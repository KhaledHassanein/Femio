import 'dart:math' as math;

import 'dates.dart';

/// The next-period prediction. Twin of `apps/web/src/lib/cycle/predict.ts`, checked
/// by the same golden fixtures (`fixtures/domain/cycle-prediction.json`). The
/// reasoning behind every constant lives in the TypeScript file's comments; this
/// file keeps the arithmetic identical rather than restating it.
///
/// Uncertainty-honest by construction (product rule 3): a window and a confidence,
/// never a single certain date, and nothing here supports a "late" counter.

enum Confidence { high, medium, low }

class PredictionEvidence {
  const PredictionEvidence({
    required this.cyclesUsed,
    required this.spread,
    required this.margin,
    required this.recentWindow,
    required this.rule,
  });
  final int cyclesUsed;
  final int spread;
  final int margin;
  final int recentWindow;

  /// `stated` (from what she told onboarding) or `observed` (from her logs).
  final String rule;

  Map<String, Object> toJson() => {
        'cyclesUsed': cyclesUsed,
        'spread': spread,
        'margin': margin,
        'recentWindow': recentWindow,
        'rule': rule,
      };
}

class CyclePrediction {
  const CyclePrediction({
    required this.averageLength,
    required this.basis,
    required this.predictedStart,
    required this.windowStart,
    required this.windowEnd,
    required this.confidence,
    required this.irregular,
    required this.learning,
    required this.evidence,
  });
  final int averageLength;
  final String basis;
  final String predictedStart;
  final String windowStart;
  final String windowEnd;
  final Confidence confidence;
  final bool irregular;
  final bool learning;
  final PredictionEvidence evidence;

  Map<String, Object> toJson() => {
        'averageLength': averageLength,
        'basis': basis,
        'predictedStart': predictedStart,
        'windowStart': windowStart,
        'windowEnd': windowEnd,
        'confidence': confidence.name,
        'irregular': irregular,
        'learning': learning,
        'evidence': evidence.toJson(),
      };
}

const _statedMarginDays = 4;
const _sameBleedWithinDays = 10;
const _recentCycles = 6;
const _maxPlausibleCycleDays = 90;

/// Logged dates collapsed to one start per bleed (consecutive days are one period).
List<String> bleedStarts(List<String> dates) {
  final sorted = dates.where(isValidISODate).toSet().toList()..sort();
  final starts = <String>[];
  // From the previous bleeding day, not the run's first day: a 12-day bleed is one
  // period (twin of predict.ts `bleedStarts`, audit appendix S02).
  String? previous;
  for (final date in sorted) {
    if (previous == null || diffDays(previous, date) > _sameBleedWithinDays) {
      starts.add(date);
    }
    previous = date;
  }
  return starts;
}

CyclePrediction _fromStated(String last, int stated) {
  final predictedStart = addDays(last, stated);
  return CyclePrediction(
    averageLength: stated,
    basis: 'stated',
    predictedStart: predictedStart,
    windowStart: addDays(predictedStart, -_statedMarginDays),
    windowEnd: addDays(predictedStart, _statedMarginDays),
    confidence: Confidence.low,
    irregular: false,
    learning: true,
    evidence: const PredictionEvidence(
      cyclesUsed: 0,
      spread: 0,
      margin: _statedMarginDays,
      recentWindow: 0,
      rule: 'stated',
    ),
  );
}

CyclePrediction? predictNextPeriod(List<String> starts, [int? statedCycleLength]) {
  final sorted = bleedStarts(starts);
  if (sorted.isEmpty) return null;

  final stated = statedCycleLength != null && statedCycleLength >= 21 && statedCycleLength <= 35
      ? statedCycleLength
      : null;

  if (sorted.length < 2) {
    return stated == null ? null : _fromStated(sorted.first, stated);
  }

  final lengths = <int>[
    for (var i = 1; i < sorted.length; i++) diffDays(sorted[i - 1], sorted[i]),
  ];
  final usable = lengths.where((n) => n <= _maxPlausibleCycleDays).toList();
  if (usable.isEmpty) {
    return stated == null ? null : _fromStated(sorted.last, stated);
  }

  final recent = usable.length > _recentCycles ? usable.sublist(usable.length - _recentCycles) : usable;
  // JavaScript's Math.round rounds .5 up; Dart's round() rounds half away from zero.
  // Lengths are positive, so the two agree.
  final averageLength = (recent.reduce((a, b) => a + b) / recent.length).round();
  final spread = lengths.reduce(math.max) - lengths.reduce(math.min);
  final predictedStart = addDays(sorted.last, averageLength);
  final margin = math.max(2, (spread / 2).ceil());
  final learning = lengths.length < 2;
  final irregular = !learning && spread > 9;

  final Confidence confidence;
  if (lengths.length >= 6 && spread <= 4) {
    confidence = Confidence.high;
  } else if (lengths.length >= 3 && spread <= 9) {
    confidence = Confidence.medium;
  } else {
    confidence = Confidence.low;
  }

  return CyclePrediction(
    averageLength: averageLength,
    basis: 'observed',
    predictedStart: predictedStart,
    windowStart: addDays(predictedStart, -margin),
    windowEnd: addDays(predictedStart, margin),
    confidence: confidence,
    irregular: irregular,
    learning: learning,
    evidence: PredictionEvidence(
      cyclesUsed: lengths.length,
      spread: spread,
      margin: margin,
      recentWindow: recent.length,
      rule: 'observed',
    ),
  );
}
