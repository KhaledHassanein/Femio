"use client";

import { useTranslations } from "next-intl";
import { cycleSegments, phaseOnDay, type CyclePhase } from "@/lib/cycle/phases";

/**
 * Where she is in her cycle, as a strip (ADR-066).
 *
 * Drafted as a ring, which is what every competitor draws — and `docs/25` §5a
 * rejects rings explicitly, because a ring implies a target and a completion and a
 * cycle is not a task you finish. §5a already prescribes the alternative, so this
 * is that: horizontal, phases as segments, a today marker, soft edges.
 *
 * The honesty rules are in `lib/cycle/phases.ts` where they can be tested, not in
 * this file where they would be decoration. This component's only job is to render
 * what it is given and to render "unknown" as visibly unknown:
 *
 * - `segments === []` (irregular, or a cycle too short to estimate) draws a plain
 *   track with a today marker and no phase colour at all. It does not fall back to
 *   a default phase, and it does not hide — "we cannot place you yet" is the
 *   answer, and she is entitled to see it.
 * - The ovulatory segment is a **window**, never a day, and is never labelled
 *   "fertile" here. Product rule 1 puts Femio out of contraception entirely.
 *
 * RTL: the strip is a flex row of segments, so it mirrors with `dir` and needs no
 * logical-property work of its own. The today marker is positioned with
 * `insetInlineStart`, not `left`.
 */

const PHASE_BG: Record<CyclePhase, string> = {
  menstrual: "bg-phase-menstrual",
  follicular: "bg-phase-follicular",
  ovulatory: "bg-phase-ovulatory",
  luteal: "bg-phase-luteal",
};

type Props = {
  /** 1-based day of the current cycle, or null before she has logged enough. */
  cycleDay: number | null;
  cycleLength: number;
  periodLength?: number;
  irregular?: boolean;
};

export function PhaseStrip({ cycleDay, cycleLength, periodLength, irregular = false }: Props) {
  const t = useTranslations("phaseStrip");
  const segments = cycleSegments({ cycleLength, periodLength, irregular });
  const known = segments.length > 0;

  const currentPhase =
    cycleDay == null
      ? null
      : phaseOnDay({ cycleDay, cycleLength, periodLength, irregular });

  // Clamped so a late cycle keeps the marker on the strip instead of pushing it
  // past the end. Being late is ordinary and must never read as off-the-scale.
  const markerPct =
    cycleDay != null && cycleLength > 0
      ? Math.min(100, Math.max(0, ((cycleDay - 0.5) / cycleLength) * 100))
      : null;

  const summary =
    cycleDay == null
      ? t("a11y.noData")
      : known
        ? t("a11y.withPhase", { day: cycleDay, length: cycleLength })
        : t("a11y.unknownPhase", { day: cycleDay });

  return (
    <div className="flex flex-col gap-2">
      <div className="flex items-baseline justify-between gap-3">
        <p className="font-display text-lg text-text">
          {cycleDay != null ? t("day", { day: cycleDay }) : t("noDay")}
        </p>
        <p className="text-sm text-text-muted">
          {currentPhase ? t(`phase.${currentPhase}`) : t("phase.unknown")}
        </p>
      </div>

      <div className="relative" role="img" aria-label={summary}>
        {/* The track is also the whole strip when the phase is unknown. An
            uncoloured bar is the honest picture of "we cannot place you yet". */}
        <div className="flex h-3 w-full overflow-hidden rounded-pill bg-surface-sunken">
          {segments.map((seg) => (
            <div
              key={`${seg.phase}-${seg.startDay}`}
              className={PHASE_BG[seg.phase]}
              style={{ width: `${((seg.endDay - seg.startDay + 1) / cycleLength) * 100}%` }}
            />
          ))}
        </div>

        {markerPct != null ? (
          <span
            aria-hidden
            className="absolute top-1/2 size-3.5 -translate-y-1/2 rounded-pill border-2 border-text bg-surface"
            // `insetInlineStart` rather than `left`: docs/22 requires logical
            // properties, and under RTL the marker must travel from the other end.
            style={{ insetInlineStart: `calc(${markerPct}% - 7px)` }}
          />
        ) : null}
      </div>

      <p className="text-2xs text-text-muted">
        {known ? t("typicalFor", { length: cycleLength }) : t("learning")}
      </p>
    </div>
  );
}
