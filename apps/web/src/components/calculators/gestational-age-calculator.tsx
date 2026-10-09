"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { gestationalAge } from "@/lib/calculators";
import { diffDays } from "@/lib/calculators/dates";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useCalculatorUsed } from "@/lib/analytics/use-calculator-used";
import { PregnancyProgress } from "./pregnancy-progress";
import { CalcNotice, ResultRegion, useToday } from "./calc-notice";

export function GestationalAgeCalculator() {
  const t = useTranslations("calculators");
  const [lmp, setLmp] = useState("");
  const ti = useTranslations("calculators.issues");
  const today = useToday();
  // Empty until mount, then her own date (not the server's UTC one: F17).
  const [picked, setAsOf] = useState("");
  const asOf = picked || today;

  const future = Boolean(lmp && today && lmp > today);
  const before = Boolean(lmp && asOf && asOf < lmp);
  const span = lmp && asOf ? diffDays(lmp, asOf) : 0;
  const stale = span > 294;
  const result = lmp && asOf && !future && !before && !stale ? gestationalAge(lmp, asOf) : null;

  useCalculatorUsed(result != null);

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
        <ResultRegion>
          {future ? <CalcNotice>{ti("future")}</CalcNotice> : null}
          {!future && before ? <CalcNotice>{ti("asOfBeforeLmp")}</CalcNotice> : null}
          {stale ? <CalcNotice>{ti("notCurrentPregnancy")}</CalcNotice> : null}
          {result && span >= 287 ? <CalcNotice>{ti("pastTerm")}</CalcNotice> : null}
          {result ? (
            <div className="rounded-sm bg-primary-soft p-4 text-primary-soft-text">
              <p className="font-display text-xl">
                {t("gestationalAge.resultLabel", { weeks: result.weeks, days: result.days })}
              </p>
              <div className="mt-3">
                <PregnancyProgress weeks={result.totalDays / 7} />
              </div>
              <p className="mt-2 text-xs opacity-90">{t("common.estimateNote")}</p>
            </div>
          ) : null}
        </ResultRegion>
      </CardContent>
    </Card>
  );
}
