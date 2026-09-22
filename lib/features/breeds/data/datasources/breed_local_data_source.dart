import 'dart:async';

import 'package:cat_directory_app/core/cache/json_cache.dart';
import 'package:cat_directory_app/features/breeds/data/models/breed_dto.dart';

class CachedBreedsPage {
  const CachedBreedsPage({required this.dto, required this.storedAt});

  final BreedsPageDto dto;
  final DateTime storedAt;
}

abstract interface class BreedLocalDataSource {
  CachedBreedsPage? readPage({required int page, required int pageSize});

  List<CachedBreedsPage> readAll();

  Future<void> savePage(BreedsPageDto page);

  Future<void> deletePage({required int page, required int pageSize});

  Future<void> clear();
}

class JsonBreedLocalDataSource implements BreedLocalDataSource {
  JsonBreedLocalDataSource(this._cache);

  final JsonCache _cache;

  static const _prefix = 'breeds:';

  // El tamano de pagina forma parte de la clave: si cambia entre versiones,
  // las paginas viejas no se mezclan con las nuevas.
  static String _key(int page, int pageSize) => '$_prefix$pageSize:$page';

  @override
  CachedBreedsPage? readPage({required int page, required int pageSize}) =>
      _read(_key(page, pageSize));

  @override
  List<CachedBreedsPage> readAll() => [
    for (final key in _cache.keysWithPrefix(_prefix).toList()) ?_read(key),
  ];

  @override
  Future<void> savePage(BreedsPageDto page) =>
      _cache.write(_key(page.currentPage, page.perPage), page.toJson());

  @override
  Future<void> deletePage({required int page, required int pageSize}) =>
      _cache.delete(_key(page, pageSize));

  @override
  Future<void> clear() async {
    for (final key in _cache.keysWithPrefix(_prefix).toList()) {
      await _cache.delete(key);
    }
  }

  CachedBreedsPage? _read(String key) {
    final record = _cache.read(key);
    if (record == null) return null;
    try {
      return CachedBreedsPage(
        dto: BreedsPageDto.fromJson(record.json! as Map<String, dynamic>),
        storedAt: record.storedAt,
      );
    } on Object {
      unawaited(_cache.delete(key));
      return null;
    }
  }
}
