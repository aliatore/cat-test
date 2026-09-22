const _transliterations = {
  'á': 'a',
  'à': 'a',
  'â': 'a',
  'ä': 'a',
  'ã': 'a',
  'å': 'a',
  'é': 'e',
  'è': 'e',
  'ê': 'e',
  'ë': 'e',
  'í': 'i',
  'ì': 'i',
  'î': 'i',
  'ï': 'i',
  'ó': 'o',
  'ò': 'o',
  'ô': 'o',
  'ö': 'o',
  'õ': 'o',
  'ø': 'o',
  'ú': 'u',
  'ù': 'u',
  'û': 'u',
  'ü': 'u',
  'æ': 'ae',
  'œ': 'oe',
  'ñ': 'n',
  'ç': 'c',
  'ß': 'ss',
};

final _footnote = RegExp(r'\[\d+\]');
final _nonAlphanumeric = RegExp('[^a-z0-9]+');
final _edgeDashes = RegExp(r'^-+|-+$');

/// Convierte un nombre de raza en un segmento de URL estable:
/// `PerFoldæ(Experimental Breed - WCF)` -> `perfoldae-experimental-breed-wcf`.
///
/// Se usa tanto para construir la ruta `/breed/:name` como para resolverla,
/// asi que `/breed/American%20Curl` y `/breed/american-curl` llevan al mismo
/// lugar.
String slugify(String input) {
  final lower = input.replaceAll(_footnote, '').toLowerCase();
  final buffer = StringBuffer();
  for (final rune in lower.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(_transliterations[char] ?? char);
  }
  return buffer
      .toString()
      .replaceAll(_nonAlphanumeric, '-')
      .replaceAll(_edgeDashes, '');
}
