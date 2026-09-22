import 'dart:async';
import 'dart:convert';

import 'package:cat_directory_app/core/cache/key_value_store.dart';
import 'package:cat_directory_app/core/utils/clock.dart';

class CacheRecord {
  const CacheRecord({required this.json, required this.storedAt});

  final Object? json;
  final DateTime storedAt;
}

/// Guarda JSON junto con la fecha de escritura y la version del esquema.
///
/// Si la version no coincide (el modelo cambio en una actualizacion de la
/// app) o la entrada esta corrupta, se descarta y se borra: nunca se intenta
/// parsear algo que puede tumbar la pantalla.
class JsonCache {
  JsonCache(
    this._store, {
    required this.schemaVersion,
    Clock clock = const Clock(),
  }) : _clock = clock;

  final KeyValueStore _store;
  final int schemaVersion;
  final Clock _clock;

  CacheRecord? read(String key) {
    final raw = _store.read(key);
    if (raw == null) return null;
    try {
      final envelope = jsonDecode(raw) as Map<String, dynamic>;
      if (envelope['v'] != schemaVersion) {
        unawaited(_store.delete(key));
        return null;
      }
      return CacheRecord(
        json: envelope['d'],
        storedAt: DateTime.fromMillisecondsSinceEpoch(envelope['t'] as int),
      );
    } on Object {
      unawaited(_store.delete(key));
      return null;
    }
  }

  Future<void> write(String key, Object? json) => _store.write(
    key,
    jsonEncode({
      'v': schemaVersion,
      't': _clock.now().millisecondsSinceEpoch,
      'd': json,
    }),
  );

  Iterable<String> keysWithPrefix(String prefix) =>
      _store.keys.where((k) => k.startsWith(prefix));

  Future<void> delete(String key) => _store.delete(key);

  Future<void> clear() => _store.clear();
}
