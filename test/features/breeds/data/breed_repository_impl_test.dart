import 'package:cat_directory_app/core/cache/json_cache.dart';
import 'package:cat_directory_app/core/cache/key_value_store.dart';
import 'package:cat_directory_app/core/domain/data_origin.dart';
import 'package:cat_directory_app/core/error/failure.dart';
import 'package:cat_directory_app/core/error/result.dart';
import 'package:cat_directory_app/features/breeds/data/datasources/breed_local_data_source.dart';
import 'package:cat_directory_app/features/breeds/data/datasources/breed_remote_data_source.dart';
import 'package:cat_directory_app/features/breeds/data/repositories/breed_repository_impl.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes.dart';

class _MockRemote extends Mock implements BreedRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late JsonBreedLocalDataSource local;
  late FakeNetworkInfo network;
  late FakeClock clock;
  late BreedRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    clock = FakeClock(DateTime(2026, 9, 22, 12));
    network = FakeNetworkInfo();
    local = JsonBreedLocalDataSource(
      JsonCache(InMemoryKeyValueStore(), schemaVersion: 1, clock: clock),
    );
    repository = BreedRepositoryImpl(
      remote: remote,
      local: local,
      networkInfo: network,
      // politica por defecto: 5 minutos fresca, 7 dias como maximo
      clock: clock,
      pageSize: 2,
    );
  });

  void remoteReturns(int page, {int lastPage = 3, List<String>? names}) {
    when(() => remote.fetchPage(page: page, limit: 2)).thenAnswer(
      (_) async => breedsPageDto(page, lastPage: lastPage, names: names),
    );
  }

  void remoteFails(int page, [DioExceptionType? type]) {
    when(() => remote.fetchPage(page: page, limit: 2)).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/breeds'),
        type: type ?? DioExceptionType.connectionError,
      ),
    );
  }

  Future<void> seedCache(int page, {required Duration age}) async {
    final writtenAt = clock.current;
    clock.current = writtenAt.subtract(age);
    await local.savePage(breedsPageDto(page));
    clock.current = writtenAt;
  }

  group('watchPage (stale-while-revalidate)', () {
    test('sin cache emite la respuesta de red y la guarda', () async {
      remoteReturns(1);

      final events = await repository.watchPage(1).toList();

      expect(events, hasLength(1));
      expect(events.single.valueOrNull?.origin, DataOrigin.remote);
      expect(local.readPage(page: 1, pageSize: 2), isNotNull);
    });

    test('con cache fresca la emite y no toca la red', () async {
      await seedCache(1, age: const Duration(minutes: 1));

      final events = await repository.watchPage(1).toList();

      expect(events.single.valueOrNull?.origin, DataOrigin.cache);
      expect(events.single.valueOrNull?.isStale, isFalse);
      verifyNever(
        () => remote.fetchPage(page: any(named: 'page'), limit: 2),
      );
    });

    test('con cache vieja emite la cache y despues la red', () async {
      await seedCache(1, age: const Duration(hours: 2));
      remoteReturns(1);

      final events = await repository.watchPage(1).toList();

      expect(events.map((e) => e.valueOrNull?.origin), [
        DataOrigin.cache,
        DataOrigin.remote,
      ]);
      expect(events.first.valueOrNull?.isStale, isTrue);
    });

    test(
      'con cache vieja y la red caida: cache primero, luego el fallo',
      () async {
        await seedCache(1, age: const Duration(hours: 2));
        remoteFails(1);

        final events = await repository.watchPage(1).toList();

        expect(events.first, isA<Ok<BreedPage>>());
        expect(events.last, const Err<BreedPage>(Failure.connection()));
      },
    );

    test('sin red y sin cache falla sin intentar la peticion', () async {
      network.online = false;

      final events = await repository.watchPage(1).toList();

      expect(events.single, const Err<BreedPage>(Failure.connection()));
      verifyNever(
        () => remote.fetchPage(page: any(named: 'page'), limit: 2),
      );
    });

    test('una cache expirada se invalida y no se muestra', () async {
      await seedCache(1, age: const Duration(days: 8));
      network.online = false;

      final events = await repository.watchPage(1).toList();

      expect(events.single, isA<Err<BreedPage>>());
      await pumpEventQueue();
      expect(local.readPage(page: 1, pageSize: 2), isNull);
    });

    test('forceRefresh (pull to refresh) ignora la cache fresca', () async {
      await seedCache(1, age: Duration.zero);
      remoteReturns(1);

      final events = await repository.watchPage(1, forceRefresh: true).toList();

      expect(events.single.valueOrNull?.origin, DataOrigin.remote);
    });
  });

  group('getPage', () {
    test('si la red falla devuelve la cache aunque este vieja', () async {
      await seedCache(2, age: const Duration(days: 1));
      remoteFails(2, DioExceptionType.receiveTimeout);

      final result = await repository.getPage(2);

      expect(result.valueOrNull?.origin, DataOrigin.cache);
      expect(result.valueOrNull?.isStale, isTrue);
    });

    test('un JSON con otra forma se reporta como ParsingFailure', () async {
      when(
        () => remote.fetchPage(page: 1, limit: 2),
      ).thenThrow(const FormatException('boom'));

      expect(
        await repository.getPage(1),
        const Err<BreedPage>(Failure.parsing()),
      );
    });

    test('un 503 se reporta como fallo del servidor', () async {
      final options = RequestOptions(path: '/breeds');
      when(() => remote.fetchPage(page: 1, limit: 2)).thenThrow(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: options, statusCode: 503),
        ),
      );

      expect(
        await repository.getPage(1),
        const Err<BreedPage>(Failure.server(statusCode: 503)),
      );
    });
  });

  group('findBySlug', () {
    test('resuelve desde la cache aunque no haya red', () async {
      await seedCache(2, age: const Duration(days: 2));
      network.online = false;

      final result = await repository.findBySlug('breed-2-b');

      expect(result.valueOrNull?.name, 'Breed 2-B');
    });

    test('recorre la API pagina a pagina hasta encontrarla', () async {
      remoteReturns(1);
      remoteReturns(2, names: ['Sokoke', 'Foldex[4]']);

      final result = await repository.findBySlug('foldex');

      expect(result.valueOrNull?.name, 'Foldex');
      verifyNever(() => remote.fetchPage(page: 3, limit: 2));
    });

    test('acepta el nombre tal cual llega en la URL', () async {
      remoteReturns(1, names: ['American Curl', 'Aegean']);

      final result = await repository.findBySlug('American Curl');

      expect(result.valueOrNull?.slug, 'american-curl');
    });

    test('devuelve notFound si no existe en ninguna pagina', () async {
      [1, 2, 3].forEach(remoteReturns);

      expect(
        await repository.findBySlug('gato-inexistente'),
        const Err<Breed>(Failure.notFound()),
      );
    });
  });

  test('purgeExpired elimina solo lo que expiro', () async {
    await seedCache(1, age: const Duration(days: 1));
    await seedCache(2, age: const Duration(days: 9));

    await repository.purgeExpired();

    expect(local.readPage(page: 1, pageSize: 2), isNotNull);
    expect(local.readPage(page: 2, pageSize: 2), isNull);
    expect(repository.cacheInfo().pages, 1);
  });
}
