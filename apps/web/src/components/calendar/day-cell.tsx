"use client";

import { cn } from "@/lib/utils";

export type DayState = {
  iso: string;
  /** Day of month, Western digits. */
  number: number;
  /** Hijri day-of-month, or empty when not shown. */
  hijri: string;
  isToday: boolean;
  isSelectedStart: boolean;
  /** Inside the entered period (the solid band). */
  inPeriod: boolean;
  inFertile: boolean;
  inNextPeriod: boolean;
  hasOvulationDot: boolean;
  /** Outside the pickable range: still drawn, never tappable. */
  disabled: boolean;
  /** The full-sentence accessible name (02_DESIGN_SPEC §2.11). */
  label: string;
};

export type LongPressHandlers = {
  handlers: Record<string, (event: never) => void>;
  consumedByLongPress: () => boolean;
};

/**
 * One day of the grid: a `gridcell` holding one button, so the whole month is a
 * single tab stop (roving `tabindex`). The number's colour follows the band behind
 * it; the start day is a filled circle; today is a bar, never a ring.
 */
export function DayCell({
  day,
  focused,
  tall,
  onTap,
  onSetEnd,
  onFocusDay,
  longPress,
}: {
  day: DayState;
  focused: boolean;
  /** Arabic rows are 52px to fit the Hijri label; others 44px. */
  tall: boolean;
  onTap: (iso: string) => void;
  onSetEnd: (iso: string) => void;
  onFocusDay: (iso: string) => void;
  longPress: LongPressHandlers;
}) {
  const numberClass = day.isSelectedStart
    ? "text-accent-fg-solid"
    : day.inPeriod
      ? "font-semibold text-log-period"
      : day.inFertile
        ? "font-semibold text-success-text"
        : day.inNextPeriod
          ? "font-medium text-log-period"
          : day.disabled
            ? "text-text-subtle"
            : "text-text-muted";

  return (
    <div role="gridcell" aria-selected={day.isSelectedStart || undefined} className="relative">
      <button
        type="button"
        tabIndex={focused ? 0 : -1}
        aria-label={day.label}
        aria-disabled={day.disabled || undefined}
        aria-current={day.isToday ? "date" : undefined}
        data-iso={day.iso}
        onClick={() => {
          if (longPress.consumedByLongPress()) return;
          onTap(day.iso);
        }}
        onFocus={() => onFocusDay(day.iso)}
        onKeyDown={(event) => {
          if (event.key === "Enter" && event.shiftKey) {
            event.preventDefault();
            onSetEnd(day.iso);
          }
        }}
        {...(day.disabled ? {} : (longPress.handlers as React.ButtonHTMLAttributes<HTMLButtonElement>))}
        className={cn(
          "relative flex w-full flex-col items-center justify-center rounded-sm text-base leading-none",
          tall ? "h-[52px]" : "h-11",
          "transition-transform duration-instant motion-safe:active:scale-[0.98]",
          "focus-visible:outline-none focus-visible:ring-[3px] focus-visible:ring-primary/50",
          day.disabled ? "cursor-default" : "cursor-pointer",
        )}
      >
        {day.isSelectedStart ? (
          <span aria-hidden className="motion-safe:animate-start-pop absolute top-1/2 size-9 -translate-y-1/2 rounded-round bg-accent-solid" />
        ) : null}
        <span className={cn("relative", numberClass, day.isToday && "font-bold")}>{day.number}</span>
        {day.hijri ? (
          <span
            aria-hidden
            className={cn("relative mt-[2px] text-2xs leading-none", day.isSelectedStart ? "text-accent-fg-solid/90" : "text-text-subtle")}
          >
            {day.hijri}
          </span>
        ) : null}
        {day.isToday && !day.isSelectedStart ? (
          <span aria-hidden className="absolute bottom-1 h-[3px] w-4 rounded-pill bg-primary" />
        ) : null}
        {day.hasOvulationDot ? <span aria-hidden className="absolute bottom-1 size-2 rounded-round bg-phase-ovulatory" /> : null}
      </button>
    </div>
  );
}
