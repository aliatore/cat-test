import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cat_directory_app/app/app.dart';
import 'package:cat_directory_app/app/di/injection.dart';
import 'package:cat_directory_app/app/router/app_router.dart';
import 'package:cat_directory_app/core/services/audio/sound_effects.dart';
import 'package:cat_directory_app/core/utils/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  PlatformDispatcher.instance.onError = (error, stack) {
    logDebug('app', 'error no capturado', error: '$error\n$stack');
    return true;
  };
  if (kDebugMode) Bloc.observer = const _LogBlocObserver();

  await configureDependencies();

  final sounds = sl<SoundEffects>();
  unawaited(sounds.preload());

  runApp(NekoDexApp(router: buildRouter(), sounds: sounds));
}

class _LogBlocObserver extends BlocObserver {
  const _LogBlocObserver();

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    logDebug('bloc', '${bloc.runtimeType} <- ${event.runtimeType}');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logDebug('bloc', '${bloc.runtimeType} fallo', error: '$error\n$stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
