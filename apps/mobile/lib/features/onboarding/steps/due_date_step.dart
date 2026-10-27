// Pregnancy onboarding, question two: the date that goes with the chosen method.
//
// Why it exists: the calendar's title and range depend on the method (a due date lies
// ahead, a last period behind), and an implausible result is flagged here instead of
// being saved silently.

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/femio_theme.dart';
import '../../../theme/spacing.dart';
import '../widgets.dart';
import 'due_method_step.dart';

/// The date question for [method].
///
/// [today] anchors the calendar range. [implausible] shows the warning; the caller also
/// passes a null [onContinue] while nothing is picked or the result is implausible.
class DueDateStep extends StatelessWidget {
  const DueDateStep({
    super.key,
    required this.progress,
    required this.onBack,
    required this.method,
    required this.today,
    required this.selected,
    required this.implausible,
    required this.onChanged,
    required this.onContinue,
  });
  final double progress;
  final VoidCallback onBack;
  final DueMethod method;
  final DateTime today;
  final DateTime? selected;
  final bool implausible;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback? onContinue;

  /// A due date can be up to about 300 days ahead; other dates reach back that far.
  static const _spanDays = 300;

  /// A baby already born is dated within the last year.
  static const _bornLookBackDays = 365;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final title = switch (method) {
      DueMethod.known => l.dueDateTitle,
      DueMethod.lmp => l.lastPeriodTitle,
      DueMethod.conception => l.conceptionTitle,
      DueMethod.ivf3 || DueMethod.ivf5 => l.transferTitle,
      DueMethod.born => l.birthDateTitle,
    };
    final first = method == DueMethod.known
        ? today
        : today.subtract(Duration(days: method == DueMethod.born ? _bornLookBackDays : _spanDays));
    final last = method == DueMethod.known ? today.add(const Duration(days: _spanDays)) : today;
    return StepScaffold(
      progress: progress,
      title: title,
      onBack: onBack,
      primaryLabel: l.continueLabel,
      onPrimary: onContinue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DateCard(first: first, last: last, selected: selected, onChanged: onChanged),
          if (implausible) ...[
            const SizedBox(height: space3),
            Text(l.implausibleDue, style: TextStyle(color: p.dangerText)),
          ],
        ],
      ),
    );
  }
}
