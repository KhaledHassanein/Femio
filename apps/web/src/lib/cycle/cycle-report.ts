import { diffDays, isValidISODate } from "../calculators/dates.ts";
import { bleedStarts } from "./predict.ts";

/**
 * The cycle that just ended — tier 2, so pure and portable.
 *
 * Both incumbents produce an end-of-cycle summary and `docs/26` §6 lists it as
 * table stakes Femio was missing. It is also the one moment in the month when a
 * woman is naturally looking back rather than forward, so it is where a summary
 * costs her the least attention.
 *
 * ## It describes; it does not grade
 *
 * There is no score, no "good cycle", no green tick for regularity, and no arrow
 * saying she improved. `docs/25` §5a rejected the ring because a ring implies a
 * target, and a graded cycle report implies the same thing more explicitly — a
 * cycle is not a performance and 31 days is not worse than 28.
 *
 * The one comparison it does make is to **her own previous cycles**, never to a
 * textbook 28: `deltaFromUsual` is the difference from her own mean, and it is
 * signed rather than labelled so the UI can say "three days longer than your
 * usual" without saying whether that is good.
 *
 * ## Why it only ever reports a *completed* cycle
 *
 * A cycle is only measurable once the next period has started — that is what
 * defines its length. Reporting on the running cycle would mean guessing its
 * length, which is the prediction's job and carries the prediction's uncertainty.
 * So this returns `null` until there are two bleeds to measure between.
 */

export type CycleReport = {
  /** First day of the cycle being reported on. */
  start: string;
  /** First day of the next period, i.e. the day this cycle ended. */
  end: string;
  /** Its measured length in days. Not an estimate — both ends are logged. */
  length: number;
  /**
   * Difference from the mean of her *earlier* cycles, or `null` when this is the
   * first one she has completed and there is nothing to compare against.
   *
   * Deliberately excludes the cycle being reported, so the comparison is against
   * what she knew before it — including it would blunt exactly the difference the
   * card exists to show.
   */
  deltaFromUsual: number | null;
  /** Days within the cycle on which she logged a bleed. */
  bleedDays: number;
  /** Distinct symptom types logged during it, most-frequent first. */
  symptoms: { type: string; count: number }[];
};

export type ReportInput = {
  /** Every logged period date, raw. Collapsed into bleeds here. */
  periodDates: readonly string[];
  /** Dated symptom logs. */
  symptoms: readonly { type: string; date: string }[];
};

/**
 * Summarise the most recently completed cycle, or `null` if none has completed.
 *
 * `null` is a real answer and callers must render it as nothing at all — an empty
 * "no report yet" card would be a box asking her for data to fill it.
 */
export function lastCompletedCycle({ periodDates, symptoms }: ReportInput): CycleReport | null {
  const starts = bleedStarts([...periodDates]);
  if (starts.length < 2) return null;

  const start = starts[starts.length - 2]!;
  const end = starts[starts.length - 1]!;
  const length = diffDays(start, end);
  if (length <= 0) return null;

  // Her mean *before* this cycle. One earlier interval is enough to compare
  // against; none means this is her first completed cycle and there is nothing
  // honest to say about whether it was typical.
  const earlier: number[] = [];
  for (let i = 1; i < starts.length - 1; i += 1) {
    earlier.push(diffDays(starts[i - 1]!, starts[i]!));
  }
  const deltaFromUsual =
    earlier.length > 0
      ? length - Math.round(earlier.reduce((a, b) => a + b, 0) / earlier.length)
      : null;

  // Bleed days counted from her raw entries, not from the collapsed starts — the
  // collapse exists to find cycle boundaries, and using it here would report every
  // period as one day long.
  const bleedDays = [...new Set(periodDates.filter(isValidISODate))].filter(
    (d) => diffDays(start, d) >= 0 && diffDays(d, end) > 0,
  ).length;

  const counts = new Map<string, number>();
  for (const s of symptoms) {
    if (!isValidISODate(s.date)) continue;
    if (diffDays(start, s.date) < 0 || diffDays(s.date, end) <= 0) continue;
    counts.set(s.type, (counts.get(s.type) ?? 0) + 1);
  }

  return {
    start,
    end,
    length,
    deltaFromUsual,
    bleedDays,
    symptoms: [...counts.entries()]
      .map(([type, count]) => ({ type, count }))
      .sort((a, b) => b.count - a.count || a.type.localeCompare(b.type))
      .slice(0, 4),
  };
}
