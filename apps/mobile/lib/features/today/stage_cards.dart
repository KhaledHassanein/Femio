// Moving between life stages from Today, without deleting or resetting (owner 2026-11-27).
//
// Why it exists: femio is a lifetime companion. She should see which stage femio is following
// and change it in one tap: "I'm pregnant" from trying to conceive, "My pregnancy has ended"
// from pregnancy (MR-35), breastfeeding after birth. Every move re-layers Today over the same
// record (product rule 5). The urgent after-loss line follows the NHS miscarriage page; the
// rest says only what femio does, never what her body will do.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/library.dart';
import '../../data/profile.dart';
import '../../domain/dates.dart';
import '../../domain/pregnancy_end.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import '../help/help_now_screen.dart';
import '../onboarding/onboarding_flow.dart';
import 'postpartum_cards.dart' show PickDaySheet, openGuide;

/// The stage femio follows now, in her words, with the layer she added.
String stageName(L10n l, Profile p) {
  final base = switch (p.goal) {
    Goal.period => l.goalPeriod,
    Goal.ttc => l.goalTtc,
    Goal.pregnant => p.isPostpartum ? l.stageAfterBirth : l.goalPregnant,
    Goal.menopause => l.goalMenopause,
  };
  return p.breastfeeding ? l.stageWithBreastfeeding(base) : base;
}

/// Opens the stage questions with her answers filled in; [start] skips to that goal.
Future<void> openStageChange(BuildContext context, FemioController controller, {Goal? start}) =>
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => OnboardingFlow(controller: controller, editing: true, startGoal: start),
    ));

/// "Now: Get pregnant · Change" under the Today title. In a pregnancy (before a birth),
/// Change first offers "My pregnancy has ended", so moving out of pregnancy never skips the
/// loss path of MR-35 (reminders off, earlier bleeding kept out of her cycles; CLIN-N3-1).
class StageRow extends StatelessWidget {
  const StageRow({super.key, required this.controller, required this.today});
  final FemioController controller;
  final String today;

  void _change(BuildContext context) {
    final profile = controller.profile!;
    if (profile.goal != Goal.pregnant || profile.isPostpartum) {
      openStageChange(context, controller);
      return;
    }
    final l = L10n.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.favorite_border_rounded),
            title: Text(l.endedAction),
            onTap: () {
              Navigator.of(sheet).pop();
              openPregnancyEnded(context, controller, today);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(l.stageEditAnswers),
            onTap: () {
              Navigator.of(sheet).pop();
              openStageChange(context, controller);
            },
          ),
          const SizedBox(height: space2),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final p = context.palette;
    return Row(children: [
      Icon(Icons.route_outlined, size: 18, color: p.textMuted),
      const SizedBox(width: space1h),
      Flexible(
        child: Text(l.stageNow(stageName(l, controller.profile!)),
            style: t.bodyMedium?.copyWith(color: p.textMuted), overflow: TextOverflow.ellipsis),
      ),
      TextButton(onPressed: () => _change(context), child: Text(l.stageChange)),
    ]);
  }
}

/// "I'm pregnant" on the trying-to-conceive Today: straight to the due-date question.
class PregnantNowButton extends StatelessWidget {
  const PregnantNowButton({super.key, required this.controller});
  final FemioController controller;

  @override
  Widget build(BuildContext context) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          onPressed: () => openStageChange(context, controller, start: Goal.pregnant),
          icon: const Icon(Icons.pregnant_woman_rounded, size: 18),
          label: Text(L10n.of(context).goalPregnant),
        ),
      );
}

/// The "My pregnancy has ended" sheet: the day, then what femio helps with now (MR-35).
Future<void> openPregnancyEnded(BuildContext context, FemioController controller, String today) {
  final l = L10n.of(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => PickDaySheet(
      title: l.endedTitle,
      note: l.endedNote,
      first: addDays(today, -pregnancyEndedMaxDaysAgo),
      today: today,
      actions: (day) => [
        Text(l.ppNextGoal, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: space2),
        for (final goal in const [Goal.period, Goal.ttc])
          Padding(
            padding: const EdgeInsets.only(bottom: space2),
            child: FilledButton(
              onPressed: day == null
                  ? null
                  : () async {
                      await controller.endPregnancy(day, goal);
                      if (context.mounted) Navigator.of(context).pop();
                    },
              child: Text(goal == Goal.period ? l.goalPeriod : l.goalTtc),
            ),
          ),
      ],
    ),
  );
}

/// "My pregnancy has ended" on the pregnancy Today.
class PregnancyEndedButton extends StatelessWidget {
  const PregnancyEndedButton({super.key, required this.controller, required this.today});
  final FemioController controller;
  final String today;

  @override
  Widget build(BuildContext context) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          onPressed: () => openPregnancyEnded(context, controller, today),
          icon: const Icon(Icons.favorite_border_rounded, size: 18),
          label: Text(L10n.of(context).endedAction),
        ),
      );
}

/// The gentle card after a pregnancy ended (MR-35): what femio changed, and when to get help.
class AfterLossCard extends StatelessWidget {
  const AfterLossCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      NoticeCard(tone: NoticeTone.quiet, heading: l.endedCardTitle, body: l.endedCardBody),
      const SizedBox(height: space2),
      NoticeCard(tone: NoticeTone.caution, heading: l.endedUrgentTitle, body: '${l.endedUrgentBody}\n\n${l.endedSource}'),
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: TextButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const HelpNowScreen())),
          child: Text(l.helpNowLauncher),
        ),
      ),
    ]);
  }
}

/// After birth: "I'm breastfeeding", and the reviewed guides while it is on.
class BreastfeedingCard extends StatelessWidget {
  const BreastfeedingCard({super.key, required this.controller, required this.library});
  final FemioController controller;
  final Library library;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final p = context.palette;
    final on = controller.profile!.breastfeeding;
    // A Material (not a decorated box) so the switch row's ink shows on the card.
    return Material(
      color: p.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLg),
        side: BorderSide(color: p.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(space4h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l.feedingTitle, style: t.titleMedium),
          subtitle: Text(l.feedingSub),
          value: on,
          onChanged: controller.setBreastfeeding,
        ),
        if (on)
          for (final (slug, label) in [
            (breastfeedingGuides[0], l.feedingGuideFirst),
            (breastfeedingGuides[1], l.feedingGuideHelp),
          ])
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () => openGuide(context, library, slug),
                icon: const Icon(Icons.menu_book_outlined, size: 18),
                label: Text(label),
              ),
            ),
        ]),
      ),
    );
  }
}
