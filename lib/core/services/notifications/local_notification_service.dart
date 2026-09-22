import 'dart:async';

import 'package:cat_directory_app/core/services/notifications/notification_service.dart';
import 'package:cat_directory_app/core/utils/log.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
// latest_10y y no latest_all: solo se programan fechas cercanas y la base
// completa de zonas pesaba ~450 KB en el APK.
import 'package:timezone/data/latest_10y.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService implements NotificationService {
  LocalNotificationService([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _channelId = 'daily_breed';
  static const _icon = 'ic_stat_nekodex';
  static const _sound = 'nekodex_notify';

  final FlutterLocalNotificationsPlugin _plugin;
  final _routes = StreamController<String>.broadcast();
  late NotificationDetails _details;

  @override
  Future<void> init({
    required String channelName,
    required String channelDescription,
  }) async {
    await _initTimeZone();

    _details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: _icon,
        color: const Color(0xFFFF2E88),
        sound: const RawResourceAndroidNotificationSound(_sound),
        category: AndroidNotificationCategory.recommendation,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBanner: true,
        presentList: true,
        presentSound: true,
        sound: '$_sound.wav',
        threadIdentifier: _channelId,
      ),
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(_icon),
        // El permiso se pide en contexto (al activar la raza del dia), no al
        // abrir la app por primera vez.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        final route = response.payload;
        if (route != null && route.startsWith('/')) _routes.add(route);
      },
    );
  }

  Future<void> _initTimeZone() async {
    tz_data.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } on Object catch (error) {
      // Sin zona horaria conocida se programa en UTC: la hora se corre, pero
      // la notificacion llega.
      logDebug('notifications', 'zona horaria desconocida', error: error);
    }
  }

  @override
  Future<String?> launchRoute() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) return null;
    final route = details.notificationResponse?.payload;
    return route != null && route.startsWith('/') ? route : null;
  }

  @override
  Stream<String> get onOpenRoute => _routes.stream;

  @override
  Future<bool> requestPermission() async {
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android != null) {
        return await android.requestNotificationsPermission() ?? false;
      }
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (ios != null) {
        return await ios.requestPermissions(alert: true, sound: true) ?? false;
      }
    } on PlatformException catch (error) {
      logDebug('notifications', 'no se pudo pedir permiso', error: error);
    }
    return false;
  }

  @override
  Future<void> show(NotificationMessage message) => _plugin.show(
    id: message.id,
    title: message.title,
    body: message.body,
    notificationDetails: _details,
    payload: message.route,
  );

  @override
  Future<void> schedule(NotificationMessage message, DateTime at) =>
      _plugin.zonedSchedule(
        id: message.id,
        scheduledDate: tz.TZDateTime.from(at, tz.local),
        notificationDetails: _details,
        // Inexacta a proposito: la raza del dia no necesita el permiso de
        // alarmas exactas (que en Android 14 el usuario tiene que conceder a
        // mano) y el sistema la agrupa con otras para ahorrar bateria.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: message.title,
        body: message.body,
        payload: message.route,
      );

  @override
  Future<void> cancel(Iterable<int> ids) async {
    for (final id in ids) {
      await _plugin.cancel(id: id);
    }
  }

  @override
  Future<void> openSystemSettings() async {
    await _plugin.openAppNotificationSettings();
  }
}
