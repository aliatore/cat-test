import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Lo que puede salir mal, visto desde el dominio. La capa de presentacion
/// decide el mensaje; aqui solo se describe que paso.
@freezed
sealed class Failure with _$Failure {
  const Failure._();

  /// El dispositivo no tiene red o el servidor no es alcanzable.
  const factory Failure.connection() = ConnectionFailure;

  const factory Failure.timeout() = TimeoutFailure;

  /// 5xx o respuesta inesperada del servidor.
  const factory Failure.server({int? statusCode}) = ServerFailure;

  /// 429: la API limita a 100 peticiones por minuto.
  const factory Failure.rateLimited({Duration? retryAfter}) =
      RateLimitedFailure;

  /// 4xx que no tiene sentido reintentar.
  const factory Failure.request({required int statusCode}) = RequestFailure;

  /// El JSON no tenia la forma esperada.
  const factory Failure.parsing() = ParsingFailure;

  /// No se pudo leer o escribir el almacenamiento local.
  const factory Failure.cache() = CacheFailure;

  /// El recurso pedido no existe (por ejemplo, una raza desde un deep link).
  const factory Failure.notFound() = NotFoundFailure;

  const factory Failure.unexpected() = UnexpectedFailure;

  /// Indica si vale la pena ofrecer "reintentar" al usuario.
  bool get isRetryable => switch (this) {
    ConnectionFailure() ||
    TimeoutFailure() ||
    ServerFailure() ||
    RateLimitedFailure() ||
    CacheFailure() ||
    UnexpectedFailure() => true,
    RequestFailure() || ParsingFailure() || NotFoundFailure() => false,
  };

  /// Fallos que se resuelven solos cuando vuelve la conexion.
  bool get isConnectivity =>
      this is ConnectionFailure || this is TimeoutFailure;
}
