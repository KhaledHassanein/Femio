// The list of draft entries she checks before anything is saved (ADR-087).
//
// Why it exists: two AI uses (reading a report, notes after a visit) end in the same thing: a
// few suggested results and medicines. Each line has a tick she can clear and a pencil that
// opens the line's words for editing, so a misread value is fixed or dropped before it reaches
// her record (CLAUDE.md rule 7: it never writes without her confirming).

import 'package:flutter/material.dart';

import '../../domain/assistant/record_draft.dart';
import '../../domain/bidi_text.dart';
import '../../domain/health_record.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/spacing.dart';

/// Shows [lines] grouped as results then medicines, with a tick per line ([kept] holds the
/// indexes she keeps). [onToggle] flips one tick; [onEdit] replaces one line after she edits it.
class DraftLinesList extends StatelessWidget {
  const DraftLinesList({
    super.key,
    required this.lines,
    required this.kept,
    required this.onToggle,
    required this.onEdit,
  });
  final List<DraftLine> lines;
  final Set<int> kept;
  final ValueChanged<int> onToggle;
  final void Function(int index, DraftLine line) onEdit;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    Widget group(String heading, DraftKind kind) {
      final indexes = [for (final (i, line) in lines.indexed) if (line.kind == kind) i];
      if (indexes.isEmpty) return const SizedBox.shrink();
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.only(top: space4, bottom: space1),
          child: Semantics(header: true, child: Text(heading, style: t.titleSmall)),
        ),
        for (final i in indexes)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: kept.contains(i),
            onChanged: (_) => onToggle(i),
            title: Text(isolateText(lines[i].title)),
            subtitle: Text(isolateText(draftLineSummary(l, lines[i]))),
            secondary: IconButton(
              tooltip: l.draftEdit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                final edited = await showDialog<DraftLine>(
                  context: context,
                  builder: (_) => _EditLineDialog(line: lines[i]),
                );
                if (edited != null) onEdit(i, edited);
              },
            ),
          ),
      ]);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      group(l.draftResultsHeading, DraftKind.lab),
      group(l.draftMedicinesHeading, DraftKind.medicine),
    ]);
  }
}

/// One line's details in a sentence: value, unit and printed range for a result; dose and how
/// often for a medicine. Never a judgement, only what was printed or said.
String draftLineSummary(L10n l, DraftLine line) {
  final f = line.fields;
  if (line.kind == DraftKind.lab) {
    final value = [f[RecordField.value], f[RecordField.unit]].whereType<String>().join(' ');
    final range = f[RecordField.printedRange];
    return range == null ? value : l.draftLabWithRange(value, range);
  }
  return [f[RecordField.dose], f[RecordField.frequency]].whereType<String>().join(' · ');
}

/// The words of one line, editable. Pops the edited line, or nothing when she cancels.
class _EditLineDialog extends StatefulWidget {
  const _EditLineDialog({required this.line});
  final DraftLine line;

  @override
  State<_EditLineDialog> createState() => _EditLineDialogState();
}

class _EditLineDialogState extends State<_EditLineDialog> {
  late final _title = TextEditingController(text: widget.line.title);
  late final Map<String, TextEditingController> _fields = {
    for (final k in _keys) k: TextEditingController(text: widget.line.fields[k] ?? ''),
  };

  List<String> get _keys => widget.line.kind == DraftKind.lab
      ? const [RecordField.value, RecordField.unit, RecordField.printedRange]
      : const [RecordField.dose, RecordField.frequency];

  @override
  void dispose() {
    _title.dispose();
    for (final c in _fields.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _label(L10n l, String key) => switch (key) {
        RecordField.value => l.draftFieldValue,
        RecordField.unit => l.draftFieldUnit,
        RecordField.printedRange => l.draftFieldRange,
        RecordField.dose => l.draftFieldDose,
        _ => l.draftFieldFrequency,
      };

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return AlertDialog(
      title: Text(l.draftEdit),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: _title,
            maxLength: maxDraftTitle,
            decoration: InputDecoration(labelText: l.draftFieldName),
          ),
          for (final k in _keys)
            TextField(
              controller: _fields[k],
              maxLength: maxDraftField,
              decoration: InputDecoration(labelText: _label(l, k)),
            ),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.recCancel)),
        FilledButton(
          onPressed: () {
            final title = _title.text.trim();
            if (title.isEmpty) return;
            Navigator.of(context).pop(DraftLine(widget.line.kind, title, {
              for (final e in _fields.entries)
                if (e.value.text.trim().isNotEmpty) e.key: e.value.text.trim(),
            }));
          },
          child: Text(l.recSave),
        ),
      ],
    );
  }
}
