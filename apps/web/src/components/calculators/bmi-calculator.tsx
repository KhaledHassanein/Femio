"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { bmi } from "@/lib/calculators";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useCalculatorUsed } from "@/lib/analytics/use-calculator-used";

type Unit = "metric" | "imperial";

export function BmiCalculator() {
  const t = useTranslations("calculators");
  const [unit, setUnit] = useState<Unit>("metric");
  const [weight, setWeight] = useState("");
  const [height, setHeight] = useState("");

  const w = Number(weight);
  const h = Number(height);
  const weightKg = unit === "metric" ? w : w * 0.453592;
  const heightCm = unit === "metric" ? h : h * 2.54;
  const result = weight && height ? bmi(weightKg, heightCm) : null;
  useCalculatorUsed(result != null);

  return (
    <Card>
      <CardContent className="flex flex-col gap-4 p-6">
        <div className="flex gap-2" role="group" aria-label={t("bmi.title")}>
          {(["metric", "imperial"] as const).map((u) => (
            <Button
              key={u}
              type="button"
              variant={unit === u ? "primary" : "outline"}
              size="sm"
              onClick={() => setUnit(u)}
              aria-pressed={unit === u}
            >
              {t(u === "metric" ? "bmi.unitMetric" : "bmi.unitImperial")}
            </Button>
          ))}
        </div>
        <div className="flex flex-col gap-2">
          <Label htmlFor="weight">
            {t(unit === "metric" ? "bmi.weightMetric" : "bmi.weightImperial")}
          </Label>
          <Input
            id="weight"
            type="number"
            inputMode="decimal"
            min={0}
            value={weight}
            onChange={(e) => setWeight(e.target.value)}
          />
        </div>
        <div className="flex flex-col gap-2">
          <Label htmlFor="height">
            {t(unit === "metric" ? "bmi.heightMetric" : "bmi.heightImperial")}
          </Label>
          <Input
            id="height"
            type="number"
            inputMode="decimal"
            min={0}
            value={height}
            onChange={(e) => setHeight(e.target.value)}
          />
        </div>
        {result ? (
          <div className="rounded-sm bg-primary-soft p-4 text-primary-soft-text">
            <p className="text-sm">{t("bmi.resultLabel")}</p>
            <p className="font-display text-xl">{result.value}</p>
            <p className="mt-1 text-sm">
              {t("bmi.categoryLabel", { category: t(`bmi.categories.${result.category}`) })}
            </p>
            <p className="mt-2 text-xs opacity-90">{t("bmi.note")}</p>
          </div>
        ) : null}
      </CardContent>
    </Card>
  );
}
