// MR-10: a calm prompt when her period has not come for a long time.
//
// Why it exists: after 90 days with no bleed logged, the first thing to rule out is a
// pregnancy, and then a clinician should hear about it (ASRM 2024: 3 months after regular
// cycles, 6 after irregular; docs/compliance/MENSTRUAL_SAFETY_THRESHOLDS.md). Femio never
// counts the days or names a cause; it says what to do. Twin of
// apps/web/src/lib/cycle/absent.ts, bound by fixtures/domain/absent-period.json.

import '../data/profile.dart';
import 'dates.dart';

/// Days since her last logged bleed after which the prompt shows (MR-10).
const absentPeriodDays = 90;

/// After a birth her period is often away for months (feeding); no prompt in that year.
const absentAfterBirthDays = 365;

/// Whether the MR-10 prompt shows for [goal] with these bleed days ([starts], any order),
/// an optional [birthDate], on [today]. Only in the cycle goals, only with a bleed on
/// record, never in the year after a birth.
bool periodAbsent({
  required Goal goal,
  required List<String> starts,
  required String? birthDate,
  required String today,
}) {
  if (goal != Goal.period && goal != Goal.ttc) return false;
  if (starts.isEmpty) return false;
  if (birthDate != null && isValidISODate(birthDate) && diffDays(birthDate, today) < absentAfterBirthDays) {
    return false;
  }
  final last = starts.reduce((a, b) => a.compareTo(b) >= 0 ? a : b);
  return diffDays(last, today) >= absentPeriodDays;
}

/// [periodAbsent] for her profile.
bool periodAbsentFor(Profile profile, String today) => periodAbsent(
      goal: profile.goal,
      starts: profile.periodStarts,
      birthDate: profile.birthDate,
      today: today,
    );
