// Settings › Assistant › "What the AI did": the AI ledger, newest first (R10.3, U34).
//
// Why it exists: "What the AI can see" says what each use may read; this page shows what
// actually ran, when and where. For Cloud boost it shows the exact text that left the phone, so
// she can check it against her consent. The entries come from `FemioController.aiLedger`; the
// page only lists them and lets her clear them.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/assistant/ai_ledger.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import 'ai_sees_screen.dart' show aiUseName;

/// The ledger page.
class AiLedgerScreen extends StatelessWidget {
  const AiLedgerScreen({super.key, required this.controller});
  final FemioController controller;

  Future<void> _confirmClear(BuildContext context) async {
    final l = L10n.of(context);
    final m = MaterialLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l.aiLedgerClearConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(m.cancelButtonLabel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l.aiLedgerClear)),
        ],
      ),
    );
    if (ok == true) await controller.clearAiLedger();
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(l.aiLedgerTitle)),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final entries = controller.aiLedger;
            return ListView(
              padding: const EdgeInsets.fromLTRB(space5, space3, space5, space8),
              children: [
                Text(l.aiLedgerIntro, style: t.bodyMedium),
                const SizedBox(height: space4),
                if (entries.isEmpty)
                  Text(l.aiLedgerEmpty, style: t.bodyLarge)
                else ...[
                  for (final e in entries) _EntryCard(entry: e),
                  const SizedBox(height: space3),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmClear(context),
                      icon: const Icon(Icons.delete_sweep_outlined),
                      label: Text(l.aiLedgerClear),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});
  final LedgerEntry entry;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final when = DateTime.tryParse(entry.at)?.toLocal();
    final sent = entry.sent;
    return Container(
      margin: const EdgeInsets.only(bottom: space3),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusMd),
        border: Border.all(color: p.border),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.all(space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(entry.cloud ? Icons.cloud_outlined : Icons.smartphone_rounded, color: p.primary),
                  const SizedBox(width: space2),
                  Expanded(child: Text(aiUseName(l, entry.use), style: t.titleSmall)),
                ],
              ),
              const SizedBox(height: space1h),
              if (when != null) Text(DateFormat.yMMMd(locale).add_jm().format(when), style: t.bodySmall),
              Text(entry.cloud ? l.aiLedgerInCloud : l.aiLedgerOnPhone, style: t.bodyMedium),
              if (!entry.answered) Text(l.aiLedgerNoReply, style: t.bodySmall?.copyWith(color: p.textMuted)),
              if (sent != null)
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  shape: const Border(),
                  collapsedShape: const Border(),
                  childrenPadding: const EdgeInsetsDirectional.only(bottom: space2),
                  title: Text(l.aiLedgerSent, style: t.labelLarge?.copyWith(color: p.primary)),
                  children: [
                    // The text is what the model received; prompts are written in English.
                    SelectableText(sent, textDirection: TextDirection.ltr, style: t.bodySmall),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
