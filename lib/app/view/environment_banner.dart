import 'package:cat_directory_app/core/config/app_environment.dart';
import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/theme/neko_typography.dart';
import 'package:flutter/widgets.dart';

/// Cinta en la esquina con el ambiente, para que una captura o un reporte de
/// QA no se confunda con la app publicada. En prod no dibuja nada.
class EnvironmentBanner extends StatelessWidget {
  const EnvironmentBanner({
    required this.environment,
    required this.child,
    super.key,
  });

  final AppEnvironment environment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (environment.isProduction) return child;

    // Colores fijos: la cinta se ve igual en modo claro y oscuro.
    const colors = NekoColors.dark;
    final accent = environment == AppEnvironment.dev
        ? colors.cyan
        : colors.yellow;
    return Banner(
      message: environment.label,
      location: BannerLocation.topEnd,
      color: accent.withValues(alpha: 0.9),
      textStyle: NekoFonts.orbitron(
        9,
        FontWeight.w700,
      ).copyWith(color: colors.background, height: 1),
      child: child,
    );
  }
}
