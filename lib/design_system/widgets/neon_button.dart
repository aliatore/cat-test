import 'dart:async';

import 'package:cat_directory_app/core/services/audio/sound_effects.dart';
import 'package:cat_directory_app/design_system/theme/motion.dart';
import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/widgets/sound_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum NeonButtonVariant { filled, outlined }

class NeonButton extends StatefulWidget {
  const NeonButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = NeonButtonVariant.filled,
    this.accent,
    this.expand = false,
    this.sound = Sfx.tap,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final NeonButtonVariant variant;
  final Color? accent;
  final bool expand;
  final Sfx? sound;

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  var _pressed = false;

  void _handleTap() {
    unawaited(HapticFeedback.selectionClick());
    final sound = widget.sound;
    if (sound != null) unawaited(SoundScope.of(context).play(sound));
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final enabled = widget.onPressed != null;
    final filled = widget.variant == NeonButtonVariant.filled;
    final accent = enabled ? (widget.accent ?? colors.cyan) : colors.textMuted;
    final onAccent =
        ThemeData.estimateBrightnessForColor(accent) == Brightness.dark
        ? Colors.white
        : colors.background;
    final foreground = filled ? onAccent : accent;
    final shape = BeveledRectangleBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      side: filled ? BorderSide.none : BorderSide(color: accent, width: 1.4),
    );

    final content = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: 18, color: foreground),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                widget.label.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: Motion.fast,
      curve: Motion.enter,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: shape,
          shadows: filled && enabled
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.45 * colors.glow),
                    blurRadius: 18,
                    spreadRadius: -4,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: filled
              ? accent.withValues(alpha: enabled ? 1 : 0.25)
              : Colors.transparent,
          shape: shape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            customBorder: shape,
            onTap: enabled ? _handleTap : null,
            onHighlightChanged: (value) => setState(() => _pressed = value),
            splashColor: foreground.withValues(alpha: 0.16),
            highlightColor: foreground.withValues(alpha: 0.08),
            child: content,
          ),
        ),
      ),
    );
  }
}
