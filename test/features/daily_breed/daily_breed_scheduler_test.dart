import 'package:cat_directory_app/core/services/notifications/notification_service.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/repositories/breed_repository.dart';
import 'package:cat_directory_app/features/daily_breed/daily_breed_scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fakes.dart';

class _MockBreeds extends Mock implements BreedRepository {}

class _RecordingNotifications implements NotificationService {
  final scheduled = <(NotificationMessage, DateTime)>[];
  final shown = <NotificationMessage>[];
  final cancelled = <int>[];

  @override
  Future<void> schedule(NotificationMessage message, DateTime at) async =>
      scheduled.add((message, at));

  @override
  Future<void> show(NotificationMessage message) async => shown.add(message);

  @override
  Future<void> cancel(Iterable<int> ids) async => cancelled.addAll(ids);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _MockBreeds breeds;
  late _RecordingNotifications notifications;
  late FakeClock clock;
  late DailyBreedScheduler scheduler;

  const copy = DailyBreedCopy(title: _title, body: _body);
  const pool = [
    Breed(name: 'Abyssinian', country: 'Ethiopia', coat: 'Short'),
    Breed(name: 'Korat', country: 'Thailand', coat: 'Short'),
    Breed(name: 'Sphynx', country: 'Canada', coat: 'Hairless'),
  ];

  setUp(() {
    breeds = _MockBreeds();
    notifications = _RecordingNotifications();
    clock = FakeClock(DateTime(2026, 9, 22, 8, 30));
    scheduler = DailyBreedScheduler(
      breeds: breeds,
      notifications: notifications,
      clock: clock,
    );
    when(() => breeds.cachedBreeds()).thenReturn(pool);
  });

  test(
    'programa los proximos 7 dias a las 10:00 con ruta a la ficha',
    () async {
      final count = await scheduler.scheduleUpcoming(copy);

      expect(count, 7);
      final first = notifications.scheduled.first;
      expect(first.$2, DateTime(2026, 9, 22, 10));
      expect(first.$1.route, startsWith('/breed/'));
      expect(notifications.scheduled.last.$2, DateTime(2026, 9, 28, 10));
    },
  );

  test('si hoy ya paso la hora, empieza manana', () async {
    clock.current = DateTime(2026, 9, 22, 18);

    await scheduler.scheduleUpcoming(copy);

    expect(notifications.scheduled.first.$2, DateTime(2026, 9, 23, 10));
    expect(notifications.scheduled, hasLength(7));
  });

  test(
    'reprogramar cancela lo anterior y elige la misma raza por fecha',
    () async {
      await scheduler.scheduleUpcoming(copy);
      final firstRun = notifications.scheduled.map((e) => e.$1.title).toList();
      notifications.scheduled.clear();

      await scheduler.scheduleUpcoming(copy);

      expect(notifications.cancelled, isNotEmpty);
      expect(notifications.scheduled.map((e) => e.$1.title), firstRun);
    },
  );

  test('sin razas en cache no programa nada', () async {
    when(() => breeds.cachedBreeds()).thenReturn(const []);

    expect(await scheduler.scheduleUpcoming(copy), 0);
    expect(await scheduler.sendTest(copy), isFalse);
    expect(notifications.scheduled, isEmpty);
  });
}

String _title(Breed breed) => 'Raza del dia: ${breed.name}';

String _body(Breed breed) => '${breed.country}';
