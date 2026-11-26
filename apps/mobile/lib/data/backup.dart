// The backup file: her whole record, sealed with a passphrase she chooses.
//
// Why it exists: a private-records app with no server loses her data with her phone
// unless she can carry it herself (ADR-070). The file is self-describing and opens
// on any phone with only the passphrase, so a new phone needs no account and no
// Keystore entry. The passphrase is never stored anywhere.

import 'dart:convert';
import 'dart:typed_data';

import '../domain/record_attachment.dart' show maxAttachmentBytes, maxBackupAttachmentBytes;
import 'attachment_store.dart' show isSafeAttachmentId;
import 'crypto/envelope.dart' as envelope;
import 'profile.dart';

/// The extension the file picker suggests. Android ignores it for identification;
/// the magic bytes inside the file are what [decodeBackup] trusts.
const backupExtension = 'femio';

/// Shortest passphrase that may OPEN a backup. Files made before ADR-085 allowed 6
/// characters, and a backup she cannot open is a lost record, so opening keeps that floor.
const minPassphraseLength = 6;

/// Shortest passphrase for a NEW backup (SEC-4, ADR-085). A backup travels and can be
/// attacked offline, where only length and the key-derivation cost slow a guesser down.
/// Length, not character classes: a sentence she remembers beats symbols she forgets.
const minNewPassphraseLength = 10;

/// The largest file [decodeBackupWithDocuments] will read (SEC-11): the 100 MB document
/// limit grows by a third in base64, plus room for the record itself. Anything bigger was not
/// written by femio and is refused before any key is derived.
const maxBackupFileBytes = 150 * 1024 * 1024;

/// The most documents one backup may carry; checked before any is restored.
const maxBackupDocuments = 2000;

/// Builds a backup file for [profile], carrying the bytes of her attached [documents] by id
/// (R11.2). The caller keeps their total under `maxBackupAttachmentBytes` and says so first.
/// Throws [ArgumentError] for a passphrase shorter than [minNewPassphraseLength].
Future<Uint8List> encodeBackup(Profile profile, String passphrase, {Map<String, List<int>> documents = const {}}) {
  if (passphrase.length < minNewPassphraseLength) throw ArgumentError('passphrase too short');
  final body = jsonEncode({
    'kind': 'femio-backup',
    'exportedAt': DateTime.now().toUtc().toIso8601String(),
    'record': profile.toJson(),
    if (documents.isNotEmpty) 'documents': {for (final e in documents.entries) e.key: base64Encode(e.value)},
  });
  return envelope.sealWithPassphrase(passphrase, utf8.encode(body));
}

/// What a backup file holds: her record and the bytes of her documents by id.
class RestoredBackup {
  const RestoredBackup(this.profile, this.documents);
  final Profile profile;
  final Map<String, Uint8List> documents;
}

/// Why a backup could not be read.
enum BackupFailure { notAFemioFile, wrongPassphrase, unreadableRecord }

/// Thrown by [decodeBackup].
class BackupError implements Exception {
  const BackupError(this.failure);
  final BackupFailure failure;

  @override
  String toString() => 'BackupError(${failure.name})';
}

/// Reads a file written by [encodeBackup]: her record only. See [decodeBackupWithDocuments].
Future<Profile> decodeBackup(List<int> bytes, String passphrase) async =>
    (await decodeBackupWithDocuments(bytes, passphrase)).profile;

/// Reads a file written by [encodeBackup], with her documents. A newer schema is migrated
/// the same way a saved record is. Throws [BackupError].
///
/// Checks run cheapest first (SEC-11): the file size, then (in the envelope) the magic and
/// the declared round count, and only then the key derivation and decryption. After the file
/// opens, every document is checked (id shape, size, count, total) before anything is
/// returned, so the caller never clears her current documents for a file that would fail
/// half-way through the restore. A document the restored record does not describe is left out.
Future<RestoredBackup> decodeBackupWithDocuments(List<int> bytes, String passphrase) async {
  if (bytes.length > maxBackupFileBytes) throw const BackupError(BackupFailure.notAFemioFile);
  final Uint8List clear;
  try {
    clear = await envelope.openWithPassphrase(passphrase, bytes);
  } on envelope.EnvelopeError catch (e) {
    throw BackupError(e.failure == envelope.EnvelopeFailure.notOurs ? BackupFailure.notAFemioFile : BackupFailure.wrongPassphrase);
  }
  try {
    final json = jsonDecode(utf8.decode(clear)) as Map<String, Object?>;
    if (json['kind'] != 'femio-backup') throw const BackupError(BackupFailure.notAFemioFile);
    final restored = Profile.fromJson(migrateRecord(Map<String, Object?>.from(json['record'] as Map)));
    // Consent to Cloud boost belongs to the phone she gave it on: a restored record keeps the
    // receipts but allows nothing until she agrees again here (ADR-080).
    final at = DateTime.now().toUtc().toIso8601String();
    final documents = _checkedDocuments((json['documents'] as Map?) ?? const {}, restored);
    return RestoredBackup(
      restored.copyWith(settings: restored.settings.copyWith(cloud: restored.settings.cloud.afterRestore(at))),
      documents,
    );
  } on BackupError {
    rethrow;
  } catch (_) {
    throw const BackupError(BackupFailure.unreadableRecord);
  }
}

/// The backup's documents, decoded and checked against [restored] before any is written.
/// Throws [BackupError] `unreadableRecord` for a bad id, an oversized document, too many
/// documents or a total over the backup limit; drops a document the record does not describe.
Map<String, Uint8List> _checkedDocuments(Map<Object?, Object?> raw, Profile restored) {
  if (raw.length > maxBackupDocuments) throw const BackupError(BackupFailure.unreadableRecord);
  final described = {for (final a in restored.attachments) a.id};
  final out = <String, Uint8List>{};
  var total = 0;
  for (final e in raw.entries) {
    final id = e.key;
    final value = e.value;
    if (id is! String || value is! String || !isSafeAttachmentId(id)) {
      throw const BackupError(BackupFailure.unreadableRecord);
    }
    // base64 is 4 characters per 3 bytes: refuse an oversized document before decoding it.
    if (value.length > (maxAttachmentBytes ~/ 3 + 1) * 4) throw const BackupError(BackupFailure.unreadableRecord);
    final decoded = base64Decode(value);
    if (decoded.length > maxAttachmentBytes) throw const BackupError(BackupFailure.unreadableRecord);
    total += decoded.length;
    if (total > maxBackupAttachmentBytes) throw const BackupError(BackupFailure.unreadableRecord);
    if (described.contains(id)) out[id] = decoded;
  }
  return out;
}

/// A file name for the export: date-stamped, no personal detail.
String backupFileName(DateTime now) =>
    'femio-backup-${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.$backupExtension';
