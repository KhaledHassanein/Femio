"use client";

import { useLocale } from "next-intl";
import type { ReactNode } from "react";

import { getDir, type Locale } from "@/i18n/routing";
import {
  confidenceBand,
  dotStrip,
  histogram,
  polyline,
  rangeBand,
  ringProgress,
  timeSeries,
  type Box,
  type Direction,
} from "@/lib/charts/geometry";

/**
 * The seven chart primitives (RB-C3, `docs/29_REBUILD/05` §4).
 *
 * Every one of these draws and decides nothing. The arithmetic is in
 * `lib/charts/geometry.ts`, which is tier 2 and will exist again in Dart; these are
 * the web half, and they carry no logic a Flutter twin would have to reproduce.
 *
 * ## Why build rather than adopt
 *
 * The teardown's clearest finding is that **nobody in the category has a
 * data-visualisation layer**. Flo's cycle history is a legend and a row of dots;
 * its Insights tab has no chart on it at all. So this is not catch-up work, and a
 * charting library would arrive with a theme we would spend longer overriding than
 * writing — one that would not respect our tokens, our RTL rules or our confidence
 * semantics, and could not be reproduced in Dart.
 *
 * ## Four rules every chart here obeys
 *
 * **Colour comes from `--chart-*` and `--log-*`.** No literals. The
 * `chart-literals-lint` guard fails the build on a hex value in this directory,
 * because a chart that hard-codes `#7C3AED` is a chart that ignores dark mode and
 * cannot be re-themed.
 *
 * **RTL is not optional.** Time runs right-to-left in Arabic. Direction comes from
 * the locale by default rather than a prop someone must remember, and the
 * inversion happens once, in `flipX`.
 *
 * **Accessible by construction.** `ChartFrame` requires a caption and renders it in
 * a real `<figcaption>`. A chart without a text alternative does not compile, which
 * is the same decision as `a11y` being required on a module: a rule the type system
 * enforces beats a rule a developer remembers.
 *
 * **Honest at low n.** Below the threshold that supports a shape, the chart says so
 * instead of drawing a trend out of two points.
 */

/* ------------------------------------------------------------------ *
 * Frame
 * ------------------------------------------------------------------ */

type FrameProps = {
  /**
   * The text alternative, already translated by the caller.
   *
   * **Required, and generated from the same data the chart draws** — not an
   * `aria-label` bolted on afterwards. A caption that says "weight over time" tells
   * a screen-reader user nothing; one that says "eight readings from 4 March to 22
   * August, 61.2kg to 64.8kg" tells them what the sighted reader can see.
   */
  caption: string;
  /** Rendered instead of the chart when there is not enough data to be honest. */
  fallback?: ReactNode;
  enough?: boolean;
  className?: string;
  width: number;
  height: number;
  children: ReactNode;
};

export function ChartFrame({
  caption,
  fallback,
  enough = true,
  className,
  width,
  height,
  children,
}: FrameProps) {
  return (
    <figure className={className}>
      {enough ? (
        <svg
          viewBox={`0 0 ${width} ${height}`}
          width="100%"
          height={height}
          role="img"
          aria-label={caption}
          /** The caption is the accessible name; the shapes inside are decoration. */
          focusable="false"
        >
          {children}
        </svg>
      ) : (
        (fallback ?? null)
      )}
      <figcaption className="mt-2 text-2xs text-text-subtle">{caption}</figcaption>
    </figure>
  );
}

/** Direction from the locale, so nobody has to remember to pass it. */
function useDirection(override?: Direction): Direction {
  const locale = useLocale();
  return override ?? getDir(locale as Locale);
}

/* ------------------------------------------------------------------ *
 * 1. DotStrip
 * ------------------------------------------------------------------ */

export type DotDatum = {
  /** A `--log-*` or `--chart-*` token name, e.g. `"log-period"`. Never a hex value. */
  token: string;
  /** 0..1. Flow intensity, or confidence, or nothing. */
  intensity?: number;
};

/**
 * One dot per day — Flo's one genuinely good visualisation, plus the thing theirs
 * cannot show. Their dots carry a category; ours also carry intensity, so a heavy
 * day and a spotting day are distinguishable at a glance.
 */
export function DotStrip({
  data,
  box,
  caption,
  direction,
  className,
}: {
  data: readonly DotDatum[];
  box: Box;
  caption: string;
  direction?: Direction;
  className?: string;
}) {
  const dir = useDirection(direction);
  const dots = dotStrip(data.length, box, dir);
  return (
    <ChartFrame caption={caption} width={box.width} height={box.height} className={className}>
      {dots.map((d) => {
        const datum = data[d.index];
        if (datum === undefined) return null;
        return (
          <circle
            key={d.index}
            cx={d.cx}
            cy={d.cy}
            r={d.r}
            fill={`var(--${datum.token})`}
            opacity={datum.intensity ?? 1}
          />
        );
      })}
    </ChartFrame>
  );
}

/* ------------------------------------------------------------------ *
 * 2. RangeBand
 * ------------------------------------------------------------------ */

export function RangeBand({
  startIndex,
  endIndex,
  total,
  box,
  caption,
  token = "chart-1",
  direction,
  className,
}: {
  startIndex: number;
  endIndex: number;
  total: number;
  box: Box;
  caption: string;
  token?: string;
  direction?: Direction;
  className?: string;
}) {
  const dir = useDirection(direction);
  const band = rangeBand(startIndex, endIndex, total, box, dir);
  return (
    <ChartFrame caption={caption} width={box.width} height={box.height} className={className}>
      {band === null ? null : (
        <rect
          x={band.x}
          y={band.y}
          width={band.width}
          height={band.height}
          rx={4}
          fill={`var(--${token})`}
          opacity={0.24}
        />
      )}
    </ChartFrame>
  );
}

/* ------------------------------------------------------------------ *
 * 3 & 6. TimeSeries and Sparkline
 * ------------------------------------------------------------------ */

export function TimeSeries({
  values,
  box,
  caption,
  token = "chart-1",
  showAxis = true,
  direction,
  className,
  notEnough,
}: {
  values: readonly (number | null)[];
  box: Box;
  caption: string;
  token?: string;
  showAxis?: boolean;
  direction?: Direction;
  className?: string;
  /** Shown instead of a line when two points would imply a trend that is not one. */
  notEnough?: ReactNode;
}) {
  const dir = useDirection(direction);
  const { segments, bounds } = timeSeries({ values, box, direction: dir });
  const real = values.filter((v) => v !== null).length;

  return (
    <ChartFrame
      caption={caption}
      width={box.width}
      height={box.height}
      className={className}
      enough={notEnough === undefined || real >= 3}
      fallback={notEnough}
    >
      {showAxis &&
        bounds.ticks.map((t) => {
          const area = box;
          const y =
            (area.padding?.top ?? 0) +
            (area.height - (area.padding?.top ?? 0) - (area.padding?.bottom ?? 0)) *
              (1 - (t - bounds.min) / Math.max(1e-9, bounds.max - bounds.min));
          return (
            <line
              key={t}
              x1={0}
              x2={box.width}
              y1={y}
              y2={y}
              stroke="var(--chart-grid)"
              strokeWidth="var(--stroke-1)"
            />
          );
        })}
      {segments.map((seg, i) => (
        <path
          key={i}
          d={polyline(seg)}
          fill="none"
          stroke={`var(--${token})`}
          strokeWidth="var(--stroke-2)"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
      ))}
    </ChartFrame>
  );
}

/** A time series with no axis and no room. Same geometry, smaller box. */
export function Sparkline(props: Omit<Parameters<typeof TimeSeries>[0], "showAxis">) {
  return <TimeSeries {...props} showAxis={false} />;
}

/* ------------------------------------------------------------------ *
 * 4. Histogram
 * ------------------------------------------------------------------ */

export function Histogram({
  counts,
  box,
  caption,
  token = "chart-2",
  direction,
  className,
}: {
  counts: readonly number[];
  box: Box;
  caption: string;
  token?: string;
  direction?: Direction;
  className?: string;
}) {
  const dir = useDirection(direction);
  const bars = histogram(counts, box, dir);
  return (
    <ChartFrame caption={caption} width={box.width} height={box.height} className={className}>
      {bars.map((b) => (
        <rect
          key={b.index}
          x={b.x}
          y={b.y}
          width={b.width}
          height={b.height}
          rx={2}
          fill={`var(--${token})`}
        />
      ))}
    </ChartFrame>
  );
}

/* ------------------------------------------------------------------ *
 * 5. RingProgress
 * ------------------------------------------------------------------ */

export function RingProgress({
  progress,
  box,
  caption,
  token = "chart-1",
  className,
}: {
  progress: number;
  box: Box;
  caption: string;
  token?: string;
  className?: string;
}) {
  const r = ringProgress(progress, box);
  return (
    <ChartFrame caption={caption} width={box.width} height={box.height} className={className}>
      <circle
        cx={r.cx}
        cy={r.cy}
        r={r.r}
        fill="none"
        stroke="var(--chart-inactive)"
        strokeWidth={r.strokeWidth}
      />
      <circle
        cx={r.cx}
        cy={r.cy}
        r={r.r}
        fill="none"
        stroke={`var(--${token})`}
        strokeWidth={r.strokeWidth}
        strokeLinecap="round"
        strokeDasharray={`${r.dash} ${r.circumference}`}
        /** Twelve o'clock, and the transition is what --motion-prediction is for. */
        transform={`rotate(-90 ${r.cx} ${r.cy})`}
        style={{ transition: "stroke-dasharray var(--motion-prediction)" }}
      />
    </ChartFrame>
  );
}

/* ------------------------------------------------------------------ *
 * 7. ConfidenceBand — ours alone
 * ------------------------------------------------------------------ */

/**
 * A prediction drawn with its uncertainty visible.
 *
 * No competitor in the teardown has one. Flo hedges in copy — "likely to start", "on
 * or around" — and draws a single dotted ring, because its model has nowhere to put
 * a width. Ours has `predictions.likely_*` beside `window_*` precisely so the two
 * tiers can be seen rather than described.
 */
export function ConfidenceBand({
  centre,
  lower,
  upper,
  box,
  caption,
  token = "chart-1",
  direction,
  className,
}: {
  centre: readonly (number | null)[];
  lower: readonly (number | null)[];
  upper: readonly (number | null)[];
  box: Box;
  caption: string;
  token?: string;
  direction?: Direction;
  className?: string;
}) {
  const dir = useDirection(direction);
  const { centreLine, area } = confidenceBand({ centre, lower, upper, box, direction: dir });
  return (
    <ChartFrame caption={caption} width={box.width} height={box.height} className={className}>
      {area === "" ? null : <path d={area} fill="var(--confidence-band)" stroke="none" />}
      {centreLine === "" ? null : (
        <path
          d={centreLine}
          fill="none"
          stroke={`var(--${token})`}
          strokeWidth="var(--stroke-2)"
          strokeLinecap="round"
        />
      )}
    </ChartFrame>
  );
}
