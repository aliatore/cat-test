import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cat_directory_app/core/error/failure_mapper.dart';
import 'package:cat_directory_app/core/network/backoff.dart';
import 'package:dio/dio.dart';

/// Se emite justo antes de cada reintento para que la UI pueda mostrar
/// "reconectando 2/3" en lugar de un spinner mudo.
class RetryAttempt {
  const RetryAttempt({
    required this.attempt,
    required this.maxRetries,
    required this.delay,
    required this.path,
  });

  /// Numero de reintento, empezando en 1.
  final int attempt;
  final int maxRetries;
  final Duration delay;
  final String path;

  @override
  String toString() => 'RetryAttempt($attempt/$maxRetries, $path, $delay)';
}

typedef RetryListener = void Function(RetryAttempt attempt);

/// Canal de difusion para que la UI se entere de los reintentos sin que la
/// capa de datos sepa que existe una UI.
class RetryEvents {
  final _controller = StreamController<RetryAttempt>.broadcast();

  Stream<RetryAttempt> get stream => _controller.stream;

  void add(RetryAttempt attempt) => _controller.add(attempt);

  Future<void> dispose() => _controller.close();
}

typedef Sleep = Future<void> Function(Duration duration);

/// Reintenta fallos transitorios (sin red, timeouts, 5xx, 429) con backoff
/// exponencial antes de entregarle el error a la capa de datos.
///
/// Solo reintenta metodos idempotentes y respeta `Retry-After`. Se desactiva
/// por peticion con `extra: {RetryInterceptor.disableKey: true}`.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.maxRetries = 3,
    this.backoff = const ExponentialBackoff(),
    this.maxRetryAfter = const Duration(seconds: 10),
    RetryListener? onRetry,
    Sleep? sleep,
    Random? random,
  }) : _dio = dio,
       _onRetry = onRetry,
       _sleep = sleep ?? _defaultSleep,
       _random = random ?? Random();

  static const disableKey = 'retry.disabled';
  static const _attemptKey = 'retry.attempt';
  static const _retryableStatus = {408, 429, 500, 502, 503, 504};
  static const _idempotentMethods = {'GET', 'HEAD', 'OPTIONS'};

  final Dio _dio;
  final int maxRetries;
  final ExponentialBackoff backoff;

  /// Si el servidor pide esperar mas que esto, no tiene sentido tener al
  /// usuario mirando un spinner: se entrega el error.
  final Duration maxRetryAfter;

  final RetryListener? _onRetry;
  final Sleep _sleep;
  final Random _random;

  static Future<void> _defaultSleep(Duration d) => Future<void>.delayed(d);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final attempt = options.extra[_attemptKey] as int? ?? 0;

    if (attempt >= maxRetries || !_isRetryable(err)) {
      handler.next(err);
      return;
    }

    final delay = _delayFor(err, attempt);
    if (delay == null) {
      handler.next(err);
      return;
    }

    _onRetry?.call(
      RetryAttempt(
        attempt: attempt + 1,
        maxRetries: maxRetries,
        delay: delay,
        path: options.path,
      ),
    );
    await _sleep(delay);

    if (options.cancelToken?.isCancelled ?? false) {
      handler.next(err);
      return;
    }

    options.extra[_attemptKey] = attempt + 1;
    try {
      // La peticion vuelve a pasar por la cadena de interceptores, asi que
      // los siguientes reintentos ocurren de forma recursiva.
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _isRetryable(DioException err) {
    final options = err.requestOptions;
    if (options.extra[disableKey] == true) return false;
    if (!_idempotentMethods.contains(options.method.toUpperCase())) {
      return false;
    }
    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      DioExceptionType.badResponse => _retryableStatus.contains(
        err.response?.statusCode,
      ),
      DioExceptionType.unknown =>
        err.error is SocketException || err.error is HttpException,
      DioExceptionType.cancel ||
      DioExceptionType.badCertificate ||
      DioExceptionType.transformTimeout => false,
    };
  }

  Duration? _delayFor(DioException err, int attempt) {
    final retryAfter = parseRetryAfter(err.response?.headers);
    if (retryAfter != null) {
      return retryAfter <= maxRetryAfter ? retryAfter : null;
    }
    return backoff.delayFor(attempt, random: _random);
  }
}
