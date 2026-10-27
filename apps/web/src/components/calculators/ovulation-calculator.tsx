"use client";

import { useState } from "react";
import { Info } from "lucide-react";
import { useTranslations } from "next-intl";
import {
  DEFAULT_CYCLE_DAYS,
  fertileWindow,
  isRegularCycleLength,
  MAX_CYCLE,
  MAX_PERIOD,
  MIN_CYCLE,
  MIN_PERIOD,
} from "@/lib/calculators";
import { addDays } from "@/lib/calculators/dates";
import type { Band } from "@/lib/calendar/grid";
import { Link } from "@/i18n/navigation";
import { CalendarLegend } from "@/components/calendar/calendar-legend";
import { CalendarPicker, EMPTY_SELECTION, type PickerSelection } from "@/components/calendar/calendar-picker";
import { Stepper } from "@/components/calendar/stepper";
import { CalculatorCard, ResultSentence, RuleLine } from "./calculator-card";
import { useCalculatorFormat } from "./use-calculator-format";

const setOf = (start: string, end: string) => {
  const out = new Set<string>();
  for (let d = start; d <= end; d = addDays(d, 1)) out.add(d);
  return out;
};

/**
 * Fertile window on the calendar (02_DESIGN_SPEC §2; register MR-06..09, MR-14, MR-15).
 *
 * She taps the first day of her last period; the window draws on the same grid.
 * Outside 21–35 days there is no window and no dot, only the "no confident window"
 * box: a day she cannot rely on is worse than no day.
 */
export function OvulationCalculator() {
  const t = useTranslations("calculators");
  const { range, day } = useCalculatorFormat();
  const [selection, setSelection] = useState<PickerSelection>(EMPTY_SELECTION);
  const [cycle, setCycle] = useState(DEFAULT_CYCLE_DAYS);
  const cycleTouched = cycle !== DEFAULT_CYCLE_DAYS;

  const result = selection.start ? fertileWindow(selection.start, cycle) : null;
  const regular = isRegularCycleLength(cycle);

  const bands: Band[] = [];
  const marks = { periodDays: new Set<string>(), fertileDays: new Set<string>(), nextPeriodDays: new Set<string>(), ovulationDay: null as string | null };
  let resultEnd: string | null = null;
  if (selection.start && result) {
    const periodEnd = addDays(selection.start, selection.periodLength - 1);
    bands.push({ id: "period", kind: "period", start: selection.start, end: periodEnd });
    marks.periodDays = setOf(selection.start, periodEnd);
    if (result.window) {
      bands.push({ id: "fertile", kind: "fertile", start: result.window.start, end: result.window.end, softStart: true, softEnd: true, breathe: true });
      marks.fertileDays = setOf(result.window.start, result.window.end);
      marks.ovulationDay = result.window.ovulation;
    }
    const nextEnd = addDays(result.nextPeriod, selection.periodLength - 1);
    bands.push({ id: "next", kind: "nextPeriod", start: result.nextPeriod, end: nextEnd, softStart: true });
    marks.nextPeriodDays = setOf(result.nextPeriod, nextEnd);
    resultEnd = nextEnd;
  }

  const sentence =
    result && result.window
      ? t("ovulation.sentence", { window: range(result.window.start, result.window.end), ovulation: day(result.window.ovulation), next: day(result.nextPeriod) })
      : result
        ? t("noWindow.title")
        : null;

  return (
    <CalculatorCard>
      <CalendarPicker
        mode="period"
        selection={selection}
        onChange={setSelection}
        bands={bands}
        marks={marks}
        resultEnd={resultEnd}
        prompt={t("calendar.prompt")}
        resultSentence={sentence}
      />

      {result?.window ? (
        <ResultSentence
          eyebrow={t("ovulation.windowLabel")}
          headline={range(result.window.start, result.window.end)}
          lines={[t("ovulation.ovulationAround", { date: day(result.window.ovulation) }), t("ovulation.nextPeriodAround", { date: day(result.nextPeriod) })]}
          confidence={cycleTouched ? t("confidence.fair") : t("confidence.rough")}
          confidenceTone={cycleTouched ? "medium" : "low"}
        >
          <RuleLine>{t("rules.predictions")}</RuleLine>
          <RuleLine>{t("rules.stripLine")}</RuleLine>
        </ResultSentence>
      ) : null}

      {result && !result.window ? (
        <div className="flex flex-col gap-2 rounded-md bg-surface-sunken p-4">
          <p className="flex items-start gap-2 text-base font-semibold text-text">
            <Info className="mt-0.5 size-5 shrink-0 text-primary" aria-hidden />
            <span>{t("noWindow.title")}</span>
          </p>
          <p className="text-sm text-text-muted">{t("noWindow.body")}</p>
          <p className="text-sm text-text-muted">{t("ovulation.nextPeriodAround", { date: day(result.nextPeriod) })}</p>
          <Link href="/learn/irregular-cycles-and-timing" className="text-sm font-semibold text-text-link underline-offset-4 hover:underline">
            {t("noWindow.link")}
          </Link>
          <RuleLine>{t("rules.soonerHelp")}</RuleLine>
          <RuleLine>{t("rules.predictions")}</RuleLine>
        </div>
      ) : null}

      {result ? (
        <CalendarLegend
          items={[
            { key: "start", label: t("legend.start") },
            { key: "period", label: t("legend.period") },
            ...(result.window ? ([{ key: "fertile", label: t("legend.fertile") }, { key: "ovulation", label: t("legend.ovulation") }] as const) : []),
            { key: "nextPeriod", label: t("legend.nextPeriod") },
          ]}
        />
      ) : null}

      <div className="flex flex-col gap-4 border-t border-border pt-4">
        <Stepper
          id="cycle"
          label={t("stepper.cycleLabel")}
          value={cycle}
          min={MIN_CYCLE}
          max={MAX_CYCLE}
          unit={t("stepper.daysUnit")}
          valueText={t("stepper.days", { count: cycle })}
          decrementLabel={t("stepper.shorterCycle")}
          incrementLabel={t("stepper.longerCycle")}
          onChange={setCycle}
        />
        {!regular ? <p className="text-sm text-text-muted">{t("stepper.outsideRegular")}</p> : null}
        <Stepper
          id="period-length"
          label={t("stepper.periodLengthLabel")}
          value={selection.periodLength}
          min={MIN_PERIOD}
          max={MAX_PERIOD}
          unit={t("stepper.daysUnit")}
          valueText={t("stepper.days", { count: selection.periodLength })}
          decrementLabel={t("stepper.shorterPeriod")}
          incrementLabel={t("stepper.longerPeriod")}
          onChange={(periodLength) => setSelection({ ...selection, periodLength })}
        />
      </div>
    </CalculatorCard>
  );
}
