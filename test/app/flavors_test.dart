import 'dart:io';

import 'package:cat_directory_app/core/config/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

/// Cada ambiente de Dart tiene que existir tambien como flavor nativo: si se
/// agrega uno aqui y no alla, `flutter run --flavor` falla en esa plataforma.
void main() {
  final gradle = File('android/app/build.gradle.kts').readAsStringSync();

  for (final environment in AppEnvironment.values) {
    final flavor = environment.name;

    test('$flavor esta en Android e iOS', () {
      expect(gradle, contains('create("$flavor")'));
      expect(File('ios/Flutter/flavors/$flavor.xcconfig').existsSync(), isTrue);
      expect(
        File(
          'ios/Runner.xcodeproj/xcshareddata/xcschemes/$flavor.xcscheme',
        ).existsSync(),
        isTrue,
      );
      for (final mode in ['Debug', 'Profile', 'Release']) {
        expect(File('ios/Flutter/$mode-$flavor.xcconfig').existsSync(), isTrue);
      }
    });
  }
}
