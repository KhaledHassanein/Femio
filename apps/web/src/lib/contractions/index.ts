/**
 * Contraction timing (P2.2.3) — the arithmetic, on its own.
 *
 * `pregnancy.contractions` has been in the Track D registry since R2.1, surfaced
 * from around 36 weeks, and rendered nothing. This is the maths behind it.
 *
 * ## What it computes, and the thing it refuses to
 *
 * Duration (how long one lasted) and interval (start of one to start of the next),
 * plus a rolling average over the recent few. Those are the two numbers a midwife
 * asks for on the phone, and having them ready is the entire feature.
 *
 * **It does not decide whether this is labour.** There is no `isLabour`, no
 * `stage`, no `phase`, and no 5-1-1 evaluation. That pattern — five minutes apart,
 * one minute long, for one hour — is guidance a clinician gives about *when to
 * call*, and an app that returned "this is active labour" would be making a
 * clinical assessment from a stopwatch. It is also the assessment with the worst
 * failure mode in the app: a woman who is told "not yet" by her phone and waits.
 *
 * So the summary is facts and the screen puts the maternity-unit route above them,
 * unconditionally, the way the movement log does (ADR-049). She reads her numbers
 * out; the person on the other end decides.
 *
 * Pure and clock-injected like the rest of tier 2.
 */

export type Contraction = {
  id: string;
  /** ISO timestamp. */
  startedAt: string;
  /** Null while one is in progress, or when she never stopped it. */
  endedAt: string | null;
};

const MS_PER_SECOND = 1000;

/** How many recent contractions the rolling average looks at. */
export const RECENT_WINDOW = 5;

export type TimedContraction = Contraction & {
  /** Seconds, or null while it is still running. */
  durationSeconds: number | null;
  /**
   * Seconds from the start of the previous contraction to the start of this one.
   * Null for the first one recorded — there is nothing to measure from, and
   * inventing a zero would drag every average down.
   */
  intervalSeconds: number | null;
};

function seconds(fromISO: string, toISO: string): number {
  return Math.max(0, Math.round((Date.parse(toISO) - Date.parse(fromISO)) / MS_PER_SECOND));
}

/**
 * Oldest first, each carrying its duration and the gap since the previous start.
 *
 * Sorted here rather than trusted from the query: the interval of a contraction
 * depends entirely on which one came before it, so a row arriving out of order
 * would not merely display oddly, it would produce a wrong number she reads aloud.
 */
export function timeContractions(contractions: readonly Contraction[]): TimedContraction[] {
  const sorted = [...contractions].sort((a, b) => a.startedAt.localeCompare(b.startedAt));
  return sorted.map((contraction, index) => {
    const previous = index > 0 ? sorted[index - 1]! : null;
    return {
      ...contraction,
      durationSeconds: contraction.endedAt ? seconds(contraction.startedAt, contraction.endedAt) : null,
      intervalSeconds: previous ? seconds(previous.startedAt, contraction.startedAt) : null,
    };
  });
}

export type ContractionSummary = {
  /** How many are in the window the averages were taken over. */
  counted: number;
  /** Rounded seconds, or null when nothing finished / nothing had a predecessor. */
  averageDurationSeconds: number | null;
  averageIntervalSeconds: number | null;
};

function mean(values: readonly number[]): number | null {
  if (values.length === 0) return null;
  return Math.round(values.reduce((a, b) => a + b, 0) / values.length);
}

/**
 * The two numbers she will be asked for, over the recent few rather than all night.
 *
 * A whole-session average is the wrong answer to "how far apart are they now" —
 * contractions that were twenty minutes apart four hours ago would flatten the
 * number she is being asked about. Deliberately **not** a trend, a direction or a
 * judgement: no "getting closer", no "regular", no verdict of any kind.
 */
export function summarize(
  timed: readonly TimedContraction[],
  window: number = RECENT_WINDOW,
): ContractionSummary {
  const recent = timed.slice(-window);
  return {
    counted: recent.length,
    averageDurationSeconds: mean(
      recent.map((c) => c.durationSeconds).filter((v): v is number => v !== null),
    ),
    averageIntervalSeconds: mean(
      recent.map((c) => c.intervalSeconds).filter((v): v is number => v !== null),
    ),
  };
}

/**
 * The one still running, if any — and only the **last** one can be.
 *
 * The obvious implementation searches the list for any unfinished row, and that is
 * wrong: an earlier contraction with no end is one she abandoned, not one that is
 * still happening, and treating it as live would leave a timer counting up from
 * hours ago. Once a later contraction exists, nothing before it is in progress.
 */
export function inProgress(timed: readonly TimedContraction[]): TimedContraction | null {
  const last = timed.at(-1);
  return last && last.endedAt === null ? last : null;
}

/** `m:ss`, the shape a stopwatch reads in. Locale-independent by design. */
export function formatDuration(totalSeconds: number): string {
  const minutes = Math.floor(totalSeconds / 60);
  const rest = totalSeconds % 60;
  return `${minutes}:${String(rest).padStart(2, "0")}`;
}
