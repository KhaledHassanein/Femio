// The Dart end of the "secure screen" switch (SEC-1, ADR-083).
//
// Why it exists: while her app lock (PIN) is on, Android must not keep a picture of her
// record. FLAG_SECURE hides the app from the recent-apps thumbnail, screenshots and screen
// recording. It follows the lock rather than being always on because the owner records the
// demo video with the lock off, and a woman who wants a screenshot for her clinician can
// turn the lock off. `MainActivity.kt` applies the flag and remembers it, so the next cold
// start is covered before the first frame. This is the only Dart file that names the channel.
// A failure never costs her a PIN change: the flag is protection on top of the lock.
// The same channel reads the boot clock for the PIN wait (SEC-N2-1): milliseconds since the
// phone started, which moving the date and time in Settings does not change.
library;

import 'package:flutter/services.dart';

/// Milliseconds since the phone started, or null where it cannot be read.
typedef BootClock = Future<int?> Function();

/// What the app lock needs from the platform. Swappable so tests use a recording fake.
abstract interface class SecureScreen {
  /// Turns screen protection on (hide from recents, block capture) or off, following the PIN.
  Future<void> protect(bool on);

  /// Her own choice without a PIN (SEC-1): protect the screen even with no lock set. The
  /// window is protected while either the PIN or this choice is on.
  Future<void> hide(bool on);

  /// True when she chose [hide]. Kept on the phone only, outside her record and backups.
  Future<bool> isHidden();
}

/// Does nothing: tests and platforms without the native side.
class NoSecureScreen implements SecureScreen {
  const NoSecureScreen();

  @override
  Future<void> protect(bool on) async {}

  @override
  Future<void> hide(bool on) async {}

  @override
  Future<bool> isHidden() async => false;
}

/// Sends the switch to `MainActivity.kt` over the `femio/secure` channel.
class MethodChannelSecureScreen implements SecureScreen {
  const MethodChannelSecureScreen();

  static const _channel = MethodChannel('femio/secure');

  /// Android's `SystemClock.elapsedRealtime()`: never set by the user, restarts at boot.
  /// Null off Android or when the call fails; the wait then falls back to the wall clock.
  static Future<int?> elapsedSinceBoot() async {
    try {
      return await _channel.invokeMethod<int>('elapsed');
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  @override
  Future<void> protect(bool on) async {
    try {
      await _channel.invokeMethod<void>('set', {'on': on});
    } on MissingPluginException {
      // Not Android: there is no recent-apps thumbnail to hide.
    } on PlatformException {
      // The window refused the flag; the PIN still guards the record.
    }
  }

  @override
  Future<void> hide(bool on) async {
    try {
      await _channel.invokeMethod<void>('hide', {'on': on});
    } on MissingPluginException {
      // Not Android.
    } on PlatformException {
      // The window refused the flag.
    }
  }

  @override
  Future<bool> isHidden() async {
    try {
      return await _channel.invokeMethod<bool>('hidden') ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
