/**
 * Weight in pregnancy (P2.2.3) — the geometry, on its own.
 *
 * `public.vitals` is the fifth table with RLS, an index and a place in the GDPR
 * export that nothing had ever written to (`docs/23` §3.2). Its own column comment
 * describes an open `type` set — `BP_sys`, `glucose`, `weight` — so weight lands
 * here rather than in a table of its own.
 *
 * ## Why there is no target line, and why that is the whole design
 *
 * There is published guidance on how much weight to gain in pregnancy, banded by
 * starting BMI. Femio does not draw it, does not compare her to it, and this module
 * exports nothing that could. A shaded "recommended range" behind her own dots is
 * an assessment of her body rendered as a background colour, and it is read that
 * way whether or not a caption says otherwise.
 *
 * It is also the single most likely place in this product to do harm quietly.
 * Pregnancy is a high-risk period for disordered eating and for weight stigma from
 * routine weighing, and a chart that says "above the line" every week to someone
 * already anxious about it is the app doing something no clinician asked it to.
 *
 * So: her dots, her axis, her numbers. Third time this codebase has made this call
 * — no `result` on the movement log (ADR-049), no `status` on `ClinicalStrip`
 * (R2.3), no shift marker on the BBT chart (P2.1) — and the fourth reason is the
 * same reason.
 */

export const WEIGHT_UNITS = ["kg", "lb"] as const;
export type WeightUnit = (typeof WEIGHT_UNITS)[number];

export type WeightEntry = {
  id: string;
  /** ISO date. */
  measuredOn: string;
  value: number;
  unit: WeightUnit;
};

/** Plausible readings, wide on purpose: a typo guard, never a comment on her body. */
const RANGE: Record<WeightUnit, { min: number; max: number }> = {
  kg: { min: 25, max: 300 },
  lb: { min: 55, max: 660 },
};

export function isPlausibleWeight(value: number, unit: WeightUnit): boolean {
  return Number.isFinite(value) && value >= RANGE[unit].min && value <= RANGE[unit].max;
}

const KG_PER_LB = 0.45359237;

/** Convert for plotting only — what she typed is what is stored and shown. */
export function toKg(value: number, unit: WeightUnit): number {
  return unit === "kg" ? value : value * KG_PER_LB;
}

export type WeightPoint = {
  entryId: string;
  measuredOn: string;
  value: number;
  unit: WeightUnit;
  /** 0–1, bottom to top. Geometry, never meaning. */
  y: number;
};

export type WeightChart = {
  points: WeightPoint[];
  /** In her preferred unit — the one she has used most recently. */
  unit: WeightUnit;
  low: number;
  high: number;
  /**
   * Change from the first reading to the last, in `unit`. A number, with no
   * comparison to anything: there is no expected value here to compare it to.
   */
  changeSinceFirst: number | null;
};

const MIN_POINTS = 2;
/** Axis padding, so a normal fluctuation does not draw as a cliff. */
const PADDING = { kg: 2, lb: 4 };

export function weightChart(entries: readonly WeightEntry[]): WeightChart | null {
  const sorted = [...entries].sort((a, b) => a.measuredOn.localeCompare(b.measuredOn));
  if (sorted.length < MIN_POINTS) return null;

  // Her most recent unit wins the axis: switching the chart to kilograms because
  // one old entry was in kilograms would make today's number unreadable to her.
  const unit = sorted[sorted.length - 1]!.unit;
  const inUnit = (entry: WeightEntry) =>
    unit === "kg" ? toKg(entry.value, entry.unit) : toKg(entry.value, entry.unit) / KG_PER_LB;

  const values = sorted.map(inUnit);
  const padding = PADDING[unit];
  const low = Math.min(...values) - padding;
  const high = Math.max(...values) + padding;
  const span = high - low || 1;

  return {
    unit,
    low,
    high,
    changeSinceFirst: Math.round((values[values.length - 1]! - values[0]!) * 10) / 10,
    points: sorted.map((entry, index) => ({
      entryId: entry.id,
      measuredOn: entry.measuredOn,
      value: Math.round(values[index]! * 10) / 10,
      unit,
      y: (values[index]! - low) / span,
    })),
  };
}
