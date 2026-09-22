/// Reloj inyectable para que la logica de expiracion sea testeable.
class Clock {
  const Clock();

  DateTime now() => DateTime.now();
}
