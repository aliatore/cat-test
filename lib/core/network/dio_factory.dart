import 'package:cat_directory_app/core/network/api_config.dart';
import 'package:cat_directory_app/core/network/retry_interceptor.dart';
import 'package:cat_directory_app/core/utils/log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio buildDio({RetryListener? onRetry, bool log = kDebugMode}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: const {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.add(RetryInterceptor(dio: dio, onRetry: onRetry));
  if (log) dio.interceptors.add(_CompactLogInterceptor());
  return dio;
}

/// Una linea por peticion: metodo, ruta, estado y duracion.
class _CompactLogInterceptor extends Interceptor {
  static const _startKey = 'log.start';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startKey] = DateTime.now();
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _log(response.requestOptions, '${response.statusCode}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log(err.requestOptions, 'ERR ${err.type.name}');
    handler.next(err);
  }

  void _log(RequestOptions options, String outcome) {
    final start = options.extra[_startKey] as DateTime?;
    final ms = start == null
        ? '?'
        : DateTime.now().difference(start).inMilliseconds.toString();
    logDebug(
      'http',
      '${options.method} ${options.uri.path}?${options.uri.query} '
          '-> $outcome (${ms}ms)',
    );
  }
}
