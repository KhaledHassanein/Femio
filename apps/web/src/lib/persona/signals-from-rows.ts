/**
 * Rows → `PersonaSignals`, as tier 1 (R2.4, ADR-060).
 *
 * This existed twice: once in `signals-from-db.ts` for the browser and once, copied
 * line for line, inside `supabase/functions/experience/index.ts`. The Edge Function's
 * own comment said it "mirrors `signals-from-db.ts` exactly" — which is a promise a
 * comment cannot keep, and it was already broken. The two copies disagreed about
 * `ttcIntent`: the server read it from `persona_state.flags_json`, the browser
 * hard-coded `false`, so **C1, C6 and C8 could resolve on the server and never in
 * the fallback**. The same document, computed two ways, came out different.
 *
 * So the derivation moves here and both callers fetch rows and hand them over. What
 * is left on each side is a query, which is the part that genuinely differs.
 *
 * Pure, clock-injected and framework-free, held there by `tier1-portability-lint`,
 * because the Dart client will need this exact function.
 *
 * ## Only what she entered herself
 *
 * Every field traces to a row she wrote. There is no behavioural inference here and
 * there must not be one (product rule 4).
 */

import { diffDays } from "../calculators/dates.ts";
import { predictNextPeriod } from "../cycle/predict.ts";
import type { AgeBand } from "./age.ts";
import { AGE_BANDS } from "./age.ts";
import { EMPTY_SIGNALS, type CycleRegularity, type PersonaSignals } from "./signals.ts";

/** Days after which we describe the record as showing no recent bleed. */
const ABSENT_AFTER_DAYS = 90;

const DAYS_PER_WEEK = 7;

export type ConditionRow = {
  code: string;
  /** When she recorded it — the only thing separating D3 from D4. */
  recordedAt: string;
};

export type PregnancyRow = {
  /** `active`, or any ended outcome; the reason is never a signal (ADR-043). */
  status: string;
  createdAt: string;
  /**
   * When the row last changed. For an ended pregnancy this **is** the end date:
   * `status` is set by ending it and nothing updates the row afterwards. Stated
   * rather than assumed, because a dedicated `ended_at` column would be truer and
   * is worth adding the day anything else edits an ended pregnancy.
   */
  updatedAt: string;
};

export type SignalRows = {
  ageBand: string | null;
  /** Period start dates, any order. */
  periodStarts: readonly string[];
  conditions: readonly ConditionRow[];
  /** The most recent pregnancy, whatever its status, or null. */
  pregnancy: PregnancyRow | null;
  /** Recent symptom types, one entry per log row. */
  symptomTypes: readonly string[];
  /** Her stated intent, from `persona_state.flags_json.ttc_intent`. Never guessed. */
  ttcIntent: boolean;
  todayISO: string;
};

const isAgeBand = (value: string | null): value is AgeBand =>
  value !== null && (AGE_BANDS as readonly string[]).includes(value);

/**
 * `absent` describes the record, never the woman.
 *
 * A long gap is a gap in what she logged. Amenorrhea is a clinical finding and Femio
 * does not make them (product rule 1) — the resolver uses this to *widen* what it
 * offers, never to conclude anything.
 *
 * Read through `predictNextPeriod` rather than measured again, so two screens can
 * never disagree about whether her cycles are regular.
 */
function regularityFrom(sortedStarts: string[], today: string): CycleRegularity {
  if (sortedStarts.length === 0) return "unknown";
  const last = sortedStarts[sortedStarts.length - 1]!;
  if (diffDays(last, today) > ABSENT_AFTER_DAYS) return "absent";
  const prediction = predictNextPeriod(sortedStarts);
  if (!prediction) return "unknown";
  return prediction.irregular ? "irregular" : "regular";
}

export function signalsFromRows(rows: SignalRows): PersonaSignals {
  const today = rows.todayISO;

  const starts = [...rows.periodStarts].filter(Boolean).sort();
  const lastStart = starts.length > 0 ? starts[starts.length - 1]! : null;
  const prediction = starts.length > 0 ? predictNextPeriod(starts) : null;

  const codes = [...new Set(rows.conditions.map((c) => c.code))];

  const symptomCounts: Record<string, number> = {};
  for (const type of rows.symptomTypes) {
    symptomCounts[type] = (symptomCounts[type] ?? 0) + 1;
  }

  const pregnancy = rows.pregnancy;
  const ended = pregnancy !== null && pregnancy.status !== "active";

  /**
   * The one signal that separates D3 from D4, and `docs/09` §8 rule 3 says they must
   * never be conflated: gestational diabetes resolves postpartum into a single OGTT,
   * pre-existing diabetes is lifelong care. The distinction is *when* it was
   * recorded relative to this pregnancy.
   */
  const diabetes = rows.conditions.find((c) => c.code === "diabetes");

  /**
   * Populated at last. `E1.requires` gates on `(weeksSincePregnancyEnd ?? 99) <= 26`
   * and **nothing ever wrote this field**, on either side — so the gate could only
   * fail and E1 was unreachable from the live record. A woman weeks after giving
   * birth resolved to Z1, which is precisely the hole R2.5 set out to close.
   */
  const weeksSincePregnancyEnd =
    ended && pregnancy ? Math.floor(diffDays(pregnancy.updatedAt.slice(0, 10), today) / DAYS_PER_WEEK) : null;

  return {
    ...EMPTY_SIGNALS,
    ageBand: isAgeBand(rows.ageBand) ? rows.ageBand : null,
    cycleRegularity: regularityFrom(starts, today),
    averageCycleLength: prediction?.averageLength ?? null,
    daysSinceLastPeriod: lastStart ? diffDays(lastStart, today) : null,
    ttcIntent: rows.ttcIntent,
    pregnancyStatus: pregnancy ? (pregnancy.status === "active" ? "active" : "ended") : null,
    weeksSincePregnancyEnd,
    conditions: codes,
    symptomCounts,
    diabetesRecordedBeforePregnancy: Boolean(
      diabetes && pregnancy && Date.parse(diabetes.recordedAt) < Date.parse(pregnancy.createdAt),
    ),
    priorLoss: codes.includes("prior_loss"),
  };
}
