"use client";

import { useMemo, useState } from "react";
import { trackCalculatorUsed } from "@/lib/consent/calculator-used";
import { Info } from "lucide-react";
import { useFormatter, useLocale, useTranslations } from "next-intl";
import { addDays, diffDays } from "@/lib/calculators/dates";
import { CYCLE_LOOKBACK_DAYS, DEFAULT_PERIOD_DAYS, MAX_PERIOD, MIN_PERIOD, TERM_END_DAYS } from "@/lib/calculators";
import { localTodayISO, monthStart, monthsSpanning, recentMonths, shiftMonth, weekStartFor, type Band } from "@/lib/calendar/grid";
import { getDir, type Locale } from "@/i18n/routing";
import { MonthStrip } from "./month-strip";
import { MonthCalendar, type DayMarks, type MonthLabels } from "./month-calendar";

export type PickerMode = "period" | "single" | "multi";

export type PickerSelection = {
  /** The tapped start (period / single modes). */
  start: string | null;
  /** Period length in days (period mode). */
  periodLength: number;
  /** Period starts (multi mode), sorted. */
  starts: string[];
};

export const EMPTY_SELECTION: PickerSelection = { start: null, periodLength: DEFAULT_PERIOD_DAYS, starts: [] };

/** How many months a result may stack (02_DESIGN_SPEC §2.3). */
const MAX_MONTHS = 3;
const MAX_STARTS = 12;
/** Month chips shown above the pregnancy calendars (§2.3). */
const MONTH_STRIP_COUNT = 10;

/**
 * The calendar as the input (02_DESIGN_SPEC §2.2). Owns which month is shown,
 * the tap → start / second tap → end / long-press → end gestures, the inline
 * messages, the Clear button and the live region. The maths and the bands come
 * from the calculator that renders it; this component only knows dates.
 */
export function CalendarPicker({
  mode,
  selection,
  onChange,
  bands,
  marks,
  resultEnd,
  prompt,
  resultSentence,
}: {
  mode: PickerMode;
  selection: PickerSelection;
  onChange: (next: PickerSelection) => void;
  bands: readonly Band[];
  marks: Omit<DayMarks, "start">;
  /** Last day a result touches; the months up to it stack under the input month. */
  resultEnd: string | null;
  /** The prompt above the grid; the inline message replaces it while relevant. */
  prompt: string;
  /** Accessible summary of the result, announced once per change. */
  resultSentence: string | null;
}) {
  const locale = useLocale();
  // The language part decides direction, week start and the Hijri line; splitting
  // keeps this correct should the locale ever carry a region or extension.
  const language = locale.split("-")[0] as Locale;
  const t = useTranslations("calculators.calendar");
  const format = useFormatter();
  const dir = getDir(language);
  const weekStart = weekStartFor(locale);
  const showHijri = language === "ar";
  const today = localTodayISO();
  const lookback = mode === "single" ? TERM_END_DAYS : CYCLE_LOOKBACK_DAYS;
  const minISO = addDays(today, -lookback);
  const maxISO = today;

  const [viewMonth, setViewMonth] = useState(() => monthStart(selection.start ?? today));
  const [focusedISO, setFocusedISO] = useState(selection.start ?? today);
  const [message, setMessage] = useState<string | null>(null);

  // The month she is looking at is always shown; the months a result runs into
  // stack under it. A result that ends before the viewed month adds nothing.
  const months = useMemo(() => {
    if (!resultEnd || resultEnd < viewMonth) return [viewMonth];
    return monthsSpanning(viewMonth, resultEnd, MAX_MONTHS);
  }, [viewMonth, resultEnd]);

  const stripMonths = useMemo(() => (mode === "single" ? recentMonths(today, MONTH_STRIP_COUNT) : []), [mode, today]);

  const say = (text: string | null) => setMessage(text);

  const onTap = (iso: string) => {
    // ADR-075: counts that a calculator was used, once per page view. The slug comes
    // from the URL; the day she tapped never leaves this function.
    trackCalculatorUsed();
    if (iso > maxISO) return say(t("futureDay"));
    if (iso < minISO) return say(mode === "single" ? t("overTerm") : t("tooOld"));
    say(null);
    if (mode === "multi") {
      const has = selection.starts.includes(iso);
      const starts = has ? selection.starts.filter((d) => d !== iso) : [...selection.starts, iso].sort().slice(-MAX_STARTS);
      onChange({ ...selection, starts });
      return;
    }
    if (mode === "period" && selection.start) {
      const length = diffDays(selection.start, iso) + 1;
      if (length >= MIN_PERIOD && length <= MAX_PERIOD) {
        onChange({ ...selection, periodLength: length });
        return;
      }
      if (iso === selection.start) return;
    }
    onChange({ ...selection, start: iso });
    setViewMonth(monthStart(iso));
  };

  const onSetEnd = (iso: string) => {
    if (mode !== "period" || !selection.start) return;
    const length = diffDays(selection.start, iso) + 1;
    if (length >= MIN_PERIOD && length <= MAX_PERIOD) onChange({ ...selection, periodLength: length });
  };

  const clear = () => {
    onChange(EMPTY_SELECTION);
    say(t("cleared"));
  };

  const hasSelection = mode === "multi" ? selection.starts.length > 0 : selection.start !== null;

  const fmtDay = (iso: string) => format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "full", timeZone: "UTC" });
  const labels: MonthLabels = {
    prevMonth: t("prevMonth"),
    nextMonth: t("nextMonth"),
    weekdayAbbr: (iso) => format.dateTime(new Date(`${iso}T00:00:00Z`), { weekday: "long", timeZone: "UTC" }),
    dayLabel: (iso, s) => {
      const parts = [fmtDay(iso)];
      if (s.isToday) parts.push(t("aria.today"));
      if (s.isSelectedStart) parts.push(t("aria.start"));
      else if (s.inPeriod) parts.push(t("aria.period"));
      if (s.inFertile) parts.push(t("aria.fertile"));
      if (s.hasOvulationDot) parts.push(t("aria.ovulation"));
      if (s.inNextPeriod) parts.push(t("aria.nextPeriod"));
      if (mode === "multi" && selection.starts.includes(iso)) parts.push(t("aria.start"));
      return parts.join(", ");
    },
  };

  const allMarks: DayMarks = {
    ...marks,
    start: mode === "multi" ? null : selection.start,
    periodDays: mode === "multi" ? new Set(selection.starts) : marks.periodDays,
  };

  return (
    <div className="flex flex-col gap-3">
      <p className="text-base font-semibold text-text" aria-live="polite">
        {message ?? prompt}
      </p>
      {!message && !hasSelection ? <p className="-mt-2 text-sm text-text-muted">{t("promptHelp")}</p> : null}
      {message ? (
        <p className="-mt-2 flex items-start gap-2 text-sm text-warning-text">
          <Info className="mt-0.5 size-4 shrink-0" aria-hidden />
          <span>{t("promptHelp")}</span>
        </p>
      ) : null}

      {stripMonths.length > 0 ? <MonthStrip months={stripMonths} viewed={viewMonth} onSelect={setViewMonth} /> : null}

      <div className="flex flex-col gap-6 md:flex-row md:gap-4">
        {months.map((month, index) => (
          <div key={month} className="md:min-w-0 md:flex-1">
            <MonthCalendar
              monthISO={month}
              weekStart={weekStart}
              dir={dir}
              locale={locale}
              showHijri={showHijri}
              today={today}
              minISO={minISO}
              maxISO={maxISO}
              marks={allMarks}
              bands={bands}
              focusedISO={focusedISO}
              onFocusDay={setFocusedISO}
              onTap={onTap}
              onSetEnd={onSetEnd}
              onNavigate={(delta) => setViewMonth((m) => shiftMonth(m, delta))}
              showNav={index === 0}
              labels={labels}
            />
          </div>
        ))}
      </div>

      {showHijri ? <p className="text-2xs text-text-subtle">{t("hijriNote")}</p> : null}

      {hasSelection ? (
        <div className="flex justify-end">
          <button
            type="button"
            onClick={clear}
            className="h-11 rounded-pill px-3 text-sm font-semibold text-text-link transition-colors hover:bg-surface-sunken focus-visible:outline-none focus-visible:ring-[3px] focus-visible:ring-primary/50"
          >
            {t("clear")}
          </button>
        </div>
      ) : null}

      <p className="sr-only" aria-live="polite">
        {resultSentence ?? ""}
      </p>
      <noscript>
        <p className="text-sm text-text-muted">{t("noscript")}</p>
      </noscript>
    </div>
  );
}
