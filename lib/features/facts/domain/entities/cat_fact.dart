import 'package:cat_directory_app/core/domain/data_origin.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cat_fact.freezed.dart';

@freezed
abstract class CatFact with _$CatFact {
  const factory CatFact({required String text, required DataOrigin origin}) =
      _CatFact;
}
