import 'package:cat_directory_app/core/cache/json_cache.dart';
import 'package:cat_directory_app/features/facts/data/models/cat_fact_dto.dart';
import 'package:dio/dio.dart';

abstract interface class CatFactRemoteDataSource {
  Future<CatFactDto> fetchRandom({required int maxLength});
}

class DioCatFactRemoteDataSource implements CatFactRemoteDataSource {
  DioCatFactRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<CatFactDto> fetchRandom({required int maxLength}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/fact',
      queryParameters: {'max_length': maxLength},
    );
    final body = response.data;
    if (body == null) throw const FormatException('respuesta vacia');
    return CatFactDto.fromJson(body);
  }
}

abstract interface class CatFactLocalDataSource {
  List<String> readAll();

  Future<void> save(String fact);
}

/// Guarda los ultimos datos vistos para tener algo que mostrar sin red.
class JsonCatFactLocalDataSource implements CatFactLocalDataSource {
  JsonCatFactLocalDataSource(this._cache, {this.capacity = 30});

  final JsonCache _cache;
  final int capacity;

  static const _key = 'facts:seen';

  @override
  List<String> readAll() {
    final json = _cache.read(_key)?.json;
    return json is List ? json.whereType<String>().toList() : const [];
  }

  @override
  Future<void> save(String fact) {
    final facts = [fact, ...readAll().where((f) => f != fact)];
    return _cache.write(_key, facts.take(capacity).toList());
  }
}
