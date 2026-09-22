import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/widgets/neon_panel.dart';
import 'package:cat_directory_app/design_system/widgets/skeleton.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Esqueleto con la misma forma que las filas reales, para que al llegar los
/// datos no salte nada de sitio.
class BreedsSkeleton extends StatelessWidget {
  const BreedsSkeleton({this.count = 7, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    return Semantics(
      label: context.l10n.loadingBreeds,
      liveRegion: true,
      excludeSemantics: true,
      child: Column(
        children: [
          for (var i = 0; i < count; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: NeonPanel(
                accent: colors.outline,
                brackets: false,
                padding: const EdgeInsets.all(12),
                child: NeonShimmer(
                  child: Row(
                    children: [
                      const SkeletonBox(width: 50, height: 50, cut: 8),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonBox(
                              width: 120.0 + (i % 3) * 36,
                              height: 15,
                            ),
                            const SizedBox(height: 9),
                            const SkeletonBox(width: 88, height: 11),
                          ],
                        ),
                      ),
                      const SkeletonBox(width: 30, height: 11),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
