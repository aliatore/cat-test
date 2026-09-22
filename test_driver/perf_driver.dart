import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

/// Guarda el resumen de la traza en docs/performance/.
Future<void> main() => integrationDriver(
  responseDataCallback: (data) async {
    final raw = data?['scroll_timeline'];
    if (raw == null) return;
    final timeline = driver.Timeline.fromJson(raw as Map<String, dynamic>);
    await driver.TimelineSummary.summarize(timeline).writeTimelineToFile(
      'scroll_timeline',
      pretty: true,
      destinationDirectory: 'docs/performance',
    );
  },
);
