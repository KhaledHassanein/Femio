"use client";

import { useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import { estimateDueDate, gestationalAge, MAX_CYCLE, MIN_CYCLE } from "@/lib/calculators";
import { todayISO } from "@/lib/calculators/dates";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { PregnancyProgress } from "./pregnancy-progress";

export function DueDateCalculator() {
  const t = useTranslations("calculators");
  const format = useFormatter();
  const [lmp, setLmp] = useState("");
  const [cycle, setCycle] = useState("28");

  const result = lmp ? estimateDueDate(lmp, Number(cycle) || 28) : null;
  // Where she is today, when the date she gave is a pregnancy in progress.
  const now = lmp ? gestationalAge(lmp, todayISO()) : null;
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
      </CardContent>
    </Card>
  );
}
