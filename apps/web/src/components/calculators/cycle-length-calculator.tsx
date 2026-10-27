"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { cycleStats, REGULAR_CYCLE_MAX, REGULAR_CYCLE_MIN } from "@/lib/calculators";
import { addDays } from "@/lib/calculators/dates";
import type { Band } from "@/lib/calendar/grid";
import { Link } from "@/i18n/navigation";
import { CalendarLegend } from "@/components/calendar/calendar-legend";
import { CalendarPicker, EMPTY_SELECTION, type PickerSelection } from "@/components/calendar/calendar-picker";
import { CalculatorCard, ResultSentence, RuleLine } from "./calculator-card";

/**
 * Average cycle length and spread from period starts she taps on the calendar
 * (register §5 "Cycle length"; MR-09). The strip under the result shows one bar
 * per cycle, its length labelled; "varies" when the spread is over nine days,
 * never "abnormal".
 */
export function CycleLengthCalculator() {
  const t = useTranslations("calculators");
  const [selection, setSelection] = useState<PickerSelection>(EMPTY_SELECTION);

  const result = cycleStats(selection.starts);
  const sorted = [...selection.starts].sort();

  const bands: Band[] = [];
  for (let i = 1; i < sorted.length; i += 1) {
    bands.push({ id: `span-${i}`, kind: "cycleSpan", start: addDays(sorted[i - 1]!, 1), end: addDays(sorted[i]!, -1) });
  }
  const marks = { periodDays: new Set<string>(), fertileDays: new Set<string>(), nextPeriodDays: new Set<string>(), ovulationDay: null };
  const resultEnd = sorted.length >= 2 ? sorted.at(-1)! : null;

  const days = (n: number) => t("stepper.days", { count: n });
  const outside = result ? result.min < REGULAR_CYCLE_MIN || result.max > REGULAR_CYCLE_MAX : false;
  const sentence = result ? t("cycleLength.sentence", { average: result.averageLength, min: result.min, max: result.max }) : null;
  const longest = result ? Math.max(...result.lengths) : 1;

  return (
    <CalculatorCard>
      <CalendarPicker mode="multi" selection={selection} onChange={setSelection} bands={bands} marks={marks} resultEnd={resultEnd} prompt={t("cycleLength.prompt")} resultSentence={sentence} />

      {sorted.length === 1 ? <p className="text-sm text-text-muted">{t("calendar.needTwo")}</p> : null}

      {result ? (
        <ResultSentence eyebrow={t("cycleLength.averageLabel")} headline={days(result.averageLength)} lines={[t("cycleLength.rangeLine", { min: days(result.min), max: days(result.max) })]}>
          <ol className="flex flex-col gap-1" aria-label={t("cycleLength.stripLabel")}>
            {result.lengths.map((len, i) => (
              <li key={i} className="flex items-center gap-2 text-2xs text-text-muted">
                <span className="h-3 rounded-pill bg-primary-soft" style={{ width: `${(len / longest) * 100}%`, maxWidth: "70%" }} aria-hidden />
                <span className="tabular-nums">{days(len)}</span>
              </li>
            ))}
          </ol>
          <RuleLine>{result.regular && !outside ? t("cycleLength.regular") : t("cycleLength.varies")}</RuleLine>
          {!result.regular || outside ? (
            <p className="flex flex-wrap gap-x-3 text-sm">
              <Link href="/learn/irregular-cycles-and-timing" className="font-semibold text-text-link underline-offset-4 hover:underline">
                {t("cycleLength.irregularLink")}
              </Link>
              <Link href="/conditions/pcos" className="font-semibold text-text-link underline-offset-4 hover:underline">
                {t("cycleLength.pcosLink")}
              </Link>
            </p>
          ) : null}
        </ResultSentence>
      ) : null}

      {sorted.length > 0 ? <CalendarLegend items={[{ key: "start", label: t("legend.periodStart") }, ...(bands.length ? ([{ key: "cycleSpan", label: t("legend.cycleSpan") }] as const) : [])]} /> : null}
    </CalculatorCard>
  );
}
