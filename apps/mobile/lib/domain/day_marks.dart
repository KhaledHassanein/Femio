import '../data/profile.dart';
import 'cycle_prediction.dart';
import 'dates.dart';
import 'fertility.dart';
import 'upcoming_periods.dart';

/// What a calendar day shows. Logged facts (bleed, spotting, something logged) and
/// estimates (predicted period, fertile window) are separate fields so the calendar
/// can never draw an estimate the way it draws a fact (rule 3).
class DayMark {
  bool bleed = false;
  bool spotting = false;
  bool logged = false;
  bool predicted = false;

  /// A predicted day drawn from a low-confidence range (dashed, "possible").
  bool possible = false;
  bool fertile = false;
  bool ovulation = false;
}

/// Marks for every day from [from] to [to] inclusive. Estimates are drawn only from
/// today forward: a prediction for a day already lived is not information.
Map<String, DayMark> dayMarks(
  Profile p, {
  required String today,
  required String from,
  required String to,
}) {
  final marks = <String, DayMark>{};
  DayMark at(String d) => marks.putIfAbsent(d, DayMark.new);

  for (final d in p.periodStarts) {
    if (d.compareTo(from) >= 0 && d.compareTo(to) <= 0) at(d).bleed = true;
  }
  for (final e in p.logs.entries) {
    if (e.key.compareTo(from) < 0 || e.key.compareTo(to) > 0) continue;
    if (e.value.flow == 'spotting') at(e.key).spotting = true;
    if (e.value.terms.isNotEmpty) at(e.key).logged = true;
  }

  if (p.goal == Goal.period || p.goal == Goal.ttc) {
    final prediction = predictNextPeriod(p.periodStarts, p.cycleLength);
    if (prediction != null) {
      void range(String a, String b, void Function(DayMark) set) {
        for (var d = a; d.compareTo(b) <= 0; d = addDays(d, 1)) {
          if (d.compareTo(today) >= 0 &&
              d.compareTo(from) >= 0 &&
              d.compareTo(to) <= 0) {
            set(at(d));
          }
        }
      }

      // The next periods (MR-51): widening ranges, only the first when irregular or learning.
      for (final u in upcomingPeriods(prediction)) {
        range(u.windowStart, u.windowEnd, (m) {
          m.predicted = true;
          if (u.confidence == Confidence.low) m.possible = true;
        });
      }
      // No window is drawn when none can be named honestly (MR-06/08).
      final fertile = fertileWindowBefore(
        prediction.predictedStart,
        cycleLength: p.cycleLength ?? prediction.averageLength,
        irregular: prediction.irregular || p.irregular,
        learning: prediction.learning && prediction.basis != 'stated',
      );
      if (fertile != null) {
        range(fertile.windowStart, fertile.windowEnd, (m) => m.fertile = true);
        range(fertile.ovulation, fertile.ovulation, (m) => m.ovulation = true);
      }
    }
  }
  return marks;
}
