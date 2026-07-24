"use client";

import { useMemo, useState } from "react";
import { useLocale, useTranslations } from "next-intl";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { buildMonthGrid, weekStartForLocale, type Flow } from "@/lib/cycle/calendar";
import { cn } from "@/lib/utils";

type PeriodDay = { date: string; flow: Flow | null };

// Opacity ramp encodes flow intensity on the menstrual-phase colour. Intensity is
// ALSO stated in each cell's aria-label, so it never relies on colour alone.
const FLOW_OPACITY: Record<Flow, string> = {
  spotting: "opacity-40",
  light: "opacity-60",
  medium: "opacity-80",
  heavy: "opacity-100",
};

export function CycleCalendar({
  periods,
  windowStart,
  windowEnd,
  fertileStart,
  fertileEnd,
  ovulation,
  today,
}: {
  periods: PeriodDay[];
  windowStart: string | null;
  windowEnd: string | null;
  fertileStart: string | null;
  fertileEnd: string | null;
  ovulation: string | null;
  today: string;
}) {
  const locale = useLocale();
  const t = useTranslations("track");
  const tf = useTranslations("track.flow");

  const [{ year, month }, setYm] = useState(() => {
    const d = new Date(`${today}T00:00:00Z`);
    return { year: d.getUTCFullYear(), month: d.getUTCMonth() };
  });

  const weekStartsOn = weekStartForLocale(locale);
  const periodMap = useMemo(
    () => new Map<string, Flow | null>(periods.map((p) => [p.date, p.flow])),
    [periods],
  );
  const grid = useMemo(
    () =>
      buildMonthGrid(year, month, {
        periods: periodMap,
        windowStart,
        windowEnd,
        fertileStart,
        fertileEnd,
        ovulation,
        today,
        weekStartsOn,
      }),
    [year, month, periodMap, windowStart, windowEnd, fertileStart, fertileEnd, ovulation, today, weekStartsOn],
  );

  // Locale-aware labels.
  const monthTitle = useMemo(
    () =>
      new Intl.DateTimeFormat(locale, { month: "long", year: "numeric", timeZone: "UTC" }).format(
        new Date(Date.UTC(year, month, 1)),
      ),
    [locale, year, month],
  );
  const weekdays = useMemo(() => {
    const fmt = new Intl.DateTimeFormat(locale, { weekday: "short", timeZone: "UTC" });
    // 2024-01-07 is a Sunday; offset to the configured week start.
    return Array.from({ length: 7 }, (_, i) =>
      fmt.format(new Date(Date.UTC(2024, 0, 7 + ((weekStartsOn + i) % 7)))),
    );
  }, [locale, weekStartsOn]);
  const dayLabel = (iso: string) =>
    new Intl.DateTimeFormat(locale, { dateStyle: "long", timeZone: "UTC" }).format(
      new Date(`${iso}T00:00:00Z`),
    );

  const shift = (delta: number) => {
    const m = month + delta;
    setYm({ year: year + Math.floor(m / 12), month: ((m % 12) + 12) % 12 });
  };

  const cellLabel = (c: {
    iso: string;
    isPeriod: boolean;
    flow: Flow | null;
    isPredicted: boolean;
    isFertile: boolean;
    isOvulation: boolean;
  }) => {
    const parts = [dayLabel(c.iso)];
    if (c.isPeriod) parts.push(c.flow ? `${t("logHeading")} — ${tf(c.flow)}` : t("logHeading"));
    if (c.isOvulation) parts.push(t("calendar.legendOvulation"));
    else if (c.isFertile) parts.push(t("calendar.legendFertile"));
    if (c.isPredicted) parts.push(t("calendar.legendPredicted"));
    return parts.join(", ");
  };

  return (
    <section className="flex flex-col gap-3">
      <div className="flex items-center justify-between">
        <h2 className="text-md font-semibold text-text">{t("calendar.heading")}</h2>
        <div className="flex items-center gap-1">
          <button
            type="button"
            onClick={() => shift(-1)}
            aria-label={t("calendar.prevMonth")}
            className="rounded-sm p-1.5 text-text-muted hover:bg-surface-sunken focus-visible:outline-none"
          >
            <ChevronLeft className="size-5 rtl:-scale-x-100" aria-hidden />
          </button>
          <button
            type="button"
            onClick={() => shift(1)}
            aria-label={t("calendar.nextMonth")}
            className="rounded-sm p-1.5 text-text-muted hover:bg-surface-sunken focus-visible:outline-none"
          >
            <ChevronRight className="size-5 rtl:-scale-x-100" aria-hidden />
          </button>
        </div>
      </div>

      <table className="w-full border-separate border-spacing-1 text-center">
        <caption className="sr-only">{monthTitle}</caption>
        <thead>
          <tr>
            <th colSpan={7} className="pb-2 font-display text-lg font-normal text-text">
              {monthTitle}
            </th>
          </tr>
          <tr>
            {weekdays.map((w, i) => (
              <th key={i} scope="col" className="pb-1 text-2xs font-medium text-text-subtle">
                {w}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {grid.weeks.map((week, wi) => (
            <tr key={wi}>
              {week.map((c) => {
                const marked = c.isPeriod || c.isPredicted || c.isFertile || c.isOvulation;
                return (
                  <td key={c.iso} className="p-0">
                    <div
                      aria-label={marked ? cellLabel(c) : undefined}
                      className={cn(
                        "relative mx-auto flex aspect-square w-full max-w-10 flex-col items-center justify-center rounded-md text-sm",
                        c.inMonth ? "text-text" : "text-text-subtle",
                        // Background bands: predicted period (amber) and fertile window (teal).
                        c.isPredicted && "bg-prediction-band/25",
                        c.isFertile && !c.isPredicted && "bg-phase-follicular/15",
                        c.isOvulation && "ring-1 ring-phase-ovulatory",
                        c.isToday && "ring-2 ring-primary",
                      )}
                    >
                      <span>{c.day}</span>
                      {c.isPeriod ? (
                        <span
                          aria-hidden
                          className={cn(
                            "absolute bottom-1 size-1.5 rounded-full bg-phase-menstrual",
                            c.flow ? FLOW_OPACITY[c.flow] : "opacity-70",
                          )}
                        />
                      ) : c.isOvulation ? (
                        <span aria-hidden className="absolute bottom-1 size-1.5 rounded-full bg-phase-ovulatory" />
                      ) : c.isFertile ? (
                        <span aria-hidden className="absolute bottom-1 size-1.5 rounded-full bg-phase-follicular/70" />
                      ) : null}
                    </div>
                  </td>
                );
              })}
            </tr>
          ))}
        </tbody>
      </table>

      <div className="flex flex-wrap items-center gap-4 text-2xs text-text-muted">
        <span className="inline-flex items-center gap-1.5">
          <span aria-hidden className="size-1.5 rounded-full bg-phase-menstrual" />
          {t("calendar.legendPeriod")}
        </span>
        <span className="inline-flex items-center gap-1.5">
          <span aria-hidden className="size-3 rounded-sm bg-prediction-band/25" />
          {t("calendar.legendPredicted")}
        </span>
        {fertileStart ? (
          <>
            <span className="inline-flex items-center gap-1.5">
              <span aria-hidden className="size-3 rounded-sm bg-phase-follicular/15" />
              {t("calendar.legendFertile")}
            </span>
            <span className="inline-flex items-center gap-1.5">
              <span aria-hidden className="size-1.5 rounded-full bg-phase-ovulatory ring-1 ring-phase-ovulatory" />
              {t("calendar.legendOvulation")}
            </span>
          </>
        ) : null}
        <span className="inline-flex items-center gap-1.5">
          <span aria-hidden className="size-3 rounded-sm ring-2 ring-primary" />
          {t("calendar.legendToday")}
        </span>
      </div>

      {fertileStart ? (
        <p className="text-2xs text-text-subtle">{t("calendar.awarenessNote")}</p>
      ) : null}
    </section>
  );
}
