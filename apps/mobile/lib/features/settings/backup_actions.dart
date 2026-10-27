// Export and import of the backup file, with the passphrase prompts.
//
// Why it exists: Settings and the recovery screen both offer backup; the file
// picking (Storage Access Framework: she chooses the folder, the app sees only that
// file) and the passphrase rules live here once. Nothing is written anywhere she
// did not pick, and the passphrase is never stored.

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/backup.dart';
import '../../l10n/app_localizations.dart';

/// Asks for a passphrase (twice when [confirm]); null when she cancels.
Future<String?> askPassphrase(BuildContext context, {required String title, required bool confirm}) async {
  final l = L10n.of(context);
  final first = TextEditingController();
  final second = TextEditingController();
  String? error;
  return showDialog<String>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.backupPassphraseHint, style: Theme.of(context).textTheme.bodySmall),
            TextField(controller: first, obscureText: true, autofocus: true, decoration: InputDecoration(labelText: l.backupPassphrase)),
            if (confirm) TextField(controller: second, obscureText: true, decoration: InputDecoration(labelText: l.backupPassphraseAgain)),
            if (error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(null), child: Text(l.back)),
          FilledButton(
            onPressed: () {
              if (first.text.length < minPassphraseLength) {
                setState(() => error = l.backupPassphraseShort(minPassphraseLength));
                return;
              }
              if (confirm && first.text != second.text) {
                setState(() => error = l.backupPassphraseMismatch);
                return;
              }
              Navigator.of(context).pop(first.text);
            },
            child: Text(l.continueLabel),
          ),
        ],
      ),
    ),
  );
}

/// Seals the record and lets her save the file where she chooses.
Future<void> exportBackupFlow(BuildContext context, FemioController controller) async {
  final l = L10n.of(context);
  final passphrase = await askPassphrase(context, title: l.exportBackup, confirm: true);
  if (passphrase == null || !context.mounted) return;
  final bytes = await controller.exportBackup(passphrase);
  final saved = await FilePicker.saveFile(
    dialogTitle: l.exportBackup,
    fileName: backupFileName(DateTime.now()),
    bytes: bytes,
  );
  if (!context.mounted) return;
  if (saved != null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.backupSaved)));
  }
}

/// Lets her pick a backup file and replaces the record with it after the passphrase.
Future<void> importBackupFlow(BuildContext context, FemioController controller) async {
  final l = L10n.of(context);
  final picked = await FilePicker.pickFiles(dialogTitle: l.importBackup);
  if (picked.isEmpty) return;
  final bytes = await picked.single.readAsBytes();
  if (!context.mounted) return;
  final passphrase = await askPassphrase(context, title: l.importBackup, confirm: false);
  if (passphrase == null || !context.mounted) return;
  try {
    await controller.importBackup(bytes, passphrase);
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.backupImported)));
  } on BackupError catch (e) {
    if (!context.mounted) return;
    final message = switch (e.failure) {
      BackupFailure.wrongPassphrase => l.backupWrongPassphrase,
      BackupFailure.notAFemioFile => l.backupNotFemio,
      BackupFailure.unreadableRecord => l.backupUnreadable,
    };
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
