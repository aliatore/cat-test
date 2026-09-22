import 'package:bloc_test/bloc_test.dart';
import 'package:cat_directory_app/core/error/failure.dart';
import 'package:cat_directory_app/core/presentation/connectivity_cubit.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/features/breeds/presentation/pages/breeds_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class _MockBreedsBloc extends MockBloc<BreedsEvent, BreedsState>
    implements BreedsBloc {}

class _MockConnectivity extends MockCubit<ConnectivityState>
    implements ConnectivityCubit {}

void main() {
  late _MockBreedsBloc bloc;
  late _MockConnectivity connectivity;

  const breeds = [
    Breed(name: 'Abyssinian', country: 'Ethiopia'),
    Breed(name: 'Aegean', country: 'Greece'),
  ];

  setUp(() {
    bloc = _MockBreedsBloc();
    connectivity = _MockConnectivity();
    when(() => connectivity.state).thenReturn(const ConnectivityState());
  });

  Future<void> pumpPage(WidgetTester tester, BreedsState state) async {
    when(() => bloc.state).thenReturn(state);
    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<BreedsBloc>.value(value: bloc),
          BlocProvider<ConnectivityCubit>.value(value: connectivity),
        ],
        child: BreedsPage(onOpenBreed: (_) {}),
      ),
    );
    await tester.pump();
  }

  testWidgets('mientras carga muestra el esqueleto y lo anuncia', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpPage(tester, const BreedsState(status: BreedsStatus.loading));

    expect(find.bySemanticsLabel('Cargando razas'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('sin datos y sin red explica que paso y deja reintentar', (
    tester,
  ) async {
    await pumpPage(
      tester,
      const BreedsState(
        status: BreedsStatus.failure,
        failure: Failure.connection(),
      ),
    );

    expect(find.text('Sin conexión a la red felina'), findsOneWidget);
    await tester.tap(find.text('REINTENTAR'));
    verify(() => bloc.add(const BreedsRetryRequested())).called(1);
  });

  testWidgets('si falla una pagina intermedia la lista sigue ahi', (
    tester,
  ) async {
    await pumpPage(
      tester,
      const BreedsState(
        status: BreedsStatus.success,
        breeds: breeds,
        visible: breeds,
        pages: {1: breeds},
        lastPage: 3,
        paginationFailure: Failure.timeout(),
      ),
    );

    expect(find.text('Abyssinian'), findsOneWidget);
    expect(
      find.text('No se pudo cargar la página siguiente. La lista sigue aquí.'),
      findsOneWidget,
    );
  });

  testWidgets('una busqueda sin resultados lo dice con el texto buscado', (
    tester,
  ) async {
    await pumpPage(
      tester,
      const BreedsState(
        status: BreedsStatus.success,
        breeds: breeds,
        query: 'zzz',
        pages: {1: breeds},
        lastPage: 3,
      ),
    );

    expect(find.text('Ningún gato responde a «zzz»'), findsOneWidget);
  });

  testWidgets('sin red avisa de cuando son los datos que se ven', (
    tester,
  ) async {
    when(
      () => connectivity.state,
    ).thenReturn(const ConnectivityState(online: false));
    await pumpPage(
      tester,
      BreedsState(
        status: BreedsStatus.success,
        breeds: breeds,
        visible: breeds,
        pages: const {1: breeds},
        lastPage: 3,
        updatedAt: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
    );

    expect(
      find.text('Sin conexión. Mostrando datos guardados hace 12 minutos.'),
      findsOneWidget,
    );
  });
}
