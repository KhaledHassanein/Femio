import type { createClient } from "@/lib/supabase/client";
import { predictNextPeriod } from "@/lib/cycle/predict";
import { todayISO } from "@/lib/calculators/dates";
import { EMPTY_SIGNALS, type CycleRegularity, type PersonaSignals } from "./signals";
import type { AgeBand } from "./state";

/**
 * Derive `PersonaSignals` from what she has actually recorded (P1.27.4a).
 *
 * The resolver has existed since ADR-057 and only ever saw wizard answers, which
 * meant it could resolve her once and never again — `docs/23` §3.1. This is the
 * other half: the same signal set, read from the live record, so re-answering a
 * question or logging a period produces a real re-resolution rather than a
 * re-run of the same four answers.
 *
 * Two rules it keeps:
 *
 * - **Only what she entered herself.** Every field traces to a row she wrote. There
 *   is no behavioural inference here and there must not be one (product rule 4).
 * - **Regularity is read through `predictNextPeriod`**, not computed again. The
 *   menopause panel already reuses it for exactly this reason: two places deciding
 *   whether her cycles are regular is two places that can disagree with each other
 *   on the same screen.
 */

type Client = ReturnType<typeof createClient>;

/** Days after which we describe the record as showing no recent bleed. */
const ABSENT_AFTER_DAYS = 90;

function daysBetween(fromISO: string, toISO: string): number {
  const from = Date.parse(`${fromISO}T00:00:00Z`);
  const to = Date.parse(`${toISO}T00:00:00Z`);
  if (Number.isNaN(from) || Number.isNaN(to)) return 0;
  return Math.round((to - from) / 86_400_000);
}

/**
 * `absent` describes the record, never the woman.
 *
 * A long gap is a gap in what she logged. Amenorrhea is a clinical finding and
 * Femio does not make them (product rule 1) — the resolver uses this to *widen*
 * what it offers, never to conclude anything.
 */
function regularityFrom(starts: readonly string[], today: string): CycleRegularity {
  if (starts.length === 0) return "unknown";
  const sorted = [...starts].sort();
  const last = sorted.at(-1)!;
  if (daysBetween(last, today) > ABSENT_AFTER_DAYS) return "absent";
  const prediction = predictNextPeriod(sorted);
  if (!prediction) return "unknown";
  return prediction.irregular ? "irregular" : "regular";
}

export async function readSignals(supabase: Client): Promise<PersonaSignals> {
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return EMPTY_SIGNALS;

  const today = todayISO();

  const [profile, cycles, conditions, pregnancy, symptoms] = await Promise.all([
    supabase.from("profiles").select("age_band").maybeSingle(),
    supabase.from("cycles").select("period_start").order("period_start", { ascending: false }),
    supabase.from("conditions_flagged").select("condition_code, created_at"),
    supabase
      .from("pregnancy")
      .select("status, edd, created_at, updated_at")
      .order("updated_at", { ascending: false })
      .limit(1)
      .maybeSingle(),
    supabase.from("symptom_logs").select("type").order("logged_at", { ascending: false }).limit(200),
  ]);

  const starts = (cycles.data ?? []).map((c) => c.period_start as string).filter(Boolean);
  const sorted = [...starts].sort();
  const lastStart = sorted.at(-1) ?? null;
  const prediction = sorted.length > 0 ? predictNextPeriod(sorted) : null;

  const conditionRows = (conditions.data ?? []) as { condition_code: string; created_at: string }[];
  const codes = [...new Set(conditionRows.map((r) => r.condition_code))];

  const symptomCounts: Record<string, number> = {};
  for (const row of (symptoms.data ?? []) as { type: string }[]) {
    symptomCounts[row.type] = (symptomCounts[row.type] ?? 0) + 1;
  }

  const pregnancyRow = pregnancy.data as
    | { status: string; edd: string | null; created_at: string }
    | null;
  const pregnancyStatus = pregnancyRow
    ? pregnancyRow.status === "active"
      ? ("active" as const)
      : ("ended" as const)
    : null;

  /**
   * The one signal that separates D3 from D4, and `docs/09` §8 rule 3 says they
   * must never be conflated: gestational diabetes resolves postpartum into a
   * single OGTT, pre-existing diabetes is lifelong care. The distinction is
   * *when* it was recorded relative to this pregnancy — a `diabetes` code
   * predating the pregnancy row, or the separate `gestational_diabetes` code the
   * wizard offers precisely so the two can be told apart.
   */
  const diabetesRow = conditionRows.find((r) => r.condition_code === "diabetes");
  const diabetesRecordedBeforePregnancy = Boolean(
    diabetesRow &&
      pregnancyRow &&
      Date.parse(diabetesRow.created_at) < Date.parse(pregnancyRow.created_at),
  );

  return {
    ...EMPTY_SIGNALS,
    ageBand: ((profile.data?.age_band as AgeBand | null) ?? null) as AgeBand | null,
    cycleRegularity: regularityFrom(sorted, today),
    averageCycleLength: prediction?.averageLength ?? null,
    daysSinceLastPeriod: lastStart ? daysBetween(lastStart, today) : null,
    // Stated intent, never guessed — it lives in `persona_state.flags_json` and is
    // supplied by the caller who knows which stage she just chose.
    ttcIntent: false,
    pregnancyStatus,
    weeksSincePregnancyEnd: null,
    conditions: codes,
    symptomCounts,
    diabetesRecordedBeforePregnancy,
    priorLoss: codes.includes("prior_loss"),
  };
}
