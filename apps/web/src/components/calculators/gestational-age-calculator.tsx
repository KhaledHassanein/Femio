"use client";

import { useState } from "react";
import { AlertTriangle } from "lucide-react";
import { useTranslations } from "next-intl";
import { estimateDueDate, gestationalAge, trimesterOf } from "@/lib/calculators";
import { localTodayISO, type Band } from "@/lib/calendar/grid";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { CalendarLegend } from "@/components/calendar/calendar-legend";
import { CalendarPicker, EMPTY_SELECTION, type PickerSelection } from "@/components/calendar/calendar-picker";
import { TermWindowBar } from "@/components/calendar/term-window-bar";
import { CalculatorCard, ResultSentence, RuleLine } from "./calculator-card";
import { useCalculatorFormat } from "./use-calculator-format";

/**
 * Weeks and days today, counted from the last period (MR-25, MR-26), with the
 * trimester and the term bar. An implausible date is refused with "check the
 * date". The red-flag box (MR-29) sits under every pregnancy-week result.
 */
export function GestationalAgeCalculator() {
  const t = useTranslations("calculators");
  const { long, range } = useCalculatorFormat();
  const [selection, setSelection] = useState<PickerSelection>(EMPTY_SELECTION);
  const today = localTodayISO();

  const result = selection.start ? gestationalAge(selection.start, today) : null;
  const due = selection.start ? estimateDueDate(selection.start) : null;
  const overTerm = selection.start !== null && result === null;

  const bands: Band[] = [];
  const marks = { periodDays: new Set<string>([...(selection.start ? [selection.start] : [])]), fertileDays: new Set<string>(), nextPeriodDays: new Set<string>(), ovulationDay: null };
  if (selection.start) bands.push({ id: "lmp", kind: "period", start: selection.start, end: selection.start });

  const sentence = result ? t("gestationalAge.sentence", { weeks: result.weeks, days: result.days, trimester: trimesterOf(result.weeks) }) : null;

  return (
    <CalculatorCard>
      <CalendarPicker mode="single" selection={selection} onChange={setSelection} bands={bands} marks={marks} resultEnd={null} prompt={t("calendar.prompt")} resultSentence={sentence} />

      {result && due ? (
        <ResultSentence eyebrow={t("gestationalAge.eyebrow")} headline={t("gestationalAge.resultLabel", { weeks: result.weeks, days: result.days })} lines={[t("gestationalAge.trimesterLine", { n: trimesterOf(result.weeks) }), t("dueDate.termWindowLabel", { start: long(due.termStart), end: long(due.termEnd) })]}>
          <TermWindowBar
            weeks={result.totalDays / 7}
            hereLabel={t("termBar.here", { weeks: result.weeks, days: result.days })}
            trimesterLabels={[t("termBar.first"), t("termBar.second"), t("termBar.third")]}
            termLabel={t("termBar.label", { range: range(due.termStart, due.termEnd) })}
          />
          <RuleLine>{t("rules.estimateNote")}</RuleLine>
          <Alert variant="danger" icon={<AlertTriangle className="size-5" />}>
            <AlertDescription>{t("rules.redFlag")}</AlertDescription>
          </Alert>
        </ResultSentence>
      ) : null}

      {overTerm ? <p className="rounded-md bg-surface-sunken p-4 text-sm text-text">{t("rules.overTerm")}</p> : null}

      {selection.start ? <CalendarLegend items={[{ key: "start", label: t("legend.lmp") }]} /> : null}
    </CalculatorCard>
  );
}
