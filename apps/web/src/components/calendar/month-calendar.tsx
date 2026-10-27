"use client";

import { useId } from "react";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { useFormatter } from "next-intl";
import { addDays as addDaysISO, diffDays } from "@/lib/calculators/dates";
import { hijriDay, hijriMonthLine, monthGrid, shiftMonth, weekdayHeaderDates, type Band } from "@/lib/calendar/grid";
import { BandLayer } from "./band-layer";
import { DayCell, type DayState } from "./day-cell";
import { useLongPress } from "./use-long-press";

export type DayMarks = {
  start: string | null;
  periodDays: ReadonlySet<string>;
  fertileDays: ReadonlySet<string>;
  nextPeriodDays: ReadonlySet<string>;
  ovulationDay: string | null;
};

export type MonthLabels = {
  prevMonth: string;
  nextMonth: string;
  /** Builds the full accessible sentence for a day (§2.11). */
  dayLabel: (iso: string, state: Omit<DayState, "label" | "iso" | "number" | "hijri">) => string;
  /** Column header abbreviations for the weekday cells, in visual order. */
  weekdayAbbr: (iso: string) => string;
};

const NAV_BUTTON =
  "flex size-11 items-center justify-center rounded-pill text-text transition-colors hover:bg-surface-sunken focus-visible:outline-none focus-visible:ring-[3px] focus-visible:ring-primary/50";

/**
 * One month as a WAI-ARIA grid (02_DESIGN_SPEC §2.3, §2.9, §2.11).
 *
 * Built from `role="grid"` divs rather than a table because each row needs to be a
 * positioned box for the band layer behind it, which a `<tr>` cannot reliably be.
 * One tab stop for the whole grid; arrow keys follow the VISUAL direction, so in
 * Arabic ArrowLeft moves to the next day. Bands live in an `aria-hidden` layer; the
 * day buttons carry the words. Hijri is display only.
 */
export function MonthCalendar({
  monthISO,
  weekStart,
  dir,
  locale,
  showHijri,
  today,
  minISO,
  maxISO,
  marks,
  bands,
  focusedISO,
  onFocusDay,
  onTap,
  onSetEnd,
  onNavigate,
  showNav,
  labels,
}: {
  monthISO: string;
  weekStart: number;
  dir: "ltr" | "rtl";
  locale: string;
  showHijri: boolean;
  today: string;
  minISO: string;
  maxISO: string;
  marks: DayMarks;
  bands: readonly Band[];
  focusedISO: string;
  onFocusDay: (iso: string) => void;
  onTap: (iso: string) => void;
  onSetEnd: (iso: string) => void;
  /** Month navigation; only the first month of a stack shows the buttons. */
  onNavigate?: (delta: number) => void;
  showNav: boolean;
  labels: MonthLabels;
}) {
  const format = useFormatter();
  const titleId = useId();
  const grid = monthGrid(monthISO, weekStart);
  const lastDay = grid.weeks.flat().filter(Boolean).at(-1) as string;
  const title = format.dateTime(new Date(`${monthISO}T00:00:00Z`), { month: "long", year: "numeric", timeZone: "UTC" });
  const hijriLine = showHijri ? hijriMonthLine(monthISO, lastDay) : "";
  const headers = weekdayHeaderDates(weekStart);
  const weekdayFormat = new Intl.DateTimeFormat(locale, { weekday: locale.startsWith("ar") ? "short" : "narrow", timeZone: "UTC" });

  const longPress = useLongPress(() => {
    const active = document.activeElement as HTMLElement | null;
    const iso = active?.dataset.iso;
    if (iso) onSetEnd(iso);
  });

  const focusDay = (iso: string) => {
    onFocusDay(iso);
    requestAnimationFrame(() => {
      document.querySelector<HTMLButtonElement>(`button[data-iso="${iso}"]`)?.focus();
    });
  };

  const onKeyDown = (event: React.KeyboardEvent) => {
    const visualNext = dir === "rtl" ? "ArrowLeft" : "ArrowRight";
    const visualPrev = dir === "rtl" ? "ArrowRight" : "ArrowLeft";
    const weekOffset = (new Date(`${focusedISO}T00:00:00Z`).getUTCDay() - weekStart + 7) % 7;
    let target: string | null = null;
    switch (event.key) {
      case visualNext:
        target = addDaysISO(focusedISO, 1);
        break;
      case visualPrev:
        target = addDaysISO(focusedISO, -1);
        break;
      case "ArrowDown":
        target = addDaysISO(focusedISO, 7);
        break;
      case "ArrowUp":
        target = addDaysISO(focusedISO, -7);
        break;
      case "Home":
        target = addDaysISO(focusedISO, -weekOffset);
        break;
      case "End":
        target = addDaysISO(focusedISO, 6 - weekOffset);
        break;
      case "PageUp":
      case "PageDown": {
        const months = (event.key === "PageUp" ? -1 : 1) * (event.shiftKey ? 12 : 1);
        const shifted = shiftMonth(focusedISO, months);
        const dayNumber = Number(focusedISO.slice(8, 10));
        const lastOfTarget = diffDays(shifted, shiftMonth(shifted, 1));
        target = addDaysISO(shifted, Math.min(dayNumber, lastOfTarget) - 1);
        break;
      }
      default:
        return;
    }
    event.preventDefault();
    if (target < grid.month || target > lastDay) onNavigate?.(target < grid.month ? -1 : 1);
    focusDay(target);
  };

  return (
    <section className="flex flex-col gap-2" aria-labelledby={titleId}>
      <header className="flex items-center justify-between gap-2">
        {showNav ? (
          <button type="button" onClick={() => onNavigate?.(-1)} aria-label={labels.prevMonth} className={NAV_BUTTON}>
            <ChevronLeft className="size-5 rtl:-scale-x-100" aria-hidden />
          </button>
        ) : (
          <span className="size-11" aria-hidden />
        )}
        <div className="flex flex-col items-center">
          <h3 id={titleId} className="text-lg font-semibold text-text">
            {title}
          </h3>
          {hijriLine ? <p className="text-2xs text-text-subtle">{hijriLine}</p> : null}
        </div>
        {showNav ? (
          <button type="button" onClick={() => onNavigate?.(1)} aria-label={labels.nextMonth} className={NAV_BUTTON}>
            <ChevronRight className="size-5 rtl:-scale-x-100" aria-hidden />
          </button>
        ) : (
          <span className="size-11" aria-hidden />
        )}
      </header>

      <div role="grid" aria-labelledby={titleId} className="flex flex-col gap-[2px]" onKeyDown={onKeyDown}>
        <div role="row" className="grid grid-cols-7 gap-1">
          {headers.map((iso) => (
            <div key={iso} role="columnheader" aria-label={labels.weekdayAbbr(iso)} className="h-6 text-center text-2xs font-medium leading-6 text-text-subtle">
              {weekdayFormat.format(new Date(`${iso}T00:00:00Z`))}
            </div>
          ))}
        </div>
        {grid.weeks.map((week, rowIndex) => (
          <div key={rowIndex} role="row" className="relative">
            <BandLayer bands={bands} week={week} />
            <div className="relative grid grid-cols-7 gap-1">
              {week.map((iso, colIndex) =>
                iso ? (
                  <DayCell
                    key={iso}
                    day={dayState(iso)}
                    focused={iso === focusedISO}
                    tall={showHijri}
                    onTap={onTap}
                    onSetEnd={onSetEnd}
                    onFocusDay={onFocusDay}
                    longPress={longPress}
                  />
                ) : (
                  <div key={`pad-${rowIndex}-${colIndex}`} role="gridcell" aria-hidden />
                ),
              )}
            </div>
          </div>
        ))}
      </div>
    </section>
  );

  function dayState(iso: string): DayState {
    const state = {
      isToday: iso === today,
      isSelectedStart: iso === marks.start,
      inPeriod: marks.periodDays.has(iso),
      inFertile: marks.fertileDays.has(iso),
      inNextPeriod: marks.nextPeriodDays.has(iso),
      hasOvulationDot: iso === marks.ovulationDay,
      disabled: iso < minISO || iso > maxISO,
    };
    return {
      iso,
      number: Number(iso.slice(8, 10)),
      hijri: showHijri ? hijriDay(iso) : "",
      ...state,
      label: labels.dayLabel(iso, state),
    };
  }
}
