"use client";

import type { ReactNode } from "react";
import type { BandGeometry } from "@/lib/cycle/band";
import { cn } from "@/lib/utils";

/**
 * The dashboard hero (P1.28.2).
 *
 * One card carrying the answer she opened the app for, in the shape the mockups
 * specified in Phase 0.5 and nobody built: eyebrow → statement → prediction band
 * → uncertainty line. Replaces two flat cards of equal visual weight, which made
 * the reader do the ranking herself.
 *
 * The gradients are the `--gradient-hero-*` tokens, not the decorative
 * `--gradient-brand`/`--gradient-fertile` pair: every stop in a hero gradient is
 * AA-safe under white text, because this card carries small body copy.
 */
export type HeroTone = "cycle" | "ttc" | "warm";

const TONE_CLASS: Record<HeroTone, string> = {
  cycle: "bg-gradient-hero-cycle",
  ttc: "bg-gradient-hero-ttc",
  warm: "bg-gradient-hero-warm",
};

export function HeroCard({
  tone,
  eyebrow,
  headline,
  footnote,
  band,
  children,
}: {
  tone: HeroTone;
  eyebrow: string;
  headline: string;
  /** The uncertainty line — confidence, or why the window is wide. */
  footnote?: string;
  band?: BandGeometry | null;
  children?: ReactNode;
}) {
  return (
    <section
      className={cn(
        "flex flex-col gap-3 rounded-lg p-6 text-text-on-brand shadow-md",
        TONE_CLASS[tone],
      )}
    >
      <p className="text-2xs font-semibold uppercase tracking-wider opacity-90">{eyebrow}</p>
      <h2 className="font-display text-lg leading-snug">{headline}</h2>
      {band ? <PredictionBand band={band} /> : null}
      {footnote ? <p className="text-2xs opacity-90">{footnote}</p> : null}
      {children}
    </section>
  );
}

/**
 * The band is decorative *reinforcement*: every fact it draws is already stated in
 * the headline and footnote above it, so it is `aria-hidden` rather than given an
 * ARIA role that would read out as noise.
 *
 * Positioned with logical inline offsets so it mirrors correctly in Arabic without
 * a second code path (product rule 6).
 */
function PredictionBand({ band }: { band: BandGeometry }) {
  const width = Math.max(band.windowEndPct - band.windowStartPct, 2);
  return (
    <div className="relative h-2 w-full rounded-pill" aria-hidden>
      <div className="absolute inset-0 rounded-pill bg-current opacity-25" />
      {/* Fading edges, not hard ones: the window has soft boundaries and the
          drawing should not claim otherwise. */}
      <div
        className="absolute inset-y-0 rounded-pill bg-[linear-gradient(90deg,transparent_0%,currentColor_35%,currentColor_65%,transparent_100%)]"
        style={{ insetInlineStart: `${band.windowStartPct}%`, width: `${width}%` }}
      />
      <div
        className="absolute inset-y-[-3px] w-[3px] rounded-pill bg-current shadow-sm"
        style={{ insetInlineStart: `${band.todayPct}%`, marginInlineStart: "-1.5px" }}
      />
    </div>
  );
}
