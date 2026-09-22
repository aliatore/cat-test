// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat_fact_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CatFactDto _$CatFactDtoFromJson(Map<String, dynamic> json) => _CatFactDto(
  fact: json['fact'] as String? ?? '',
  length: (json['length'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CatFactDtoToJson(_CatFactDto instance) =>
    <String, dynamic>{'fact': instance.fact, 'length': instance.length};
