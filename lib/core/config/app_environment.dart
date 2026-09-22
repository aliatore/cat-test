import 'package:flutter/services.dart';

/// Ambiente con el que se compilo la app. Sale del flavor nativo
/// (`--flavor dev|qa|prod`); sin flavor es prod, igual que el `default-flavor`
/// del pubspec.
///
/// El nombre de la app, el id y el esquema de deep links de cada ambiente
/// viven en Android (`productFlavors`) e iOS (`ios/Flutter/flavors`); aqui
/// solo lo que usa Dart.
enum AppEnvironment {
  dev(
    apiBaseUrl: 'https://catfact.ninja',
    revalidateAfter: Duration(seconds: 30),
    httpLogs: true,
  ),
  qa(
    apiBaseUrl: 'https://catfact.ninja',
    revalidateAfter: Duration(minutes: 1),
    httpLogs: true,
  ),
  prod(
    apiBaseUrl: 'https://catfact.ninja',
    revalidateAfter: Duration(minutes: 5),
    httpLogs: false,
  )
  ;

  const AppEnvironment({
    required this.apiBaseUrl,
    required this.revalidateAfter,
    required this.httpLogs,
  });

  /// catfact.ninja no tiene staging: por ahora los tres usan la misma API.
  final String apiBaseUrl;

  /// Tiempo en segundo plano a partir del cual se revalida al volver. En dev
  /// y qa es corto para poder probarlo sin esperar cinco minutos.
  final Duration revalidateAfter;

  /// Una linea por peticion en la consola (solo en debug).
  final bool httpLogs;

  static final AppEnvironment current = fromFlavor(appFlavor);

  static AppEnvironment fromFlavor(String? flavor) => values.firstWhere(
    (environment) => environment.name == flavor,
    orElse: () => prod,
  );

  bool get isProduction => this == prod;

  /// DEV, QA o PROD.
  String get label => name.toUpperCase();
}
