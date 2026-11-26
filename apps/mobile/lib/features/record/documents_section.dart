// The "Documents and photos" part of an entry's editor, and the "My documents" screen (R11.2).
//
// Why it exists: she attaches a report where it belongs, on the visit or result it came
// from: a PDF or photo from the system picker, a photo from her camera app, or a document she
// already added. Every refusal (too big, wrong type) is said in words, never a silent no.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../data/document_source.dart';
import '../../data/record_documents.dart';
import '../../domain/bidi_text.dart';
import '../../domain/record_attachment.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/spacing.dart';
import 'document_thumb.dart';
import 'document_viewer.dart';

/// Shows the documents linked to one entry and the ways to add one. [ids] are the linked
/// documents; [onChanged] receives the new list; [onAdded] is told of each new document so the
/// editor can drop it if she leaves without saving.
class DocumentsSection extends StatelessWidget {
  const DocumentsSection({
    super.key,
    required this.controller,
    required this.ids,
    required this.onChanged,
    required this.onAdded,
  });
  final FemioController controller;
  final List<String> ids;
  final ValueChanged<List<String>> onChanged;
  final ValueChanged<String> onAdded;

  Future<void> _add(BuildContext context, Future<PickedDocument?> Function() pick) async {
    final l = L10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final picked = await pick();
    if (picked == null) return;
    if (picked.tooLarge) {
      messenger.showSnackBar(SnackBar(content: Text(l.recDocsTooLarge)));
      return;
    }
    final name = picked.name.isNotEmpty ? picked.name : l.recDocsPhotoName(DateFormat.yMMMd(locale).add_Hm().format(DateTime.now()));
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
    onAdded(added.id);
    onChanged([...ids, added.id]);
  }

  Future<void> _fromMine(BuildContext context) async {
    final chosen = await Navigator.of(context).push<String>(MaterialPageRoute(
      builder: (_) => DocumentsLibraryScreen(controller: controller, choosing: true, exclude: ids.toSet()),
    ));
    if (chosen != null && !ids.contains(chosen)) onChanged([...ids, chosen]);
  }

  Future<void> _open(BuildContext context, String id) async {
    final result = await Navigator.of(context).push<DocumentViewerResult>(MaterialPageRoute(
      builder: (_) => DocumentViewer(controller: controller, id: id, canUnlink: true),
    ));
    if (result != null) onChanged([for (final x in ids) if (x != id) x]);
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final linked = [for (final id in ids) ?controller.documents.byId(id)];
    final others = controller.documents.all.where((a) => !ids.contains(a.id));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.recDocsHeading, style: t.titleSmall),
        const SizedBox(height: space2),
        if (linked.isNotEmpty) ...[
          Wrap(spacing: space2, runSpacing: space2, children: [
            for (final a in linked)
              DocumentThumb(controller: controller, attachment: a, onTap: () => _open(context, a.id)),
          ]),
          const SizedBox(height: space2),
        ],
        Wrap(spacing: space2, runSpacing: space2, children: [
          OutlinedButton.icon(
            onPressed: () => _add(context, controller.deviceFiles.pickFile),
            icon: const Icon(Icons.upload_file_rounded),
            label: Text(l.recDocsAddFile),
          ),
          OutlinedButton.icon(
            onPressed: () => _add(context, controller.deviceFiles.takePhoto),
            icon: const Icon(Icons.photo_camera_outlined),
            label: Text(l.recDocsTakePhoto),
          ),
          if (others.isNotEmpty)
            TextButton.icon(
              onPressed: () => _fromMine(context),
              icon: const Icon(Icons.folder_open_outlined),
              label: Text(l.recDocsFromMine),
            ),
        ]),
        const SizedBox(height: space1h),
        Text(l.recDocsNote, style: t.bodySmall),
      ],
    );
  }
}

/// Every document she has. With [choosing], a tap picks one (returned by the route) instead of
/// opening it; [exclude] hides the ones already on the entry.
class DocumentsLibraryScreen extends StatefulWidget {
  const DocumentsLibraryScreen({super.key, required this.controller, this.choosing = false, this.exclude = const {}});
  final FemioController controller;
  final bool choosing;
  final Set<String> exclude;

  @override
  State<DocumentsLibraryScreen> createState() => _DocumentsLibraryScreenState();
}

class _DocumentsLibraryScreenState extends State<DocumentsLibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final docs = [for (final a in widget.controller.documents.all) if (!widget.exclude.contains(a.id)) a];
    return Scaffold(
      appBar: AppBar(title: Text(widget.choosing ? l.recDocsChoose : l.recDocsLibrary)),
      body: docs.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(space6),
                child: Text(l.recDocsLibraryEmpty, textAlign: TextAlign.center, style: t.bodyLarge),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(space5),
              children: [
                Wrap(spacing: space3, runSpacing: space3, children: [
                  for (final a in docs) _LibraryTile(controller: widget.controller, attachment: a, onTap: () => _tap(a)),
                ]),
                const SizedBox(height: space4),
                Text(l.recDocPrivate, style: t.bodySmall),
              ],
            ),
    );
  }

  Future<void> _tap(RecordAttachment a) async {
    if (widget.choosing) {
      Navigator.of(context).pop(a.id);
      return;
    }
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => DocumentViewer(controller: widget.controller, id: a.id),
    ));
    if (mounted) setState(() {});
  }
}

class _LibraryTile extends StatelessWidget {
  const _LibraryTile({required this.controller, required this.attachment, required this.onTap});
  final FemioController controller;
  final RecordAttachment attachment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: documentThumbSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DocumentThumb(controller: controller, attachment: attachment, onTap: onTap, showName: false),
            const SizedBox(height: space1),
            Text(isolateText(attachment.name), maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      );
}
