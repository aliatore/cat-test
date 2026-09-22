import 'package:bloc/bloc.dart';
import 'package:cat_directory_app/core/error/failure.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/usecases/breed_usecases.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'breed_detail_cubit.freezed.dart';

@freezed
sealed class BreedDetailState with _$BreedDetailState {
  const factory BreedDetailState.loading() = BreedDetailLoading;

  const factory BreedDetailState.loaded(Breed breed) = BreedDetailLoaded;

  const factory BreedDetailState.failure(Failure failure) = BreedDetailFailure;
}

/// Resuelve la raza de la ruta `/breed/:name`.
///
/// Desde la lista llega con `initial` (asi el Hero tiene destino en el primer
/// frame); desde un deep link o una notificacion llega solo el slug y se
/// busca en memoria, en cache o, en ultimo caso, en la API.
class BreedDetailCubit extends Cubit<BreedDetailState> {
  BreedDetailCubit({
    required FindBreed findBreed,
    required this.slug,
    Breed? initial,
  }) : _findBreed = findBreed,
       super(
         initial == null
             ? const BreedDetailState.loading()
             : BreedDetailState.loaded(initial),
       );

  final FindBreed _findBreed;
  final String slug;

  Future<void> load() async {
    if (state is BreedDetailLoaded) return;
    emit(const BreedDetailState.loading());
    final result = await _findBreed(slug);
    if (isClosed) return;
    emit(result.fold(BreedDetailState.loaded, BreedDetailState.failure));
  }
}
