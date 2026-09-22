import 'package:freezed_annotation/freezed_annotation.dart';

part 'breed_dto.freezed.dart';
part 'breed_dto.g.dart';

/// Forma exacta de un elemento de `GET /breeds`. Todos los campos pueden venir
/// vacios en la API real (hay 20 razas sin patron y 14 sin origen).
@freezed
abstract class BreedDto with _$BreedDto {
  const factory BreedDto({
    @Default('') String breed,
    @Default('') String country,
    @Default('') String origin,
    @Default('') String coat,
    @Default('') String pattern,
  }) = _BreedDto;

  factory BreedDto.fromJson(Map<String, dynamic> json) =>
      _$BreedDtoFromJson(json);
}

/// Respuesta paginada de Laravel que devuelve la API.
@freezed
abstract class BreedsPageDto with _$BreedsPageDto {
  const factory BreedsPageDto({
    @JsonKey(fromJson: readInt) required int currentPage,
    @JsonKey(fromJson: readInt) required int lastPage,
    @JsonKey(fromJson: readInt) required int perPage,
    @JsonKey(fromJson: readInt) required int total,
    @Default(<BreedDto>[]) List<BreedDto> data,
  }) = _BreedsPageDto;

  factory BreedsPageDto.fromJson(Map<String, dynamic> json) =>
      _$BreedsPageDtoFromJson(json);
}

/// Laravel a veces serializa los enteros de la paginacion como texto.
int readInt(Object? value) => switch (value) {
  final int v => v,
  final num v => v.toInt(),
  final String v => int.tryParse(v) ?? 0,
  _ => 0,
};
