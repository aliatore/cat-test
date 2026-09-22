import 'package:cat_directory_app/design_system/theme/motion.dart';
import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum StateArt {
  offline('assets/lottie/offline.json', Icons.wifi_off_rounded),
  empty('assets/lottie/empty.json', Icons.nightlight_round),
  loading('assets/lottie/loader.json', Icons.hourglass_top_rounded)
  ;

  const StateArt(this.asset, this.fallbackIcon);

  final String asset;
  final IconData fallbackIcon;
}

/// Pantalla de estado (vacio, error, sin red) con su animacion. Es una
/// region "viva": los lectores de pantalla la anuncian cuando aparece.
class StateView extends StatelessWidget {
  const StateView({
    required this.art,
    required this.title,
    required this.message,
    this.action,
    this.compact = false,
    super.key,
  });

  final StateArt art;
  final String title;
  final String message;
  final Widget? action;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final theme = Theme.of(context);
    final reduced = Motion.reduced(context);
    final size = compact ? 110.0 : 168.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Lottie.asset(
              art.asset,
              width: size,
              height: size,
              animate: !reduced,
              errorBuilder: (_, _, _) =>
                  Icon(art.fallbackIcon, size: size * 0.5, color: colors.cyan),
            ),
          ),
          const SizedBox(height: 18),
          Semantics(
            liveRegion: true,
            container: true,
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (action != null) ...[const SizedBox(height: 22), action!],
        ],
      ),
    );
  }
}
