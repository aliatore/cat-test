import 'package:cat_directory_app/core/utils/slug.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('nombres simples', () {
    expect(slugify('Abyssinian'), 'abyssinian');
    expect(slugify('American Curl'), 'american-curl');
  });

  test('limpia los nombres raros que trae la API', () {
    expect(slugify('Foldex[4]'), 'foldex');
    expect(
      slugify('PerFoldæ(Experimental Breed - WCF)'),
      'perfoldae-experimental-breed-wcf',
    );
    expect(slugify('Donskoy, or Don Sphynx'), 'donskoy-or-don-sphynx');
    expect(
      slugify('Persian (Modern Persian Cat)'),
      'persian-modern-persian-cat',
    );
  });

  test('es idempotente, asi un slug resuelve a si mismo', () {
    const slug = 'kurilian-bobtail-or-kuril-islands-bobtail';
    expect(slugify(slug), slug);
    expect(slugify('American%20Curl'.replaceAll('%20', ' ')), 'american-curl');
  });
}
