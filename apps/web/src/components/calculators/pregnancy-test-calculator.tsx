"use client";

import { useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import {
  MAX_CYCLE,
  MIN_CYCLE,
  pregnancyTestFromPeriod,
  pregnancyTestFromSex,
} from "@/lib/calculators";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { chipVariants } from "@/components/ui/chip";
import { MiniCalendar, type DayMark } from "./mini-calendar";

type Mode = "period" | "sex";

export function PregnancyTestCalculator() {
  const t = useTranslations("calculators");
  const format = useFormatter();
  const [mode, setMode] = useState<Mode>("period");
  const [date, setDate] = useState("");
  const [cycle, setCycle] = useState("28");

  const fromPeriod =
    mode === "period" && date ? pregnancyTestFromPeriod(date, Number(cycle) || 28) : null;
  const fromSex = mode === "sex" && date ? pregnancyTestFromSex(date) : null;
  const testFrom = fromPeriod?.testFrom ?? fromSex?.testFrom ?? null;

  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "long", timeZone: "UTC" });

  const marks = new Map<string, DayMark>();
  if (testFrom) marks.set(testFrom, "test");

  return (
    <Card>
      <CardContent className="flex flex-col gap-4 p-6">
        <div className="flex flex-col gap-2">
          <p className="text-sm font-medium text-text">{t("pregnancyTest.modeLabel")}</p>
          <div className="flex flex-wrap gap-2">
            {(["period", "sex"] as const).map((m) => (
              <button
                key={m}
                type="button"
                aria-pressed={mode === m}
                onClick={() => {
                  setMode(m);
                  setDate("");
                }}
                className={chipVariants({ selected: mode === m })}
              >
                {t(m === "period" ? "pregnancyTest.modePeriod" : "pregnancyTest.modeSex")}
              </button>
            ))}
          </div>
        </div>
        <div className="flex flex-col gap-2">
          <Label htmlFor="date">
            {mode === "period" ? t("common.lmpLabel") : t("pregnancyTest.sexLabel")}
          </Label>
          <Input id="date" type="date" value={date} onChange={(e) => setDate(e.target.value)} />
        </div>
        {mode === "period" ? (
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
        ) : null}

        {testFrom ? (
          <div className="flex flex-col gap-4">
            <div className="flex flex-col gap-1 rounded-md bg-primary-soft p-4 text-primary-soft-text">
              {fromPeriod ? (
                <p className="text-sm">
                  {t("pregnancyTest.expectedPeriodLabel")} {fmt(fromPeriod.expectedPeriod)}
                </p>
              ) : null}
              <p className="text-sm">{t("pregnancyTest.testFromLabel")}</p>
              <p className="font-display text-xl">{fmt(testFrom)}</p>
              <p className="mt-1 text-xs">
                {t(fromPeriod ? "pregnancyTest.notePeriod" : "pregnancyTest.noteSex")}
              </p>
            </div>
            <MiniCalendar marks={marks} from={testFrom} to={testFrom} />
            <p className="text-2xs text-text-subtle">{t("pregnancyTest.source")}</p>
          </div>
        ) : null}
      </CardContent>
    </Card>
  );
}
