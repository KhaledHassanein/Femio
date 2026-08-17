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

/**
 * The gap after which a further bleed is the postmenopausal kind (R2.9).
 *
 * Twelve months is the convention F2 §A names, and it is the same number the
 * menopause panel already counts to. One definition, because two places
 * disagreeing about it would mean one screen telling her a bleed is worth checking
 * and another saying nothing.
 */
const POSTMENOPAUSAL_GAP_DAYS = 365;

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
  /**
   * Stage-scoped answers she gave at onboarding (P1.27.8), from
   * `persona_state.flags_json`. Both describe things that happened **before** she
   * installed Femio, so no amount of logging will ever produce them.
   */
  ttcMonths?: number | null;
  /** Weeks since she gave birth, as she reported it. See below for precedence. */
  statedWeeksSinceBirth?: number | null;
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

/**
 * Did she record a bleed after twelve months without one?
 *
 * Read off consecutive starts rather than from a "final period" field, because
 * Femio has never had one and inventing it would mean deciding when her periods
 * stopped — which is the conclusion the whole track refuses to reach (ADR-042).
 * A gap of a year between two logged starts is arithmetic; what it means is not.
 */
function bledAfterALongGap(sortedStarts: readonly string[]): boolean {
  for (let i = 1; i < sortedStarts.length; i += 1) {
    if (diffDays(sortedStarts[i - 1]!, sortedStarts[i]!) >= POSTMENOPAUSAL_GAP_DAYS) return true;
  }
  return false;
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
  const weeksFromRow =
    ended && pregnancy ? Math.floor(diffDays(pregnancy.updatedAt.slice(0, 10), today) / DAYS_PER_WEEK) : null;

  /**
   * The row wins when there is one, and her answer fills the common gap.
   *
   * A pregnancy Femio watched end has a real date. A woman who installed Femio two
   * weeks after giving birth has no row at all — the case `phaseForTrack` already
   * had to special-case — and until P1.27.8 nothing could tell us how long ago it
   * was. Her answer is not a fallback for a *missing* value so much as the only
   * source for the majority of Track E.
   *
   * Preferring the row is deliberate: it is a date rather than a band, and where
   * both exist the recorded one is the more precise.
   */
  // `?? null` throughout: these two are optional inputs, and a caller that omits
  // them — a golden fixture written before they existed, or a Dart client — must
  // get `null` rather than `undefined`, which would not match a recorded answer.
  const weeksSincePregnancyEnd = weeksFromRow ?? rows.statedWeeksSinceBirth ?? null;

  return {
    ...EMPTY_SIGNALS,
    ageBand: isAgeBand(rows.ageBand) ? rows.ageBand : null,
    cycleRegularity: regularityFrom(starts, today),
    averageCycleLength: prediction?.averageLength ?? null,
    daysSinceLastPeriod: lastStart ? diffDays(lastStart, today) : null,
    ttcIntent: rows.ttcIntent,
    ttcMonths: rows.ttcMonths ?? null,
    /**
     * The outcome as recorded, normalised to the three values the schema allows.
     * A stated birth she did not qualify stays `ended`, never `completed`.
     */
    pregnancyOutcome: !pregnancy
      ? null
      : pregnancy.status === "active"
        ? null
        : pregnancy.status === "completed" || pregnancy.status === "loss"
          ? pregnancy.status
          : "ended",
    pregnancyStatus: pregnancy
      ? pregnancy.status === "active"
        ? "active"
        : "ended"
      : // She told us she recently gave birth and Femio never saw the pregnancy.
        // Without this, E1's `pregnancyStatus === "ended"` gate fails for the
        // majority of Track E, exactly as its weeks gate did before R2.4.
        (rows.statedWeeksSinceBirth ?? null) !== null
        ? "ended"
        : null,
    weeksSincePregnancyEnd,
    conditions: codes,
    symptomCounts,
    diabetesRecordedBeforePregnancy: Boolean(
      diabetes && pregnancy && Date.parse(diabetes.recordedAt) < Date.parse(pregnancy.createdAt),
    ),
    priorLoss: codes.includes("prior_loss"),
    postmenopausalBleed: bledAfterALongGap(starts),
  };
}
