// The seek-help clock: when it is reasonable to suggest talking to a clinician.
//
// Why it exists: this rule sat inside the Today screen (study report 04), where no
// fixture could reach it. It is the register's MR-13 and MR-14, twinned with
// `apps/web/src/lib/fertility/guidance.ts` through `fixtures/domain/ttc-guidance.json`:
// twelve months of trying under 35, six months from 35, and no clock at all when
// cycles are irregular. A suggestion, never a verdict, never the word "infertile".

import '../data/profile.dart';

/// Why a suggestion was made.
enum GuidanceReason { twelveMonths, sixMonthsFrom35, irregularCycles }

/// The outcome: whether to show the calm "talk to a clinician" note, and why.
class TtcGuidance {
  const TtcGuidance(this.suggestClinician, this.reason);
  final bool suggestClinician;
  final GuidanceReason? reason;

  Map<String, Object?> toJson() => {'suggestClinician': suggestClinician, 'reason': reason?.name};
}

/// From this age, six to twelve months of trying already earns the suggestion.
const earlierReferralAge = 35;

/// [age] may be unknown (null); then only "over twelve months" or irregular cycles count.
TtcGuidance ttcGuidance({required TryingFor? tryingFor, required int? age, required bool irregular}) {
  if (irregular) return const TtcGuidance(true, GuidanceReason.irregularCycles);
  if (tryingFor == TryingFor.over12) return const TtcGuidance(true, GuidanceReason.twelveMonths);
  if (tryingFor == TryingFor.sixTo12 && age != null && age >= earlierReferralAge) {
    return const TtcGuidance(true, GuidanceReason.sixMonthsFrom35);
  }
  return const TtcGuidance(false, null);
}
