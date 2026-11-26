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

/// Marks for every day from [from] to [to] inclusive.
///
/// Her period days: every day she logged a flow, and the days after each start up to
/// the period length she told us (owner 2026-11-26: a period is not one day). Days of
/// that length still ahead of [today] are drawn as expected, not as fact.
///
/// Estimates (MR-57): predicted periods from [today] forward, since a past range for a
/// period that has not come would read as a "late" counter (rule 3). Fertile windows and
/// ovulation from the start of her current cycle forward, so the window she just lived
/// through stays visible this cycle; earlier cycles show only what she logged.
Map<String, DayMark> dayMarks(
  Profile p, {
  required String today,
  required String from,
  required String to,
}) {
  final marks = <String, DayMark>{};
  DayMark at(String d) => marks.putIfAbsent(d, DayMark.new);
  bool inView(String d) => d.compareTo(from) >= 0 && d.compareTo(to) <= 0;

  for (final d in p.periodStarts) {
    if (inView(d)) at(d).bleed = true;
  }
  for (final e in p.logs.entries) {
    if (!inView(e.key)) continue;
    if (e.value.flow == 'spotting') at(e.key).spotting = true;
    if (e.value.terms.isNotEmpty || e.value.hasNote) at(e.key).logged = true;
  }

  final starts = bleedStarts(p.periodStarts);
  final length = p.periodLength;
  if (length != null && length > 1) {
    for (final s in starts) {
      for (var i = 1; i < length; i++) {
        final d = addDays(s, i);
        // A day she logged as spotting or as no flow keeps what she said.
        final logged = p.logs[d];
        if (logged != null && logged.flow != null) continue;
        if (!inView(d)) continue;
        if (d.compareTo(today) <= 0) {
          at(d).bleed = true;
        } else {
          at(d).predicted = true;
        }
      }
    }
  }

  if (p.goal == Goal.period || p.goal == Goal.ttc) {
    final prediction = predictNextPeriod(p.periodStarts, p.cycleLength);
    if (prediction != null) {
      void range(String a, String b, String floor, void Function(DayMark) set) {
        for (var d = a; d.compareTo(b) <= 0; d = addDays(d, 1)) {
          if (d.compareTo(floor) >= 0 && inView(d)) set(at(d));
        }
      }

      // The next periods (MR-51, MR-57): widening ranges, only the first when irregular
      // or still being learned from her logs.
      for (final u in upcomingPeriods(prediction)) {
        range(u.windowStart, u.windowEnd, today, (m) {
          m.predicted = true;
          if (u.confidence == Confidence.low) m.possible = true;
        });
      }
      // No window is drawn when none can be named honestly (MR-06/08).
      final cycleStart = starts.isEmpty ? today : starts.last;
      for (final w in fertileWindowsFor(p, prediction)) {
        range(w.windowStart, w.windowEnd, cycleStart, (m) => m.fertile = true);
        range(w.ovulation, w.ovulation, cycleStart, (m) => m.ovulation = true);
      }
    }
  }
  return marks;
}
