/// Charts built from what she has entered in her record (R11.5). Pure: no UI, no clock.
///
/// Why it exists: the record holds her blood pressure, glucose and lab results. When she
/// has at least two readings of the same thing, in the same unit, femio can draw them. This
/// file decides which series exist and where each dot sits; the widgets only paint it.
///
/// Rules it holds to (CLAUDE.md rules 1 and 3):
/// - Units stay exactly as she entered them. A mg/dL series and a mmol/L series are two
///   series and are never converted or joined.
/// - The only range ever drawn is the one printed on her own report ([parsePrintedRange]);
///   if it does not parse, there is no band. femio adds no range, target or threshold.
/// - Nothing here says high, low, normal or good. The numbers are geometry, not meaning.
/// - The x-axis is the day each reading happened, at real spacing: two readings a week
///   apart sit closer than two readings a month apart.
library;

import 'dart:math' as math;

import 'health_record.dart';

/// What a series is made of.
enum ChartKind { bloodPressure, glucose, lab }

/// The unit of every blood-pressure series.
const bloodPressureUnit = 'mmHg';

/// A series needs this many readings before it is drawn: a dot is not a pattern.
const chartMinReadings = 2;

/// The range printed on her report, parsed into two numbers.
class PrintedRange {
  const PrintedRange(this.low, this.high);
  final double low;
  final double high;

  @override
  bool operator ==(Object other) => other is PrintedRange && other.low == low && other.high == high;

  @override
  int get hashCode => Object.hash(low, high);

  @override
  String toString() => 'PrintedRange($low, $high)';
}

/// One plotted reading: the record entry it comes from, its day, and its number(s).
class ChartReading {
  const ChartReading({required this.entry, required this.value, this.second});

  /// The entry, so a list can show it exactly as she wrote it.
  final RecordEntry entry;

  /// The number plotted (systolic for blood pressure).
  final double value;

  /// The second number plotted (diastolic), only for blood pressure.
  final double? second;

  /// ISO day it happened.
  String get day => entry.happenedOn;
}

/// One chart: its readings in date order, its axis and the printed band if she has one.
class ChartSeries {
  ChartSeries({required this.id, required this.kind, required this.title, required this.unit, required this.readings})
    : band = _bandOf(readings),
      _axis = _axisFor(readings, _bandOf(readings));

  /// Stable key: `bp`, `glucose:<unit>` or `lab:<title>|<unit>`.
  final String id;
  final ChartKind kind;

  /// Her own title for a lab; empty for blood pressure and glucose (the screen names those).
  final String title;

  /// The unit as she entered it (`mmHg` for blood pressure).
  final String unit;

  /// Oldest day first; the same day by the order she added them.
  final List<ChartReading> readings;

  /// The range printed on her most recent reading of this series, or null (no band).
  final PrintedRange? band;

  final ({double low, double high, int decimals}) _axis;

  /// The bottom of the y-axis, rounded to a clean step (never a target).
  double get axisLow => _axis.low;

  /// The top of the y-axis, rounded to a clean step.
  double get axisHigh => _axis.high;

  /// How many decimals the axis labels need.
  int get axisDecimals => _axis.decimals;

  /// Each reading's place along the x-axis, 0 to 1, by real days between readings. When
  /// every reading is on one day they sit in the middle.
  List<double> get xs {
    final first = DateTime.parse('${readings.first.day}T00:00:00Z');
    final spans = [for (final r in readings) DateTime.parse('${r.day}T00:00:00Z').difference(first).inDays];
    final last = spans.last;
    return [for (final d in spans) last == 0 ? 0.5 : d / last];
  }

  /// The plotted number of each reading, 0 (axis bottom) to 1 (axis top).
  List<double> get ys => [for (final r in readings) _unit(r.value)];

  /// The second number (diastolic) of each reading, or empty when the series has none.
  List<double> get ys2 => [
    if (kind == ChartKind.bloodPressure)
      for (final r in readings) _unit(r.second ?? r.value),
  ];

  /// The band as 0–1 y positions, clamped to the axis, or null.
  ({double low, double high})? get bandY {
    final b = band;
    return b == null ? null : (low: _unit(b.low).clamp(0.0, 1.0), high: _unit(b.high).clamp(0.0, 1.0));
  }

  double _unit(double v) => (v - _axis.low) / (_axis.high - _axis.low);
}

/// Every series she can chart, in the order the Charts list shows them: blood pressure,
/// glucose (one per unit), then lab tests by name. Series with fewer than
/// [chartMinReadings] readings are left out. Entries whose numbers do not read as plain
/// numbers are left out of the chart (they stay in her record).
List<ChartSeries> buildChartSeries(Iterable<RecordEntry> record) {
  final ordered = [...record]
    ..sort((a, b) {
      final byDay = a.happenedOn.compareTo(b.happenedOn);
      return byDay != 0 ? byDay : a.addedOn.compareTo(b.addedOn);
    });

  final bp = <ChartReading>[];
  final glucose = <String, List<ChartReading>>{};
  final glucoseUnit = <String, String>{};
  final labs = <String, List<ChartReading>>{};
  final labTitle = <String, String>{};
  final labUnit = <String, String>{};

  for (final e in ordered) {
    switch (e.kind) {
      case RecordKind.bloodPressure:
        final s = parseReadingNumber(e.fields[RecordField.systolic] ?? '');
        final d = parseReadingNumber(e.fields[RecordField.diastolic] ?? '');
        if (s != null && d != null) bp.add(ChartReading(entry: e, value: s, second: d));
      case RecordKind.glucose:
        final v = parseReadingNumber(e.fields[RecordField.value] ?? '');
        final u = (e.fields[RecordField.unit] ?? '').trim();
        if (v == null || u.isEmpty) break;
        final key = _unitKey(u);
        glucose.putIfAbsent(key, () => []).add(ChartReading(entry: e, value: v));
        glucoseUnit[key] = u;
      case RecordKind.lab:
        final v = parseReadingNumber(e.fields[RecordField.value] ?? '');
        final title = e.title.trim();
        if (v == null || title.isEmpty) break;
        final u = (e.fields[RecordField.unit] ?? '').trim();
        final key = '${_titleKey(title)}|${_unitKey(u)}';
        labs.putIfAbsent(key, () => []).add(ChartReading(entry: e, value: v));
        // The newest spelling of the name and unit is the one drawn.
        labTitle[key] = title;
        labUnit[key] = u;
      default:
        break;
    }
  }

  final out = <ChartSeries>[
    if (bp.length >= chartMinReadings)
      ChartSeries(id: 'bp', kind: ChartKind.bloodPressure, title: '', unit: bloodPressureUnit, readings: bp),
    for (final k in (glucose.keys.toList()..sort()))
      if (glucose[k]!.length >= chartMinReadings)
        ChartSeries(id: 'glucose:$k', kind: ChartKind.glucose, title: '', unit: glucoseUnit[k]!, readings: glucose[k]!),
  ];
  final labKeys = [
    for (final k in labs.keys)
      if (labs[k]!.length >= chartMinReadings) k,
  ]..sort((a, b) => labTitle[a]!.toLowerCase().compareTo(labTitle[b]!.toLowerCase()));
  for (final k in labKeys) {
    out.add(ChartSeries(id: 'lab:$k', kind: ChartKind.lab, title: labTitle[k]!, unit: labUnit[k]!, readings: labs[k]!));
  }
  return out;
}

/// A reading typed as a plain number: Western or Arabic-Indic digits, `.` `,` or `٫` as the
/// decimal mark. Returns null for anything else ("<0.5", "positive", "5 to 6").
double? parseReadingNumber(String raw) {
  final s = _westernDigits(raw).trim();
  if (!RegExp(r'^\d+(?:[.,٫]\d+)?$').hasMatch(s)) return null;
  return _toNumber(s);
}

/// Reads a printed range such as "0.4–4.0", "0.4 - 4.0 mIU/L", "(30 to 100)" or "٠٫٤-٤٫٠"
/// into its two ends. Returns null when it is not exactly one low–high pair with the low
/// below the high (one-sided ranges such as "<5" included), so the chart shows no band.
PrintedRange? parsePrintedRange(String raw) {
  final s = _westernDigits(raw).trim();
  const num = r'(\d+(?:[.,٫]\d+)?)';
  final m = RegExp(
    r'^[\(\[\s]*' + num + r'\s*(?:[-–—−~]|to|إلى|à)\s*' + num + r'[^\d]*$',
    caseSensitive: false,
  ).firstMatch(s);
  if (m == null) return null;
  final low = _toNumber(m.group(1)!);
  final high = _toNumber(m.group(2)!);
  if (low == null || high == null || !(low < high)) return null;
  return PrintedRange(low, high);
}

/// Clean axis ends around [low] and [high] (and room either side), on a 1, 2 or 5 step,
/// with an even number of steps so the middle gridline is a clean number too. Exposed for
/// tests; it is geometry only.
({double low, double high, int decimals}) niceAxis(double low, double high) {
  var span = high - low;
  if (span <= 0) span = math.max(low.abs() * 0.1, 1);
  final raw = span / 4;
  final mag = math.pow(10, (math.log(raw) / math.ln10).floor()).toDouble();
  final norm = raw / mag;
  final step = (norm <= 1 ? 1 : norm <= 2 ? 2 : norm <= 5 ? 5 : 10) * mag;
  var lo = (low / step).floor() * step;
  var hi = (high / step).ceil() * step;
  if (hi == lo) hi = lo + step;
  // Keep one step of air around the extremes so no dot sits on the frame.
  if ((low - lo) < step * 0.25) lo -= step;
  if ((hi - high) < step * 0.25) hi += step;
  if (((hi - lo) / step).round().isOdd) hi += step;
  var decimals = 0;
  while (decimals < 4 && ((step * math.pow(10, decimals)) - (step * math.pow(10, decimals)).round()).abs() > 1e-9) {
    decimals++;
  }
  return (low: _tidy(lo, decimals), high: _tidy(hi, decimals), decimals: decimals);
}

double _tidy(double v, int decimals) => double.parse(v.toStringAsFixed(decimals));

PrintedRange? _bandOf(List<ChartReading> readings) {
  for (final r in readings.reversed) {
    final raw = r.entry.fields[RecordField.printedRange];
    if (raw != null) return parsePrintedRange(raw);
  }
  return null;
}

({double low, double high, int decimals}) _axisFor(List<ChartReading> readings, PrintedRange? band) {
  final values = [
    for (final r in readings) ...[r.value, ?r.second],
    ?band?.low,
    ?band?.high,
  ];
  return niceAxis(values.reduce(math.min), values.reduce(math.max));
}

String _unitKey(String u) => u.replaceAll(RegExp(r'\s+'), '').toLowerCase();

String _titleKey(String t) => t.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

double? _toNumber(String s) {
  // "1,000" is a thousand; "0,4" is four tenths.
  final cleaned = RegExp(r'^\d{1,3}(,\d{3})+(\.\d+)?$').hasMatch(s) ? s.replaceAll(',', '') : s.replaceAll(RegExp(r'[,٫]'), '.');
  return double.tryParse(cleaned);
}

String _westernDigits(String s) {
  final b = StringBuffer();
  for (final c in s.runes) {
    if (c >= 0x0660 && c <= 0x0669) {
      b.writeCharCode(0x30 + c - 0x0660);
    } else if (c >= 0x06F0 && c <= 0x06F9) {
      b.writeCharCode(0x30 + c - 0x06F0);
    } else {
      b.writeCharCode(c);
    }
  }
  return b.toString();
}
