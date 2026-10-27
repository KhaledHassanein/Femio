"use client";

import { AXIS_WEEKS, TERM_START_WEEKS, TRIMESTER_ENDS_WEEKS as TRIMESTER_ENDS } from "@/lib/calculators";

/**
 * The term-window bar (02_DESIGN_SPEC §2.7). An axis from 0 to 42 weeks with three
 * sunken trimester segments and the 37–42 week window as a soft, breathing band.
 * Nothing fills toward the due date: a pregnancy is not a progress bar. "You are
 * here" is a dot with a label, positioned with `inset-inline-start` so it mirrors.
 */
export function TermWindowBar({
  weeks,
  hereLabel,
  trimesterLabels,
  termLabel,
}: {
  /** Where she is, in weeks (fractional), or null when the bar is a reference only. */
  weeks: number | null;
  hereLabel: string | null;
  /** Three labels, first to third trimester. */
  trimesterLabels: readonly [string, string, string];
  /** Accessible description of the window. */
  termLabel: string;
}) {
  const pct = (w: number) => `${(Math.min(AXIS_WEEKS, Math.max(0, w)) / AXIS_WEEKS) * 100}%`;
  const here = weeks === null ? null : Math.min(AXIS_WEEKS, Math.max(0, weeks));
  return (
    <figure className="flex flex-col gap-2" aria-label={termLabel}>
      <div className="relative pt-6">
        {here !== null && hereLabel ? (
          <span
            className="absolute top-0 -translate-x-1/2 whitespace-nowrap text-sm font-semibold text-text rtl:translate-x-1/2"
            style={{ insetInlineStart: pct(here) }}
          >
            {hereLabel}
          </span>
        ) : null}
        <div aria-hidden className="relative flex h-3 w-full gap-[2px]">
          {TRIMESTER_ENDS.map((end, i) => {
            const start = i === 0 ? 0 : TRIMESTER_ENDS[i - 1]!;
            return <span key={end} className="h-3 rounded-pill bg-surface-sunken" style={{ width: `${((end - start) / AXIS_WEEKS) * 100}%` }} />;
          })}
          <span
            className="band-breathe band-soft-s band-soft-e absolute top-0 h-3 rounded-pill bg-prediction-band/60"
            style={{ insetInlineStart: pct(TERM_START_WEEKS), width: pct(AXIS_WEEKS - TERM_START_WEEKS), ["--breathe-scale" as string]: "1.25" }}
          />
          {here !== null ? (
            <span className="absolute top-1/2 size-3 -translate-x-1/2 -translate-y-1/2 rounded-round bg-primary ring-2 ring-bg rtl:translate-x-1/2" style={{ insetInlineStart: pct(here) }} />
          ) : null}
        </div>
      </div>
      <figcaption aria-hidden className="flex text-2xs text-text-muted">
        {TRIMESTER_ENDS.map((end, i) => {
          const start = i === 0 ? 0 : TRIMESTER_ENDS[i - 1]!;
          return (
            <span key={end} className="text-center" style={{ width: `${((end - start) / AXIS_WEEKS) * 100}%` }}>
              {trimesterLabels[i]}
            </span>
          );
        })}
      </figcaption>
    </figure>
  );
}
