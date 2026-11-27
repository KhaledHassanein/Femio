// "My AI choices": every AI and Cloud boost choice she made, as dated, sealed receipts.
//
// Why it exists: consent must be provable (GDPR Art. 7(1); Saudi PDPL; Egypt Law 151/2020),
// and the owner asked for a record that can show, in a dispute, what she chose and when.
// femio has no server, so the record lives in her own record and backup. This screen shows
// each receipt in her language, says whether the seals still check out
// ([CloudConsent.sealIntact]), and lets her share a full copy, seals included, with anyone
// she chooses (for example femio's support, if she raises a complaint).

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app.dart';
import '../../data/share_channel.dart';
import '../../domain/assistant/cloud_consent.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import 'ai_choices_wizard.dart';

/// How many characters of a seal the list shows; the shared copy carries the full seal.
const _sealShown = 12;

/// The receipts, newest first.
class AiChoicesRecordScreen extends StatelessWidget {
  const AiChoicesRecordScreen({super.key, required this.controller});
  final FemioController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: controller,
        builder: (context, _) => _build(context),
      );

  Widget _build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final p = context.palette;
    final locale = Localizations.localeOf(context).toString();
    final consent = controller.profile?.settings.cloud ?? const CloudConsent();
    final receipts = consent.log.reversed.toList();
    return Scaffold(
      appBar: AppBar(title: Text(l.aiRecordTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(space5, space3, space5, space8),
          children: [
            Text(l.aiRecordIntro, style: t.bodyMedium),
            const SizedBox(height: space4),
            if (receipts.isEmpty)
              Text(l.aiRecordEmpty, style: t.bodyMedium?.copyWith(color: p.textMuted))
            else ...[
              NoticeCard(
                tone: consent.sealIntact ? NoticeTone.quiet : NoticeTone.urgent,
                heading: consent.sealIntact ? l.aiRecordIntact : l.aiRecordBroken,
                body: '',
              ),
              const SizedBox(height: space3),
              for (final e in receipts) _Receipt(event: e, locale: locale),
              const SizedBox(height: space4),
              OutlinedButton.icon(
                onPressed: () => shareText(receiptsAsText(l, consent, locale), subject: l.aiRecordShareSubject),
                icon: const Icon(Icons.ios_share_rounded),
                label: Text(l.aiRecordShare),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The receipt time in her language and her phone's time zone, with Western digits.
String formatReceiptTime(String iso, String locale) {
  final at = DateTime.tryParse(iso)?.toLocal();
  if (at == null) return iso;
  return DateFormat.yMMMd(locale).add_Hm().format(at);
}

/// The ticked statements of [e], named shortly in her language.
String ackNames(L10n l, CloudConsentEvent e) => [
      for (final a in e.acks)
        switch (a) {
          AiAck.wellness => l.aiAckShortWellness,
          AiAck.notice => l.aiAckShortNotice,
          AiAck.cloud => l.aiAckShortCloud,
          _ => a,
        },
    ].join(' · ');

/// The whole record as plain text for sharing: one block per receipt, oldest first, with the
/// UTC time and the full seals, so a copy can be checked against the phone later.
String receiptsAsText(L10n l, CloudConsent consent, String locale) {
  final b = StringBuffer('${l.aiRecordTitle}\n${consent.sealIntact ? l.aiRecordIntact : l.aiRecordBroken}\n');
  for (final e in consent.log) {
    b
      ..writeln()
      ..writeln('${formatReceiptTime(e.at, locale)} (${e.at})')
      ..writeln(l.aiRecordAi(e.ai == null ? 'unknown' : (e.ai! ? 'on' : 'off')))
      ..writeln(l.aiRecordCloud(e.isWithdrawal ? l.aiRecordCloudOff : purposeNames(l, e.purposes)));
    if (e.acks.isNotEmpty) b.writeln(l.aiRecordAcks(ackNames(l, e)));
    b.writeln(l.aiRecordMeta(e.version, e.lang ?? '-', e.seal ?? '-'));
    if (e.prev != null) b.writeln('prev ${e.prev}');
  }
  return b.toString();
}

class _Receipt extends StatelessWidget {
  const _Receipt({required this.event, required this.locale});
  final CloudConsentEvent event;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final p = context.palette;
    final e = event;
    final seal = e.seal == null ? '-' : e.seal!.substring(0, _sealShown);
    return Container(
      margin: const EdgeInsets.only(bottom: space3),
      padding: const EdgeInsets.all(space3),
      decoration: BoxDecoration(border: Border.all(color: p.border), borderRadius: BorderRadius.circular(radiusMd)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formatReceiptTime(e.at, locale), style: t.titleSmall),
          const SizedBox(height: space1),
          Text(l.aiRecordAi(e.ai == null ? 'unknown' : (e.ai! ? 'on' : 'off')), style: t.bodyMedium),
          Text(l.aiRecordCloud(e.isWithdrawal ? l.aiRecordCloudOff : purposeNames(l, e.purposes)), style: t.bodyMedium),
          if (e.acks.isNotEmpty) Text(l.aiRecordAcks(ackNames(l, e)), style: t.bodySmall),
          const SizedBox(height: space1),
          Text(l.aiRecordMeta(e.version, e.lang ?? '-', seal), style: t.labelSmall?.copyWith(color: p.textMuted)),
        ],
      ),
    );
  }
}
