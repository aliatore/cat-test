import 'dart:async';

import 'package:cat_directory_app/app/di/injection.dart';
import 'package:cat_directory_app/app/view/route_not_found_page.dart';
import 'package:cat_directory_app/core/utils/slug.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breed_detail_cubit.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_cache_cubit.dart';
import 'package:cat_directory_app/features/breeds/presentation/pages/breed_detail_page.dart';
import 'package:cat_directory_app/features/breeds/presentation/pages/breeds_page.dart';
import 'package:cat_directory_app/features/facts/presentation/bloc/cat_fact_bloc.dart';
import 'package:cat_directory_app/features/settings/presentation/settings_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const directory = 'directory';
  static const breed = 'breed';

  static String breedPath(String slug) => '/breed/$slug';
}

/// `/breed/:name` es una sub-ruta de `/`: al abrir un deep link la pila queda
/// [directorio, detalle] y "atras" lleva al listado en vez de cerrar la app.
GoRouter buildRouter({String? initialLocation}) {
  return GoRouter(
    initialLocation: initialLocation ?? '/',
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        path: '/',
        name: AppRoutes.directory,
        builder: (context, state) => BreedsPage(
          onOpenSettings: () => showSettingsSheet(
            context,
            cache: sl<BreedsCacheCubit>(),
          ),
          onOpenBreed: (breed) => context.goNamed(
            AppRoutes.breed,
            pathParameters: {'name': breed.slug},
            // Solo una optimizacion para que el Hero tenga destino en el primer
            // frame; la ruta funciona igual sin extra (deep links).
            extra: breed,
          ),
        ),
        routes: [
          GoRoute(
            path: 'breed/:name',
            name: AppRoutes.breed,
            // `/breed/American Curl` y `/breed/american-curl` son lo mismo;
            // se normaliza para que la URL que se comparte sea siempre una.
            redirect: (context, state) {
              final raw = state.pathParameters['name'] ?? '';
              final slug = slugify(raw);
              return slug.isNotEmpty && slug != raw
                  ? AppRoutes.breedPath(slug)
                  : null;
            },
            builder: (context, state) {
              final slug = state.pathParameters['name']!;
              final extra = state.extra;
              return MultiBlocProvider(
                // Ir de una ficha a otra (deep link, notificacion) reutiliza
                // la misma pagina: sin esta key los blocs de la raza anterior
                // seguirian vivos y se veria la ficha equivocada.
                key: ValueKey(slug),
                providers: [
                  BlocProvider(
                    create: (_) {
                      final cubit = sl<BreedDetailCubit>(
                        param1: slug,
                        param2: extra is Breed && extra.slug == slug
                            ? extra
                            : null,
                      );
                      unawaited(cubit.load());
                      return cubit;
                    },
                  ),
                  BlocProvider(
                    create: (_) =>
                        sl<CatFactBloc>()..add(const CatFactRequested()),
                  ),
                ],
                child: BreedDetailPage(
                  onGoToDirectory: () => context.goNamed(AppRoutes.directory),
                ),
              );
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => RouteNotFoundPage(
      path: state.uri.path,
      onGoHome: () => context.go('/'),
    ),
  );
}
