import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cat_directory_app/features/breeds/data/datasources/breed_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Responde la pagina pedida despues de que la prueba lo permita.
class _GatedAdapter implements HttpClientAdapter {
  final gate = Completer<void>();
  final requests = <Uri>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options.uri);
    await gate.future;
    final page = int.parse(options.uri.queryParameters['page']!);
    return ResponseBody.fromString(
      jsonEncode({
        'current_page': page,
        'last_page': 7,
        'per_page': '15',
        'total': 98,
        'data': [
          {
            'breed': 'Abyssinian',
            'country': 'Ethiopia',
            'origin': 'Natural/Standard',
            'coat': 'Short',
            'pattern': 'Ticked',
          },
        ],
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _GatedAdapter adapter;
  late DioBreedRemoteDataSource dataSource;

  setUp(() {
    adapter = _GatedAdapter();
    dataSource = DioBreedRemoteDataSource(
      Dio(BaseOptions(baseUrl: 'https://catfact.ninja'))
        ..httpClientAdapter = adapter,
    );
  });

  test('parsea la respuesta paginada de Laravel', () async {
    adapter.gate.complete();

    final page = await dataSource.fetchPage(page: 2, limit: 15);

    expect(page.currentPage, 2);
    expect(page.perPage, 15, reason: 'per_page puede llegar como texto');
    expect(page.data.single.breed, 'Abyssinian');
  });

  test('dos peticiones iguales en curso comparten una sola llamada', () async {
    final first = dataSource.fetchPage(page: 1, limit: 15);
    final second = dataSource.fetchPage(page: 1, limit: 15);
    adapter.gate.complete();

    final results = await Future.wait([first, second]).timeout(
      const Duration(seconds: 2),
    );

    expect(adapter.requests, hasLength(1));
    expect(results.first, results.last);
  });

  test('al terminar libera la clave y la siguiente vuelve a la red', () async {
    adapter.gate.complete();
    await dataSource
        .fetchPage(page: 1, limit: 15)
        .timeout(const Duration(seconds: 2));
    await dataSource
        .fetchPage(page: 1, limit: 15)
        .timeout(const Duration(seconds: 2));

    expect(adapter.requests, hasLength(2));
  });
}
