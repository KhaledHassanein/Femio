// Onboarding question for the trying-to-conceive goal: for how long.
//
// Why it exists: how long she has been trying decides when the Today screen suggests
// speaking to a clinician (NHS timing), so it is asked once, here.

import 'package:flutter/material.dart';

import '../../../data/profile.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets.dart';

/// The "how long have you been trying" question.
///
/// [selected] highlights an earlier answer, [onPick] receives a tap (and finishes
/// onboarding), [onNotSure] finishes without an answer.
class TryingStep extends StatelessWidget {
  const TryingStep({
    super.key,
    required this.progress,
    required this.onBack,
    required this.selected,
    required this.onPick,
    required this.onNotSure,
  });
  final double progress;
  final VoidCallback onBack;
  final TryingFor? selected;
  final ValueChanged<TryingFor> onPick;
  final VoidCallback onNotSure;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    Widget option(TryingFor v, String label) => OptionTile(
          icon: Icons.schedule_rounded,
          title: label,
          selected: selected == v,
          onTap: () => onPick(v),
        );
    return StepScaffold(
      progress: progress,
      title: l.tryingTitle,
      onBack: onBack,
      secondary: [TextButton(onPressed: onNotSure, child: Text(l.notSure))],
      child: Column(children: [
        option(TryingFor.justStarted, l.tryingJustStarted),
        option(TryingFor.under6, l.tryingUnder6),
        option(TryingFor.sixTo12, l.trying6to12),
        option(TryingFor.over12, l.tryingOver12),
      ]),
    );
  }
}
