"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { DEFAULT_CYCLE_DAYS, IRREGULAR_SEED, MAX_CYCLE, MAX_PERIOD, MIN_CYCLE, MIN_PERIOD, periodForecast } from "@/lib/calculators";
import { addDays } from "@/lib/calculators/dates";
import { localTodayISO, type Band } from "@/lib/calendar/grid";
import { CalendarLegend } from "@/components/calendar/calendar-legend";
import { CalendarPicker, EMPTY_SELECTION, type PickerSelection } from "@/components/calendar/calendar-picker";
import { Stepper } from "@/components/calendar/stepper";
import { chipVariants } from "@/components/ui/chip";
import { CalculatorCard, ResultSentence, RuleLine } from "./calculator-card";
import { useCalculatorFormat } from "./use-calculator-format";

const setOf = (start: string, end: string) => {
  const out = new Set<string>();
  for (let d = start; d <= end; d = addDays(d, 1)) out.add(d);
  return out;
};

/**
 * The next three periods as ranges that widen (rule 3; register §5 "Period").
 * The range comes from her own shortest and longest cycle; "Irregular / not sure"
 * seeds the pair with the accepted 21–35 range and the result says "wide estimate".
 */
export function PeriodCalculator() {
  const t = useTranslations("calculators");
  const { range, day } = useCalculatorFormat();
  const [selection, setSelection] = useState<PickerSelection>(EMPTY_SELECTION);
  const [irregular, setIrregular] = useState(false);
  const [shortest, setShortest] = useState(DEFAULT_CYCLE_DAYS);
  const [longest, setLongest] = useState(DEFAULT_CYCLE_DAYS);
  const today = localTodayISO();

  const bounds = irregular ? { a: Math.min(shortest, longest), b: Math.max(shortest, longest) } : { a: shortest, b: shortest };
  const result = selection.start ? periodForecast(selection.start, bounds.a, bounds.b, selection.periodLength, 3) : null;

  const bands: Band[] = [];
  const marks = { periodDays: new Set<string>(), fertileDays: new Set<string>(), nextPeriodDays: new Set<string>(), ovulationDay: null };
  let resultEnd: string | null = null;
  if (selection.start && result) {
    const periodEnd = addDays(selection.start, selection.periodLength - 1);
    bands.push({ id: "period", kind: "period", start: selection.start, end: periodEnd });
    marks.periodDays = setOf(selection.start, periodEnd);
    result.forEach((p, i) => {
      const end = addDays(p.latest, selection.periodLength - 1);
      bands.push({ id: `next-${i}`, kind: "nextPeriod", start: p.earliest, end, softStart: true, softEnd: p.earliest !== p.latest, breathe: i === 0 });
      for (const d of setOf(p.earliest, end)) marks.nextPeriodDays.add(d);
      resultEnd = end;
    });
  }

  const startPassed = result !== null && result[0]!.latest < today;
  const lines = result ? result.map((p, i) => t("period.nextLine", { n: i + 1, when: p.earliest === p.latest ? day(p.earliest) : range(p.earliest, p.latest) })) : [];
  const sentence = result ? lines.join(". ") : null;

  const toggleIrregular = () => {
    const next = !irregular;
    setIrregular(next);
    if (next && shortest === longest) {
      setShortest(IRREGULAR_SEED.shortest);
      setLongest(IRREGULAR_SEED.longest);
    }
  };

  return (
    <CalculatorCard>
      <CalendarPicker mode="period" selection={selection} onChange={setSelection} bands={bands} marks={marks} resultEnd={resultEnd} prompt={t("calendar.prompt")} resultSentence={sentence} />

      {result ? (
        <ResultSentence
          eyebrow={t("period.eyebrow")}
          headline={result[0]!.earliest === result[0]!.latest ? day(result[0]!.earliest) : range(result[0]!.earliest, result[0]!.latest)}
          lines={lines.slice(1)}
          confidence={irregular ? t("confidence.wide") : shortest !== DEFAULT_CYCLE_DAYS ? t("confidence.fair") : t("confidence.rough")}
          confidenceTone={irregular || shortest === DEFAULT_CYCLE_DAYS ? "low" : "medium"}
        >
          <RuleLine>{t("period.resultNote")}</RuleLine>
          {startPassed ? <RuleLine>{t("rules.testFirst")}</RuleLine> : null}
        </ResultSentence>
      ) : null}

      {result ? (
        <CalendarLegend
          items={[
            { key: "start", label: t("legend.start") },
            { key: "period", label: t("legend.period") },
            { key: "nextPeriod", label: t("legend.nextPeriod") },
          ]}
        />
      ) : null}

      <div className="flex flex-col gap-4 border-t border-border pt-4">
        {irregular ? (
          <>
            <Stepper id="shortest" label={t("stepper.shortestLabel")} value={shortest} min={MIN_CYCLE} max={MAX_CYCLE} unit={t("stepper.daysUnit")} valueText={t("stepper.days", { count: shortest })} decrementLabel={t("stepper.shorterCycle")} incrementLabel={t("stepper.longerCycle")} onChange={setShortest} />
            <Stepper id="longest" label={t("stepper.longestLabel")} value={longest} min={MIN_CYCLE} max={MAX_CYCLE} unit={t("stepper.daysUnit")} valueText={t("stepper.days", { count: longest })} decrementLabel={t("stepper.shorterCycle")} incrementLabel={t("stepper.longerCycle")} onChange={setLongest} />
          </>
        ) : (
          <Stepper id="cycle" label={t("stepper.cycleLabel")} value={shortest} min={MIN_CYCLE} max={MAX_CYCLE} unit={t("stepper.daysUnit")} valueText={t("stepper.days", { count: shortest })} decrementLabel={t("stepper.shorterCycle")} incrementLabel={t("stepper.longerCycle")} onChange={(v) => { setShortest(v); setLongest(v); }} />
        )}
        <div className="flex flex-wrap items-center gap-3">
          <button type="button" aria-pressed={irregular} onClick={toggleIrregular} className={chipVariants({ selected: irregular })}>
            {t("stepper.irregularChip")}
          </button>
          <span className="text-sm text-text-muted">{t("period.varyNote")}</span>
        </div>
        <Stepper id="period-length" label={t("stepper.periodLengthLabel")} value={selection.periodLength} min={MIN_PERIOD} max={MAX_PERIOD} unit={t("stepper.daysUnit")} valueText={t("stepper.days", { count: selection.periodLength })} decrementLabel={t("stepper.shorterPeriod")} incrementLabel={t("stepper.longerPeriod")} onChange={(periodLength) => setSelection({ ...selection, periodLength })} />
      </div>
    </CalculatorCard>
  );
}
