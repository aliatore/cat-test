import 'package:bloc/bloc.dart';
import 'package:cat_directory_app/core/services/audio/sound_effects.dart';
import 'package:cat_directory_app/core/services/notifications/notification_service.dart';
import 'package:cat_directory_app/features/daily_breed/daily_breed_scheduler.dart';
import 'package:cat_directory_app/features/settings/domain/app_settings.dart';
import 'package:cat_directory_app/features/settings/domain/settings_repository.dart';

enum NotificationOutcome { done, permissionDenied, noBreedsYet }

class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit({
    required SettingsRepository repository,
    required SoundEffects sounds,
    required NotificationService notifications,
    required DailyBreedScheduler scheduler,
  }) : _repository = repository,
       _sounds = sounds,
       _notifications = notifications,
       _scheduler = scheduler,
       super(repository.load()) {
    _sounds.enabled = state.soundEnabled;
  }

  final SettingsRepository _repository;
  final SoundEffects _sounds;
  final NotificationService _notifications;
  final DailyBreedScheduler _scheduler;

  Future<void> setTheme(ThemePreference theme) =>
      _update(state.copyWith(theme: theme));

  Future<void> setSound({required bool enabled}) {
    _sounds.enabled = enabled;
    return _update(state.copyWith(soundEnabled: enabled));
  }

  Future<void> setPerformanceOverlay({required bool enabled}) =>
      _update(state.copyWith(performanceOverlay: enabled));

  /// El permiso se pide aqui, cuando el usuario entiende para que es.
  Future<NotificationOutcome> setDailyBreed({
    required bool enabled,
    required DailyBreedCopy copy,
  }) async {
    if (!enabled) {
      await _scheduler.cancel();
      await _update(state.copyWith(dailyBreed: false));
      return NotificationOutcome.done;
    }
    if (!await _notifications.requestPermission()) {
      return NotificationOutcome.permissionDenied;
    }
    await _update(state.copyWith(dailyBreed: true));
    final scheduled = await _scheduler.scheduleUpcoming(copy);
    return scheduled == 0
        ? NotificationOutcome.noBreedsYet
        : NotificationOutcome.done;
  }

  Future<NotificationOutcome> sendTestNotification(DailyBreedCopy copy) async {
    if (!await _notifications.requestPermission()) {
      return NotificationOutcome.permissionDenied;
    }
    return await _scheduler.sendTest(copy)
        ? NotificationOutcome.done
        : NotificationOutcome.noBreedsYet;
  }

  /// Al arrancar se reprograma la semana con la cache mas reciente.
  Future<void> refreshDailyBreed(DailyBreedCopy copy) async {
    if (state.dailyBreed) await _scheduler.scheduleUpcoming(copy);
  }

  Future<void> openSystemNotificationSettings() =>
      _notifications.openSystemSettings();

  Future<void> _update(AppSettings next) async {
    emit(next);
    await _repository.save(next);
  }
}
