/// Valores que cambian entre entornos. El dominio de los App Links y
/// Universal Links se puede sobrescribir al compilar:
/// `--dart-define=DEEP_LINK_HOST=mi-dominio.com`.
abstract final class AppConfig {
  static const deepLinkHost = String.fromEnvironment(
    'DEEP_LINK_HOST',
    defaultValue: 'luisturiz.com',
  );

  /// Esquema propio para probar deep links sin dominio verificado:
  /// `nekodex://open/breed/abyssinian`.
  static const deepLinkScheme = 'nekodex';

  static const version = '1.0.0';

  /// Tiempo en segundo plano a partir del cual se revalida al volver. Para
  /// probarlo rapido: `--dart-define=REVALIDATE_AFTER_SECONDS=10`.
  static const revalidateAfter = Duration(
    seconds: int.fromEnvironment('REVALIDATE_AFTER_SECONDS', defaultValue: 300),
  );

  static Uri breedLink(String slug) => Uri.https(deepLinkHost, '/breed/$slug');
}
