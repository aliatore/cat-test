import 'dart:ui';

import 'package:cat_directory_app/l10n/gen/app_localizations.dart';
import 'package:flutter/widgets.dart';

export 'package:cat_directory_app/l10n/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Textos para cuando todavia no hay un `BuildContext` con Localizations
/// (arranque, notificaciones programadas). Mismo criterio que la app: si el
/// idioma del telefono no esta soportado, espanol.
AppLocalizations platformL10n() {
  final code = PlatformDispatcher.instance.locale.languageCode;
  final supported = AppLocalizations.supportedLocales.any(
    (l) => l.languageCode == code,
  );
  return lookupAppLocalizations(Locale(supported ? code : 'es'));
}
