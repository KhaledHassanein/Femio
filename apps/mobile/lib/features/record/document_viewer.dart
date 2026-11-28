// One document, full screen: a photo she can zoom, or a PDF's pages drawn on the phone (R11.2).
//
// Why it exists: reading her own report should never mean handing it to another app. From here
// she can rename it, share it through the system sheet (her choice, said plainly), take it off
// the entry she came from, or delete it everywhere after a confirmation.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;

import '../../app.dart';
import '../../domain/bidi_text.dart';
import '../../domain/record_attachment.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../domain/dates.dart';
import '../assistant/assistant_scope.dart';
import 'scan_report.dart';

/// What the viewer did, for the screen that opened it.
enum DocumentViewerResult { unlinked, deleted }

/// The viewer for document [id]. [canUnlink] shows "Remove from this entry" (opened from an
/// entry's editor).
class DocumentViewer extends StatefulWidget {
  const DocumentViewer({super.key, required this.controller, required this.id, this.canUnlink = false});
  final FemioController controller;
  final String id;
  final bool canUnlink;

  @override
  State<DocumentViewer> createState() => _DocumentViewerState();
}

enum _Action { rename, unlink, delete }

class _DocumentViewerState extends State<DocumentViewer> {
  late final Future<_Loaded> _content = _load();

  /// Whether Gemini Nano can read this document here (ADR-087); without it the button is not
  /// shown, and the document stays attach-only.
  bool _canRead = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AssistantScope.gatewayOf(context).status().then((s) {
      if (mounted && s.canRunPrivate != _canRead) setState(() => _canRead = s.canRunPrivate);
    });
  }

  Future<void> _readWithAi() => Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => ScanDraftScreen(
          controller: widget.controller,
          documentId: widget.id,
          today: toISO(DateTime.now()),
        ),
      ));

  Future<_Loaded> _load() async {
    final a = widget.controller.documents.byId(widget.id);
    final bytes = await widget.controller.documents.bytes(widget.id);
    if (a == null || bytes == null) return const _Loaded(null, []);
    if (a.isImage) return _Loaded(bytes, const []);
    return _Loaded(bytes, await widget.controller.deviceFiles.pdfPages(bytes));
  }

  RecordAttachment? get _attachment => widget.controller.documents.byId(widget.id);

  Future<void> _rename() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _RenameDialog(initial: _attachment?.name ?? ''),
    );
    if (name == null) return;
    await widget.controller.documents.rename(widget.id, name);
    if (mounted) setState(() {});
  }

  Future<void> _share(Uint8List bytes) async {
    final a = _attachment;
    if (a == null) return;
    final ok = await widget.controller.deviceFiles.share(bytes, a.name, a.mime);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.of(context).recDocShareFailed)));
    }
  }

  Future<void> _delete() async {
    final l = L10n.of(context);
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.recDocDeleteTitle),
        content: Text(l.recDocDeleteBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(l.recCancel)),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(l.recDelete)),
        ],
      ),
    );
    if (yes != true) return;
    await widget.controller.documents.delete(widget.id);
    if (mounted) Navigator.of(context).pop(DocumentViewerResult.deleted);
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final a = _attachment;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return FutureBuilder<_Loaded>(
      future: _content,
      builder: (context, snap) {
        final loaded = snap.data;
        final bytes = loaded?.bytes;
        return Scaffold(
          appBar: AppBar(
            title: Text(isolateText(a?.name ?? ''), maxLines: 1, overflow: TextOverflow.ellipsis),
            actions: [
              if (bytes != null && _canRead)
                IconButton(tooltip: l.scanReadWithAi, onPressed: _readWithAi, icon: const Icon(Icons.document_scanner_outlined)),
              if (bytes != null)
                IconButton(tooltip: l.recDocShare, onPressed: () => _share(bytes), icon: const Icon(Icons.ios_share_rounded)),
              PopupMenuButton<_Action>(
                onSelected: (action) => switch (action) {
                  _Action.rename => _rename(),
                  _Action.unlink => Navigator.of(context).pop(DocumentViewerResult.unlinked),
                  _Action.delete => _delete(),
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: _Action.rename, child: Text(l.recDocRename)),
                  if (widget.canUnlink) PopupMenuItem(value: _Action.unlink, child: Text(l.recDocUnlink)),
                  PopupMenuItem(value: _Action.delete, child: Text(l.recDocDelete, style: TextStyle(color: p.danger))),
                ],
              ),
            ],
          ),
          body: switch (snap.connectionState) {
            ConnectionState.done when bytes == null => _Message(l.recDocUnreadable),
            ConnectionState.done when a != null && a.isImage => InteractiveViewer(
                maxScale: 6,
                child: Center(child: Image.memory(bytes!, errorBuilder: (_, _, _) => _Message(l.recDocUnreadable))),
              ),
            ConnectionState.done when loaded!.pages.isEmpty => _Message(l.recDocPdfUnreadable),
            ConnectionState.done => InteractiveViewer(
                maxScale: 4,
                child: ListView(
                  padding: const EdgeInsets.all(space3),
                  children: [
                    for (final page in loaded!.pages)
                      Padding(
                        padding: const EdgeInsets.only(bottom: space3),
                        child: DecoratedBox(
                          decoration: BoxDecoration(border: Border.all(color: p.border)),
                          child: Image.memory(page),
                        ),
                      ),
                  ],
                ),
              ),
            _ => const Center(child: CircularProgressIndicator()),
          },
          bottomNavigationBar: a == null
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(space4, space2, space4, space3),
                    child: Text(
                      [
                        l.recRowAdded(a.addedOn.length >= 10 ? DateFormat.yMMMd(locale).format(DateTime.parse(a.addedOn)) : a.addedOn),
                        a.sizeBytes < 1024 * 1024
                            ? l.recDocSizeKb(((a.sizeBytes + 1023) ~/ 1024).toString())
                            : l.recDocSizeMb(NumberFormat('0.0', 'en').format(a.sizeBytes / (1024 * 1024))),
                        l.recDocPrivate,
                      ].join(' · '),
                      style: t.bodySmall,
                    ),
                  ),
                ),
        );
      },
    );
  }
}

/// The rename dialog owns its text field, so the field outlives the closing animation.
class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.initial});
  final String initial;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final _field = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return AlertDialog(
      title: Text(l.recDocRename),
      content: TextField(
        controller: _field,
        autofocus: true,
        maxLength: maxAttachmentNameLength,
        decoration: InputDecoration(labelText: l.recDocRenameLabel),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.recCancel)),
        FilledButton(onPressed: () => Navigator.of(context).pop(_field.text), child: Text(l.recSave)),
      ],
    );
  }
}

class _Loaded {
  const _Loaded(this.bytes, this.pages);
  final Uint8List? bytes;
  final List<Uint8List> pages;
}

class _Message extends StatelessWidget {
  const _Message(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(space6),
          child: Text(text, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
        ),
      );
}
