import 'package:cat_directory_app/core/config/app_environment.dart';

/// Valores fijos de la app; lo que cambia por ambiente esta en
/// [AppEnvironment]. El dominio de los App Links y Universal Links se puede
/// sobrescribir al compilar: `--dart-define=DEEP_LINK_HOST=mi-dominio.com`.
abstract final class AppConfig {
  static const deepLinkHost = String.fromEnvironment(
    'DEEP_LINK_HOST',
    defaultValue: 'luisturiz.com',
  );

  static const version = '1.0.0';

  /// Version visible en Ajustes: `1.0.0` en prod y `1.0.0-dev` en los demas,
  /// igual que el versionName de Android.
  static String versionFor(AppEnvironment environment) =>
      environment.isProduction ? version : '$version-${environment.name}';

  static Uri breedLink(String slug) => Uri.https(deepLinkHost, '/breed/$slug');
}
