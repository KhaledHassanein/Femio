/**
 * Fetal movement pattern log (P2.2).
 *
 * This module deliberately does NOT contain a threshold, a target, or a function
 * that decides whether a session was reassuring — and that absence is the design,
 * not an omission.
 *
 * Femio's published, review-cleared guidance
 * (docs/content/articles/pregnancy-warning-signs.md) says: *"There is no single
 * normal number for everyone. Your baby's change from usual matters."* and
 * *"Should reduced movement wait until tomorrow? No."*
 *
 * A classic count-to-ten kick counter contradicts both. It implies a pass mark,
 * and the harm runs in the dangerous direction: reaching ten can read as "all is
 * well" to someone whose baby is moving much less than usual, and false
 * reassurance here delays care. That is also squarely product rule 1 — deciding
 * that a pattern is fine is a clinical conclusion, and Femio does not draw it.
 *
 * So what this module does is arithmetic and comparison against *her own* history:
 * how long a session took, and how it sits against her recent sessions. It surfaces
 * a change; it never interprets one.
 */

export type MovementSession = {
  id?: string;
  startedAt: string;
  endedAt: string | null;
  movementCount: number | null;
};

/** Elapsed milliseconds of a session, or null if it has not ended. */
export function sessionDurationMs(session: MovementSession): number | null {
  if (!session.endedAt) return null;
  const ms = new Date(session.endedAt).getTime() - new Date(session.startedAt).getTime();
  return Number.isFinite(ms) && ms >= 0 ? ms : null;
}

/**
 * Minutes per movement — the only figure that makes two sessions comparable when
 * she stopped at different counts. Null when it cannot be computed honestly
 * (unfinished, no movements recorded, or a zero-length session).
 */
export function minutesPerMovement(session: MovementSession): number | null {
  const ms = sessionDurationMs(session);
  if (ms === null || ms === 0) return null;
  if (!session.movementCount || session.movementCount <= 0) return null;
  return ms / 60000 / session.movementCount;
}

export type PatternComparison =
  | { status: "insufficient"; sessions: number }
  | {
      status: "comparable";
      sessions: number;
      typicalMinutesPerMovement: number;
      latestMinutesPerMovement: number;
      /** Latest is this many times her typical. >1 means movements are further apart. */
      ratio: number;
      /** Longer gaps than usual — a change worth her noticing, NOT a verdict. */
      slower: boolean;
    };

/** How many completed sessions before a comparison is worth showing at all. */
export const MIN_SESSIONS_FOR_PATTERN = 3;

/**
 * A session is flagged as "slower than usual" at 1.5x her own median gap.
 *
 * The multiplier is a display threshold for *when to prompt her to consider
 * calling*, never a diagnostic one, and it is intentionally biased to prompt too
 * often rather than too rarely: a false prompt costs a phone call, a missed one
 * costs much more. The surrounding UI offers the same maternity-contact route
 * whether or not this is true, so nothing is gated behind it.
 */
export const SLOWER_RATIO = 1.5;

function median(values: number[]): number {
  const sorted = [...values].sort((a, b) => a - b);
  const mid = Math.floor(sorted.length / 2);
  const hi = sorted[mid] ?? 0;
  if (sorted.length % 2 !== 0) return hi;
  const lo = sorted[mid - 1] ?? hi;
  return (lo + hi) / 2;
}

/**
 * Compare the most recent session against the median of the ones before it.
 *
 * Median rather than mean: a single very long session (she was busy, she put the
 * phone down) would drag a mean and make every later session look fast by
 * comparison — which would suppress exactly the signal this exists to surface.
 *
 * `sessions` is expected newest-first, as the queries return it.
 */
export function comparePattern(sessions: MovementSession[]): PatternComparison {
  const rates = sessions
    .map((s) => ({ session: s, rate: minutesPerMovement(s) }))
    .filter((r): r is { session: MovementSession; rate: number } => r.rate !== null);

  if (rates.length < MIN_SESSIONS_FOR_PATTERN) {
    return { status: "insufficient", sessions: rates.length };
  }

  const latest = rates[0];
  const previous = rates.slice(1);
  // Unreachable given the length check above, but the compiler cannot see that and
  // an assertion here would be the wrong tool in a health calculation.
  if (!latest) return { status: "insufficient", sessions: rates.length };

  const typical = median(previous.map((p) => p.rate));
  if (typical === 0) return { status: "insufficient", sessions: rates.length };

  const ratio = latest.rate / typical;
  return {
    status: "comparable",
    sessions: rates.length,
    typicalMinutesPerMovement: typical,
    latestMinutesPerMovement: latest.rate,
    ratio,
    slower: ratio >= SLOWER_RATIO,
  };
}
