import 'package:cat_directory_app/design_system/theme/neko_theme.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/presentation/widgets/breed_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  const breed = Breed(
    name: 'Abyssinian',
    country: 'Ethiopia',
    coat: 'Short',
    pattern: 'Ticked',
  );

  Widget tile({VoidCallback? onTap}) => Padding(
    padding: const EdgeInsets.all(16),
    child: BreedTile(breed: breed, number: 1, onTap: onTap, hero: false),
  );

  testWidgets('un lector de pantalla oye nombre y pais como un boton', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpApp(tile(onTap: () {}));

    expect(
      tester.getSemantics(find.bySemanticsLabel('Abyssinian. País: Ethiopia.')),
      matchesSemantics(
        label: 'Abyssinian. País: Ethiopia.',
        isButton: true,
        hasTapAction: true,
        onTapHint: 'ver ficha',
      ),
    );
    semantics.dispose();
  });

  testWidgets('la accion de toque llega tambien desde la accesibilidad', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var taps = 0;
    await tester.pumpApp(tile(onTap: () => taps++));

    tester.semantics.tap(find.semantics.byLabel(RegExp('Abyssinian')));
    await tester.pump();

    expect(taps, 1);
    semantics.dispose();
  });

  testWidgets('sin pais conocido lo dice en vez de dejar un hueco', (
    tester,
  ) async {
    await tester.pumpApp(
      const BreedTile(breed: Breed(name: 'Aegean'), number: 2, hero: false),
    );

    expect(find.text('PAÍS DESCONOCIDO'), findsOneWidget);
  });

  for (final (name, theme) in [
    ('oscuro', NekoTheme.dark()),
    ('claro', NekoTheme.light()),
  ]) {
    testWidgets('cumple las guias de accesibilidad en modo $name', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpApp(tile(onTap: () {}), theme: theme);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    });
  }
}
