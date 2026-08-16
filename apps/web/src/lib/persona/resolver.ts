import type { PersonaSignals } from "./signals.ts";
import { signalCoverage } from "./signals.ts";

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
 * Below this, there is nothing worth *offering* either (P1.27.5).
 *
 * `docs/09` §5 says Femio offers the nearest persona "when confidence crosses a
 * threshold", which is a different threshold from the one that makes it commit —
 * and the gap between them is the whole offer. A test caught what happens without
 * this: a brand-new account with **nothing logged at all** scores B1 at 0.21,
 * because "no conditions recorded" and "not trying to conceive" are both true of
 * someone who has told us nothing. Offering her a life stage on that evidence is
 * the product guessing at a woman and calling it personalization.
 */
export const OFFER_THRESHOLD = 0.4;

/**
 * If the top two are within this, we are choosing on noise. docs/09 §5 says blend
 * the two nearest rather than committing, and Z1 *is* the blended state.
 */
export const AMBIGUITY_MARGIN = 0.08;

const has = (code: string): Predicate => (s) => s.conditions.includes(code);

/**
 * The pregnancy complications that carry a follow-up obligation past the birth
 * (E4 §A, the destination of D3/D4/D5/D6/D8).
 *
 * `thyroid` is deliberately absent: D7 routes to **E7** rather than here, because
 * postpartum thyroiditis is its own watch with its own cadence rather than one
 * more item on a follow-up schedule. `prior_preterm` is here because a preterm
 * birth or NICU stay is the fifth entry point §A names, even though its follow-up
 * is about her rather than about a number.
 */
const COMPLICATION_CODES: readonly string[] = [
  "gestational_diabetes",
  "diabetes",
  "hypertension",
  "pre_eclampsia",
  "prior_preterm",
];
const symptom =
  (type: string, atLeast = 2): Predicate =>
  (s) => (s.symptomCounts[type] ?? 0) >= atLeast;
const inBand =
  (...bands: string[]): Predicate =>
  (s) => s.ageBand !== null && bands.includes(s.ageBand);

const pregnant: Predicate = (s) => s.pregnancyStatus === "active";
const notPregnant: Predicate = (s) => s.pregnancyStatus !== "active";

/**
 * Not in the bands where the adolescent framing is unambiguous (R2.5c).
 *
 * Track B's cycle personas are written for adults, and without this a
 * thirteen-year-old with steady cycles outscored A2 on B1 — the general adult
 * tracker — which is precisely the "17+ gap" A2 §C names as the category's
 * recurring failure. Worse for **B5**: it reads irregular cycles as the defining
 * signal, while A2 §D is explicit that irregularity is *developmentally expected*
 * for the first 1–3 years after menarche and must never be treated as a finding.
 *
 * `16_17` is deliberately left free: a seventeen-year-old with three settled years
 * behind her may genuinely be B1, and §J describes exactly that transition. An
 * **unknown** band passes too — most accounts have none, and gating on absence
 * would quietly stop B1 resolving for almost everybody.
 */
const notAdolescent: Predicate = (s) => s.ageBand !== "under_13" && s.ageBand !== "13_15";

/**
 * How long she is expected to keep trying before an evaluation is usually offered
 * — **twelve months, or six from 35** (P1.27.8).
 *
 * ACOG, NICE and ASRM all shorten the window at 35. One definition, three
 * consumers: C1 is the woman *inside* it, C2 the woman past it under 35, C3 the
 * woman past it over. Writing the number three times is how they would come to
 * disagree, and the direction that disagreement would take — a 37-year-old held at
 * C1 for six extra months — is the expensive one.
 */
export function evaluationWindowMonths(ageBand: PersonaSignals["ageBand"]): number {
  return ageBand === "35_44" || ageBand === "45_54" ? 6 : 12;
}

/**
 * Still within her own window. This is what makes C1 *the general TTC persona*
 * rather than merely the first one in the list: without it C1 scored a perfect 1.0
 * for a woman of two years and won the tie on rule order alone.
 */
const withinEvaluationWindow: Predicate = (s) =>
  (s.ttcMonths ?? 0) < evaluationWindowMonths(s.ageBand);

const pastEvaluationWindow: Predicate = (s) =>
  s.ttcMonths !== null && s.ttcMonths >= evaluationWindowMonths(s.ageBand);

/**
 * The rules. **This is not all ~73 personas — and the reason is the wizard, not
 * the data model.**
 *
 * An earlier version of this comment said the taxonomy keys on labs, BBT/OPK and
 * screeners we do not collect. That was asserted without checking and it is wrong.
 * Reading all 73 specs (2026-08-07): **72 of 73 are keyed by a wizard question**,
 * **53 of 73 by a self-reported condition**, and only 5 mention labs. Counting
 * personas whose §I needs *no* collection surface beyond wizard answers:
 * **57 of 73 are resolvable today** if the wizard asks for the answers.
 *
 * What actually blocks them is two things, both application-layer:
 *   1. The wizard implements Q1 of the six branches docs/09 §4 specifies, with
 *      four of its eight options.
 *   2. **Nothing writes `conditions_flagged`.** The table exists and is read by
 *      the visit summary and the GDPR export, but no code path inserts into it —
 *      so the single highest-value signal in the taxonomy is unreachable.
 *
 * So the rules below are thin because their *input* is thin, not because the
 * scoring cannot express them. Adding a persona here is cheap once its signal
 * arrives; see P1.27.4a. The genuinely blocked ones are the 16 that need labs,
 * validated screeners or partner data (P2.1, P2.7, P3).
 */
export const PERSONA_RULES: readonly PersonaRule[] = [
  // ---- Track A — adolescent. Age band and whether she has ever logged a period
  // are the signals we hold; A3–A6 need bleeding-volume, PCOS-sign and
  // energy-availability data we do not collect.
  {
    /**
     * A1 — before the first period. The gate is `cycleRegularity === "unknown"`
     * *and* nothing logged, because A1 §I resolves on "hasn't had a first period
     * yet" and §J moves her to A2 the moment one is logged. `under_13` is included
     * deliberately: she exists, and product rule 2 says the answer to a young user
     * is a gentler experience, never a locked door.
     */
    id: "A1",
    track: "A",
    requires: [
      notPregnant,
      inBand("under_13", "13_15"),
      (s) => s.daysSinceLastPeriod === null,
    ],
    signals: [
      { weight: 3, when: inBand("under_13", "13_15") },
      { weight: 3, when: (s) => s.daysSinceLastPeriod === null },
      { weight: 1, when: (s) => !s.ttcIntent },
    ],
  },
  {
    id: "A2",
    track: "A",
    requires: [notPregnant, inBand("13_15", "16_17")],
    signals: [
      { weight: 3, when: inBand("13_15", "16_17") },
      { weight: 2, when: (s) => s.cycleRegularity === "irregular" },
      { weight: 1, when: (s) => !s.ttcIntent },
      // §J: a first period logged is the transition into A2. It is evidence for
      // A2 rather than a gate, because a teen who has not logged one yet may
      // simply not have started logging.
      { weight: 2, when: (s) => s.daysSinceLastPeriod !== null },
    ],
  },

  // ---- Track B — cycle & gynae. B2/B3/B4 and B7–B19 need severity scales,
  // bleeding volume (PBAC) and screener results.
  {
    id: "B1",
    track: "B",
    requires: [notPregnant, notAdolescent],
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
    requires: [notPregnant, notAdolescent],
    signals: [
      { weight: 3, when: (s) => s.cycleRegularity === "irregular" || s.cycleRegularity === "absent" },
      { weight: 2, when: (s) => (s.daysSinceLastPeriod ?? 0) > 45 },
      { weight: 1, when: (s) => !s.ttcIntent },
    ],
  },
  {
    id: "B6",
    track: "B",
    requires: [notPregnant, notAdolescent, has("pcos")],
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
      // The signal that keeps C1 general. Weighted above the others because
      // being past her window is the single fact that makes her someone else.
      { weight: 3, when: withinEvaluationWindow },
      { weight: 1, when: (s) => s.cycleRegularity === "regular" },
      { weight: 1, when: (s) => s.conditions.length === 0 },
    ],
  },
  {
    /**
     * C2 — primary infertility, under 35 (P1.27.8).
     *
     * C2 §I: *"How long have you been trying?" -> >=12 months => candidate for C2*,
     * with the under-35 band because ACOG/NICE/ASRM set her formal evaluation clock
     * at twelve months rather than six. The threshold is the whole persona: C1 is
     * the same woman before it, and the difference in what Femio should emphasise
     * — a work-up roadmap rather than a fertile window — is large.
     *
     * Note what this is **not**: a statement that she has infertility. The persona
     * changes emphasis and reading, never a label, and the copy never says one.
     */
    id: "C2",
    track: "C",
    requires: [notPregnant, (s) => s.ttcIntent, pastEvaluationWindow, inBand("18_24", "25_34")],
    signals: [
      { weight: 4, when: pastEvaluationWindow },
      { weight: 2, when: (s) => s.ttcIntent },
      { weight: 1, when: inBand("18_24", "25_34") },
    ],
  },
  {
    /**
     * C3 — primary infertility, 35 and over. Same persona, **six months** rather
     * than twelve, because the published guidance shortens the evaluation window at
     * 35. Getting this wrong in the lenient direction costs a woman half a year of
     * the one thing she cannot get back, which is why the age band is a gate rather
     * than a weight.
     */
    id: "C3",
    track: "C",
    requires: [notPregnant, (s) => s.ttcIntent, pastEvaluationWindow, inBand("35_44", "45_54")],
    signals: [
      { weight: 4, when: pastEvaluationWindow },
      { weight: 2, when: (s) => s.ttcIntent },
      { weight: 2, when: inBand("35_44", "45_54") },
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
      // A recorded loss routes to E6 and must never land here, whatever else is
      // true — E6 §A calls itself "the destination state of the universal loss
      // handler". `ended` without a stated outcome is not treated as a birth.
      (s) => s.pregnancyOutcome !== "loss",
      (s) => !s.priorLoss,
      (s) => (s.weeksSincePregnancyEnd ?? 99) <= 26,
    ],
    signals: [
      { weight: 4, when: (s) => s.pregnancyStatus === "ended" },
      { weight: 2, when: (s) => (s.weeksSincePregnancyEnd ?? 99) <= 26 },
      /**
       * What keeps E1 the *general* postpartum persona rather than merely the
       * first one listed. After a stated live birth E2 is the more specific
       * answer and should win; where the outcome was not stated, E1 is exactly
       * right — recovery, with nothing assumed about feeding or about what
       * happened. Without this, E1 tied E2 at 1.0 and won on rule order alone,
       * which is the same trap C1 was in before `withinEvaluationWindow`.
       */
      { weight: 3, when: (s) => s.pregnancyOutcome !== "completed" },
      /**
       * The same move again, and the **fourth** time this pattern has appeared
       * (C1/C2, E1/E2, the hero hoist, and now this): when a specific persona
       * extends a general one, the general one needs a signal that is false in the
       * specific case, or the two tie at 1.0 and the general one wins on rule
       * order alone. Without this, a woman who told the postpartum triage about her
       * thyroid or her mood scored E1 and E7/E3 identically, and E7 and E3 could
       * never fire from an unstated outcome — the condition she reported would have
       * changed nothing at all.
       */
      { weight: 1, when: (s) => s.conditions.length === 0 },
    ],
  },
  {
    /**
     * E3 — postpartum mood. Gated on the `depression_anxiety` code the postpartum
     * triage asks for, which is **her own statement**, never an EPDS total: a
     * questionnaire crossing a line is not Femio's cue to decide she has a
     * condition (product rule 1, and P2.7's whole posture on scoring).
     *
     * Listed before E4 and E7 because when several apply, `docs/09` §8 rule 2
     * gives the hero to the most acute — and postpartum mood is the one this
     * product treats as its highest-sensitivity tier.
     */
    id: "E3",
    track: "E",
    requires: [
      (s) => s.pregnancyStatus === "ended",
      (s) => s.pregnancyOutcome !== "loss",
      (s) => !s.priorLoss,
      (s) => s.conditions.includes("depression_anxiety"),
      // A year, not six months. E3 §A is explicit that mood can begin any time in
      // the first postpartum year, including after feeding stops.
      (s) => (s.weeksSincePregnancyEnd ?? 99) <= 52,
    ],
    signals: [
      { weight: 4, when: (s) => s.conditions.includes("depression_anxiety") },
      { weight: 3, when: (s) => s.pregnancyStatus === "ended" },
      { weight: 2, when: (s) => (s.weeksSincePregnancyEnd ?? 99) <= 52 },
    ],
  },
  {
    /**
     * E4 — follow-up after a complicated pregnancy. The destination of D3, D4, D5,
     * D6 and D8, and the record that carries a condition across the birth instead
     * of ending it there (product rule 5).
     *
     * Ahead of E7 deliberately: the E4 schedule is *time-critical* — the 72-hour
     * and 7–10-day blood-pressure checks, the 4–12 week glucose test — while
     * postpartum thyroiditis is a watch across a year. When both apply, the acute
     * schedule wins the hero and the thyroid layer is the runner-up.
     */
    id: "E4",
    track: "E",
    requires: [
      (s) => s.pregnancyStatus === "ended",
      (s) => s.pregnancyOutcome !== "loss",
      (s) => !s.priorLoss,
      (s) => s.conditions.some((c) => COMPLICATION_CODES.includes(c)),
      (s) => (s.weeksSincePregnancyEnd ?? 99) <= 52,
    ],
    signals: [
      { weight: 4, when: (s) => s.conditions.some((c) => COMPLICATION_CODES.includes(c)) },
      { weight: 3, when: (s) => s.pregnancyStatus === "ended" },
      { weight: 2, when: (s) => (s.weeksSincePregnancyEnd ?? 99) <= 52 },
    ],
  },
  {
    /**
     * E2 — breastfeeding and lactation. Layers on E1: her recovery is still
     * happening and E2 §E is emphatic that the subject stays **her** — "her
     * breasts, her body, her mood" — rather than becoming a baby tracker.
     *
     * Gated on a live birth she stated. Surfacing feeding content to someone who
     * recorded a loss is the single worst thing this track could do, and E6 §A
     * notes that lactation after loss is "close to unspeakable" in some of Femio's
     * markets. So the gate is `completed`, not "not a loss".
     */
    id: "E2",
    track: "E",
    requires: [
      (s) => s.pregnancyOutcome === "completed",
      (s) => !s.priorLoss,
      (s) => (s.weeksSincePregnancyEnd ?? 99) <= 52,
    ],
    signals: [
      { weight: 4, when: (s) => s.pregnancyOutcome === "completed" },
      { weight: 2, when: (s) => (s.weeksSincePregnancyEnd ?? 99) <= 26 },
      { weight: 1, when: (s) => s.conditions.length === 0 },
    ],
  },
  {
    /**
     * E7 — postpartum thyroiditis watch, the destination of D7's `ppt_watch_flag`.
     *
     * §A: the symptoms overlap almost completely with ordinary postpartum
     * exhaustion and with mood, which is why this resolves from a *reported
     * thyroid condition* and never from a symptom pattern. Femio surfacing "this
     * could be your thyroid" off a fatigue log would be exactly the inference the
     * spec forbids; what it does is put the lab log and the mood screener in the
     * same place and let a clinician decide.
     */
    id: "E7",
    track: "E",
    requires: [
      (s) => s.pregnancyStatus === "ended",
      (s) => s.pregnancyOutcome !== "loss",
      (s) => !s.priorLoss,
      (s) => s.conditions.includes("thyroid"),
      // A year: PPT is described across the first postpartum year, and the ATA
      // recheck sits at its end.
      (s) => (s.weeksSincePregnancyEnd ?? 99) <= 52,
    ],
    signals: [
      { weight: 4, when: (s) => s.conditions.includes("thyroid") },
      { weight: 3, when: (s) => s.pregnancyStatus === "ended" },
      { weight: 2, when: (s) => (s.weeksSincePregnancyEnd ?? 99) <= 52 },
    ],
  },
  {
    id: "E6",
    track: "E",
    requires: [
      (s) => s.pregnancyStatus === "ended",
      // Either a recorded loss, or a `prior_loss` she told us about. The first is
      // what the universal handler fires on; the second is how she arrives from
      // the wizard months later (E6 §A route b).
      (s) => s.pregnancyOutcome === "loss" || s.priorLoss,
    ],
    signals: [
      { weight: 4, when: (s) => s.pregnancyStatus === "ended" },
      { weight: 4, when: (s) => s.pregnancyOutcome === "loss" || s.priorLoss },
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
 * The base persona of each track — the honest answer when she has *told us* which
 * stage she is in and the evidence has not caught up.
 *
 * `state.ts` held this as a mode→persona map, reachable only from a browser. It is
 * tier 1: the Edge Function has to apply the same rule or the document it serves
 * disagrees with the state the app stored (R2.6).
 */
export const TRACK_BASE_PERSONA: Record<Track, string> = {
  A: "A2",
  B: "B1",
  C: "C1",
  D: "D1",
  E: "E1",
  F: "F1",
  Z: "Z1",
};

/**
 * Resolve, with her stated stage winning the track (R2.6, product rule 3).
 *
 * She just told us. If she says "I recently gave birth" and there is no pregnancy
 * row in Femio to prove it — she joined after the birth, which is the common case —
 * the evidence resolves her to Z1 and she would be shown the generic experience with
 * a next-period prediction. That is the exact defect R2.5 closed, reopened from the
 * server side, and it is why this rule cannot live only in `switchMode`.
 *
 * The resolver still refines *within* the track: a pregnant woman with a thyroid
 * condition gets D7, not D1.
 */
export function resolveForStatedTrack(
  signals: PersonaSignals,
  statedTrack: Track | null,
): Resolution {
  const resolved = resolvePersona(signals);
  if (!statedTrack || resolved.track === statedTrack) return resolved;

  /**
   * Prefer the evidence's own best guess *within* her track over the base persona.
   *
   * When the answer is Z1, `runnerUp` holds the persona we would have committed to
   * with more certainty — and it is often already in the track she named. A
   * thirteen-year-old who has logged nothing scores A1 (before her first period)
   * far above A2, just not confidently enough to commit; falling back to the
   * track's base would hand her A2 and a window card for cycles she has not had.
   * The base is for when the evidence says nothing about her track at all.
   */
  const nearest =
    resolved.runnerUp && trackOfPersona(resolved.runnerUp.personaId) === statedTrack
      ? resolved.runnerUp.personaId
      : TRACK_BASE_PERSONA[statedTrack];

  return {
    ...resolved,
    personaId: nearest,
    track: statedTrack,
    // No offer. Suggesting a persona from a track she has just said she is not in
    // would be the product arguing with her (P1.27.5 offers, it does not insist).
    runnerUp: null,
  };
}

/**
 * Which track a persona belongs to. Exported for the offer (P1.27.5): the UI has
 * to name the *stage* it is offering, and it must do that by lookup rather than by
 * comparing persona ids in a component, which `persona-branch-lint` forbids and
 * `docs/24` calls the whole point.
 */
export function trackOfPersona(personaId: string): Track | null {
  return PERSONA_RULES.find((rule) => rule.id === personaId)?.track ?? null;
}

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

  // Ambiguity only means Z1 when the candidates disagree about the **track**, i.e.
  // about which experience she needs. Two personas on the same track are not
  // competing — they are one experience with different modifier emphasis, and
  // docs/09 §8 rule 2 says the most-acute emphasis wins the hero rather than the
  // tie collapsing to generic. The worked example is exactly this: pregnancy +
  // thyroid + prior loss is a pregnancy hero with thyroid and PAL strips, not a
  // shrug. Before this check, that combination scored 1.0 and resolved to Z1 —
  // maximum confidence and no persona, which is incoherent on its face.
  const crossTrackTie =
    second && second.rule.track !== top.rule.track && top.value - second.value < AMBIGUITY_MARGIN;
  if (crossTrackTie) return fallback(offer, confidence);

  return {
    personaId: top.rule.id,
    track: top.rule.track,
    modifiers,
    emotionalContext,
    confidence,
    runnerUp: second ? { personaId: second.rule.id, confidence: second.value } : null,
  };
}
