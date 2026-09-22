import 'dart:async';

import 'package:cat_directory_app/core/services/audio/sound_effects.dart';
import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/widgets/sound_scope.dart';
import 'package:flutter/material.dart';

enum NoticeTone { info, success, warning, error }

void showNekoSnackBar(
  BuildContext context, {
  required String message,
  NoticeTone tone = NoticeTone.info,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 4),
}) {
  final colors = context.neko;
  final (color, icon) = switch (tone) {
    NoticeTone.info => (colors.cyan, Icons.info_outline_rounded),
    NoticeTone.success => (colors.mint, Icons.check_circle_outline_rounded),
    NoticeTone.warning => (colors.yellow, Icons.cloud_off_rounded),
    NoticeTone.error => (colors.magenta, Icons.error_outline_rounded),
  };
  final sound = switch (tone) {
    NoticeTone.success => Sfx.success,
    NoticeTone.warning || NoticeTone.error => Sfx.glitch,
    NoticeTone.info => null,
  };
  if (sound != null) unawaited(SoundScope.of(context).play(sound));

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: duration,
        shape: BeveledRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          side: BorderSide(color: color.withValues(alpha: 0.6)),
        ),
        content: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        action: actionLabel == null || onAction == null
            ? null
            : SnackBarAction(
                label: actionLabel.toUpperCase(),
                textColor: color,
                onPressed: onAction,
              ),
      ),
    );
}
