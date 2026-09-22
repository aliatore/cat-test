part of 'breeds_bloc.dart';

enum BreedsStatus { initial, loading, success, failure }

enum BreedsNoticeKind { showingCache, refreshFailed, refreshed, backOnline }

/// Mensaje de una sola vez (snackbar). El [id] cambia en cada aviso para
/// que el listener no dependa de la igualdad del contenido.
@freezed
abstract class BreedsNotice with _$BreedsNotice {
  const factory BreedsNotice({
    required int id,
    required BreedsNoticeKind kind,
    Failure? failure,
  }) = _BreedsNotice;
}

@freezed
abstract class BreedsState with _$BreedsState {
  const factory BreedsState({
    @Default(BreedsStatus.initial) BreedsStatus status,

    /// Paginas cargadas por numero. Es la fuente de verdad: permite
    /// reemplazar solo la pagina 1 al revalidar sin perder el resto.
    @Default(<int, List<Breed>>{}) Map<int, List<Breed>> pages,

    /// Todas las razas cargadas, en orden y sin duplicados.
    @Default(<Breed>[]) List<Breed> breeds,

    /// Las que pasan el filtro de busqueda (o todas si no hay busqueda).
    @Default(<Breed>[]) List<Breed> visible,
    @Default('') String query,
    @Default(0) int lastPage,
    @Default(0) int total,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isRefreshing,

    /// Fallo que deja la pantalla sin datos.
    Failure? failure,

    /// Fallo de la ultima pagina pedida: la lista ya cargada se conserva.
    Failure? paginationFailure,
    DataOrigin? origin,
    @Default(false) bool isStale,
    DateTime? updatedAt,
    BreedsNotice? notice,
  }) = _BreedsState;

  const BreedsState._();

  int get currentPage => pages.isEmpty ? 0 : pages.keys.reduce(max);

  bool get hasReachedMax => lastPage > 0 && currentPage >= lastPage;

  bool get hasData => breeds.isNotEmpty;

  bool get isSearching => query.isNotEmpty;
}
