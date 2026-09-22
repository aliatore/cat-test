/// Contenido de una notificacion local. [route] es la ruta de GoRouter que se
/// abre al tocarla (por ejemplo `/breed/abyssinian`).
class NotificationMessage {
  const NotificationMessage({
    required this.id,
    required this.title,
    required this.body,
    this.route,
  });

  final int id;
  final String title;
  final String body;
  final String? route;
}

abstract interface class NotificationService {
  /// [channelName] y [channelDescription] se ven en los ajustes de Android,
  /// por eso llegan ya traducidos.
  Future<void> init({
    required String channelName,
    required String channelDescription,
  });

  /// Ruta de la notificacion que abrio la app en frio, si la hubo.
  Future<String?> launchRoute();

  /// Rutas de las notificaciones que se tocan con la app ya abierta.
  Stream<String> get onOpenRoute;

  Future<bool> requestPermission();

  Future<void> show(NotificationMessage message);

  Future<void> schedule(NotificationMessage message, DateTime at);

  Future<void> cancel(Iterable<int> ids);

  Future<void> openSystemSettings();
}
