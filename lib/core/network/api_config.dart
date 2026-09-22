abstract final class ApiConfig {
  static const baseUrl = 'https://catfact.ninja';

  static const connectTimeout = Duration(seconds: 8);
  static const receiveTimeout = Duration(seconds: 10);

  /// La API devuelve 98 razas. Con 15 por pagina el scroll infinito se
  /// ejercita de verdad (7 paginas) sin castigar la red.
  static const breedsPageSize = 15;

  /// Los datos curiosos largos rompen la tarjeta del detalle.
  static const factMaxLength = 240;
}
