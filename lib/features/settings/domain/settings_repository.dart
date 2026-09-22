import 'package:cat_directory_app/features/settings/domain/app_settings.dart';

abstract interface class SettingsRepository {
  AppSettings load();

  Future<void> save(AppSettings settings);
}
