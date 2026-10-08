import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../data/profile.dart';
import '../../domain/bbt.dart';
import '../../domain/dates.dart';
import '../../domain/log_vocabulary.g.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/log_labels.g.dart';
import '../../theme/femio_theme.dart';

/// One day's log. Every tap saves (no save button to forget); the vocabulary is the
/// website's, generated (`scripts/mobile/sync-log-vocabulary.mjs`), and every term is
/// available whatever her goal (rule 2).
class LogScreen extends StatelessWidget {
  const LogScreen({
    super.key,
    required this.controller,
    required this.today,
    required this.date,
    required this.onDateChanged,
  });
  final FemioController controller;
  final String today;
  final String date;
  final ValueChanged<String> onDateChanged;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final profile = controller.profile!;
        final log = profile.logs[date] ??
            (profile.periodStarts.contains(date) ? const DayLog(flow: 'medium') : const DayLog());

        void save(DayLog next) => controller.setDayLog(date, next);
        void setFlow(String? flow) => save(log.copyWith(flow: flow));
        void toggle(String key) {
          final terms = [...log.terms];
          terms.contains(key) ? terms.remove(key) : terms.add(key);
          save(log.copyWith(terms: terms));
        }

        Widget section(String title, List<Widget> chips) => Padding(
              padding: const EdgeInsets.only(top: 22),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Semantics(header: true, child: Text(title, style: t.titleMedium)),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: chips),
              ]),
            );

        Widget termChips(LogDimension d, Color tint, Color ink) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final term in logTerms.where((x) => x.dimension == d))
                  _Chip(
                    label: logLabel(l, term.key),
                    selected: log.terms.contains(term.key),
                    // Elevated terms stay quiet on a shared screen (vocabulary.ts).
                    tint: term.elevated ? p.surfaceSunken : tint,
                    ink: term.elevated ? p.text : ink,
                    onTap: () => toggle(term.key),
                  ),
              ],
            );

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              Semantics(header: true, child: Text(l.logTitle, style: t.headlineMedium)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: p.border),
                ),
                child: Row(children: [
                  IconButton(
                    onPressed: () => onDateChanged(addDays(date, -1)),
                    icon: const Icon(Icons.chevron_left_rounded),
                    tooltip: l.previousDay,
                  ),
                  Expanded(
                    child: Text(
                      date == today ? '${l.navToday} · ${DateFormat.MMMd(locale).format(fromISO(date))}'
                          : DateFormat.MMMMEEEEd(locale).format(fromISO(date)),
                      textAlign: TextAlign.center,
                      style: t.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: date.compareTo(today) >= 0 ? null : () => onDateChanged(addDays(date, 1)),
                    icon: const Icon(Icons.chevron_right_rounded),
                    tooltip: l.nextDay,
                  ),
                ]),
              ),
              section(l.sectionPeriod, [
                _Chip(
                  label: l.flowNone,
                  selected: log.flow == null,
                  tint: p.surfaceSunken,
                  ink: p.text,
                  onTap: () => setFlow(null),
                ),
                for (final f in flowLevels)
                  _Chip(
                    label: flowLabel(l, f),
                    selected: log.flow == f,
                    tint: p.logPeriodAlt,
                    ink: p.logPeriod,
                    icon: Icons.water_drop_rounded,
                    onTap: () => setFlow(f),
                  ),
              ]),
              section(l.sectionMood, [termChips(LogDimension.mood, p.logMoodAlt, p.logMood)]),
              section(l.sectionSymptoms, [termChips(LogDimension.symptom, p.logSymptomAlt, p.logSymptom)]),
              section(l.sectionDischarge, [termChips(LogDimension.discharge, p.logDischargeAlt, p.logDischarge)]),
              section(l.sectionOvulationTest, [
                for (final r in opkResults)
                  _Chip(
                    label: opkLabel(l, r),
                    selected: log.opk == r,
                    tint: p.successSoft,
                    ink: p.successText,
                    onTap: () => save(log.copyWith(opk: log.opk == r ? null : r)),
                  ),
              ]),
              section(l.sectionTemperature, [
                _TemperatureField(
                  key: ValueKey('bbt-$date'),
                  initial: log.bbt,
                  hint: l.temperatureHint,
                  saveLabel: l.temperatureSave,
                  clearLabel: l.temperatureClear,
                  invalid: l.invalidBbt,
                  onSave: (v) => save(log.copyWith(bbt: v)),
                ),
              ]),
              section(l.sectionMore, [termChips(LogDimension.intercourse, p.surfaceSunken, p.text)]),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.lock_outline_rounded, size: 16, color: p.textSubtle),
                const SizedBox(width: 6),
                Flexible(child: Text(l.logSavedNote, style: t.bodySmall)),
              ]),
            ],
          ),
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.tint,
    required this.ink,
    required this.onTap,
    this.icon,
  });
  final String label;
  final bool selected;
  final Color tint;
  final Color ink;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? tint : p.surface,
        shape: StadiumBorder(side: BorderSide(color: selected ? ink : p.border, width: selected ? 1.5 : 1)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (selected) ...[Icon(icon ?? Icons.check_rounded, size: 16, color: ink), const SizedBox(width: 6)],
                Text(label,
                    style: TextStyle(
                      color: selected ? ink : p.text,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    )),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// Waking temperature, typed. Rejects only what no thermometer produced (a typo guard,
/// `isPlausibleBbt`); a plausible number is never commented on.
class _TemperatureField extends StatefulWidget {
  const _TemperatureField({
    super.key,
    required this.initial,
    required this.hint,
    required this.saveLabel,
    required this.clearLabel,
    required this.invalid,
    required this.onSave,
  });
  final double? initial;
  final String hint;
  final String saveLabel;
  final String clearLabel;
  final String invalid;
  final ValueChanged<double?> onSave;

  @override
  State<_TemperatureField> createState() => _TemperatureFieldState();
}

class _TemperatureFieldState extends State<_TemperatureField> {
  late final _controller = TextEditingController(text: widget.initial?.toString() ?? '');
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final text = _controller.text.trim().replaceAll(',', '.').replaceAll('٫', '.');
    final value = double.tryParse(text);
    if (value == null || unitOf(value) == null) {
      setState(() => _error = widget.invalid);
      return;
    }
    setState(() => _error = null);
    widget.onSave(value);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final theme = Theme.of(context);
    // The hint and the error sit under the whole row, in her reading direction: the
    // field itself is LTR (numbers), and a helper inside it would be clipped to the
    // field's width and drawn left-aligned in Arabic.
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          child: TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              hintText: '36.5',
              filled: true,
              fillColor: p.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              enabledBorder: _error == null
                  ? null
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: theme.colorScheme.error),
                    ),
            ),
            onSubmitted: (_) => _save(),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(88, 52)),
          onPressed: _save,
          child: Text(widget.saveLabel),
        ),
        if (widget.initial != null)
          IconButton(
            tooltip: widget.clearLabel,
            onPressed: () {
              _controller.clear();
              widget.onSave(null);
            },
            icon: const Icon(Icons.close_rounded),
          ),
      ]),
      const SizedBox(height: 6),
      Padding(
        padding: const EdgeInsetsDirectional.only(start: 12),
        child: Text(
          _error ?? widget.hint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: _error == null ? p.textMuted : theme.colorScheme.error,
          ),
        ),
      ),
    ]);
  }
}
