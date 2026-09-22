import 'dart:io';

import 'package:cat_directory_app/core/error/failure.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

/// Traduce excepciones de infraestructura (Dio, parseo, IO) a [Failure].
/// Es el unico punto donde la capa de datos conoce los detalles de Dio.
Failure mapErrorToFailure(Object error) => switch (error) {
  DioException(
    type: DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout,
  ) =>
    const Failure.timeout(),
  DioException(type: DioExceptionType.connectionError) ||
  DioException(error: SocketException()) => const Failure.connection(),
  DioException(type: DioExceptionType.badResponse, :final response) =>
    _fromResponse(response),
  DioException(error: final Object inner) when _isParsingError(inner) =>
    const Failure.parsing(),
  Object() when _isParsingError(error) => const Failure.parsing(),
  _ => const Failure.unexpected(),
};

bool _isParsingError(Object error) =>
    error is FormatException ||
    error is TypeError ||
    error is CheckedFromJsonException;

Failure _fromResponse(Response<dynamic>? response) {
  final status = response?.statusCode;
  if (status == null) return const Failure.server();
  if (status == 404) return const Failure.notFound();
  if (status == 429) {
    return Failure.rateLimited(retryAfter: parseRetryAfter(response?.headers));
  }
  if (status >= 500) return Failure.server(statusCode: status);
  if (status >= 400) return Failure.request(statusCode: status);
  return Failure.server(statusCode: status);
}

/// `Retry-After` puede venir en segundos o como fecha HTTP.
Duration? parseRetryAfter(Headers? headers, {DateTime? now}) {
  final raw = headers?.value('retry-after');
  if (raw == null) return null;
  final seconds = int.tryParse(raw.trim());
  if (seconds != null) return Duration(seconds: seconds);
  try {
    final date = HttpDate.parse(raw);
    final diff = date.difference(now ?? DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  } on FormatException {
    return null;
  } on HttpException {
    return null;
  }
}
