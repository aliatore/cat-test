import 'package:hive_ce/hive_ce.dart';

/// Almacenamiento clave/valor minimo. Existe para que la capa de datos no
/// dependa de Hive y para poder probarla con un fake en memoria.
abstract interface class KeyValueStore {
  String? read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);

  Future<void> clear();

  Iterable<String> get keys;
}

class HiveKeyValueStore implements KeyValueStore {
  HiveKeyValueStore(this._box);

  final Box<String> _box;

  @override
  String? read(String key) => _box.get(key);

  @override
  Future<void> write(String key, String value) => _box.put(key, value);

  @override
  Future<void> delete(String key) => _box.delete(key);

  @override
  Future<void> clear() => _box.clear();

  @override
  Iterable<String> get keys => _box.keys.cast<String>();
}

class InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, String> _data = {};

  @override
  String? read(String key) => _data[key];

  @override
  Future<void> write(String key, String value) async => _data[key] = value;

  @override
  Future<void> delete(String key) async => _data.remove(key);

  @override
  Future<void> clear() async => _data.clear();

  @override
  Iterable<String> get keys => _data.keys.toList();
}
