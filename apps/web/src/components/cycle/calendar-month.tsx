"use client";

import { useFormatter, useTranslations } from "next-intl";

import { cn } from "@/lib/utils";
import type { DayState, FlowLevel } from "@/lib/cycle/day-states";

/**
 * The month grid (RB-C5, `docs/29_REBUILD/06` §2).
 *
 * Every fact it draws comes from `lib/cycle/day-states.ts`, which is tier-2 and
 * tested. This file owns *appearance only* — which is why precedence between
 * states lives here, in CSS, rather than in an enum in the data model where it
 * would be a rule nobody can see.
 *
 * ## The two probability tiers, drawn as two things
 *
 * Flo computes both — its string catalogue distinguishes "likely to start" from
 * "may start" — and renders them as one dotted ring. Femio renders a **firm** ring
 * for `likely` and a **soft** one for `possible`, from `predictions.likely_*`
 * versus `predictions.window_*`. Collapsing them throws away the honest half of
 * the answer on the surface she looks at most.
 *
 * ## RTL is load-bearing here, not cosmetic
 *
 * The grid mirrors, and so does the *meaning* of a run's ends: in Arabic the first
 * day of a period is on the **right**. That is why the caps use
 * `border-start-start-radius` / `border-end-end-radius` — the logical properties
 * flip with direction — rather than `rounded-l` / `rounded-r`, which would put the
 * opening cap on the wrong end of every Arabic period and look plausible while
 * doing it. `docs/29_REBUILD/06` §2 names this as the thing that ships broken if
 * nobody looks, so it is stated here too.
 *
 * ## What is deliberately absent
 *
 * Nothing marks a day "safe" or "infertile". The fertile band marks an estimate;
 * the absence of a band is not a claim, and product rule 1 keeps Femio out of
 * contraception entirely.
 */

/** Flow intensity → fill opacity. Size is not used: every cell is the same size. */
const FLOW_OPACITY: Record<FlowLevel, string> = {
  spotting: "opacity-30",
  light: "opacity-50",
  medium: "opacity-75",
  heavy: "opacity-100",
};

export function CalendarMonth({
  days,
  onSelect,
  selected,
}: {
  /** One entry per cell, already in grid order. */
  days: readonly DayState[];
  onSelect?: (date: string) => void;
  selected?: string | null;
}) {
  const t = useTranslations("calendar");
  const format = useFormatter();

  const dayNumber = (iso: string) => Number(iso.slice(8, 10));

  /**
   * One sentence per cell for a screen reader, because the visual encoding —
   * fill, ring, band, dot — is entirely unavailable to one. Built from the same
   * flags the pixels come from, so the two cannot disagree.
   */
  const describe = (d: DayState): string => {
    const parts: string[] = [
      format.dateTime(new Date(`${d.date}T00:00:00Z`), { dateStyle: "long", timeZone: "UTC" }),
    ];
    if (d.today) parts.push(t("a11y.today"));
    if (d.period) parts.push(t(`a11y.flow.${d.period.flow}`));
    if (d.runStart) parts.push(t("a11y.runStart"));
    if (d.runEnd) parts.push(t("a11y.runEnd"));
    if (d.predictedLikely) parts.push(t("a11y.likely"));
    else if (d.predictedPossible) parts.push(t("a11y.possible"));
    if (d.ovulation) parts.push(t("a11y.ovulation"));
    else if (d.fertile) parts.push(t("a11y.fertile"));
    if (d.hasLogs) parts.push(t("a11y.hasLogs"));
    return parts.join(". ");
  };

  return (
    <div role="grid" aria-label={t("gridLabel")} className="grid grid-cols-7 gap-y-1">
      {days.map((d) => (
        <div key={d.date} role="gridcell" className="relative">
          <button
            type="button"
            onClick={() => onSelect?.(d.date)}
            aria-label={describe(d)}
            aria-current={d.today ? "date" : undefined}
            aria-pressed={selected === d.date}
            // min-h-11 keeps every cell at the 44px touch target. A calendar is the
            // densest grid in the app and the easiest place to lose it.
            className="relative flex min-h-11 w-full flex-col items-center justify-center gap-0.5"
          >
            {/* Fertile band — beneath the numerals, edges feathered, spanning the
                cell so adjacent days read as one continuous band. */}
            {d.fertile ? (
              <span
                aria-hidden
                className={cn(
                  "pointer-events-none absolute inset-x-0 bottom-1 h-1.5 bg-confidence-band",
                  "[mask-image:linear-gradient(90deg,transparent,black_20%,black_80%,transparent)]",
                )}
              />
            ) : null}

            {/* Logged bleeding. The cap radii are logical, so they mirror in RTL. */}
            {d.period ? (
              <span
                aria-hidden
                className={cn(
                  "pointer-events-none absolute inset-y-1 inset-x-0 bg-log-period",
                  FLOW_OPACITY[d.period.flow],
                  d.runStart && "rounded-se-pill rounded-ss-pill",
                  d.runEnd && "rounded-ee-pill rounded-es-pill",
                )}
              />
            ) : null}

            {/* Prediction rings. Firm beats soft when a day carries both. */}
            {d.predictedLikely ? (
              <span
                aria-hidden
                className="pointer-events-none absolute inset-0.5 rounded-pill border-2 border-confidence-high"
              />
            ) : d.predictedPossible ? (
              <span
                aria-hidden
                className="pointer-events-none absolute inset-0.5 rounded-pill border border-dashed border-confidence-low"
              />
            ) : null}

            {/* Today — composable with everything above, so it is its own layer. */}
            {d.today ? (
              <span
                aria-hidden
                className="pointer-events-none absolute inset-0 rounded-pill ring-2 ring-text"
              />
            ) : null}

            <span
              className={cn(
                "relative text-sm",
                d.today ? "font-semibold text-text" : "text-text",
                // The heavy fill is dark enough that the numeral needs the paired `-alt`
                // tone rather than body text — C1 ships one per log colour for exactly this.
                d.period && d.period.flow === "heavy" && "text-log-period-alt",
              )}
            >
              {dayNumber(d.date)}
            </span>

            {/* Ovulation marker sits inside the band; the logs dot sits under the
                numeral. Both are small, and both are already in the label above. */}
            <span aria-hidden className="relative flex h-1.5 items-center gap-0.5">
              {d.ovulation ? (
                <span className="size-1.5 rounded-pill bg-confidence-high" />
              ) : null}
              {d.hasLogs ? <span className="size-1 rounded-pill bg-log-symptom" /> : null}
            </span>
          </button>
        </div>
      ))}
    </div>
  );
}
