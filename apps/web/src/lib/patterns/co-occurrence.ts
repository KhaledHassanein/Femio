import { CONFIDENCE_RANK, confidenceFrom, type PatternConfidence } from "./confidence.ts";
import { frameFor, placeInCycle, type Entry } from "./cycles.ts";

/**
 * Which symptoms she tends to log on the same day (P2.5).
 *
 * The second of the three dimensions `docs/03` §H.3 asks for, and the one where
 * the wording matters most, because **co-occurrence is the shape people read as
 * causation**. "Headaches with your cramps" is one careless preposition away from
 * "your cramps cause your headaches", which is a claim about mechanism Femio
 * cannot make and product rule 1 forbids it from making.
 *
 * So the output carries counts and nothing else: these two appeared on the same
 * day, in this many of your cycles, out of this many. The copy that renders it
 * says *together*, never *because*, and there is no field here that could carry a
 * direction — no `cause`, no `leads_to`, no ordering between `a` and `b`. The pair
 * is stored alphabetically precisely so nothing downstream can infer one.
 *
 * ## Why "in N cycles" rather than "on N days"
 *
 * Days are the wrong denominator: someone who logs both symptoms every day for one
 * bad week has seven co-occurrences and no pattern at all. Counting **distinct
 * cycles** makes the claim about repetition across her cycle rather than about the
 * length of a single episode — the same reasoning `MIN_CYCLES_FOR_PATTERN` already
 * encodes for timing.
 *
 * ## What is deliberately absent
 *
 * No lift, no chi-squared, no correlation coefficient. Three to twelve cycles of
 * self-reported data collected without a protocol cannot support a statistic, and
 * one printed next to a symptom would imply a rigour that is not there — see
 * `confidence.ts` for the full reasoning. She gets the counts, which she could
 * have derived from her own calendar, and Femio's confidence in them.
 */

export type CoOccurrence = {
  /** The pair, alphabetically. No ordering is implied and none may be inferred. */
  a: string;
  b: string;
  /** Distinct cycles in which both were logged on the same day. */
  cycles: number;
  /** Cycles in which *either* was logged — the honest denominator. */
  ofCycles: number;
  /** Days on which both appeared. Shown as supporting detail, never as the claim. */
  days: number;
  confidence: PatternConfidence;
};

/**
 * Below this the pair is a coincidence with a name. Two shared days across two
 * cycles is the kind of thing that happens to everyone in a month.
 */
const MIN_SHARED_DAYS = 3;

export function coOccurrences(
  entries: readonly Entry[],
  periodStarts: readonly string[],
  limit = 3,
): CoOccurrence[] {
  const frame = frameFor(periodStarts);
  if (!frame) return [];

  /** cycle → day → the set of types logged that day. */
  const byDay = new Map<string, Set<string>>();
  /** type → cycles it appeared in at all, for the denominator. */
  const cyclesByType = new Map<string, Set<number>>();

  for (const entry of entries) {
    const placed = placeInCycle(frame, entry.date);
    if (!placed) continue;
    const key = `${placed.cycle}:${placed.day}`;
    const types = byDay.get(key) ?? new Set<string>();
    types.add(entry.type);
    byDay.set(key, types);

    const seen = cyclesByType.get(entry.type) ?? new Set<number>();
    seen.add(placed.cycle);
    cyclesByType.set(entry.type, seen);
  }

  /** pair → { cycles, days } */
  const pairs = new Map<string, { a: string; b: string; cycles: Set<number>; days: number }>();
  for (const [key, types] of byDay) {
    if (types.size < 2) continue;
    const cycle = Number(key.split(":")[0]);
    const sorted = [...types].sort();
    for (let i = 0; i < sorted.length; i += 1) {
      for (let j = i + 1; j < sorted.length; j += 1) {
        const a = sorted[i]!;
        const b = sorted[j]!;
        const id = `${a}|${b}`;
        const bucket = pairs.get(id) ?? { a, b, cycles: new Set<number>(), days: 0 };
        bucket.cycles.add(cycle);
        bucket.days += 1;
        pairs.set(id, bucket);
      }
    }
  }

  const found: CoOccurrence[] = [];
  for (const { a, b, cycles, days } of pairs.values()) {
    if (days < MIN_SHARED_DAYS) continue;
    // Cycles in which either appeared: the pair can only co-occur in a cycle where
    // at least one of them was logged, so this is the population the count is out
    // of. Using every cycle she has would understate a symptom she only gets some
    // months; using only the shared cycles would make every pair look universal.
    const either = new Set<number>([
      ...(cyclesByType.get(a) ?? []),
      ...(cyclesByType.get(b) ?? []),
    ]);
    const ofCycles = Math.min(either.size, frame.completeCycles);
    const confidence = confidenceFrom({ cycles: cycles.size, ofCycles });
    if (!confidence) continue;
    found.push({ a, b, cycles: cycles.size, ofCycles, days, confidence });
  }

  // Stable across sessions: confidence, then repetition, then alphabetical. She
  // re-reads this list, and a list that reshuffles for no reason reads as noise.
  return found
    .sort(
      (x, y) =>
        CONFIDENCE_RANK[y.confidence] - CONFIDENCE_RANK[x.confidence] ||
        y.cycles - x.cycles ||
        x.a.localeCompare(y.a) ||
        x.b.localeCompare(y.b),
    )
    .slice(0, limit);
}
