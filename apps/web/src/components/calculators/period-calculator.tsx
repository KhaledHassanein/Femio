"use client";

import { useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import { MAX_CYCLE, MAX_PERIOD, MIN_CYCLE, MIN_PERIOD, periodForecast } from "@/lib/calculators";
import { addDays } from "@/lib/calculators/dates";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { MiniCalendar, markRange, type DayMark } from "./mini-calendar";

export function PeriodCalculator() {
  const t = useTranslations("calculators");
  const format = useFormatter();
  const [lmp, setLmp] = useState("");
  const [shortest, setShortest] = useState("28");
  const [longest, setLongest] = useState("28");
  const [length, setLength] = useState("5");

  const len = Number(length) || 5;
  const result = lmp
    ? periodForecast(lmp, Number(shortest) || 28, Number(longest) || 28, len, 3)
    : null;

  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });

  const marks = new Map<string, DayMark>();
  for (const p of result ?? []) {
    if (p.earliest === p.latest) markRange(marks, p.earliest, p.endIfEarliest, "period");
    else markRange(marks, p.earliest, p.latest, "periodMaybe");
  }

  return (
    <Card>
      <CardContent className="flex flex-col gap-4 p-6">
        <div className="flex flex-col gap-2">
          <Label htmlFor="lmp">{t("common.lmpLabel")}</Label>
          <Input id="lmp" type="date" value={lmp} onChange={(e) => setLmp(e.target.value)} />
        </div>
        <div className="grid grid-cols-2 gap-3">
          <div className="flex flex-col gap-2">
            <Label htmlFor="shortest">{t("period.shortestLabel")}</Label>
            <Input
              id="shortest"
              type="number"
              min={MIN_CYCLE}
              max={MAX_CYCLE}
              value={shortest}
              onChange={(e) => setShortest(e.target.value)}
            />
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="longest">{t("period.longestLabel")}</Label>
            <Input
              id="longest"
              type="number"
              min={MIN_CYCLE}
              max={MAX_CYCLE}
              value={longest}
              onChange={(e) => setLongest(e.target.value)}
            />
          </div>
        </div>
        <p className="text-2xs text-text-muted">{t("period.varyNote")}</p>
        <div className="flex flex-col gap-2">
          <Label htmlFor="length">{t("period.periodLengthLabel")}</Label>
          <Input
            id="length"
            type="number"
            min={MIN_PERIOD}
            max={MAX_PERIOD}
            value={length}
            onChange={(e) => setLength(e.target.value)}
          />
        </div>

        {result ? (
          <div className="flex flex-col gap-4">
            <ol className="flex flex-col gap-2">
              {result.map((p, i) => (
                <li
                  key={p.earliest}
                  className="flex items-center justify-between gap-3 rounded-md bg-log-period-alt px-4 py-3 text-log-period"
                >
                  <span className="text-sm">{t("period.nextLabel", { n: i + 1 })}</span>
                  <span className="font-display text-md">
                    {p.earliest === p.latest
                      ? t("period.singleValue", { date: fmt(p.earliest) })
                      : t("period.rangeValue", { start: fmt(p.earliest), end: fmt(p.latest) })}
                  </span>
                </li>
              ))}
            </ol>
            <MiniCalendar
              marks={marks}
              from={result[0]!.earliest}
              to={addDays(result[2]!.latest, len)}
            />
            <p className="text-xs text-text-muted">{t("period.resultNote")}</p>
          </div>
        ) : null}
      </CardContent>
    </Card>
  );
}
