// Onboarding question two: her year of birth, chosen on a wheel.
//
// Why it exists: age shapes which tools make sense and gates the under-18 notice. Only
// the year is asked (data minimisation: nothing here needs an exact birthday).

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/femio_theme.dart';
import '../../../theme/spacing.dart';
import '../../../theme/radii.dart';
import '../widgets.dart';

/// The birth-year question.
///
/// [years] is the list on the wheel, newest first; [initialIndex] is where it opens;
/// [onYearChanged] reports each year the wheel settles on; [onContinue] runs on the
/// button. Callers must pass an [initialIndex] that is inside [years].
class BirthYearStep extends StatelessWidget {
  const BirthYearStep({
    super.key,
    required this.progress,
    required this.onBack,
    required this.years,
    required this.initialIndex,
    required this.onYearChanged,
    required this.onContinue,
  });
  final double progress;
  final VoidCallback onBack;
  final List<int> years;
  final int initialIndex;
  final ValueChanged<int> onYearChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return StepScaffold(
      progress: progress,
      title: l.birthYearTitle,
      subtitle: l.birthYearSub,
      onBack: onBack,
      primaryLabel: l.continueLabel,
      onPrimary: onContinue,
      child: _YearWheel(years: years, initialIndex: initialIndex, onChanged: onYearChanged),
    );
  }
}

class _YearWheel extends StatelessWidget {
  const _YearWheel({required this.years, required this.initialIndex, required this.onChanged});
  final List<int> years;
  final int initialIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusLg),
        border: Border.all(color: p.border),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 52,
            margin: const EdgeInsets.symmetric(horizontal: space4),
            decoration: BoxDecoration(color: p.primarySoft, borderRadius: BorderRadius.circular(radiusMd)),
          ),
          ListWheelScrollView.useDelegate(
            controller: FixedExtentScrollController(initialItem: initialIndex),
            itemExtent: 52,
            diameterRatio: 1.6,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (i) => onChanged(years[i]),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: years.length,
              builder: (context, i) => Center(
                child: Text('${years[i]}', style: t.headlineSmall),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
