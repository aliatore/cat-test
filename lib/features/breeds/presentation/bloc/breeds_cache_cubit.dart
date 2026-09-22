import 'package:bloc/bloc.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breeds_cache_info.dart';
import 'package:cat_directory_app/features/breeds/domain/usecases/breed_usecases.dart';

/// Resumen de la cache del directorio para la pantalla de ajustes.
class BreedsCacheCubit extends Cubit<BreedsCacheInfo> {
  BreedsCacheCubit({
    required GetBreedsCacheInfo getInfo,
    required ClearBreedsCache clear,
  }) : _getInfo = getInfo,
       _clear = clear,
       super(getInfo());

  final GetBreedsCacheInfo _getInfo;
  final ClearBreedsCache _clear;

  void refresh() => emit(_getInfo());

  Future<void> clear() async {
    await _clear();
    emit(_getInfo());
  }
}
