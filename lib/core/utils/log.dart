import 'package:flutter/foundation.dart';

/// Log de desarrollo: solo en debug y visible en la consola de `flutter run`.
void logDebug(String tag, String message, {Object? error}) {
  if (!kDebugMode) return;
  debugPrint('[$tag] $message${error == null ? '' : ' -> $error'}');
}
