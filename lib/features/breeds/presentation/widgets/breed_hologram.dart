import 'dart:async';
import 'dart:math';

import 'package:cat_directory_app/core/services/audio/sound_effects.dart';
import 'package:cat_directory_app/design_system/theme/motion.dart';
import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/widgets/cat_avatar.dart';
import 'package:cat_directory_app/design_system/widgets/sound_scope.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/presentation/widgets/breed_tile.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Avatar grande del detalle, con un anillo de "holograma" girando detras.
/// Es el destino del Hero que sale de la fila de la lista. Tocarlo maulla.
class BreedHologram extends StatefulWidget {
  const BreedHologram({required this.breed, this.size = 176, super.key});

  final Breed breed;
  final double size;

  @override
  State<BreedHologram> createState() => _BreedHologramState();
}

class _BreedHologramState extends State<BreedHologram>
    with SingleTickerProviderStateMixin {
  late final _ring = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  );
  var _petted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _ring.stop();
    } else if (!_ring.isAnimating) {
      unawaited(_ring.repeat());
    }
  }

  @override
  void dispose() {
    _ring.dispose();
    super.dispose();
  }

  Future<void> _pet() async {
    unawaited(HapticFeedback.mediumImpact());
    unawaited(SoundScope.of(context).play(Sfx.meow));
    setState(() => _petted = true);
    await Future<void>.delayed(const Duration(milliseconds: 160));
    if (mounted) setState(() => _petted = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final l10n = context.l10n;
    final ringSize = widget.size + 64;

    return Semantics(
      button: true,
      label: l10n.detailAvatarSemantics(widget.breed.name),
      onTap: _pet,
      onTapHint: l10n.detailPetHint,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: _pet,
        child: SizedBox.square(
          dimension: ringSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _ring,
                  builder: (context, _) => CustomPaint(
                    size: Size.square(ringSize),
                    painter: _RingPainter(
                      progress: _ring.value,
                      primary: colors.cyan,
                      secondary: colors.magenta,
                      glow: colors.glow,
                    ),
                  ),
                ),
              ),
              AnimatedScale(
                scale: _petted ? 0.9 : 1,
                duration: Motion.fast,
                curve: Curves.easeOutBack,
                child: Hero(
                  tag: breedHeroTag(widget.breed),
                  child: CatAvatar(
                    spec: avatarSpecFor(widget.breed),
                    size: widget.size,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.primary,
    required this.secondary,
    required this.glow,
  });

  final double progress;
  final Color primary;
  final Color secondary;
  final double glow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 6;

    canvas.drawCircle(
      center,
      radius - 16,
      Paint()
        ..shader = RadialGradient(
          colors: [
            primary.withValues(alpha: 0.16 * glow),
            primary.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    final dashes = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = primary.withValues(alpha: 0.75);
    const segments = 36;
    const sweep = 2 * pi / segments;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final rotation = progress * 2 * pi;
    for (var i = 0; i < segments; i++) {
      if (i % 6 == 5) continue;
      canvas.drawArc(rect, rotation + i * sweep, sweep * 0.55, false, dashes);
    }

    final inner = Rect.fromCircle(center: center, radius: radius - 10);
    canvas.drawArc(
      inner,
      -rotation * 1.6,
      pi * 0.7,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = secondary.withValues(alpha: 0.85),
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.primary != primary;
}
