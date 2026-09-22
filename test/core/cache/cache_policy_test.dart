import 'package:cat_directory_app/core/cache/cache_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // 5 minutos fresca, 7 dias como maximo
  const policy = CachePolicy.breeds;
  final now = DateTime(2026, 9, 22, 12);

  CacheFreshness ageOf(Duration age) => policy.evaluate(now.subtract(age), now);

  test('dentro del TTL la entrada es fresca', () {
    expect(ageOf(Duration.zero), CacheFreshness.fresh);
    expect(
      ageOf(const Duration(minutes: 4, seconds: 59)),
      CacheFreshness.fresh,
    );
  });

  test('pasado el TTL se sirve pero hay que revalidar', () {
    expect(ageOf(const Duration(minutes: 5)), CacheFreshness.stale);
    expect(ageOf(const Duration(days: 6)), CacheFreshness.stale);
  });

  test('pasada la edad maxima se invalida', () {
    expect(ageOf(const Duration(days: 7)), CacheFreshness.expired);
    expect(ageOf(const Duration(days: 40)), CacheFreshness.expired);
  });

  test('una fecha en el futuro (reloj movido) obliga a revalidar', () {
    expect(
      policy.evaluate(now.add(const Duration(hours: 1)), now),
      CacheFreshness.stale,
    );
  });
}
