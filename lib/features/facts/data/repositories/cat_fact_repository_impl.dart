import 'dart:math';

import 'package:cat_directory_app/core/domain/data_origin.dart';
import 'package:cat_directory_app/core/error/failure.dart';
import 'package:cat_directory_app/core/error/failure_mapper.dart';
import 'package:cat_directory_app/core/error/result.dart';
import 'package:cat_directory_app/core/network/api_config.dart';
import 'package:cat_directory_app/core/network/network_info.dart';
import 'package:cat_directory_app/core/utils/log.dart';
import 'package:cat_directory_app/features/facts/data/datasources/cat_fact_data_sources.dart';
import 'package:cat_directory_app/features/facts/domain/entities/cat_fact.dart';
import 'package:cat_directory_app/features/facts/domain/repositories/cat_fact_repository.dart';

class CatFactRepositoryImpl implements CatFactRepository {
  CatFactRepositoryImpl({
    required CatFactRemoteDataSource remote,
    required CatFactLocalDataSource local,
    required NetworkInfo networkInfo,
    Random? random,
  }) : _remote = remote,
       _local = local,
       _networkInfo = networkInfo,
       _random = random ?? Random();

  final CatFactRemoteDataSource _remote;
  final CatFactLocalDataSource _local;
  final NetworkInfo _networkInfo;
  final Random _random;

  String? _lastShown;

  @override
  Future<Result<CatFact>> getRandomFact() async {
    if (!await _networkInfo.isConnected) {
      return _fromCache() ?? const Err(Failure.connection());
    }
    try {
      final dto = await _remote.fetchRandom(maxLength: ApiConfig.factMaxLength);
      final text = dto.fact.trim();
      if (text.isEmpty) throw const FormatException('dato vacio');
      await _saveQuietly(text);
      _lastShown = text;
      return Ok(CatFact(text: text, origin: DataOrigin.remote));
    } on Object catch (error) {
      return _fromCache() ?? Err(mapErrorToFailure(error));
    }
  }

  Result<CatFact>? _fromCache() {
    final saved = _local.readAll();
    if (saved.isEmpty) return null;
    // Si hay donde elegir, no repetir el mismo dato dos veces seguidas.
    final options = saved.length > 1
        ? saved.where((f) => f != _lastShown).toList()
        : saved;
    final text = options[_random.nextInt(options.length)];
    _lastShown = text;
    return Ok(CatFact(text: text, origin: DataOrigin.cache));
  }

  Future<void> _saveQuietly(String fact) async {
    try {
      await _local.save(fact);
    } on Object catch (error) {
      logDebug('cache', 'no se pudo guardar el dato', error: error);
    }
  }
}
