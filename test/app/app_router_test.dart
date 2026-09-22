import 'package:bloc_test/bloc_test.dart';
import 'package:cat_directory_app/app/di/injection.dart';
import 'package:cat_directory_app/app/router/app_router.dart';
import 'package:cat_directory_app/core/domain/data_origin.dart';
import 'package:cat_directory_app/core/error/failure.dart';
import 'package:cat_directory_app/core/error/result.dart';
import 'package:cat_directory_app/core/presentation/connectivity_cubit.dart';
import 'package:cat_directory_app/core/utils/slug.dart';
import 'package:cat_directory_app/design_system/theme/neko_theme.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/repositories/breed_repository.dart';
import 'package:cat_directory_app/features/breeds/domain/usecases/breed_usecases.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breed_detail_cubit.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/features/facts/domain/entities/cat_fact.dart';
import 'package:cat_directory_app/features/facts/domain/repositories/cat_fact_repository.dart';
import 'package:cat_directory_app/features/facts/domain/usecases/get_random_fact.dart';
import 'package:cat_directory_app/features/facts/presentation/bloc/cat_fact_bloc.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MockBreedsBloc extends MockBloc<BreedsEvent, BreedsState>
    implements BreedsBloc {}

class _MockConnectivity extends MockCubit<ConnectivityState>
    implements ConnectivityCubit {}

class _MockBreeds extends Mock implements BreedRepository {}

class _Facts implements CatFactRepository {
  @override
  Future<Result<CatFact>> getRandomFact() async => const Ok(
    CatFact(text: 'Cats sleep a lot.', origin: DataOrigin.remote),
  );
}

void main() {
  const directory = [
    Breed(name: 'American Curl', country: 'United States'),
    Breed(name: 'Foldex', country: 'Canada'),
  ];
  late _MockBreeds breeds;

  setUp(() async {
    await sl.reset();
    breeds = _MockBreeds();
    when(() => breeds.findBySlug(any())).thenAnswer((invocation) async {
      final slug = slugify(invocation.positionalArguments.first as String);
      for (final breed in directory) {
        if (breed.slug == slug) return Ok(breed);
      }
      return const Err(Failure.notFound());
    });
    sl
      ..registerFactoryParam<BreedDetailCubit, String, Breed?>(
        (slug, initial) => BreedDetailCubit(
          findBreed: FindBreed(breeds),
          slug: slug,
          initial: initial,
        ),
      )
      ..registerFactory(
        () => CatFactBloc(getRandomFact: GetRandomFact(_Facts())),
      );
  });

  Future<GoRouter> open(WidgetTester tester, String location) async {
    final bloc = _MockBreedsBloc();
    final connectivity = _MockConnectivity();
    when(() => bloc.state).thenReturn(const BreedsState());
    when(() => connectivity.state).thenReturn(const ConnectivityState());
    final router = buildRouter(initialLocation: location);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<BreedsBloc>.value(value: bloc),
          BlocProvider<ConnectivityCubit>.value(value: connectivity),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          theme: NekoTheme.dark(),
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  String location(GoRouter router) =>
      router.routerDelegate.currentConfiguration.uri.path;

  testWidgets('/breed/:name normaliza el nombre y abre la ficha', (
    tester,
  ) async {
    final router = await open(tester, '/breed/American%20Curl');

    expect(location(router), '/breed/american-curl');
    expect(find.text('American Curl'), findsWidgets);
    expect(find.text('Cats sleep a lot.'), findsOneWidget);
  });

  testWidgets('un deep link deja el directorio debajo para poder volver', (
    tester,
  ) async {
    final router = await open(tester, '/breed/foldex');

    expect(router.canPop(), isTrue);
    router.pop();
    await tester.pumpAndSettle();
    expect(location(router), '/');
  });

  testWidgets('una raza que no existe muestra el aviso, no un error', (
    tester,
  ) async {
    await open(tester, '/breed/gato-fantasma');

    expect(find.text('Esa raza no está en el directorio'), findsOneWidget);
    expect(find.text('IR AL DIRECTORIO'), findsOneWidget);
  });

  testWidgets('una ruta desconocida cae en la pantalla de ruta perdida', (
    tester,
  ) async {
    await open(tester, '/perros');

    expect(find.text('Ruta desconocida'), findsOneWidget);
  });
}
