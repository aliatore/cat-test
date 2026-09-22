import 'dart:async';

import 'package:cat_directory_app/design_system/theme/motion.dart';
import 'package:flutter/widgets.dart';

/// Entrada suave (fade + desplazamiento corto) que se reproduce una sola vez.
/// Al terminar devuelve el hijo sin envoltorios, asi que no deja capas de
/// opacidad vivas durante el scroll.
class Appear extends StatefulWidget {
  const Appear({
    required this.child,
    this.delay = Duration.zero,
    this.offset = 14,
    this.enabled = true,
    super.key,
  });

  final Widget child;
  final Duration delay;
  final double offset;
  final bool enabled;

  @override
  State<Appear> createState() => _AppearState();
}

class _AppearState extends State<Appear> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: Motion.medium,
  );
  late final _curve = CurvedAnimation(parent: _controller, curve: Motion.enter);
  Timer? _delay;
  var _done = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_done || _controller.isAnimating || _delay != null) return;
    if (!widget.enabled || Motion.reduced(context)) {
      _done = true;
      return;
    }
    _delay = Timer(widget.delay, () {
      if (!mounted) return;
      unawaited(
        _controller.forward().whenComplete(() {
          if (mounted) setState(() => _done = true);
        }),
      );
    });
  }

  @override
  void dispose() {
    _delay?.cancel();
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_done) return widget.child;
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) => Opacity(
        opacity: _curve.value,
        child: Transform.translate(
          offset: Offset(0, widget.offset * (1 - _curve.value)),
          child: child,
        ),
      ),
    );
  }
}
