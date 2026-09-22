import 'package:flutter/material.dart';

/// Paleta completa de la app. El ColorScheme de Material cubre lo basico; lo
/// propio del estilo (neones, reticula, brillo) vive aqui.
@immutable
class NekoColors extends ThemeExtension<NekoColors> {
  const NekoColors({
    required this.background,
    required this.backgroundDeep,
    required this.surface,
    required this.surfaceRaised,
    required this.outline,
    required this.cyan,
    required this.magenta,
    required this.yellow,
    required this.purple,
    required this.mint,
    required this.danger,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.grid,
    required this.glow,
  });

  /// "Night City": el modo en el que se penso la app.
  static const dark = NekoColors(
    background: Color(0xFF07060F),
    backgroundDeep: Color(0xFF110A26),
    surface: Color(0xFF0E0C1D),
    surfaceRaised: Color(0xFF17142E),
    outline: Color(0xFF2B2653),
    cyan: Color(0xFF00F0FF),
    magenta: Color(0xFFFF2E88),
    yellow: Color(0xFFFCEE0A),
    purple: Color(0xFFB388FF),
    mint: Color(0xFF3CFFB4),
    danger: Color(0xFFFF4D6D),
    textPrimary: Color(0xFFECEAFB),
    textSecondary: Color(0xFFA7A3CC),
    textMuted: Color(0xFF7C78A3),
    grid: Color(0xFF6B3FD9),
    glow: 1,
  );

  /// "Distrito de dia": mismos acentos, oscurecidos para que el texto pase
  /// contraste AA sobre fondo claro.
  static const light = NekoColors(
    background: Color(0xFFF4F2FB),
    backgroundDeep: Color(0xFFE6E1F7),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFEDEAF8),
    outline: Color(0xFFCFC9E8),
    cyan: Color(0xFF007A8C),
    magenta: Color(0xFFC2185B),
    yellow: Color(0xFF7A6500),
    purple: Color(0xFF6A34C2),
    mint: Color(0xFF00805A),
    danger: Color(0xFFC62845),
    textPrimary: Color(0xFF15122B),
    textSecondary: Color(0xFF47436A),
    textMuted: Color(0xFF6B6790),
    grid: Color(0xFF8F7BD6),
    glow: 0.35,
  );

  final Color background;
  final Color backgroundDeep;
  final Color surface;
  final Color surfaceRaised;
  final Color outline;
  final Color cyan;
  final Color magenta;
  final Color yellow;
  final Color purple;
  final Color mint;
  final Color danger;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color grid;

  /// Intensidad de los halos de neon (0..1). En claro casi no se usan.
  final double glow;

  /// Acentos para los avatares de cada raza, en orden estable.
  List<Color> get accents => [cyan, magenta, yellow, purple, mint];

  @override
  NekoColors copyWith({
    Color? background,
    Color? backgroundDeep,
    Color? surface,
    Color? surfaceRaised,
    Color? outline,
    Color? cyan,
    Color? magenta,
    Color? yellow,
    Color? purple,
    Color? mint,
    Color? danger,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? grid,
    double? glow,
  }) => NekoColors(
    background: background ?? this.background,
    backgroundDeep: backgroundDeep ?? this.backgroundDeep,
    surface: surface ?? this.surface,
    surfaceRaised: surfaceRaised ?? this.surfaceRaised,
    outline: outline ?? this.outline,
    cyan: cyan ?? this.cyan,
    magenta: magenta ?? this.magenta,
    yellow: yellow ?? this.yellow,
    purple: purple ?? this.purple,
    mint: mint ?? this.mint,
    danger: danger ?? this.danger,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textMuted: textMuted ?? this.textMuted,
    grid: grid ?? this.grid,
    glow: glow ?? this.glow,
  );

  @override
  NekoColors lerp(NekoColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return NekoColors(
      background: mix(background, other.background),
      backgroundDeep: mix(backgroundDeep, other.backgroundDeep),
      surface: mix(surface, other.surface),
      surfaceRaised: mix(surfaceRaised, other.surfaceRaised),
      outline: mix(outline, other.outline),
      cyan: mix(cyan, other.cyan),
      magenta: mix(magenta, other.magenta),
      yellow: mix(yellow, other.yellow),
      purple: mix(purple, other.purple),
      mint: mix(mint, other.mint),
      danger: mix(danger, other.danger),
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      textMuted: mix(textMuted, other.textMuted),
      grid: mix(grid, other.grid),
      glow: glow + (other.glow - glow) * t,
    );
  }
}

extension NekoColorsX on BuildContext {
  NekoColors get neko => Theme.of(this).extension<NekoColors>()!;
}
