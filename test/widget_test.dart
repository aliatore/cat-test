import 'package:cat_directory_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('la app arranca', (tester) async {
    await tester.pumpWidget(const CatDirectoryApp());
    expect(find.text('NekoDex'), findsOneWidget);
  });
}
