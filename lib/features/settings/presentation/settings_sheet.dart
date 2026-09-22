import 'dart:async';

import 'package:cat_directory_app/core/config/app_config.dart';
import 'package:cat_directory_app/core/config/app_environment.dart';
import 'package:cat_directory_app/core/presentation/relative_time.dart';
import 'package:cat_directory_app/core/services/audio/sound_effects.dart';
import 'package:cat_directory_app/design_system/theme/motion.dart';
import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/theme/neko_typography.dart';
import 'package:cat_directory_app/design_system/widgets/neon_button.dart';
import 'package:cat_directory_app/design_system/widgets/neon_panel.dart';
import 'package:cat_directory_app/design_system/widgets/sound_scope.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_cache_cubit.dart';
import 'package:cat_directory_app/features/daily_breed/daily_breed_copy.dart';
import 'package:cat_directory_app/features/daily_breed/daily_breed_scheduler.dart';
import 'package:cat_directory_app/features/settings/domain/app_settings.dart';
import 'package:cat_directory_app/features/settings/presentation/settings_cubit.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showSettingsSheet(
  BuildContext context, {
  required BreedsCacheCubit cache,
}) async {
  cache.refresh();
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) =>
        BlocProvider.value(value: cache, child: const SettingsSheet()),
  );
  await cache.close();
}

class SettingsSheet extends StatefulWidget {
  const SettingsSheet({super.key});

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  // Los avisos van dentro de la hoja: un snackbar quedaria tapado por ella.
  ({String text, Color color, bool offerSettings})? _notice;

  void _say(String text, Color color, {bool offerSettings = false}) => setState(
    () => _notice = (
      text: text,
      color: color,
      offerSettings: offerSettings,
    ),
  );

  void _tick() => unawaited(SoundScope.of(context).play(Sfx.tap));

  Future<void> _toggleDailyBreed({required bool enabled}) async {
    _tick();
    final l10n = context.l10n;
    final colors = context.neko;
    final outcome = await context.read<SettingsCubit>().setDailyBreed(
      enabled: enabled,
      copy: dailyBreedCopy(l10n),
    );
    if (!mounted) return;
    switch (outcome) {
      case NotificationOutcome.permissionDenied:
        _say(
          l10n.settingsNotificationsDenied,
          colors.magenta,
          offerSettings: true,
        );
      case NotificationOutcome.noBreedsYet:
        _say(l10n.settingsNoBreedsYet, colors.yellow);
      case NotificationOutcome.done:
        if (enabled) _say(l10n.settingsDailyBreedOn, colors.mint);
    }
  }

  Future<void> _sendTest() async {
    final l10n = context.l10n;
    final colors = context.neko;
    final outcome = await context.read<SettingsCubit>().sendTestNotification(
      dailyBreedCopy(l10n),
    );
    if (!mounted) return;
    switch (outcome) {
      case NotificationOutcome.permissionDenied:
        _say(
          l10n.settingsNotificationsDenied,
          colors.magenta,
          offerSettings: true,
        );
      case NotificationOutcome.noBreedsYet:
        _say(l10n.settingsNoBreedsYet, colors.yellow);
      case NotificationOutcome.done:
        _say(l10n.settingsTestNotificationSent, colors.mint);
    }
  }

  Future<void> _clearCache() async {
    final l10n = context.l10n;
    final colors = context.neko;
    final breeds = context.read<BreedsBloc>();
    await context.read<BreedsCacheCubit>().clear();
    breeds.add(const BreedsRefreshRequested());
    if (mounted) _say(l10n.settingsCacheCleared, colors.cyan);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.neko;
    final settings = context.watch<SettingsCubit>().state;
    final cubit = context.read<SettingsCubit>();
    final cache = context.watch<BreedsCacheCubit>().state;
    final time = MaterialLocalizations.of(context).formatTimeOfDay(
      const TimeOfDay(hour: DailyBreedScheduler.hour, minute: 0),
    );
    final notice = _notice;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.settingsTitle.toUpperCase(),
              style: NekoFonts.orbitron(
                20,
                FontWeight.w700,
              ).copyWith(color: colors.textPrimary),
            ),
          ),
          const SizedBox(height: 22),
          _Label(l10n.settingsTheme),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ThemePreference>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: ThemePreference.system,
                  label: Text(l10n.themeSystem),
                  icon: const Icon(Icons.brightness_auto_rounded, size: 18),
                ),
                ButtonSegment(
                  value: ThemePreference.dark,
                  label: Text(l10n.themeDark),
                  icon: const Icon(Icons.dark_mode_rounded, size: 18),
                ),
                ButtonSegment(
                  value: ThemePreference.light,
                  label: Text(l10n.themeLight),
                  icon: const Icon(Icons.light_mode_rounded, size: 18),
                ),
              ],
              selected: {settings.theme},
              onSelectionChanged: (selection) {
                _tick();
                unawaited(cubit.setTheme(selection.first));
              },
            ),
          ),
          const SizedBox(height: 18),
          _SwitchRow(
            icon: Icons.graphic_eq_rounded,
            title: l10n.settingsSound,
            subtitle: l10n.settingsSoundDescription,
            value: settings.soundEnabled,
            onChanged: (value) async {
              await cubit.setSound(enabled: value);
              if (value) _tick();
            },
          ),
          _SwitchRow(
            icon: Icons.notifications_active_outlined,
            title: l10n.settingsDailyBreed,
            subtitle: l10n.settingsDailyBreedDescription(time),
            value: settings.dailyBreed,
            onChanged: (value) => _toggleDailyBreed(enabled: value),
          ),
          const SizedBox(height: 6),
          NeonButton(
            label: l10n.settingsTestNotification,
            icon: Icons.send_rounded,
            variant: NeonButtonVariant.outlined,
            onPressed: _sendTest,
          ),
          AnimatedSize(
            duration: Motion.medium,
            curve: Motion.enter,
            child: notice == null
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Semantics(
                      liveRegion: true,
                      child: NeonPanel(
                        accent: notice.color,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notice.text),
                            if (notice.offerSettings) ...[
                              const SizedBox(height: 10),
                              NeonButton(
                                label: l10n.settingsOpenSystemSettings,
                                icon: Icons.open_in_new_rounded,
                                variant: NeonButtonVariant.outlined,
                                accent: notice.color,
                                onPressed: cubit.openSystemNotificationSettings,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 24),
          _Label(l10n.settingsCache),
          const SizedBox(height: 10),
          NeonPanel(
            accent: colors.yellow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cache.pages == 0
                      ? l10n.settingsCacheEmpty
                      : l10n.settingsCacheSummary(
                          cache.breeds,
                          cache.pages,
                          relativeAge(l10n, cache.lastUpdated),
                        ),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.settingsCachePolicy,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                NeonButton(
                  label: l10n.settingsClearCache,
                  icon: Icons.delete_sweep_outlined,
                  variant: NeonButtonVariant.outlined,
                  accent: colors.magenta,
                  sound: Sfx.glitch,
                  onPressed: cache.pages == 0 ? null : _clearCache,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SwitchRow(
            icon: Icons.speed_rounded,
            title: l10n.settingsPerformanceOverlay,
            subtitle: l10n.settingsPerformanceOverlayDescription,
            value: settings.performanceOverlay,
            onChanged: (value) {
              _tick();
              unawaited(cubit.setPerformanceOverlay(enabled: value));
            },
          ),
          const SizedBox(height: 22),
          Center(
            child: Text(
              l10n.settingsAbout(AppConfig.versionFor(AppEnvironment.current)),
              style: NekoFonts.monoLabel(11).copyWith(color: colors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: NekoFonts.monoLabel(12).copyWith(color: context.neko.cyan),
  );
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    // MergeSemantics: el lector anuncia titulo, descripcion y estado del
    // interruptor como un solo control.
    return MergeSemantics(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: value ? colors.cyan : colors.textMuted),
        title: Text(title, style: Theme.of(context).textTheme.titleSmall),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: Switch(value: value, onChanged: onChanged),
        onTap: () => onChanged(!value),
      ),
    );
  }
}
