import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/theme/neko_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Esquinas cortadas en diagonal: el recurso de forma de todo el sistema.
const nekoCorner = Radius.circular(12);
const nekoShape = BeveledRectangleBorder(
  borderRadius: BorderRadius.only(topLeft: nekoCorner, bottomRight: nekoCorner),
);

abstract final class NekoTheme {
  static ThemeData dark() => _build(NekoColors.dark, Brightness.dark);

  static ThemeData light() => _build(NekoColors.light, Brightness.light);

  static ThemeData _build(NekoColors c, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.cyan,
      onPrimary: isDark ? const Color(0xFF00161A) : Colors.white,
      secondary: c.magenta,
      onSecondary: isDark ? const Color(0xFF1C0010) : Colors.white,
      tertiary: c.yellow,
      onTertiary: isDark ? const Color(0xFF1A1700) : Colors.white,
      error: c.danger,
      onError: isDark ? const Color(0xFF1F0008) : Colors.white,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      surfaceContainerLowest: c.background,
      surfaceContainerLow: c.surface,
      surfaceContainer: c.surface,
      surfaceContainerHigh: c.surfaceRaised,
      surfaceContainerHighest: c.surfaceRaised,
      outline: c.outline,
      outlineVariant: c.outline.withValues(alpha: 0.6),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: c.textPrimary,
      onInverseSurface: c.background,
      inversePrimary: c.magenta,
    );
    final text = buildTextTheme(c.textPrimary, c.textSecondary);

    return ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      textTheme: text,
      fontFamily: NekoFonts.body,
      extensions: [c],
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: AppBarThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: c.background,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: c.background,
              ),
      ),
      iconTheme: IconThemeData(color: c.textSecondary, size: 22),
      cardTheme: CardThemeData(
        color: c.surface,
        shape: nekoShape,
        margin: EdgeInsets.zero,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: c.surface.withValues(alpha: isDark ? 0.92 : 1),
        hintStyle: NekoFonts.monoLabel(14).copyWith(color: c.textMuted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: _inputBorder(c.outline),
        enabledBorder: _inputBorder(c.outline),
        focusedBorder: _inputBorder(c.cyan, width: 1.6),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.cyan,
        selectionColor: c.cyan.withValues(alpha: 0.3),
        selectionHandleColor: c.cyan,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.cyan,
        refreshBackgroundColor: c.surfaceRaised,
        linearTrackColor: c.outline,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.surfaceRaised,
        contentTextStyle: text.bodyMedium,
        shape: nekoShape,
        elevation: 0,
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: c.outline,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: nekoShape,
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyMedium,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.onPrimary
              : c.textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? c.cyan : c.surfaceRaised,
        ),
        trackOutlineColor: WidgetStatePropertyAll(c.outline),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: const WidgetStatePropertyAll(nekoShape),
          side: WidgetStatePropertyAll(BorderSide(color: c.outline)),
          textStyle: WidgetStatePropertyAll(text.labelMedium),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? scheme.onPrimary
                : c.textSecondary,
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? c.cyan
                : Colors.transparent,
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: ShapeDecoration(color: c.surfaceRaised, shape: nekoShape),
        textStyle: text.labelMedium?.copyWith(color: c.textPrimary),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: color, width: width),
      );
}
