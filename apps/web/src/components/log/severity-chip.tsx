"use client";

import { useTranslations } from "next-intl";

import { cn } from "@/lib/utils";

/**
 * A trackable, and — once selected — how strongly (RB-C6, `docs/29_REBUILD/06` §3).
 *
 * ## Why severity is worth the trouble
 *
 * `symptom_logs.severity` is 0–4 and `lib/patterns` already reads it for trend.
 * Flo logs presence only, which is exactly why its patterns can say a symptom
 * recurred and never that it got **worse**. Ours can, and that difference lives or
 * dies on whether this control collects severity without being annoying.
 *
 * ## The interaction, and the rule it obeys
 *
 * - **First tap selects.** Logging stays one tap, as it is everywhere else.
 * - **Tapping an already-selected chip cycles the level**, 1 → 2 → 3 → 4 → 1.
 * - **Long-press opens the scale directly**, for someone who knows they want a 4.
 * - **Tapping "off" is a separate control**, not a fifth cycle step, because
 *   hiding removal inside a rotation means a mis-tap silently deletes an entry.
 *
 * The invariant that matters: **severity is never required.** A term that carries
 * `severityScale: false` is presence-only, and a selected chip that has never been
 * cycled logs `severity: null` rather than a default. A default here would be
 * Femio inventing a number and then feeding it to a trend — the same class of
 * error as an average built from a gap.
 */

/** 1–4, matching `symptom_logs.severity`. `null` is selected-without-a-level. */
export type Severity = 1 | 2 | 3 | 4;

export type Tone = "symptom" | "mood" | "discharge" | "vital" | "intercourse";

/**
 * Tint per dimension, written out rather than built as `bg-log-${tone}`.
 *
 * Tailwind's JIT scans source text for complete class names — a template literal
 * produces nothing, with no error and no warning, which is the failure mode
 * `STATE.md` records as costing a session: *a utility with no theme entry emits
 * nothing, silently.* Interpolation is the same trap by a different route, and it
 * looks even more correct in review.
 */
const TONE_CLASS: Record<Tone, string> = {
  symptom: "bg-log-symptom text-log-symptom-alt",
  mood: "bg-log-mood text-log-mood-alt",
  discharge: "bg-log-discharge text-log-discharge-alt",
  vital: "bg-log-vital text-log-vital-alt",
  intercourse: "bg-log-intercourse text-log-intercourse-alt",
};

const LEVEL_CLASS: Record<Severity, string> = {
  1: "opacity-40",
  2: "opacity-60",
  3: "opacity-80",
  4: "opacity-100",
};

export function SeverityChip({
  label,
  selected,
  severity,
  supportsSeverity,
  tone = "symptom",
  onToggle,
  onCycle,
}: {
  label: string;
  selected: boolean;
  severity: Severity | null;
  /** From `LogTerm.severityScale`. Presence-only terms never cycle. */
  supportsSeverity: boolean;
  /** Which `--log-*` family tints it. */
  tone?: Tone;
  onToggle: () => void;
  onCycle: () => void;
}) {
  const t = useTranslations("log");

  /**
   * One label carrying state, because a screen-reader user gets none of the tint
   * or the fill. `aria-pressed` says selected; this says *how strongly*, which is
   * the part the visual encoding alone would hide.
   */
  const describe = () => {
    if (!selected) return label;
    if (!supportsSeverity || severity === null) return `${label}. ${t("a11y.logged")}`;
    return `${label}. ${t(`a11y.severity.${severity}`)}. ${t("a11y.cycleHint")}`;
  };

  return (
    <button
      type="button"
      aria-pressed={selected}
      aria-label={describe()}
      onClick={() => (selected && supportsSeverity ? onCycle() : onToggle())}
      // Long-press is an accelerator, never the only route: everything it reaches
      // is reachable by tapping, so a user who cannot press-and-hold loses nothing.
      onContextMenu={(e) => {
        if (!selected || !supportsSeverity) return;
        e.preventDefault();
        onCycle();
      }}
      className={cn(
        "relative inline-flex min-h-11 items-center gap-2 rounded-pill border px-4 text-sm",
        "transition-[background-color,border-color] duration-quick ease-standard",
        selected
          ? cn("border-transparent", TONE_CLASS[tone])
          : "border-border bg-surface text-text hover:bg-surface-sunken",
        selected && supportsSeverity && severity !== null && LEVEL_CLASS[severity],
      )}
    >
      {label}
      {selected && supportsSeverity && severity !== null ? (
        <span
          aria-hidden
          className="inline-flex items-center gap-0.5"
          // The level, as marks rather than a numeral: it reads at a glance in a
          // dense grid of chips, and it needs no translation.
        >
          {[1, 2, 3, 4].map((n) => (
            <span
              key={n}
              className={cn(
                "size-1 rounded-pill bg-current",
                n <= severity ? "opacity-100" : "opacity-30",
              )}
            />
          ))}
        </span>
      ) : null}
    </button>
  );
}

/** Next level in the cycle. Exported so the screen and its tests agree. */
export function nextSeverity(current: Severity | null): Severity {
  if (current === null) return 1;
  return current === 4 ? 1 : ((current + 1) as Severity);
}
