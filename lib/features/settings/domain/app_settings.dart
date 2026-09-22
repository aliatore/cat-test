import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

/// Tema elegido por el usuario. Por defecto sigue al sistema.
enum ThemePreference { system, dark, light }

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(ThemePreference.system) ThemePreference theme,
    @Default(true) bool soundEnabled,
    @Default(false) bool dailyBreed,
    @Default(false) bool performanceOverlay,
  }) = _AppSettings;
}
