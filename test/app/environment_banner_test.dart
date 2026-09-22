import 'package:cat_directory_app/app/view/environment_banner.dart';
import 'package:cat_directory_app/core/config/app_environment.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, AppEnvironment environment) {
    return tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: EnvironmentBanner(
          environment: environment,
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  testWidgets('dev y qa llevan la cinta con su nombre', (tester) async {
    for (final environment in [AppEnvironment.dev, AppEnvironment.qa]) {
      await pump(tester, environment);
      final banner = tester.widget<Banner>(find.byType(Banner));
      expect(banner.message, environment.label);
    }
  });

  testWidgets('prod no lleva cinta', (tester) async {
    await pump(tester, AppEnvironment.prod);
    expect(find.byType(Banner), findsNothing);
  });
}
