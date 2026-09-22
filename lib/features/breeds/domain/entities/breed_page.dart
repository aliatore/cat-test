import 'package:cat_directory_app/core/domain/data_origin.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'breed_page.freezed.dart';

@freezed
abstract class BreedPage with _$BreedPage {
  const factory BreedPage({
    required List<Breed> breeds,
    required int page,
    required int lastPage,
    required int total,
    required DataOrigin origin,

    /// Cuando se obtuvo de la API (para cache, cuando se guardo).
    required DateTime updatedAt,

    /// La cache ya paso su TTL: se muestra, pero hay que revalidar.
    @Default(false) bool isStale,
  }) = _BreedPage;

  const BreedPage._();

  bool get hasMore => page < lastPage;
}
