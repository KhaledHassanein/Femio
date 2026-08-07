"use client";

import { useEffect, useRef } from "react";
import { useFormatter } from "next-intl";
import { addDays } from "@/lib/calculators/dates";
import { cn } from "@/lib/utils";

/**
 * The day picker at the top of Track (P1.28.3).
 *
 * Logging used to mean scrolling to a `<input type="date">` in the middle of a
 * form. Almost every entry is for today or the last day or two, so those days get
 * a thumb-sized target and everything else keeps the date field underneath.
 *
 * Ends at today rather than centring on it: there is nothing to log in the future,
 * and a strip that scrolls both ways invites the attempt. Laid out in document
 * order and scrolled to its own end, so Arabic mirrors it without a second path.
 */
export function DateStrip({
  selected,
  today,
  markedDays,
  onSelect,
  label,
  days = 14,
}: {
  selected: string;
  today: string;
  /** Dates with a period already logged — a dot, not a colour-only signal. */
  markedDays: ReadonlySet<string>;
  onSelect: (iso: string) => void;
  label: string;
  days?: number;
}) {
  const format = useFormatter();
  const todayRef = useRef<HTMLButtonElement>(null);

  // Oldest first, today last.
  const dates = Array.from({ length: days }, (_, i) => addDays(today, i - (days - 1)));

  useEffect(() => {
    // `scrollIntoView` rather than arithmetic on `scrollLeft`: RTL browsers
    // disagree about whether that value starts at 0 or runs negative, and a first
    // version of this left the Arabic strip showing a fortnight ago. Aligning the
    // element itself is direction-agnostic, and `scroll-px-5` on the container
    // keeps today off the screen edge. `block: "nearest"` stops it moving the page.
    todayRef.current?.scrollIntoView({ inline: "end", block: "nearest" });
  }, []);

  const utc = (iso: string) => new Date(`${iso}T00:00:00Z`);

  return (
    <div
      role="radiogroup"
      aria-label={label}
      className="-mx-5 flex snap-x snap-mandatory scroll-px-5 gap-2 overflow-x-auto px-5 pb-1"
    >
      {dates.map((iso) => {
        const isSelected = iso === selected;
        const isToday = iso === today;
        return (
          <button
            key={iso}
            ref={isToday ? todayRef : undefined}
            type="button"
            onClick={() => onSelect(iso)}
            role="radio"
            aria-checked={isSelected}
            aria-label={format.dateTime(utc(iso), { dateStyle: "full", timeZone: "UTC" })}
            className={cn(
              // 48×64 keeps every day comfortably over the 44px touch minimum.
              "flex min-h-16 w-12 shrink-0 snap-end flex-col items-center justify-center gap-0.5",
              "rounded-md border text-2xs transition-colors duration-fast",
              "motion-safe:ease-spring motion-safe:active:scale-95",
              isSelected
                ? "border-primary bg-primary text-primary-fg"
                : "border-border bg-surface text-text-muted hover:bg-surface-sunken",
              !isSelected && isToday && "border-primary text-primary",
            )}
          >
            <span aria-hidden>
              {format.dateTime(utc(iso), { weekday: "narrow", timeZone: "UTC" })}
            </span>
            <span aria-hidden className="font-display text-sm">
              {format.dateTime(utc(iso), { day: "numeric", timeZone: "UTC" })}
            </span>
            <span
              aria-hidden
              className={cn(
                "size-1 rounded-round",
                markedDays.has(iso)
                  ? isSelected
                    ? "bg-primary-fg"
                    : "bg-phase-menstrual"
                  : "bg-transparent",
              )}
            />
          </button>
        );
      })}
    </div>
  );
}
