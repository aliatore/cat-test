import 'dart:math';

import 'package:cat_directory_app/core/services/notifications/notification_service.dart';
import 'package:cat_directory_app/core/utils/clock.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/repositories/breed_repository.dart';

/// Como se redacta la notificacion; lo aporta la capa que conoce el idioma.
class DailyBreedCopy {
  const DailyBreedCopy({required this.title, required this.body});

  final String Function(Breed breed) title;
  final String Function(Breed breed) body;
}

/// "Raza del dia": una notificacion local diaria con una raza del directorio.
///
/// Las notificaciones repetitivas de iOS/Android siempre muestran el mismo
/// texto, asi que se programan los proximos 7 dias uno a uno (cada dia una
/// raza distinta) y se reprograman cada vez que la app arranca.
class DailyBreedScheduler {
  DailyBreedScheduler({
    required BreedRepository breeds,
    required NotificationService notifications,
    Clock clock = const Clock(),
  }) : _breeds = breeds,
       _notifications = notifications,
       _clock = clock;

  static const days = 7;
  static const hour = 10;
  static const _firstId = 1000;
  static const _testId = 1999;

  final BreedRepository _breeds;
  final NotificationService _notifications;
  final Clock _clock;

  /// Programa los proximos dias con lo que haya en cache. Devuelve cuantas
  /// notificaciones quedaron programadas (0 si todavia no hay razas).
  Future<int> scheduleUpcoming(DailyBreedCopy copy) async {
    await cancel();
    final pool = _breeds.cachedBreeds();
    if (pool.isEmpty) return 0;

    final now = _clock.now();
    var scheduled = 0;
    for (var day = 0; day <= days; day++) {
      final at = DateTime(now.year, now.month, now.day + day, hour);
      if (!at.isAfter(now) || scheduled == days) continue;
      final breed = breedFor(at, pool);
      await _notifications.schedule(_message(_firstId + day, breed, copy), at);
      scheduled++;
    }
    return scheduled;
  }

  Future<void> cancel() =>
      _notifications.cancel([for (var d = 0; d <= days; d++) _firstId + d]);

  /// Notificacion inmediata con una raza al azar, para probar el flujo
  /// completo (incluido abrir la ficha al tocarla).
  Future<bool> sendTest(DailyBreedCopy copy) async {
    final pool = _breeds.cachedBreeds();
    if (pool.isEmpty) return false;
    final breed = pool[Random().nextInt(pool.length)];
    await _notifications.show(_message(_testId, breed, copy));
    return true;
  }

  /// La misma fecha siempre da la misma raza, aunque se reprograme mil veces.
  static Breed breedFor(DateTime day, List<Breed> pool) {
    final seed = day.year * 10000 + day.month * 100 + day.day;
    return pool[Random(seed).nextInt(pool.length)];
  }

  NotificationMessage _message(int id, Breed breed, DailyBreedCopy copy) =>
      NotificationMessage(
        id: id,
        title: copy.title(breed),
        body: copy.body(breed),
        route: '/breed/${breed.slug}',
      );
}
