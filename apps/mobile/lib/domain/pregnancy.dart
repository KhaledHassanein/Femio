import 'dates.dart';

/// Pregnancy progress from the estimated due date. Twin of
/// `apps/web/src/lib/pregnancy/index.ts`, checked by the same golden fixtures
/// (`fixtures/domain/gestational-age.json`).

const gestationDays = 280;

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
    termStart: addDays(eddISO, -21),
  );
}

/// First through 13w6d, second through 27w6d, third thereafter.
int trimesterFor(int totalDays) {
  if (totalDays < 98) return 1;
  if (totalDays < 196) return 2;
  return 3;
}

String? eddFromLmp(String lmpISO) =>
    isValidISODate(lmpISO) ? addDays(lmpISO, gestationDays) : null;

/// From a conception date: 266 days, the 280 less the two weeks before ovulation.
String? eddFromConception(String iso) => isValidISODate(iso) ? addDays(iso, 266) : null;

bool isPlausibleEdd(String eddISO, String today) {
  if (!isValidISODate(eddISO) || !isValidISODate(today)) return false;
  final until = diffDays(today, eddISO);
  return until <= gestationDays && until >= -35;
}

/// From an IVF embryo transfer: 266 days less the embryo's age at transfer (3 or 5
/// days). ACOG Committee Opinion 700, "Methods for Estimating the Due Date".
String? eddFromTransfer(String iso, {required int embryoDays}) =>
    isValidISODate(iso) ? addDays(iso, 266 - embryoDays) : null;

/// MR-53: the gestation on a scan report is accepted from 4w0d to 41w6d (the
/// engine's sanity range, like MR-26).
const scanMinGestationDays = 28;
const scanMaxGestationDays = 293;

/// Estimated due date from a dating scan (MR-53): the scan date plus what is left of
/// 280 days after the gestation the report gives ([weeks] completed weeks and [days]
/// extra days, 0-6). femio never re-dates or compares methods; the report is taken as
/// written (ACOG Committee Opinion 700 leaves re-dating to the clinician).
///
/// Returns null for an invalid date, days outside 0-6, or a gestation outside
/// 4w0d-41w6d, so the screen asks her to check the report. Twin of `eddFromScan` in
/// `apps/web/src/lib/pregnancy/index.ts` (fixture `edd-from.json`).
String? eddFromScan(String scanISO, int weeks, int days) {
  if (!isValidISODate(scanISO) || weeks < 0 || days < 0 || days > 6) return null;
  final total = weeks * 7 + days;
  if (total < scanMinGestationDays || total > scanMaxGestationDays) return null;
  return addDays(scanISO, gestationDays - total);
}
