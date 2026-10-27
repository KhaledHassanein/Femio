// The app lock: a PIN she sets, checked before the record is shown.
//
// Why it exists: "private" on an unlocked phone means a borrowed phone shows her
// cycle. The PIN never leaves the phone and is never stored: only a salted PBKDF2
// hash goes into the key vault, so even the vault's contents do not give it away.
// There is no recovery; a forgotten PIN means "delete everything and start over",
// and the lock screen says so plainly.

import 'dart:convert';

import 'crypto/envelope.dart' as envelope;
import 'key_vault.dart';

const _saltKey = 'lock-salt-v1';
const _hashKey = 'lock-hash-v1';

/// PBKDF2 rounds for the PIN. A PIN is short, so the cost per guess is the only
/// defence a hash offers; this keeps a check under a quarter second on a phone.
const pinIterations = 30000;

/// PIN length bounds. Digits only; a phone keypad is what she has one-handed.
const minPinLength = 4;
const maxPinLength = 8;

/// How long the app may sit in the background before it locks again.
const relockAfter = Duration(seconds: 60);

/// Sets, checks and clears the PIN through a [KeyVault].
class AppLock {
  AppLock(this._vault);
  final KeyVault _vault;

  /// True when a PIN has been set.
  Future<bool> get isEnabled async => await _vault.read(_hashKey) != null;

  /// A valid PIN is 4 to 8 digits.
  static bool isValidPin(String pin) => RegExp('^[0-9]{$minPinLength,$maxPinLength}\$').hasMatch(pin);

  /// Stores a new salted hash for [pin]. Throws [ArgumentError] for an invalid PIN.
  Future<void> setPin(String pin) async {
    if (!isValidPin(pin)) throw ArgumentError('pin must be $minPinLength to $maxPinLength digits');
    final salt = envelope.randomBytes(envelope.saltLength);
    final hash = await envelope.deriveKey(pin, salt, iterations: pinIterations);
    await _vault.write(_saltKey, base64Encode(salt));
    await _vault.write(_hashKey, base64Encode(hash));
  }

  /// True when [pin] matches the stored hash. False when no PIN is set.
  Future<bool> verify(String pin) async {
    final salt = await _vault.read(_saltKey);
    final stored = await _vault.read(_hashKey);
    if (salt == null || stored == null) return false;
    final hash = await envelope.deriveKey(pin, base64Decode(salt), iterations: pinIterations);
    return _constantTimeEquals(base64Decode(stored), hash);
  }

  /// Removes the PIN. Requires no proof: Settings asks for the current PIN first.
  Future<void> clear() async {
    await _vault.delete(_saltKey);
    await _vault.delete(_hashKey);
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i += 1) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
