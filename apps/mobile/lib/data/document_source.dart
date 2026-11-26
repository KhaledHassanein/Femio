// Where her documents come from and go to on the phone (R11.2): the system file picker, the
// system camera, Android's own PDF renderer and the system share sheet.
//
// Why it exists: femio asks for no CAMERA or storage permission (ADR-082 §2). The system
// picker hands over only the file she chose; the camera intent opens her own camera app; a PDF
// is drawn page by page inside femio, so it never has to be handed to another app just to be
// read; and sharing is her own act through the system sheet. An interface so tests and
// screenshots run without a phone.

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/record_attachment.dart';

/// The channel for PDF pages and file sharing; `MainActivity.kt` answers it.
const filesChannel = MethodChannel('femio/files');

/// Width in pixels a PDF page is drawn at: sharp on a phone, small enough to hold in memory.
const pdfPageWidth = 1200;

/// The most PDF pages drawn for one document; a longer file shows the first ones and says so.
const maxPdfPages = 40;

/// Camera photos are scaled to at most this width and saved at [cameraQuality], which keeps a
/// readable report well under [maxAttachmentBytes].
const cameraMaxWidth = 2400.0;
const cameraQuality = 85;

/// Deletes the plain copies the file picker leaves in the app's cache (SEC-15). The picker
/// copies every file she chooses there; once the bytes are in memory (and sealed, for a
/// document) the copy is only a readable duplicate of her health file. A failure is ignored:
/// the copy is inside the app's private storage, and the next pick tries again.
Future<void> clearPickerCopies() async {
  try {
    await FilePicker.clearTemporaryFiles();
  } catch (_) {
    // No picker on this platform (tests), or the folder was already gone.
  }
}

/// Deletes the camera's plain photo file at [path] once its bytes are read (SEC-15).
Future<void> _deletePhotoCopy(String path) async {
  try {
    final file = File(path);
    if (await file.exists()) await file.delete();
  } catch (_) {
    // The camera app kept the file elsewhere or it is already gone; nothing to clean.
  }
}

/// A file she picked or a photo she took.
class PickedDocument {
  const PickedDocument(this.bytes, this.name, {this.mime}) : tooLarge = false;
  const PickedDocument.tooLarge()
      : bytes = const [],
        name = '',
        mime = null,
        tooLarge = true;

  final List<int> bytes;

  /// The picked file's own name; empty for a camera photo (the screen names it).
  final String name;

  /// Set when the name does not say the type (a camera photo is a JPEG).
  final String? mime;

  /// True when the file was over [maxAttachmentBytes] and was not read.
  final bool tooLarge;
}

/// The phone's own ways in and out for documents.
abstract class DocumentSource {
  /// Opens the system file picker for a PDF or a photo. Null when she cancels.
  Future<PickedDocument?> pickFile();

  /// Opens the system camera. Null when she cancels.
  Future<PickedDocument?> takePhoto();

  /// The pages of [pdf] as PNG images, at most [maxPdfPages]. Empty when the file cannot be
  /// drawn (damaged, password-protected, or no Android host).
  Future<List<Uint8List>> pdfPages(Uint8List pdf);

  /// Hands [bytes] to the system share sheet as [name]. False when the sheet could not open.
  Future<bool> share(Uint8List bytes, String name, String mime);
}

/// The real phone.
class SystemDocumentSource implements DocumentSource {
  const SystemDocumentSource();

  @override
  Future<PickedDocument?> pickFile() async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: attachmentMimeTypes.keys.toList(),
    );
    if (picked.isEmpty) return null;
    final file = picked.single;
    final length = await file.length();
    final bytes = length != null && length > maxAttachmentBytes ? null : await file.readAsBytes();
    await clearPickerCopies();
    if (bytes == null) return const PickedDocument.tooLarge();
    return PickedDocument(bytes, file.name);
  }

  @override
  Future<PickedDocument?> takePhoto() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: cameraMaxWidth,
      imageQuality: cameraQuality,
      requestFullMetadata: false,
    );
    if (photo == null) return null;
    final bytes = await photo.readAsBytes();
    await _deletePhotoCopy(photo.path);
    if (bytes.length > maxAttachmentBytes) return const PickedDocument.tooLarge();
    return PickedDocument(bytes, '', mime: 'image/jpeg');
  }

  @override
  Future<List<Uint8List>> pdfPages(Uint8List pdf) async {
    try {
      final pages = await filesChannel.invokeListMethod<Uint8List>(
        'pdfPages',
        {'bytes': pdf, 'width': pdfPageWidth, 'maxPages': maxPdfPages},
      );
      return pages ?? const [];
    } on MissingPluginException {
      return const [];
    } on PlatformException {
      return const [];
    }
  }

  @override
  Future<bool> share(Uint8List bytes, String name, String mime) async {
    try {
      return await filesChannel.invokeMethod<bool>('share', {'bytes': bytes, 'name': name, 'mime': mime}) ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
