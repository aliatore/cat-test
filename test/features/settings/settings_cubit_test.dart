import 'package:cat_directory_app/core/cache/key_value_store.dart';
import 'package:cat_directory_app/core/services/audio/sound_effects.dart';
import 'package:cat_directory_app/core/services/notifications/notification_service.dart';
import 'package:cat_directory_app/features/daily_breed/daily_breed_scheduler.dart';
import 'package:cat_directory_app/features/settings/data/local_settings_repository.dart';
import 'package:cat_directory_app/features/settings/domain/app_settings.dart';
import 'package:cat_directory_app/features/settings/presentation/settings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockNotifications extends Mock implements NotificationService {}

class _MockScheduler extends Mock implements DailyBreedScheduler {}

void main() {
  late InMemoryKeyValueStore store;
  late _MockNotifications notifications;
  late _MockScheduler scheduler;
  late SilentSoundEffects sounds;

  final copy = DailyBreedCopy(title: (b) => b.name, body: (b) => b.name);

  setUpAll(() => registerFallbackValue(copy));

  setUp(() {
    store = InMemoryKeyValueStore();
    notifications = _MockNotifications();
    scheduler = _MockScheduler();
    sounds = SilentSoundEffects();
    when(() => scheduler.cancel()).thenAnswer((_) async {});
  });

  SettingsCubit build() => SettingsCubit(
    repository: LocalSettingsRepository(store),
    sounds: sounds,
    notifications: notifications,
    scheduler: scheduler,
  );

  test('los ajustes sobreviven a un reinicio', () async {
    await build().setTheme(ThemePreference.dark);
    await build().setSound(enabled: false);

    final restored = build().state;

    expect(restored.theme, ThemePreference.dark);
    expect(restored.soundEnabled, isFalse);
    expect(sounds.enabled, isFalse);
  });

  test('sin permiso la raza del dia queda apagada', () async {
    when(
      () => notifications.requestPermission(),
    ).thenAnswer((_) async => false);
    final cubit = build();

    final outcome = await cubit.setDailyBreed(enabled: true, copy: copy);

    expect(outcome, NotificationOutcome.permissionDenied);
    expect(cubit.state.dailyBreed, isFalse);
    verifyNever(() => scheduler.scheduleUpcoming(any()));
  });

  test('con permiso se activa y programa la semana', () async {
    when(() => notifications.requestPermission()).thenAnswer((_) async => true);
    when(() => scheduler.scheduleUpcoming(any())).thenAnswer((_) async => 7);
    final cubit = build();

    final outcome = await cubit.setDailyBreed(enabled: true, copy: copy);

    expect(outcome, NotificationOutcome.done);
    expect(cubit.state.dailyBreed, isTrue);
  });

  test('un json corrupto no rompe el arranque', () async {
    await store.write('settings', '{roto');

    expect(build().state, const AppSettings());
  });
}
