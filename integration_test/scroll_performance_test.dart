import 'package:cat_directory_app/app/bootstrap.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/features/breeds/presentation/pages/breeds_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Auditoria de scroll: carga el directorio completo (98 razas, 7 paginas) y
/// despues traza el scroll arriba y abajo con la lista ya cargada.
///
///   fvm flutter drive --profile \
///     --driver=test_driver/perf_driver.dart \
///     --target=integration_test/scroll_performance_test.dart
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    ..framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('scroll del directorio cargado', (tester) async {
    await bootstrap();
    // Deja pasar el splash animado.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    final list = find.byType(CustomScrollView);
    final bloc = tester.element(find.byType(BreedsPage)).read<BreedsBloc>();

    // Carga todas las paginas antes de medir.
    for (var i = 0; i < 40 && !bloc.state.hasReachedMax; i++) {
      await tester.fling(list, const Offset(0, -900), 4000);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 600));
    }
    expect(bloc.state.hasReachedMax, isTrue);
    expect(bloc.state.breeds.length, greaterThan(90));

    for (var i = 0; i < 12; i++) {
      await tester.fling(list, const Offset(0, 1500), 5000);
      await tester.pumpAndSettle();
    }

    await binding.traceAction(() async {
      for (var round = 0; round < 2; round++) {
        for (var i = 0; i < 8; i++) {
          await tester.fling(list, const Offset(0, -700), 2600);
          await tester.pumpAndSettle();
        }
        for (var i = 0; i < 8; i++) {
          await tester.fling(list, const Offset(0, 700), 2600);
          await tester.pumpAndSettle();
        }
      }
    }, reportKey: 'scroll_timeline');
  });
}
