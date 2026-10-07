"use client";

import { useLocale, useTranslations } from "next-intl";
import { addDays, diffDays } from "@/lib/calculators/dates";

/**
 * A result drawn as the month she will live it (P2.6): period days, the fertile
 * window, ovulation, the day to test. The same picture a period app shows, so the
 * calculator reads as a preview of the app rather than a sentence with dates in it.
 *
 * It repeats what the text above it says, so it is hidden from assistive tech: a
 * screen reader gets the sentence, not 42 unlabelled numbers.
 */
export type DayMark = "period" | "periodMaybe" | "fertile" | "ovulation" | "test";

const STYLE: Record<DayMark, string> = {
  period: "bg-log-period-alt font-semibold text-log-period",
  periodMaybe: "border border-dashed border-log-period text-log-period",
  fertile: "bg-phase-ovulatory/25 text-text",
  ovulation: "bg-phase-ovulatory font-bold text-black/80",
  test: "bg-primary-solid font-semibold text-primary-fg-solid",
};

/** Saturday in Arabic (Saudi Arabia, Egypt), Monday in French and Spanish. */
const WEEK_START: Record<string, number> = { en: 0, ar: 6, fr: 1, es: 1 };
const MAX_MONTHS = 3;

function monthStart(iso: string): string {
  return `${iso.slice(0, 7)}-01`;
}
function nextMonth(iso: string): string {
  const d = new Date(`${iso}T00:00:00Z`);
  d.setUTCMonth(d.getUTCMonth() + 1, 1);
  return d.toISOString().slice(0, 10);
}

export function MiniCalendar({
  marks,
  from,
  to,
}: {
  marks: ReadonlyMap<string, DayMark>;
  from: string;
  to: string;
}) {
  const locale = useLocale();
  const t = useTranslations("calculators.calendar");
  const weekStart = WEEK_START[locale] ?? 0;

  const months: string[] = [];
  for (let m = monthStart(from); m <= to && months.length < MAX_MONTHS; m = nextMonth(m)) {
    months.push(m);
  }

  const weekday = new Intl.DateTimeFormat(locale, { weekday: "narrow", timeZone: "UTC" });
  // 2026-01-04 is a Sunday: day 0 of a week, whatever the locale.
  const headers = Array.from({ length: 7 }, (_, i) =>
    weekday.format(new Date(`${addDays("2026-01-04", (weekStart + i) % 7)}T00:00:00Z`)),
  );
  const monthName = new Intl.DateTimeFormat(locale, {
    month: "long",
    year: "numeric",
    timeZone: "UTC",
  });
  const used = new Set(marks.values());

  return (
    <div aria-hidden className="flex flex-col gap-4">
      <div className="grid gap-4 sm:grid-cols-2">
        {months.map((first) => {
          const lead = (new Date(`${first}T00:00:00Z`).getUTCDay() - weekStart + 7) % 7;
          const days = diffDays(first, nextMonth(first));
          return (
            <div key={first} className="rounded-lg border border-border bg-surface p-3">
              <p className="mb-2 text-center text-sm font-semibold text-text">
                {monthName.format(new Date(`${first}T00:00:00Z`))}
              </p>
              <div className="grid grid-cols-7 gap-1 text-center text-2xs">
                {headers.map((h, i) => (
                  <span key={i} className="pb-1 text-text-subtle">
                    {h}
                  </span>
                ))}
                {Array.from({ length: lead }, (_, i) => (
                  <span key={`lead-${i}`} />
                ))}
                {Array.from({ length: days }, (_, i) => {
                  const iso = addDays(first, i);
                  const mark = marks.get(iso);
                  return (
                    <span
                      key={iso}
                      className={`flex aspect-square items-center justify-center rounded-pill text-xs ${
                        mark ? STYLE[mark] : "text-text-muted"
                      }`}
                    >
                      {i + 1}
                    </span>
                  );
                })}
              </div>
            </div>
          );
        })}
      </div>
      <ul className="flex flex-wrap gap-x-4 gap-y-2 text-2xs text-text-muted">
        {(Object.keys(STYLE) as DayMark[])
          .filter((k) => used.has(k))
          .map((k) => (
            <li key={k} className="flex items-center gap-1.5">
              <span className={`size-3.5 rounded-pill ${STYLE[k]}`} />
              {t(k)}
            </li>
          ))}
      </ul>
    </div>
  );
}

/** Mark every day from `start` to `end` inclusive, without overwriting stronger marks. */
export function markRange(
  marks: Map<string, DayMark>,
  start: string,
  end: string,
  mark: DayMark,
): void {
  for (let d = start; d <= end; d = addDays(d, 1)) if (!marks.has(d)) marks.set(d, mark);
}
