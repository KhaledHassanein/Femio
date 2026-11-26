/// Her signs laid out day by day for one cycle (R8.8). Pure: no clock, no UI.
///
/// Why it exists: a temperature, an ovulation test and her discharge are each logged on their
/// own, but she reads them together, by cycle day, side by side. This lines them up exactly as
/// she logged them. It never adds a reading of its own: no temperature shift, no "you
/// ovulated", no named day (MR-16, MR-17, product rule 1). The temperature row reuses the
/// chart geometry in `bbt.dart`, which needs 3 readings (MR-17).
library;

import '../data/profile.dart';
import 'bbt.dart';
import 'cycle_prediction.dart' show bleedStarts;
import 'dates.dart';
import 'log_vocabulary.g.dart';
import 'patterns.dart' show patternRecentCycles;

/// One cycle she can look at: from a period start to the day before the next, or to today
/// for the cycle still running.
class SignCycle {
  const SignCycle(this.start, this.end, {required this.complete});
  final String start;

  /// The last day shown (inclusive).
  final String end;
  final bool complete;

  int get days => diffDays(start, end) + 1;
}

/// What she logged on one cycle day.
class SignDay {
  const SignDay({
    required this.day,
    required this.cycleDay,
    required this.bleeding,
    this.flow,
    this.bbt,
    this.bbtY,
    this.opk,
    this.discharge = const [],
  });
  final String day;

  /// 1 on the first day of the period.
  final int cycleDay;
  final bool bleeding;
  final String? flow;
  final double? bbt;

  /// Where the temperature sits in the cycle's chart, 0 bottom to 1 top; null under 3 readings.
  final double? bbtY;
  final String? opk;

  /// Her discharge words, in vocabulary order.
  final List<String> discharge;

  bool get hasSign => bbt != null || opk != null || discharge.isNotEmpty;
  bool get isEmpty => !hasSign && !bleeding;
}

/// One cycle's days and its temperature scale.
class SignCycleDays {
  const SignCycleDays(this.cycle, this.days, this.chart);
  final SignCycle cycle;
  final List<SignDay> days;

  /// The temperature chart for the cycle, or null with fewer than 3 readings (MR-17).
  final BbtChart? chart;

  int get temperatures => days.where((d) => d.bbt != null).length;
  bool get hasOpk => days.any((d) => d.opk != null);
  bool get hasSigns => days.any((d) => d.hasSign);
}

final _dischargeKeys = [
  for (final t in logTerms)
    if (t.dimension == LogDimension.discharge) t.key,
];

/// Her cycles up to [today], oldest first: the complete ones and the one still running,
/// at most [patternRecentCycles] + 1. Empty with no period start logged.
List<SignCycle> signCycles(Profile profile, String today) {
  final starts = [for (final s in bleedStarts(profile.cycleStarts)) if (s.compareTo(today) <= 0) s];
  final out = [
    for (var i = 0; i < starts.length; i++)
      i + 1 < starts.length
          ? SignCycle(starts[i], addDays(starts[i + 1], -1), complete: true)
          : SignCycle(starts[i], today, complete: false),
  ];
  const keep = patternRecentCycles + 1;
  return out.length <= keep ? out : out.sublist(out.length - keep);
}

/// The cycle that holds [day], or null.
SignCycle? cycleHolding(List<SignCycle> cycles, String day) {
  for (final c in cycles) {
    if (day.compareTo(c.start) >= 0 && day.compareTo(c.end) <= 0) return c;
  }
  return null;
}

/// Every day of [cycle] with what she logged, as she logged it.
SignCycleDays signDays(Profile profile, SignCycle cycle) {
  final bleeds = profile.periodStarts.toSet();
  final chart = bbtChart([
    for (var i = 0; i < cycle.days; i++)
      if (profile.logs[addDays(cycle.start, i)]?.bbt case final v?) BbtEntry(addDays(cycle.start, i), addDays(cycle.start, i), v),
  ], cycle.start);
  final y = {for (final p in chart?.points ?? const <BbtPoint>[]) p.loggedAt: p.y};
  return SignCycleDays(cycle, [
    for (var i = 0; i < cycle.days; i++)
      () {
        final day = addDays(cycle.start, i);
        final log = profile.logs[day];
        return SignDay(
          day: day,
          cycleDay: i + 1,
          bleeding: bleeds.contains(day) || (log?.flow != null),
          flow: log?.flow,
          bbt: log?.bbt,
          bbtY: y[day],
          opk: log?.opk,
          discharge: [for (final k in _dischargeKeys) if (log?.terms.contains(k) ?? false) k],
        );
      }(),
  ], chart);
}

/// How full the ovulation-test mark is drawn, 0 to 1, by its place in `opkResults`
/// (negative to positive), as the strip reads. A drawing of her result, not a meaning.
double opkFill(String result) {
  final i = opkResults.indexOf(result);
  return i < 0 ? 0 : i / (opkResults.length - 1);
}

/// How full the discharge mark is drawn, 0 to 1, by the furthest of her words in the
/// vocabulary order (dry to egg white). A drawing of her words, not a meaning.
double dischargeFill(List<String> words) {
  var best = -1;
  for (final w in words) {
    final i = _dischargeKeys.indexOf(w);
    if (i > best) best = i;
  }
  return best < 0 ? 0 : best / (_dischargeKeys.length - 1);
}
