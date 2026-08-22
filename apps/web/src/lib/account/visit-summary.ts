import { diffDays, isValidISODate } from "@/lib/calculators/dates";
import { bleedStarts, predictNextPeriod } from "@/lib/cycle/predict";

// Pure builder for the doctor-visit summary (P1.16.1). Takes already-fetched,
// owner-scoped rows and produces a compact, human-readable clinical snapshot —
// NOT the raw GDPR JSON. No DB, no rendering, so it is unit-testable and the page
// stays a thin server component. Femio never diagnoses: conditions are shown as
// self-reported and the summary carries a "not a medical record" disclaimer.

export type CycleRow = { period_start: string; flow?: string | null };
export type SymptomRow = { type: string; severity?: number | null; logged_at: string };
export type MedRow = { name: string; active?: boolean | null };
export type ConditionRow = { condition_code: string; source: string };
export type KeyDateRow = { label?: string | null; date: string; display_pref?: string | null };

/**
 * What Femio worked out, kept apart from what she wrote down (R3.1c).
 *
 * A clinician reading this has to know instantly which numbers are observations
 * and which are estimates. A report that blurs the two is worse than no report,
 * because it launders a prediction into a medical record — and the numbers are
 * indistinguishable on the page otherwise: "28 days" looks the same whether she
 * measured it or Femio guessed it from one interval.
 *
 * `basis` carries that distinction all the way from `predictNextPeriod` rather
 * than being reconstructed here, so the report cannot disagree with the dashboard
 * about where a number came from.
 */
export type DerivedCycle = {
  /** Mean of her observed intervals, or the length she stated. Never both. */
  averageLength: number | null;
  /** `stated` = she told us during setup. `observed` = measured from her logs. */
  basis: "stated" | "observed" | null;
  rangeLow: number | null;
  rangeHigh: number | null;
  /** Femio's estimate of the next period, as a range. Never a single date. */
  predictedWindow: { start: string; end: string } | null;
  /** Femio has not seen enough cycles to characterise her pattern. */
  learning: boolean;
  /** Her observed intervals vary widely. Only ever set from real measurement. */
  irregular: boolean;
};

export type VisitSummary = {
  generatedAt: string;
  track: string | null;
  /** Everything in here she entered herself. Nothing is computed. */
  cycle: {
    logged: number;
    lastPeriod: string | null;
    recent: { start: string; flow: string | null }[];
  };
  /** Everything in here Femio worked out. Nothing here is her observation. */
  derived: DerivedCycle;
  symptoms: { type: string; severity: number | null; date: string }[];
  meds: { name: string; active: boolean }[];
  conditions: { code: string; source: string }[];
  keyDates: { label: string | null; date: string }[];
};

function cycleLengths(startsDesc: string[]): number[] {
  // `bleedStarts`, not a second de-dupe of its own (R3.1.9, R3.1c.1).
  //
  // This function used to sort the raw rows itself, which meant three days logged
  // during one period became three cycles one day apart — the same bug the
  // dashboard had, reproduced here. Worse than a repeat: the report is the
  // document she hands a clinician, so the two surfaces could disagree about how
  // long her cycles are, and the printed one would win the argument in the room.
  //
  // One answer to "when did her periods begin", shared with the prediction.
  const sorted = bleedStarts(startsDesc);
  const lengths: number[] = [];
  for (let i = 1; i < sorted.length; i++) {
    const len = diffDays(sorted[i - 1]!, sorted[i]!);
    if (len > 0 && len <= 90) lengths.push(len); // ignore gaps/outliers
  }
  return lengths;
}

export function buildVisitSummary(
  input: {
    cycles?: CycleRow[];
    symptoms?: SymptomRow[];
    meds?: MedRow[];
    conditions?: ConditionRow[];
    keyDates?: KeyDateRow[];
    track?: string | null;
    /** Her stated usual cycle length (R3.1b). Never treated as an observation. */
    statedCycleLength?: number | null;
  },
  generatedAt: string,
): VisitSummary {
  const cycles = input.cycles ?? [];
  const startsDesc = cycles.map((c) => c.period_start).filter(isValidISODate);
  const lengths = cycleLengths(startsDesc);
  // The same prediction the dashboard shows, from the same function. Reproducing
  // the arithmetic here is how the printed page and the screen come to disagree,
  // and the printed page is the one that ends up in a consulting room.
  const prediction = predictNextPeriod(startsDesc, input.statedCycleLength ?? null);

  return {
    generatedAt,
    track: input.track ?? null,
    cycle: {
      logged: startsDesc.length,
      lastPeriod: startsDesc.length > 0 ? [...startsDesc].sort().at(-1)! : null,
      recent: cycles.slice(0, 6).map((c) => ({ start: c.period_start, flow: c.flow ?? null })),
    },
    derived: {
      /**
       * The report keeps its own average, and that is a **known disagreement with
       * the dashboard**, recorded rather than papered over (R3.1c.5).
       *
       * `cycleLengths` here discards intervals over 90 days — a 151-day gap is not
       * a 151-day cycle — and `predictNextPeriod` never has. Unifying them looked
       * like a one-line win until the golden fixtures and Track F's reachability
       * tests caught what it costs: a menopausal woman who bleeds after eighteen
       * months has that gap dropped, and is then reported as **regular**, which is
       * the opposite of the signal `bledAfterALongGap` and F2's red flag exist to
       * raise. Fixing the dashboard to match cannot be a tail-end edit.
       *
       * So the safer behaviour stays here, the disagreement is logged as R3.1.10,
       * and `basis`/`predictedWindow` still come from the shared predictor so the
       * two never disagree about *where a number came from* — only, for now, about
       * one outlier rule.
       */
      averageLength:
        prediction?.basis === "stated"
          ? prediction.averageLength
          : lengths.length > 0
            ? Math.round(lengths.reduce((a, b) => a + b, 0) / lengths.length)
            : null,
      basis: prediction?.basis ?? null,
      // The observed spread, and only ever observed: a stated length has no range,
      // and inventing one around it would dress a single remembered number as a
      // measurement.
      rangeLow: lengths.length > 0 ? Math.min(...lengths) : null,
      rangeHigh: lengths.length > 0 ? Math.max(...lengths) : null,
      predictedWindow: prediction
        ? { start: prediction.windowStart, end: prediction.windowEnd }
        : null,
      learning: prediction?.learning ?? false,
      irregular: prediction?.irregular ?? false,
    },
    symptoms: (input.symptoms ?? []).slice(0, 15).map((s) => ({
      type: s.type,
      severity: s.severity ?? null,
      date: s.logged_at.slice(0, 10),
    })),
    meds: (input.meds ?? []).map((m) => ({ name: m.name, active: m.active !== false })),
    conditions: (input.conditions ?? []).map((c) => ({ code: c.condition_code, source: c.source })),
    keyDates: (input.keyDates ?? [])
      .filter((k) => k.display_pref !== "hidden")
      .map((k) => ({ label: k.label ?? null, date: k.date })),
  };
}
