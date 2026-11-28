// Add or edit one entry of her health record (R11.1, ADR-082).
//
// Why it exists: every entry needs the day it happened (picked on a calendar, never
// guessed), her own title and the fields for its kind, typed as the report wrote them.
// Saving stamps added-on for a new entry and an edit trail for a changed one. Documents and
// photos are attached here too (R11.2); one added and then abandoned is deleted on the way out.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/bidi_text.dart';
import '../../domain/dates.dart';
import '../../domain/health_record.dart';
import '../../domain/record_charts.dart' show parseReadingNumber;
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import 'documents_section.dart';
import 'record_labels.dart';

/// How far back an entry's day may go: a lifetime of history, not a typo guard.
const recordEarliestYear = 1900;

/// How many years ahead a planned end day may go (a medicine course that ends later).
const recordFutureYears = 5;

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
  late List<String> _attachmentIds = [...?widget.existing?.attachmentIds];

  /// Documents added while this editor was open; any still unlinked on the way out are deleted.
  final _addedHere = <String>{};
  bool _tried = false;

  @override
  void dispose() {
    unawaited(widget.controller.documents.dropUnlinked(_addedHere));
    _title.dispose();
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  /// A day on the calendar. [future] allows days after today (a medicine's planned end).
  Future<String?> _pickDay(String? current, {bool future = false}) async {
    final today = fromISO(widget.today);
    final last = future ? DateTime(today.year + recordFutureYears, today.month, today.day) : today;
    final initial = fromISO(current ?? widget.today);
    final date = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(last) ? last : initial,
      firstDate: DateTime(recordEarliestYear),
      lastDate: last,
    );
    return date == null ? null : toISO(date);
  }

  Map<String, String> _fields() => {
        for (final k in recordFieldsFor(_kind))
          if (recordDateFields.contains(k)) ...{if (_dates[k] != null) k: _dates[k]!} else k: _text[k]!.text,
      };

  /// Blood pressure and glucose need no title of her own: the kind names them.
  bool get _isReading => _kind == RecordKind.bloodPressure || _kind == RecordKind.glucose;

  /// The number on a reading field, or null when it is blank or not a number above zero.
  double? _number(String field) {
    final v = parseReadingNumber(_text[field]!.text);
    return v != null && v > 0 ? v : null;
  }

  /// Why [field] cannot be saved yet, or null. Only checks that a number is a number: femio
  /// never says a reading is too high or too low.
  String? _fieldError(L10n l, String field) {
    if (!_tried) return null;
    return switch ((_kind, field)) {
      (RecordKind.bloodPressure, RecordField.systolic || RecordField.diastolic) =>
        _number(field) == null ? l.chartNeedNumber : null,
      (RecordKind.bloodPressure, RecordField.pulse) =>
        _text[field]!.text.trim().isNotEmpty && _number(field) == null ? l.chartNeedNumber : null,
      (RecordKind.glucose, RecordField.value) => _number(field) == null ? l.chartNeedNumber : null,
      (RecordKind.glucose, RecordField.unit) => _text[field]!.text.trim().isEmpty ? l.chartNeedUnit : null,
      _ => null,
    };
  }

  Future<void> _save() async {
    setState(() => _tried = true);
    final l = L10n.of(context);
    final title = _title.text.trim().isEmpty && _isReading ? recordKindLabel(l, _kind) : _title.text.trim();
    if (title.isEmpty || _happenedOn == null) return;
    if (recordFieldsFor(_kind).any((k) => _fieldError(l, k) != null)) return;
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
            attachmentIds: _attachmentIds,
          )
        : old.edit(at: now, title: title, happenedOn: _happenedOn, fields: _fields(), attachmentIds: _attachmentIds);
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

  /// The fields typed as a number, so the phone shows a number pad.
  static const _numeric = {RecordField.systolic, RecordField.diastolic, RecordField.pulse};

  /// A row of chips for a field with a few fixed answers (glucose unit, when it was taken).
  /// The stored text is the option's key, exactly as listed; tapping the chosen one clears it.
  Widget _choiceField({
    required String label,
    required TextEditingController controller,
    required Map<String, String> options,
    String? error,
  }) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: t.titleSmall),
      const SizedBox(height: space2),
      Wrap(spacing: space2, runSpacing: space2, children: [
        for (final o in options.entries)
          ChoiceChip(
            label: Text(o.value),
            selected: controller.text == o.key,
            onSelected: (on) => setState(() => controller.text = on ? o.key : ''),
          ),
      ]),
      if (error != null)
        Padding(
          padding: const EdgeInsetsDirectional.only(start: space3, top: space1),
          child: Text(error, style: t.bodySmall?.copyWith(color: p.danger)),
        ),
    ]);
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
                onSelected: (_) => setState(() {
                  _kind = k;
                  // A lab's unit typed before switching is not one of the glucose choices.
                  if (k == RecordKind.glucose) {
                    if (!glucoseUnits.contains(_text[RecordField.unit]!.text)) _text[RecordField.unit]!.clear();
                    if (!glucoseContexts.contains(_text[RecordField.context]!.text)) _text[RecordField.context]!.clear();
                  }
                }),
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
              error: _tried && _title.text.trim().isEmpty && !_isReading ? l.recNeedTitle : null,
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
                final d = await _pickDay(_dates[k], future: k == RecordField.endedOn);
                if (d != null) setState(() => _dates[k] = d);
              })
            else if (_kind == RecordKind.glucose && (k == RecordField.unit || k == RecordField.context))
              _choiceField(
                label: recordFieldLabel(l, k),
                controller: _text[k]!,
                options: k == RecordField.unit
                    ? {for (final u in glucoseUnits) u: u}
                    : {for (final c in glucoseContexts) c: glucoseContextLabel(l, c)},
                error: _fieldError(l, k),
              )
            else
              TextField(
                controller: _text[k],
                keyboardType: _numeric.contains(k) || (_kind == RecordKind.glucose && k == RecordField.value)
                    ? const TextInputType.numberWithOptions(decimal: true) : null,
                // "0.4 - 4.0" must read as printed, never turned around in Arabic.
                textDirection: directionOfText(_text[k]!.text, Directionality.of(context)),
                onChanged: (_) => setState(() {}),
                minLines: k == RecordField.details ? 2 : 1,
                maxLines: k == RecordField.details ? 6 : 1,
                decoration: deco(recordFieldLabel(l, k), error: _fieldError(l, k)),
              ),
          ],
          const SizedBox(height: space5),
          DocumentsSection(
            controller: widget.controller,
            ids: _attachmentIds,
            onChanged: (ids) => setState(() => _attachmentIds = ids),
            onAdded: _addedHere.add,
          ),
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
