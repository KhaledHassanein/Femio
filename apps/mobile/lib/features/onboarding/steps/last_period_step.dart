// Onboarding question: the first day of her last period.
//
// Why it exists: this one date is what makes the first prediction possible, so it is
// asked before anything else about her cycle, and "I don't remember" is always allowed.

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets.dart';

/// The last-period question, a calendar with nothing pre-selected.
///
/// [today] is the latest pickable day; the calendar reaches back [lookBackDays] days.
/// [onContinue] is null until she taps a day. [onDontRemember] skips the answer.
class LastPeriodStep extends StatelessWidget {
  const LastPeriodStep({
    super.key,
    required this.progress,
    required this.onBack,
    required this.today,
    required this.selected,
    required this.onChanged,
    required this.onContinue,
    required this.onDontRemember,
  });
  final double progress;
  final VoidCallback onBack;
  final DateTime today;
  final DateTime? selected;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback? onContinue;
  final VoidCallback onDontRemember;

  /// Four months back covers a late period without offering a year of scrolling.
  static const lookBackDays = 120;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return StepScaffold(
      progress: progress,
      title: l.lastPeriodTitle,
      subtitle: l.lastPeriodSub,
      onBack: onBack,
      primaryLabel: l.continueLabel,
      onPrimary: onContinue,
      secondary: [TextButton(onPressed: onDontRemember, child: Text(l.dontRemember))],
      child: DateCard(
        first: today.subtract(const Duration(days: lookBackDays)),
        last: today,
        selected: selected,
        onChanged: onChanged,
      ),
    );
  }
}
