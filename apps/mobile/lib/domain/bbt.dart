import 'dart:math' as math;

import 'dates.dart';

/// Waking-temperature chart geometry. Twin of `bbtChart` in
/// `apps/web/src/lib/fertility/index.ts`, held together by `fixtures/domain/bbt-chart.json`.
///
/// It returns where to put the dots and nothing else: no shift, no phase, no
/// ovulation day. A sustained rise is a reading Femio does not make (product rule 1,
/// and the contraception guardrail): her numbers, drawn honestly, and the meaning is
/// for her and her clinician.

class BbtEntry {
  const BbtEntry(this.id, this.loggedAt, this.bbt);
  final String id;
  final String loggedAt;
  final double bbt;
}

class BbtPoint {
  const BbtPoint(this.entryId, this.loggedAt, this.cycleDay, this.bbt, this.y);
  final String entryId;
  final String loggedAt;
  final int? cycleDay;
  final double bbt;

  /// 0–1, bottom to top, for drawing. Geometry, never meaning.
  final double y;
}

class BbtChart {
  const BbtChart(this.points, this.low, this.high, this.unit);
  final List<BbtPoint> points;
  final double low;
  final double high;
  final String unit;
}

const _celsius = (min: 34.0, max: 40.0);
const _fahrenheit = (min: 93.0, max: 104.0);

/// A typo guard (365 for 36.5), not a judgement: any reading inside is never commented on.
bool isPlausibleBbt(double value, String unit) {
  final r = unit == 'c' ? _celsius : _fahrenheit;
  return value.isFinite && value >= r.min && value <= r.max;
}

String? unitOf(double value) => isPlausibleBbt(value, 'c')
    ? 'c'
    : isPlausibleBbt(value, 'f')
        ? 'f'
        : null;

const _padding = {'c': 0.4, 'f': 0.7};
const _minPoints = 3;

BbtChart? bbtChart(List<BbtEntry> entries, String? cycleStart) {
  final sorted = [...entries]..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
  if (sorted.length < _minPoints) return null;
  final unit = unitOf(sorted.first.bbt) ?? 'c';
  final values = sorted.map((e) => e.bbt);
  final low = values.reduce(math.min) - _padding[unit]!;
  final high = values.reduce(math.max) + _padding[unit]!;
  final span = (high - low) == 0 ? 1 : high - low;
  int? day(String at) {
    if (cycleStart == null) return null;
    final d = diffDays(cycleStart, at) + 1;
    return d >= 1 ? d : null;
  }

  return BbtChart(
    [for (final e in sorted) BbtPoint(e.id, e.loggedAt, day(e.loggedAt), e.bbt, (e.bbt - low) / span)],
    low,
    high,
    unit,
  );
}
