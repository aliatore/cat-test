import 'package:cat_directory_app/core/cache/json_cache.dart';
import 'package:cat_directory_app/core/cache/key_value_store.dart';
import 'package:cat_directory_app/core/network/dio_factory.dart';
import 'package:cat_directory_app/core/network/network_info.dart';
import 'package:cat_directory_app/core/network/retry_interceptor.dart';
import 'package:cat_directory_app/core/presentation/connectivity_cubit.dart';
import 'package:cat_directory_app/core/services/audio/audioplayers_sound_effects.dart';
import 'package:cat_directory_app/core/services/audio/sound_effects.dart';
import 'package:cat_directory_app/core/services/notifications/local_notification_service.dart';
import 'package:cat_directory_app/core/services/notifications/notification_service.dart';
import 'package:cat_directory_app/features/breeds/data/datasources/breed_local_data_source.dart';
import 'package:cat_directory_app/features/breeds/data/datasources/breed_remote_data_source.dart';
import 'package:cat_directory_app/features/breeds/data/repositories/breed_repository_impl.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/repositories/breed_repository.dart';
import 'package:cat_directory_app/features/breeds/domain/usecases/breed_usecases.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breed_detail_cubit.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_cache_cubit.dart';
import 'package:cat_directory_app/features/daily_breed/daily_breed_scheduler.dart';
import 'package:cat_directory_app/features/facts/data/datasources/cat_fact_data_sources.dart';
import 'package:cat_directory_app/features/facts/data/repositories/cat_fact_repository_impl.dart';
import 'package:cat_directory_app/features/facts/domain/repositories/cat_fact_repository.dart';
import 'package:cat_directory_app/features/facts/domain/usecases/get_random_fact.dart';
import 'package:cat_directory_app/features/facts/presentation/bloc/cat_fact_bloc.dart';
import 'package:cat_directory_app/features/settings/data/local_settings_repository.dart';
import 'package:cat_directory_app/features/settings/domain/settings_repository.dart';
import 'package:cat_directory_app/features/settings/presentation/settings_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';

final GetIt sl = GetIt.instance;

/// Subir este numero invalida toda la cache al actualizar la app (por ejemplo
/// si cambia la forma de los modelos guardados).
const cacheSchemaVersion = 1;

/// Raiz de composicion: el unico lugar que conoce las implementaciones
/// concretas. Las pantallas reciben sus blocs ya construidos.
Future<void> configureDependencies() async {
  // Application Support y no Documents: es cache, no un archivo del usuario.
  final dir = await getApplicationSupportDirectory();
  Hive.init('${dir.path}/hive');
  final cacheBox = await Hive.openBox<String>('cache');
  final settingsBox = await Hive.openBox<String>('settings');

  final retryEvents = RetryEvents();

  sl
    ..registerSingleton<RetryEvents>(retryEvents)
    ..registerSingleton(buildDio(onRetry: retryEvents.add))
    ..registerSingleton<NetworkInfo>(
      ConnectivityNetworkInfo(Connectivity()),
      dispose: (info) => (info as ConnectivityNetworkInfo).dispose(),
    )
    ..registerSingleton(
      JsonCache(HiveKeyValueStore(cacheBox), schemaVersion: cacheSchemaVersion),
    )
    ..registerSingleton<SoundEffects>(AudioplayersSoundEffects())
    ..registerSingleton<NotificationService>(LocalNotificationService())
    // razas
    ..registerLazySingleton<BreedRemoteDataSource>(
      () => DioBreedRemoteDataSource(sl()),
    )
    ..registerLazySingleton<BreedLocalDataSource>(
      () => JsonBreedLocalDataSource(sl()),
    )
    ..registerLazySingleton<BreedRepository>(
      () => BreedRepositoryImpl(remote: sl(), local: sl(), networkInfo: sl()),
    )
    ..registerFactory(() => WatchBreedsPage(sl()))
    ..registerFactory(() => GetBreedsPage(sl()))
    ..registerFactory(() => FindBreed(sl()))
    ..registerFactory(() => GetBreedsCacheInfo(sl()))
    ..registerFactory(() => ClearBreedsCache(sl()))
    // datos curiosos
    ..registerLazySingleton<CatFactRemoteDataSource>(
      () => DioCatFactRemoteDataSource(sl()),
    )
    ..registerLazySingleton<CatFactLocalDataSource>(
      () => JsonCatFactLocalDataSource(sl()),
    )
    ..registerLazySingleton<CatFactRepository>(
      () => CatFactRepositoryImpl(remote: sl(), local: sl(), networkInfo: sl()),
    )
    ..registerFactory(() => GetRandomFact(sl()))
    // presentacion
    ..registerFactory(
      () => BreedsBloc(watchPage: sl(), getPage: sl(), networkInfo: sl()),
    )
    ..registerFactory(
      () => ConnectivityCubit(
        networkInfo: sl(),
        retries: sl<RetryEvents>().stream,
      ),
    )
    ..registerFactoryParam<BreedDetailCubit, String, Breed?>(
      (slug, initial) =>
          BreedDetailCubit(findBreed: sl(), slug: slug, initial: initial),
    )
    ..registerFactory(() => CatFactBloc(getRandomFact: sl()))
    ..registerFactory(() => BreedsCacheCubit(getInfo: sl(), clear: sl()))
    // ajustes y raza del dia
    ..registerLazySingleton<SettingsRepository>(
      () => LocalSettingsRepository(HiveKeyValueStore(settingsBox)),
    )
    ..registerLazySingleton(
      () => DailyBreedScheduler(breeds: sl(), notifications: sl()),
    )
    ..registerFactory(
      () => SettingsCubit(
        repository: sl(),
        sounds: sl(),
        notifications: sl(),
        scheduler: sl(),
      ),
    );

  await sl<BreedRepository>().purgeExpired();
}
