import 'package:cat_directory_app/core/error/result.dart';
import 'package:cat_directory_app/features/facts/domain/entities/cat_fact.dart';

abstract interface class CatFactRepository {
  /// Un dato curioso aleatorio. Sin red devuelve uno de los ya vistos, y solo
  /// falla si nunca se descargo ninguno.
  Future<Result<CatFact>> getRandomFact();
}
