import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

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
  ConnectivityNetworkInfo(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    try {
      return _isOnline(await _connectivity.checkConnectivity());
    } on PlatformException {
      // Si el plugin falla preferimos intentar la peticion a bloquearla.
      return true;
    }
  }

  @override
  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.map(_isOnline).distinct();

  static bool _isOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
