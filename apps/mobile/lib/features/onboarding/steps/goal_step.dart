// Onboarding question one: what is she here for.
//
// Why it exists: the goal decides every later question and the whole Today screen, so
// it comes first and nothing is pre-selected (owner critique 2026-10-07).

import 'package:flutter/material.dart';

import '../../../data/profile.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/femio_theme.dart';
import '../widgets.dart';

/// The goal question: four tiles, one tap each.
///
/// [selected] highlights a goal she already chose (when she comes back to this step);
/// [onPick] receives the tapped goal. It has no failure cases.
class GoalStep extends StatelessWidget {
  const GoalStep({
    super.key,
    required this.progress,
    required this.onBack,
    required this.selected,
    required this.onPick,
  });
  final double progress;
  final VoidCallback onBack;
  final Goal? selected;
  final ValueChanged<Goal> onPick;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    Widget tile(Goal g, IconData icon, String title, String desc, Color tint) => OptionTile(
          icon: icon,
          title: title,
          description: desc,
          tint: tint,
          selected: selected == g,
          onTap: () => onPick(g),
        );
    return StepScaffold(
      progress: progress,
      title: l.goalTitle,
      subtitle: l.goalSub,
      onBack: onBack,
      child: Column(children: [
        tile(Goal.period, Icons.water_drop_outlined, l.goalPeriod, l.goalPeriodDesc, p.logPeriodAlt),
        tile(Goal.ttc, Icons.local_florist_outlined, l.goalTtc, l.goalTtcDesc, p.successSoft),
        tile(Goal.pregnant, Icons.child_friendly_outlined, l.goalPregnant, l.goalPregnantDesc, p.accentSoft),
        tile(Goal.menopause, Icons.nightlight_outlined, l.goalMenopause, l.goalMenopauseDesc, p.primarySoft),
      ]),
    );
  }
}
