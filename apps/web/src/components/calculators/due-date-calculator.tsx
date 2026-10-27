"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { DEFAULT_CYCLE_DAYS, estimateDueDate, gestationalAge, MAX_CYCLE, MIN_CYCLE } from "@/lib/calculators";
import { localTodayISO, type Band } from "@/lib/calendar/grid";
import { CalendarLegend } from "@/components/calendar/calendar-legend";
import { CalendarPicker, EMPTY_SELECTION, type PickerSelection } from "@/components/calendar/calendar-picker";
import { Stepper } from "@/components/calendar/stepper";
import { TermWindowBar } from "@/components/calendar/term-window-bar";
import { CalculatorCard, ResultSentence, RuleLine } from "./calculator-card";
import { useCalculatorFormat } from "./use-calculator-format";

/**
 * Due date with the 37w0d–42w0d window (MR-23, MR-24). She taps the first day of
 * her last period; the result is "around" a date plus the window most babies
 * arrive in, drawn on the term bar. Nothing fills toward the date.
 */
export function DueDateCalculator() {
  const t = useTranslations("calculators");
  const { long, range } = useCalculatorFormat();
  const [selection, setSelection] = useState<PickerSelection>(EMPTY_SELECTION);
  const [cycle, setCycle] = useState(DEFAULT_CYCLE_DAYS);
  const today = localTodayISO();

  const result = selection.start ? estimateDueDate(selection.start, cycle) : null;
  const now = selection.start ? gestationalAge(selection.start, today) : null;
  const overTerm = selection.start !== null && now === null;

  const bands: Band[] = [];
  const marks = { periodDays: new Set<string>([...(selection.start ? [selection.start] : [])]), fertileDays: new Set<string>(), nextPeriodDays: new Set<string>(), ovulationDay: null };
  if (selection.start) bands.push({ id: "lmp", kind: "period", start: selection.start, end: selection.start });

  const sentence = result ? t("dueDate.sentence", { date: long(result.edd), start: long(result.termStart), end: long(result.termEnd) }) : null;

  return (
    <CalculatorCard>
      <CalendarPicker mode="single" selection={selection} onChange={setSelection} bands={bands} marks={marks} resultEnd={null} prompt={t("calendar.prompt")} resultSentence={sentence} />

      {result && !overTerm ? (
        <ResultSentence eyebrow={t("dueDate.eddLabel")} headline={t("dueDate.around", { date: long(result.edd) })} lines={[t("dueDate.termWindowLabel", { start: long(result.termStart), end: long(result.termEnd) })]}>
          <TermWindowBar
            weeks={now ? now.totalDays / 7 : null}
            hereLabel={now ? t("termBar.here", { weeks: now.weeks, days: now.days }) : null}
            trimesterLabels={[t("termBar.first"), t("termBar.second"), t("termBar.third")]}
            termLabel={t("termBar.label", { range: range(result.termStart, result.termEnd) })}
          />
          <RuleLine>{t("rules.estimateNote")}</RuleLine>
          <RuleLine>{t("rules.clinicianAdjust")}</RuleLine>
        </ResultSentence>
      ) : null}

      {overTerm ? <p className="rounded-md bg-surface-sunken p-4 text-sm text-text">{t("rules.overTerm")}</p> : null}

      {selection.start ? <CalendarLegend items={[{ key: "start", label: t("legend.lmp") }]} /> : null}

      <div className="border-t border-border pt-4">
        <Stepper id="cycle" label={t("stepper.cycleLabel")} value={cycle} min={MIN_CYCLE} max={MAX_CYCLE} unit={t("stepper.daysUnit")} valueText={t("stepper.days", { count: cycle })} decrementLabel={t("stepper.shorterCycle")} incrementLabel={t("stepper.longerCycle")} onChange={setCycle} />
      </div>
    </CalculatorCard>
  );
}
