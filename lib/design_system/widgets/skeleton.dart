import 'dart:async';

import 'package:cat_directory_app/design_system/theme/motion.dart';
import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:flutter/material.dart';

/// Barrido de brillo sobre un grupo de skeletons: un solo controlador para
/// el grupo entero en vez de uno por caja.
class NeonShimmer extends StatefulWidget {
  const NeonShimmer({required this.child, super.key});

  final Widget child;

  @override
  State<NeonShimmer> createState() => _NeonShimmerState();
}

class _NeonShimmerState extends State<NeonShimmer>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      unawaited(_controller.repeat());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final base = colors.surfaceRaised;
    final highlight = Color.lerp(base, colors.cyan, 0.22)!;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final t = _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(-1.6 + 3.2 * t, -0.3),
            end: Alignment(-0.6 + 3.2 * t, 0.3),
            colors: [base, highlight, base],
            stops: const [0, 0.5, 1],
          ).createShader(bounds),
          child: child,
        );
      },
    );
  }
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({this.width, this.height = 14, this.cut = 4, super.key});

  final double? width;
  final double height;
  final double cut;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    height: height,
    child: DecoratedBox(
      decoration: ShapeDecoration(
        color: context.neko.surfaceRaised,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(cut),
            bottomRight: Radius.circular(cut),
          ),
        ),
      ),
    ),
  );
}
