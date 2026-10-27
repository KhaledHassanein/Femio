// The sealed envelope every record and backup is written in.
//
// Why it exists: her record is health data on a phone that can be lost, and a backup
// is a file that travels. Both are sealed with AES-GCM (authenticated encryption:
// anyone who changes a byte is detected, nobody without the key reads a byte). The
// record key lives in the Android Keystore; a backup key is derived from a passphrase
// she chooses, because a backup must open on a phone that has no Keystore entry.
// Pure Dart, no platform code, so every path is unit-tested.

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

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

/// PBKDF2-HMAC-SHA256 rounds for a backup passphrase. Pure-Dart PBKDF2 runs at
/// roughly 100k rounds a second on a mid-range phone, so 120k keeps a backup
/// export under two seconds while making a guessed passphrase expensive.
/// Raising it only affects new backups: each file records the count it used.
const backupIterations = 120000;

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

/// Derives a 32-byte key from a passphrase with PBKDF2-HMAC-SHA256.
Future<Uint8List> deriveKey(String passphrase, List<int> salt, {int iterations = backupIterations}) async {
  final pbkdf2 = Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: iterations, bits: keyLength * 8);
  final key = await pbkdf2.deriveKeyFromPassword(password: passphrase, nonce: salt);
  return Uint8List.fromList(await key.extractBytes());
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
  if (iterations < 1000 || iterations > 10000000) throw const EnvelopeError(EnvelopeFailure.notOurs);
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
