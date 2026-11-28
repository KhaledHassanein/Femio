// Asks her, every time, before a report or her own words go to Google's cloud AI (ADR-089).
//
// Why it exists: the owner asked (2026-11-28) that every AI feature on a phone without Gemini
// Nano offer Cloud boost instead of just saying "not on this phone". Reading a report, her words
// after a visit or a Say it note is her record, so two steps stand between it and the cloud:
//   1. her standing consent to "Read my reports in the cloud" (CloudPurpose.records), given in
//      the one AI wizard with its own box; if it is missing, this offers to open the wizard;
//   2. a preview sheet for this one item: what will be sent (the number of page pictures, or
//      her words exactly), who receives it and how long it is kept, with Send and Not now.
// Only a tap on Send makes an [ApprovedRecord] (the privacy tripwire checks that this file is
// the only caller of [ApprovedRecord.approvedOnSheet]).

import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../domain/assistant/approved_record.dart';
import '../../domain/assistant/cloud_consent.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import 'ai_choices_wizard.dart' show AiMode, openAiChoicesWizard;

/// Her cloud consent as saved now.
CloudConsent _consent(FemioController controller) => controller.profile?.settings.cloud ?? const CloudConsent();

/// Whether she has agreed to cloud reading on today's consent text.
bool cloudReadingAllowed(FemioController controller) => _consent(controller).allows(CloudPurpose.records);

/// Asks her before [reading] goes to the cloud. [parts] are her words, [pages] page pictures,
/// [today] the ISO day. Without her cloud reading consent it first offers the AI wizard;
/// then it shows the preview. Returns the approval, or null when she declines at any step.
Future<ApprovedRecord?> approveCloudReading(
  BuildContext context,
  FemioController controller, {
  required RecordReading reading,
  List<String> parts = const [],
  List<Uint8List> pages = const [],
  required String today,
}) async {
  if (!cloudReadingAllowed(controller)) {
    final l = L10n.of(context);
    final turnOn = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.cloudReadOfferTitle),
        content: Text(l.cloudReadOfferBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(l.cloudReadNotNow)),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(l.cloudReadTurnOn)),
        ],
      ),
    );
    if (turnOn != true || !context.mounted) return null;
    await openAiChoicesWizard(context, controller, start: AiMode.cloud);
    if (!context.mounted || !cloudReadingAllowed(controller)) return null;
  }
  final send = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => CloudReadingSheet(reading: reading, parts: parts, pageCount: pages.length),
  );
  if (send != true) return null;
  return ApprovedRecord.approvedOnSheet(reading: reading, parts: parts, pages: pages, today: today);
}

/// The preview: what goes, to whom, and Send or Not now. Public for widget tests.
class CloudReadingSheet extends StatelessWidget {
  const CloudReadingSheet({super.key, required this.reading, this.parts = const [], this.pageCount = 0});
  final RecordReading reading;
  final List<String> parts;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final p = context.palette;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(space5, 0, space5, space4),
          children: [
            Text(l.cloudReadTitle, style: t.titleLarge),
            const SizedBox(height: space3),
            Text(l.cloudReadWhy, style: t.bodyMedium),
            const SizedBox(height: space4),
            Text(l.cloudReadWordsLabel, style: t.titleSmall),
            const SizedBox(height: space2),
            Container(
              padding: const EdgeInsets.all(space3),
              decoration: BoxDecoration(
                color: p.surfaceSunken,
                border: Border.all(color: p.border),
                borderRadius: BorderRadius.circular(radiusMd),
              ),
              child: reading == RecordReading.report
                  ? Row(children: [
                      Icon(Icons.description_outlined, color: p.primary),
                      const SizedBox(width: space2),
                      Expanded(child: Text(l.cloudReadPages(pageCount), style: t.bodyMedium)),
                    ])
                  : Text(parts.join('\n'), style: t.bodyMedium),
            ),
            const SizedBox(height: space4),
            Text(l.cloudReadWho, style: t.bodySmall?.copyWith(color: p.textMuted)),
            const SizedBox(height: space5),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.cloud_upload_outlined),
              label: Text(l.cloudReadSend),
            ),
            const SizedBox(height: space2),
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l.cloudReadNotNow)),
          ],
        ),
      ),
    );
  }
}
