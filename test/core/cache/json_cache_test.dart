import 'package:cat_directory_app/core/cache/json_cache.dart';
import 'package:cat_directory_app/core/cache/key_value_store.dart';
import 'package:cat_directory_app/core/utils/clock.dart';
import 'package:flutter_test/flutter_test.dart';

class _FixedClock extends Clock {
  _FixedClock(this.value);

  final DateTime value;

  @override
  DateTime now() => value;
}

void main() {
  late InMemoryKeyValueStore store;
  final writtenAt = DateTime(2026, 9, 22, 10, 30);

  setUp(() => store = InMemoryKeyValueStore());

  test('guarda el JSON con la fecha de escritura', () async {
    final cache = JsonCache(
      store,
      schemaVersion: 1,
      clock: _FixedClock(writtenAt),
    );

    await cache.write('page_1', {'breed': 'Abyssinian'});
    final record = cache.read('page_1');

    expect(record?.json, {'breed': 'Abyssinian'});
    expect(record?.storedAt, writtenAt);
  });

  test('descarta y borra entradas de otra version del esquema', () async {
    await JsonCache(store, schemaVersion: 1).write('page_1', {'a': 1});

    final cache = JsonCache(store, schemaVersion: 2);

    expect(cache.read('page_1'), isNull);
    await pumpEventQueue();
    expect(store.read('page_1'), isNull);
  });

  test('una entrada corrupta no revienta: se ignora y se borra', () async {
    await store.write('page_1', '{no es json');
    final cache = JsonCache(store, schemaVersion: 1);

    expect(cache.read('page_1'), isNull);
    await pumpEventQueue();
    expect(store.keys, isEmpty);
  });

  test('lista las claves por prefijo', () async {
    final cache = JsonCache(store, schemaVersion: 1);
    await cache.write('breeds_page_1', 1);
    await cache.write('breeds_page_2', 2);
    await cache.write('facts', 3);

    expect(cache.keysWithPrefix('breeds_page_'), hasLength(2));
  });
}
