import type { PersonaSignals } from "@/lib/persona/signals";
import { signalCoverage } from "@/lib/persona/signals";

/**
 * The persona resolver (P1.27.4, docs/09 §5).
 *
 * ~73 personas were specified in `docs/personas/` and the app mapped four modes to
 * four hardcoded ids. This is the scoring layer that closes that gap.
 *
 * ## What this returns, and what it deliberately cannot
 *
 * `Resolution` has no `hidden`, `blocked`, `disabled` or `available` field, and it
 * must never gain one. Invariant 1 of docs/09 is "personalize, never restrict": the
 * resolved state drives **emphasis, defaults, tone and alerts** — never access. A
 * type that cannot express restriction cannot accidentally implement it, which is
 * the same reasoning that kept a `result` column off the movement-log schema
 * (ADR-049). If a future feature needs to hide something, that is a product
 * decision requiring its own ADR, not a field added here.
 *
 * ## How scoring works
 *
 * Each persona declares hard `requires` gates and a set of weighted `signals`. A
 * persona that fails a gate scores zero — gates are what keep genuinely distinct
 * paths distinct (docs/09 §8 rule 3, D3 vs D4). Otherwise the score is matched
 * weight over total weight, so a persona is not punished for keying on signals we
 * happen to hold.
 *
 * ## Why it so often answers Z1
 *
 * Z1 is a first-class answer, not a failure (docs/09 §5). Two things force it:
 * a top score below `CONFIDENCE_THRESHOLD`, and a top score too close to the
 * runner-up to choose between them. In both cases the runner-up is returned so the
 * UI can *offer* — "Want me to tailor Femio for X? You can undo this anytime" —
 * which is P1.27.5. Nothing here ever applies a persona on its own authority.
 */

export type Track = "A" | "B" | "C" | "D" | "E" | "F" | "Z";

export type Resolution = {
  personaId: string;
  track: Track;
  /** Composable layers, not exclusive states (docs/09 §8). Sorted, deduped. */
  modifiers: string[];
  /** Tone inputs — grief and anxiety awareness (invariant 7). */
  emotionalContext: string[];
  /** 0–1. Written to `persona_state.confidence`. */
  confidence: number;
  /**
   * The persona we would have picked with more certainty, when we picked Z1
   * instead. This is what P1.27.5 offers her; it is never applied automatically.
   */
  runnerUp: { personaId: string; confidence: number } | null;
};

type Predicate = (s: PersonaSignals) => boolean;

type PersonaRule = {
  id: string;
  track: Track;
  /** All must hold or the persona is not a candidate at all. */
  requires?: Predicate[];
  /** Weighted evidence; weights are relative within a persona, not across them. */
  signals: Array<{ weight: number; when: Predicate }>;
};

/** Below this, Z1 with an offer rather than a commitment. */
export const CONFIDENCE_THRESHOLD = 0.6;

/**
 * If the top two are within this, we are choosing on noise. docs/09 §5 says blend
 * the two nearest rather than committing, and Z1 *is* the blended state.
 */
export const AMBIGUITY_MARGIN = 0.08;

const has = (code: string): Predicate => (s) => s.conditions.includes(code);
const symptom =
  (type: string, atLeast = 2): Predicate =>
  (s) => (s.symptomCounts[type] ?? 0) >= atLeast;
const inBand =
  (...bands: string[]): Predicate =>
  (s) => s.ageBand !== null && bands.includes(s.ageBand);

const pregnant: Predicate = (s) => s.pregnancyStatus === "active";
const notPregnant: Predicate = (s) => s.pregnancyStatus !== "active";

/**
 * The rules. **This is not all ~73 personas and does not pretend to be.**
 *
 * A persona is only listed once Femio records the signals it keys on. The rest of
 * the taxonomy keys on labs, BBT/OPK series, partner results and validated
 * screeners that no screen collects yet (P2.1, P2.7); adding rules for those would
 * create branches that can never fire and a resolver that looks finished. Each
 * missing group is noted where it belongs so the next session extends rather than
 * rediscovers.
 */
export const PERSONA_RULES: readonly PersonaRule[] = [
  // ---- Track A — adolescent. Age band is the only signal we hold; A3–A6 need
  // bleeding-volume, PCOS-sign and energy-availability data we do not collect.
  {
    id: "A2",
    track: "A",
    requires: [notPregnant, inBand("13_15", "16_17")],
    signals: [
      { weight: 3, when: inBand("13_15", "16_17") },
      { weight: 2, when: (s) => s.cycleRegularity === "irregular" },
      { weight: 1, when: (s) => !s.ttcIntent },
    ],
  },

  // ---- Track B — cycle & gynae. B2/B3/B4 and B7–B19 need severity scales,
  // bleeding volume (PBAC) and screener results.
  {
    id: "B1",
    track: "B",
    requires: [notPregnant],
    signals: [
      { weight: 3, when: (s) => s.cycleRegularity === "regular" },
      { weight: 2, when: (s) => !s.ttcIntent },
      { weight: 1, when: inBand("18_24", "25_34", "35_44") },
      { weight: 1, when: (s) => s.conditions.length === 0 },
    ],
  },
  {
    id: "B5",
    track: "B",
    requires: [notPregnant],
    signals: [
      { weight: 3, when: (s) => s.cycleRegularity === "irregular" || s.cycleRegularity === "absent" },
      { weight: 2, when: (s) => (s.daysSinceLastPeriod ?? 0) > 45 },
      { weight: 1, when: (s) => !s.ttcIntent },
    ],
  },
  {
    id: "B6",
    track: "B",
    requires: [notPregnant, has("pcos")],
    signals: [
      { weight: 4, when: has("pcos") },
      { weight: 2, when: (s) => s.cycleRegularity === "irregular" || s.cycleRegularity === "absent" },
      { weight: 1, when: (s) => !s.ttcIntent },
    ],
  },

  // ---- Track C — TTC. C2–C16 need TTC duration, labs and partner data.
  {
    id: "C1",
    track: "C",
    requires: [notPregnant, (s) => s.ttcIntent],
    signals: [
      { weight: 4, when: (s) => s.ttcIntent },
      { weight: 1, when: (s) => s.cycleRegularity === "regular" },
      { weight: 1, when: (s) => s.conditions.length === 0 },
    ],
  },
  {
    id: "C6",
    track: "C",
    requires: [notPregnant, (s) => s.ttcIntent, has("pcos")],
    signals: [
      { weight: 4, when: (s) => s.ttcIntent },
      { weight: 3, when: has("pcos") },
    ],
  },
  {
    id: "C8",
    track: "C",
    requires: [notPregnant, (s) => s.ttcIntent, has("thyroid")],
    signals: [
      { weight: 4, when: (s) => s.ttcIntent },
      { weight: 3, when: has("thyroid") },
    ],
  },

  // ---- Track D — pregnancy. Every rule gates on an active pregnancy, so nothing
  // here can fire for someone who is not pregnant.
  {
    id: "D1",
    track: "D",
    requires: [pregnant],
    signals: [
      { weight: 4, when: pregnant },
      { weight: 2, when: (s) => s.conditions.length === 0 },
      { weight: 1, when: (s) => !s.priorLoss },
    ],
  },
  {
    id: "D2",
    track: "D",
    requires: [pregnant, (s) => s.priorLoss],
    signals: [
      { weight: 4, when: pregnant },
      { weight: 4, when: (s) => s.priorLoss },
    ],
  },
  {
    // Gestational: diabetes recorded during this pregnancy, not before it.
    id: "D3",
    track: "D",
    requires: [pregnant, has("diabetes"), (s) => !s.diabetesRecordedBeforePregnancy],
    signals: [
      { weight: 4, when: pregnant },
      { weight: 4, when: has("diabetes") },
    ],
  },
  {
    // Pre-existing: the distinction is lifelong care versus a postpartum OGTT, and
    // docs/09 §8 rule 3 is explicit that the two must never be conflated.
    id: "D4",
    track: "D",
    requires: [pregnant, has("diabetes"), (s) => s.diabetesRecordedBeforePregnancy],
    signals: [
      { weight: 4, when: pregnant },
      { weight: 4, when: has("diabetes") },
      { weight: 2, when: (s) => s.diabetesRecordedBeforePregnancy },
    ],
  },
  {
    id: "D7",
    track: "D",
    requires: [pregnant, has("thyroid")],
    signals: [
      { weight: 4, when: pregnant },
      { weight: 4, when: has("thyroid") },
    ],
  },

  // ---- Track E — postpartum. E2/E3/E5/E7 need feeding logs and EPDS (P2.3, P2.7).
  {
    id: "E1",
    track: "E",
    requires: [
      (s) => s.pregnancyStatus === "ended",
      (s) => !s.priorLoss,
      (s) => (s.weeksSincePregnancyEnd ?? 99) <= 26,
    ],
    signals: [
      { weight: 4, when: (s) => s.pregnancyStatus === "ended" },
      { weight: 2, when: (s) => (s.weeksSincePregnancyEnd ?? 99) <= 26 },
    ],
  },
  {
    id: "E6",
    track: "E",
    requires: [(s) => s.pregnancyStatus === "ended", (s) => s.priorLoss],
    signals: [
      { weight: 4, when: (s) => s.pregnancyStatus === "ended" },
      { weight: 4, when: (s) => s.priorLoss },
    ],
  },

  // ---- Track F — perimenopause & menopause. F3–F6 need bone/CV history and
  // surgical context we do not record.
  {
    id: "F1",
    track: "F",
    requires: [notPregnant, inBand("35_44", "45_54", "55_plus")],
    signals: [
      { weight: 3, when: inBand("45_54") },
      { weight: 3, when: (s) => s.cycleRegularity === "irregular" },
      { weight: 2, when: symptom("hotFlushes") },
      { weight: 1, when: symptom("troubleSleeping") },
      { weight: 1, when: (s) => !s.ttcIntent },
    ],
  },
  {
    id: "F2",
    track: "F",
    requires: [notPregnant, (s) => (s.daysSinceLastPeriod ?? 0) >= 365],
    signals: [
      { weight: 4, when: (s) => (s.daysSinceLastPeriod ?? 0) >= 365 },
      { weight: 2, when: inBand("45_54", "55_plus") },
      { weight: 1, when: symptom("hotFlushes") },
    ],
  },
];

/**
 * Modifiers are layers, not personas (docs/09 §8). They stack, and they are
 * resolved independently of which persona won — someone in D1 with a thyroid
 * condition still gets the thyroid layer.
 */
function resolveModifiers(s: PersonaSignals): string[] {
  const out = new Set<string>();
  for (const code of s.conditions) out.add(code);
  if (s.pregnancyStatus === "active" && s.priorLoss) out.add("pregnancy_after_loss");
  if (s.cycleRegularity === "irregular" || s.cycleRegularity === "absent") out.add("irregular_cycles");
  return [...out].sort();
}

function resolveEmotionalContext(s: PersonaSignals): string[] {
  const out = new Set<string>();
  // Loss suppresses celebratory content everywhere, permanently, until she says
  // otherwise (invariant 7). It is context, never a persona on its own.
  if (s.priorLoss) out.add("prior_loss");
  if (s.ttcIntent && (s.daysSinceLastPeriod ?? 0) > 35) out.add("waiting");
  return [...out].sort();
}

function score(rule: PersonaRule, s: PersonaSignals): number {
  if (rule.requires?.some((gate) => !gate(s))) return 0;
  const total = rule.signals.reduce((sum, sig) => sum + sig.weight, 0);
  if (total === 0) return 0;
  const matched = rule.signals.reduce((sum, sig) => (sig.when(s) ? sum + sig.weight : sum), 0);
  return matched / total;
}

/**
 * Resolve a persona from what we know. Always returns something — Z1 when the
 * evidence is thin or ambiguous, which is a real answer and not a failure.
 */
export function resolvePersona(signals: PersonaSignals): Resolution {
  const modifiers = resolveModifiers(signals);
  const emotionalContext = resolveEmotionalContext(signals);

  const ranked = PERSONA_RULES.map((rule) => ({ rule, value: score(rule, signals) }))
    .filter((entry) => entry.value > 0)
    // Ties broken by rule order so the result is deterministic; the order above is
    // read top-down and a test asserts stability.
    .sort((a, b) => b.value - a.value);

  const fallback = (runnerUp: Resolution["runnerUp"], confidence: number): Resolution => ({
    personaId: "Z1",
    track: "Z",
    modifiers,
    emotionalContext,
    confidence,
    runnerUp,
  });

  const top = ranked[0];
  if (!top) return fallback(null, 0);

  // Thin evidence is its own reason for Z1: a persona resolved from one signal out
  // of six would be a guess wearing a confidence score.
  const confidence = top.value * (0.5 + 0.5 * signalCoverage(signals));
  const second = ranked[1];
  const offer = { personaId: top.rule.id, confidence };

  if (confidence < CONFIDENCE_THRESHOLD) return fallback(offer, confidence);
  if (second && top.value - second.value < AMBIGUITY_MARGIN) return fallback(offer, confidence);

  return {
    personaId: top.rule.id,
    track: top.rule.track,
    modifiers,
    emotionalContext,
    confidence,
    runnerUp: second ? { personaId: second.rule.id, confidence: second.value } : null,
  };
}
