// Due date by method, with the term window (R11.1; MR-23, MR-24, MR-52).
//
// Why it exists: the Tools screen answers "when is my baby due?" from whatever she
// knows (her last period with her cycle length, conception, an IVF transfer or a
// dating scan) without saving anything. Onboarding uses the single-method functions in
// `pregnancy.dart`; this adds the cycle-length shift and the 37w0d-42w0d window so the
// screen draws a result and does no arithmetic.
//
// Twin of `estimateDueDateFrom` in `apps/web/src/lib/calculators/index.ts`, bound by
// `fixtures/domain/due-date.json` (generated in Python, not by either client). The
// result is a typed value with `toJson()` for a later explainer (R10.1).

import 'dates.dart';
import 'pregnancy.dart';

/// How she knows the date (MR-23, MR-52).
enum DueDateMethod { lmp, conception, transfer3, transfer5, scan }

/// MR-23: the cycle-length shift applies to a stated cycle of 21-45 days; 28 is none.
const dueMinCycle = 21;
const dueMaxCycle = 45;
const dueTypicalCycle = 28;

/// MR-52: the scan-report steppers run 4-41 weeks and 0-6 extra days; 12 weeks is
/// where the stepper starts (a common dating-scan week), never a claim about hers.
const scanMinWeeks = 4;
const scanMaxWeeks = 41;
const scanDefaultWeeks = 12;
const scanMaxExtraDays = 6;

/// MR-24: the window runs 21 days before to 14 days after the due date.
const _termBeforeDue = 21;
const _termAfterDue = 14;

/// A due date, the window most babies arrive in, and the last-period date it implies.
class DueDateEstimate {
  const DueDateEstimate({required this.edd, required this.termStart, required this.termEnd, required this.lmp});

  final String edd;
  final String termStart;
  final String termEnd;

  /// Due date - 280 days: the anchor for the week marker.
  final String lmp;

  Map<String, String> toJson() => {'edd': edd, 'termStart': termStart, 'termEnd': termEnd, 'lmp': lmp};
}

/// The due date for [method] from [dateISO].
///
/// [cycleLength] shifts a last-period date by its distance from 28 (21-45 only).
/// [scanWeeks] and [scanDays] are the gestation on a scan report (MR-52).
/// Returns null when the input is refused: an invalid date, a cycle length outside
/// 21-45, or a scan gestation outside 4w0d-41w6d.
DueDateEstimate? dueDateFrom(
  DueDateMethod method,
  String dateISO, {
  int cycleLength = dueTypicalCycle,
  int scanWeeks = -1,
  int scanDays = -1,
}) {
  if (!isValidISODate(dateISO)) return null;
  final String? edd;
  switch (method) {
    case DueDateMethod.lmp:
      if (cycleLength < dueMinCycle || cycleLength > dueMaxCycle) return null;
      final base = eddFromLmp(dateISO);
      edd = base == null ? null : addDays(base, cycleLength - dueTypicalCycle);
    case DueDateMethod.conception:
      edd = eddFromConception(dateISO);
    case DueDateMethod.transfer3:
      edd = eddFromTransfer(dateISO, embryoDays: 3);
    case DueDateMethod.transfer5:
      edd = eddFromTransfer(dateISO, embryoDays: 5);
    case DueDateMethod.scan:
      edd = eddFromScan(dateISO, scanWeeks, scanDays);
  }
  if (edd == null) return null;
  return DueDateEstimate(
    edd: edd,
    termStart: addDays(edd, -_termBeforeDue),
    termEnd: addDays(edd, _termAfterDue),
    lmp: addDays(edd, -gestationDays),
  );
}
