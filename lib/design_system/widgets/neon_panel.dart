import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:flutter/material.dart';

/// Panel con esquinas cortadas, borde de neon tenue y marcas de "HUD" en las
/// esquinas rectas. Es la superficie base de tarjetas y bloques de datos.
class NeonPanel extends StatelessWidget {
  const NeonPanel({
    required this.child,
    this.accent,
    this.padding = const EdgeInsets.all(14),
    this.cut = 12,
    this.glow = false,
    this.brackets = true,
    this.fill,
    super.key,
  });

  final Widget child;
  final Color? accent;
  final EdgeInsetsGeometry padding;
  final double cut;

  /// Halo difuso. Cuesta raster, asi que no se usa en elementos de lista.
  final bool glow;
  final bool brackets;
  final Color? fill;

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final color = accent ?? colors.cyan;
    final shape = BeveledRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(cut),
        bottomRight: Radius.circular(cut),
      ),
      side: BorderSide(color: color.withValues(alpha: 0.38)),
    );

    return CustomPaint(
      foregroundPainter: brackets ? _BracketsPainter(color) : null,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: fill ?? colors.surface.withValues(alpha: 0.88),
          shape: shape,
          shadows: glow
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35 * colors.glow),
                    blurRadius: 22,
                    spreadRadius: -6,
                  ),
                ]
              : null,
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Escuadras de 10px en las dos esquinas que no estan cortadas.
class _BracketsPainter extends CustomPainter {
  _BracketsPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const length = 10.0;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final w = size.width;
    final h = size.height;

    canvas
      ..drawPath(
        Path()
          ..moveTo(w - length, 1)
          ..lineTo(w - 1, 1)
          ..lineTo(w - 1, length),
        paint,
      )
      ..drawPath(
        Path()
          ..moveTo(1, h - length)
          ..lineTo(1, h - 1)
          ..lineTo(length, h - 1),
        paint,
      );
  }

  @override
  bool shouldRepaint(_BracketsPainter oldDelegate) =>
      oldDelegate.color != color;
}
