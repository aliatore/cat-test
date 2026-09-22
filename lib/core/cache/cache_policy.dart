/// Estado de una entrada de cache segun su edad.
enum CacheFreshness {
  /// Se sirve tal cual, sin tocar la red.
  fresh,

  /// Se sirve de inmediato y se revalida en segundo plano
  /// (stale-while-revalidate).
  stale,

  /// Ya no es confiable: se invalida y se borra.
  expired,
}

/// Politica explicita de invalidacion/revalidacion.
///
/// La API responde `Cache-Control: no-cache` y no expone ETag ni
/// Last-Modified, asi que la frescura se decide en el cliente.
class CachePolicy {
  const CachePolicy({required this.freshFor, required this.maxAge});

  /// Razas: el catalogo cambia muy poco, pero no queremos servir una semana
  /// de datos sin preguntar.
  static const breeds = CachePolicy(
    freshFor: Duration(minutes: 5),
    maxAge: Duration(days: 7),
  );

  final Duration freshFor;
  final Duration maxAge;

  CacheFreshness evaluate(DateTime storedAt, DateTime now) {
    final age = now.difference(storedAt);
    // Si el reloj del telefono se movio hacia atras no podemos fiarnos de la
    // edad: se muestra, pero se revalida.
    if (age.isNegative) return CacheFreshness.stale;
    if (age < freshFor) return CacheFreshness.fresh;
    if (age < maxAge) return CacheFreshness.stale;
    return CacheFreshness.expired;
  }
}
