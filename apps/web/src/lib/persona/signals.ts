/**
 * The observable signals a persona can be resolved from (P1.27.4, docs/09 §5).
 *
 * Deliberately narrow: this type lists **only what Femio actually records**. The
 * taxonomy in docs/08 keys some personas on labs, BBT/OPK series, partner semen
 * analysis and validated screeners — none of which the app collects yet. Inventing
 * a signal here that nothing populates would produce a resolver that looks complete
 * and silently never fires those branches, which is worse than a short list.
 *
 * Everything here is derived from data the user entered herself. Nothing is
 * inferred from behaviour she did not consent to being read (product rule 4).
 */
import type { AgeBand } from "./age.ts";

export type CycleRegularity = "regular" | "irregular" | "absent" | "unknown";

export type PersonaSignals = {
  /** From `profiles.age_band`. Null when she has not told us, which is common. */
  ageBand: AgeBand | null;
  /**
   * From logged period starts. `absent` means a long gap rather than a diagnosis —
   * amenorrhea is a clinical finding and Femio does not make them (product rule 1).
   */
  cycleRegularity: CycleRegularity;
  /** Null until there are at least two period starts to measure between. */
  averageCycleLength: number | null;
  daysSinceLastPeriod: number | null;
  /** From `persona_state.flags_json.ttc_intent` — her stated intent, never guessed. */
  ttcIntent: boolean;
  /**
   * How long she has been trying, in months, as **she** reported it (P1.27.8).
   *
   * The only thing separating C1 from C2 and C3, and it is not derivable from
   * anything Femio records: she was trying long before she installed an app.
   * Null means she was not asked or preferred not to say, never zero — a woman
   * who has been trying for two years and skipped the question must not be
   * treated as having started today.
   */
  ttcMonths: number | null;
  /** From the `pregnancy` table. `ended` covers every outcome; the reason is not a signal. */
  pregnancyStatus: "active" | "ended" | null;
  /** Weeks since an ended pregnancy, for postpartum vs. long-past. */
  weeksSincePregnancyEnd: number | null;
  /** `conditions_flagged.condition_code`, all self-reported and non-diagnostic. */
  conditions: readonly string[];
  /** Symptom type → times logged, over the recent window the caller chose. */
  symptomCounts: Readonly<Record<string, number>>;
  /**
   * Whether a diabetes condition was recorded **before** the current pregnancy
   * started. This exists as its own field because docs/09 §8 rule 3 says D3
   * (gestational, resolves postpartum) and D4 (pre-existing, lifelong) must never
   * be conflated, and the only thing that separates them is when it was recorded.
   */
  diabetesRecordedBeforePregnancy: boolean;
  /** Any recorded pregnancy loss. Drives emotional context, never a persona alone. */
  priorLoss: boolean;
};

/** A signal set that asserts nothing — the honest starting point for a new account. */
export const EMPTY_SIGNALS: PersonaSignals = {
  ageBand: null,
  cycleRegularity: "unknown",
  averageCycleLength: null,
  daysSinceLastPeriod: null,
  ttcIntent: false,
  ttcMonths: null,
  pregnancyStatus: null,
  weeksSincePregnancyEnd: null,
  conditions: [],
  symptomCounts: {},
  diabetesRecordedBeforePregnancy: false,
  priorLoss: false,
};

/** How many of the signals we could know are actually populated, 0–1. */
/**
 * Deliberately only the **broadly applicable** signals. `ttcMonths` is not here:
 * it is stage-specific, and counting it would lower confidence for every woman
 * who is pregnant, postpartum or thirteen — none of whom will ever be asked it.
 * Coverage measures how much we know about someone, not how many questions exist.
 */
export function signalCoverage(s: PersonaSignals): number {
  const known = [
    s.ageBand !== null,
    s.cycleRegularity !== "unknown",
    s.averageCycleLength !== null,
    s.pregnancyStatus !== null,
    s.conditions.length > 0,
    Object.keys(s.symptomCounts).length > 0,
  ];
  return known.filter(Boolean).length / known.length;
}
