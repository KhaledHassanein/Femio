"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import {
  DEFAULT_CYCLE_DAYS,
  estimateDueDateFrom,
  gestationalAge,
  MAX_CYCLE,
  MIN_CYCLE,
  SCAN_DEFAULT_WEEKS,
  SCAN_MAX_WEEKS,
  SCAN_MIN_WEEKS,
  type DueMethod,
} from "@/lib/calculators";
import { localTodayISO, type Band } from "@/lib/calendar/grid";
import { CalendarLegend } from "@/components/calendar/calendar-legend";
import { CalendarPicker, EMPTY_SELECTION, type PickerSelection } from "@/components/calendar/calendar-picker";
import { Stepper } from "@/components/calendar/stepper";
import { TermWindowBar } from "@/components/calendar/term-window-bar";
import { chipVariants } from "@/components/ui/chip";
import { CalculatorCard, ResultSentence, RuleLine } from "./calculator-card";
import { useCalculatorFormat } from "./use-calculator-format";

/** The four choices she sees; "transfer" opens the day-3 / day-5 choice (MR-23). */
type MethodChoice = "lmp" | "conception" | "transfer" | "scan";
const METHODS: readonly MethodChoice[] = ["lmp", "conception", "transfer", "scan"];
const LAST_SCAN_EXTRA_DAY = 6;

/**
 * Due date with the 37w0d–42w0d window (MR-23, MR-24, MR-53). She says how she knows
 * the date (last period, conception, IVF transfer or a dating scan), taps it, and the
 * result is "around" a date plus the window most babies arrive in, drawn on the term
 * bar. A scan's weeks and days are taken as written; nothing compares methods.
 *
 * The rules result is the typed `DueDateByMethod` from `lib/calculators`; a later
 * "AI view" (R10.1) reads that value, never this markup.
 */
export function DueDateCalculator() {
  const t = useTranslations("calculators");
  const { long, range } = useCalculatorFormat();
  const [selection, setSelection] = useState<PickerSelection>(EMPTY_SELECTION);
  const [choice, setChoice] = useState<MethodChoice>("lmp");
  const [embryoDays, setEmbryoDays] = useState<3 | 5>(5);
  const [cycle, setCycle] = useState(DEFAULT_CYCLE_DAYS);
  const [scanWeeks, setScanWeeks] = useState(SCAN_DEFAULT_WEEKS);
  const [scanDays, setScanDays] = useState(0);
  const today = localTodayISO();

  const method: DueMethod = choice === "transfer" ? (embryoDays === 3 ? "transfer3" : "transfer5") : choice;
  const result = selection.start ? estimateDueDateFrom(method, selection.start, { cycleLength: cycle, scanWeeks, scanDays }) : null;
  const now = result ? gestationalAge(result.lmp, today) : null;
  const overTerm = result !== null && now === null && today > result.lmp;

  const bands: Band[] = [];
  const marks = { periodDays: new Set<string>(selection.start ? [selection.start] : []), fertileDays: new Set<string>(), nextPeriodDays: new Set<string>(), ovulationDay: null };
  if (selection.start) bands.push({ id: "start", kind: "period", start: selection.start, end: selection.start });

  const sentence = result ? t("dueDate.sentence", { date: long(result.edd), start: long(result.termStart), end: long(result.termEnd) }) : null;
  const prompt = choice === "lmp" ? t("calendar.prompt") : t(`dueDate.prompt.${choice}`);
  const legend = choice === "lmp" ? t("legend.lmp") : t(`legend.${choice}`);

  const pick = (next: MethodChoice) => {
    setChoice(next);
    setSelection(EMPTY_SELECTION);
  };

  return (
    <CalculatorCard>
      <div className="flex flex-col gap-2">
        <p className="text-sm font-semibold text-text">{t("dueDate.methodLabel")}</p>
        <div className="flex flex-wrap gap-2">
          {METHODS.map((m) => (
            <button key={m} type="button" aria-pressed={choice === m} onClick={() => pick(m)} className={chipVariants({ selected: choice === m })}>
              {t(`dueDate.method.${m}`)}
            </button>
          ))}
        </div>
        {choice === "transfer" ? (
          <div className="flex flex-col gap-2 pt-2">
            <p className="text-sm font-semibold text-text">{t("dueDate.embryoLabel")}</p>
            <div className="flex flex-wrap gap-2">
              {([3, 5] as const).map((d) => (
                <button key={d} type="button" aria-pressed={embryoDays === d} onClick={() => setEmbryoDays(d)} className={chipVariants({ selected: embryoDays === d })}>
                  {t(d === 3 ? "dueDate.embryo.day3" : "dueDate.embryo.day5")}
                </button>
              ))}
            </div>
          </div>
        ) : null}
      </div>

      <CalendarPicker key={choice} mode="single" selection={selection} onChange={setSelection} bands={bands} marks={marks} resultEnd={null} prompt={prompt} resultSentence={sentence} />

      {result && !overTerm ? (
        <ResultSentence eyebrow={t("dueDate.eddLabel")} headline={t("dueDate.around", { date: long(result.edd) })} lines={[t("dueDate.termWindowLabel", { start: long(result.termStart), end: long(result.termEnd) })]}>
          <TermWindowBar
            weeks={now ? now.totalDays / 7 : null}
            hereLabel={now ? t("termBar.here", { weeks: now.weeks, days: now.days }) : null}
            trimesterLabels={[t("termBar.first"), t("termBar.second"), t("termBar.third")]}
            termLabel={t("termBar.label", { range: range(result.termStart, result.termEnd) })}
          />
          <RuleLine>{t("rules.estimateNote")}</RuleLine>
          <RuleLine>{choice === "scan" ? t("dueDate.scanNote") : t("rules.clinicianAdjust")}</RuleLine>
        </ResultSentence>
      ) : null}

      {overTerm ? <p className="rounded-md bg-surface-sunken p-4 text-sm text-text">{t("rules.overTerm")}</p> : null}

      {selection.start ? <CalendarLegend items={[{ key: "start", label: legend }]} /> : null}

      {choice === "lmp" ? (
        <div className="border-t border-border pt-4">
          <Stepper id="cycle" label={t("stepper.cycleLabel")} value={cycle} min={MIN_CYCLE} max={MAX_CYCLE} unit={t("stepper.daysUnit")} valueText={t("stepper.days", { count: cycle })} decrementLabel={t("stepper.shorterCycle")} incrementLabel={t("stepper.longerCycle")} onChange={setCycle} />
        </div>
      ) : null}

      {choice === "scan" ? (
        <div className="flex flex-col gap-4 border-t border-border pt-4">
          <Stepper id="scan-weeks" label={t("dueDate.scanWeeksLabel")} value={scanWeeks} min={SCAN_MIN_WEEKS} max={SCAN_MAX_WEEKS} unit={t("dueDate.weeksUnit")} valueText={t("dueDate.weeks", { count: scanWeeks })} decrementLabel={t("dueDate.fewerWeeks")} incrementLabel={t("dueDate.moreWeeks")} onChange={setScanWeeks} />
          <Stepper id="scan-days" label={t("dueDate.scanDaysLabel")} value={scanDays} min={0} max={LAST_SCAN_EXTRA_DAY} unit={t("stepper.daysUnit")} valueText={t("stepper.days", { count: scanDays })} decrementLabel={t("dueDate.fewerDays")} incrementLabel={t("dueDate.moreDays")} onChange={setScanDays} />
        </div>
      ) : null}
    </CalculatorCard>
  );
}
