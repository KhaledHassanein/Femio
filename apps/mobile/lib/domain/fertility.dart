import 'dates.dart';

/// Fertile window from a predicted next period. Twin of `fertileWindow` in
/// `apps/web/src/lib/calculators/index.ts`: ovulation about 14 days before the
/// next period, the window the five days before it and the day after.
///
/// Awareness only (product rule 1): never presented as a way to avoid pregnancy.
class FertileWindow {
  const FertileWindow(this.ovulation, this.windowStart, this.windowEnd);
  final String ovulation;
  final String windowStart;
  final String windowEnd;
}

const lutealPhaseDays = 14;

FertileWindow fertileWindowBefore(String nextPeriodISO) {
  final ovulation = addDays(nextPeriodISO, -lutealPhaseDays);
  return FertileWindow(ovulation, addDays(ovulation, -5), addDays(ovulation, 1));
}
