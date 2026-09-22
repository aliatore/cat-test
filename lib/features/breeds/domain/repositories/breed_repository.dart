import 'package:cat_directory_app/core/error/result.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed_page.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breeds_cache_info.dart';

abstract interface class BreedRepository {
  /// Stale-while-revalidate: emite primero lo que haya en cache (si no
  /// expiro) y despues, si la cache no estaba fresca, el resultado de la red.
  ///
  /// Si la cache se emitio y la red falla, el segundo evento es un [Err]:
  /// quien escucha decide si eso bloquea la pantalla o es solo un aviso.
  Stream<Result<BreedPage>> watchPage(int page, {bool forceRefresh = false});

  /// Pagina suelta para el scroll infinito: cache fresca, si no la red, y si
  /// la red falla la cache aunque este vieja.
  Future<Result<BreedPage>> getPage(int page);

  /// Resuelve una raza por su slug; lo usan los deep links y las
  /// notificaciones, que pueden llegar sin la lista cargada.
  Future<Result<Breed>> findBySlug(String slug);

  /// Razas disponibles sin red (cache no expirada), en orden del directorio.
  List<Breed> cachedBreeds();

  BreedsCacheInfo cacheInfo();

  Future<void> purgeExpired();

  Future<void> clearCache();
}
