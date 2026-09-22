import 'dart:math';

/// Backoff exponencial con jitter parcial: la mitad del retardo es fija y la
/// otra mitad aleatoria, asi los reintentos de varios clientes no llegan en
/// rafaga al mismo segundo pero nunca se reintenta "ya mismo".
class ExponentialBackoff {
  const ExponentialBackoff({
    this.initialDelay = const Duration(milliseconds: 400),
    this.maxDelay = const Duration(seconds: 4),
    this.factor = 2,
    this.jitter = 0.5,
  }) : assert(jitter >= 0 && jitter <= 1, 'jitter va de 0 a 1');

  final Duration initialDelay;
  final Duration maxDelay;
  final double factor;

  /// Fraccion del retardo que se aleatoriza (0 = determinista).
  final double jitter;

  /// [attempt] empieza en 0 para el primer reintento.
  Duration delayFor(int attempt, {Random? random}) {
    final raw = initialDelay.inMicroseconds * pow(factor, attempt);
    final capped = min(raw.toDouble(), maxDelay.inMicroseconds.toDouble());
    if (jitter == 0 || random == null) {
      return Duration(microseconds: capped.round());
    }
    final fixed = capped * (1 - jitter);
    final variable = capped * jitter * random.nextDouble();
    return Duration(microseconds: (fixed + variable).round());
  }
}
