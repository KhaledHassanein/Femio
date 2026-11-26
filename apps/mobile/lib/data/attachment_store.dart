// Where the bytes of her documents and photos live (R11.2, ADR-082 §2).
//
// Why it exists: a document can be ten megabytes, far too big to rewrite inside the record on
// every save, so each one is its own file in the app's private support directory, sealed with
// the record key and named by a random id, never by her file name. The record keeps only the
// description (`RecordAttachment`). An interface so tests run in memory.

// ignore_for_file: prefer_initializing_formals

import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import 'crypto/envelope.dart' as envelope;
import 'key_vault.dart';
import 'store.dart';

/// Magic bytes at the start of a sealed document, so a document file is never mistaken for
/// the record file or a backup.
const attachmentMagic = 'FMA1';

/// The folder, inside the app's support directory, that holds the sealed documents.
const attachmentFolder = 'documents';

/// Reads and writes the sealed bytes of her documents.
abstract class AttachmentStore {
  /// Seals [bytes] and stores them under [id], replacing any file with that id.
  Future<void> put(String id, List<int> bytes);

  /// The plain bytes for [id], or null when there is no such file or it cannot be opened.
  Future<Uint8List?> read(String id);

  /// Removes the file for [id]; nothing happens when there is none.
  Future<void> delete(String id);

  /// Removes every document file ("delete everything").
  Future<void> clear();
}

/// Sealed files in `<support>/documents/<id>`, with the record key from the [KeyVault].
class EncryptedAttachmentStore implements AttachmentStore {
  /// [directory] overrides the support directory (tests).
  EncryptedAttachmentStore({required KeyVault vault, Directory? directory})
      : _vault = vault,
        _directory = directory;

  final KeyVault _vault;
  final Directory? _directory;

  Future<Directory> _dir() async {
    final base = _directory ?? await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/$attachmentFolder');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  /// An id is only ever a random token femio made; anything else could reach outside the folder.
  static bool _safe(String id) => RegExp(r'^[A-Za-z0-9_-]{8,64}$').hasMatch(id);

  @override
  Future<void> put(String id, List<int> bytes) async {
    if (!_safe(id)) throw ArgumentError('bad attachment id');
    final sealed = await envelope.seal(await recordKey(_vault), bytes, magic: attachmentMagic);
    final file = File('${(await _dir()).path}/$id');
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsBytes(sealed, flush: true);
    await tmp.rename(file.path);
  }

  @override
  Future<Uint8List?> read(String id) async {
    if (!_safe(id)) return null;
    final file = File('${(await _dir()).path}/$id');
    if (!await file.exists()) return null;
    try {
      return await envelope.open(await recordKey(_vault), await file.readAsBytes(), magic: attachmentMagic);
    } on envelope.EnvelopeError {
      return null;
    }
  }

  @override
  Future<void> delete(String id) async {
    if (!_safe(id)) return;
    final file = File('${(await _dir()).path}/$id');
    if (await file.exists()) await file.delete();
  }

  @override
  Future<void> clear() async {
    final dir = await _dir();
    if (await dir.exists()) await dir.delete(recursive: true);
  }
}

/// For tests and screenshots.
class MemoryAttachmentStore implements AttachmentStore {
  final files = <String, Uint8List>{};

  @override
  Future<void> put(String id, List<int> bytes) async => files[id] = Uint8List.fromList(bytes);

  @override
  Future<Uint8List?> read(String id) async => files[id];

  @override
  Future<void> delete(String id) async => files.remove(id);

  @override
  Future<void> clear() async => files.clear();
}
