import 'package:cat_directory_app/core/config/app_config.dart';
import 'package:cat_directory_app/core/config/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEnvironment', () {
    test('sale del flavor con el que se compilo', () {
      expect(AppEnvironment.fromFlavor('dev'), AppEnvironment.dev);
      expect(AppEnvironment.fromFlavor('qa'), AppEnvironment.qa);
      expect(AppEnvironment.fromFlavor('prod'), AppEnvironment.prod);
    });

    test('sin flavor o con uno desconocido es prod', () {
      expect(AppEnvironment.fromFlavor(null), AppEnvironment.prod);
      expect(AppEnvironment.fromFlavor('staging'), AppEnvironment.prod);
    });

    test('la version lleva el ambiente salvo en prod', () {
      expect(AppConfig.versionFor(AppEnvironment.prod), AppConfig.version);
      expect(
        AppConfig.versionFor(AppEnvironment.qa),
        '${AppConfig.version}-qa',
      );
    });
  });
}
