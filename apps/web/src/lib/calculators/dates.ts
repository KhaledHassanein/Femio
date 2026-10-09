// Date-only helpers. Inputs are ISO dates (YYYY-MM-DD, as produced by <input
// type="date">). All math is done in UTC to avoid DST/timezone drift.

const MS_PER_DAY = 86_400_000;

export function isValidISODate(iso: string): boolean {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(iso)) return false;
  const d = new Date(`${iso}T00:00:00Z`);
  return !Number.isNaN(d.getTime()) && d.toISOString().slice(0, 10) === iso;
}

export function toUTC(iso: string): number {
  return new Date(`${iso}T00:00:00Z`).getTime();
}

export function addDays(iso: string, days: number): string {
  return new Date(toUTC(iso) + days * MS_PER_DAY).toISOString().slice(0, 10);
}

/** Whole days from `a` to `b` (b − a); negative if b is before a. */
export function diffDays(aISO: string, bISO: string): number {
  return Math.round((toUTC(bISO) - toUTC(aISO)) / MS_PER_DAY);
}

/**
 * Her calendar date, not UTC's: in Cairo after 21:00 UTC is already tomorrow, and
 * the UTC date made the pregnancy-week tool a day behind every evening (audit F17).
 */
export function todayISO(now = new Date()): string {
  const m = String(now.getMonth() + 1).padStart(2, "0");
  const d = String(now.getDate()).padStart(2, "0");
  return `${now.getFullYear()}-${m}-${d}`;
}
