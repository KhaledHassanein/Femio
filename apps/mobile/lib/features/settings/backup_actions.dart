// Export and import of the backup file, with the passphrase prompts.
//
// Why it exists: Settings and the recovery screen both offer backup; the file
// picking (Storage Access Framework: she chooses the folder, the app sees only that
// file) and the passphrase rules live here once. Nothing is written anywhere she
// did not pick, and the passphrase is never stored.

import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/backup.dart';
import '../../data/document_source.dart' show clearPickerCopies;
import '../../data/record_documents.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/spacing.dart';

/// Asks for a passphrase (twice when [confirm]); null when she cancels. A new passphrase
/// ([confirm]) needs [minNewPassphraseLength] characters; opening an existing file accepts
/// the older, shorter floor so backups made before ADR-085 still open.
Future<String?> askPassphrase(BuildContext context, {required String title, required bool confirm}) async {
  final l = L10n.of(context);
  final minLength = confirm ? minNewPassphraseLength : minPassphraseLength;
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
              if (first.text.length < minLength) {
                setState(() => error = l.backupPassphraseShort(minLength));
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

/// Runs [work] (the passphrase key derivation and the sealing) behind a small modal
/// "working" dialog, so the few seconds a 600,000-round key takes on a phone (ADR-085) never
/// look like a frozen app, and nothing else can be tapped meanwhile. Rethrows what [work] throws.
Future<T> _whileWorking<T>(BuildContext context, Future<T> Function() work) async {
  final l = L10n.of(context);
  final navigator = Navigator.of(context, rootNavigator: true);
  var open = true;
  unawaited(showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(children: [
          const CircularProgressIndicator(),
          const SizedBox(width: space4),
          Expanded(child: Text(l.backupWorking)),
        ]),
      ),
    ),
  ).whenComplete(() => open = false));
  try {
    return await work();
  } finally {
    if (open) navigator.pop();
  }
}

/// Seals the record and lets her save the file where she chooses.
Future<void> exportBackupFlow(BuildContext context, FemioController controller) async {
  final l = L10n.of(context);
  final passphrase = await askPassphrase(context, title: l.exportBackup, confirm: true);
  if (passphrase == null || !context.mounted) return;
  final Uint8List bytes;
  try {
    bytes = await _whileWorking(context, () => controller.exportBackup(passphrase));
  } on BackupTooLargeError {
    // Her documents are over what one backup carries (ADR-082 §2): say so, never cut silently.
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.backupTooLarge)));
    return;
  }
  if (!context.mounted) return;
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
  // Size first (SEC-11): a file bigger than any backup femio writes is refused unread.
  final length = await picked.single.length();
  final bytes = length != null && length > maxBackupFileBytes ? null : await picked.single.readAsBytes();
  // The picker copied the file into the app's cache; the bytes are in memory now (SEC-15).
  await clearPickerCopies();
  if (!context.mounted) return;
  if (bytes == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.backupNotFemio)));
    return;
  }
  final passphrase = await askPassphrase(context, title: l.importBackup, confirm: false);
  if (passphrase == null || !context.mounted) return;
  try {
    await _whileWorking(context, () => controller.importBackup(bytes, passphrase));
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
