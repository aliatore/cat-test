import 'package:cat_directory_app/design_system/theme/neko_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Etiqueta de estado tipo terminal: `● LIVE`, `● CACHE`, `● OFFLINE`.
class StatusChip extends StatelessWidget {
  const StatusChip({
    required this.label,
    required this.color,
    this.pulsing = false,
    super.key,
  });

  final String label;
  final Color color;
  final bool pulsing;

  @override
  Widget build(BuildContext context) {
    Widget dot = Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.7), blurRadius: 6),
        ],
      ),
    );
    if (pulsing && !(MediaQuery.maybeDisableAnimationsOf(context) ?? false)) {
      dot = dot
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .fade(begin: 1, end: 0.25, duration: 700.ms);
    }

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.08),
        shape: BeveledRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
          side: BorderSide(color: color.withValues(alpha: 0.55)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            dot,
            const SizedBox(width: 7),
            Text(
              label.toUpperCase(),
              style: NekoFonts.monoLabel(11.5).copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
