"use client";

import { useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import { fertileWindow, MAX_CYCLE, MIN_CYCLE } from "@/lib/calculators";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useCalculatorUsed } from "@/lib/analytics/use-calculator-used";
import { MiniCalendar, markRange, type DayMark } from "./mini-calendar";

export function OvulationCalculator() {
  const t = useTranslations("calculators");
  const format = useFormatter();
  const [lmp, setLmp] = useState("");
  const [cycle, setCycle] = useState("28");

  const result = lmp ? fertileWindow(lmp, Number(cycle) || 28) : null;

  useCalculatorUsed(result != null);
  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "long", timeZone: "UTC" });

  const marks = new Map<string, DayMark>();
  if (result) {
    marks.set(result.ovulation, "ovulation");
    marks.set(result.nextPeriod, "period");
    markRange(marks, result.windowStart, result.windowEnd, "fertile");
  }

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
        {result ? (
          <div className="flex flex-col gap-3 rounded-sm bg-success-soft p-4 text-success-text">
            <div>
              <p className="text-sm">{t("ovulation.windowLabel")}</p>
              <p className="font-display text-xl">
                {t("ovulation.rangeValue", {
                  start: fmt(result.windowStart),
                  end: fmt(result.windowEnd),
                })}
              </p>
            </div>
            <p className="text-sm">
              {t("ovulation.ovulationLabel")}: {fmt(result.ovulation)}
            </p>
            <p className="text-sm">
              {t("ovulation.nextPeriodLabel")}: {fmt(result.nextPeriod)}
            </p>
            <p className="text-xs opacity-90">{t("ovulation.awarenessNote")}</p>
          </div>
        ) : null}
        {result ? (
          <MiniCalendar marks={marks} from={result.windowStart} to={result.nextPeriod} />
        ) : null}
      </CardContent>
    </Card>
  );
}
