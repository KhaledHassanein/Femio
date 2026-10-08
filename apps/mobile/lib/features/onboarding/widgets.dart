import 'package:flutter/material.dart';

import '../../theme/femio_theme.dart';

/// One onboarding question: a progress bar, the question, its answers, and the
/// actions pinned to the bottom where a thumb reaches them.
class StepScaffold extends StatelessWidget {
  const StepScaffold({
    super.key,
    required this.progress,
    required this.title,
    this.subtitle,
    required this.child,
    this.primaryLabel,
    this.onPrimary,
    this.secondary = const [],
    this.onBack,
  });

  final double progress;
  final String title;
  final String? subtitle;
  final Widget child;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final List<Widget> secondary;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 20, 0),
              child: Row(
                children: [
                  if (onBack != null)
                    IconButton(
                      onPressed: onBack,
                      icon: const BackButtonIcon(),
                      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                    )
                  else
                    const SizedBox(width: 48),
                  const SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: p.surfaceSunken,
                        color: p.primarySolid,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(header: true, child: Text(title, style: t.headlineMedium)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(subtitle!, style: t.bodyMedium),
                    ],
                    const SizedBox(height: 24),
                    child,
                  ],
                ),
              ),
            ),
            if (primaryLabel != null || secondary.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (primaryLabel != null)
                      FilledButton(onPressed: onPrimary, child: Text(primaryLabel!)),
                    for (final w in secondary) ...[const SizedBox(height: 4), w],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A large tappable answer: tinted icon, title, one line of explanation.
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    required this.onTap,
    this.tint,
    this.selected = false,
  });

  final IconData icon;
  final String title;
  final String? description;
  final VoidCallback onTap;
  final Color? tint;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: selected ? p.primarySoft : p.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: selected ? p.primarySolid : p.border, width: selected ? 2 : 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: tint ?? p.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: p.primarySoftText),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: t.titleMedium),
                      if (description != null) ...[
                        const SizedBox(height: 2),
                        Text(description!, style: t.bodySmall),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: p.textSubtle, textDirection: Directionality.of(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A number chosen with − and +, shown large.
class NumberStepper extends StatelessWidget {
  const NumberStepper({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.label,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    Widget round(IconData icon, VoidCallback? onTap, String tooltip) => IconButton.filledTonal(
          onPressed: onTap,
          icon: Icon(icon),
          iconSize: 28,
          tooltip: tooltip,
          style: IconButton.styleFrom(
            minimumSize: const Size(56, 56),
            backgroundColor: p.primarySoft,
            foregroundColor: p.primarySoftText,
          ),
        );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: p.border),
      ),
      child: Row(
        children: [
          round(Icons.remove_rounded, value > min ? () => onChanged(value - 1) : null, '−'),
          Expanded(
            child: Semantics(
              liveRegion: true,
              child: Text(label, textAlign: TextAlign.center, style: t.displaySmall),
            ),
          ),
          round(Icons.add_rounded, value < max ? () => onChanged(value + 1) : null, '+'),
        ],
      ),
    );
  }
}

/// A month calendar in a card. Nothing is selected until she taps a day.
class DateCard extends StatelessWidget {
  const DateCard({
    super.key,
    required this.first,
    required this.last,
    required this.selected,
    required this.onChanged,
  });

  final DateTime first;
  final DateTime last;
  final DateTime? selected;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: p.border),
      ),
      child: CalendarDatePicker(
        initialDate: selected,
        currentDate: last,
        firstDate: first,
        lastDate: last,
        initialCalendarMode: DatePickerMode.day,
        onDateChanged: onChanged,
      ),
    );
  }
}
