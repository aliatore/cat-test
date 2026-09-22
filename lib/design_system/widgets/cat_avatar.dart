import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:flutter/material.dart';

/// Rasgos visuales de un avatar. Se derivan de los datos reales de la raza:
/// el patron del pelaje decide el dibujo y el nombre decide los colores.
enum CatMarking {
  stripes,
  spots,
  points,
  bicolor,
  ticked,
  solid,
  wrinkles,
  circuit,
}

@immutable
class CatAvatarSpec {
  const CatAvatarSpec({
    required this.seed,
    required this.marking,
    this.fluffy = false,
  });

  /// [seed] suele ser el slug de la raza; [pattern] y [coat] vienen de la API
  /// tal cual ("Colorpoint/Mitted/Bicolor", "Semi-long", ...).
  factory CatAvatarSpec.fromBreed({
    required String seed,
    String? pattern,
    String? coat,
  }) {
    final p = (pattern ?? '').toLowerCase();
    final c = (coat ?? '').toLowerCase();
    return CatAvatarSpec(
      seed: _fnv1a(seed),
      marking: _markingFor(p, c),
      fluffy: c.contains('long') || c.contains('medium'),
    );
  }

  final int seed;
  final CatMarking marking;
  final bool fluffy;

  static CatMarking _markingFor(String pattern, String coat) {
    if (coat.contains('hairless') || pattern.contains('hairless')) {
      return CatMarking.wrinkles;
    }
    if (pattern.contains('all but') || pattern.isEmpty) {
      return CatMarking.circuit;
    }
    if (pattern.contains('tabby') ||
        pattern.contains('mackerel') ||
        pattern.contains('striped')) {
      return CatMarking.stripes;
    }
    if (pattern.contains('spot') || pattern.contains('marbled')) {
      return CatMarking.spots;
    }
    if (pattern.contains('point') ||
        pattern.contains('colorprint') ||
        pattern.contains('mink')) {
      return CatMarking.points;
    }
    if (pattern.contains('bi') ||
        pattern.contains('tri') ||
        pattern.contains('van') ||
        pattern.contains('mitted')) {
      return CatMarking.bicolor;
    }
    if (pattern.contains('tick')) return CatMarking.ticked;
    if (pattern.contains('solid')) return CatMarking.solid;
    return CatMarking.circuit;
  }

  /// Hash estable entre ejecuciones y plataformas (String.hashCode no lo es).
  static int _fnv1a(String input) {
    var hash = 0x811c9dc5;
    for (final unit in input.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash;
  }

  @override
  bool operator ==(Object other) =>
      other is CatAvatarSpec &&
      other.seed == seed &&
      other.marking == marking &&
      other.fluffy == fluffy;

  @override
  int get hashCode => Object.hash(seed, marking, fluffy);
}

/// Avatar de neon generado por codigo: cada raza tiene el suyo, siempre el
/// mismo, sin descargar una sola imagen.
class CatAvatar extends StatelessWidget {
  const CatAvatar({
    required this.spec,
    this.size = 52,
    this.glow = true,
    super.key,
  });

  final CatAvatarSpec spec;
  final double size;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final accents = colors.accents;
    final accent = accents[spec.seed % accents.length];
    var eyes = accents[(spec.seed ~/ 7) % accents.length];
    if (eyes == accent) eyes = accents[(spec.seed + 2) % accents.length];

    return RepaintBoundary(
      child: CustomPaint(
        size: Size.square(size),
        painter: CatAvatarPainter(
          spec: spec,
          accent: accent,
          eyes: eyes,
          nose: accent == colors.yellow ? colors.magenta : colors.yellow,
          pupil: colors.background,
          glow: glow ? colors.glow : 0,
        ),
      ),
    );
  }
}

class CatAvatarPainter extends CustomPainter {
  CatAvatarPainter({
    required this.spec,
    required this.accent,
    required this.eyes,
    required this.nose,
    required this.pupil,
    required this.glow,
  });

  final CatAvatarSpec spec;
  final Color accent;
  final Color eyes;
  final Color nose;
  final Color pupil;
  final double glow;

  // Geometria canonica en un lienzo de 512x512; la comparten el icono, las
  // animaciones Lottie y este painter.
  static final Path _head = _poly(const [
    (136, 96),
    (206, 172),
    (256, 166),
    (306, 172),
    (376, 96),
    (390, 208),
    (414, 290),
    (358, 370),
    (256, 406),
    (154, 370),
    (98, 290),
    (122, 208),
  ]);
  static final Path _innerEars = Path()
    ..addPath(
      _poly(const [(137, 186), (144, 124), (183, 166)], close: false),
      Offset.zero,
    )
    ..addPath(
      _poly(const [(375, 186), (368, 124), (329, 166)], close: false),
      Offset.zero,
    );
  static final Path _eyes = Path()
    ..addPath(
      _poly(const [(164, 262), (222, 244), (236, 270), (182, 288)]),
      Offset.zero,
    )
    ..addPath(
      _poly(const [(348, 262), (290, 244), (276, 270), (330, 288)]),
      Offset.zero,
    );
  static final Path _pupils = Path()
    ..addPath(
      _poly(const [(203, 250), (208, 266), (203, 282), (198, 266)]),
      Offset.zero,
    )
    ..addPath(
      _poly(const [(309, 250), (314, 266), (309, 282), (304, 266)]),
      Offset.zero,
    );
  static final Path _nose = _poly(const [(242, 314), (270, 314), (256, 330)]);
  static final Path _mouth = _lines(const [
    ((256, 330), (256, 340)),
    ((256, 340), (240, 352)),
    ((256, 340), (272, 352)),
  ]);
  static final Path _whiskers = _lines(const [
    ((196, 326), (84, 310)),
    ((198, 338), (78, 342)),
    ((200, 350), (90, 376)),
    ((316, 326), (428, 310)),
    ((314, 338), (434, 342)),
    ((312, 350), (422, 376)),
  ]);
  static final Path _tufts = Path()
    ..addPath(
      _poly(const [
        (100, 276),
        (80, 290),
        (100, 300),
        (82, 314),
        (106, 322),
      ], close: false),
      Offset.zero,
    )
    ..addPath(
      _poly(const [
        (412, 276),
        (432, 290),
        (412, 300),
        (430, 314),
        (406, 322),
      ], close: false),
      Offset.zero,
    );

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 512;
    canvas
      ..save()
      ..translate(
        (size.width - 512 * scale) / 2,
        (size.height - 512 * scale) / 2,
      )
      ..scale(scale);

    if (glow > 0) {
      canvas.drawPath(
        _head,
        _stroke(accent.withValues(alpha: 0.2 * glow), 40),
      );
    }
    canvas
      ..drawPath(_head, Paint()..color = accent.withValues(alpha: 0.1))
      ..save()
      ..clipPath(_head);
    _paintMarking(canvas);
    canvas.restore();

    if (spec.fluffy) canvas.drawPath(_tufts, _stroke(accent, 10));
    canvas
      ..drawPath(_head, _stroke(accent, 16))
      ..drawPath(_innerEars, _stroke(eyes.withValues(alpha: 0.85), 10))
      ..drawPath(_eyes, Paint()..color = eyes.withValues(alpha: 0.3))
      ..drawPath(_eyes, _stroke(eyes, 10))
      ..drawPath(_pupils, Paint()..color = pupil)
      ..drawPath(_nose, Paint()..color = nose)
      ..drawPath(_mouth, _stroke(accent.withValues(alpha: 0.9), 8))
      ..drawPath(_whiskers, _stroke(eyes.withValues(alpha: 0.75), 6))
      ..restore();
  }

  void _paintMarking(Canvas canvas) {
    final soft = accent.withValues(alpha: 0.42);
    switch (spec.marking) {
      case CatMarking.stripes:
        canvas.drawPath(
          _lines(const [
            ((196, 196), (226, 214)),
            ((316, 196), (286, 214)),
            ((236, 186), (246, 222)),
            ((276, 186), (266, 222)),
            ((104, 262), (150, 276)),
            ((104, 296), (148, 300)),
            ((408, 262), (362, 276)),
            ((408, 296), (364, 300)),
          ]),
          _stroke(soft, 12),
        );
      case CatMarking.spots:
        final paint = Paint()..color = soft;
        for (final (x, y, r) in const [
          (196.0, 214.0, 11.0),
          (316.0, 214.0, 11.0),
          (256.0, 236.0, 9.0),
          (138.0, 312.0, 10.0),
          (374.0, 312.0, 10.0),
          (170.0, 348.0, 8.0),
          (342.0, 348.0, 8.0),
        ]) {
          canvas.drawCircle(Offset(x, y), r, paint);
        }
      case CatMarking.points:
        final paint = Paint()..color = accent.withValues(alpha: 0.38);
        canvas
          ..drawPath(_poly(const [(122, 208), (136, 96), (206, 172)]), paint)
          ..drawPath(_poly(const [(390, 208), (376, 96), (306, 172)]), paint)
          ..drawOval(
            Rect.fromCenter(
              center: const Offset(256, 336),
              width: 124,
              height: 82,
            ),
            paint,
          );
      case CatMarking.bicolor:
        canvas
          ..drawRect(
            const Rect.fromLTWH(0, 0, 256, 512),
            Paint()..color = accent.withValues(alpha: 0.2),
          )
          ..drawPath(
            _poly(const [(236, 166), (276, 166), (262, 312), (250, 312)]),
            Paint()..color = eyes.withValues(alpha: 0.16),
          );
      case CatMarking.ticked:
        final paint = Paint()..color = soft;
        for (var y = 190.0; y <= 240; y += 16) {
          for (var x = 174.0; x <= 338; x += 16) {
            canvas.drawCircle(Offset(x + (y % 32 == 0 ? 8 : 0), y), 3.2, paint);
          }
        }
      case CatMarking.solid:
        canvas.drawPath(_head, Paint()..color = accent.withValues(alpha: 0.14));
      case CatMarking.wrinkles:
        final paint = _stroke(soft, 8);
        for (final radius in const [30.0, 46.0, 62.0]) {
          canvas.drawArc(
            Rect.fromCircle(center: const Offset(256, 250), radius: radius),
            3.6,
            2.2,
            false,
            paint,
          );
        }
      case CatMarking.circuit:
        final paint = _stroke(eyes.withValues(alpha: 0.4), 6);
        canvas.drawPath(
          _lines(const [
            ((256, 170), (256, 206)),
            ((256, 206), (230, 226)),
            ((256, 206), (282, 226)),
            ((150, 214), (168, 232)),
            ((362, 214), (344, 232)),
          ]),
          paint,
        );
        final node = Paint()..color = eyes.withValues(alpha: 0.55);
        for (final o in const [
          Offset(230, 226),
          Offset(282, 226),
          Offset(168, 232),
          Offset(344, 232),
        ]) {
          canvas.drawCircle(o, 6, node);
        }
    }
  }

  static Paint _stroke(Color color, double width) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  static Path _poly(List<(num, num)> points, {bool close = true}) {
    final path = Path()
      ..addPolygon([
        for (final (x, y) in points) Offset(x.toDouble(), y.toDouble()),
      ], close);
    return path;
  }

  static Path _lines(List<((num, num), (num, num))> segments) {
    final path = Path();
    for (final ((x1, y1), (x2, y2)) in segments) {
      path
        ..moveTo(x1.toDouble(), y1.toDouble())
        ..lineTo(x2.toDouble(), y2.toDouble());
    }
    return path;
  }

  @override
  bool shouldRepaint(CatAvatarPainter oldDelegate) =>
      oldDelegate.spec != spec ||
      oldDelegate.accent != accent ||
      oldDelegate.eyes != eyes ||
      oldDelegate.glow != glow;
}
