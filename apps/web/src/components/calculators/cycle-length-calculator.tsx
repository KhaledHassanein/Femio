"use client";

import { useState } from "react";
import { Plus, X } from "lucide-react";
import { useTranslations } from "next-intl";
import { cycleStats } from "@/lib/calculators";
import { CalcNotice, ResultRegion } from "./calc-notice";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useCalculatorUsed } from "@/lib/analytics/use-calculator-used";

export function CycleLengthCalculator() {
  const t = useTranslations("calculators");
  const [dates, setDates] = useState<string[]>(["", ""]);

  const setAt = (i: number, v: string) => setDates((d) => d.map((x, idx) => (idx === i ? v : x)));
  const add = () => setDates((d) => [...d, ""]);
  const remove = (i: number) => setDates((d) => d.filter((_, idx) => idx !== i));

  const result = cycleStats(dates);

  useCalculatorUsed(result != null);
  const days = (n: number) => t("cycleLength.daysValue", { days: n });

  return (
    <Card>
      <CardContent className="flex flex-col gap-4 p-6">
        <Label>{t("cycleLength.datesLabel")}</Label>
        <div className="flex flex-col gap-2">
          {dates.map((d, i) => (
            <div key={i} className="flex items-center gap-2">
              <Input
                type="date"
                value={d}
                onChange={(e) => setAt(i, e.target.value)}
                aria-label={`${t("cycleLength.datesLabel")} ${i + 1}`}
              />
              {dates.length > 2 ? (
                <Button
                  type="button"
                  variant="ghost"
                  size="icon"
                  aria-label={t("cycleLength.removeDate")}
                  onClick={() => remove(i)}
                >
                  <X className="size-4" />
                </Button>
              ) : null}
            </div>
          ))}
        </div>
        <Button type="button" variant="outline" size="sm" onClick={add} className="self-start">
          <Plus className="size-4" />
          {t("cycleLength.addDate")}
        </Button>
        <ResultRegion>
          {result?.tooClose ? (
            <CalcNotice>{t("issues.tooClose", { days: result.min })}</CalcNotice>
          ) : result ? (
            <div className="rounded-sm bg-primary-soft p-4 text-primary-soft-text">
              <p className="text-sm">{t("cycleLength.averageLabel")}</p>
              <p className="font-display text-xl">{days(result.averageLength)}</p>
              {result.count > 1 ? (
                <p className="mt-1 text-sm">
                  {t("cycleLength.rangeLabel")}: {days(result.min)} – {days(result.max)}
                </p>
              ) : null}
              <p className="mt-2 text-sm">
                {result.regular === null
                  ? t("issues.oneInterval")
                  : result.regular
                    ? t("cycleLength.regular")
                    : t("cycleLength.irregular")}
              </p>
            </div>
          ) : (
            <p className="text-sm text-text-muted">{t("cycleLength.needTwo")}</p>
          )}
        </ResultRegion>
      </CardContent>
    </Card>
  );
}
