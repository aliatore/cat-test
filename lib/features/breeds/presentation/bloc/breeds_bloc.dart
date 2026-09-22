import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cat_directory_app/core/domain/data_origin.dart';
import 'package:cat_directory_app/core/error/failure.dart';
import 'package:cat_directory_app/core/error/result.dart';
import 'package:cat_directory_app/core/network/network_info.dart';
import 'package:cat_directory_app/core/utils/slug.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed_page.dart';
import 'package:cat_directory_app/features/breeds/domain/usecases/breed_usecases.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'breeds_bloc.freezed.dart';
part 'breeds_event.dart';
part 'breeds_state.dart';

const searchDebounce = Duration(milliseconds: 300);

/// Debounce + restartable: espera a que el usuario deje de escribir y, si
/// llega un valor nuevo mientras se procesa el anterior, gana el nuevo.
EventTransformer<E> debounceRestartable<E>(Duration duration) =>
    (events, mapper) =>
        restartable<E>().call(events.debounce(duration), mapper);

class BreedsBloc extends Bloc<BreedsEvent, BreedsState> {
  BreedsBloc({
    required WatchBreedsPage watchPage,
    required GetBreedsPage getPage,
    required NetworkInfo networkInfo,
  }) : _watchPage = watchPage,
       _getPage = getPage,
       super(const BreedsState()) {
    on<BreedsStarted>(_onStarted, transformer: droppable());
    on<BreedsNextPageRequested>(_onNextPage, transformer: droppable());
    on<BreedsRefreshRequested>(_onRefresh, transformer: droppable());
    on<BreedsRetryRequested>(_onRetry, transformer: droppable());
    on<BreedsRevalidateRequested>(_onRevalidate, transformer: droppable());
    on<BreedsQueryChanged>(
      _onQueryChanged,
      transformer: debounceRestartable(searchDebounce),
    );
    on<_ConnectivityChanged>(_onConnectivityChanged);

    _connectivity = networkInfo.onStatusChange.listen(
      (online) => add(_ConnectivityChanged(online: online)),
    );
    unawaited(networkInfo.isConnected.then((online) => _online ??= online));
  }

  final WatchBreedsPage _watchPage;
  final GetBreedsPage _getPage;
  late final StreamSubscription<bool> _connectivity;

  bool? _online;
  var _noticeSeq = 0;

  /// Se incrementa en cada refresh. Una pagina que llega con un epoch viejo
  /// pertenece a una lista que ya no existe y se descarta: asi un scroll
  /// infinito lento no puede pegar la pagina 5 de antes encima de la pagina
  /// 1 recien recargada.
  var _epoch = 0;

  Future<void> _onStarted(BreedsStarted event, Emitter<BreedsState> emit) {
    if (!state.hasData) {
      emit(state.copyWith(status: BreedsStatus.loading, failure: null));
    }
    return _loadFirstPage(emit);
  }

  Future<void> _onNextPage(
    BreedsNextPageRequested event,
    Emitter<BreedsState> emit,
  ) async {
    if (state.status != BreedsStatus.success ||
        state.isLoadingMore ||
        state.isRefreshing ||
        state.hasReachedMax) {
      return;
    }
    final epoch = _epoch;
    final next = state.currentPage + 1;
    emit(state.copyWith(isLoadingMore: true, paginationFailure: null));

    final result = await _getPage(next);
    if (epoch != _epoch) return;

    emit(switch (result) {
      Ok(:final value) => _withPage(value).copyWith(isLoadingMore: false),
      Err(:final failure) => state.copyWith(
        isLoadingMore: false,
        paginationFailure: failure,
      ),
    });
  }

  Future<void> _onRefresh(
    BreedsRefreshRequested event,
    Emitter<BreedsState> emit,
  ) async {
    _epoch++;
    emit(
      state.copyWith(
        isRefreshing: true,
        isLoadingMore: false,
        paginationFailure: null,
      ),
    );

    final result = await _watchPage(1, forceRefresh: true).last;

    emit(switch (result) {
      Ok(:final value) => _replacedBy(value).copyWith(
        isRefreshing: false,
        notice: _notice(BreedsNoticeKind.refreshed),
      ),
      Err(:final failure) when state.hasData => state.copyWith(
        isRefreshing: false,
        notice: _notice(BreedsNoticeKind.refreshFailed, failure),
      ),
      Err(:final failure) => state.copyWith(
        isRefreshing: false,
        status: BreedsStatus.failure,
        failure: failure,
      ),
    });
  }

  Future<void> _onRetry(
    BreedsRetryRequested event,
    Emitter<BreedsState> emit,
  ) async {
    if (!state.hasData) {
      emit(state.copyWith(status: BreedsStatus.loading, failure: null));
      await _loadFirstPage(emit);
    } else if (state.paginationFailure != null) {
      add(const BreedsNextPageRequested());
    }
  }

  Future<void> _onRevalidate(
    BreedsRevalidateRequested event,
    Emitter<BreedsState> emit,
  ) async {
    if (state.status == BreedsStatus.loading || state.isRefreshing) return;
    if (!state.hasData) {
      add(const BreedsRetryRequested());
      return;
    }
    // Si la pagina 1 en cache sigue fresca, el repositorio ni toca la red.
    await _loadFirstPage(emit, silent: true);
  }

  void _onQueryChanged(BreedsQueryChanged event, Emitter<BreedsState> emit) {
    final query = event.query.trim();
    if (query == state.query) return;
    emit(state.copyWith(query: query, visible: _filter(state.breeds, query)));
  }

  void _onConnectivityChanged(
    _ConnectivityChanged event,
    Emitter<BreedsState> emit,
  ) {
    final cameBack = _online == false && event.online;
    _online = event.online;
    if (!cameBack) return;

    emit(state.copyWith(notice: _notice(BreedsNoticeKind.backOnline)));
    if (!state.hasData) {
      add(const BreedsRetryRequested());
    } else if (state.paginationFailure != null) {
      add(const BreedsNextPageRequested());
    } else if (state.origin == DataOrigin.cache) {
      add(const BreedsRevalidateRequested());
    }
  }

  Future<void> _loadFirstPage(
    Emitter<BreedsState> emit, {
    bool silent = false,
  }) => emit.forEach<Result<BreedPage>>(
    _watchPage(1),
    onData: (result) => switch (result) {
      Ok(:final value) => _withPage(value).copyWith(
        origin: value.origin,
        isStale: value.isStale,
        updatedAt: value.updatedAt,
      ),
      // Ya hay datos (de la cache): el fallo de red es un aviso, no un error.
      Err(:final failure) when state.hasData =>
        silent
            ? state
            : state.copyWith(
                notice: _notice(BreedsNoticeKind.showingCache, failure),
              ),
      Err(:final failure) => state.copyWith(
        status: BreedsStatus.failure,
        failure: failure,
      ),
    },
  );

  BreedsState _withPage(BreedPage page) =>
      _withPages({...state.pages, page.page: page.breeds}, page);

  BreedsState _replacedBy(BreedPage page) =>
      _withPages({
        page.page: page.breeds,
      }, page).copyWith(
        origin: page.origin,
        isStale: page.isStale,
        updatedAt: page.updatedAt,
      );

  BreedsState _withPages(Map<int, List<Breed>> pages, BreedPage page) {
    final breeds = _flatten(pages);
    return state.copyWith(
      status: BreedsStatus.success,
      pages: pages,
      breeds: breeds,
      visible: _filter(breeds, state.query),
      lastPage: page.lastPage,
      total: page.total,
      failure: null,
    );
  }

  BreedsNotice _notice(BreedsNoticeKind kind, [Failure? failure]) =>
      BreedsNotice(id: ++_noticeSeq, kind: kind, failure: failure);

  static List<Breed> _flatten(Map<int, List<Breed>> pages) {
    final seen = <String>{};
    final numbers = pages.keys.toList()..sort();
    return [
      for (final number in numbers)
        for (final breed in pages[number]!)
          if (seen.add(breed.slug)) breed,
    ];
  }

  /// Busqueda local sobre lo cargado, sin acentos ni mayusculas:
  /// "perfoldae" encuentra "PerFoldæ".
  static List<Breed> _filter(List<Breed> breeds, String query) {
    final needle = searchKey(query);
    if (needle.isEmpty) return breeds;
    return [
      for (final breed in breeds)
        if (searchKey(breed.name).contains(needle)) breed,
    ];
  }

  static String searchKey(String value) => slugify(value).replaceAll('-', ' ');

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    return super.close();
  }
}
