// Onboarding question: how many days from one period start to the next.
//
// Why it exists: a stated length gives the first prediction a basis before she has
// logged any cycles. "Irregular" and "not sure" are first-class answers (product rule
// 3: predictions stay honest when cycles vary).

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets.dart';

/// Cycle-length stepper from [minDays] to [maxDays].
///
/// [onContinue] keeps [value]; [onIrregular] records that her cycles vary;
/// [onNotSure] leaves the length unset without calling it irregular.
class CycleLengthStep extends StatelessWidget {
  const CycleLengthStep({
    super.key,
    required this.progress,
    required this.onBack,
    required this.value,
    required this.onChanged,
    required this.onContinue,
    required this.onIrregular,
    required this.onNotSure,
  });
  final double progress;
  final VoidCallback onBack;
  final int value;
  final ValueChanged<int> onChanged;
  final VoidCallback onContinue;
  final VoidCallback onIrregular;
  final VoidCallback onNotSure;

  static const minDays = 21;
  static const maxDays = 45;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return StepScaffold(
      progress: progress,
      title: l.cycleLengthTitle,
      subtitle: l.cycleLengthSub,
      onBack: onBack,
      primaryLabel: l.continueLabel,
      onPrimary: onContinue,
      secondary: [
        TextButton(onPressed: onIrregular, child: Text(l.irregular)),
        TextButton(onPressed: onNotSure, child: Text(l.notSure)),
      ],
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
