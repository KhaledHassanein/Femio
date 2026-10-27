/**
 * `LogVocabulary` — the canonical list of what may be logged (RB-B3,
 * `docs/29_REBUILD/03` §4).
 *
 * ## What this actually is: unification, not authoring
 *
 * The plan said to "expand from ~22 terms toward Flo's 47". Counted properly,
 * **45 already existed**, plus five cervical-mucus terms and one intercourse
 * boolean — 51 in three separate places, which is the real problem:
 *
 * | Vocabulary | Where it lived | Terms |
 * |---|---|---|
 * | Symptoms and moods | `lib/cycle/symptoms.ts` `SYMPTOM_GROUPS` | 45 |
 * | Cervical mucus | `lib/fertility/index.ts` `CM_TYPES` | 5 |
 * | Intercourse | `fertility_logs.intercourse boolean` | 1 |
 *
 * Three lists, three shapes, none carrying dimension, sensitivity or clinical
 * name, and only the first reachable from the log screen. So a woman on the cycle
 * track cannot record cervical mucus at all — not because we decided she should
 * not, but because the vocabulary lives in the TTC screen's imports.
 *
 * This file is the single tier-1 list all of them become. It is portable: no
 * framework, no data layer, explicit `.ts` extensions, so the Dart twin and the
 * Edge Function read the same terms as the browser.
 *
 * ## It groups; it never restricts
 *
 * `symptoms.ts` says the vocabulary is *"grown, never partitioned"* — a separate
 * menopause list would mean a woman in cycle mode could not log a night sweat,
 * which is product rule 2 violated in the schema. That rule governs this file too.
 *
 * **`lifeStages` says which terms a track surfaces _by default_. It never says
 * which terms exist for her.** Every term is loggable by every persona, always,
 * via search and via the full list. Any code that uses `lifeStages` to build the
 * set of *available* terms rather than the *initially visible* ones is the bug
 * this paragraph exists to name — and `vocabulary.test.ts` fails if the two are
 * ever confused.
 *
 * ## `sensitivity`
 *
 * `elevated` marks what a shared device should not reveal at a glance. Partner
 * sharing and discreet notification wording both read it, so the rule is written
 * once rather than re-decided per surface. It is not a synonym for "sexual": a
 * screener result is elevated and a headache is not.
 *
 * ## OD-5 — the intercourse dimension holds exactly one term
 *
 * No act types, no orgasm or masturbation entries, no "sex and sex drive"
 * category. One marker carrying a date, which is all `lib/fertility` needs, and
 * which is what `fertility_logs.intercourse` has been since schema v1.
 *
 * The clinical terms stay, under clinical names, because they are symptoms a
 * clinician asks about: `painDuringSex`, `vaginalDryness`, `libidoUp`,
 * `libidoDown`. They were already in the vocabulary and were already right.
 *
 * Conservative wording in all four languages is a **review item, not a copy
 * detail**: a term that reads clinical in English and crude in Arabic fails.
 */

/**
 * Life-stage track letters (A teen, B cycle, C trying to conceive, D pregnancy,
 * E after birth, F menopause, Z unknown). Defined here because the vocabulary is
 * shared with the Flutter app through `scripts/mobile/sync-log-vocabulary.mjs`
 * and must not depend on the retired web persona resolver.
 */
export type Track = "A" | "B" | "C" | "D" | "E" | "F" | "Z";

export const LOG_VOCABULARY_VERSION = 1;

export type LogDimension = "symptom" | "mood" | "discharge" | "intercourse" | "vital";

export type LogTerm = {
  /** Stable. Never renamed — it is stored in `symptom_logs.type`. */
  key: string;
  dimension: LogDimension;
  /** i18n key. Never a rendered string (chapter 03, rule 1). */
  labelKey: string;
  /** For the visit pack and the clinician summary, where the lay word is not enough. */
  clinicalName?: string;
  /** Does the 0–4 scale in `symptom_logs.severity` apply? */
  severityScale: boolean;
  /** Tracks that surface it **by default**. Never a restriction — see the header. */
  lifeStages: readonly Track[];
  sensitivity: "normal" | "elevated";
};

const ALL: readonly Track[] = ["A", "B", "C", "D", "E", "F", "Z"];
/** Everything except adolescent, for terms that assume an adult context. */
const ADULT: readonly Track[] = ["B", "C", "D", "E", "F", "Z"];

/** Shorthand so the table below reads as data rather than as object literals. */
function term(
  key: string,
  dimension: LogDimension,
  labelKey: string,
  opts: Partial<Omit<LogTerm, "key" | "dimension" | "labelKey">> = {},
): LogTerm {
  return {
    key,
    dimension,
    labelKey,
    severityScale: opts.severityScale ?? dimension === "symptom",
    lifeStages: opts.lifeStages ?? ALL,
    sensitivity: opts.sensitivity ?? "normal",
    ...(opts.clinicalName === undefined ? {} : { clinicalName: opts.clinicalName }),
  };
}

const mood = (k: string) => term(k, "mood", `symptoms.items.${k}`, { severityScale: true });
const sym = (k: string, o: Partial<LogTerm> = {}) => term(k, "symptom", `symptoms.items.${k}`, o);

/**
 * The nine mood keys, carried over unchanged from `SYMPTOM_GROUPS[group="mood"]`.
 * Migration `0016` backfills exactly these to `dimension = 'mood'`.
 */
const MOODS: readonly LogTerm[] = [
  "happy",
  "calm",
  "anxious",
  "irritable",
  "sad",
  "moodSwings",
  "lowMotivation",
  "tearfulness",
  "panicFeelings",
].map(mood);

/**
 * The 36 physical terms, carried over from `SYMPTOM_GROUPS` groups `body` and
 * `other`. Not one is dropped: the old grouping was presentational and this is
 * clinical, so terms move between headings but none leaves the product.
 */
const SYMPTOMS: readonly LogTerm[] = [
  sym("cramps", { clinicalName: "dysmenorrhoea" }),
  sym("headache"),
  sym("bloating"),
  sym("breastTenderness", { clinicalName: "mastalgia" }),
  sym("backache"),
  sym("jointPain", { clinicalName: "arthralgia" }),
  sym("musclePain", { clinicalName: "myalgia" }),
  sym("nausea"),
  sym("constipation"),
  sym("diarrhea"),
  sym("fatigue"),
  sym("acne"),
  sym("hotFlashes", { clinicalName: "vasomotor symptoms", lifeStages: ADULT }),
  sym("nightSweats", { clinicalName: "nocturnal vasomotor symptoms", lifeStages: ADULT }),
  sym("spotting", { clinicalName: "intermenstrual bleeding" }),
  sym("heartFlutters", { clinicalName: "palpitations" }),
  sym("weightChange"),
  sym("cravings"),
  sym("insomnia"),
  sym("dizziness"),
  sym("brainFog", { clinicalName: "subjective cognitive difficulty" }),
  // Clinical sexual-health terms. In scope under OD-5 because a clinician asks
  // about them; they are symptoms, not lifestyle content.
  sym("libidoUp", { clinicalName: "increased libido", lifeStages: ADULT, sensitivity: "elevated" }),
  sym("libidoDown", { clinicalName: "reduced libido", lifeStages: ADULT, sensitivity: "elevated" }),
  sym("vaginalDryness", { clinicalName: "vaginal atrophy", lifeStages: ADULT, sensitivity: "elevated" }),
  sym("painDuringSex", { clinicalName: "dyspareunia", lifeStages: ADULT, sensitivity: "elevated" }),
  sym("bladderUrgency"),
  sym("bladderLeaks", { clinicalName: "urinary incontinence" }),
  sym("hairThinning", { clinicalName: "alopecia" }),
  sym("dryItchySkin", { clinicalName: "pruritus" }),
  sym("brittleNails"),
  sym("gumSoreness", { clinicalName: "gingival tenderness" }),
  sym("burningMouth", { clinicalName: "burning mouth syndrome", lifeStages: ADULT }),
  sym("tingling", { clinicalName: "paraesthesia" }),
  sym("electricShocks"),
  sym("bodyOdourChange"),
  sym("tinnitus"),
];

/**
 * Cervical mucus, from `lib/fertility` `CM_TYPES` — the vocabulary the trackers
 * and the literature share. It already existed and was already right; what it
 * lacked was a route to the log screen for anyone not on the TTC track.
 *
 * No severity scale: these are categories, not intensities.
 */
const DISCHARGE: readonly LogTerm[] = ["dry", "sticky", "creamy", "watery", "eggWhite"].map((k) =>
  term(k, "discharge", `fertility.cm.${k}`, {
    severityScale: false,
    lifeStages: ADULT,
    clinicalName: "cervical mucus",
  }),
);

/**
 * **Exactly one term (OD-5).** A date, and nothing else. `fertility_logs.intercourse`
 * has held precisely this since schema v1.
 */
const INTERCOURSE: readonly LogTerm[] = [
  term("intercourse", "intercourse", "fertility.intercourse", {
    severityScale: false,
    lifeStages: ADULT,
    sensitivity: "elevated",
  }),
];

/**
 * Measurements. A pointer dimension: the values live in `vitals`, and BBT lives in
 * `fertility_logs.bbt` and is deliberately absent here — duplicating it would
 * create two sources of truth for one measurement (migration `0017`).
 */
const VITALS: readonly LogTerm[] = [
  ["weight", "vitals.weight"],
  ["glucose", "vitals.glucose"],
  ["bp_sys", "vitals.bpSystolic"],
  ["bp_dia", "vitals.bpDiastolic"],
  ["temp_body", "vitals.bodyTemperature"],
  ["resting_hr", "vitals.restingHeartRate"],
  ["hrv", "vitals.heartRateVariability"],
  ["sleep_minutes", "vitals.sleep"],
  ["steps", "vitals.steps"],
].map(([k, labelKey]) =>
  term(k as string, "vital", labelKey as string, { severityScale: false }),
);

export const LOG_TERMS: readonly LogTerm[] = [
  ...MOODS,
  ...SYMPTOMS,
  ...DISCHARGE,
  ...INTERCOURSE,
  ...VITALS,
];

export type LogVocabulary = {
  version: number;
  terms: readonly LogTerm[];
};

export const LOG_VOCABULARY: LogVocabulary = {
  version: LOG_VOCABULARY_VERSION,
  terms: LOG_TERMS,
};

/* ------------------------------------------------------------------ *
 * Derivations
 *
 * A flat list with `dimension` on each term, rather than chapter 03's
 * `dimensions: { symptom: [...], mood: [...] }`. One list means a key cannot
 * appear in two dimensions and cannot be added twice, which a nested shape
 * permits silently. The grouped view is derived below where it is wanted.
 * ------------------------------------------------------------------ */

export function termsInDimension(dimension: LogDimension): readonly LogTerm[] {
  return LOG_TERMS.filter((t) => t.dimension === dimension);
}

export function findTerm(key: string): LogTerm | undefined {
  return LOG_TERMS.find((t) => t.key === key);
}

/**
 * The terms a track surfaces **first**. Not the terms it allows.
 *
 * Callers must treat this as ordering, exactly as `SurfaceMap.tools.featured` is
 * ordering — the rest of the vocabulary follows it, reachable by scrolling and by
 * search. A caller that renders only this is restricting by life stage, which
 * product rule 2 forbids.
 */
export function defaultTermsForTrack(track: Track): readonly LogTerm[] {
  return LOG_TERMS.filter((t) => t.lifeStages.includes(track));
}
