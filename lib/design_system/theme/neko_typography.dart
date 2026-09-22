import 'package:flutter/material.dart';

/// Tres familias con roles claros:
/// - Orbitron: marca y titulos (se usa poco, cansa en parrafos).
/// - Chakra Petch: todo lo que se lee.
/// - Share Tech Mono: etiquetas tipo terminal (datos, estados).
abstract final class NekoFonts {
  static const display = 'Orbitron';
  static const body = 'ChakraPetch';
  static const mono = 'ShareTechMono';

  /// Orbitron es una fuente variable: el peso se pide por eje `wght`.
  static TextStyle orbitron(double size, FontWeight weight) => TextStyle(
    fontFamily: display,
    fontSize: size,
    fontWeight: weight,
    fontVariations: [FontVariation.weight(weight.value.toDouble())],
    letterSpacing: size * 0.06,
    height: 1.15,
  );

  static TextStyle monoLabel(double size) => TextStyle(
    fontFamily: mono,
    fontSize: size,
    letterSpacing: 1.1,
    height: 1.25,
  );
}

TextTheme buildTextTheme(Color primary, Color secondary) {
  TextStyle body(double size, FontWeight weight, {double height = 1.4}) =>
      TextStyle(
        fontFamily: NekoFonts.body,
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: primary,
      );

  return TextTheme(
    displayLarge: NekoFonts.orbitron(44, FontWeight.w900).copyWith(
      color: primary,
    ),
    displayMedium: NekoFonts.orbitron(36, FontWeight.w800).copyWith(
      color: primary,
    ),
    displaySmall: NekoFonts.orbitron(30, FontWeight.w700).copyWith(
      color: primary,
    ),
    headlineLarge: NekoFonts.orbitron(28, FontWeight.w700).copyWith(
      color: primary,
    ),
    headlineMedium: NekoFonts.orbitron(24, FontWeight.w700).copyWith(
      color: primary,
    ),
    headlineSmall: NekoFonts.orbitron(20, FontWeight.w700).copyWith(
      color: primary,
    ),
    titleLarge: NekoFonts.orbitron(18, FontWeight.w600).copyWith(
      color: primary,
    ),
    titleMedium: body(17, FontWeight.w600, height: 1.25),
    titleSmall: body(15, FontWeight.w600, height: 1.25),
    bodyLarge: body(16, FontWeight.w400),
    bodyMedium: body(14.5, FontWeight.w400),
    bodySmall: body(13, FontWeight.w400).copyWith(color: secondary),
    labelLarge: body(15, FontWeight.w700, height: 1.2).copyWith(
      letterSpacing: 1.2,
    ),
    labelMedium: NekoFonts.monoLabel(13).copyWith(color: secondary),
    labelSmall: NekoFonts.monoLabel(11.5).copyWith(color: secondary),
  );
}
