// The pregnancy weight-gain tool: the IOM reference range for her BMI before
// pregnancy (R11.3, MR-54).
//
// Why it exists: "how much weight should I gain?" is a top pregnancy question, and the
// answer has one trusted public source (Institute of Medicine 2009, used by CDC and
// ACOG). The screen shows that range as a reference, never a target or a verdict, and
// saves nothing. The weight screen in pregnancy tools still draws her own readings
// with no band (`domain/weight.dart`). The arithmetic is `weightGainRange`.
//
// Kilograms and centimetres only: the wedge (Saudi Arabia and Egypt) measures in
// metric; the pound range is shown as a second line.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../domain/weight_gain.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import 'tool_widgets.dart';

/// Arabic-Indic and Persian digits a phone keyboard may type, mapped to 0-9.
const _easternDigits = '٠١٢٣٤٥٦٧٨٩';
const _persianDigits = '۰۱۲۳۴۵۶۷۸۹';

/// A number she typed, with a comma or the Arabic decimal mark as the point and any
/// Eastern digits read as Western ones. Null when it is not a number.
double? parseTypedNumber(String raw) {
  final buffer = StringBuffer();
  for (final ch in raw.trim().split('')) {
    final eastern = _easternDigits.indexOf(ch);
    final persian = _persianDigits.indexOf(ch);
    if (eastern >= 0) {
      buffer.write(eastern);
    } else if (persian >= 0) {
      buffer.write(persian);
    } else if (ch == ',' || ch == '٫') {
      buffer.write('.');
    } else {
      buffer.write(ch);
    }
  }
  return double.tryParse(buffer.toString());
}

/// The weight-gain tool.
class WeightGainScreen extends StatefulWidget {
  const WeightGainScreen({super.key});

  @override
  State<WeightGainScreen> createState() => _WeightGainScreenState();
}

class _WeightGainScreenState extends State<WeightGainScreen> {
  final _weight = TextEditingController();
  final _height = TextEditingController();
  int _babies = 1;

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final number = NumberFormat.decimalPatternDigits(
      locale: Localizations.localeOf(context).toLanguageTag(),
      decimalDigits: 1,
    );
    String fmt(num v) => v == v.roundToDouble() ? v.round().toString() : number.format(v);
    final bands = {
      BmiBand.underweight: l.toolBandUnderweight,
      BmiBand.normal: l.toolBandNormal,
      BmiBand.overweight: l.toolBandOverweight,
      BmiBand.obese: l.toolBandObese,
    };

    final w = parseTypedNumber(_weight.text);
    final h = parseTypedNumber(_height.text);
    final bothTyped = _weight.text.trim().isNotEmpty && _height.text.trim().isNotEmpty;
    final result = w == null || h == null ? null : weightGainRange(w, h, _babies);

    InputDecoration field(String label) => InputDecoration(
          labelText: label,
          filled: true,
          fillColor: p.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusMd)),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.toolGainTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(space5, space2, space5, space8),
        children: [
          Text(l.toolGainIntro, style: t.bodyMedium),
          const SizedBox(height: space4),
          TextField(
            key: const ValueKey('gain-weight'),
            controller: _weight,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: field(l.toolGainWeight),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: space3),
          TextField(
            key: const ValueKey('gain-height'),
            controller: _height,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: field(l.toolGainHeight),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: space4),
          ToolChoice<int>(
            label: l.toolGainBabiesLabel,
            options: {1: l.toolGainBabiesOne, 2: l.toolGainBabiesTwo, multiples: l.toolGainBabiesMore},
            value: _babies,
            onChanged: (b) => setState(() => _babies = b),
          ),
          if (bothTyped && result == null) ...[
            const SizedBox(height: space4),
            Text(
              l.toolGainOutOfRange('$minWeightKg', '$maxWeightKg', '$minHeightCm', '$maxHeightCm'),
              style: t.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (result != null) ...[
            const SizedBox(height: space5),
            ToolResult(
              eyebrow: l.toolGainEyebrow,
              headline: switch (result.noRangeReason) {
                NoRangeReason.twinsUnderweight => l.toolGainNoRangeTwins,
                NoRangeReason.multiples => l.toolGainNoRangeMultiples,
                null => l.toolGainRangeKg(fmt(result.range!.lowKg), fmt(result.range!.highKg)),
              },
              lines: [
                if (result.range != null)
                  l.toolGainOtherUnit(l.toolGainRangeLb(fmt(result.range!.lowLb), fmt(result.range!.highLb))),
                l.toolGainBmiLine(number.format(result.bmi), bands[result.band]!),
              ],
            ),
            ToolNote(l.toolGainNote),
            ToolNote(l.toolGainSource),
          ],
        ],
      ),
    );
  }
}
