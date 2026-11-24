"use client";

import { useState } from "react";
import { AlertTriangle } from "lucide-react";
import { useTranslations } from "next-intl";
import { DUE_DATE_LOOKAHEAD_DAYS } from "@/lib/calculators";
import { localTodayISO, type Band } from "@/lib/calendar/grid";
import { eddFromLmp } from "@/lib/pregnancy";
import { pregnancyCalendar, type PregnancyWeekRow } from "@/lib/pregnancy/calendar";
import { Link } from "@/i18n/navigation";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { CalendarLegend } from "@/components/calendar/calendar-legend";
import { CalendarPicker, EMPTY_SELECTION, type PickerSelection } from "@/components/calendar/calendar-picker";
import { chipVariants } from "@/components/ui/chip";
import { cn } from "@/lib/utils";
import { CalculatorCard, ResultSentence, RuleLine } from "./calculator-card";
import { useCalculatorFormat } from "./use-calculator-format";

type Anchor = "edd" | "lmp";

/**
 * The pregnancy week-by-week calendar (MR-53). She taps her due date (or her last
 * period); every week from 4 to 41 is listed with its dates, grouped by trimester,
 * with the week's reviewed guide. The current week is marked only when today falls in
 * it. The red-flag box (MR-29) sits under every pregnancy-week result.
 *
 * The rules result is the typed `PregnancyCalendar` from `lib/pregnancy/calendar`; a
 * later "AI view" (R10.1) reads that value, never this markup.
 */
export function PregnancyCalendarCalculator() {
  const t = useTranslations("calculators");
  const { long, range } = useCalculatorFormat();
  const [anchor, setAnchor] = useState<Anchor>("edd");
  const [selection, setSelection] = useState<PickerSelection>(EMPTY_SELECTION);
  const today = localTodayISO();

  const edd = selection.start ? (anchor === "edd" ? selection.start : eddFromLmp(selection.start)) : null;
  const calendar = edd ? pregnancyCalendar(edd, today) : null;

  const bands: Band[] = selection.start ? [{ id: "anchor", kind: "period", start: selection.start, end: selection.start }] : [];
  const marks = { periodDays: new Set<string>(selection.start ? [selection.start] : []), fertileDays: new Set<string>(), nextPeriodDays: new Set<string>(), ovulationDay: null };
  const sentence = calendar ? t("pregnancyCalendar.headline", { date: long(calendar.edd) }) : null;

  const pick = (next: Anchor) => {
    setAnchor(next);
    setSelection(EMPTY_SELECTION);
  };

  return (
    <CalculatorCard>
      <div className="flex flex-col gap-2">
        <p className="text-sm font-semibold text-text">{t("pregnancyCalendar.methodLabel")}</p>
        <div className="flex flex-wrap gap-2">
          {(["edd", "lmp"] as const).map((a) => (
            <button key={a} type="button" aria-pressed={anchor === a} onClick={() => pick(a)} className={chipVariants({ selected: anchor === a })}>
              {t(`pregnancyCalendar.method.${a}`)}
            </button>
          ))}
        </div>
      </div>

      <CalendarPicker
        key={anchor}
        mode="single"
        selection={selection}
        onChange={setSelection}
        bands={bands}
        marks={marks}
        resultEnd={null}
        prompt={anchor === "edd" ? t("pregnancyCalendar.promptEdd") : t("calendar.prompt")}
        resultSentence={sentence}
        futureDays={anchor === "edd" ? DUE_DATE_LOOKAHEAD_DAYS : 0}
      />

      {selection.start ? <CalendarLegend items={[{ key: "start", label: anchor === "edd" ? t("legend.due") : t("legend.lmp") }]} /> : null}

      {calendar ? (
        <ResultSentence
          eyebrow={t("pregnancyCalendar.eyebrow")}
          headline={t("pregnancyCalendar.headline", { date: long(calendar.edd) })}
          lines={[
            t("pregnancyCalendar.trimesterLine", { second: long(calendar.secondTrimester), third: long(calendar.thirdTrimester) }),
            t("dueDate.termWindowLabel", { start: long(calendar.termStart), end: long(calendar.termEnd) }),
          ]}
        >
          {([1, 2, 3] as const).map((n) => (
            <section key={n} aria-labelledby={`trimester-${n}`} className="flex flex-col gap-2 pt-2">
              <h2 id={`trimester-${n}`} className="font-display text-lg text-text">
                {t(n === 1 ? "termBar.first" : n === 2 ? "termBar.second" : "termBar.third")}
              </h2>
              <ol className="flex flex-col gap-2">
                {calendar.weeks
                  .filter((w) => w.trimester === n)
                  .map((w) => (
                    <WeekRow key={w.week} row={w} current={calendar.currentWeek === w.week} dates={range(w.start, w.end)} />
                  ))}
              </ol>
            </section>
          ))}
          <RuleLine>{t("rules.estimateNote")}</RuleLine>
          <RuleLine>{t("rules.clinicianAdjust")}</RuleLine>
          <Alert variant="danger" icon={<AlertTriangle className="size-5" />}>
            <AlertDescription>{t("rules.redFlag")}</AlertDescription>
          </Alert>
        </ResultSentence>
      ) : null}
    </CalculatorCard>
  );
}

/** One week: its number, its dates, and the week guide when one exists. */
function WeekRow({ row, current, dates }: { row: PregnancyWeekRow; current: boolean; dates: string }) {
  const t = useTranslations("calculators.pregnancyCalendar");
  return (
    <li
      aria-current={current ? "date" : undefined}
      className={cn(
        "flex flex-wrap items-center justify-between gap-x-4 gap-y-1 rounded-md border px-3 py-2",
        current ? "border-primary bg-primary-soft text-primary-soft-text" : "border-border bg-surface",
      )}
    >
      <span className="flex flex-col">
        <span className="text-sm font-semibold">
          {t("week", { week: row.week })}
          {current ? <span className="ms-2 rounded-pill bg-primary-solid px-2 py-0.5 text-2xs font-semibold text-primary-fg-solid">{t("current")}</span> : null}
        </span>
        <span className={cn("text-sm", current ? "" : "text-text-muted")}>
          <bdi>{dates}</bdi>
        </span>
      </span>
      {row.guide ? (
        <Link href={`/learn/${row.guide}`} className="text-sm font-semibold text-text-link underline-offset-4 hover:underline">
          {t("readGuide", { week: row.week })}
        </Link>
      ) : (
        <span className="text-sm text-text-subtle">{t("noGuide")}</span>
      )}
    </li>
  );
}
