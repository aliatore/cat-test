import 'dart:async';

import 'package:cat_directory_app/core/config/app_config.dart';
import 'package:cat_directory_app/core/error/failure.dart';
import 'package:cat_directory_app/core/presentation/failure_copy.dart';
import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/theme/neko_typography.dart';
import 'package:cat_directory_app/design_system/widgets/appear.dart';
import 'package:cat_directory_app/design_system/widgets/cyber_background.dart';
import 'package:cat_directory_app/design_system/widgets/glitch_text.dart';
import 'package:cat_directory_app/design_system/widgets/neko_snackbar.dart';
import 'package:cat_directory_app/design_system/widgets/neon_button.dart';
import 'package:cat_directory_app/design_system/widgets/state_view.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breed_detail_cubit.dart';
import 'package:cat_directory_app/features/breeds/presentation/widgets/breed_hologram.dart';
import 'package:cat_directory_app/features/breeds/presentation/widgets/breed_spec_grid.dart';
import 'package:cat_directory_app/features/breeds/presentation/widgets/breed_tile.dart';
import 'package:cat_directory_app/features/facts/presentation/widgets/fun_fact_card.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Ficha de una raza. Espera un [BreedDetailCubit] y un `CatFactBloc` en el
/// contexto; los pone el router.
class BreedDetailPage extends StatelessWidget {
  const BreedDetailPage({required this.onGoToDirectory, super.key});

  final VoidCallback onGoToDirectory;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<BreedDetailCubit>().state;
    final breed = switch (state) {
      BreedDetailLoaded(:final breed) => breed,
      _ => null,
    };

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).canPop()
              ? Navigator.of(context).pop()
              : onGoToDirectory(),
        ),
        actions: [
          if (breed != null)
            IconButton(
              tooltip: l10n.detailCopyLink,
              icon: const Icon(Icons.link_rounded),
              onPressed: () => _copyLink(context, breed),
            ),
          const SizedBox(width: 6),
        ],
      ),
      body: CyberBackground(
        child: switch (state) {
          BreedDetailLoaded(:final breed) => _DetailContent(breed: breed),
          BreedDetailLoading() => Center(
            child: StateView(art: StateArt.loading, title: l10n.detailLoading),
          ),
          BreedDetailFailure(:final failure) => _DetailFailure(
            failure: failure,
            onGoToDirectory: onGoToDirectory,
          ),
        },
      ),
    );
  }

  Future<void> _copyLink(BuildContext context, Breed breed) async {
    final message = context.l10n.detailLinkCopied;
    await Clipboard.setData(
      ClipboardData(text: AppConfig.breedLink(breed.slug).toString()),
    );
    if (!context.mounted) return;
    showNekoSnackBar(context, message: message, tone: NoticeTone.success);
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.breed});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final l10n = context.l10n;
    final media = MediaQuery.of(context);
    final serial = avatarSpecFor(
      breed,
    ).seed.toRadixString(16).toUpperCase().padLeft(8, '0').substring(0, 6);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        media.padding.top + kToolbarHeight,
        16,
        media.padding.bottom + 24,
      ),
      child: Column(
        children: [
          BreedHologram(breed: breed),
          const SizedBox(height: 12),
          Appear(
            delay: const Duration(milliseconds: 60),
            child: Semantics(
              header: true,
              label: breed.name,
              excludeSemantics: true,
              child: GlitchText(
                breed.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Appear(
            delay: const Duration(milliseconds: 90),
            child: Text(
              '${l10n.detailSerial('NX-$serial')}  ·  /breed/${breed.slug}',
              textAlign: TextAlign.center,
              style: NekoFonts.monoLabel(
                11.5,
              ).copyWith(color: colors.textMuted),
            ),
          ),
          const SizedBox(height: 22),
          BreedSpecGrid(breed: breed),
          const SizedBox(height: 14),
          const Appear(
            delay: Duration(milliseconds: 420),
            child: FunFactCard(),
          ),
        ],
      ),
    );
  }
}

class _DetailFailure extends StatelessWidget {
  const _DetailFailure({required this.failure, required this.onGoToDirectory});

  final Failure failure;
  final VoidCallback onGoToDirectory;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<BreedDetailCubit>();
    final goBack = NeonButton(
      label: l10n.detailGoToDirectory,
      icon: Icons.grid_view_rounded,
      variant: NeonButtonVariant.outlined,
      onPressed: onGoToDirectory,
    );

    if (failure is NotFoundFailure) {
      return Center(
        child: StateView(
          art: StateArt.empty,
          title: l10n.detailNotFoundTitle,
          message: l10n.detailNotFoundMessage,
          action: goBack,
        ),
      );
    }

    final copy = failureCopy(l10n, failure);
    return Center(
      child: StateView(
        art: copy.art,
        title: copy.title,
        message: copy.message,
        action: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            NeonButton(
              label: l10n.retry,
              icon: Icons.refresh_rounded,
              onPressed: () => unawaited(cubit.load()),
            ),
            goBack,
          ],
        ),
      ),
    );
  }
}
