// Onboarding question: how many days her period usually lasts.
//
// Why it exists: it sets the shaded bleed days on the calendar. "Not sure" is a normal
// answer and leaves the length unset rather than guessing.

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets.dart';

/// Period-length stepper from [minDays] to [maxDays].
///
/// [value] is the number shown, [onChanged] receives the new one, [onContinue] keeps it
/// and [onNotSure] leaves it unset.
class PeriodLengthStep extends StatelessWidget {
  const PeriodLengthStep({
    super.key,
    required this.progress,
    required this.onBack,
    required this.value,
    required this.onChanged,
    required this.onContinue,
    required this.onNotSure,
  });
  final double progress;
  final VoidCallback onBack;
  final int value;
  final ValueChanged<int> onChanged;
  final VoidCallback onContinue;
  final VoidCallback onNotSure;

  static const minDays = 2;
  static const maxDays = 10;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return StepScaffold(
      progress: progress,
      title: l.periodLengthTitle,
      onBack: onBack,
      primaryLabel: l.continueLabel,
      onPrimary: onContinue,
      secondary: [TextButton(onPressed: onNotSure, child: Text(l.notSure))],
      child: NumberStepper(
        value: value,
        min: minDays,
        max: maxDays,
        label: l.daysValue(value),
        onChanged: onChanged,
      ),
    );
  }
}
