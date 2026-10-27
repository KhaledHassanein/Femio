// Shown when the record on the phone could not be read.
//
// Why it exists: a file that fails to open must never be silently replaced by an
// empty record (study report 04). The store moved it aside; this screen tells her
// what happened and gives the two honest ways forward: restore a backup, or start
// over knowing what is lost.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import 'backup_actions.dart';
import 'delete_dialog.dart';

/// The recovery screen after a quarantined record.
class CorruptRecordScreen extends StatelessWidget {
  const CorruptRecordScreen({super.key, required this.controller});
  final FemioController controller;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(space6),
          children: [
            Semantics(header: true, child: Text(l.corruptTitle, style: t.headlineMedium)),
            const SizedBox(height: space3),
            Text(l.corruptBody, style: t.bodyMedium?.copyWith(color: p.textMuted)),
            const SizedBox(height: space6),
            NoticeCard(tone: NoticeTone.quiet, heading: l.backupSection, body: l.backupHonesty),
            const SizedBox(height: space6),
            FilledButton.icon(
              onPressed: () => importBackupFlow(context, controller),
              icon: const Icon(Icons.restore_rounded),
              label: Text(l.importBackup),
            ),
            const SizedBox(height: space3),
            OutlinedButton(
              onPressed: () => confirmDeleteEverything(context, controller),
              child: Text(l.startOver),
            ),
          ],
        ),
      ),
    );
  }
}
