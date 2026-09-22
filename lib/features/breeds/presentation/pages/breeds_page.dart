import 'dart:async';

import 'package:cat_directory_app/core/error/failure.dart';
import 'package:cat_directory_app/core/presentation/failure_copy.dart';
import 'package:cat_directory_app/core/services/audio/sound_effects.dart';
import 'package:cat_directory_app/design_system/theme/motion.dart';
import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/theme/neko_typography.dart';
import 'package:cat_directory_app/design_system/widgets/appear.dart';
import 'package:cat_directory_app/design_system/widgets/cyber_background.dart';
import 'package:cat_directory_app/design_system/widgets/neko_snackbar.dart';
import 'package:cat_directory_app/design_system/widgets/neon_button.dart';
import 'package:cat_directory_app/design_system/widgets/sound_scope.dart';
import 'package:cat_directory_app/design_system/widgets/state_view.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/features/breeds/presentation/widgets/breed_tile.dart';
import 'package:cat_directory_app/features/breeds/presentation/widgets/breeds_app_bar.dart';
import 'package:cat_directory_app/features/breeds/presentation/widgets/breeds_skeleton.dart';
import 'package:cat_directory_app/features/breeds/presentation/widgets/pagination_footer.dart';
import 'package:cat_directory_app/features/breeds/presentation/widgets/signal_banner.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BreedsPage extends StatefulWidget {
  const BreedsPage({
    required this.onOpenBreed,
    this.onOpenSettings,
    super.key,
  });

  /// La navegacion la decide el router; la pantalla solo avisa.
  final ValueChanged<Breed> onOpenBreed;
  final VoidCallback? onOpenSettings;

  @override
  State<BreedsPage> createState() => _BreedsPageState();
}

class _BreedsPageState extends State<BreedsPage> {
  /// Se pide la pagina siguiente cuando quedan menos de ~8 filas por debajo,
  /// para que llegue antes de que el usuario toque fondo.
  static const _prefetchExtent = 700.0;

  final _scroll = ScrollController();

  /// Las filas ya vistas no vuelven a animar al hacer scroll hacia arriba.
  final _appeared = <String>{};
  var _firstBatch = true;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_maybeLoadMore);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _maybeLoadMore() {
    if (!_scroll.hasClients) return;
    final bloc = context.read<BreedsBloc>();
    final state = bloc.state;
    // Si la ultima pagina fallo no se reintenta con cada pixel de scroll: lo
    // hace el boton del pie o la vuelta de la conexion.
    if (state.status != BreedsStatus.success ||
        state.isSearching ||
        state.isLoadingMore ||
        state.isRefreshing ||
        state.hasReachedMax ||
        state.paginationFailure != null) {
      return;
    }
    if (_scroll.position.extentAfter < _prefetchExtent) {
      bloc.add(const BreedsNextPageRequested());
    }
  }

  Future<void> _refresh() async {
    final bloc = context.read<BreedsBloc>();
    const limit = Duration(seconds: 20);
    if (!bloc.state.isRefreshing) {
      bloc.add(const BreedsRefreshRequested());
      await bloc.stream
          .firstWhere((s) => s.isRefreshing)
          .timeout(limit, onTimeout: () => bloc.state);
    }
    await bloc.stream
        .firstWhere((s) => !s.isRefreshing)
        .timeout(limit, onTimeout: () => bloc.state);
  }

  void _open(Breed breed) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(SoundScope.of(context).play(Sfx.tap));
    FocusManager.instance.primaryFocus?.unfocus();
    widget.onOpenBreed(breed);
  }

  void _showNotice(BreedsNotice notice) {
    final l10n = context.l10n;
    final bloc = context.read<BreedsBloc>();
    final rateLimited = notice.failure is RateLimitedFailure;
    switch (notice.kind) {
      case BreedsNoticeKind.showingCache:
        showNekoSnackBar(
          context,
          tone: NoticeTone.warning,
          message: rateLimited
              ? l10n.noticeRateLimited
              : l10n.noticeShowingCache,
        );
      case BreedsNoticeKind.refreshFailed:
        showNekoSnackBar(
          context,
          tone: NoticeTone.warning,
          message: rateLimited
              ? l10n.noticeRateLimited
              : l10n.noticeRefreshFailed,
          actionLabel: l10n.retry,
          onAction: () => bloc.add(const BreedsRefreshRequested()),
        );
      case BreedsNoticeKind.backOnline:
        showNekoSnackBar(
          context,
          tone: NoticeTone.success,
          message: l10n.noticeBackOnline,
        );
      case BreedsNoticeKind.refreshed:
        unawaited(SoundScope.of(context).play(Sfx.success));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final media = MediaQuery.of(context);

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<BreedsBloc, BreedsState>(
            listenWhen: (previous, current) =>
                current.notice != null &&
                previous.notice?.id != current.notice?.id,
            listener: (context, state) => _showNotice(state.notice!),
          ),
          // Resultados nuevos arrancan arriba; si no, los primeros pueden
          // quedar escondidos bajo la barra fija.
          BlocListener<BreedsBloc, BreedsState>(
            listenWhen: (previous, current) => previous.query != current.query,
            listener: (context, state) {
              if (_scroll.hasClients && _scroll.offset > 0) {
                unawaited(
                  _scroll.animateTo(
                    0,
                    duration: Motion.medium,
                    curve: Motion.enter,
                  ),
                );
              }
            },
          ),
          // Si la pantalla es alta y la primera pagina no la llena, no hay
          // scroll que dispare la siguiente: se revisa tras cada carga.
          BlocListener<BreedsBloc, BreedsState>(
            listenWhen: (previous, current) =>
                previous.breeds.length != current.breeds.length ||
                previous.status != current.status,
            listener: (context, state) =>
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _maybeLoadMore(),
                ),
          ),
        ],
        child: CyberBackground(
          child: RefreshIndicator(
            onRefresh: _refresh,
            color: colors.cyan,
            backgroundColor: colors.surfaceRaised,
            edgeOffset:
                media.padding.top +
                BreedsAppBar.toolbarHeight +
                BreedsAppBar.searchHeight,
            child: CustomScrollView(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                BreedsAppBar(onOpenSettings: widget.onOpenSettings),
                const SliverToBoxAdapter(child: SignalBanner()),
                BlocBuilder<BreedsBloc, BreedsState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status ||
                      previous.visible != current.visible ||
                      previous.failure != current.failure ||
                      previous.query != current.query,
                  builder: _content,
                ),
                const SliverToBoxAdapter(child: PaginationFooter()),
                SliverToBoxAdapter(
                  child: SizedBox(height: media.padding.bottom + 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, BreedsState state) {
    final l10n = context.l10n;
    final bloc = context.read<BreedsBloc>();

    if (!state.hasData) {
      if (state.status == BreedsStatus.failure && state.failure != null) {
        final copy = failureCopy(l10n, state.failure!);
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: StateView(
              art: copy.art,
              title: copy.title,
              message: copy.message,
              action: NeonButton(
                label: l10n.retry,
                icon: Icons.refresh_rounded,
                onPressed: () => bloc.add(const BreedsRetryRequested()),
              ),
            ),
          ),
        );
      }
      return const SliverPadding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        sliver: SliverToBoxAdapter(child: BreedsSkeleton()),
      );
    }

    if (state.visible.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: StateView(
          art: StateArt.empty,
          compact: true,
          title: l10n.emptySearchTitle(state.query),
          message: l10n.emptySearchMessage,
        ),
      );
    }

    final firstBatch = _firstBatch;
    if (firstBatch) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _firstBatch = false);
    }

    return SliverMainAxisGroup(
      slivers: [
        if (state.isSearching)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
            sliver: SliverToBoxAdapter(
              child: Semantics(
                liveRegion: true,
                child: Text(
                  l10n.searchResults(state.visible.length).toUpperCase(),
                  style: NekoFonts.monoLabel(
                    12,
                  ).copyWith(color: context.neko.cyan),
                ),
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          sliver: SliverPrototypeExtentList.builder(
            prototypeItem: BreedTile.prototype,
            itemCount: state.visible.length,
            itemBuilder: (context, index) {
              final breed = state.visible[index];
              final tile = BreedTile(
                key: ValueKey(breed.slug),
                breed: breed,
                number: breedNumber(state, index),
                query: state.query,
                onTap: () => _open(breed),
              );
              if (!_appeared.add(breed.slug)) return tile;
              return Appear(
                delay: firstBatch
                    ? Duration(milliseconds: 45 * index.clamp(0, 10))
                    : Duration.zero,
                child: tile,
              );
            },
          ),
        ),
      ],
    );
  }
}
