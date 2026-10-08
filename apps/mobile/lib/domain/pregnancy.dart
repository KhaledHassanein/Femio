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
