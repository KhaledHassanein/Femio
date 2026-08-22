import { diffDays, isValidISODate } from "../calculators/dates.ts";
import { bleedStarts } from "./predict.ts";

/**
 * Where in her cycle a symptom actually falls — tier 2, so pure and portable.
 *
 * `symptom_logs` has held real data since P1.14 and **nothing has ever read it**
 * beyond counting the three most frequent types. Both incumbents ship pattern
 * spotting, and `docs/26` §6 lists it as table stakes Femio was missing. This is
 * the module that reads her own record back to her.
 *
 * ## What it will and will not say
 *
 * It reports **counts over cycle days**. "You logged cramps on days 1–3 in four of
 * your last five cycles" is arithmetic she could do herself with a calendar, and
 * it is the whole claim. It is not:
 *
 * - a cause. Nothing here says the cycle *produced* the symptom.
 * - a diagnosis. `docs/09` §1.4 and product rule 1 both forbid it, and a pattern
 *   is exactly the shape of evidence people over-read.
 * - a prediction. It never says "you will get cramps on Tuesday".
 *
 * The reviewed article this sits beside puts it plainly and the wording is worth
 * keeping: *a repeating pattern may be useful to record, but the pattern alone
 * cannot confirm a health condition.*
 *
 * ## Why a minimum before it says anything
 *
 * A symptom logged in one cycle has no pattern; showing "you always get this on
 * day 2" from a single observation is the same false confidence R3.1.7 removed
 * from the prediction copy. So a symptom must appear in at least
 * `MIN_CYCLES_FOR_PATTERN` distinct cycles before it is reported at all, and the
 * count of cycles is returned so the UI can show its own evidence.
 */

/**
 * Below this, there is no pattern — only observations.
 *
 * Three is the smallest number that can show repetition rather than coincidence:
 * two occurrences are a line, three are the beginning of a shape. Deliberately not
 * two, which would let a symptom logged in back-to-back cycles claim to be typical.
 */
export const MIN_CYCLES_FOR_PATTERN = 3;

export type SymptomLog = {
  type: string;
  /** ISO date. Time of day is irrelevant to a cycle-day question. */
  date: string;
};

export type SymptomPattern = {
  type: string;
  /** 1-based cycle days on which it was logged, ascending, de-duped. */
  days: number[];
  /** The tightest run covering most occurrences — what the UI names. */
  from: number;
  to: number;
  /** How many distinct cycles it appeared in. The evidence, shown not hidden. */
  cycles: number;
  /** How many cycles she has logged in the window. The denominator. */
  ofCycles: number;
};

/** Which cycle a date belongs to, and which day of it. `null` if before the first. */
function cycleDayOf(starts: readonly string[], date: string): { cycle: number; day: number } | null {
  for (let i = starts.length - 1; i >= 0; i -= 1) {
    const offset = diffDays(starts[i]!, date);
    if (offset >= 0) return { cycle: i, day: offset + 1 };
  }
  return null;
}

/**
 * Her logged symptoms, grouped by where in the cycle they fall.
 *
 * Returns `[]` rather than a partial answer when there is not enough history —
 * "not yet" is a real result and callers must render it as one.
 */
export function symptomPatterns(
  logs: readonly SymptomLog[],
  periodStarts: readonly string[],
  limit = 3,
): SymptomPattern[] {
  // The same bleed-collapsing the prediction uses. Three days logged during one
  // period are one cycle here too, or every symptom would appear to fall on day 1
  // of a one-day cycle (R3.1.9).
  const starts = bleedStarts([...periodStarts]);
  if (starts.length < 2) return [];

  // Only complete cycles: the current one is still running, so a symptom absent
  // from it has not failed to appear — it may simply not have happened yet, and
  // counting it would drag every denominator down.
  const complete = starts.slice(0, -1);
  if (complete.length === 0) return [];

  const byType = new Map<string, Map<number, Set<number>>>();
  for (const log of logs) {
    if (!isValidISODate(log.date)) continue;
    const placed = cycleDayOf(starts, log.date);
    if (placed === null || placed.cycle >= complete.length) continue;
    const days = byType.get(log.type) ?? new Map<number, Set<number>>();
    const cycles = days.get(placed.day) ?? new Set<number>();
    cycles.add(placed.cycle);
    days.set(placed.day, cycles);
    byType.set(log.type, days);
  }

  const patterns: SymptomPattern[] = [];
  for (const [type, dayMap] of byType) {
    const distinctCycles = new Set<number>();
    for (const cycles of dayMap.values()) for (const c of cycles) distinctCycles.add(c);
    if (distinctCycles.size < MIN_CYCLES_FOR_PATTERN) continue;

    const days = [...dayMap.keys()].sort((a, b) => a - b);
    patterns.push({
      type,
      days,
      from: days[0]!,
      to: days[days.length - 1]!,
      cycles: distinctCycles.size,
      ofCycles: complete.length,
    });
  }

  // Most-repeated first, then earliest in the cycle, then alphabetical — a stable
  // order matters because this renders as a list she will re-read across sessions.
  return patterns
    .sort((a, b) => b.cycles - a.cycles || a.from - b.from || a.type.localeCompare(b.type))
    .slice(0, limit);
}
