import 'package:cat_directory_app/core/domain/data_origin.dart';
import 'package:cat_directory_app/features/breeds/data/models/breed_dto.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed_page.dart';

extension BreedDtoMapper on BreedDto {
  Breed toEntity() => Breed(
    name: cleanBreedName(breed),
    country: _nullIfBlank(country),
    origin: _nullIfBlank(origin),
    coat: _nullIfBlank(coat),
    pattern: _nullIfBlank(pattern),
  );
}

extension BreedsPageDtoMapper on BreedsPageDto {
  BreedPage toEntity({
    required DataOrigin origin,
    required DateTime updatedAt,
    bool isStale = false,
  }) => BreedPage(
    breeds: [
      for (final dto in data)
        if (dto.breed.trim().isNotEmpty) dto.toEntity(),
    ],
    page: currentPage,
    lastPage: lastPage,
    total: total,
    origin: origin,
    updatedAt: updatedAt,
    isStale: isStale,
  );
}

final _footnote = RegExp(r'\[\d+\]');
final _parenWithoutSpace = RegExp(r'(\S)\(');
final _whitespace = RegExp(r'\s+');

/// Los nombres vienen copiados de Wikipedia: `Foldex[4]` o
/// `PerFoldæ(Experimental Breed - WCF)`.
String cleanBreedName(String raw) => raw
    .replaceAll(_footnote, '')
    .replaceAllMapped(_parenWithoutSpace, (m) => '${m[1]} (')
    .replaceAll(_whitespace, ' ')
    .trim();

String? _nullIfBlank(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
