// The signs she logged this cycle, gathered for one card on the trying-to-conceive Today (R8.27).
//
// Why it exists: a woman trying to conceive often logs her fluid, an ovulation test and her
// waking temperature on different screens and days. This gathers the latest of each since her
// last period started, as she logged them. It never combines them into a conclusion: no
// "you ovulated", no shift, no named day (MR-16, MR-17, product rule 1). The card that draws it
// adds the MR-16 sentence whenever a test result is shown.

import '../data/profile.dart';
import 'bbt.dart' show unitOf;
import 'cycle_prediction.dart' show bleedStarts;
import 'log_vocabulary.g.dart';

/// One reading and the day she logged it (ISO `yyyy-mm-dd`).
class SignReading<T> {
  const SignReading(this.day, this.value);
  final String day;
  final T value;
}

/// The latest of each sign in the current cycle.
class CycleSigns {
  const CycleSigns({this.discharge, this.opk, this.bbt, this.bbtUnit, this.bbtCount = 0});

  /// The discharge words she chose on the latest day she logged any (vocabulary keys,
  /// in vocabulary order). Null when none this cycle.
  final SignReading<List<String>>? discharge;

  /// The latest ovulation-test result, verbatim (`opkResults`).
  final SignReading<String>? opk;

  /// The latest waking temperature, in the unit she typed.
  final SignReading<double>? bbt;

  /// `c` or `f` for [bbt], guessed from its size like the chart does; null if implausible.
  final String? bbtUnit;

  /// How many temperatures she logged this cycle (the chart needs three, MR-17).
  final int bbtCount;

  bool get isEmpty => discharge == null && opk == null && bbt == null;
}

final _dischargeKeys = [
  for (final t in logTerms)
    if (t.dimension == LogDimension.discharge) t.key,
];

/// Gathers [logs] from the start of the current cycle up to and including [today].
///
/// The cycle starts at the last bleed start in [periodStarts] on or before [today]; with
/// no start logged, every day up to [today] counts. Future days are ignored. Days are
/// ISO strings, compared as text. Returns an empty [CycleSigns] when nothing fits.
CycleSigns cycleSigns(Map<String, DayLog> logs, List<String> periodStarts, String today) {
  final starts = [for (final s in bleedStarts(periodStarts)) if (s.compareTo(today) <= 0) s];
  final since = starts.isEmpty ? null : starts.last;
  final days = [
    for (final d in logs.keys)
      if (d.compareTo(today) <= 0 && (since == null || d.compareTo(since) >= 0)) d,
  ]..sort();

  SignReading<List<String>>? discharge;
  SignReading<String>? opk;
  SignReading<double>? bbt;
  var bbtCount = 0;
  for (final d in days) {
    final log = logs[d]!;
    final words = [for (final k in _dischargeKeys) if (log.terms.contains(k)) k];
    if (words.isNotEmpty) discharge = SignReading(d, words);
    if (log.opk != null) opk = SignReading(d, log.opk!);
    if (log.bbt != null) {
      bbt = SignReading(d, log.bbt!);
      bbtCount++;
    }
  }
  return CycleSigns(
    discharge: discharge,
    opk: opk,
    bbt: bbt,
    bbtUnit: bbt == null ? null : unitOf(bbt.value),
    bbtCount: bbtCount,
  );
}
