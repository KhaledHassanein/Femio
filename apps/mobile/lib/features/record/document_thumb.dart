// A small tile for one document: the photo itself, or a PDF mark with its name (R11.2).
//
// Why it exists: the editor and "My documents" show the same tile. A photo is opened from its
// sealed file only to draw this tile, scaled down in memory, and never written anywhere plain.

import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../domain/bidi_text.dart';
import '../../domain/record_attachment.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';

/// Edge of a document tile, in logical pixels.
const documentThumbSize = 96.0;

/// The tile. Tapping it calls [onTap]. [showName] writes a PDF's name inside the tile (off
/// where the name is already written below it).
class DocumentThumb extends StatefulWidget {
  const DocumentThumb({
    super.key,
    required this.controller,
    required this.attachment,
    required this.onTap,
    this.showName = true,
  });
  final FemioController controller;
  final RecordAttachment attachment;
  final VoidCallback onTap;
  final bool showName;

  @override
  State<DocumentThumb> createState() => _DocumentThumbState();
}

class _DocumentThumbState extends State<DocumentThumb> {
  late Future<Uint8List?> _bytes = _load();

  Future<Uint8List?> _load() async => widget.attachment.isImage
      ? widget.controller.documents.bytes(widget.attachment.id)
      : null;

  @override
  void didUpdateWidget(DocumentThumb old) {
    super.didUpdateWidget(old);
    if (old.attachment.id != widget.attachment.id) _bytes = _load();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final a = widget.attachment;
    final scale = MediaQuery.devicePixelRatioOf(context);
    return Semantics(
      button: true,
      label: a.name,
      child: Material(
        color: p.surfaceSunken,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: BorderSide(color: p.border),
        ),
        child: InkWell(
          onTap: widget.onTap,
          child: SizedBox.square(
            dimension: documentThumbSize,
            child: a.isImage
                ? FutureBuilder<Uint8List?>(
                    future: _bytes,
                    builder: (context, snap) {
                      final b = snap.data;
                      if (b == null) {
                        return Icon(Icons.image_outlined, color: p.textSubtle);
                      }
                      return Image.memory(
                        b,
                        fit: BoxFit.cover,
                        cacheWidth: (documentThumbSize * scale).round(),
                        gaplessPlayback: true,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.broken_image_outlined,
                          color: p.textSubtle,
                        ),
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.all(space2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.picture_as_pdf_outlined,
                          color: p.primary,
                          size: 32,
                        ),
                        if (widget.showName) const SizedBox(height: space1),
                        if (widget.showName)
                          Text(
                            isolateText(a.name),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: t.labelSmall,
                          ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
