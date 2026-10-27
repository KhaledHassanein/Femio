// The weight screen: her readings drawn as they are.
//
// Why it exists: she may want her numbers for her notes. There is no target band and no
// expected gain (domain/weight.dart); judging the trend is for her clinician.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/dates.dart';
import '../../domain/weight.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/readings_chart.dart';

/// Weight readings, drawn as they are. No target band and no "expected gain"
/// (`domain/weight.dart`): her dots, her numbers, for her notes.
class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key, required this.controller, required this.today});
  final FemioController controller;
  final String today;

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final _value = TextEditingController();
  late String _unit = widget.controller.profile!.weights.lastOrNull?.unit ?? 'kg';
  late String _date = widget.today;
  String? _error;

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = L10n.of(context);
    final v = double.tryParse(_value.text.trim().replaceAll(',', '.').replaceAll('٫', '.'));
    if (v == null || !isPlausibleWeight(v, _unit)) {
      setState(() => _error = l.weightInvalid);
      return;
    }
    final profile = widget.controller.profile!;
    final entry = WeightEntry('w${DateTime.now().microsecondsSinceEpoch}', _date, v, _unit);
    await widget.controller.save(profile.copyWith(weights: [...profile.weights, entry]));
    _value.clear();
    setState(() => _error = null);
    if (mounted) FocusScope.of(context).unfocus();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fromISO(_date),
      firstDate: fromISO(widget.today).subtract(const Duration(days: 400)),
      lastDate: fromISO(widget.today),
    );
    if (picked != null) setState(() => _date = toISO(picked));
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    String unitLabel(String u) => u == 'kg' ? l.weightUnitKg : l.weightUnitLb;
    String fmt(double v) => v.toStringAsFixed(1);

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final weights = widget.controller.profile!.weights;
        final chart = weightChart(weights);
        final sorted = [...weights]..sort((a, b) => b.measuredOn.compareTo(a.measuredOn));
        return Scaffold(
          appBar: AppBar(title: Text(l.weightHeading)),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(space5, space2, space5, space8),
            children: [
              Text(l.weightIntro, style: t.bodyMedium),
              const SizedBox(height: space4),
              Container(
                padding: const EdgeInsets.all(space4h),
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(radiusLg),
                  border: Border.all(color: p.border),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (chart == null)
                    Text(l.weightNeedData, style: t.bodySmall)
                  else ...[
                    ReadingsChart(
                      ys: [for (final x in chart.points) x.y],
                      low: chart.low,
                      high: chart.high,
                      unit: ' ${unitLabel(chart.unit)}',
                      decimals: 1,
                      semanticsLabel:
                          '${l.weightHeading}: ${chart.points.map((x) => '${fmt(x.value)} ${unitLabel(x.unit)}').join(', ')}',
                    ),
                    const SizedBox(height: space2),
                    if (chart.changeSinceFirst != null)
                      Text(
                        l.weightChange(
                          '${chart.changeSinceFirst! > 0 ? '+' : ''}${fmt(chart.changeSinceFirst!)}',
                          unitLabel(chart.unit),
                        ),
                        style: t.titleMedium,
                      ),
                    const SizedBox(height: space1h),
                    Text(l.weightNote, style: t.bodySmall),
                  ],
                ]),
              ),
              const SizedBox(height: space5),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  child: TextField(
                    controller: _value,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: l.weightValue,
                      filled: true,
                      fillColor: p.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusMd)),
                    ),
                    onSubmitted: (_) => _save(),
                  ),
                ),
                const SizedBox(width: space2),
                SegmentedButton<String>(
                  showSelectedIcon: false,
                  segments: [for (final u in weightUnits) ButtonSegment(value: u, label: Text(unitLabel(u)))],
                  selected: {_unit},
                  onSelectionChanged: (s) => setState(() => _unit = s.first),
                ),
              ]),
              const SizedBox(height: space2),
              TextButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.event_outlined),
                label: Text('${l.weightDate}: ${DateFormat.yMMMd(locale).format(fromISO(_date))}'),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: space3, bottom: space1h),
                  child: Text(_error!, style: t.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error)),
                ),
              FilledButton(onPressed: _save, child: Text(l.weightSave)),
              const SizedBox(height: space5),
              for (final w in sorted)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: space1),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: p.border))),
                  child: Row(children: [
                    Expanded(child: Text(DateFormat.yMMMd(locale).format(fromISO(w.measuredOn)), style: t.bodyMedium)),
                    Text('${fmt(w.value)} ${unitLabel(w.unit)}', style: t.titleMedium),
                    IconButton(
                      tooltip: l.apptDelete,
                      icon: Icon(Icons.close_rounded, size: 20, color: p.textSubtle),
                      onPressed: () {
                        final profile = widget.controller.profile!;
                        widget.controller.save(profile.copyWith(weights: [
                          for (final x in profile.weights)
                            if (x.id != w.id) x,
                        ]));
                      },
                    ),
                  ]),
                ),
            ],
          ),
        );
      },
    );
  }
}
