import 'dart:async';
import 'dart:typed_data';

import 'package:cat_directory_app/core/network/backoff.dart';
import 'package:cat_directory_app/core/network/retry_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Adaptador que responde con una secuencia fija de resultados.
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this._script);

  final List<Object> _script;
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final step = _script[calls.clamp(0, _script.length - 1)];
    calls++;
    return switch (step) {
      final DioExceptionType type => throw DioException(
        requestOptions: options,
        type: type,
      ),
      final (int, Map<String, List<String>>) status => ResponseBody.fromString(
        '{"error":true}',
        status.$1,
        headers: status.$2,
      ),
      final int status => ResponseBody.fromString(
        '{"ok":${status < 400}}',
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
      _ => throw StateError('paso invalido: $step'),
    };
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late List<Duration> sleeps;
  late List<RetryAttempt> attempts;

  Dio buildDio(_ScriptedAdapter adapter, {int maxRetries = 3}) {
    final dio = Dio()..httpClientAdapter = adapter;
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        maxRetries: maxRetries,
        backoff: const ExponentialBackoff(jitter: 0),
        onRetry: attempts.add,
        sleep: (d) async => sleeps.add(d),
      ),
    );
    return dio;
  }

  setUp(() {
    sleeps = [];
    attempts = [];
  });

  test(
    'reintenta errores de conexion y termina entregando la respuesta',
    () async {
      final adapter = _ScriptedAdapter([
        DioExceptionType.connectionError,
        DioExceptionType.receiveTimeout,
        200,
      ]);

      final response = await buildDio(adapter).get<dynamic>('/breeds');

      expect(response.statusCode, 200);
      expect(adapter.calls, 3);
      expect(attempts.map((a) => a.attempt), [1, 2]);
    },
  );

  test('el retardo crece de forma exponencial', () async {
    final adapter = _ScriptedAdapter([503, 503, 503, 200]);

    await buildDio(adapter).get<dynamic>('/breeds');

    expect(sleeps, const [
      Duration(milliseconds: 400),
      Duration(milliseconds: 800),
      Duration(milliseconds: 1600),
    ]);
  });

  test('se rinde al agotar los intentos y propaga el ultimo error', () async {
    final adapter = _ScriptedAdapter([DioExceptionType.connectionError]);

    await expectLater(
      buildDio(adapter, maxRetries: 2).get<dynamic>('/breeds'),
      throwsA(
        isA<DioException>().having(
          (e) => e.type,
          'type',
          DioExceptionType.connectionError,
        ),
      ),
    );
    expect(adapter.calls, 3, reason: '1 intento + 2 reintentos');
  });

  test('no reintenta errores del cliente (4xx)', () async {
    final adapter = _ScriptedAdapter([404]);

    await expectLater(
      buildDio(adapter).get<dynamic>('/breeds'),
      throwsA(isA<DioException>()),
    );
    expect(adapter.calls, 1);
    expect(attempts, isEmpty);
  });

  test('no reintenta metodos que no son idempotentes', () async {
    final adapter = _ScriptedAdapter([503, 200]);

    await expectLater(
      buildDio(adapter).post<dynamic>('/breeds'),
      throwsA(isA<DioException>()),
    );
    expect(adapter.calls, 1);
  });

  test('respeta Retry-After en un 429', () async {
    final adapter = _ScriptedAdapter([
      (
        429,
        {
          'retry-after': ['2'],
        },
      ),
      200,
    ]);

    await buildDio(adapter).get<dynamic>('/fact');

    expect(sleeps, const [Duration(seconds: 2)]);
  });

  test('si Retry-After pide demasiado, entrega el error sin esperar', () async {
    final adapter = _ScriptedAdapter([
      (
        429,
        {
          'retry-after': ['120'],
        },
      ),
    ]);

    await expectLater(
      buildDio(adapter).get<dynamic>('/fact'),
      throwsA(isA<DioException>()),
    );
    expect(sleeps, isEmpty);
  });

  test('se puede desactivar por peticion', () async {
    final adapter = _ScriptedAdapter([DioExceptionType.connectionError, 200]);

    await expectLater(
      buildDio(adapter).get<dynamic>(
        '/fact',
        options: Options(extra: {RetryInterceptor.disableKey: true}),
      ),
      throwsA(isA<DioException>()),
    );
    expect(adapter.calls, 1);
  });
}
