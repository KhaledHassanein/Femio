"use client";

import type { ReactNode } from "react";
import type { BandGeometry } from "@/lib/ui/range-band";
import { cn } from "@/lib/utils";

/**
 * The hero card (P1.28.2) — the one thing a screen leads with.
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
/**
 * A palette choice, not a life stage. The first version used `cycle | ttc | warm`
 * and menopause had to pass `tone="brand"` — a menopause hero labelled "cycle" in
 * the source, and a type that would need a new member for every one of the ~73
 * personas in docs/08. These name the gradient family instead, so the caller picks
 * a colour and the component stays out of the taxonomy.
 */
export type HeroTone = "brand" | "fertile" | "warm";

const TONE_CLASS: Record<HeroTone, string> = {
  brand: "bg-gradient-hero-cycle",
  fertile: "bg-gradient-hero-ttc",
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
        "hero-glow flex flex-col gap-3 rounded-lg p-6 text-text-on-brand shadow-md",
        TONE_CLASS[tone],
      )}
    >
      <p className="text-2xs font-semibold uppercase tracking-wider opacity-90">{eyebrow}</p>
      <h2 className="font-display text-lg leading-snug">{headline}</h2>
      {band ? <PredictionBand band={band} /> : null}
      {children}
      {/* Last, always: the uncertainty line qualifies everything above it. */}
      {footnote ? <p className="text-2xs opacity-90">{footnote}</p> : null}
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
        // `band-breathe` (v3 P1.3): the window's glow swells and settles, slowly.
        // It is the one moving thing on the card because it is the one uncertain
        // thing; a fixed date would sit still. Stops under reduced motion.
        className="band-breathe absolute inset-y-0 rounded-pill bg-[linear-gradient(90deg,transparent_0%,currentColor_35%,currentColor_65%,transparent_100%)]"
        style={{ insetInlineStart: `${band.windowStartPct}%`, width: `${width}%` }}
      />
      <div
        className="absolute inset-y-[-3px] w-[3px] rounded-pill bg-current shadow-sm"
        style={{ insetInlineStart: `${band.todayPct}%`, marginInlineStart: "-1.5px" }}
      />
    </div>
  );
}
