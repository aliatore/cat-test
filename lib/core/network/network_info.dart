import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:stream_transform/stream_transform.dart';

/// Estado de la conectividad del dispositivo.
///
/// connectivity_plus solo sabe si hay una interfaz de red activa, no si hay
/// internet de verdad; por eso se usa para cortar camino cuando es seguro que
/// no hay red, y el resto lo deciden los errores reales de cada peticion.
abstract interface class NetworkInfo {
  Future<bool> get isConnected;

  Stream<bool> get onStatusChange;
}

class ConnectivityNetworkInfo implements NetworkInfo {
  ConnectivityNetworkInfo(this._connectivity) {
    _raw = _connectivity.onConnectivityChanged
        .map(_isOnline)
        .asBroadcastStream();
    _subscription = _raw.listen((online) => _last = online);
  }

  /// Cambios de red mas cortos que esto no llegan a la UI (evita el
  /// "sin red -> conectado" que reporta iOS al arrancar).
  static const _settle = Duration(milliseconds: 600);

  final Connectivity _connectivity;
  late final Stream<bool> _raw;
  late final StreamSubscription<bool> _subscription;
  bool? _last;

  @override
  Future<bool> get isConnected async {
    final last = _last;
    if (last != null) return last;
    try {
      if (_isOnline(await _connectivity.checkConnectivity())) return true;
      // Al arrancar, iOS puede decir "sin red" antes de que el monitor reciba
      // su primera ruta. Se espera un instante a la primera lectura real.
      return await _raw.first.timeout(_settle, onTimeout: () => false);
    } on PlatformException {
      // Si el plugin falla preferimos intentar la peticion a bloquearla.
      return true;
    }
  }

  @override
  Stream<bool> get onStatusChange => _raw.debounce(_settle).distinct();

  Future<void> dispose() => _subscription.cancel();

  static bool _isOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
