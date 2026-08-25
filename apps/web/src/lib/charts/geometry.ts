/**
 * Chart geometry (RB-C3, `docs/29_REBUILD/05` §4).
 *
 * ## Why this is a separate module from the components
 *
 * A chart is two things: arithmetic that turns her data into coordinates, and SVG
 * that draws them. The arithmetic has to exist **twice** — once here and once in
 * Dart — and two clients disagreeing about where a fertile window starts is the
 * same class of problem as two clients disagreeing about a due date. So the
 * arithmetic is tier 2, pure, and bound by fixtures; the drawing is per-client and
 * carries no decisions.
 *
 * `lib/vitals/weight.ts` already set this precedent — `weightChart()` computes and
 * `weight-chart.tsx` draws. This generalises it.
 *
 * ## Build, do not adopt
 *
 * No charting library. Flo draws its own; the pregnancy tracker uses Compose canvas.
 * A library arrives with a theme we would spend longer overriding than writing, and
 * it will not respect our tokens, our RTL rules or our confidence semantics. It also
 * could not be reproduced in Dart, which makes the fixture rule impossible.
 *
 * ## The rule that governs every function here
 *
 * **Geometry never decides anything medical.** It receives numbers and returns
 * coordinates. Whether a window is wide, whether a pattern is strong, whether there
 * is enough data to say something — all tier 1, already computed, arriving as input.
 * The one exception is `hasEnoughPoints`, which is a *rendering* judgement about
 * whether a line would mislead, not a clinical one.
 *
 * ## RTL
 *
 * Time runs right-to-left in Arabic. Every function that maps a time domain to x
 * takes a `direction`, and an axis that does not flip is a bug — the kind that ships
 * because nobody tested it. `flipX` is the single place that inversion happens, so
 * there is one thing to get right rather than seven.
 */

export type Direction = "ltr" | "rtl";

export type Box = {
  width: number;
  height: number;
  padding?: { top?: number; right?: number; bottom?: number; left?: number };
};

export type Point = { x: number; y: number };

/** The drawable area inside a box, after padding. */
export function plotArea(box: Box): { x: number; y: number; width: number; height: number } {
  const p = box.padding ?? {};
  const left = p.left ?? 0;
  const top = p.top ?? 0;
  const right = p.right ?? 0;
  const bottom = p.bottom ?? 0;
  return {
    x: left,
    y: top,
    width: Math.max(0, box.width - left - right),
    height: Math.max(0, box.height - top - bottom),
  };
}

/**
 * Mirror an x coordinate for right-to-left reading.
 *
 * The single place inversion happens. Every time-domain function routes through it,
 * so getting RTL right is one thing to verify rather than seven.
 */
export function flipX(x: number, area: { x: number; width: number }, direction: Direction): number {
  if (direction === "ltr") return x;
  return area.x + area.width - (x - area.x);
}

/**
 * Map a value in `[min, max]` onto `[0, size]`.
 *
 * A zero-width domain returns the midpoint rather than dividing by zero: one logged
 * weight is a real state, and a chart of it should put the dot in the middle rather
 * than produce `NaN` and render nothing.
 */
export function linearScale(value: number, min: number, max: number, size: number): number {
  if (max === min) return size / 2;
  return ((value - min) / (max - min)) * size;
}

/**
 * Round axis bounds outward to human numbers.
 *
 * Charts whose axis reads 28.4–31.7 look computed; 28–32 looks considered. Returns
 * the bounds and the tick values, so the caller does not re-derive them and drift.
 */
export function niceBounds(min: number, max: number, targetTicks = 4): {
  min: number;
  max: number;
  ticks: readonly number[];
} {
  if (!Number.isFinite(min) || !Number.isFinite(max)) return { min: 0, max: 1, ticks: [0, 1] };
  if (min === max) {
    // A flat series still deserves an axis with room above and below it.
    const pad = Math.abs(min) * 0.1 || 1;
    return { min: min - pad, max: max + pad, ticks: [min - pad, min, min + pad] };
  }
  const span = max - min;
  const rawStep = span / Math.max(1, targetTicks);
  const magnitude = 10 ** Math.floor(Math.log10(rawStep));
  const step = [1, 2, 2.5, 5, 10].map((m) => m * magnitude).find((s) => s >= rawStep) ?? magnitude * 10;
  const niceMin = Math.floor(min / step) * step;
  const niceMax = Math.ceil(max / step) * step;
  const ticks: number[] = [];
  // Guard the loop: a pathological step could otherwise run away.
  for (let t = niceMin, i = 0; t <= niceMax + step / 2 && i < 64; t += step, i++) {
    ticks.push(Number(t.toFixed(6)));
  }
  return { min: niceMin, max: niceMax, ticks };
}

/* ------------------------------------------------------------------ *
 * 1. DotStrip — one dot per day
 *
 * Flo's cycle history is a legend and a row of dots, and it is the one part of
 * their data visualisation that works: legible at a glance, correct at any width,
 * no axis to misread. Ours also carries flow intensity, which theirs cannot.
 * ------------------------------------------------------------------ */

export type DotSpec = { index: number; cx: number; cy: number; r: number };

export function dotStrip(
  count: number,
  box: Box,
  direction: Direction = "ltr",
  options: { gap?: number; maxRadius?: number } = {},
): readonly DotSpec[] {
  const area = plotArea(box);
  if (count <= 0 || area.width <= 0) return [];
  const gap = options.gap ?? 2;
  const slot = area.width / count;
  const r = Math.max(1, Math.min(options.maxRadius ?? 6, (slot - gap) / 2, area.height / 2));
  const cy = area.y + area.height / 2;
  return Array.from({ length: count }, (_, index) => {
    const cx = area.x + slot * index + slot / 2;
    return { index, cx: flipX(cx, area, direction), cy, r };
  });
}

/* ------------------------------------------------------------------ *
 * 2. RangeBand — a span within a domain
 * ------------------------------------------------------------------ */

export type BandSpec = { x: number; width: number; y: number; height: number };

/**
 * A band covering `[startIndex, endIndex]` of `total` slots.
 *
 * Inclusive of both ends, because a fertile window "from the 16th to the 26th"
 * includes the 26th. Off-by-one here is the difference between a correct chart and
 * one that quietly drops her last fertile day.
 */
export function rangeBand(
  startIndex: number,
  endIndex: number,
  total: number,
  box: Box,
  direction: Direction = "ltr",
): BandSpec | null {
  const area = plotArea(box);
  if (total <= 0 || area.width <= 0) return null;
  const lo = Math.max(0, Math.min(startIndex, endIndex));
  const hi = Math.min(total - 1, Math.max(startIndex, endIndex));
  if (hi < lo) return null;
  const slot = area.width / total;
  const width = slot * (hi - lo + 1);
  const xLtr = area.x + slot * lo;
  const x = direction === "ltr" ? xLtr : flipX(xLtr + width, area, "rtl");
  return { x, width, y: area.y, height: area.height };
}

/* ------------------------------------------------------------------ *
 * 3 & 6. TimeSeries and Sparkline
 *
 * A sparkline is a time series with no axes and no room, so it is the same
 * geometry with a smaller box. One implementation, not two.
 * ------------------------------------------------------------------ */

export type SeriesInput = { values: readonly (number | null)[]; box: Box; direction?: Direction };

export type SeriesGeometry = {
  points: readonly (Point | null)[];
  /** Contiguous runs of real points. A gap in her logging is a gap in the line. */
  segments: readonly (readonly Point[])[];
  bounds: { min: number; max: number; ticks: readonly number[] };
};

export function timeSeries({ values, box, direction = "ltr" }: SeriesInput): SeriesGeometry {
  const area = plotArea(box);
  const real = values.filter((v): v is number => v !== null && Number.isFinite(v));
  const bounds = niceBounds(
    real.length > 0 ? Math.min(...real) : 0,
    real.length > 0 ? Math.max(...real) : 1,
  );

  const points = values.map((v, i) => {
    if (v === null || !Number.isFinite(v)) return null;
    const xLtr = area.x + linearScale(i, 0, Math.max(1, values.length - 1), area.width);
    return {
      x: flipX(xLtr, area, direction),
      // SVG y grows downward, so a high value is a small y.
      y: area.y + area.height - linearScale(v, bounds.min, bounds.max, area.height),
    };
  });

  /**
   * Split at nulls rather than interpolating across them. A line drawn through a
   * week she did not log implies data she never gave — the visual equivalent of
   * inventing a reading.
   */
  const segments: Point[][] = [];
  let current: Point[] = [];
  for (const p of points) {
    if (p === null) {
      if (current.length > 0) segments.push(current);
      current = [];
    } else current.push(p);
  }
  if (current.length > 0) segments.push(current);

  return { points, segments, bounds };
}

/** An SVG path from a run of points. Empty string for a run too short to draw. */
export function polyline(points: readonly Point[]): string {
  if (points.length === 0) return "";
  return points.map((p, i) => `${i === 0 ? "M" : "L"}${p.x.toFixed(2)} ${p.y.toFixed(2)}`).join(" ");
}

/* ------------------------------------------------------------------ *
 * 4. Histogram
 * ------------------------------------------------------------------ */

export type BarSpec = { index: number; x: number; y: number; width: number; height: number };

export function histogram(
  counts: readonly number[],
  box: Box,
  direction: Direction = "ltr",
  options: { gap?: number } = {},
): readonly BarSpec[] {
  const area = plotArea(box);
  if (counts.length === 0 || area.width <= 0) return [];
  const gap = options.gap ?? 2;
  const slot = area.width / counts.length;
  const width = Math.max(1, slot - gap);
  const max = Math.max(...counts, 1);
  return counts.map((c, index) => {
    const height = area.height * (Math.max(0, c) / max);
    const xLtr = area.x + slot * index + gap / 2;
    const x = direction === "ltr" ? xLtr : flipX(xLtr + width, area, "rtl");
    return { index, x, y: area.y + area.height - height, width, height };
  });
}

/* ------------------------------------------------------------------ *
 * 5. RingProgress
 * ------------------------------------------------------------------ */

/**
 * A ring arc for `progress` in 0..1, starting at twelve o'clock.
 *
 * Uses `stroke-dasharray` rather than an arc path: it animates cleanly with one
 * property, which `--motion-prediction` needs when a cycle position moves, and it
 * cannot produce the degenerate arc that a 100% path does.
 */
export function ringProgress(
  progress: number,
  box: Box,
  options: { strokeWidth?: number } = {},
): { cx: number; cy: number; r: number; circumference: number; dash: number; strokeWidth: number } {
  const area = plotArea(box);
  const strokeWidth = options.strokeWidth ?? 8;
  const r = Math.max(0, Math.min(area.width, area.height) / 2 - strokeWidth / 2);
  const circumference = 2 * Math.PI * r;
  const clamped = Number.isFinite(progress) ? Math.max(0, Math.min(1, progress)) : 0;
  return {
    cx: area.x + area.width / 2,
    cy: area.y + area.height / 2,
    r,
    circumference,
    dash: circumference * clamped,
    strokeWidth,
  };
}

/* ------------------------------------------------------------------ *
 * 7. ConfidenceBand — ours alone
 *
 * A prediction drawn with its uncertainty visible. No competitor in the teardown
 * has one: Flo hedges in copy and draws a single dotted ring, because its model has
 * nowhere to put a width.
 * ------------------------------------------------------------------ */

export type ConfidenceInput = {
  centre: readonly (number | null)[];
  lower: readonly (number | null)[];
  upper: readonly (number | null)[];
  box: Box;
  direction?: Direction;
};

export function confidenceBand({ centre, lower, upper, box, direction = "ltr" }: ConfidenceInput): {
  centreLine: string;
  area: string;
  bounds: SeriesGeometry["bounds"];
} {
  const plot = plotArea(box);
  const all = [...centre, ...lower, ...upper].filter(
    (v): v is number => v !== null && Number.isFinite(v),
  );
  const bounds = niceBounds(
    all.length > 0 ? Math.min(...all) : 0,
    all.length > 0 ? Math.max(...all) : 1,
  );
  const at = (v: number, i: number, n: number): Point => ({
    x: flipX(plot.x + linearScale(i, 0, Math.max(1, n - 1), plot.width), plot, direction),
    y: plot.y + plot.height - linearScale(v, bounds.min, bounds.max, plot.height),
  });

  const n = Math.max(centre.length, lower.length, upper.length);
  const top: Point[] = [];
  const bottom: Point[] = [];
  for (let i = 0; i < n; i++) {
    const u = upper[i];
    const l = lower[i];
    if (u !== null && u !== undefined && Number.isFinite(u)) top.push(at(u, i, n));
    if (l !== null && l !== undefined && Number.isFinite(l)) bottom.push(at(l, i, n));
  }

  const centrePoints = centre
    .map((v, i) => (v === null || !Number.isFinite(v) ? null : at(v, i, n)))
    .filter((p): p is Point => p !== null);

  /** Closed area: along the upper edge, back along the lower. */
  const area =
    top.length > 0 && bottom.length > 0
      ? `${polyline(top)} ${bottom
          .slice()
          .reverse()
          .map((p) => `L${p.x.toFixed(2)} ${p.y.toFixed(2)}`)
          .join(" ")} Z`
      : "";

  return { centreLine: polyline(centrePoints), area, bounds };
}

/* ------------------------------------------------------------------ *
 * Honesty at low n
 * ------------------------------------------------------------------ */

/**
 * Is there enough here to draw a line rather than a set of dots?
 *
 * Two points make a line that looks like a trend and is not one. This is a
 * *rendering* judgement — whether a shape would mislead — and deliberately not a
 * clinical one: `lib/patterns` decides whether a finding exists, and it uses about
 * three cycles. A chart may draw what it has; it may not imply more.
 */
export function hasEnoughPoints(values: readonly (number | null)[], minimum = 3): boolean {
  return values.filter((v) => v !== null && Number.isFinite(v)).length >= minimum;
}
