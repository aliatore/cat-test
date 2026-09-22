import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cat_directory_app/core/domain/data_origin.dart';
import 'package:cat_directory_app/core/error/failure.dart';
import 'package:cat_directory_app/core/error/result.dart';
import 'package:cat_directory_app/features/facts/domain/entities/cat_fact.dart';
import 'package:cat_directory_app/features/facts/domain/repositories/cat_fact_repository.dart';
import 'package:cat_directory_app/features/facts/domain/usecases/get_random_fact.dart';
import 'package:cat_directory_app/features/facts/presentation/bloc/cat_fact_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements CatFactRepository {}

void main() {
  late _MockRepository repository;
  const fact = CatFact(
    text: 'Cats sleep 70% of their lives.',
    origin: DataOrigin.remote,
  );

  setUp(() => repository = _MockRepository());

  CatFactBloc build() => CatFactBloc(getRandomFact: GetRandomFact(repository));

  blocTest<CatFactBloc, CatFactState>(
    'tiene su propio estado de carga y luego muestra el dato',
    setUp: () => when(
      () => repository.getRandomFact(),
    ).thenAnswer((_) async => const Ok(fact)),
    build: build,
    act: (bloc) => bloc.add(const CatFactRequested()),
    expect: () => const [CatFactState.loading(), CatFactState.loaded(fact)],
  );

  blocTest<CatFactBloc, CatFactState>(
    'un fallo queda contenido en el bloque del dato',
    setUp: () => when(
      () => repository.getRandomFact(),
    ).thenAnswer((_) async => const Err(Failure.connection())),
    build: build,
    act: (bloc) => bloc.add(const CatFactRequested()),
    expect: () => const [
      CatFactState.loading(),
      CatFactState.failure(Failure.connection()),
    ],
  );

  test(
    'pedir otro dato varias veces seguidas hace una sola peticion',
    () async {
      final pending = Completer<Result<CatFact>>();
      when(() => repository.getRandomFact()).thenAnswer((_) => pending.future);
      final bloc = build()
        ..add(const CatFactRequested())
        ..add(const CatFactRequested())
        ..add(const CatFactRequested());

      await pumpEventQueue();
      pending.complete(const Ok(fact));
      await pumpEventQueue();

      verify(() => repository.getRandomFact()).called(1);
      await bloc.close();
    },
  );
}
