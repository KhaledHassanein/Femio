// Date-only helpers over ISO dates (YYYY-MM-DD). Arithmetic is done in UTC so DST
// can never shift a day; only `todayISO` reads the local clock, on purpose.

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
 * Today as the device's LOCAL calendar date (MR-11). The UTC date is wrong for
 * three hours a night in Cairo and Riyadh, which is exactly when a woman logs.
 */
export function todayISO(now: Date = new Date()): string {
  const y = now.getFullYear();
  const m = String(now.getMonth() + 1).padStart(2, "0");
  const d = String(now.getDate()).padStart(2, "0");
  return `${y}-${m}-${d}`;
}
