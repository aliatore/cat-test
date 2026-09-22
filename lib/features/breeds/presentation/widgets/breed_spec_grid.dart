import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/theme/neko_typography.dart';
import 'package:cat_directory_app/design_system/widgets/appear.dart';
import 'package:cat_directory_app/design_system/widgets/neon_panel.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Ficha tecnica: pais, origen, pelaje y patron en una cuadricula 2x2.
class BreedSpecGrid extends StatelessWidget {
  const BreedSpecGrid({required this.breed, super.key});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final l10n = context.l10n;

    final cells = [
      (l10n.detailCountry, breed.country, Icons.public_rounded, colors.cyan),
      (l10n.detailOrigin, breed.origin, Icons.biotech_outlined, colors.magenta),
      (l10n.detailCoat, breed.coat, Icons.waves_rounded, colors.yellow),
      (l10n.detailPattern, breed.pattern, Icons.blur_on_rounded, colors.purple),
    ];

    Widget cell(int i) {
      final (label, value, icon, accent) = cells[i];
      return Appear(
        delay: Duration(milliseconds: 120 + 70 * i),
        child: _SpecCell(
          label: label,
          value: value ?? l10n.unknownValue,
          icon: icon,
          accent: accent,
        ),
      );
    }

    return Column(
      children: [
        for (final row in [
          [0, 1],
          [2, 3],
        ]) ...[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: cell(row[0])),
                const SizedBox(width: 10),
                Expanded(child: cell(row[1])),
              ],
            ),
          ),
          if (row.first == 0) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _SpecCell extends StatelessWidget {
  const _SpecCell({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: NeonPanel(
        accent: accent,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: accent),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: NekoFonts.monoLabel(11.5).copyWith(color: accent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}
