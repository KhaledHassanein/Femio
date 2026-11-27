// The app lock: a PIN she sets, checked before the record is shown.
//
// Why it exists: "private" on an unlocked phone means a borrowed phone shows her
// cycle. The PIN never leaves the phone and is never stored: only a salted PBKDF2
// hash goes into the key vault, so even the vault's contents do not give it away.
// There is no recovery; a forgotten PIN means "delete everything and start over",
// and the lock screen says so plainly.
//
// Two protections ride on the lock (SEC-1, SEC-2, ADR-083):
// - wrong PINs cost time: after [freePinTries] misses each further miss doubles a wait,
//   kept in the vault so a restart does not reset it, and timed on the phone's boot clock
//   too, so moving the wall clock forward does not end it (SEC-N2-1);
// - while a PIN is set, the screen is protected (no recent-apps picture, no capture).
// The PIN guards the screen, not the encryption: the record key is in the Keystore and
// does not depend on the PIN (SEC-3; a PIN-wrapped key is proposed in ADR-084).

import 'dart:convert';
import 'dart:math' show min;

import 'package:flutter/foundation.dart';

import 'crypto/envelope.dart' as envelope;
import 'key_vault.dart';
import 'secure_screen.dart';

const _saltKey = 'lock-salt-v1';
const _hashKey = 'lock-hash-v1';
const _failuresKey = 'lock-failures-v1';
const _waitUntilKey = 'lock-wait-until-v1';
const _waitBootKey = 'lock-wait-boot-v1';

/// PBKDF2 rounds for the PIN. A PIN is short, so the cost per guess is the only
/// defence a hash offers. Not stored with the hash, so it cannot change without
/// breaking every PIN already set; the wait below is what slows guessing now.
const pinIterations = 30000;

/// PIN length bounds. Digits only; a phone keypad is what she has one-handed.
const minPinLength = 4;
const maxPinLength = 8;

/// How long the app may sit in the background before it locks again.
const relockAfter = Duration(seconds: 60);

/// Wrong PINs allowed before the first wait: room for a few honest slips.
const freePinTries = 5;

/// The first wait, after [freePinTries] misses in a row; each further miss doubles it.
const firstPinWait = Duration(seconds: 30);

/// The longest wait. Long enough that guessing 10,000 four-digit PINs takes months, short
/// enough that she is never shut out of her own record for a day.
const maxPinWait = Duration(minutes: 30);

/// The wait after [failures] wrong PINs in a row: none for the first [freePinTries] - 1,
/// then [firstPinWait] doubling up to [maxPinWait].
Duration pinWaitAfter(int failures) {
  if (failures < freePinTries) return Duration.zero;
  final doublings = min(failures - freePinTries, 20);
  final seconds = firstPinWait.inSeconds * (1 << doublings);
  return Duration(seconds: min(seconds, maxPinWait.inSeconds));
}

/// Sets, checks and clears the PIN through a [KeyVault].
class AppLock {
  /// [screen] applies screen protection; by default the real channel when [_vault] is the
  /// phone's Keystore vault (only `main.dart` builds one) and nothing for a test vault.
  /// [clock] reads "now" for the wait (tests move it). [bootClock] reads milliseconds since
  /// the phone started, which the user cannot set; by default the real one with the phone's
  /// vault and none (null) in tests.
  AppLock(this._vault, {SecureScreen? screen, DateTime Function()? clock, BootClock? bootClock})
      : _screen = screen ?? (_vault is SecureKeyVault ? const MethodChannelSecureScreen() : const NoSecureScreen()),
        _clock = clock ?? DateTime.now,
        _boot = bootClock ?? (_vault is SecureKeyVault ? MethodChannelSecureScreen.elapsedSinceBoot : _noBootClock);

  final KeyVault _vault;
  final SecureScreen _screen;
  final DateTime Function() _clock;
  final BootClock _boot;

  static Future<int?> _noBootClock() async => null;

  /// When the current wait ends, or null when she may try now. Updated by every check and
  /// by [isEnabled]; the lock screen listens so it can say how long to wait. One value for
  /// the process: there is one lock screen and one vault on a phone.
  static final ValueNotifier<DateTime?> waitUntil = ValueNotifier<DateTime?>(null);

  /// True when a PIN has been set. Read once when the app starts, so it also brings the
  /// screen protection and [waitUntil] in line with what the vault holds.
  Future<bool> get isEnabled async {
    final on = await _vault.read(_hashKey) != null;
    await _screen.protect(on);
    await retryAfter();
    return on;
  }

  /// True when she chose to protect the screen without a PIN (SEC-1).
  Future<bool> get screenHidden => _screen.isHidden();

  /// Protects the screen (no screenshots, no recent-apps picture) even without a PIN, or
  /// stops doing so. With a PIN set the screen stays protected whatever this says.
  Future<void> hideScreen(bool on) => _screen.hide(on);

  /// A valid PIN is 4 to 8 digits.
  static bool isValidPin(String pin) => RegExp('^[0-9]{$minPinLength,$maxPinLength}\$').hasMatch(pin);

  /// Stores a new salted hash for [pin] and turns screen protection on.
  /// Throws [ArgumentError] for an invalid PIN.
  Future<void> setPin(String pin) async {
    if (!isValidPin(pin)) throw ArgumentError('pin must be $minPinLength to $maxPinLength digits');
    final salt = envelope.randomBytes(envelope.saltLength);
    final hash = await envelope.deriveKey(pin, salt, iterations: pinIterations);
    await _vault.write(_saltKey, base64Encode(salt));
    await _vault.write(_hashKey, base64Encode(hash));
    await _resetFailures();
    await _screen.protect(true);
  }

  /// True when [pin] matches the stored hash. False when no PIN is set, when it is wrong,
  /// and, without checking it, while a wait from earlier misses is still running (so a
  /// guess during the wait costs nothing and teaches nothing). A wrong PIN counts toward
  /// the next wait; a right one clears the count.
  Future<bool> verify(String pin) async {
    if (await retryAfter() > Duration.zero) return false;
    final salt = await _vault.read(_saltKey);
    final stored = await _vault.read(_hashKey);
    if (salt == null || stored == null) return false;
    // The miss is counted before the check, so closing the app during the check cannot
    // make a guess free (SEC-N2-1); a right PIN clears the count below.
    final failures = (int.tryParse(await _vault.read(_failuresKey) ?? '') ?? 0) + 1;
    await _vault.write(_failuresKey, '$failures');
    final hash = await envelope.deriveKey(pin, base64Decode(salt), iterations: pinIterations);
    if (_constantTimeEquals(base64Decode(stored), hash)) {
      await _resetFailures();
      return true;
    }
    final wait = pinWaitAfter(failures);
    if (wait > Duration.zero) {
      final until = _clock().add(wait);
      await _vault.write(_waitUntilKey, '${until.millisecondsSinceEpoch}');
      final boot = await _boot();
      if (boot != null) await _vault.write(_waitBootKey, '$boot:${wait.inMilliseconds}');
      waitUntil.value = until;
    }
    return false;
  }

  /// How long until she may try again; zero when she may try now. A stored end further
  /// away than [maxPinWait] (the phone's clock was set back) is pulled in to [maxPinWait],
  /// so a clock change can never shut her out for longer. The wait is also timed on the
  /// boot clock, which only runs forward: moving the wall clock forward does not end it
  /// early (SEC-N2-1). After a reboot the boot clock starts again and the wall clock rules.
  Future<Duration> retryAfter() async {
    final raw = int.tryParse(await _vault.read(_waitUntilKey) ?? '');
    final now = _clock();
    if (raw == null) {
      waitUntil.value = null;
      return Duration.zero;
    }
    var until = DateTime.fromMillisecondsSinceEpoch(raw);
    if (until.difference(now) > maxPinWait) {
      until = now.add(maxPinWait);
      await _vault.write(_waitUntilKey, '${until.millisecondsSinceEpoch}');
    }
    final bootLeft = await _bootLeft();
    if (bootLeft != null && bootLeft > until.difference(now)) until = now.add(bootLeft);
    final left = until.difference(now);
    if (left <= Duration.zero) {
      waitUntil.value = null;
      return Duration.zero;
    }
    waitUntil.value = until;
    return left;
  }

  /// Removes the PIN, the miss count and screen protection. Requires no proof: Settings
  /// asks for the current PIN first.
  Future<void> clear() async {
    await _vault.delete(_saltKey);
    await _vault.delete(_hashKey);
    await _resetFailures();
    await _screen.protect(false);
  }

  /// What is left of the wait on the boot clock, or null when it cannot tell (no boot
  /// clock, no record, or the phone restarted since the wait began).
  Future<Duration?> _bootLeft() async {
    final parts = (await _vault.read(_waitBootKey))?.split(':');
    if (parts == null || parts.length != 2) return null;
    final start = int.tryParse(parts[0]);
    final wait = int.tryParse(parts[1]);
    final now = await _boot();
    if (start == null || wait == null || now == null || now < start) return null;
    final capped = min<int>(wait, maxPinWait.inMilliseconds);
    final left = Duration(milliseconds: start + capped - now);
    return left > Duration.zero ? left : Duration.zero;
  }

  Future<void> _resetFailures() async {
    await _vault.delete(_failuresKey);
    await _vault.delete(_waitUntilKey);
    await _vault.delete(_waitBootKey);
    waitUntil.value = null;
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
