// "What the AI can see": every AI use, where it runs, what it receives and whether it may
// change her record (R10.3).
//
// Why it exists: product rule 7 says the AI reads only through a narrow, typed context. This
// screen is generated from the policy table (`usePolicies`, ADR-081), so a new use cannot ship
// without appearing here: the screen has no list of its own to forget to update.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../domain/assistant/uses.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';

/// The use's name, as she meets it in the app.
String aiUseName(L10n l, AssistantUse use) => switch (use) {
  AssistantUse.askOnPhone => l.askTitle,
  AssistantUse.askInCloud => l.aiUseAskInCloud,
  AssistantUse.sayItToLog => l.sayItButton,
  AssistantUse.tipsOrder => l.aiUseTips,
  AssistantUse.visitQuestions => l.visitQuestionsTitle,
};

/// What the use does for her, and what happens without it, in plain words (owner 2026-11-27).
String aiUseHelps(L10n l, AssistantUse use) => switch (use) {
  AssistantUse.askOnPhone => l.aiHelpsAsk,
  AssistantUse.askInCloud => l.aiHelpsAskCloud,
  AssistantUse.sayItToLog => l.aiHelpsSayIt,
  AssistantUse.tipsOrder => l.aiHelpsTips,
  AssistantUse.visitQuestions => l.aiHelpsVisit,
};

/// One input in plain words.
String aiInputText(L10n l, AssistantInput input) => switch (input) {
  AssistantInput.herQuestion => l.aiSeesHerQuestion,
  AssistantInput.approvedQuestion => l.aiSeesApprovedQuestion,
  AssistantInput.trustedPassages => l.aiSeesPassages,
  AssistantInput.herNote => l.aiSeesNote,
  AssistantInput.fourBands => l.aiSeesBands,
  AssistantInput.reviewedIds => l.aiSeesIds,
  AssistantInput.visitFacts => l.aiSeesVisitFacts,
};

/// The list, one card per enabled use. [controller] supplies her master switch, so the page
/// says plainly when none of it runs.
class AiSeesScreen extends StatelessWidget {
  const AiSeesScreen({super.key, required this.controller});
  final FemioController controller;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final on = controller.profile?.settings.assistantOn ?? true;
    return Scaffold(
      appBar: AppBar(title: Text(l.aiSeesTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(space5, space3, space5, space8),
        children: [
          Text(l.aiSeesIntro, style: t.bodyLarge),
          if (!on) ...[
            const SizedBox(height: space2),
            Text(l.aiSeesOff, style: t.bodyMedium?.copyWith(color: p.textMuted)),
          ],
          const SizedBox(height: space4),
          for (final MapEntry(key: use, value: policy) in usePolicies.entries)
            if (policy.enabled) _UseCard(use: use, policy: policy),
        ],
      ),
    );
  }
}

class _UseCard extends StatelessWidget {
  const _UseCard({required this.use, required this.policy});
  final AssistantUse use;
  final AssistantPolicy policy;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final phone = policy.tier == AssistantTier.phone;
    final draft = policy.write == AssistantWrite.draftSheConfirms;
    Widget line(IconData icon, String text, {double size = 18}) => Padding(
      padding: const EdgeInsets.only(top: space2),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 18, height: 20, child: Icon(icon, size: size, color: p.textMuted)),
        const SizedBox(width: space2),
        Expanded(child: Text(text, style: t.bodyMedium)),
      ]),
    );
    return Semantics(
      container: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: space3),
        padding: const EdgeInsets.all(space4),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(radiusLg),
          border: Border.all(color: p.border),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(aiUseName(l, use), style: t.titleMedium),
          const SizedBox(height: space1),
          Text(aiUseHelps(l, use), style: t.bodyMedium),
          line(phone ? Icons.phone_android_rounded : Icons.cloud_outlined,
              phone ? l.aiWherePhone : l.aiWhereHybrid),
          line(draft ? Icons.edit_note_rounded : Icons.lock_outline_rounded,
              draft ? l.aiWriteDraft : l.aiWriteNone),
          const SizedBox(height: space3),
          Text(l.aiSeesLabel, style: t.labelLarge?.copyWith(color: p.textMuted)),
          for (final input in policy.sees) line(Icons.circle, aiInputText(l, input), size: 6),
        ]),
      ),
    );
  }
}
