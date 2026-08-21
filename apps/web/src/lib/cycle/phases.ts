/**
 * Menstrual cycle phases — tier 2 (`docs/24` §1), so pure, clock-free and portable.
 *
 * The design system has carried `--phase-menstrual/follicular/ovulatory/luteal`
 * since the token work, and nothing has ever rendered them: Femio predicts when
 * bleeding starts and says nothing about where she is in between. The competitive
 * research is blunt about the cost — apps that explain the phases deliver
 * dramatically more value than apps that only predict bleeding (`docs/26` §7).
 *
 * Three honesty constraints shape every choice below, and none of them is
 * negotiable for a nicer-looking ring:
 *
 * 1. **This is never contraception** (product rule 1). It describes a pattern that
 *    has already happened; it does not identify safe days and must never be
 *    presented as though it could.
 * 2. **Irregular means unknown, not approximate** (product rule 3). When her
 *    cycles do not support a phase estimate this returns `null` rather than a
 *    plausible-looking guess. A confident wrong phase is worse than no phase.
 * 3. **Ovulation is estimated backwards, not forwards.** The luteal phase is the
 *    stable part of the cycle; the follicular part is what varies. So ovulation is
 *    derived as `cycleLength - LUTEAL_DAYS` rather than assumed to be day 14,
 *    which is only true for a 28-day cycle and is the single most common error in
 *    this category.
 */

export type CyclePhase = "menstrual" | "follicular" | "ovulatory" | "luteal";

/**
 * Typical luteal length, counted back from the next period.
 *
 * [NEEDS SOURCE] — the 12–14 day luteal phase is standard in the clinical
 * literature and is the basis of every backwards ovulation estimate, but it needs
 * a Tier-1 citation (ACOG or NHS) before this ships user-visible copy. Using 14
 * here as the midpoint of the usual range.
 */
const LUTEAL_DAYS = 14;

/**
 * How wide the ovulatory window is, centred on the estimate.
 *
 * [NEEDS SOURCE] — needs the same citation. Deliberately a *window*, never a day:
 * a single highlighted "ovulation day" is the shape that gets read as a fertility
 * guarantee, which is exactly what product rule 1 forbids.
 */
const OVULATORY_SPAN = 2;

/**
 * Below this, a cycle is too short for the backwards estimate to mean anything —
 * `cycleLength - 14` would land on or before the bleeding days and the phases
 * would overlap. Returning `null` is the honest answer.
 */
const MIN_ESTIMABLE_CYCLE = 21;

export type PhaseInput = {
  /** 1-based day of the current cycle. Day 1 is the first day of bleeding. */
  cycleDay: number;
  /** Her own average, not a default. */
  cycleLength: number;
  /** Days of bleeding. Falls back to a typical value when she has not logged flow. */
  periodLength?: number;
  /**
   * Her cycles vary too much to place a phase. Passed in rather than re-derived:
   * `predictNextPeriod` already decides what "irregular" means and two answers to
   * that question is the drift the tier-1 rule exists to prevent.
   */
  irregular?: boolean;
};

/** [NEEDS SOURCE] — typical bleeding length when she has logged no flow data. */
const DEFAULT_PERIOD_DAYS = 5;

/**
 * Which phase a given cycle day falls in, or `null` when it cannot be known.
 *
 * `null` is a real answer and callers must render it as one — "we do not know yet"
 * — never by falling through to a default phase.
 */
export function phaseOnDay({
  cycleDay,
  cycleLength,
  periodLength = DEFAULT_PERIOD_DAYS,
  irregular = false,
}: PhaseInput): CyclePhase | null {
  if (irregular) return null;
  if (!Number.isFinite(cycleDay) || cycleDay < 1) return null;
  if (!Number.isFinite(cycleLength) || cycleLength < MIN_ESTIMABLE_CYCLE) return null;
  // A day beyond the expected length is not an error — her period is simply not
  // here yet. It is still luteal, and saying so is more useful than saying nothing.
  if (cycleDay > cycleLength) return "luteal";

  if (cycleDay <= Math.max(1, periodLength)) return "menstrual";

  const ovulation = cycleLength - LUTEAL_DAYS;
  if (cycleDay >= ovulation - OVULATORY_SPAN && cycleDay <= ovulation + OVULATORY_SPAN) {
    return "ovulatory";
  }
  return cycleDay < ovulation ? "follicular" : "luteal";
}

export type PhaseSegment = {
  phase: CyclePhase;
  /** 1-based, inclusive. */
  startDay: number;
  endDay: number;
};

/**
 * The whole cycle as ordered segments — what a ring or a strip needs in one pass.
 *
 * Built by walking `phaseOnDay` rather than repeating its arithmetic, so the ring
 * can never disagree with the label under it. Returns `[]` when no phase can be
 * estimated, which callers must render as an unknown cycle rather than an empty one.
 */
export function cycleSegments(input: Omit<PhaseInput, "cycleDay">): PhaseSegment[] {
  const { cycleLength } = input;
  if (input.irregular) return [];
  if (!Number.isFinite(cycleLength) || cycleLength < MIN_ESTIMABLE_CYCLE) return [];

  const segments: PhaseSegment[] = [];
  for (let day = 1; day <= cycleLength; day += 1) {
    const phase = phaseOnDay({ ...input, cycleDay: day });
    if (phase === null) return [];
    const last = segments[segments.length - 1];
    if (last && last.phase === phase) last.endDay = day;
    else segments.push({ phase, startDay: day, endDay: day });
  }
  return segments;
}
