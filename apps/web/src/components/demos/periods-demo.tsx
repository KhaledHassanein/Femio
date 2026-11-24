"use client";

/**
 * "Honest about how far ahead it can see" (R2.10): the app's next-periods rule (MR-51)
 * on three synthetic patterns.
 *
 * Why it exists: a range that widens, and a forecast that stops after one period when the
 * cycles vary, is femio's difference from a tracker that prints one date. Showing it on
 * sample data proves it without asking anyone for her dates. The server wrapper runs
 * `lib/demos/samples.ts` (the same shared rules the app runs) for every pattern and formats
 * every date, so this component only switches between finished views: server and browser
 * format date ranges with different spaces, and a range formatted twice would not hydrate.
 *
 * Drawn as a timeline of bands (never a ring, never a single date): a likely period is a
 * filled band, a low-confidence one is dashed, and each row says its range and confidence
 * in words, so colour is never the only channel.
 */
import { useState } from "react";

import { PERIOD_PATTERNS, type PeriodPattern } from "@/lib/demos/samples";
import { cn } from "@/lib/utils";

export type PeriodView = {
  /** The pattern's note and its last logged day, already in her language. */
  note: string;
  bars: { from: number; width: number; low: boolean }[];
  ticks: { at: number; label: string }[];
  rows: { range: string; confidence: string; low: boolean }[];
  /** "Each later period is wider" or "only the next one", whichever applies. */
  footer: string;
};

export type PeriodsDemoStrings = {
  patternsLabel: string;
  patterns: Record<PeriodPattern, string>;
  caption: string;
  title: string;
};

export function PeriodsDemo({ strings, views }: { strings: PeriodsDemoStrings; views: Record<PeriodPattern, PeriodView> }) {
  const [pattern, setPattern] = useState<PeriodPattern>("regular");
  const view = views[pattern];

  return (
    <div className="flex flex-col gap-5">
      <div role="radiogroup" aria-label={strings.patternsLabel} className="flex flex-wrap gap-2">
        {PERIOD_PATTERNS.map((p) => (
          <button
            key={p}
            type="button"
            role="radio"
            aria-checked={p === pattern}
            onClick={() => setPattern(p)}
            className={cn(
              "min-h-11 rounded-pill border px-4 text-xs font-semibold transition-colors duration-fast",
              p === pattern
                ? "border-primary bg-primary-soft text-primary-soft-text"
                : "border-border bg-surface text-text hover:bg-surface-sunken",
            )}
          >
            {strings.patterns[p]}
          </button>
        ))}
      </div>

      <div className="rounded-lg border border-border bg-surface p-5 shadow-xs" aria-live="polite">
        <p className="text-2xs text-text-muted">{view.note}</p>

        {/* The timeline. Decorative: every band is said in words in the list below. */}
        <div className="relative mt-6 h-16" aria-hidden>
          <span className="absolute inset-x-0 top-7 h-px bg-border" />
          <span className="absolute start-0 top-5 size-5 -translate-x-1/2 rounded-round bg-log-period rtl:translate-x-1/2" />
          {view.ticks.map((tick) => (
            <span key={tick.label} className="absolute top-9 text-2xs text-text-subtle" style={{ insetInlineStart: `${tick.at}%` }}>
              <span className="absolute -top-3 block h-2 w-px bg-border" />
              {tick.label}
            </span>
          ))}
          {view.bars.map((bar, i) => (
            <span
              key={`${pattern}-${i}`}
              className={cn(
                "absolute top-5 h-4 min-w-6 rounded-pill motion-safe:animate-in motion-safe:zoom-in-95",
                bar.low ? "border-2 border-dashed border-prediction-band bg-prediction-band/15" : "bg-prediction-band/80",
              )}
              style={{ insetInlineStart: `${bar.from}%`, width: `${bar.width}%`, animationDelay: `${i * 120}ms` }}
            />
          ))}
        </div>

        <h3 className="mt-4 text-sm font-semibold text-text">{strings.title}</h3>
        <ul className="mt-2 flex flex-col divide-y divide-border">
          {view.rows.map((row, i) => (
            <li key={`${pattern}-row-${i}`} className="flex items-center gap-3 py-2.5">
              <span
                className={cn("size-4 shrink-0 rounded-round border-2 border-prediction-band", row.low && "border-dashed")}
                aria-hidden
              />
              <span className="flex-1 text-sm text-text">{row.range}</span>
              <span className="text-end text-2xs text-text-muted">{row.confidence}</span>
            </li>
          ))}
        </ul>
        <p className="mt-3 text-2xs leading-relaxed text-text-muted">{view.footer}</p>
      </div>
      <p className="text-2xs text-text-subtle">{strings.caption}</p>
    </div>
  );
}
