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

/// MR-03: the stated cycle lengths that earn a period range. 36-45 gets a low-confidence
/// range; the fertile window stays withheld outside 21-35 (MR-08). Onboarding's stepper
/// offers exactly this span.
const statedCycleMinDays = 21;
const statedCycleMaxDays = 45;

/// MR-57 (owner 2026-11-26): her stated length stands in until she has logged this many
/// starts, so logging a second period never makes the calendar show less.
const statedUntilStarts = 3;
const _sameBleedWithinDays = 10;
const _recentCycles = 6;
const _maxPlausibleCycleDays = 90;

/// Cycles whose shortest and longest differ by more than this many days count as irregular.
/// Named so the explainer (`prediction_explain.dart`) quotes the same numbers the rule uses.
const irregularSpreadDays = 9;

/// High confidence: at least this many cycles, varying by at most [highConfidenceSpreadDays].
const highConfidenceCycles = 6;
const highConfidenceSpreadDays = 4;

/// Medium confidence: at least this many cycles, varying by at most [irregularSpreadDays].
const mediumConfidenceCycles = 3;

/// Logged dates collapsed to one start per bleed (consecutive days are one period).
List<String> bleedStarts(List<String> dates) {
  final sorted = dates.where(isValidISODate).toSet().toList()..sort();
  final starts = <String>[];
  for (final date in sorted) {
    if (starts.isEmpty || diffDays(starts.last, date) > _sameBleedWithinDays) {
      starts.add(date);
    }
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

  final stated = statedCycleLength != null &&
          statedCycleLength >= statedCycleMinDays &&
          statedCycleLength <= statedCycleMaxDays
      ? statedCycleLength
      : null;

  if (sorted.length == 1 && stated == null) return null;
  if (sorted.length < statedUntilStarts && stated != null) return _fromStated(sorted.last, stated);

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
  final irregular = !learning && spread > irregularSpreadDays;

  final Confidence confidence;
  if (lengths.length >= highConfidenceCycles && spread <= highConfidenceSpreadDays) {
    confidence = Confidence.high;
  } else if (lengths.length >= mediumConfidenceCycles && spread <= irregularSpreadDays) {
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
