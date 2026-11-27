// Onboarding's last step: meet the assistant before the first screen (R14.6a).
//
// Why it exists: the judge audit found the assistant easy to miss. Saying once, up front,
// what it does, that it runs on this phone, that the safety rules answer first and that
// Cloud boost stays off unless she turns it on, makes the AI visible without a pop-up
// later. The points are the same widget as the first-use sheet's.

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../assistant/assistant_pill.dart';
import '../widgets.dart';

/// The assistant introduction. [onContinue] saves her record and opens the app.
class AssistantIntroStep extends StatelessWidget {
  const AssistantIntroStep({super.key, required this.progress, required this.onBack, required this.onContinue});
  final double progress;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return StepScaffold(
      progress: progress,
      onBack: onBack,
      title: l.assistIntroTitle,
      primaryLabel: l.assistIntroContinue,
      onPrimary: onContinue,
      child: const AssistantIntroPoints(),
    );
  }
}
