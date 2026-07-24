import { diffDays, isValidISODate } from "@/lib/calculators/dates";

// Small, pure insight helpers over the user's own logged data. Uncertainty-honest
// and non-diagnostic — these describe patterns, never verdicts (docs/09 §1.4).

/** Current cycle day (day 1 = the last period start on/before today). */
export function currentCycleDay(starts: string[], today: string): number | null {
  const past = starts.filter(isValidISODate).filter((d) => diffDays(d, today) >= 0);
  if (past.length === 0) return null;
  const last = past.sort().at(-1)!;
  return diffDays(last, today) + 1;
}

/** Most frequently logged symptom types, most-common first. */
export function topSymptoms(types: string[], limit = 3): { type: string; count: number }[] {
  const counts = new Map<string, number>();
  for (const t of types) counts.set(t, (counts.get(t) ?? 0) + 1);
  return [...counts.entries()]
    .map(([type, count]) => ({ type, count }))
    .sort((a, b) => b.count - a.count || a.type.localeCompare(b.type))
    .slice(0, limit);
}
