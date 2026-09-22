import 'package:cat_directory_app/design_system/widgets/cyber_background.dart';
import 'package:cat_directory_app/design_system/widgets/neon_button.dart';
import 'package:cat_directory_app/design_system/widgets/state_view.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class RouteNotFoundPage extends StatelessWidget {
  const RouteNotFoundPage({
    required this.path,
    required this.onGoHome,
    super.key,
  });

  final String path;
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: CyberBackground(
        child: Center(
          child: StateView(
            art: StateArt.empty,
            title: l10n.routeNotFoundTitle,
            message: l10n.routeNotFoundMessage(path),
            action: NeonButton(
              label: l10n.detailGoToDirectory,
              icon: Icons.grid_view_rounded,
              onPressed: onGoHome,
            ),
          ),
        ),
      ),
    );
  }
}
