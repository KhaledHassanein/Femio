// The sealed envelope every record and backup is written in.
//
// Why it exists: her record is health data on a phone that can be lost, and a backup
// is a file that travels. Both are sealed with AES-GCM (authenticated encryption:
// anyone who changes a byte is detected, nobody without the key reads a byte). The
// record key lives in the Android Keystore; a backup key is derived from a passphrase
// she chooses, because a backup must open on a phone that has no Keystore entry.
// Pure Dart, no platform code, so every path is unit-tested.

import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'pbkdf2.dart';

/// Marks a sealed record file. Four bytes of ASCII, then a version byte.
const recordMagic = 'FMR1';

/// Marks a backup file. A backup carries its own salt and iteration count.
const backupMagic = 'FMB1';

/// AES-GCM nonce length, in bytes (the standard 96 bits).
const nonceLength = 12;

/// AES-GCM tag length, in bytes.
const macLength = 16;

/// Salt length for a passphrase-derived key, in bytes.
const saltLength = 16;

/// PBKDF2-HMAC-SHA256 rounds for a NEW backup: OWASP's 2023 floor for this hash (Password
/// Storage Cheat Sheet). The fast PBKDF2 in `pbkdf2.dart` takes about 0.9 s for this on a
/// desktop CPU, measured 2026-11-27 (ADR-085); a mid-range phone is slower, and only a
/// backup export or import waits for it, off the UI isolate. Each file records the count it
/// used, so raising this only affects new backups: files made at the old 120,000 still open.
const backupIterations = 600000;

/// The fewest rounds a backup file may declare. Old femio files used 120,000; the floor
/// only refuses a file that is plainly not ours.
const minBackupIterations = 1000;

/// The most rounds a backup file may declare (SEC-11). The count is read from the file
/// before the passphrase is checked, so without a ceiling a hostile file could keep the
/// phone deriving a key for minutes. About three times today's count leaves room for one
/// future raise; a file above it is refused as "not a femio file" without any key work.
const maxBackupIterations = 2000000;

/// Key length for AES-256, in bytes.
const keyLength = 32;

final _aesGcm = AesGcm.with256bits();
final _random = Random.secure();

/// A fresh random key for a new record. Base64 so the Keystore stores a string.
String newRecordKey() => base64Encode(randomBytes(keyLength));

/// [n] cryptographically random bytes.
Uint8List randomBytes(int n) => Uint8List.fromList(List.generate(n, (_) => _random.nextInt(256)));

/// Seals [plaintext] under a raw 32-byte [key]: magic, nonce, ciphertext, tag.
///
/// Throws [ArgumentError] for a key of the wrong length.
Future<Uint8List> seal(List<int> key, List<int> plaintext, {String magic = recordMagic}) async {
  if (key.length != keyLength) throw ArgumentError('key must be $keyLength bytes');
  final nonce = randomBytes(nonceLength);
  final box = await _aesGcm.encrypt(plaintext, secretKey: SecretKey(key), nonce: nonce);
  return Uint8List.fromList([...ascii.encode(magic), ...nonce, ...box.cipherText, ...box.mac.bytes]);
}

/// Opens a file written by [seal]. Returns the plaintext, or throws
/// [EnvelopeError] when the file is not ours, is truncated, was changed, or was
/// sealed under a different key (the three last cases are indistinguishable by
/// design: GCM refuses them all the same way).
Future<Uint8List> open(List<int> key, List<int> sealed, {String magic = recordMagic}) async {
  final head = ascii.encode(magic);
  if (sealed.length < head.length + nonceLength + macLength) throw const EnvelopeError(EnvelopeFailure.notOurs);
  for (var i = 0; i < head.length; i += 1) {
    if (sealed[i] != head[i]) throw const EnvelopeError(EnvelopeFailure.notOurs);
  }
  final nonce = sealed.sublist(head.length, head.length + nonceLength);
  final cipher = sealed.sublist(head.length + nonceLength, sealed.length - macLength);
  final mac = Mac(sealed.sublist(sealed.length - macLength));
  try {
    final clear = await _aesGcm.decrypt(SecretBox(cipher, nonce: nonce, mac: mac), secretKey: SecretKey(key));
    return Uint8List.fromList(clear);
  } on SecretBoxAuthenticationError {
    throw const EnvelopeError(EnvelopeFailure.cannotOpen);
  }
}

/// Derives a 32-byte key from a passphrase with PBKDF2-HMAC-SHA256 (password as UTF-8).
///
/// Runs on a short-lived background isolate, so a 600,000-round backup key never freezes
/// the screen. The result is byte-for-byte the standard PBKDF2 the `cryptography` package
/// computed before ADR-085, so existing PIN hashes and backups still match.
/// Throws [ArgumentError] for [iterations] below 1.
Future<Uint8List> deriveKey(String passphrase, List<int> salt, {int iterations = backupIterations}) {
  if (iterations < 1) throw ArgumentError.value(iterations, 'iterations', 'must be at least 1');
  final saltCopy = Uint8List.fromList(salt);
  return Isolate.run(() => pbkdf2HmacSha256(passphrase, saltCopy, iterations: iterations, length: keyLength));
}

/// Seals [plaintext] under a passphrase: magic, salt, iterations (4 bytes, big
/// endian), then the sealed envelope. Self-describing, so a backup opens on any
/// phone with only the passphrase.
Future<Uint8List> sealWithPassphrase(String passphrase, List<int> plaintext) async {
  final salt = randomBytes(saltLength);
  final key = await deriveKey(passphrase, salt);
  final body = await seal(key, plaintext, magic: backupMagic);
  final count = ByteData(4)..setUint32(0, backupIterations);
  return Uint8List.fromList([...ascii.encode(backupMagic), ...salt, ...count.buffer.asUint8List(), ...body]);
}

/// Opens a file written by [sealWithPassphrase]. Throws [EnvelopeError]
/// `notOurs` for a foreign file and `cannotOpen` for a wrong passphrase.
Future<Uint8List> openWithPassphrase(String passphrase, List<int> sealed) async {
  final head = ascii.encode(backupMagic);
  final prefix = head.length + saltLength + 4;
  if (sealed.length < prefix) throw const EnvelopeError(EnvelopeFailure.notOurs);
  for (var i = 0; i < head.length; i += 1) {
    if (sealed[i] != head[i]) throw const EnvelopeError(EnvelopeFailure.notOurs);
  }
  final salt = sealed.sublist(head.length, head.length + saltLength);
  final iterations = ByteData.sublistView(Uint8List.fromList(sealed.sublist(head.length + saltLength, prefix))).getUint32(0);
  // Cheap checks first: the declared count and the minimum envelope size are refused before
  // any key is derived, so a hostile or truncated file costs nothing (SEC-11).
  if (iterations < minBackupIterations || iterations > maxBackupIterations) throw const EnvelopeError(EnvelopeFailure.notOurs);
  if (sealed.length < prefix + head.length + nonceLength + macLength) throw const EnvelopeError(EnvelopeFailure.notOurs);
  final key = await deriveKey(passphrase, salt, iterations: iterations);
  return open(key, sealed.sublist(prefix), magic: backupMagic);
}

/// Why an envelope could not be opened.
enum EnvelopeFailure { notOurs, cannotOpen }

/// Thrown by [open] and [openWithPassphrase].
class EnvelopeError implements Exception {
  const EnvelopeError(this.failure);
  final EnvelopeFailure failure;

  @override
  String toString() => 'EnvelopeError(${failure.name})';
}
