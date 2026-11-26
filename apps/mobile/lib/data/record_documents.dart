// Adding, reading, renaming and deleting her documents (R11.2, ADR-082 §2).
//
// Why it exists: a document has two halves that must stay in step: its description in the
// record (`Profile.attachments`, and the ids on the entries that link it) and its sealed bytes
// in the [AttachmentStore]. This class is the one place that changes both, so no screen can
// leave a description without a file or a file nobody can see. It holds no state of its own:
// it reads the current record and saves through the controller's callbacks.

// ignore_for_file: prefer_initializing_formals

import 'dart:convert';
import 'dart:typed_data';

import '../domain/health_record.dart';
import '../domain/record_attachment.dart';
import 'attachment_store.dart';
import 'crypto/envelope.dart' as envelope;
import 'profile.dart';

/// Why a document was not added.
enum AddDocumentFailure { unsupportedType, tooLarge, empty }

/// The result of [RecordDocuments.add]: the new description, or why there is none.
class AddDocumentResult {
  const AddDocumentResult.added(RecordAttachment this.attachment) : failure = null;
  const AddDocumentResult.failed(AddDocumentFailure this.failure) : attachment = null;

  final RecordAttachment? attachment;
  final AddDocumentFailure? failure;
}

/// Thrown by [RecordDocuments.forBackup] when her documents are over
/// [maxBackupAttachmentBytes] together: the backup is refused rather than cut short.
class BackupTooLargeError implements Exception {
  const BackupTooLargeError(this.totalBytes);
  final int totalBytes;
}

/// Keeps her documents' descriptions and sealed bytes in step.
class RecordDocuments {
  RecordDocuments(
    this._files, {
    required Profile? Function() read,
    required Future<void> Function(Profile) save,
    required DateTime Function() clock,
  })  : _read = read,
        _save = save,
        _clock = clock;

  final AttachmentStore _files;
  final Profile? Function() _read;
  final Future<void> Function(Profile) _save;
  final DateTime Function() _clock;

  Profile get _profile => _read()!;

  String _now() => _clock().toIso8601String().substring(0, 19);

  /// Every document she has, newest first.
  List<RecordAttachment> get all => [..._profile.attachments]..sort((a, b) => b.addedOn.compareTo(a.addedOn));

  /// The description for [id], or null.
  RecordAttachment? byId(String id) {
    for (final a in _profile.attachments) {
      if (a.id == id) return a;
    }
    return null;
  }

  /// The plain size of all her documents together, in bytes.
  int get totalBytes => _profile.attachments.fold(0, (sum, a) => sum + a.sizeBytes);

  /// Seals [bytes] as a new document called [fileName] and adds its description to the record.
  /// [mime] overrides the type read from the name (the camera gives a JPEG). Refuses an
  /// unsupported type, an empty file and one over [maxAttachmentBytes]. The new document is
  /// not yet linked to any entry; the editor links it when she saves the entry.
  Future<AddDocumentResult> add(List<int> bytes, String fileName, {String? mime}) async {
    final type = mime ?? attachmentMimeFor(fileName);
    if (type == null || !attachmentMimeTypes.containsValue(type)) {
      return const AddDocumentResult.failed(AddDocumentFailure.unsupportedType);
    }
    if (bytes.isEmpty) return const AddDocumentResult.failed(AddDocumentFailure.empty);
    if (bytes.length > maxAttachmentBytes) return const AddDocumentResult.failed(AddDocumentFailure.tooLarge);
    final id = base64Url.encode(envelope.randomBytes(16)).replaceAll('=', '');
    await _files.put(id, bytes);
    final attachment = RecordAttachment(id: id, name: fileName, mime: type, sizeBytes: bytes.length, addedOn: _now())
        .renamed(fileName);
    await _save(_profile.copyWith(attachments: [..._profile.attachments, attachment]));
    return AddDocumentResult.added(attachment);
  }

  /// The plain bytes of document [id], or null when the file is missing or cannot be opened.
  Future<Uint8List?> bytes(String id) => _files.read(id);

  /// Gives document [id] a new name. A blank name changes nothing.
  Future<void> rename(String id, String name) async {
    await _save(_profile.copyWith(attachments: [
      for (final a in _profile.attachments) a.id == id ? a.renamed(name) : a,
    ]));
  }

  /// Deletes document [id]: its file, its description and its link on every entry. Each
  /// entry that lost the link records the change in its edit trail.
  Future<void> delete(String id) async {
    final at = _now();
    await _save(_profile.copyWith(
      attachments: [for (final a in _profile.attachments) if (a.id != id) a],
      record: [
        for (final e in _profile.record)
          e.attachmentIds.contains(id)
              ? e.edit(at: at, attachmentIds: [for (final x in e.attachmentIds) if (x != id) x])
              : e,
      ],
    ));
    await _files.delete(id);
  }

  /// Deletes those of [ids] that no entry links, for an editor closed without saving: a file
  /// she added and then abandoned should not stay behind.
  Future<void> dropUnlinked(Iterable<String> ids) async {
    final linked = {for (final e in _profile.record) ...e.attachmentIds};
    for (final id in ids) {
      if (!linked.contains(id) && byId(id) != null) await delete(id);
    }
  }

  /// The bytes of every document by id, for the backup. Throws [BackupTooLargeError] when
  /// they are over [maxBackupAttachmentBytes] together. A file that cannot be opened is left
  /// out; its description still travels, so she sees which one is missing.
  Future<Map<String, Uint8List>> forBackup() async {
    final total = totalBytes;
    if (total > maxBackupAttachmentBytes) throw BackupTooLargeError(total);
    final out = <String, Uint8List>{};
    for (final a in _profile.attachments) {
      final b = await _files.read(a.id);
      if (b != null) out[a.id] = b;
    }
    return out;
  }

  /// Writes the documents restored from a backup, before the restored record is saved.
  Future<void> restore(Map<String, Uint8List> documents) async {
    for (final e in documents.entries) {
      await _files.put(e.key, e.value);
    }
  }

  /// Removes every document file ("delete everything", or before a restore replaces them).
  Future<void> clear() => _files.clear();
}

/// The entries that link document [id].
List<RecordEntry> entriesLinking(Profile profile, String id) =>
    [for (final e in profile.record) if (e.attachmentIds.contains(id)) e];
