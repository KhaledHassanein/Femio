"use client";

import { useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import {
  cycleInRange,
  estimateDueDate,
  gestationalAge,
  MAX_CYCLE,
  MIN_CYCLE,
} from "@/lib/calculators";
import { diffDays } from "@/lib/calculators/dates";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useCalculatorUsed } from "@/lib/analytics/use-calculator-used";
import { PregnancyProgress } from "./pregnancy-progress";
import { CalcNotice, ResultRegion, useToday } from "./calc-notice";

/** 41w0d and 42w0d: when care teams usually talk next steps, and the end of term. */
const PAST_TERM_DAYS = 287;
const TERM_END_DAYS = 294;

export function DueDateCalculator() {
  const t = useTranslations("calculators");
  const format = useFormatter();
  const [lmp, setLmp] = useState("");
  const [cycle, setCycle] = useState("28");

  const ti = useTranslations("calculators.issues");
  const today = useToday();
  const n = Number(cycle);
  const future = Boolean(lmp && today && lmp > today);
  const cycleBad = !cycleInRange(n);
  const since = lmp && today ? diffDays(lmp, today) : 0;
  // More than 42 weeks back is not a pregnancy in progress; a past EDD helps nobody.
  const stale = since > TERM_END_DAYS;
  const result = lmp && !future && !stale ? estimateDueDate(lmp, n) : null;

  useCalculatorUsed(result != null);
  // Where she is today, when the date she gave is a pregnancy in progress.
  const now = result && today ? gestationalAge(lmp, today) : null;
  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "long", timeZone: "UTC" });

  return (
    <Card>
      <CardContent className="flex flex-col gap-4 p-6">
        <div className="flex flex-col gap-2">
          <Label htmlFor="lmp">{t("common.lmpLabel")}</Label>
          <Input id="lmp" type="date" value={lmp} onChange={(e) => setLmp(e.target.value)} />
        </div>
        <div className="flex flex-col gap-2">
          <Label htmlFor="cycle">{t("common.cycleLabel")}</Label>
          <Input
            id="cycle"
            type="number"
            min={MIN_CYCLE}
            max={MAX_CYCLE}
            value={cycle}
            onChange={(e) => setCycle(e.target.value)}
          />
        </div>
        <ResultRegion>
          {future ? <CalcNotice>{ti("future")}</CalcNotice> : null}
          {stale ? <CalcNotice>{ti("notCurrentPregnancy")}</CalcNotice> : null}
          {lmp && cycleBad ? (
            <CalcNotice read={["irregular"]}>
              {ti("cycleRange", { min: MIN_CYCLE, max: MAX_CYCLE })}
            </CalcNotice>
          ) : null}
          {result && since >= PAST_TERM_DAYS ? <CalcNotice>{ti("pastTerm")}</CalcNotice> : null}
          {result ? (
            <div className="rounded-sm bg-primary-soft p-4 text-primary-soft-text">
              <p className="text-sm">{t("dueDate.eddLabel")}</p>
              <p className="font-display text-xl">{fmt(result.edd)}</p>
              <p className="mt-2 text-sm">
                {t("dueDate.termWindowLabel", {
                  start: fmt(result.termStart),
                  end: fmt(result.termEnd),
                })}
              </p>
              {now ? (
                <div className="mt-3">
                  <PregnancyProgress weeks={now.totalDays / 7} />
                </div>
              ) : null}
              <p className="mt-2 text-xs opacity-90">{t("common.estimateNote")}</p>
            </div>
          ) : null}
        </ResultRegion>
      </CardContent>
    </Card>
  );
}
