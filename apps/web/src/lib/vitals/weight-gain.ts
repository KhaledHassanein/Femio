/**
 * The pregnancy weight-gain reference range (MR-55, IOM 2009).
 *
 * Why it exists: "how much weight should I gain?" is one of the first pregnancy
 * questions, and the answer depends on her BMI before pregnancy. This returns the
 * Institute of Medicine's total-gain range for her band as reference text: never a
 * verdict, a colour, or a pass or fail. It returns numbers and band names only, so the
 * page and a later explainer both read the same typed value.
 *
 * Sources (read 2026-11-24, listed in the register row): the IOM/NRC 2009 report brief
 * (pounds), Gilmore & Redman 2015 Table 1 (kilograms, one baby), the MSD Manual
 * Professional table (twin kilograms), CDC "Weight Gain During Pregnancy". IOM gives no
 * range for twins with a BMI under 18.5, nor for three or more babies, so neither gets
 * one here.
 *
 * Twin of `apps/mobile/lib/domain/weight_gain.dart`, bound by
 * `fixtures/domain/weight-gain.json` (generated in Python, not by either client).
 */
import { bmi, type BmiCategory } from "../calculators/index.ts";

/** MR-28 / MR-55: accepted weight before pregnancy, kg. */
export const MIN_WEIGHT_KG = 25;
export const MAX_WEIGHT_KG = 300;
/** MR-55: accepted height, cm (the engine's sanity range). */
export const MIN_HEIGHT_CM = 120;
export const MAX_HEIGHT_CM = 220;
/** The input's "three or more" value. */
export const MULTIPLES = 3;
/** Unit conversions for the imperial inputs (exact by definition). */
export const KG_PER_LB = 0.45359237;
export const CM_PER_INCH = 2.54;

/** 1, 2, or 3 meaning "three or more". */
export type Babies = 1 | 2 | 3;

export type GainRange = { lowKg: number; highKg: number; lowLb: number; highLb: number };

/** MR-55, one baby. */
const SINGLETON: Record<BmiCategory, GainRange> = {
  underweight: { lowKg: 12.5, highKg: 18, lowLb: 28, highLb: 40 },
  normal: { lowKg: 11.5, highKg: 16, lowLb: 25, highLb: 35 },
  overweight: { lowKg: 7, highKg: 11.5, lowLb: 15, highLb: 25 },
  obese: { lowKg: 5, highKg: 9, lowLb: 11, highLb: 20 },
};

/** MR-55, twins (IOM's provisional guidance); none for a BMI under 18.5. */
const TWINS: Record<BmiCategory, GainRange | null> = {
  underweight: null,
  normal: { lowKg: 16.8, highKg: 24.5, lowLb: 37, highLb: 54 },
  overweight: { lowKg: 14.1, highKg: 22.7, lowLb: 31, highLb: 50 },
  obese: { lowKg: 11.5, highKg: 19.1, lowLb: 25, highLb: 42 },
};

export type WeightGainResult = {
  bmi: number;
  band: BmiCategory;
  babies: Babies;
  /** Null when IOM gives no range; `noRangeReason` says why. */
  range: GainRange | null;
  noRangeReason: "twinsUnderweight" | "multiples" | null;
};

/**
 * The IOM 2009 total-gain range for her pre-pregnancy weight and height.
 *
 * @param weightKg weight before pregnancy, 25–300 kg.
 * @param heightCm height, 120–220 cm.
 * @param babies 1, 2, or 3 for three or more.
 * @returns the band and range, or null for input outside the accepted ranges.
 */
export function weightGainRange(weightKg: number, heightCm: number, babies: number): WeightGainResult | null {
  if (!(weightKg >= MIN_WEIGHT_KG && weightKg <= MAX_WEIGHT_KG)) return null;
  if (!(heightCm >= MIN_HEIGHT_CM && heightCm <= MAX_HEIGHT_CM)) return null;
  if (babies !== 1 && babies !== 2 && babies !== MULTIPLES) return null;
  const b = bmi(weightKg, heightCm);
  if (!b) return null;
  if (babies === MULTIPLES) return { bmi: b.value, band: b.category, babies, range: null, noRangeReason: "multiples" };
  const range = (babies === 1 ? SINGLETON : TWINS)[b.category];
  return range
    ? { bmi: b.value, band: b.category, babies, range: { ...range }, noRangeReason: null }
    : { bmi: b.value, band: b.category, babies, range: null, noRangeReason: "twinsUnderweight" };
}
