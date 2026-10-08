/// Weight in pregnancy: the geometry, on its own. Twin of
/// `apps/web/src/lib/vitals/weight.ts`, bound to it by `fixtures/domain/weight-chart.json`.
///
/// No target line, no "recommended gain" band, nothing that could draw one: a shaded
/// range behind her dots is an assessment of her body rendered as a background colour,
/// and pregnancy is a high-risk time for weight stigma and disordered eating. Her dots,
/// her axis, her numbers (the same call as the movement log and the BBT chart).
library;

import 'dart:math' as math;

const weightUnits = ['kg', 'lb'];

class WeightEntry {
  const WeightEntry(this.id, this.measuredOn, this.value, this.unit);
  final String id;

  /// ISO date.
  final String measuredOn;
  final double value;

  /// `kg` or `lb`, as she typed it; what she typed is what is stored and shown.
  final String unit;

  Map<String, Object?> toJson() => {'id': id, 'measuredOn': measuredOn, 'value': value, 'unit': unit};
  static WeightEntry fromJson(Map<String, Object?> j) => WeightEntry(
        j['id'] as String,
        j['measuredOn'] as String,
        (j['value'] as num).toDouble(),
        j['unit'] as String,
      );
}

/// Wide on purpose: a typo guard, never a comment on her body.
bool isPlausibleWeight(double value, String unit) => value.isFinite &&
    (unit == 'kg' ? value >= 25 && value <= 300 : value >= 55 && value <= 660);

const _kgPerLb = 0.45359237;

double toKg(double value, String unit) => unit == 'kg' ? value : value * _kgPerLb;

class WeightPoint {
  const WeightPoint(this.entryId, this.measuredOn, this.value, this.unit, this.y);
  final String entryId;
  final String measuredOn;
  final double value;
  final String unit;

  /// 0–1, bottom to top. Geometry, never meaning.
  final double y;
}

class WeightChart {
  const WeightChart(this.points, this.unit, this.low, this.high, this.changeSinceFirst);
  final List<WeightPoint> points;

  /// Her most recent unit.
  final String unit;
  final double low;
  final double high;

  /// A number, compared with nothing: there is no expected value to compare it to.
  final double? changeSinceFirst;
}

double _round1(double n) => (n * 10).round() / 10;

WeightChart? weightChart(Iterable<WeightEntry> entries) {
  final sorted = [...entries]..sort((a, b) => a.measuredOn.compareTo(b.measuredOn));
  if (sorted.length < 2) return null;
  // Her latest unit wins the axis, so today's number reads as she typed it.
  final unit = sorted.last.unit;
  double inUnit(WeightEntry e) => unit == 'kg' ? toKg(e.value, e.unit) : toKg(e.value, e.unit) / _kgPerLb;
  final values = sorted.map(inUnit).toList();
  final padding = unit == 'kg' ? 2 : 4;
  final low = values.reduce(math.min) - padding;
  final high = values.reduce(math.max) + padding;
  final span = high - low == 0 ? 1 : high - low;
  return WeightChart(
    [
      for (var i = 0; i < sorted.length; i++)
        WeightPoint(sorted[i].id, sorted[i].measuredOn, _round1(values[i]), unit, (values[i] - low) / span),
    ],
    unit,
    low,
    high,
    _round1(values.last - values.first),
  );
}
