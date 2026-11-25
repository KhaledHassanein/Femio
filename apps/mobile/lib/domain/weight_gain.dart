// The pregnancy weight-gain reference range (MR-55, IOM 2009).
//
// Why it exists: "how much weight should I gain?" depends on her BMI before
// pregnancy. This returns the Institute of Medicine's total-gain range for her band as
// reference text: never a verdict, a colour, or a pass or fail. It returns numbers and
// band names only, so the screen and a later explainer (R10.1) read the same value.
//
// Sources (read 2026-11-24, listed in the register row): the IOM/NRC 2009 report brief
// (pounds), Gilmore & Redman 2015 Table 1 (kilograms, one baby), the MSD Manual
// Professional table (twin kilograms), CDC "Weight Gain During Pregnancy". IOM gives no
// range for twins with a BMI under 18.5, nor for three or more babies.
//
// Twin of `apps/web/src/lib/vitals/weight-gain.ts`, bound by
// `fixtures/domain/weight-gain.json` (generated in Python, not by either client).

/// MR-28 / MR-55: accepted weight before pregnancy (kg) and height (cm).
const minWeightKg = 25;
const maxWeightKg = 300;
const minHeightCm = 120;
const maxHeightCm = 220;

/// The input's "three or more babies" value.
const multiples = 3;

/// WHO adult BMI bands, the same cut-offs as the website's BMI calculator.
enum BmiBand { underweight, normal, overweight, obese }

/// WHO cut-offs on the BMI rounded to one decimal.
const _underweightBelow = 18.5;
const _normalBelow = 25.0;
const _overweightBelow = 30.0;

/// A total-gain range in both units, as IOM states it.
class GainRange {
  const GainRange(this.lowKg, this.highKg, this.lowLb, this.highLb);
  final num lowKg;
  final num highKg;
  final num lowLb;
  final num highLb;

  Map<String, Object> toJson() => {'lowKg': lowKg, 'highKg': highKg, 'lowLb': lowLb, 'highLb': highLb};
}

/// Why no range is shown.
enum NoRangeReason { twinsUnderweight, multiples }

/// MR-55, one baby.
const _singleton = <BmiBand, GainRange>{
  BmiBand.underweight: GainRange(12.5, 18, 28, 40),
  BmiBand.normal: GainRange(11.5, 16, 25, 35),
  BmiBand.overweight: GainRange(7, 11.5, 15, 25),
  BmiBand.obese: GainRange(5, 9, 11, 20),
};

/// MR-55, twins (IOM's provisional guidance); none for a BMI under 18.5.
const _twins = <BmiBand, GainRange?>{
  BmiBand.underweight: null,
  BmiBand.normal: GainRange(16.8, 24.5, 37, 54),
  BmiBand.overweight: GainRange(14.1, 22.7, 31, 50),
  BmiBand.obese: GainRange(11.5, 19.1, 25, 42),
};

/// The result: her BMI and band, and the range or why there is none.
class WeightGainResult {
  const WeightGainResult({
    required this.bmi,
    required this.band,
    required this.babies,
    required this.range,
    required this.noRangeReason,
  });

  final double bmi;
  final BmiBand band;
  final int babies;
  final GainRange? range;
  final NoRangeReason? noRangeReason;

  Map<String, Object?> toJson() => {
        'bmi': bmi,
        'band': band.name,
        'babies': babies,
        'range': range?.toJson(),
        'noRangeReason': noRangeReason?.name,
      };
}

/// BMI rounded to one decimal (halves up), the website's `bmi()` rounding.
double bmiOf(double weightKg, double heightCm) {
  final meters = heightCm / 100;
  return (weightKg / (meters * meters) * 10).round() / 10;
}

/// The WHO band of a BMI already rounded to one decimal.
BmiBand bandOf(double bmi) {
  if (bmi < _underweightBelow) return BmiBand.underweight;
  if (bmi < _normalBelow) return BmiBand.normal;
  if (bmi < _overweightBelow) return BmiBand.overweight;
  return BmiBand.obese;
}

/// The IOM 2009 total-gain range for [weightKg] before pregnancy (25-300), [heightCm]
/// (120-220) and [babies] (1, 2, or 3 for three or more).
///
/// Returns null for input outside the accepted ranges.
WeightGainResult? weightGainRange(double weightKg, double heightCm, int babies) {
  if (weightKg < minWeightKg || weightKg > maxWeightKg) return null;
  if (heightCm < minHeightCm || heightCm > maxHeightCm) return null;
  if (babies < 1 || babies > multiples) return null;
  final bmi = bmiOf(weightKg, heightCm);
  final band = bandOf(bmi);
  if (babies == multiples) {
    return WeightGainResult(bmi: bmi, band: band, babies: babies, range: null, noRangeReason: NoRangeReason.multiples);
  }
  final range = babies == 1 ? _singleton[band] : _twins[band];
  return WeightGainResult(
    bmi: bmi,
    band: band,
    babies: babies,
    range: range,
    noRangeReason: range == null ? NoRangeReason.twinsUnderweight : null,
  );
}
