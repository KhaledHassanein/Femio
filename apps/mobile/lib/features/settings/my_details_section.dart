// Settings → My details: change her goal, and her due date while she is pregnant.
//
// Why it exists: onboarding promises "You can change this any time", and the only way to
// move from trying to conceive to pregnant used to be Delete everything. Product rule 5:
// a change of stage re-layers the experience over the SAME record, so every choice here
// goes through FemioController.setGoal / setDueDate, which change the stage and nothing
// she has logged.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../data/profile.dart';
import '../../domain/dates.dart';
import '../../domain/pregnancy.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../onboarding/date_card.dart';

/// The name of [goal] as onboarding words it.
String goalName(L10n l, Goal goal) => switch (goal) {
  Goal.period => l.goalPeriod,
  Goal.ttc => l.goalTtc,
  Goal.pregnant => l.goalPregnant,
  Goal.menopause => l.goalMenopause,
};

String _goalDescription(L10n l, Goal goal) => switch (goal) {
  Goal.period => l.goalPeriodDesc,
  Goal.ttc => l.goalTtcDesc,
  Goal.pregnant => l.goalPregnantDesc,
  Goal.menopause => l.goalMenopauseDesc,
};

/// The rows under the "My details" heading: her goal, and the due date while pregnant
/// (not after the birth). [today] fixes the date in tests.
class MyDetailsRows extends StatelessWidget {
  const MyDetailsRows({super.key, required this.controller, required this.profile, this.today});
  final FemioController controller;
  final Profile profile;
  final String? today;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final edd = profile.edd;
    final showDueDate = profile.goal == Goal.pregnant && profile.birthDate == null;
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.flag_outlined),
          title: Text(l.settingsGoal),
          subtitle: Text(goalName(l, profile.goal)),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _chooseGoal(context),
        ),
        if (showDueDate)
          ListTile(
            leading: const Icon(Icons.event_outlined),
            title: Text(l.settingsDueDate),
            subtitle: edd == null || !isValidISODate(edd) ? null : Text(DateFormat.yMMMd(locale).format(fromISO(edd))),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _editDueDate(context, onSave: controller.setDueDate),
          ),
      ],
    );
  }

  Future<void> _chooseGoal(BuildContext context) async {
    final picked = await showModalBottomSheet<Goal>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _GoalSheet(current: profile.goal),
    );
    if (picked == null || picked == profile.goal || !context.mounted) return;
    if (picked == Goal.pregnant) {
      // Pregnancy needs a due date; the goal only changes once she has given one.
      await _editDueDate(context, onSave: (edd) => controller.setGoal(Goal.pregnant, edd: edd));
    } else {
      await controller.setGoal(picked);
    }
  }

  Future<void> _editDueDate(BuildContext context, {required Future<void> Function(String edd) onSave}) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => DueDateScreen(initial: profile.edd, today: today ?? todayISO(), onSave: onSave),
        ),
      );
}

/// The four goals, one tap each, with the reassurance that records stay.
class _GoalSheet extends StatelessWidget {
  const _GoalSheet({required this.current});
  final Goal current;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: space4),
              child: Semantics(header: true, child: Text(l.settingsGoal, style: t.titleLarge)),
            ),
            RadioGroup<Goal>(
              groupValue: current,
              onChanged: (g) => Navigator.of(context).pop(g),
              child: Column(
                children: [
                  for (final g in Goal.values)
                    RadioListTile<Goal>(value: g, title: Text(goalName(l, g)), subtitle: Text(_goalDescription(l, g))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(space4, space1, space4, space4),
              child: Text(l.settingsGoalNote, style: t.bodySmall?.copyWith(color: p.textMuted)),
            ),
          ],
        ),
      ),
    );
  }
}

/// The due date calendar with a Save button. Save stays off until she has picked a day
/// that looks like a current pregnancy (the same rule onboarding uses).
///
/// [initial] is the due date already on the record, if any; [today] is an ISO day;
/// [onSave] receives the chosen ISO day and the screen closes once it has finished.
class DueDateScreen extends StatefulWidget {
  const DueDateScreen({super.key, required this.initial, required this.today, required this.onSave});
  final String? initial;
  final String today;
  final Future<void> Function(String edd) onSave;

  @override
  State<DueDateScreen> createState() => _DueDateScreenState();
}

class _DueDateScreenState extends State<DueDateScreen> {
  DateTime? _picked;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null && isPlausibleEdd(initial, widget.today)) _picked = fromISO(initial);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.onSave(toISO(_picked!));
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      // The controller has already raised its "could not save" banner; stay here so she
      // can try again.
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final today = fromISO(widget.today);
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsDueDate)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(space2, space3, space2, space8),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: space3),
            child: Semantics(header: true, child: Text(l.dueDateTitle, style: t.titleLarge)),
          ),
          const SizedBox(height: space3),
          DateCard(
            first: today.subtract(const Duration(days: maxDaysPastDue)),
            last: today.add(const Duration(days: maxDaysUntilDue)),
            selected: _picked,
            today: today,
            onChanged: (d) => setState(() => _picked = d),
          ),
          const SizedBox(height: space4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: space3),
            child: FilledButton(onPressed: _picked == null || _saving ? null : _save, child: Text(l.saveLabel)),
          ),
        ],
      ),
    );
  }
}
