// "Report this answer": the in-app flag on every answer the AI wrote (R14.18).
//
// Why it exists: Google Play's AI-Generated Content policy asks apps that generate content
// with AI for an in-app way to report or flag it. femio has no server and no network code
// of its own (ADR-080), so the report is built here, in the app, and handed to the phone's
// share sheet addressed to femio's support inbox. It holds only the answer, where it was
// made and the reason she picked: never her question, never her record.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/share_channel.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/spacing.dart';

/// Where reports go: the support address the website and the store listing publish.
const answerReportAddress = 'info@femioapp.com';

/// Why she flags an answer.
enum ReportReason { wrong, unsafe, offensive, other }

/// The label for [r] in her language.
String reportReasonLabel(L10n l, ReportReason r) => switch (r) {
      ReportReason.wrong => l.reportWrong,
      ReportReason.unsafe => l.reportUnsafe,
      ReportReason.offensive => l.reportOffensive,
      ReportReason.other => l.reportOther,
    };

/// The report's text: the reason, where the answer was made, and the answer word for word.
/// Nothing else: no question, no record, no device details.
String answerReportText(L10n l, {required ReportReason reason, required String origin, required String answer}) =>
    l.reportText(reportReasonLabel(l, reason), origin, answer);

/// Opens the report sheet for [answer], made where [origin] says (the card's own label).
Future<void> showReportAnswerSheet(BuildContext context, {required String answer, required String origin}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ReportAnswerSheet(answer: answer, origin: origin),
    );

/// The sheet: why she is reporting, what the report holds, and Send. Public for tests.
class ReportAnswerSheet extends StatefulWidget {
  const ReportAnswerSheet({super.key, required this.answer, required this.origin});
  final String answer;
  final String origin;

  @override
  State<ReportAnswerSheet> createState() => _ReportAnswerSheetState();
}

class _ReportAnswerSheetState extends State<ReportAnswerSheet> {
  ReportReason? _reason;

  Future<void> _send() async {
    final l = L10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final text = answerReportText(l, reason: _reason!, origin: widget.origin, answer: widget.answer);
    final shared = await shareText(text, subject: l.reportSubject, to: answerReportAddress);
    if (!shared) await Clipboard.setData(ClipboardData(text: text));
    nav.pop();
    messenger.showSnackBar(SnackBar(
      content: Text(shared ? l.reportThanks : l.reportCopied(answerReportAddress)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(space5, 0, space5, space5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Semantics(header: true, child: Text(l.reportTitle, style: t.titleLarge)),
          const SizedBox(height: space2),
          Text(l.reportBody(answerReportAddress), style: t.bodyMedium),
          const SizedBox(height: space4),
          Wrap(spacing: space2, runSpacing: space2, children: [
            for (final r in ReportReason.values)
              ChoiceChip(
                label: Text(reportReasonLabel(l, r)),
                selected: _reason == r,
                onSelected: (_) => setState(() => _reason = r),
              ),
          ]),
          const SizedBox(height: space5),
          FilledButton(onPressed: _reason == null ? null : _send, child: Text(l.reportSend)),
        ]),
      ),
    );
  }
}
