// The small building blocks the Tools screens share (R11).
//
// Why it exists: the due-date, pregnancy-calendar and weight-gain screens ask for a
// choice, a number or a date, then draw one result card. Keeping those pieces here
// means the three screens look alike and none of them repeats layout code. Nothing in
// this file calculates: the numbers come from `lib/domain/`.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../domain/dates.dart';
import '../../domain/hijri.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';

/// The smallest comfortable tap target for the stepper buttons (Material: 48 dp).
const double _tapTarget = 48;

/// A short date in her language ("12 Mar 2027"), Western digits in Arabic (ADR-069,
/// set once in `main.dart`).
String toolDate(BuildContext context, String iso) =>
    DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag()).format(fromISO(iso));

/// A labelled row of chips; exactly one is selected.
///
/// [options] maps each value to its already-localised label.
class ToolChoice<T> extends StatelessWidget {
  const ToolChoice({super.key, required this.label, required this.options, required this.value, required this.onChanged});

  final String label;
  final Map<T, String> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.titleSmall),
        const SizedBox(height: space2),
        Wrap(
          spacing: space2,
          runSpacing: space2,
          children: [
            for (final entry in options.entries)
              ChoiceChip(
                label: Text(entry.value),
                selected: entry.key == value,
                onSelected: (_) => onChanged(entry.key),
              ),
          ],
        ),
      ],
    );
  }
}

/// A compact − / + number in one line, for screens with more than one number.
///
/// [value] stays within [min] and [max]; [valueLabel] is the localised value
/// ("12 weeks"); a screen reader hears "[label]: [valueLabel]".
class ToolStepper extends StatelessWidget {
  const ToolStepper({
    super.key,
    required this.label,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final String valueLabel;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    Widget button(IconData icon, VoidCallback? onTap, String tooltip) => IconButton.filledTonal(
          onPressed: onTap,
          icon: Icon(icon),
          tooltip: tooltip,
          style: IconButton.styleFrom(
            minimumSize: const Size(_tapTarget, _tapTarget),
            backgroundColor: p.primarySoft,
            foregroundColor: p.primarySoftText,
          ),
        );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: space2, horizontal: space3),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusLg),
        border: Border.all(color: p.border),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: t.bodyMedium?.copyWith(color: p.textMuted))),
          button(Icons.remove_rounded, value > min ? () => onChanged(value - 1) : null, '−'),
          SizedBox(
            width: space12 * 2,
            child: Semantics(
              liveRegion: true,
              label: '$label: $valueLabel',
              excludeSemantics: true,
              child: Text(valueLabel, textAlign: TextAlign.center, style: t.titleMedium),
            ),
          ),
          button(Icons.add_rounded, value < max ? () => onChanged(value + 1) : null, '+'),
        ],
      ),
    );
  }
}

/// The result: a soft card with a small eyebrow, a large headline, and lines under it.
class ToolResult extends StatelessWidget {
  const ToolResult({super.key, this.eyebrow, required this.headline, this.lines = const [], this.children = const []});

  final String? eyebrow;
  final String headline;
  final List<String> lines;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(space4h),
        decoration: BoxDecoration(
          color: p.primarySoft,
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (eyebrow != null) ...[
              Text(eyebrow!, style: t.labelLarge?.copyWith(color: p.primarySoftText)),
              const SizedBox(height: space1h),
            ],
            Text(headline, style: t.headlineSmall?.copyWith(color: p.text)),
            for (final line in lines) ...[
              const SizedBox(height: space1h),
              Text(line, style: t.bodyMedium?.copyWith(color: p.text)),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}

/// The Hijri date beside a Gregorian one (rule 6), small and muted; empty when the
/// Hijri date is unavailable.
class HijriLine extends StatelessWidget {
  const HijriLine({super.key, required this.iso});
  final String iso;

  @override
  Widget build(BuildContext context) {
    final text = hijriFullDate(iso, Localizations.localeOf(context).toLanguageTag());
    if (text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: space1),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.palette.textMuted)),
    );
  }
}

/// A small muted note under a result (the estimate line, the clinician line, a source).
class ToolNote extends StatelessWidget {
  const ToolNote(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: space2),
        child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.palette.textMuted)),
      );
}
