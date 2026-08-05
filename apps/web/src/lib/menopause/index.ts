import { diffDays, isValidISODate } from "@/lib/calculators/dates";

/**
 * Perimenopause / menopause tracking (P1.13c).
 *
 * The single most useful number in this life stage is how long it has been since the
 * last period, because the clinical convention is twelve consecutive months without one.
 * Femio reports that count and names the convention. It does **not** conclude anything
 * from it — that would be diagnosing, which is outside what Femio is (product rule 1),
 * and it would be wrong often enough to matter: pregnancy, thyroid disease, some
 * medicines and several other causes stop periods too, which is exactly why the clinical
 * definition includes "with no other cause", and only a clinician can establish that.
 *
 * So the honest shape is: here is the count, here is what the convention says, here is
 * why it is worth a conversation. The arithmetic is ours; the conclusion is hers and her
 * clinician's.
 */

/** The convention: twelve consecutive months without a period, other causes excluded. */
export const MENOPAUSE_MONTHS = 12;

/**
 * Symptoms most associated with this transition, drawn from the existing taxonomy so
 * nothing new has to be logged or translated. Used to pick out the relevant part of a
 * symptom history rather than showing an undifferentiated "most logged" list.
 */
export const MENOPAUSE_SYMPTOMS = [
  "hotFlashes",
  "insomnia",
  "brainFog",
  "moodSwings",
  "anxious",
  "irritable",
  "jointPain",
  "headache",
  "fatigue",
  "libidoDown",
  "lowMotivation",
] as const;

export type SinceLastPeriod = {
  days: number;
  /** Whole months elapsed, counted by calendar rather than by 30-day blocks. */
  months: number;
  /** Whether the count has passed the twelve-month convention. */
  pastConventionalMarker: boolean;
  /** Months still to go before that marker; 0 once passed. */
  monthsRemaining: number;
};

/**
 * How long since the most recent logged period start.
 * Null when there is nothing logged or the date is unusable — an empty state is better
 * than a number derived from nothing.
 */
export function sinceLastPeriod(lastStartISO: string | null, todayISO: string): SinceLastPeriod | null {
  if (!lastStartISO || !isValidISODate(lastStartISO) || !isValidISODate(todayISO)) return null;

  const days = diffDays(lastStartISO, todayISO);
  if (days < 0) return null; // a future date is a data error, not a very long gap

  // Calendar months, not days/30: "six months" should mean the same thing to a reader
  // as it does on her calendar, and the 30-day approximation drifts by days a year.
  const from = new Date(`${lastStartISO}T00:00:00Z`);
  const to = new Date(`${todayISO}T00:00:00Z`);
  let months = (to.getUTCFullYear() - from.getUTCFullYear()) * 12 + (to.getUTCMonth() - from.getUTCMonth());
  if (to.getUTCDate() < from.getUTCDate()) months -= 1;
  months = Math.max(0, months);

  return {
    days,
    months,
    pastConventionalMarker: months >= MENOPAUSE_MONTHS,
    monthsRemaining: Math.max(0, MENOPAUSE_MONTHS - months),
  };
}

export type CycleVariability = {
  shortest: number;
  longest: number;
  spread: number;
  /** True when recent cycles vary enough that a single predicted date would mislead. */
  irregular: boolean;
};

/**
 * Spread of recent cycle lengths. In perimenopause cycles typically become less
 * predictable before they stop, so the *variation* is more informative than the average —
 * and it is the honest thing to show, because a confident single date is precisely what
 * this stage cannot support (product rule 3).
 */
export function cycleVariability(starts: string[], window = 6): CycleVariability | null {
  const sorted = [...new Set(starts.filter(isValidISODate))].sort();
  if (sorted.length < 3) return null;

  const recent = sorted.slice(-(window + 1));
  const lengths: number[] = [];
  for (let i = 1; i < recent.length; i += 1) lengths.push(diffDays(recent[i - 1]!, recent[i]!));
  if (lengths.length < 2) return null;

  const shortest = Math.min(...lengths);
  const longest = Math.max(...lengths);
  const spread = longest - shortest;
  // Same threshold as `predictNextPeriod` (spread > 9) on purpose: two screens calling
  // the same cycles regular on one page and irregular on another would be a bug the
  // reader has no way to resolve.
  return { shortest, longest, spread, irregular: spread > 9 };
}
