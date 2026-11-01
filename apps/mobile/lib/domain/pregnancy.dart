import 'dates.dart';

/// Pregnancy progress from the estimated due date. Twin of
/// `apps/web/src/lib/pregnancy/index.ts`, checked by the same golden fixtures
/// (`fixtures/domain/gestational-age.json`).

const gestationDays = 280;

/// Term runs from 37w0d to 42w0d. Counted from the 40w0d due date: 21 days before it,
/// and 14 days after it (MR-24; `apps/web` `TERM_END_DAYS` is the same 294 days from LMP).
const termStartDaysBeforeDue = 21;
const termEndDaysAfterDue = 14;

/// Total days of pregnancy at 42w0d. A pregnancy past this is "over term": Today stops
/// counting and points her to her midwife or doctor instead (MR-02, design spec §2.7).
const overTermTotalDays = gestationDays + termEndDaysAfterDue;

class PregnancyProgress {
  const PregnancyProgress({
    required this.weeks,
    required this.days,
    required this.totalDays,
    required this.trimester,
    required this.daysUntilDue,
    required this.overdue,
    required this.termStart,
  });

  final int weeks;
  final int days;
  final int totalDays;
  final int trimester;
  final int daysUntilDue;
  final bool overdue;
  final String termStart;

  Map<String, Object> toJson() => {
    'weeks': weeks,
    'days': days,
    'totalDays': totalDays,
    'trimester': trimester,
    'daysUntilDue': daysUntilDue,
    'overdue': overdue,
    'termStart': termStart,
  };
}

PregnancyProgress? pregnancyProgress(String eddISO, String today) {
  if (!isValidISODate(eddISO) || !isValidISODate(today)) return null;
  final daysUntilDue = diffDays(today, eddISO);
  final totalDays = gestationDays - daysUntilDue;
  if (totalDays < 0 || totalDays > 315) return null;
  return PregnancyProgress(
    weeks: totalDays ~/ 7,
    days: totalDays % 7,
    totalDays: totalDays,
    trimester: trimesterFor(totalDays),
    daysUntilDue: daysUntilDue,
    overdue: daysUntilDue < 0,
    termStart: addDays(eddISO, -termStartDaysBeforeDue),
  );
}

/// The term window around a due date: 37w0d to 42w0d, both days included.
class TermWindow {
  const TermWindow({required this.start, required this.end});
  final String start;
  final String end;
}

/// The window in which most babies arrive, as ISO days, or null for an invalid date.
/// This replaces any "days to go" or "days overdue" count: it is a range, never a
/// single day (rule 3, MR-02). Unit-tested in `test/pregnancy_term_window_test.dart`.
TermWindow? termWindow(String eddISO) {
  if (!isValidISODate(eddISO)) return null;
  return TermWindow(start: addDays(eddISO, -termStartDaysBeforeDue), end: addDays(eddISO, termEndDaysAfterDue));
}

/// True once she is past 42w0d by this due date.
bool isOverTerm(PregnancyProgress progress) => progress.totalDays > overTermTotalDays;

/// First through 13w6d, second through 27w6d, third thereafter.
int trimesterFor(int totalDays) {
  if (totalDays < 98) return 1;
  if (totalDays < 196) return 2;
  return 3;
}

String? eddFromLmp(String lmpISO) => isValidISODate(lmpISO) ? addDays(lmpISO, gestationDays) : null;

/// From a conception date: 266 days, the 280 less the two weeks before ovulation.
String? eddFromConception(String iso) => isValidISODate(iso) ? addDays(iso, 266) : null;

/// A due date can lie up to 280 days ahead, and up to 35 days behind (a late pregnancy).
const maxDaysUntilDue = gestationDays;
const maxDaysPastDue = 35;

bool isPlausibleEdd(String eddISO, String today) {
  if (!isValidISODate(eddISO) || !isValidISODate(today)) return false;
  final until = diffDays(today, eddISO);
  return until <= maxDaysUntilDue && until >= -maxDaysPastDue;
}

/// From an IVF embryo transfer: 266 days less the embryo's age at transfer (3 or 5
/// days). ACOG Committee Opinion 700, "Methods for Estimating the Due Date".
String? eddFromTransfer(String iso, {required int embryoDays}) =>
    isValidISODate(iso) ? addDays(iso, 266 - embryoDays) : null;
