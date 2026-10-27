// The one irreversible action, behind a confirmation that says what it costs.
//
// Why it exists: "Start over" used to wipe the record with no confirmation (study
// report 04). The words come from the legal pack and name what is lost and what is
// not (backup files she saved elsewhere).

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../l10n/app_localizations.dart';

/// Asks, then deletes her record, settings and PIN from this phone.
Future<void> confirmDeleteEverything(BuildContext context, FemioController controller) async {
  final l = L10n.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.deleteConfirmTitle),
      content: Text(l.deleteConfirmBody),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l.deleteConfirmCancel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l.deleteConfirmAction),
        ),
      ],
    ),
  );
  if (confirmed == true) {
    await controller.deleteEverything();
    if (context.mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
