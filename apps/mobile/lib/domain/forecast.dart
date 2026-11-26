// What the calendar and Today may say about her next periods, and why they say nothing.
//
// Why it exists: the owner saw a calendar with only her past period and no word about
// why (2026-11-26, R14.7). The twin rules (`predictNextPeriod`, `upcomingPeriods`) know
// nothing of her profile; this app-only glue adds the two profile facts they cannot see:
// her own "my cycles are irregular" answer (MR-51: then only the next period), and
// today's date (MR-57: no range already past). Both surfaces ask here, so Today and the
// calendar always agree.

import '../data/profile.dart';
import 'cycle_prediction.dart';
import 'upcoming_periods.dart';

/// Why there is no period range ahead to show, in the order the rules decide it.
enum ForecastGap {
  /// She has logged no period start (for example "I don't remember" in onboarding).
  noPeriodLogged,

  /// One start and no usual length ("Not sure"): adding her length fixes it.
  needLength,

  /// She said her cycles are irregular, or her logged gaps are too long to be cycles:
  /// femio waits for her next period.
  needAnother,

  /// Every range femio worked out has already passed without a new start logged.
  allPassed,
}

/// The next periods for [profile], only the first when she called her cycles irregular
/// (MR-51), or what [upcomingPeriods] returns otherwise. Empty when [prediction] is null.
List<UpcomingPeriod> upcomingFor(Profile profile, CyclePrediction? prediction) =>
    upcomingPeriods(prediction, count: profile.irregular ? 1 : upcomingPeriodCount);

/// The periods from [upcomingFor] that have not ended before [today] (ISO). A range already
/// past would read as a "late" counter (rule 3), so neither surface shows one.
List<UpcomingPeriod> upcomingAhead(Profile profile, String today) => [
      for (final u in upcomingFor(profile, predictNextPeriod(profile.cycleStarts, profile.cycleLength)))
        if (u.windowEnd.compareTo(today) >= 0) u,
    ];

/// Why nothing is ahead for [profile] on [today], or null when a range is ahead.
ForecastGap? forecastGap(Profile profile, String today) {
  if (upcomingAhead(profile, today).isNotEmpty) return null;
  final starts = bleedStarts(profile.cycleStarts);
  if (starts.isEmpty) return ForecastGap.noPeriodLogged;
  if (predictNextPeriod(profile.cycleStarts, profile.cycleLength) != null) return ForecastGap.allPassed;
  if (starts.length == 1 && !profile.irregular) return ForecastGap.needLength;
  return ForecastGap.needAnother;
}
