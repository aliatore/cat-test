import 'package:freezed_annotation/freezed_annotation.dart';

part 'breeds_cache_info.freezed.dart';

@freezed
abstract class BreedsCacheInfo with _$BreedsCacheInfo {
  const factory BreedsCacheInfo({
    required int pages,
    required int breeds,
    DateTime? lastUpdated,
  }) = _BreedsCacheInfo;

  static const empty = BreedsCacheInfo(pages: 0, breeds: 0);
}
