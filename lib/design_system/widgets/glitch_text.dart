import 'dart:async';
import 'dart:math';

import 'package:cat_directory_app/design_system/theme/motion.dart';
import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:flutter/material.dart';

/// Texto con aberracion cromatica y, cada tanto, una rafaga de glitch.
///
/// En reposo no anima nada (solo sombras de color); la rafaga dura ~0.4 s,
/// asi que no mantiene la pantalla repintando a 60 fps.
class GlitchText extends StatefulWidget {
  const GlitchText(
    this.text, {
    this.style,
    this.every = const Duration(seconds: 6),
    this.animate = true,
    this.textAlign,
    this.maxLines,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final Duration every;
  final bool animate;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  State<GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<GlitchText>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  Timer? _timer;
  Timer? _firstBurst;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _schedule();
  }

  @override
  void didUpdateWidget(GlitchText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate != widget.animate ||
        oldWidget.every != widget.every) {
      _schedule();
    }
  }

  void _schedule() {
    _timer?.cancel();
    _firstBurst?.cancel();
    if (!widget.animate || Motion.reduced(context)) return;
    _firstBurst = Timer(const Duration(milliseconds: 700), _burst);
    _timer = Timer.periodic(widget.every, (_) => _burst());
  }

  void _burst() {
    if (mounted) unawaited(_controller.forward(from: 0));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _firstBurst?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final base = DefaultTextStyle.of(context).style.merge(widget.style);
    final aberration = 0.55 * colors.glow;
    final resting = base.copyWith(
      shadows: [
        Shadow(
          color: colors.cyan.withValues(alpha: aberration),
          offset: const Offset(-1.4, 0),
        ),
        Shadow(
          color: colors.magenta.withValues(alpha: aberration),
          offset: const Offset(1.4, 0),
        ),
      ],
    );

    Text copy(TextStyle style) => Text(
      widget.text,
      style: style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.maxLines == null ? null : TextOverflow.ellipsis,
    );

    return AnimatedBuilder(
      animation: _controller,
      child: copy(resting),
      builder: (context, child) {
        if (!_controller.isAnimating) return child!;
        final t = _controller.value;
        final amplitude = sin(pi * t) * 5;
        final step = (t * 14).floor();
        return Stack(
          clipBehavior: Clip.none,
          children: [
            ExcludeSemantics(
              child: Transform.translate(
                offset: Offset(_noise(step, 1) * amplitude, 0),
                child: ClipRect(
                  clipper: _Slice(0.1 + 0.3 * _noise(step, 3).abs(), 0.55),
                  child: copy(base.copyWith(color: colors.cyan)),
                ),
              ),
            ),
            ExcludeSemantics(
              child: Transform.translate(
                offset: Offset(_noise(step, 2) * amplitude, 0),
                child: ClipRect(
                  clipper: _Slice(0.45, 0.8 + 0.2 * _noise(step, 4).abs()),
                  child: copy(base.copyWith(color: colors.magenta)),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(_noise(step, 5) * amplitude * 0.3, 0),
              child: child,
            ),
          ],
        );
      },
    );
  }

  /// Ruido determinista en [-1, 1] que cambia a saltos, como un glitch real.
  static double _noise(int step, int seed) {
    final x = sin(step * 12.9898 + seed * 78.233) * 43758.5453;
    return (x - x.floorToDouble()) * 2 - 1;
  }
}

class _Slice extends CustomClipper<Rect> {
  _Slice(this.top, this.bottom);

  final double top;
  final double bottom;

  @override
  Rect getClip(Size size) => Rect.fromLTRB(
    -8,
    size.height * top,
    size.width + 8,
    size.height * bottom,
  );

  @override
  bool shouldReclip(_Slice oldClipper) =>
      oldClipper.top != top || oldClipper.bottom != bottom;
}
