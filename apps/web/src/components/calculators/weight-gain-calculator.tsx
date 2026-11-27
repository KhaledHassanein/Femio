"use client";

import { useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import {
  BMI_NORMAL_BELOW,
  BMI_OVERWEIGHT_BELOW,
  BMI_UNDERWEIGHT_BELOW,
  type BmiCategory,
} from "@/lib/calculators";
import {
  CM_PER_INCH,
  KG_PER_LB,
  MAX_HEIGHT_CM,
  MAX_WEIGHT_KG,
  MIN_HEIGHT_CM,
  MIN_WEIGHT_KG,
  weightGainRange,
  type Babies,
} from "@/lib/vitals/weight-gain";
import { chipVariants } from "@/components/ui/chip";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { CalculatorCard, ResultSentence, RuleLine } from "./calculator-card";

type Unit = "metric" | "imperial";
const BABY_CHOICES: readonly { value: Babies; key: "one" | "two" | "more" }[] = [
  { value: 1, key: "one" },
  { value: 2, key: "two" },
  { value: 3, key: "more" },
];

/**
 * The IOM 2009 weight-gain reference range (MR-55). She enters her weight before
 * pregnancy and her height, and says how many babies; the result is the total-gain
 * range for her BMI band, in her units with the other unit beside it. No colour, no
 * verdict, no target: the range is reference text with its source under it.
 *
 * The rules result is the typed `WeightGainResult` from `lib/vitals/weight-gain`; a
 * later "AI view" (R10.1) reads that value, never this markup.
 */
export function WeightGainCalculator() {
  const t = useTranslations("calculators");
  const format = useFormatter();
  // CLIN-N2-4 / MR-55: the band by its numbers, never "underweight" or "obese" (as the app).
  const cut = (v: number) => format.number(v, { maximumFractionDigits: 1 });
  const bandText = (band: BmiCategory): string => {
    switch (band) {
      case "underweight":
        return t("weightGain.bandUnder", { limit: cut(BMI_UNDERWEIGHT_BELOW) });
      case "normal":
        return t("weightGain.bandBetween", { low: cut(BMI_UNDERWEIGHT_BELOW), high: cut(BMI_NORMAL_BELOW) });
      case "overweight":
        return t("weightGain.bandBetween", { low: cut(BMI_NORMAL_BELOW), high: cut(BMI_OVERWEIGHT_BELOW) });
      case "obese":
        return t("weightGain.bandFrom", { limit: cut(BMI_OVERWEIGHT_BELOW) });
    }
  };
  const [unit, setUnit] = useState<Unit>("metric");
  const [weight, setWeight] = useState("");
  const [height, setHeight] = useState("");
  const [babies, setBabies] = useState<Babies>(1);

  const w = Number(weight);
  const h = Number(height);
  const weightKg = unit === "metric" ? w : w * KG_PER_LB;
  const heightCm = unit === "metric" ? h : h * CM_PER_INCH;
  const entered = weight !== "" && height !== "";
  const result = entered ? weightGainRange(weightKg, heightCm, babies) : null;
  const num = (n: number) => format.number(n, { maximumFractionDigits: 1 });

  const kg = result?.range ? t("weightGain.rangeKg", { low: num(result.range.lowKg), high: num(result.range.highKg) }) : null;
  const lb = result?.range ? t("weightGain.rangeLb", { low: num(result.range.lowLb), high: num(result.range.highLb) }) : null;
  const headline = unit === "metric" ? kg : lb;
  const other = unit === "metric" ? lb : kg;

  return (
    <CalculatorCard>
      <div className="flex flex-wrap gap-2" role="group" aria-label={t("weightGain.title")}>
        {(["metric", "imperial"] as const).map((u) => (
          <button key={u} type="button" aria-pressed={unit === u} onClick={() => setUnit(u)} className={chipVariants({ selected: unit === u })}>
            {t(u === "metric" ? "bmi.unitMetric" : "bmi.unitImperial")}
          </button>
        ))}
      </div>

      <div className="grid gap-4 sm:grid-cols-2">
        <div className="flex flex-col gap-2">
          <Label htmlFor="wg-weight">{t(unit === "metric" ? "weightGain.weightMetric" : "weightGain.weightImperial")}</Label>
          <Input id="wg-weight" type="number" inputMode="decimal" min={0} value={weight} onChange={(e) => setWeight(e.target.value)} />
        </div>
        <div className="flex flex-col gap-2">
          <Label htmlFor="wg-height">{t(unit === "metric" ? "bmi.heightMetric" : "bmi.heightImperial")}</Label>
          <Input id="wg-height" type="number" inputMode="decimal" min={0} value={height} onChange={(e) => setHeight(e.target.value)} />
        </div>
      </div>

      <div className="flex flex-col gap-2">
        <p className="text-sm font-semibold text-text">{t("weightGain.babiesLabel")}</p>
        <div className="flex flex-wrap gap-2">
          {BABY_CHOICES.map(({ value, key }) => (
            <button key={key} type="button" aria-pressed={babies === value} onClick={() => setBabies(value)} className={chipVariants({ selected: babies === value })}>
              {t(`weightGain.babies.${key}`)}
            </button>
          ))}
        </div>
      </div>

      {entered && !result ? (
        <p className="rounded-md bg-surface-sunken p-4 text-sm text-text" role="status">
          {t("weightGain.outOfRange", { minW: MIN_WEIGHT_KG, maxW: MAX_WEIGHT_KG, minH: MIN_HEIGHT_CM, maxH: MAX_HEIGHT_CM })}
        </p>
      ) : null}

      {result ? (
        <ResultSentence
          eyebrow={t("weightGain.eyebrow")}
          headline={headline ?? t(result.noRangeReason === "multiples" ? "weightGain.noRangeMultiples" : "weightGain.noRangeTwinsUnderweight")}
          lines={[
            ...(other ? [t("weightGain.otherUnit", { range: other })] : []),
            t("weightGain.bmiLine", { value: num(result.bmi), band: bandText(result.band) }),
          ]}
        >
          <RuleLine>{t("weightGain.note")}</RuleLine>
          <RuleLine>{t("weightGain.source")}</RuleLine>
        </ResultSentence>
      ) : null}
    </CalculatorCard>
  );
}
