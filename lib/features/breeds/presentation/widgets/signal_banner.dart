import 'package:cat_directory_app/core/presentation/connectivity_cubit.dart';
import 'package:cat_directory_app/core/presentation/relative_time.dart';
import 'package:cat_directory_app/design_system/theme/motion.dart';
import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/widgets/neon_panel.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Franja que explica que pasa con la red: sin conexion (y de cuando son los
/// datos que se ven) o reconectando, con el numero de intento.
class SignalBanner extends StatelessWidget {
  const SignalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final l10n = context.l10n;
    final connection = context.watch<ConnectivityCubit>().state;
    final (hasData, updatedAt) = context.select<BreedsBloc, (bool, DateTime?)>(
      (b) => (b.state.hasData, b.state.updatedAt),
    );
    final retry = connection.retry;

    (String, Color, IconData)? content;
    if (retry != null) {
      content = (
        l10n.bannerRetrying(retry.attempt, retry.maxRetries),
        colors.cyan,
        Icons.sync_rounded,
      );
    } else if (!connection.online && hasData) {
      content = (
        l10n.bannerOffline(relativeAge(l10n, updatedAt)),
        colors.yellow,
        Icons.cloud_off_rounded,
      );
    } else if (!connection.online) {
      content = (
        l10n.bannerOfflineEmpty,
        colors.magenta,
        Icons.wifi_off_rounded,
      );
    }

    return AnimatedSize(
      duration: Motion.medium,
      curve: Motion.enter,
      alignment: Alignment.topCenter,
      child: content == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 2),
              child: Semantics(
                liveRegion: true,
                container: true,
                child: NeonPanel(
                  accent: content.$2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Icon(content.$3, size: 18, color: content.$2),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          content.$1,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
