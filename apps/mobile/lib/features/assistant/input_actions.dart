// The two buttons at the end of every assistant text box: add a report, and speak
// (owner 2026-11-28).
//
// Why it exists: she looked for a way to add a photo or PDF of a report from where she talks to
// femio and did not find it (it lived only behind the "+" tab). Every box where she writes to
// the assistant (Ask femio, Say it, After a visit) now ends with the same pair: a paperclip that
// starts "Read a report" (photo or file, read on the phone, checked line by line before
// saving) and the mic.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../record/scan_report.dart';
import 'mic_button.dart';

/// A paperclip and a mic for a text field's `suffixIcon`. [text] is the field the mic fills;
/// [controller] and [today] (ISO day) start the report reader. [enabled] greys both out while
/// the screen is busy.
class AssistantInputActions extends StatelessWidget {
  const AssistantInputActions({
    super.key,
    required this.text,
    required this.controller,
    required this.today,
    this.enabled = true,
  });

  final TextEditingController text;
  final FemioController controller;
  final String today;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(
        tooltip: l.attachReport,
        onPressed: enabled ? () => startScanReport(context, controller: controller, today: today) : null,
        icon: Icon(Icons.attach_file_rounded, color: p.textMuted),
      ),
      MicButton(controller: text, enabled: enabled),
    ]);
  }
}
