/**
 * The 18+ gate on a birth-year answer (MR-48, decision D-01).
 *
 * The website asks nobody's age; this is the twin of
 * apps/mobile/lib/domain/age_gate.dart, kept so the shared fixture
 * fixtures/domain/age-gate.json runs on both sides (ADR-070). Nineteen or more
 * calendar years is an adult whatever her birthday; exactly eighteen is ambiguous and
 * the app asks one yes/no question; fewer is under 18.
 */
export type AgeGate = "adult" | "askBirthday" | "under18";

/** Decides the gate from the birth year and today's year. Pure; no failure cases. */
export function ageGate(birthYear: number, todayYear: number): AgeGate {
  const years = todayYear - birthYear;
  if (years >= 19) return "adult";
  if (years === 18) return "askBirthday";
  return "under18";
}
