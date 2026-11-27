// The fertile window, and when there is honestly none to name.
//
// Why it exists: the register (MR-06, MR-07, MR-08) says ovulation is estimated
// 14 days before the next period and the window is the six days ending on it, and
// that no window is named when cycles are irregular, still being learned, or outside
// 21 to 35 days: a day she cannot rely on is worse than no day. Twin of
// `fertileWindow` in `apps/web/src/lib/calculators/index.ts`, bound by
// `fixtures/domain/fertile-window.json`. Awareness only (product rule 1): never a
// way to avoid pregnancy.

import '../data/profile.dart';
import 'cycle_prediction.dart';
import 'dates.dart';
import 'forecast.dart';

/// The six-day window and the day it ends on.
class FertileWindow {
  const FertileWindow(this.ovulation, this.windowStart, this.windowEnd);
  final String ovulation;
  final String windowStart;
  final String windowEnd;

  Map<String, Object?> toJson() => {'ovulation': ovulation, 'windowStart': windowStart, 'windowEnd': windowEnd};
}

/// MR-07: ovulation this many days before the next period.
const lutealPhaseDays = 14;

/// MR-07: the window is this many days, ending on ovulation day.
const fertileWindowDays = 6;

/// MR-08: a window is named only for cycle lengths in this range.
const regularCycleMin = 21;
const regularCycleMax = 35;

/// The window before [nextPeriodISO], or null when none can be named honestly
/// (MR-06): irregular cycles, a prediction still being learned, or a cycle length
/// outside the regular range. A null [cycleLength] (she said "not sure") also
/// withholds the window.
FertileWindow? fertileWindowBefore(
  String nextPeriodISO, {
  required int? cycleLength,
  required bool irregular,
  required bool learning,
}) {
  if (irregular || learning || cycleLength == null) return null;
  if (cycleLength < regularCycleMin || cycleLength > regularCycleMax) return null;
  final ovulation = addDays(nextPeriodISO, -lutealPhaseDays);
  return FertileWindow(ovulation, addDays(ovulation, -(fertileWindowDays - 1)), ovulation);
}

// App-only glue (no TypeScript twin): the inputs the calendar, Today and the explainers
// pass to [fertileWindowBefore], so all three agree on when a window is named.

/// Whether a fertile window is named, and if not, which rule withheld it (MR-06, MR-08).
enum WindowStatus { shown, irregular, learning, outsideRange }

/// The fertile window the app shows for [profile] and [prediction], or null when none can
/// be named. The one place the calendar, Today and the explainers ask (MR-06..08).
FertileWindow? fertileWindowFor(Profile profile, CyclePrediction prediction) =>
    _windowBefore(profile, prediction, prediction.predictedStart);

/// One window before each predicted period the calendar draws (MR-57): this cycle's
/// first, then one per later period. Empty when the rule withholds a window. Each is
/// MR-07's six days before that period's middle date; the period range around it
/// already widens with distance, so the window is not drawn as more certain than it is.
List<FertileWindow> fertileWindowsFor(Profile profile, CyclePrediction prediction) => [
      for (final u in upcomingFor(profile, prediction))
        ?_windowBefore(profile, prediction, u.predictedStart),
    ];

/// The window Today headlines: the first that has not ended by [today] (this cycle's, or
/// the next once it has passed), or null when the rule withholds a window. Owner
/// 2026-11-26: a window already lived is history for the calendar, not news for Today.
FertileWindow? currentOrNextFertileWindow(Profile profile, CyclePrediction prediction, String today) {
  final windows = fertileWindowsFor(profile, prediction);
  for (final w in windows) {
    if (w.windowEnd.compareTo(today) >= 0) return w;
  }
  return windows.isEmpty ? null : windows.last;
}

FertileWindow? _windowBefore(Profile profile, CyclePrediction prediction, String nextStart) =>
    fertileWindowBefore(
      nextStart,
      // CLIN-17 (R14.12): once the forecast comes from her own cycles, MR-08 checks her
      // observed length, not the one she stated at onboarding.
      cycleLength: prediction.basis == 'observed'
          ? prediction.averageLength
          : (profile.cycleLength ?? prediction.averageLength),
      irregular: prediction.irregular || profile.irregular,
      learning: prediction.learning && prediction.basis != 'stated',
    );

/// Why [fertileWindowFor] returned what it did, in the order the rule checks.
WindowStatus windowStatusFor(Profile profile, CyclePrediction prediction) {
  if (prediction.irregular || profile.irregular) return WindowStatus.irregular;
  if (prediction.learning && prediction.basis != 'stated') return WindowStatus.learning;
  return fertileWindowFor(profile, prediction) == null ? WindowStatus.outsideRange : WindowStatus.shown;
}
