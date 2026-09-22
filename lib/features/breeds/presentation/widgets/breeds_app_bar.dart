import 'package:cat_directory_app/core/domain/data_origin.dart';
import 'package:cat_directory_app/core/presentation/connectivity_cubit.dart';
import 'package:cat_directory_app/design_system/theme/motion.dart';
import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/theme/neko_typography.dart';
import 'package:cat_directory_app/design_system/widgets/glitch_text.dart';
import 'package:cat_directory_app/design_system/widgets/status_chip.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/features/breeds/presentation/widgets/breed_search_field.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BreedsAppBar extends StatelessWidget {
  const BreedsAppBar({this.onOpenSettings, super.key});

  static const toolbarHeight = 60.0;
  static const searchHeight = 76.0;

  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final l10n = context.l10n;
    final top = MediaQuery.paddingOf(context).top;

    return SliverAppBar(
      pinned: true,
      toolbarHeight: toolbarHeight,
      expandedHeight: toolbarHeight + 34 + searchHeight,
      backgroundColor: colors.background,
      titleSpacing: 16,
      title: Semantics(
        header: true,
        label: l10n.appName,
        excludeSemantics: true,
        child: GlitchText(
          'NEKO//DEX',
          style: NekoFonts.orbitron(
            22,
            FontWeight.w800,
          ).copyWith(color: colors.textPrimary),
        ),
      ),
      actions: [
        const _DataStatusChip(),
        if (onOpenSettings != null)
          IconButton(
            tooltip: l10n.settingsTooltip,
            onPressed: onOpenSettings,
            icon: const Icon(Icons.tune_rounded),
          ),
        const SizedBox(width: 6),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Padding(
          padding: EdgeInsets.fromLTRB(16, top + toolbarHeight - 4, 16, 0),
          child: const Align(alignment: Alignment.topLeft, child: _Tagline()),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(searchHeight),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: BreedSearchField(),
            ),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors.cyan.withValues(alpha: 0),
                    colors.cyan.withValues(alpha: 0.6),
                    colors.magenta.withValues(alpha: 0.6),
                    colors.magenta.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tagline extends StatelessWidget {
  const _Tagline();

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final l10n = context.l10n;
    final total = context.select<BreedsBloc, int>((bloc) => bloc.state.total);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: l10n.directoryTagline.toUpperCase(),
            style: TextStyle(color: colors.cyan),
          ),
          if (total > 0) TextSpan(text: '  ·  ${l10n.directoryCount(total)}'),
        ],
      ),
      style: NekoFonts.monoLabel(12.5).copyWith(color: colors.textSecondary),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _DataStatusChip extends StatelessWidget {
  const _DataStatusChip();

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final l10n = context.l10n;
    final (online, retrying) = context.select<ConnectivityCubit, (bool, bool)>(
      (c) => (c.state.online, c.state.retry != null),
    );
    final (status, origin, refreshing) = context
        .select<BreedsBloc, (BreedsStatus, DataOrigin?, bool)>(
          (b) => (b.state.status, b.state.origin, b.state.isRefreshing),
        );

    (String, Color, bool)? chip;
    if (!online) {
      chip = (l10n.statusOffline, colors.magenta, false);
    } else if (retrying || refreshing || status == BreedsStatus.loading) {
      chip = (l10n.statusSyncing, colors.cyan, true);
    } else if (origin == DataOrigin.cache) {
      chip = (l10n.statusCache, colors.yellow, false);
    } else if (origin == DataOrigin.remote) {
      chip = (l10n.statusLive, colors.mint, false);
    }

    return AnimatedSwitcher(
      duration: Motion.medium,
      child: chip == null
          ? const SizedBox.shrink()
          : Semantics(
              key: ValueKey(chip.$1),
              liveRegion: true,
              label: l10n.statusSemantics(chip.$1),
              excludeSemantics: true,
              child: StatusChip(
                label: chip.$1,
                color: chip.$2,
                pulsing: chip.$3,
              ),
            ),
    );
  }
}
