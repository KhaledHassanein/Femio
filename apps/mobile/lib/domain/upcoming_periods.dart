// The next few periods after her entries, each a range with a confidence word (MR-51).
//
// Why it exists: the owner asked that the calendar show the calculated next periods
// once she has logged (R8.10). Twin of `apps/web/src/lib/cycle/upcoming.ts`, bound by
// `fixtures/domain/upcoming-periods.json`; the reasoning lives in the TypeScript file.

import 'dart:math' as math;

import 'cycle_prediction.dart';
import 'dates.dart';

/// MR-51: how many periods the calendar shows ahead.
const upcomingPeriodCount = 3;

/// One predicted period: a range and how sure the range is.
class UpcomingPeriod {
  const UpcomingPeriod(
    this.predictedStart,
    this.windowStart,
    this.windowEnd,
    this.confidence,
  );
  final String predictedStart;
  final String windowStart;
  final String windowEnd;
  final Confidence confidence;

  Map<String, Object> toJson() => {
    'predictedStart': predictedStart,
    'windowStart': windowStart,
    'windowEnd': windowEnd,
    'confidence': confidence.name,
  };
}

/// The next [count] periods from [prediction], in date order.
///
/// Period k starts k average lengths after her last start, with a half-width of
/// `ceil(margin × √k)`; confidence drops one level per later period, never below
/// low. Returns only the first when her cycles are irregular or still being learned
/// (MR-06), and an empty list when [prediction] is null.
List<UpcomingPeriod> upcomingPeriods(
  CyclePrediction? prediction, {
  int count = upcomingPeriodCount,
}) {
  if (prediction == null || count < 1) return const [];
  final total = prediction.irregular || prediction.learning ? 1 : count;
  final first = prediction.confidence.index;
  return [
    for (var k = 1; k <= total; k++)
      () {
        final start = addDays(
          prediction.predictedStart,
          (k - 1) * prediction.averageLength,
        );
        final margin = (prediction.evidence.margin * math.sqrt(k)).ceil();
        return UpcomingPeriod(
          start,
          addDays(start, -margin),
          addDays(start, margin),
          Confidence.values[math.min(
            Confidence.values.length - 1,
            first + k - 1,
          )],
        );
      }(),
  ];
}
