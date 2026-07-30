/**
 * k-anonymity for the first-party insights dashboard (P1.20.3).
 *
 * The suppression that *matters* happens in SQL (migration 0006), so a small
 * cell never leaves the database. This module re-applies the same rule on the
 * way to the screen, for the same reason `lib/analytics/guard.ts` re-validates
 * events the types already describe: the guarantee should not depend on one
 * layer staying correct. If someone later relaxes the SQL, or points the page at
 * a different source, a group of 3 women still does not reach a screen.
 *
 * K must match `public.insights_k()`. It is duplicated deliberately — a value
 * fetched from the thing it is meant to police is not a check.
 */
export const K = 10;

/** A count that may have been withheld for being too small to be anonymous. */
export type Count = number | null;

export type Bucket = { bucket: string; users: Count };

/** The label SQL uses for suppressed groups rolled together. */
export const WITHHELD_BUCKET = "withheld";

export function isSuppressed(value: Count): boolean {
  return value === null;
}

/** Below k → withheld (null). Already-withheld stays withheld. */
export function suppressCount(value: Count, k: number = K): Count {
  if (value === null) return null;
  return value >= k ? value : null;
}

/**
 * Drops any bucket that falls below k rather than nulling it: for a breakdown,
 * showing "PCOS — withheld" would still disclose that a tiny PCOS group exists,
 * which is itself the sensitive fact. Buckets already withheld by SQL are kept
 * (they carry no number), and the roll-up bucket passes through untouched.
 */
export function suppressBuckets(rows: Bucket[], k: number = K): Bucket[] {
  return rows.filter(
    (r) => r.bucket === WITHHELD_BUCKET || r.users === null || r.users >= k,
  );
}

/** True when nothing in the breakdown can be shown — the honest empty state. */
export function isFullyWithheld(rows: Bucket[]): boolean {
  return rows.every((r) => r.users === null || r.bucket === WITHHELD_BUCKET);
}

/** Largest visible count, for drawing bars proportionally. */
export function maxVisible(rows: Bucket[]): number {
  return rows.reduce((max, r) => (r.users !== null && r.users > max ? r.users : max), 0);
}
