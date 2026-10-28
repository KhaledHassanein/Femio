// The one question asked when the birth year leaves her age at 17 or 18 (D-01).
//
// Why it exists: the wheel collects a year only, so a woman born eighteen calendar
// years ago may or may not have had her birthday yet. Rather than collect a date of
// birth, one yes/no settles it (lib/domain/age_gate.dart). Nothing here is saved.

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets.dart';

/// "Has your 18th birthday passed?" [onYes] continues her path; [onNo] shows the
/// under-18 notice. It has no failure cases.
class EighteenStep extends StatelessWidget {
  const EighteenStep({
    super.key,
    required this.progress,
    required this.onBack,
    required this.onYes,
    required this.onNo,
  });
  final double progress;
  final VoidCallback onBack;
  final VoidCallback onYes;
  final VoidCallback onNo;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return StepScaffold(
      progress: progress,
      title: l.eighteenTitle,
      subtitle: l.eighteenSub,
      onBack: onBack,
      child: Column(
        children: [
          OptionTile(icon: Icons.check_rounded, title: l.yesLabel, onTap: onYes),
          OptionTile(icon: Icons.schedule_rounded, title: l.noNotYetLabel, onTap: onNo),
        ],
      ),
    );
  }
}
