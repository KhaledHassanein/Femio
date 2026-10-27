"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { DEFAULT_CYCLE_DAYS, MAX_CYCLE, MIN_CYCLE, pregnancyTestFromPeriod, pregnancyTestFromSex } from "@/lib/calculators";
import { addDays } from "@/lib/calculators/dates";
import { daysInMonth, monthStart, type Band } from "@/lib/calendar/grid";
import { CalendarLegend } from "@/components/calendar/calendar-legend";
import { CalendarPicker, EMPTY_SELECTION, type PickerSelection } from "@/components/calendar/calendar-picker";
import { Stepper } from "@/components/calendar/stepper";
import { chipVariants } from "@/components/ui/chip";
import { CalculatorCard, ResultSentence, RuleLine } from "./calculator-card";
import { useCalculatorFormat } from "./use-calculator-format";

type Mode = "period" | "sex";

const setOf = (start: string, end: string) => {
  const out = new Set<string>();
  for (let d = start; d <= end; d = addDays(d, 1)) out.add(d);
  return out;
};

/**
 * When a home test is most reliable (MR-21, NHS): from the first day of a missed
 * period, or 21 days after unprotected sex when the period date is unknown. The
 * "test from" band runs from that day to the end of its month: it is an open
 * window, not a single day.
 */
export function PregnancyTestCalculator() {
  const t = useTranslations("calculators");
  const { day } = useCalculatorFormat();
  const [mode, setMode] = useState<Mode>("period");
  const [selection, setSelection] = useState<PickerSelection>(EMPTY_SELECTION);
  const [cycle, setCycle] = useState(DEFAULT_CYCLE_DAYS);

  const fromPeriod = mode === "period" && selection.start ? pregnancyTestFromPeriod(selection.start, cycle) : null;
  const fromSex = mode === "sex" && selection.start ? pregnancyTestFromSex(selection.start) : null;
  const testFrom = fromPeriod?.testFrom ?? fromSex?.testFrom ?? null;

  const bands: Band[] = [];
  const marks = { periodDays: new Set<string>(), fertileDays: new Set<string>(), nextPeriodDays: new Set<string>(), ovulationDay: null };
  let resultEnd: string | null = null;
  if (selection.start && testFrom) {
    if (mode === "period") {
      const periodEnd = addDays(selection.start, selection.periodLength - 1);
      bands.push({ id: "period", kind: "period", start: selection.start, end: periodEnd });
      marks.periodDays = setOf(selection.start, periodEnd);
    }
    const monthEnd = addDays(monthStart(testFrom), daysInMonth(testFrom) - 1);
    bands.push({ id: "test", kind: "testFrom", start: testFrom, end: monthEnd, softEnd: true, breathe: true });
    resultEnd = monthEnd;
  }

  const sentence = testFrom ? t("pregnancyTest.sentence", { date: day(testFrom) }) : null;

  return (
    <CalculatorCard>
      <div className="flex flex-col gap-2">
        <p className="text-sm font-semibold text-text">{t("pregnancyTest.modeLabel")}</p>
        <div className="flex flex-wrap gap-2">
          {(["period", "sex"] as const).map((m) => (
            <button
              key={m}
              type="button"
              aria-pressed={mode === m}
              onClick={() => {
                setMode(m);
                setSelection(EMPTY_SELECTION);
              }}
              className={chipVariants({ selected: mode === m })}
            >
              {t(m === "period" ? "pregnancyTest.modePeriod" : "pregnancyTest.modeSex")}
            </button>
          ))}
        </div>
      </div>

      <CalendarPicker
        mode={mode === "period" ? "period" : "single"}
        selection={selection}
        onChange={setSelection}
        bands={bands}
        marks={marks}
        resultEnd={resultEnd}
        prompt={mode === "period" ? t("calendar.prompt") : t("pregnancyTest.promptSex")}
        resultSentence={sentence}
      />

      {testFrom ? (
        <ResultSentence
          eyebrow={t("pregnancyTest.testFromLabel")}
          headline={day(testFrom)}
          lines={fromPeriod ? [t("pregnancyTest.expectedPeriodLine", { date: day(fromPeriod.expectedPeriod) })] : []}
        >
          <RuleLine>{t(fromPeriod ? "pregnancyTest.notePeriod" : "pregnancyTest.noteSex")}</RuleLine>
          <p className="text-2xs text-text-subtle">{t("pregnancyTest.source")}</p>
        </ResultSentence>
      ) : null}

      {testFrom ? (
        <CalendarLegend
          items={[
            { key: "start", label: mode === "period" ? t("legend.start") : t("legend.sexDay") },
            ...(mode === "period" ? ([{ key: "period", label: t("legend.period") }] as const) : []),
            { key: "testFrom", label: t("legend.testFrom") },
          ]}
        />
      ) : null}

      {mode === "period" ? (
        <div className="border-t border-border pt-4">
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
        </div>
      ) : null}
    </CalculatorCard>
  );
}
