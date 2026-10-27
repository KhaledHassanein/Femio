// Pregnancy onboarding, question one: how does she know her due date.
//
// Why it exists: a due date can come from a scan, a last period, conception or an IVF
// transfer, and each is worked out differently (domain/pregnancy.dart). Asking the
// method first keeps the date question to one date.

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets.dart';

/// How the date she will enter relates to the due date.
enum DueMethod { known, lmp, conception, ivf3, ivf5, born }

/// The due-date method question: one tile per [DueMethod].
///
/// [selected] highlights an earlier answer; [onPick] receives a tap.
class DueMethodStep extends StatelessWidget {
  const DueMethodStep({
    super.key,
    required this.progress,
    required this.onBack,
    required this.selected,
    required this.onPick,
  });
  final double progress;
  final VoidCallback onBack;
  final DueMethod? selected;
  final ValueChanged<DueMethod> onPick;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    Widget method(DueMethod m, IconData icon, String label) => OptionTile(
          icon: icon,
          title: label,
          selected: selected == m,
          onTap: () => onPick(m),
        );
    return StepScaffold(
      progress: progress,
      title: l.dueMethodTitle,
      onBack: onBack,
      child: Column(children: [
        method(DueMethod.known, Icons.event_available_outlined, l.dueMethodKnown),
        method(DueMethod.lmp, Icons.water_drop_outlined, l.dueMethodLmp),
        method(DueMethod.conception, Icons.favorite_border_rounded, l.dueMethodConception),
        method(DueMethod.ivf5, Icons.science_outlined, l.dueMethodIvf5),
        method(DueMethod.ivf3, Icons.science_outlined, l.dueMethodIvf3),
        method(DueMethod.born, Icons.child_care_outlined, l.dueMethodBorn),
      ]),
    );
  }
}
