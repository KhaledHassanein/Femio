// Menopause onboarding: when was her last period.
//
// Why it exists: months since the last period is the one number the menopause view of
// Today is built on. "More than a year ago" and "not sure" are answers, not errors.

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets.dart';

/// The last-period question for the menopause goal.
///
/// [onContinue] is null until she taps a day; [onOverYear] and [onNotSure] finish
/// without a date.
class MenoLastStep extends StatelessWidget {
  const MenoLastStep({
    super.key,
    required this.progress,
    required this.onBack,
    required this.today,
    required this.selected,
    required this.onChanged,
    required this.onContinue,
    required this.onOverYear,
    required this.onNotSure,
  });
  final double progress;
  final VoidCallback onBack;
  final DateTime today;
  final DateTime? selected;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback? onContinue;
  final VoidCallback onOverYear;
  final VoidCallback onNotSure;

  /// A little over a year back, so "about twelve months ago" is reachable.
  static const lookBackDays = 400;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return StepScaffold(
      progress: progress,
      title: l.menoLastTitle,
      onBack: onBack,
      primaryLabel: l.continueLabel,
      onPrimary: onContinue,
      secondary: [
        TextButton(onPressed: onOverYear, child: Text(l.menoOverYear)),
        TextButton(onPressed: onNotSure, child: Text(l.notSure)),
      ],
      child: DateCard(
        first: today.subtract(const Duration(days: lookBackDays)),
        last: today,
        selected: selected,
        onChanged: onChanged,
      ),
    );
  }
}
