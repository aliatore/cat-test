import 'package:cat_directory_app/design_system/theme/neko_theme.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  /// Monta [widget] con el tema, las traducciones y un Scaffold, como en la
  /// app real. Por defecto en espanol y modo oscuro.
  ///
  /// Con [reduceMotion] (activo por defecto) las animaciones decorativas no
  /// arrancan, igual que con "reducir movimiento" en el telefono, asi que no
  /// quedan timers colgando al terminar la prueba.
  Future<void> pumpApp(
    Widget widget, {
    ThemeData? theme,
    Locale locale = const Locale('es'),
    bool reduceMotion = true,
  }) async {
    await pumpWidget(
      MaterialApp(
        theme: theme ?? NekoTheme.dark(),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(disableAnimations: reduceMotion),
          child: child!,
        ),
        home: Scaffold(body: widget),
      ),
    );
  }
}
