// The pregnancy week-by-week calendar (MR-54): which dates each week covers.
//
// Why it exists: "what dates is week 24?" is the question behind a pregnancy calendar,
// and the reviewed week guides answer what happens in it. Each row is labelled by
// completed weeks, the way the guides are titled ("24 weeks pregnant" runs 24w0d to
// 24w6d and opens `pregnancy-week-24`).
//
// Pure arithmetic from a due date (MR-23: the last period is 280 days before it). It
// never says whether a pregnancy is on track. The result is a typed value with
// `toJson()`, so a later explainer (R10.1) reads the same facts the screen draws.
//
// Twin of `apps/web/src/lib/pregnancy/calendar.ts`, bound by
// `fixtures/domain/pregnancy-calendar.json` (generated in Python, not by either client).

import 'dates.dart';
import 'pregnancy.dart';

/// MR-54: the first and last week rows, and the weeks that have a week guide.
const firstRowWeek = 4;
const lastRowWeek = 41;
const firstGuideWeek = 4;
const lastGuideWeek = 40;

/// MR-25: the second trimester starts at 14w0d, the third at 28w0d.
const _secondTrimesterDays = 98;
const _thirdTrimesterDays = 196;

/// MR-24: the term window, 37w0d to 42w0d.
const _termStartDays = 259;
const _termEndDays = 294;
const _daysPerWeek = 7;

/// One week row: [week] completed weeks, from [start] to [end].
class PregnancyWeekRow {
  const PregnancyWeekRow({
    required this.week,
    required this.start,
    required this.end,
    required this.trimester,
    required this.guide,
  });

  final int week;
  final String start;
  final String end;
  final int trimester;

  /// The week guide's slug, or null where no guide exists (week 41).
  final String? guide;

  Map<String, Object?> toJson() => {
        'week': week,
        'start': start,
        'end': end,
        'trimester': trimester,
        'guide': guide,
      };
}

/// The whole calendar for one due date.
class PregnancyCalendar {
  const PregnancyCalendar({
    required this.lmp,
    required this.edd,
    required this.secondTrimester,
    required this.thirdTrimester,
    required this.termStart,
    required this.termEnd,
    required this.currentWeek,
    required this.weeks,
  });

  final String lmp;
  final String edd;
  final String secondTrimester;
  final String thirdTrimester;
  final String termStart;
  final String termEnd;

  /// The row today falls in, or null when today is outside rows 4-41.
  final int? currentWeek;
  final List<PregnancyWeekRow> weeks;

  Map<String, Object?> toJson() => {
        'lmp': lmp,
        'edd': edd,
        'secondTrimester': secondTrimester,
        'thirdTrimester': thirdTrimester,
        'termStart': termStart,
        'termEnd': termEnd,
        'currentWeek': currentWeek,
        'weeks': [for (final w in weeks) w.toJson()],
      };
}

/// Every week row from [eddISO] (any method, MR-23/MR-53). [todayISO] is the device's
/// local day (MR-11) and only marks the current row.
///
/// Returns null when either date is invalid.
PregnancyCalendar? pregnancyCalendar(String eddISO, String todayISO) {
  if (!isValidISODate(eddISO) || !isValidISODate(todayISO)) return null;
  final lmp = addDays(eddISO, -gestationDays);
  final weeks = <PregnancyWeekRow>[
    for (var week = firstRowWeek; week <= lastRowWeek; week++)
      PregnancyWeekRow(
        week: week,
        start: addDays(lmp, week * _daysPerWeek),
        end: addDays(lmp, week * _daysPerWeek + _daysPerWeek - 1),
        trimester: trimesterFor(week * _daysPerWeek),
        guide: week >= firstGuideWeek && week <= lastGuideWeek ? 'pregnancy-week-$week' : null,
      ),
  ];
  final since = diffDays(lmp, todayISO);
  final current = since >= 0 ? since ~/ _daysPerWeek : null;
  return PregnancyCalendar(
    lmp: lmp,
    edd: eddISO,
    secondTrimester: addDays(lmp, _secondTrimesterDays),
    thirdTrimester: addDays(lmp, _thirdTrimesterDays),
    termStart: addDays(lmp, _termStartDays),
    termEnd: addDays(lmp, _termEndDays),
    currentWeek: current != null && current >= firstRowWeek && current <= lastRowWeek ? current : null,
    weeks: weeks,
  );
}
