import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:flutter/material.dart';

/// Fondo estatico: degradado, halos y una reticula en perspectiva.
///
/// Se pinta una sola vez y queda aislado en su propia capa, asi que el
/// scroll de la lista nunca lo repinta.
class CyberBackground extends StatelessWidget {
  const CyberBackground({this.child, super.key});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: CustomPaint(painter: _BackgroundPainter(colors)),
        ),
        ?child,
      ],
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter(this.colors);

  final NekoColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.background, colors.backgroundDeep],
        ).createShader(rect),
    );

    _halo(
      canvas,
      size,
      Offset(size.width * 0.95, size.height * 0.02),
      size.width * 0.9,
      colors.magenta,
      0.16,
    );
    _halo(
      canvas,
      size,
      Offset(0, size.height * 0.75),
      size.width * 0.8,
      colors.cyan,
      0.10,
    );

    _grid(canvas, size);
    _scanlines(canvas, size);
  }

  void _halo(
    Canvas canvas,
    Size size,
    Offset center,
    double radius,
    Color color,
    double strength,
  ) {
    final alpha = strength * colors.glow;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: alpha),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  /// Reticula "synthwave" en el tercio inferior.
  void _grid(Canvas canvas, Size size) {
    final horizon = size.height * 0.68;
    final bottom = size.height;
    final vanishing = Offset(size.width / 2, horizon);
    final area = Rect.fromLTRB(0, horizon, size.width, bottom);
    final paint = Paint()
      ..strokeWidth = 1
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors.grid.withValues(alpha: 0),
          colors.grid.withValues(alpha: 0.28),
        ],
      ).createShader(area);

    const columns = 14;
    for (var i = -columns; i <= columns; i++) {
      final x = size.width / 2 + i * size.width / columns * 1.6;
      canvas.drawLine(vanishing, Offset(x, bottom), paint);
    }
    // Lineas horizontales cada vez mas juntas hacia el horizonte.
    for (var i = 1; i <= 9; i++) {
      final t = i / 9;
      final y = horizon + (bottom - horizon) * t * t;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _scanlines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colors.textPrimary.withValues(alpha: 0.018)
      ..strokeWidth = 1;
    for (var y = 0.0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_BackgroundPainter oldDelegate) =>
      oldDelegate.colors != colors;
}
