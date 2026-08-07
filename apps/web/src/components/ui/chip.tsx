import { cva, type VariantProps } from "class-variance-authority";

/**
 * The selectable pill used by every logger (P1.28 cleanup).
 *
 * There were four hand-rolled copies of this class stack and they had already
 * drifted: a flow chip was bolder than a symptom chip, a period chip had no
 * surface fill, a severity chip hovered to a different token, and the pregnancy
 * chips were still 30px after the cycle chips were raised to 44px — so the mode
 * where someone may be tapping urgently had the worst control. The 44px fix had
 * to be landed twice. Once is the budget.
 *
 * Same shape as `buttonVariants` and `badgeVariants`, which is how this codebase
 * already expresses a variant surface.
 */
export const chipVariants = cva(
  [
    "inline-flex items-center justify-center rounded-pill border",
    // Press feedback and its easing live here, not at seven call sites. The
    // `motion-safe:` prefix is load-bearing: the global reduced-motion rule zeroes
    // transition-duration, which makes the scale instant rather than absent.
    "transition-[background-color,border-color,transform] duration-fast",
    "motion-safe:ease-spring motion-safe:active:scale-95",
  ].join(" "),
  {
    variants: {
      size: {
        /** Default: clears the 44px WCAG 2.2 touch minimum. */
        md: "min-h-11 px-4 text-sm",
        /** Secondary controls nested inside a selected chip (severity levels). */
        sm: "min-h-9 min-w-9 px-3 text-2xs",
      },
      /**
       * Unselected colour. `sameDay`/`emergency` carry the pregnancy urgency tiers
       * (P1.13d) — the only visual difference between loggers that earns its place.
       */
      tone: {
        default: "border-border bg-surface text-text hover:bg-surface-sunken",
        sameDay: "border-warning bg-warning-soft text-warning-text",
        emergency: "border-danger-border bg-danger-soft text-danger-text",
      },
      selected: {
        true: "border-primary bg-primary-soft font-medium text-primary-soft-text",
        false: "",
      },
    },
    // Selected always wins over the tone, so an urgent symptom that has been picked
    // reads as picked rather than as still-urgent-and-unhandled.
    compoundVariants: [{ selected: true, className: "border-primary bg-primary-soft" }],
    defaultVariants: { size: "md", tone: "default", selected: false },
  },
);

export type ChipProps = VariantProps<typeof chipVariants>;
