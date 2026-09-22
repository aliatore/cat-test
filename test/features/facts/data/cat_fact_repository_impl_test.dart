import 'dart:math';

import 'package:cat_directory_app/core/cache/json_cache.dart';
import 'package:cat_directory_app/core/cache/key_value_store.dart';
import 'package:cat_directory_app/core/domain/data_origin.dart';
import 'package:cat_directory_app/core/error/failure.dart';
import 'package:cat_directory_app/core/error/result.dart';
import 'package:cat_directory_app/features/facts/data/datasources/cat_fact_data_sources.dart';
import 'package:cat_directory_app/features/facts/data/models/cat_fact_dto.dart';
import 'package:cat_directory_app/features/facts/data/repositories/cat_fact_repository_impl.dart';
import 'package:cat_directory_app/features/facts/domain/entities/cat_fact.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes.dart';

class _MockRemote extends Mock implements CatFactRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late JsonCatFactLocalDataSource local;
  late FakeNetworkInfo network;
  late CatFactRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    network = FakeNetworkInfo();
    local = JsonCatFactLocalDataSource(
      JsonCache(InMemoryKeyValueStore(), schemaVersion: 1),
    );
    repository = CatFactRepositoryImpl(
      remote: remote,
      local: local,
      networkInfo: network,
      random: Random(1),
    );
  });

  test('con red devuelve el dato de la API y lo guarda para despues', () async {
    when(
      () => remote.fetchRandom(maxLength: any(named: 'maxLength')),
    ).thenAnswer((_) async => const CatFactDto(fact: ' Cats sleep a lot. '));

    final result = await repository.getRandomFact();

    expect(
      result,
      const Ok(CatFact(text: 'Cats sleep a lot.', origin: DataOrigin.remote)),
    );
    expect(local.readAll(), ['Cats sleep a lot.']);
  });

  test('sin red usa un dato guardado', () async {
    await local.save('Cats have 32 muscles in each ear.');
    network.online = false;

    final result = await repository.getRandomFact();

    expect(result.valueOrNull?.origin, DataOrigin.cache);
    verifyNever(() => remote.fetchRandom(maxLength: any(named: 'maxLength')));
  });

  test('si la API falla tambien cae a un dato guardado', () async {
    await local.save('A group of cats is called a clowder.');
    when(
      () => remote.fetchRandom(maxLength: any(named: 'maxLength')),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/fact'),
        type: DioExceptionType.connectionTimeout,
      ),
    );

    final result = await repository.getRandomFact();

    expect(result.valueOrNull?.text, 'A group of cats is called a clowder.');
  });

  test('sin red y sin datos guardados falla', () async {
    network.online = false;

    expect(
      await repository.getRandomFact(),
      const Err<CatFact>(Failure.connection()),
    );
  });

  test('offline no repite el mismo dato dos veces seguidas', () async {
    await local.save('uno');
    await local.save('dos');
    network.online = false;

    final first = await repository.getRandomFact();
    final second = await repository.getRandomFact();

    expect(first.valueOrNull?.text, isNot(second.valueOrNull?.text));
  });
}
