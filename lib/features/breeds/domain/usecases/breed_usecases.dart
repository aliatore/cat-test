import 'package:cat_directory_app/core/error/result.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed_page.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breeds_cache_info.dart';
import 'package:cat_directory_app/features/breeds/domain/repositories/breed_repository.dart';

class WatchBreedsPage {
  const WatchBreedsPage(this._repository);

  final BreedRepository _repository;

  Stream<Result<BreedPage>> call(int page, {bool forceRefresh = false}) =>
      _repository.watchPage(page, forceRefresh: forceRefresh);
}

class GetBreedsPage {
  const GetBreedsPage(this._repository);

  final BreedRepository _repository;

  Future<Result<BreedPage>> call(int page) => _repository.getPage(page);
}

class FindBreed {
  const FindBreed(this._repository);

  final BreedRepository _repository;

  Future<Result<Breed>> call(String slug) => _repository.findBySlug(slug);
}

class GetBreedsCacheInfo {
  const GetBreedsCacheInfo(this._repository);

  final BreedRepository _repository;

  BreedsCacheInfo call() => _repository.cacheInfo();
}

class ClearBreedsCache {
  const ClearBreedsCache(this._repository);

  final BreedRepository _repository;

  Future<void> call() => _repository.clearCache();
}
