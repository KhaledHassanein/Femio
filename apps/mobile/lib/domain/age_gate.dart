// The 18+ gate on the onboarding birth-year answer (MR-48, decision D-01).
//
// Why it exists: a year difference alone lets a 17-year-old in whenever her birthday
// falls later in the year. The decision was not to collect a date of birth (nothing
// else in the app needs one) but to ask one yes/no question in the one ambiguous
// case. The rule lives here rather than in the screen and runs against
// fixtures/domain/age-gate.json on both clients (ADR-070).

/// What the birth-year answer settles.
enum AgeGate {
  /// Nineteen or more calendar years: she is 18 whatever her birthday.
  adult,

  /// Exactly eighteen calendar years: she is 17 or 18, so one question decides.
  askBirthday,

  /// Seventeen or fewer: the tracker is not for her yet; every guide stays open.
  under18,
}

/// Decides the gate from [birthYear] and [todayYear].
///
/// Pure, with no failure cases: an implausible year (in the future, or very old)
/// still maps to one of the three answers, and the wheel never offers one anyway.
AgeGate ageGate({required int birthYear, required int todayYear}) {
  final years = todayYear - birthYear;
  if (years >= 19) return AgeGate.adult;
  if (years == 18) return AgeGate.askBirthday;
  return AgeGate.under18;
}
