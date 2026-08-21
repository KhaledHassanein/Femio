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
 * 3. **Ovulation is estimated backwards, not forwards.** The end of the cycle is
 *    its stable part; the follicular stretch is what varies. So the window is
 *    counted back from the *next* period rather than assumed to sit on day 14 —
 *    true only of a 28-day cycle, and the single most common error in this
 *    category. The interval itself is the NHS's, not ours (see below).
 */

export type CyclePhase = "menstrual" | "follicular" | "ovulatory" | "luteal";

/**
 * The ovulatory window, counted back from the *next* period.
 *
 * Sourced rather than invented, from Femio's own knowledge base: the NHS cycle
 * guide says exact timing is hard to pinpoint and **often falls around 10 to 16
 * days before the next period**, and ACOG describes a fertile interval that begins
 * several days before ovulation and ends about a day after it. Both are cited in
 * `docs/content/articles/fertile-window-explained.md`, which also states plainly
 * that ovulation does not always happen on day 14.
 *
 * This replaces a hand-picked `14 ± 2`. That earlier guess was not only unsourced
 * but **too narrow** — it described a five-day span where the NHS describes seven,
 * which is precisely the false precision product rule 3 exists to prevent.
 *
 * Deliberately a window and never a single day: a highlighted "ovulation day" is
 * the shape that gets read as a fertility guarantee, and Femio is not
 * contraception (product rule 1).
 *
 * Sources:
 *   NHS — Periods and fertility in the menstrual cycle
 *   https://www.nhs.uk/conditions/periods/fertility-in-the-menstrual-cycle/
 *   ACOG — Fertility Awareness-Based Methods of Family Planning
 *   https://www.acog.org/womens-health/faqs/fertility-awareness-based-methods-of-family-planning
 */
const OVULATION_EARLIEST_BEFORE_NEXT = 16;
const OVULATION_LATEST_BEFORE_NEXT = 10;

/**
 * Below this, a cycle is too short for the backwards estimate to mean anything:
 * the ovulatory window would land on or before the bleeding days and the phases
 * would overlap. 21 days is also the low end of what the NHS describes as a usual
 * cycle, and it is the lower bound the `profiles.stated_cycle_length` constraint
 * enforces — one number, three places, deliberately the same.
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

/**
 * Bleeding length used only when she has neither stated nor logged one.
 *
 * A last resort, not a claim: `stated_period_length` (R3.1b.1) is asked during
 * setup precisely so this is rarely reached, and her own logged days beat both.
 * The NHS cycle guide describes bleeding of around 2–7 days as usual; 5 is the
 * middle of that, and it is never presented to her as *her* number.
 */
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

  // Counted back from the next period, which is the stable end of the cycle — not
  // forward from day 1. Ovulation on "day 14" is true only of a 28-day cycle; for a
  // 32-day cycle it is four days early, and that is the commonest error in this
  // category.
  const windowOpens = cycleLength - OVULATION_EARLIEST_BEFORE_NEXT;
  const windowCloses = cycleLength - OVULATION_LATEST_BEFORE_NEXT;
  if (cycleDay >= windowOpens && cycleDay <= windowCloses) return "ovulatory";
  return cycleDay < windowOpens ? "follicular" : "luteal";
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
