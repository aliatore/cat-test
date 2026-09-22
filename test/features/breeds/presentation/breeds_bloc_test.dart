import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cat_directory_app/core/domain/data_origin.dart';
import 'package:cat_directory_app/core/error/failure.dart';
import 'package:cat_directory_app/core/error/result.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed_page.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breeds_cache_info.dart';
import 'package:cat_directory_app/features/breeds/domain/repositories/breed_repository.dart';
import 'package:cat_directory_app/features/breeds/domain/usecases/breed_usecases.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

/// Repositorio guionizado: cada prueba decide que responde cada pagina.
class _ScriptedRepository implements BreedRepository {
  final watch = <int, List<Result<BreedPage>>>{};
  final refresh = <Result<BreedPage>>[];
  final pages = <int, Future<Result<BreedPage>> Function()>{};
  final getPageCalls = <int>[];

  @override
  Stream<Result<BreedPage>> watchPage(int page, {bool forceRefresh = false}) {
    if (forceRefresh) return Stream.value(refresh.removeAt(0));
    return Stream.fromIterable(watch[page] ?? const []);
  }

  @override
  Future<Result<BreedPage>> getPage(int page) {
    getPageCalls.add(page);
    return pages[page]!();
  }

  @override
  Future<Result<Breed>> findBySlug(String slug) => throw UnimplementedError();

  @override
  BreedsCacheInfo cacheInfo() => BreedsCacheInfo.empty;

  @override
  Future<void> purgeExpired() async {}

  @override
  Future<void> clearCache() async {}
}

BreedPage _page(
  int number, {
  DataOrigin origin = DataOrigin.remote,
  int lastPage = 3,
  List<String>? names,
}) => BreedPage(
  breeds: [
    for (final name in names ?? ['Breed $number-A', 'Breed $number-B'])
      Breed(name: name, country: 'Egypt'),
  ],
  page: number,
  lastPage: lastPage,
  total: lastPage * 2,
  origin: origin,
  updatedAt: DateTime(2026, 9, 22),
);

void main() {
  late _ScriptedRepository repository;
  late FakeNetworkInfo network;

  setUp(() {
    repository = _ScriptedRepository();
    network = FakeNetworkInfo();
  });

  BreedsBloc buildBloc() => BreedsBloc(
    watchPage: WatchBreedsPage(repository),
    getPage: GetBreedsPage(repository),
    networkInfo: network,
  );

  /// Bloc ya cargado con la pagina 1 de red.
  Future<BreedsBloc> loadedBloc() async {
    repository.watch[1] = [Ok(_page(1))];
    final bloc = buildBloc()..add(const BreedsStarted());
    await bloc.stream.firstWhere((s) => s.status == BreedsStatus.success);
    return bloc;
  }

  group('arranque offline-first', () {
    blocTest<BreedsBloc, BreedsState>(
      'muestra la cache al instante y despues la version de red',
      build: buildBloc,
      setUp: () => repository.watch[1] = [
        Ok(_page(1, origin: DataOrigin.cache)),
        Ok(_page(1, names: ['Abyssinian', 'Aegean'])),
      ],
      act: (bloc) => bloc.add(const BreedsStarted()),
      expect: () => [
        isA<BreedsState>().having(
          (s) => s.status,
          'status',
          BreedsStatus.loading,
        ),
        isA<BreedsState>()
            .having((s) => s.origin, 'origin', DataOrigin.cache)
            .having((s) => s.breeds.length, 'breeds', 2),
        isA<BreedsState>()
            .having((s) => s.origin, 'origin', DataOrigin.remote)
            .having((s) => s.breeds.first.name, 'first', 'Abyssinian'),
      ],
    );

    blocTest<BreedsBloc, BreedsState>(
      'con cache y la red caida conserva los datos y solo avisa',
      build: buildBloc,
      setUp: () => repository.watch[1] = [
        Ok(_page(1, origin: DataOrigin.cache)),
        const Err(Failure.connection()),
      ],
      act: (bloc) => bloc.add(const BreedsStarted()),
      skip: 2,
      expect: () => [
        isA<BreedsState>()
            .having((s) => s.status, 'status', BreedsStatus.success)
            .having((s) => s.breeds.length, 'breeds', 2)
            .having(
              (s) => s.notice?.kind,
              'notice',
              BreedsNoticeKind.showingCache,
            ),
      ],
    );

    blocTest<BreedsBloc, BreedsState>(
      'sin cache y sin red queda en error para ofrecer reintento',
      build: buildBloc,
      setUp: () => repository.watch[1] = [const Err(Failure.connection())],
      act: (bloc) => bloc.add(const BreedsStarted()),
      expect: () => [
        isA<BreedsState>().having(
          (s) => s.status,
          'status',
          BreedsStatus.loading,
        ),
        isA<BreedsState>()
            .having((s) => s.status, 'status', BreedsStatus.failure)
            .having((s) => s.failure, 'failure', const Failure.connection()),
      ],
    );
  });

  group('scroll infinito', () {
    test('agrega la pagina siguiente a la lista', () async {
      repository.pages[2] = () async => Ok(_page(2));
      final bloc = await loadedBloc();

      bloc.add(const BreedsNextPageRequested());
      final state = await bloc.stream.firstWhere((s) => !s.isLoadingMore);

      expect(state.breeds.map((b) => b.name), [
        'Breed 1-A',
        'Breed 1-B',
        'Breed 2-A',
        'Breed 2-B',
      ]);
      expect(state.currentPage, 2);
      await bloc.close();
    });

    test('no dispara mas de una peticion si ya hay una en curso', () async {
      final pending = Completer<Result<BreedPage>>();
      repository.pages[2] = () => pending.future;
      final bloc = await loadedBloc();

      bloc
        ..add(const BreedsNextPageRequested())
        ..add(const BreedsNextPageRequested())
        ..add(const BreedsNextPageRequested());
      await pumpEventQueue();
      pending.complete(Ok(_page(2)));
      await bloc.stream.firstWhere((s) => !s.isLoadingMore);

      expect(repository.getPageCalls, [2]);
      await bloc.close();
    });

    test('si falla una pagina intermedia la lista no se borra', () async {
      repository.pages[2] = () async => const Err(Failure.timeout());
      final bloc = await loadedBloc();

      bloc.add(const BreedsNextPageRequested());
      final state = await bloc.stream.firstWhere((s) => !s.isLoadingMore);

      expect(state.breeds, hasLength(2));
      expect(state.status, BreedsStatus.success);
      expect(state.paginationFailure, const Failure.timeout());
      await bloc.close();
    });

    test('no pide nada mas al llegar a la ultima pagina', () async {
      repository.watch[1] = [Ok(_page(1, lastPage: 1))];
      final bloc = buildBloc()..add(const BreedsStarted());
      await bloc.stream.firstWhere((s) => s.status == BreedsStatus.success);

      bloc.add(const BreedsNextPageRequested());
      await pumpEventQueue();

      expect(bloc.state.hasReachedMax, isTrue);
      expect(repository.getPageCalls, isEmpty);
      await bloc.close();
    });
  });

  group('pull to refresh', () {
    test('una pagina que llega despues del refresh se descarta', () async {
      final slowPage = Completer<Result<BreedPage>>();
      repository.pages[2] = () => slowPage.future;
      repository.refresh.add(Ok(_page(1, names: ['Fresh A', 'Fresh B'])));
      final bloc = await loadedBloc();

      bloc.add(const BreedsNextPageRequested());
      await pumpEventQueue();
      bloc.add(const BreedsRefreshRequested());
      await bloc.stream.firstWhere((s) => !s.isRefreshing);
      slowPage.complete(Ok(_page(2)));
      await pumpEventQueue();

      expect(bloc.state.breeds.map((b) => b.name), ['Fresh A', 'Fresh B']);
      expect(bloc.state.currentPage, 1);
      await bloc.close();
    });

    test('si el refresh falla, la lista sigue y se avisa', () async {
      repository.refresh.add(const Err(Failure.connection()));
      final bloc = await loadedBloc();

      bloc.add(const BreedsRefreshRequested());
      final state = await bloc.stream.firstWhere((s) => !s.isRefreshing);

      expect(state.breeds, hasLength(2));
      expect(state.notice?.kind, BreedsNoticeKind.refreshFailed);
      await bloc.close();
    });
  });

  group('busqueda local', () {
    blocTest<BreedsBloc, BreedsState>(
      'aplica debounce y filtra por nombre sin importar acentos',
      build: buildBloc,
      seed: () => const BreedsState(
        status: BreedsStatus.success,
        breeds: [
          Breed(name: 'Abyssinian'),
          Breed(name: 'PerFoldæ (Experimental Breed - WCF)'),
          Breed(name: 'Persian (Modern Persian Cat)'),
        ],
      ),
      act: (bloc) => bloc
        ..add(const BreedsQueryChanged('p'))
        ..add(const BreedsQueryChanged('pe'))
        ..add(const BreedsQueryChanged('perfoldae')),
      wait: searchDebounce + const Duration(milliseconds: 50),
      expect: () => [
        isA<BreedsState>().having((s) => s.query, 'query', 'perfoldae').having(
          (s) => s.visible.map((b) => b.name),
          'visible',
          ['PerFoldæ (Experimental Breed - WCF)'],
        ),
      ],
    );
  });

  test('al volver la conexion reintenta la pagina que habia fallado', () async {
    var attempts = 0;
    repository.pages[2] = () async => ++attempts == 1
        ? const Err<BreedPage>(Failure.connection())
        : Ok(_page(2));
    network.online = false;
    final bloc = await loadedBloc();

    bloc.add(const BreedsNextPageRequested());
    await bloc.stream.firstWhere((s) => s.paginationFailure != null);
    network.emit(online: true);
    final state = await bloc.stream.firstWhere((s) => s.currentPage == 2);

    expect(state.paginationFailure, isNull);
    expect(repository.getPageCalls, [2, 2]);
    await bloc.close();
  });
}
