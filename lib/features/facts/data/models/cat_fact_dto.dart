import 'package:freezed_annotation/freezed_annotation.dart';

part 'cat_fact_dto.freezed.dart';
part 'cat_fact_dto.g.dart';

@freezed
abstract class CatFactDto with _$CatFactDto {
  const factory CatFactDto({@Default('') String fact, @Default(0) int length}) =
      _CatFactDto;

  factory CatFactDto.fromJson(Map<String, dynamic> json) =>
      _$CatFactDtoFromJson(json);
}
