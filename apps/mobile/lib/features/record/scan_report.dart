// Read a report with AI: a photo or PDF of a lab report or prescription, read by Gemini Nano on
// the phone into results and medicines she checks before saving (R11.3, ADR-087).
//
// Why it exists: typing every value off a lab report is the chore that stops a record being
// kept. On a phone with Gemini Nano the AI fills the draft; on any other phone the document is
// still saved and she types the results, and femio says why the AI cannot read it (owner
// 2026-11-28). The document never leaves the phone: the call is ONLY_ON_DEVICE, with no cloud
// fallback. Saved results join her record, so her history and charts include them.

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../data/assistant_gateway.dart';
import '../../data/record_documents.dart';
import '../../domain/assistant/record_draft.dart';
import '../../domain/dates.dart';
import '../../domain/health_record.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/type_sizes.dart';
import '../assistant/assistant_scope.dart';
import 'draft_lines.dart';
import 'record_editor.dart';

/// Starts "Read a report with AI" from the + sheet: checks the phone can read documents, lets
/// her take a photo or choose a file, saves it to My documents, then opens the draft. On a phone
/// without Gemini Nano it says why and opens a lab result entry where she attaches it by hand.
Future<void> startScanReport(BuildContext context, {required FemioController controller, required String today}) async {
  final l = L10n.of(context);
  final nav = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final status = await AssistantScope.gatewayOf(context).status();
  if (!context.mounted) return;
  if (!status.canRunPrivate) {
    final attach = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.scanNoAiTitle),
        content: Text(l.scanNoAiBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(l.recCancel)),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(l.scanAttachInstead)),
        ],
      ),
    );
    if (attach == true) {
      await nav.push(MaterialPageRoute<void>(
        builder: (_) => RecordEditor(controller: controller, today: today, initialKind: RecordKind.lab),
      ));
    }
    return;
  }
  final source = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          leading: const Icon(Icons.photo_camera_outlined),
          title: Text(l.recDocsTakePhoto),
          onTap: () => Navigator.of(ctx).pop(true),
        ),
        ListTile(
          leading: const Icon(Icons.upload_file_outlined),
          title: Text(l.recDocsAddFile),
          onTap: () => Navigator.of(ctx).pop(false),
        ),
      ]),
    ),
  );
  if (source == null) return;
  final picked = await (source ? controller.deviceFiles.takePhoto() : controller.deviceFiles.pickFile());
  if (picked == null) return;
  if (picked.tooLarge) {
    messenger.showSnackBar(SnackBar(content: Text(l.recDocsTooLarge)));
    return;
  }
  final name = picked.name.isNotEmpty ? picked.name : l.recDocsPhotoName(DateFormat.yMMMd(l.localeName).add_Hm().format(DateTime.now()));
  final result = await controller.documents.add(picked.bytes, name, mime: picked.mime);
  final added = result.attachment;
  if (added == null) {
    messenger.showSnackBar(SnackBar(
      content: Text(switch (result.failure!) {
        AddDocumentFailure.tooLarge => l.recDocsTooLarge,
        AddDocumentFailure.unsupportedType => l.recDocsUnsupported,
        AddDocumentFailure.empty => l.recDocUnreadable,
      }),
    ));
    return;
  }
  await nav.push(MaterialPageRoute<void>(
    builder: (_) => ScanDraftScreen(controller: controller, documentId: added.id, today: today),
  ));
}

/// Reads document [documentId] on the phone and shows the draft for her to check. [today] is
/// the ISO day. Public for the document viewer's "Read with AI" and for tests.
class ScanDraftScreen extends StatefulWidget {
  const ScanDraftScreen({super.key, required this.controller, required this.documentId, required this.today});
  final FemioController controller;
  final String documentId;
  final String today;

  @override
  State<ScanDraftScreen> createState() => _ScanDraftScreenState();
}

class _ScanDraftScreenState extends State<ScanDraftScreen> {
  bool _reading = true;
  bool _failed = false;
  List<DraftLine> _lines = const [];
  final _kept = <int>{};
  String? _date;
  bool _tried = false;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reading && _lines.isEmpty && !_failed) _read();
  }

  bool _started = false;

  Future<void> _read() async {
    if (_started) return;
    _started = true;
    final gateway = AssistantScope.gatewayOf(context);
    final pages = await _pages();
    final AssistantResult<RecordDraft> result =
        pages.isEmpty ? const AssistantResult.rules() : await gateway.readDocument(pages, widget.today);
    if (!mounted) return;
    final draft = result.value;
    setState(() {
      _reading = false;
      _failed = draft == null;
      _lines = draft?.lines ?? const [];
      _kept.addAll(List.generate(_lines.length, (i) => i));
      _date = draft?.date;
    });
  }

  /// The pictures the AI reads: the photo itself, or the first [maxScanPages] PDF pages.
  Future<List<Uint8List>> _pages() async {
    final docs = widget.controller.documents;
    final a = docs.byId(widget.documentId);
    final bytes = await docs.bytes(widget.documentId);
    if (a == null || bytes == null) return const [];
    if (a.isImage) return [bytes];
    final pages = await widget.controller.deviceFiles.pdfPages(bytes);
    return pages.take(maxScanPages).toList();
  }

  Future<void> _pickDate() async {
    final today = fromISO(widget.today);
    final picked = await showDatePicker(
      context: context,
      initialDate: _date == null ? today : fromISO(_date!),
      firstDate: DateTime(earliestDraftYear),
      lastDate: today,
    );
    if (picked != null) setState(() => _date = toISO(picked));
  }

  Future<void> _save() async {
    setState(() => _tried = true);
    final date = _date;
    if (date == null || _kept.isEmpty || _saving) return;
    setState(() => _saving = true);
    final l = L10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final entries = entriesFromDraft(
      [for (final i in _kept.toList()..sort()) _lines[i]],
      happenedOn: date,
      addedOn: DateTime.now().toIso8601String(),
      idPrefix: 'r${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(1 << 16)}',
      source: RecordSource.scanned,
      attachmentId: widget.documentId,
    );
    for (final e in entries) {
      await widget.controller.saveRecordEntry(e);
    }
    messenger.showSnackBar(SnackBar(content: Text(l.scanSaved(entries.length))));
    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Scaffold(
      appBar: AppBar(title: Text(l.scanTitle)),
      body: _reading
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(space6),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: space4),
                  Text(l.scanReading, textAlign: TextAlign.center, style: t.bodyMedium),
                ]),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(space5, space3, space5, space6),
              children: [
                Text(
                  _failed ? l.scanFailed : (_lines.isEmpty ? l.scanNothing : l.scanIntro),
                  style: t.bodyMedium,
                ),
                if (_lines.isNotEmpty) ...[
                  const SizedBox(height: space4),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.event_outlined, color: p.primary),
                    title: Text(l.scanDateLabel),
                    subtitle: Text(
                      _date == null ? l.scanDateMissing : DateFormat.yMMMd(locale).format(fromISO(_date!)),
                      style: _tried && _date == null ? t.bodySmall?.copyWith(color: p.danger) : null,
                    ),
                    trailing: const Icon(Icons.edit_calendar_outlined),
                    onTap: _pickDate,
                  ),
                  DraftLinesList(
                    lines: _lines,
                    kept: _kept,
                    onToggle: (i) => setState(() => _kept.contains(i) ? _kept.remove(i) : _kept.add(i)),
                    onEdit: (i, line) => setState(() => _lines = [..._lines]..[i] = line),
                  ),
                ],
                const SizedBox(height: space4),
                Row(children: [
                  Icon(Icons.lock_outline_rounded, size: iconSizeInline, color: p.textSubtle),
                  const SizedBox(width: space1h),
                  Expanded(child: Text(l.scanPrivateNote, style: t.bodySmall)),
                ]),
              ],
            ),
      bottomNavigationBar: !_reading && _lines.isNotEmpty
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(space5, space2, space5, space3),
                child: FilledButton(
                  onPressed: _kept.isEmpty || _saving ? null : _save,
                  child: Text(l.recSave),
                ),
              ),
            )
          : null,
    );
  }
}
