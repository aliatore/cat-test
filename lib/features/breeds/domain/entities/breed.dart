import 'package:cat_directory_app/core/utils/slug.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'breed.freezed.dart';

@freezed
abstract class Breed with _$Breed {
  const factory Breed({
    required String name,
    String? country,
    String? origin,
    String? coat,
    String? pattern,
  }) = _Breed;

  const Breed._();

  /// Identificador estable para la ruta `/breed/:name`.
  String get slug => slugify(name);
}
