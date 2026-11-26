/// The after-birth stage (R8.19). Pure: no clock, no UI.
///
/// Why it exists: after birth the questions change week by week, the bleed is healing and
/// not a period, and warning signs stay serious for a year. The rules are in the register
/// (MR-50 warning signs, MR-60 the healing bleed and the restart of ranges):
/// - bleeding logged in this stage stays out of the period list (`Profile.isPostpartum`);
/// - the cycle tools read only bleeding from the birth on (`Profile.cycleStarts`), so her
///   first period after birth starts the ranges again;
/// - femio never detects the return of ovulation or of periods; she says when it came back.
library;

import 'dates.dart';

/// The reviewed after-birth guides in the order they are offered, one per week since birth
/// (week 0 is the first seven days). An editorial order, not a medical rule: each guide is
/// offered in the week its questions usually come up, and all of them stay in Learn.
const recoveryGuideByWeek = [
  'postpartum-recovery-first-six-weeks',
  'bleeding-after-birth',
  'mood-after-birth',
  'postpartum-wound-healing',
  'sleep-and-exhaustion-after-birth',
  'pelvic-floor-after-birth',
  'periods-after-birth',
];

/// The guide with the full list of after-birth warning signs and their sources (MR-50).
const postpartumWarningGuide = 'postpartum-warning-signs';

/// The guide behind the mood check-in note.
const postpartumMoodGuide = 'mood-after-birth';

/// How far back a birth can be recorded from the pregnancy Today ("I had my baby").
const recordBirthMaxDaysAgo = 365;

/// Whole weeks from [birthDate] to [today], never below zero.
int weeksSinceBirth(String birthDate, String today) {
  final days = diffDays(birthDate, today);
  return days < 0 ? 0 : days ~/ 7;
}

/// The guide offered in week [weeks] after birth, or null once the sequence is done.
String? recoveryGuideFor(int weeks) => weeks >= 0 && weeks < recoveryGuideByWeek.length ? recoveryGuideByWeek[weeks] : null;
