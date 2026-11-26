// Add or edit one entry of her health record (R11.1, ADR-082).
//
// Why it exists: every entry needs the day it happened (picked on a calendar, never
// guessed), her own title and the fields for its kind, typed as the report wrote them.
// Saving stamps added-on for a new entry and an edit trail for a changed one.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/bidi_text.dart';
import '../../domain/dates.dart';
import '../../domain/health_record.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import 'record_labels.dart';

/// How far back an entry's day may go: a lifetime of history, not a typo guard.
const recordEarliestYear = 1900;

/// The editor. [existing] null means a new entry of [initialKind].
class RecordEditor extends StatefulWidget {
  const RecordEditor({
    super.key,
    required this.controller,
    required this.today,
    required this.initialKind,
    this.existing,
  });
  final FemioController controller;
  final String today;
  final RecordKind initialKind;
  final RecordEntry? existing;

  @override
  State<RecordEditor> createState() => _RecordEditorState();
}

class _RecordEditorState extends State<RecordEditor> {
  late RecordKind _kind = widget.existing?.kind ?? widget.initialKind;
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late String? _happenedOn = widget.existing?.happenedOn;
  late final Map<String, TextEditingController> _text = {
    for (final k in RecordField.all)
      if (!recordDateFields.contains(k)) k: TextEditingController(text: widget.existing?.fields[k] ?? ''),
  };
  late final Map<String, String?> _dates = {
    for (final k in recordDateFields) k: widget.existing?.fields[k],
  };
  bool _tried = false;

  @override
  void dispose() {
    _title.dispose();
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<String?> _pickDay(String? current) async {
    final initial = fromISO(current ?? widget.today);
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(recordEarliestYear),
      lastDate: fromISO(widget.today),
    );
    return date == null ? null : toISO(date);
  }

  Map<String, String> _fields() => {
        for (final k in recordFieldsFor(_kind))
          if (recordDateFields.contains(k)) ...{if (_dates[k] != null) k: _dates[k]!} else k: _text[k]!.text,
      };

  Future<void> _save() async {
    setState(() => _tried = true);
    final title = _title.text.trim();
    if (title.isEmpty || _happenedOn == null) return;
    final now = DateTime.now().toIso8601String();
    final old = widget.existing;
    final entry = old == null
        ? RecordEntry.create(
            id: 'r${DateTime.now().microsecondsSinceEpoch}',
            kind: _kind,
            title: title,
            happenedOn: _happenedOn!,
            addedOn: now,
            fields: _fields(),
          )
        : old.edit(at: now, title: title, happenedOn: _happenedOn, fields: _fields());
    await widget.controller.saveRecordEntry(entry);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final l = L10n.of(context);
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.recDeleteTitle),
        content: Text(l.recDeleteBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(l.recCancel)),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(l.recDelete)),
        ],
      ),
    );
    if (yes != true) return;
    await widget.controller.deleteRecordEntry(widget.existing!.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    InputDecoration deco(String label, {String? hint, String? error}) => InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: error,
          filled: true,
          fillColor: p.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusMd)),
        );
    Widget dayRow(String label, String? value, VoidCallback onTap, {String? error}) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: p.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radiusMd),
                side: BorderSide(color: error == null ? p.border : p.danger),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(radiusMd),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(space4, space2h, space3, space2h),
                  child: Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(label, style: t.bodySmall),
                        Text(value == null ? '—' : DateFormat.yMMMd(locale).format(fromISO(value)), style: t.titleMedium),
                      ]),
                    ),
                    Icon(Icons.event_outlined, color: p.textSubtle),
                  ]),
                ),
              ),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: space3, top: space1),
                child: Text(error, style: t.bodySmall?.copyWith(color: p.danger)),
              ),
          ],
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? l.recAdd : l.recEdit),
        actions: [
          if (widget.existing != null)
            IconButton(tooltip: l.recDelete, onPressed: _delete, icon: const Icon(Icons.delete_outline_rounded)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(space5, space2, space5, space8),
        children: [
          Text(l.recFormKind, style: t.titleSmall),
          const SizedBox(height: space2),
          Wrap(spacing: space2, runSpacing: space2, children: [
            for (final k in RecordKind.values)
              ChoiceChip(
                avatar: Icon(recordKindIcon(k), size: 18),
                label: Text(recordKindLabel(l, k)),
                selected: _kind == k,
                onSelected: (_) => setState(() => _kind = k),
              ),
          ]),
          const SizedBox(height: space4),
          TextField(
            controller: _title,
            textCapitalization: TextCapitalization.sentences,
            // Her words keep their own direction ("TSH" in an Arabic screen).
            textDirection: directionOfText(_title.text, Directionality.of(context)),
            onChanged: (_) => setState(() {}),
            decoration: deco(
              l.recFormTitle,
              hint: l.recFormTitleHint,
              error: _tried && _title.text.trim().isEmpty ? l.recNeedTitle : null,
            ),
          ),
          const SizedBox(height: space3),
          dayRow(
            l.recFormHappened,
            _happenedOn,
            () async {
              final d = await _pickDay(_happenedOn);
              if (d != null) setState(() => _happenedOn = d);
            },
            error: _tried && _happenedOn == null ? l.recNeedDate : null,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: space3, top: space1h),
            child: Text(l.recFormHappenedHint, style: t.bodySmall),
          ),
          for (final k in recordFieldsFor(_kind)) ...[
            const SizedBox(height: space3),
            if (recordDateFields.contains(k))
              dayRow(recordFieldLabel(l, k), _dates[k], () async {
                final d = await _pickDay(_dates[k]);
                if (d != null) setState(() => _dates[k] = d);
              })
            else
              TextField(
                controller: _text[k],
                // "0.4 - 4.0" must read as printed, never turned around in Arabic.
                textDirection: directionOfText(_text[k]!.text, Directionality.of(context)),
                onChanged: (_) => setState(() {}),
                minLines: k == RecordField.details ? 2 : 1,
                maxLines: k == RecordField.details ? 6 : 1,
                decoration: deco(recordFieldLabel(l, k)),
              ),
          ],
          const SizedBox(height: space6),
          FilledButton(onPressed: _save, child: Text(l.recSave)),
          const SizedBox(height: space2),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.recCancel)),
          const SizedBox(height: space2),
          Text(l.recNoVerdictNote, style: t.bodySmall),
        ],
      ),
    );
  }
}
