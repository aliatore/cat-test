import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cat_directory_app/core/error/failure.dart';
import 'package:cat_directory_app/features/facts/domain/entities/cat_fact.dart';
import 'package:cat_directory_app/features/facts/domain/usecases/get_random_fact.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cat_fact_bloc.freezed.dart';

final class CatFactRequested {
  const CatFactRequested();
}

@freezed
sealed class CatFactState with _$CatFactState {
  const factory CatFactState.loading() = CatFactLoading;

  const factory CatFactState.loaded(CatFact fact) = CatFactLoaded;

  const factory CatFactState.failure(Failure failure) = CatFactFailure;
}

/// Estado propio del dato curioso: carga, falla y se reintenta sin tocar el
/// resto de la pantalla de detalle.
class CatFactBloc extends Bloc<CatFactRequested, CatFactState> {
  CatFactBloc({required GetRandomFact getRandomFact})
    : _getRandomFact = getRandomFact,
      super(const CatFactState.loading()) {
    // Tocar "otro dato" cinco veces seguidas no dispara cinco peticiones.
    on<CatFactRequested>(_onRequested, transformer: droppable());
  }

  final GetRandomFact _getRandomFact;

  Future<void> _onRequested(
    CatFactRequested event,
    Emitter<CatFactState> emit,
  ) async {
    emit(const CatFactState.loading());
    final result = await _getRandomFact();
    emit(result.fold(CatFactState.loaded, CatFactState.failure));
  }
}
