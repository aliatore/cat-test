import 'dart:async';

import 'package:cat_directory_app/features/breeds/data/models/breed_dto.dart';
import 'package:dio/dio.dart';

abstract interface class BreedRemoteDataSource {
  Future<BreedsPageDto> fetchPage({required int page, required int limit});
}

class DioBreedRemoteDataSource implements BreedRemoteDataSource {
  DioBreedRemoteDataSource(this._dio);

  final Dio _dio;
  final _inFlight = <String, Future<BreedsPageDto>>{};

  @override
  Future<BreedsPageDto> fetchPage({required int page, required int limit}) {
    final key = '$page:$limit';
    // Si ya hay una peticion identica en curso se comparte su resultado: el
    // bloc evita duplicados en la lista, esto los evita en la red (por
    // ejemplo, un deep link resolviendo la misma pagina que el directorio).
    final pending = _inFlight[key];
    if (pending != null) return pending;

    final request = _get(page, limit);
    _inFlight[key] = request;
    // Solo limpia el mapa; el resultado y los errores los recibe quien llama.
    request.whenComplete(() => _inFlight.remove(key)).ignore();
    return request;
  }

  Future<BreedsPageDto> _get(int page, int limit) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/breeds',
      queryParameters: {'page': page, 'limit': limit},
    );
    final body = response.data;
    if (body == null) throw const FormatException('respuesta vacia');
    return BreedsPageDto.fromJson(body);
  }
}
