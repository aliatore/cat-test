import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/theme/neko_typography.dart';
import 'package:cat_directory_app/design_system/widgets/neon_button.dart';
import 'package:cat_directory_app/design_system/widgets/neon_panel.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Pie de la lista: cargando la siguiente pagina, error recuperable,
/// "cargar mas" mientras se busca, o fin del directorio.
class PaginationFooter extends StatelessWidget {
  const PaginationFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BreedsBloc>().state;
    final colors = context.neko;
    final l10n = context.l10n;
    final bloc = context.read<BreedsBloc>();

    if (state.status != BreedsStatus.success) {
      return const SizedBox(height: 24);
    }

    final Widget child;
    if (state.isLoadingMore) {
      child = Semantics(
        liveRegion: true,
        label: l10n.paginationLoading,
        excludeSemantics: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.cyan,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.paginationLoading,
              style: NekoFonts.monoLabel(
                12.5,
              ).copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      );
    } else if (state.paginationFailure != null) {
      child = NeonPanel(
        accent: colors.magenta,
        child: Column(
          children: [
            Semantics(
              liveRegion: true,
              child: Row(
                children: [
                  Icon(Icons.signal_wifi_off_rounded, color: colors.magenta),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l10n.paginationError)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            NeonButton(
              label: l10n.retry,
              icon: Icons.refresh_rounded,
              variant: NeonButtonVariant.outlined,
              accent: colors.magenta,
              expand: true,
              onPressed: () => bloc.add(const BreedsRetryRequested()),
            ),
          ],
        ),
      );
    } else if (state.isSearching && !state.hasReachedMax) {
      child = Column(
        children: [
          Text(
            l10n.searchScope(state.breeds.length),
            textAlign: TextAlign.center,
            style: NekoFonts.monoLabel(
              12,
            ).copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 12),
          NeonButton(
            label: l10n.searchLoadMore,
            icon: Icons.downloading_rounded,
            variant: NeonButtonVariant.outlined,
            onPressed: () => bloc.add(const BreedsNextPageRequested()),
          ),
        ],
      );
    } else if (state.hasReachedMax) {
      child = Row(
        children: [
          Expanded(child: Divider(color: colors.outline)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              l10n.endOfList(state.total).toUpperCase(),
              style: NekoFonts.monoLabel(
                11.5,
              ).copyWith(color: colors.textMuted),
            ),
          ),
          Expanded(child: Divider(color: colors.outline)),
        ],
      );
    } else {
      return const SizedBox(height: 72);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: child,
    );
  }
}
