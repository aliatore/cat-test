import 'dart:async';
import 'dart:developer' as developer;

import 'package:cat_directory_app/core/cache/cache_policy.dart';
import 'package:cat_directory_app/core/domain/data_origin.dart';
import 'package:cat_directory_app/core/error/failure.dart';
import 'package:cat_directory_app/core/error/failure_mapper.dart';
import 'package:cat_directory_app/core/error/result.dart';
import 'package:cat_directory_app/core/network/api_config.dart';
import 'package:cat_directory_app/core/network/network_info.dart';
import 'package:cat_directory_app/core/utils/clock.dart';
import 'package:cat_directory_app/core/utils/slug.dart';
import 'package:cat_directory_app/features/breeds/data/datasources/breed_local_data_source.dart';
import 'package:cat_directory_app/features/breeds/data/datasources/breed_remote_data_source.dart';
import 'package:cat_directory_app/features/breeds/data/mappers/breed_mapper.dart';
import 'package:cat_directory_app/features/breeds/data/models/breed_dto.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed_page.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breeds_cache_info.dart';
import 'package:cat_directory_app/features/breeds/domain/repositories/breed_repository.dart';

typedef _CachedPage = ({BreedPage page, CacheFreshness freshness});

class BreedRepositoryImpl implements BreedRepository {
  BreedRepositoryImpl({
    required BreedRemoteDataSource remote,
    required BreedLocalDataSource local,
    required NetworkInfo networkInfo,
    CachePolicy policy = CachePolicy.breeds,
    Clock clock = const Clock(),
    int pageSize = ApiConfig.breedsPageSize,
  }) : _remote = remote,
       _local = local,
       _networkInfo = networkInfo,
       _policy = policy,
       _clock = clock,
       _pageSize = pageSize;

  final BreedRemoteDataSource _remote;
  final BreedLocalDataSource _local;
  final NetworkInfo _networkInfo;
  final CachePolicy _policy;
  final Clock _clock;
  final int _pageSize;

  /// Indice en memoria slug -> raza con todo lo que ya paso por el
  /// repositorio. Hace que abrir un detalle no cueste una peticion.
  final _index = <String, Breed>{};

  @override
  Stream<Result<BreedPage>> watchPage(
    int page, {
    bool forceRefresh = false,
  }) async* {
    final cached = forceRefresh ? null : _readCache(page);
    if (cached != null) {
      yield Ok(cached.page);
      if (cached.freshness == CacheFreshness.fresh) return;
    }
    yield await _fetchRemote(page);
  }

  @override
  Future<Result<BreedPage>> getPage(int page) async {
    final cached = _readCache(page);
    if (cached != null && cached.freshness == CacheFreshness.fresh) {
      return Ok(cached.page);
    }
    final remote = await _fetchRemote(page);
    if (remote is Err<BreedPage> && cached != null) {
      // Mejor una pagina vieja que un hueco en la lista.
      return Ok(cached.page);
    }
    return remote;
  }

  @override
  Future<Result<Breed>> findBySlug(String slug) async {
    final key = slugify(slug);
    final known = _index[key] ?? _findInCache(key);
    if (known != null) return Ok(known);

    // No esta en memoria ni en disco: se recorre la API pagina a pagina y de
    // paso queda caliente la cache del directorio.
    var page = 1;
    var lastPage = 1;
    do {
      switch (await getPage(page)) {
        case Err(:final failure):
          return Err(failure);
        case Ok(:final value):
          lastPage = value.lastPage;
          for (final breed in value.breeds) {
            if (breed.slug == key) return Ok(breed);
          }
      }
      page++;
    } while (page <= lastPage);

    return const Err(Failure.notFound());
  }

  @override
  BreedsCacheInfo cacheInfo() {
    final now = _clock.now();
    final valid = _local
        .readAll()
        .where(
          (e) =>
              e.dto.perPage == _pageSize &&
              _policy.evaluate(e.storedAt, now) != CacheFreshness.expired,
        )
        .toList();
    if (valid.isEmpty) return BreedsCacheInfo.empty;
    return BreedsCacheInfo(
      pages: valid.length,
      breeds: valid.fold(0, (sum, e) => sum + e.dto.data.length),
      lastUpdated: valid
          .map((e) => e.storedAt)
          .reduce((a, b) => a.isAfter(b) ? a : b),
    );
  }

  @override
  Future<void> purgeExpired() async {
    final now = _clock.now();
    for (final entry in _local.readAll()) {
      final expired =
          _policy.evaluate(entry.storedAt, now) == CacheFreshness.expired;
      if (expired || entry.dto.perPage != _pageSize) {
        await _local.deletePage(
          page: entry.dto.currentPage,
          pageSize: entry.dto.perPage,
        );
      }
    }
  }

  @override
  Future<void> clearCache() async {
    _index.clear();
    await _local.clear();
  }

  _CachedPage? _readCache(int page) {
    final entry = _local.readPage(page: page, pageSize: _pageSize);
    if (entry == null) return null;

    final freshness = _policy.evaluate(entry.storedAt, _clock.now());
    if (freshness == CacheFreshness.expired) {
      unawaited(_local.deletePage(page: page, pageSize: _pageSize));
      return null;
    }

    final breedPage = entry.dto.toEntity(
      origin: DataOrigin.cache,
      updatedAt: entry.storedAt,
      isStale: freshness == CacheFreshness.stale,
    );
    _remember(breedPage.breeds);
    return (page: breedPage, freshness: freshness);
  }

  Breed? _findInCache(String slug) {
    final now = _clock.now();
    for (final entry in _local.readAll()) {
      if (_policy.evaluate(entry.storedAt, now) == CacheFreshness.expired) {
        continue;
      }
      for (final dto in entry.dto.data) {
        final breed = dto.toEntity();
        _index[breed.slug] = breed;
      }
    }
    return _index[slug];
  }

  Future<Result<BreedPage>> _fetchRemote(int page) async {
    if (!await _networkInfo.isConnected) {
      return const Err(Failure.connection());
    }
    try {
      final dto = await _remote.fetchPage(page: page, limit: _pageSize);
      await _saveQuietly(dto);
      final breedPage = dto.toEntity(
        origin: DataOrigin.remote,
        updatedAt: _clock.now(),
      );
      _remember(breedPage.breeds);
      return Ok(breedPage);
    } on Object catch (error) {
      return Err(mapErrorToFailure(error));
    }
  }

  /// Que falle el disco no debe tumbar una respuesta que llego bien.
  Future<void> _saveQuietly(BreedsPageDto dto) async {
    try {
      await _local.savePage(dto);
    } on Object catch (error) {
      developer.log(
        'no se pudo cachear la pagina',
        error: error,
        name: 'cache',
      );
    }
  }

  void _remember(List<Breed> breeds) {
    for (final breed in breeds) {
      _index[breed.slug] = breed;
    }
  }
}
