// The assistant's doors: ask a question, say how today went, questions for a visit (R8.3).
//
// Why it exists: the assistant was two buttons deep on Today, so most people would never
// meet it. Since R8.29 the doors open from the "+" in the navigation bar (`add_sheet.dart`);
// Today, Learn and Log open the same doors (R14.6). The first tap shows one sheet saying what runs on the phone and offering Cloud boost
// as a choice, through its own consent screen with nothing ticked (ADR-079, ADR-080). Every
// door also works with the AI unavailable: the rules and guides answer (product rule 7).

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/library.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import 'ask_screen.dart';
import 'ai_choices_wizard.dart';
import 'say_it_sheet.dart';
import 'visit_summary_screen.dart';

/// Shows the first-use sheet once, then the three doors.
Future<void> openAssistant(
  BuildContext context, {
  required FemioController controller,
  required String today,
  Library? library,
}) async {
  if (!await _introDone(context, controller) || !context.mounted) return;
  final door = await showModalBottomSheet<AssistantDoor>(
    context: context,
    showDragHandle: true,
    builder: (_) => const AssistantDoorsSheet(),
  );
  if (door == null || !context.mounted) return;
  await _open(context, door, controller: controller, today: today, library: library);
}

/// Opens one door directly (from the "+" sheet), after the first-use sheet if she has not
/// seen it. Returns when the door's screen or sheet closes.
Future<void> openAssistantDoor(
  BuildContext context,
  AssistantDoor door, {
  required FemioController controller,
  required String today,
  Library? library,
}) async {
  if (!await _introDone(context, controller) || !context.mounted) return;
  await _open(context, door, controller: controller, today: today, library: library);
}

/// True when she may go on: the intro was seen before, or she chose to continue now.
Future<bool> _introDone(BuildContext context, FemioController controller) async {
  final settings = controller.profile?.settings;
  if (settings != null && !settings.assistantIntroSeen) {
    final go = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AssistantIntroSheet(controller: controller),
    );
    // Seen means shown: closing it by swiping counts too, so it never nags.
    final now = controller.profile?.settings;
    if (now != null) await controller.setSettings(now.copyWith(assistantIntroSeen: true));
    return go == true;
  }
  return true;
}

Future<void> _open(
  BuildContext context,
  AssistantDoor door, {
  required FemioController controller,
  required String today,
  Library? library,
}) async {
  final nav = Navigator.of(context);
  switch (door) {
    case AssistantDoor.ask:
      await nav.push(MaterialPageRoute<void>(
        builder: (_) => AskScreen(controller: controller, library: library, today: today),
      ));
    case AssistantDoor.sayIt:
      await showSayItSheet(context, controller: controller, date: today);
    case AssistantDoor.visit:
      await nav.push(MaterialPageRoute<void>(
        builder: (_) => VisitSummaryScreen(controller: controller, today: today),
      ));
  }
}

/// The three ways into the assistant.
enum AssistantDoor { ask, sayIt, visit }

/// The first-use sheet: what runs on the phone, what never happens, and Cloud boost as an
/// option she has to choose. Pops `true` to continue to the doors. Public for screenshots.
class AssistantIntroSheet extends StatelessWidget {
  const AssistantIntroSheet({super.key, required this.controller});
  final FemioController controller;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(space5, 0, space5, space5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.assistIntroTitle, style: t.titleLarge),
          const SizedBox(height: space3),
          const AssistantIntroPoints(),
          const SizedBox(height: space4),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.assistIntroContinue),
          ),
          const SizedBox(height: space2),
          OutlinedButton(
            onPressed: () async {
              final nav = Navigator.of(context);
              await openAiChoicesWizard(context, controller, start: AiMode.cloud);
              nav.pop(true);
            },
            child: Text(l.assistIntroCloudAction),
          ),
        ]),
      ),
    );
  }
}

/// What the assistant does, its rules, Cloud boost and where to change it. Shared by the
/// first-use sheet and onboarding's last step (R14.6a), so both say exactly the same.
class AssistantIntroPoints extends StatelessWidget {
  const AssistantIntroPoints({super.key});

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _Point(icon: Icons.phone_android_rounded, text: l.assistIntroPhone),
      _Point(icon: Icons.health_and_safety_outlined, text: l.assistIntroRules),
      _Point(icon: Icons.cloud_outlined, title: l.assistIntroCloudTitle, text: l.assistIntroCloudBody),
      const SizedBox(height: space2),
      Text(l.assistIntroSettings, style: t.bodySmall?.copyWith(color: p.textMuted)),
    ]);
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.icon, required this.text, this.title});
  final IconData icon;
  final String text;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: space3),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: p.primary),
        const SizedBox(width: space3),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (title != null) Text(title!, style: t.titleSmall),
            Text(text, style: t.bodyMedium),
          ]),
        ),
      ]),
    );
  }
}

/// The three doors. Pops the chosen one. Public for screenshots.
class AssistantDoorsSheet extends StatelessWidget {
  const AssistantDoorsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    Widget door(AssistantDoor d, IconData icon, String title, String sub) => ListTile(
          leading: Icon(icon, color: p.primary),
          title: Text(title),
          subtitle: Text(sub),
          onTap: () => Navigator.of(context).pop(d),
        );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: space3),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          door(AssistantDoor.ask, Icons.travel_explore_rounded, l.assistDoorAsk, l.assistDoorAskSub),
          door(AssistantDoor.sayIt, Icons.edit_note_rounded, l.assistDoorSayIt, l.assistDoorSayItSub),
          door(AssistantDoor.visit, Icons.event_note_outlined, l.visitQuestionsTitle, l.assistDoorVisitSub),
        ]),
      ),
    );
  }
}
