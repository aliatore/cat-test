import 'package:cat_directory_app/app/di/injection.dart';
import 'package:cat_directory_app/app/view/splash_overlay.dart';
import 'package:cat_directory_app/core/config/app_config.dart';
import 'package:cat_directory_app/core/presentation/connectivity_cubit.dart';
import 'package:cat_directory_app/core/services/audio/sound_effects.dart';
import 'package:cat_directory_app/design_system/theme/neko_theme.dart';
import 'package:cat_directory_app/design_system/widgets/sound_scope.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NekoDexApp extends StatefulWidget {
  const NekoDexApp({required this.router, required this.sounds, super.key});

  final GoRouter router;
  final SoundEffects sounds;

  @override
  State<NekoDexApp> createState() => _NekoDexAppState();
}

class _NekoDexAppState extends State<NekoDexApp> {
  // Viven por encima del router: la carga empieza mientras corre el splash y
  // el estado sobrevive a la navegacion.
  late final BreedsBloc _breeds = sl<BreedsBloc>()..add(const BreedsStarted());
  late final ConnectivityCubit _connectivity = sl<ConnectivityCubit>();
  late final AppLifecycleListener _lifecycle;
  DateTime? _hiddenAt;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onHide: () => _hiddenAt = DateTime.now(),
      onShow: _onShow,
    );
  }

  /// Si la app estuvo mucho rato en segundo plano, se revalida la cache al
  /// volver (el repositorio decide si de verdad hace falta ir a la red).
  void _onShow() {
    final hiddenAt = _hiddenAt;
    _hiddenAt = null;
    if (hiddenAt == null) return;
    if (DateTime.now().difference(hiddenAt) >= AppConfig.revalidateAfter) {
      _breeds.add(const BreedsRevalidateRequested());
    }
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _breeds.close().ignore();
    _connectivity.close().ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _breeds),
        BlocProvider.value(value: _connectivity),
      ],
      child: SoundScope(
        sounds: widget.sounds,
        child: MaterialApp.router(
          onGenerateTitle: (context) => context.l10n.appName,
          debugShowCheckedModeBanner: false,
          theme: NekoTheme.light(),
          darkTheme: NekoTheme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: widget.router,
          builder: (context, child) => SplashOverlay(child: child!),
        ),
      ),
    );
  }
}
