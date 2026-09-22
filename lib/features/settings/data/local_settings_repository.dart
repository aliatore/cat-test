import 'dart:convert';

import 'package:cat_directory_app/core/cache/key_value_store.dart';
import 'package:cat_directory_app/features/settings/domain/app_settings.dart';
import 'package:cat_directory_app/features/settings/domain/settings_repository.dart';

class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this._store);

  final KeyValueStore _store;

  static const _key = 'settings';

  @override
  AppSettings load() {
    final raw = _store.read(_key);
    if (raw == null) return const AppSettings();
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return AppSettings(
        theme:
            ThemePreference.values.asNameMap()[json['theme']] ??
            ThemePreference.system,
        soundEnabled: json['sound'] as bool? ?? true,
        dailyBreed: json['dailyBreed'] as bool? ?? false,
        performanceOverlay: json['performanceOverlay'] as bool? ?? false,
      );
    } on Object {
      return const AppSettings();
    }
  }

  @override
  Future<void> save(AppSettings settings) => _store.write(
    _key,
    jsonEncode({
      'theme': settings.theme.name,
      'sound': settings.soundEnabled,
      'dailyBreed': settings.dailyBreed,
      'performanceOverlay': settings.performanceOverlay,
    }),
  );
}
