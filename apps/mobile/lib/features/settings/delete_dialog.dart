// The one irreversible action, behind a confirmation that says what it costs.
//
// Why it exists: "Start over" used to wipe the record with no confirmation (study
// report 04). The words come from the legal pack and name what is lost and what is
// not (backup files she saved elsewhere). Since 2026-11-27 (owner) she must also tick a
// box saying she understands it is erased for good and femio keeps no copy; the delete
// button stays disabled until she does.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../l10n/app_localizations.dart';

/// Asks, then deletes her record, settings and PIN from this phone.
Future<void> confirmDeleteEverything(BuildContext context, FemioController controller) async {
  final l = L10n.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      var understood = false;
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l.deleteConfirmTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.deleteConfirmBody),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: understood,
                  onChanged: (v) => setState(() => understood = v ?? false),
                  title: Text(l.deleteConfirmAck, style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l.deleteConfirmCancel)),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
              onPressed: understood ? () => Navigator.of(context).pop(true) : null,
              child: Text(l.deleteConfirmAction),
            ),
          ],
        ),
      );
    },
  );
  if (confirmed == true) {
    await controller.deleteEverything();
    if (context.mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
