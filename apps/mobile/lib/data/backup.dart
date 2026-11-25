// The backup file: her whole record, sealed with a passphrase she chooses.
//
// Why it exists: a private-records app with no server loses her data with her phone
// unless she can carry it herself (ADR-070). The file is self-describing and opens
// on any phone with only the passphrase, so a new phone needs no account and no
// Keystore entry. The passphrase is never stored anywhere.

import 'dart:convert';
import 'dart:typed_data';

import 'crypto/envelope.dart' as envelope;
import 'profile.dart';

/// The extension the file picker suggests. Android ignores it for identification;
/// the magic bytes inside the file are what [decodeBackup] trusts.
const backupExtension = 'femio';

/// Shortest passphrase accepted. Length, not character classes: a sentence she
/// remembers beats symbols she forgets, and a lost passphrase loses the backup.
const minPassphraseLength = 6;

/// Builds a backup file for [profile].
Future<Uint8List> encodeBackup(Profile profile, String passphrase) {
  if (passphrase.length < minPassphraseLength) throw ArgumentError('passphrase too short');
  final body = jsonEncode({'kind': 'femio-backup', 'exportedAt': DateTime.now().toUtc().toIso8601String(), 'record': profile.toJson()});
  return envelope.sealWithPassphrase(passphrase, utf8.encode(body));
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

/// Reads a file written by [encodeBackup]. A newer schema is migrated the same way
/// a saved record is.
Future<Profile> decodeBackup(List<int> bytes, String passphrase) async {
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
    return restored.copyWith(settings: restored.settings.copyWith(cloud: restored.settings.cloud.afterRestore(at)));
  } on BackupError {
    rethrow;
  } catch (_) {
    throw const BackupError(BackupFailure.unreadableRecord);
  }
}

/// A file name for the export: date-stamped, no personal detail.
String backupFileName(DateTime now) =>
    'femio-backup-${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.$backupExtension';
