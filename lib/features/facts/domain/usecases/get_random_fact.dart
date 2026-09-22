import 'package:cat_directory_app/core/error/result.dart';
import 'package:cat_directory_app/features/facts/domain/entities/cat_fact.dart';
import 'package:cat_directory_app/features/facts/domain/repositories/cat_fact_repository.dart';

class GetRandomFact {
  const GetRandomFact(this._repository);

  final CatFactRepository _repository;

  Future<Result<CatFact>> call() => _repository.getRandomFact();
}
