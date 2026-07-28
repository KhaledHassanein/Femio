import { diffDays, isValidISODate } from "@/lib/calculators/dates";

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

export type VisitSummary = {
  generatedAt: string;
  track: string | null;
  cycle: {
    logged: number;
    averageLength: number | null;
    rangeLow: number | null;
    rangeHigh: number | null;
    lastPeriod: string | null;
    recent: { start: string; flow: string | null }[];
  };
  symptoms: { type: string; severity: number | null; date: string }[];
  meds: { name: string; active: boolean }[];
  conditions: { code: string; source: string }[];
  keyDates: { label: string | null; date: string }[];
};

function cycleLengths(startsDesc: string[]): number[] {
  const sorted = [...new Set(startsDesc.filter(isValidISODate))].sort();
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
  },
  generatedAt: string,
): VisitSummary {
  const cycles = input.cycles ?? [];
  const startsDesc = cycles.map((c) => c.period_start).filter(isValidISODate);
  const lengths = cycleLengths(startsDesc);
  const averageLength =
    lengths.length > 0 ? Math.round(lengths.reduce((a, b) => a + b, 0) / lengths.length) : null;

  return {
    generatedAt,
    track: input.track ?? null,
    cycle: {
      logged: startsDesc.length,
      averageLength,
      rangeLow: lengths.length > 0 ? Math.min(...lengths) : null,
      rangeHigh: lengths.length > 0 ? Math.max(...lengths) : null,
      lastPeriod: startsDesc.length > 0 ? [...startsDesc].sort().at(-1)! : null,
      recent: cycles.slice(0, 6).map((c) => ({ start: c.period_start, flow: c.flow ?? null })),
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
