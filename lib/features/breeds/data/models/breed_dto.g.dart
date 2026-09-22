// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breed_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BreedDto _$BreedDtoFromJson(Map<String, dynamic> json) => _BreedDto(
  breed: json['breed'] as String? ?? '',
  country: json['country'] as String? ?? '',
  origin: json['origin'] as String? ?? '',
  coat: json['coat'] as String? ?? '',
  pattern: json['pattern'] as String? ?? '',
);

Map<String, dynamic> _$BreedDtoToJson(_BreedDto instance) => <String, dynamic>{
  'breed': instance.breed,
  'country': instance.country,
  'origin': instance.origin,
  'coat': instance.coat,
  'pattern': instance.pattern,
};

_BreedsPageDto _$BreedsPageDtoFromJson(Map<String, dynamic> json) =>
    _BreedsPageDto(
      currentPage: readInt(json['current_page']),
      lastPage: readInt(json['last_page']),
      perPage: readInt(json['per_page']),
      total: readInt(json['total']),
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => BreedDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <BreedDto>[],
    );

Map<String, dynamic> _$BreedsPageDtoToJson(_BreedsPageDto instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };
