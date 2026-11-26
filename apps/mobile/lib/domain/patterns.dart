/// Her patterns, counted from what she logged (R8.5, R10.4). Pure: no clock, no UI.
///
/// Why it exists: "seen in 4 of 5 cycles" is the honest way to show a pattern: a count of her
/// own entries, never a cause, a score or a verdict (rule 1). The rules behind every number
/// are in the medical rules register (`01_PRODUCT_SCOPE.md` §4, MR-58 and MR-59):
/// - a cycle runs from the first day of one period to the day before the next (FIGO 2018);
/// - the cycle-length range needs 2 complete cycles; "seen in N of M cycles", the picked
///   statements and the variation note need 3 complete cycles she logged in;
/// - "before your period" is the 5 days before a period starts;
/// - the variation note appears when her complete cycles vary by more than
///   [irregularSpreadDays] days or one falls outside 24 to 38 days (FIGO 2018), and it only
///   suggests mentioning it at a visit. It never says "abnormal" or names a condition.
library;

import '../data/profile.dart';
import 'cycle_prediction.dart';
import 'dates.dart';

/// Complete cycles needed before the cycle-length range is shown (MR-58).
const patternMinCyclesForRange = 2;

/// Complete cycles she logged in, needed before "seen in N of M" and the variation note (MR-58).
const patternMinCycles = 3;

/// How many recent complete cycles the patterns read.
const patternRecentCycles = 12;

/// "Before your period": this many days before a period starts (MR-58).
const premenstrualDays = 5;

/// Cycle lengths inside this range are within the usual frequency (FIGO 2018, MR-59).
const usualCycleShortestDays = 24;
const usualCycleLongestDays = 38;

/// How many picked statements are shown (R10.4).
const patternStatementCount = 3;

/// A statement needs the sign in at least this many cycles (one cycle is not a pattern).
const patternStatementMinSeen = 2;

/// Days counted in the "recent" frequency view for goals without cycles.
const recentPatternDays = 90;

/// Where in a cycle a day falls.
enum CyclePhase { period, beforePeriod }

/// One complete cycle: [start] is the first day of a period, [length] the days to the next.
class CycleSpan {
  const CycleSpan(this.start, this.length, this.bleedDays);
  final String start;
  final int length;

  /// Days of bleeding logged from [start] onward (her period, as logged).
  final int bleedDays;

  /// The ISO day the next period started.
  String get nextStart => addDays(start, length);

  /// Whether [day] falls in [phase] of this cycle.
  bool inPhase(String day, CyclePhase phase) => switch (phase) {
        CyclePhase.period => diffDays(start, day) >= 0 && diffDays(start, day) < bleedDays,
        CyclePhase.beforePeriod => diffDays(day, nextStart) >= 1 && diffDays(day, nextStart) <= premenstrualDays,
      };

  /// Whether [day] falls anywhere in this cycle.
  bool contains(String day) => diffDays(start, day) >= 0 && diffDays(day, nextStart) >= 1;
}

/// How often one logged term showed up in one phase: [seen] of [cycles] cycles.
class PhaseCount {
  const PhaseCount(this.term, this.phase, this.seen, this.cycles);
  final String term;
  final CyclePhase phase;
  final int seen;
  final int cycles;
}

/// What one complete cycle holds besides its length: ovulation-test and temperature entries.
class CycleDetail {
  const CycleDetail(this.span, {required this.daysLogged, required this.opkPositiveDays, required this.temperatures});
  final CycleSpan span;
  final int daysLogged;

  /// Days her ovulation test read high, peak or positive (she reads the stick; femio counts).
  final int opkPositiveDays;
  final int temperatures;
}

/// Everything the Patterns screen shows for a cycle goal.
class CyclePatterns {
  const CyclePatterns({required this.cycles, required this.loggedCycles, required this.counts, required this.details});

  /// Complete cycles, oldest first, at most [patternRecentCycles].
  final List<CycleSpan> cycles;

  /// How many of [cycles] have at least one day logged.
  final int loggedCycles;

  /// Every term seen at least once in a phase, most cycles first.
  final List<PhaseCount> counts;

  /// One row per cycle, newest first.
  final List<CycleDetail> details;

  bool get hasRange => cycles.length >= patternMinCyclesForRange;
  bool get hasCounts => loggedCycles >= patternMinCycles;
  int get shortest => cycles.map((c) => c.length).reduce((a, b) => a < b ? a : b);
  int get longest => cycles.map((c) => c.length).reduce((a, b) => a > b ? a : b);

  /// Whether the variation note applies (MR-59): enough cycles, and they vary by more than
  /// [irregularSpreadDays] days or one is outside [usualCycleShortestDays]-[usualCycleLongestDays].
  bool get varies =>
      cycles.length >= patternMinCycles &&
      (longest - shortest > irregularSpreadDays ||
          cycles.any((c) => c.length < usualCycleShortestDays || c.length > usualCycleLongestDays));

  /// Up to [patternStatementCount] counts worth saying (R10.4): seen in at least
  /// [patternStatementMinSeen] cycles, most cycles first; empty before [hasCounts].
  List<PhaseCount> get statements =>
      hasCounts ? counts.where((c) => c.seen >= patternStatementMinSeen).take(patternStatementCount).toList() : const [];
}

/// Her complete cycles from [profile]'s period days, oldest first, the most recent
/// [patternRecentCycles]. The cycle still running is not complete and is left out.
List<CycleSpan> completeCycles(Profile profile) {
  final bleeds = profile.periodStarts.toSet();
  final starts = bleedStarts(profile.cycleStarts);
  final out = <CycleSpan>[];
  for (var i = 0; i + 1 < starts.length; i++) {
    var run = 0;
    while (bleeds.contains(addDays(starts[i], run))) {
      run++;
    }
    out.add(CycleSpan(starts[i], diffDays(starts[i], starts[i + 1]), run == 0 ? 1 : run));
  }
  return out.length <= patternRecentCycles ? out : out.sublist(out.length - patternRecentCycles);
}

/// Counts her logs against her complete cycles. Only terms she logged are counted, and a
/// cycle counts toward "M" only if she logged something in it.
CyclePatterns cyclePatterns(Profile profile) {
  final cycles = completeCycles(profile);
  final logged = <CycleSpan>[];
  final details = <CycleDetail>[];
  final seen = <(String, CyclePhase), int>{};
  for (final c in cycles) {
    final days = [
      for (final e in profile.logs.entries)
        if (c.contains(e.key) && !e.value.isEmpty) e,
    ];
    if (days.isNotEmpty) logged.add(c);
    details.add(CycleDetail(
      c,
      daysLogged: days.length,
      opkPositiveDays: days.where((e) => const {'high', 'peak', 'positive'}.contains(e.value.opk)).length,
      temperatures: days.where((e) => e.value.bbt != null).length,
    ));
    for (final phase in CyclePhase.values) {
      final terms = {
        for (final e in days)
          if (c.inPhase(e.key, phase)) ...e.value.terms,
      };
      for (final t in terms) {
        seen[(t, phase)] = (seen[(t, phase)] ?? 0) + 1;
      }
    }
  }
  final counts = [
    for (final e in seen.entries) PhaseCount(e.key.$1, e.key.$2, e.value, logged.length),
  ]..sort((a, b) {
      final bySeen = b.seen.compareTo(a.seen);
      if (bySeen != 0) return bySeen;
      final byPhase = a.phase.index.compareTo(b.phase.index);
      return byPhase != 0 ? byPhase : a.term.compareTo(b.term);
    });
  return CyclePatterns(cycles: cycles, loggedCycles: logged.length, counts: counts, details: details.reversed.toList());
}

/// For goals without cycles (pregnancy, menopause): each term she logged in the
/// [recentPatternDays] days ending [today], with the number of days, most days first.
List<({String term, int days})> recentTermDays(Profile profile, String today) {
  final from = addDays(today, -(recentPatternDays - 1));
  final days = <String, int>{};
  for (final e in profile.logs.entries) {
    if (e.key.compareTo(from) < 0 || e.key.compareTo(today) > 0) continue;
    for (final t in e.value.terms.toSet()) {
      days[t] = (days[t] ?? 0) + 1;
    }
  }
  return [for (final e in days.entries) (term: e.key, days: e.value)]
    ..sort((a, b) => b.days != a.days ? b.days.compareTo(a.days) : a.term.compareTo(b.term));
}
