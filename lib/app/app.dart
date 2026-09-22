import 'dart:async';

import 'package:cat_directory_app/app/di/injection.dart';
import 'package:cat_directory_app/app/view/splash_overlay.dart';
import 'package:cat_directory_app/core/config/app_environment.dart';
import 'package:cat_directory_app/core/presentation/connectivity_cubit.dart';
import 'package:cat_directory_app/core/services/audio/sound_effects.dart';
import 'package:cat_directory_app/core/services/notifications/notification_service.dart';
import 'package:cat_directory_app/design_system/theme/neko_theme.dart';
import 'package:cat_directory_app/design_system/widgets/sound_scope.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/features/daily_breed/daily_breed_copy.dart';
import 'package:cat_directory_app/features/settings/domain/app_settings.dart';
import 'package:cat_directory_app/features/settings/presentation/settings_cubit.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NekoDexApp extends StatefulWidget {
  const NekoDexApp({
    required this.environment,
    required this.router,
    required this.sounds,
    required this.notifications,
    super.key,
  });

  final AppEnvironment environment;
  final GoRouter router;
  final SoundEffects sounds;
  final NotificationService notifications;

  @override
  State<NekoDexApp> createState() => _NekoDexAppState();
}

class _NekoDexAppState extends State<NekoDexApp> {
  // Viven por encima del router: la carga empieza mientras corre el splash y
  // el estado sobrevive a la navegacion.
  late final BreedsBloc _breeds = sl<BreedsBloc>()..add(const BreedsStarted());
  late final ConnectivityCubit _connectivity = sl<ConnectivityCubit>();
  late final SettingsCubit _settings = sl<SettingsCubit>();
  late final AppLifecycleListener _lifecycle;
  late final StreamSubscription<String> _notificationTaps;
  DateTime? _hiddenAt;
  var _rescheduled = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onHide: () => _hiddenAt = DateTime.now(),
      onShow: _onShow,
    );
    // Tocar una notificacion con la app abierta lleva a la ficha de la raza.
    _notificationTaps = widget.notifications.onOpenRoute.listen(
      widget.router.go,
    );
  }

  /// Si la app estuvo mucho rato en segundo plano, se revalida la cache al
  /// volver (el repositorio decide si de verdad hace falta ir a la red).
  void _onShow() {
    final hiddenAt = _hiddenAt;
    _hiddenAt = null;
    if (hiddenAt == null) return;
    final away = DateTime.now().difference(hiddenAt);
    if (away >= widget.environment.revalidateAfter) {
      _breeds.add(const BreedsRevalidateRequested());
    }
  }

  /// La raza del dia se reprograma con la primera lista buena de la sesion.
  void _onBreedsLoaded(BuildContext context, BreedsState state) {
    if (_rescheduled || !state.hasData) return;
    _rescheduled = true;
    unawaited(_settings.refreshDailyBreed(dailyBreedCopy(platformL10n())));
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    unawaited(_notificationTaps.cancel());
    unawaited(_breeds.close());
    unawaited(_connectivity.close());
    unawaited(_settings.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _breeds),
        BlocProvider.value(value: _connectivity),
        BlocProvider.value(value: _settings),
      ],
      child: SoundScope(
        sounds: widget.sounds,
        child: BlocListener<BreedsBloc, BreedsState>(
          listener: _onBreedsLoaded,
          child: BlocBuilder<SettingsCubit, AppSettings>(
            buildWhen: (previous, current) =>
                previous.theme != current.theme ||
                previous.performanceOverlay != current.performanceOverlay,
            builder: (context, settings) => MaterialApp.router(
              onGenerateTitle: (context) => context.l10n.appName,
              debugShowCheckedModeBanner: false,
              theme: NekoTheme.light(),
              darkTheme: NekoTheme.dark(),
              themeMode: switch (settings.theme) {
                ThemePreference.system => ThemeMode.system,
                ThemePreference.dark => ThemeMode.dark,
                ThemePreference.light => ThemeMode.light,
              },
              showPerformanceOverlay: settings.performanceOverlay,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: widget.router,
              builder: (context, child) => SplashOverlay(child: child!),
            ),
          ),
        ),
      ),
    );
  }
}
