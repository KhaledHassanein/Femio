"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { gestationalAge } from "@/lib/calculators";
import { todayISO } from "@/lib/calculators/dates";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export function GestationalAgeCalculator() {
  const t = useTranslations("calculators");
  const [lmp, setLmp] = useState("");
  const [asOf, setAsOf] = useState(todayISO());

  const result = lmp ? gestationalAge(lmp, asOf) : null;

  return (
    <Card>
      <CardContent className="flex flex-col gap-4 p-6">
        <div className="flex flex-col gap-2">
          <Label htmlFor="lmp">{t("common.lmpLabel")}</Label>
          <Input id="lmp" type="date" value={lmp} onChange={(e) => setLmp(e.target.value)} />
        </div>
        <div className="flex flex-col gap-2">
          <Label htmlFor="asof">{t("gestationalAge.asOfLabel")}</Label>
          <Input id="asof" type="date" value={asOf} onChange={(e) => setAsOf(e.target.value)} />
        </div>
        {result ? (
          <div className="rounded-sm bg-primary-soft p-4 text-primary-soft-text">
            <p className="font-display text-xl">
              {t("gestationalAge.resultLabel", { weeks: result.weeks, days: result.days })}
            </p>
            <p className="mt-2 text-xs opacity-90">{t("common.estimateNote")}</p>
          </div>
        ) : null}
      </CardContent>
    </Card>
  );
}
