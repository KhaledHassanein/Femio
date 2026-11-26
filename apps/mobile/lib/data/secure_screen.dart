// The Dart end of the "secure screen" switch (SEC-1, ADR-083).
//
// Why it exists: while her app lock (PIN) is on, Android must not keep a picture of her
// record. FLAG_SECURE hides the app from the recent-apps thumbnail, screenshots and screen
// recording. It follows the lock rather than being always on because the owner records the
// demo video with the lock off, and a woman who wants a screenshot for her clinician can
// turn the lock off. `MainActivity.kt` applies the flag and remembers it, so the next cold
// start is covered before the first frame. This is the only Dart file that names the channel.
// A failure never costs her a PIN change: the flag is protection on top of the lock.
library;

import 'package:flutter/services.dart';

/// What the app lock needs from the platform. Swappable so tests use a recording fake.
abstract interface class SecureScreen {
  /// Turns screen protection on (hide from recents, block capture) or off.
  Future<void> protect(bool on);
}

/// Does nothing: tests and platforms without the native side.
class NoSecureScreen implements SecureScreen {
  const NoSecureScreen();

  @override
  Future<void> protect(bool on) async {}
}

/// Sends the switch to `MainActivity.kt` over the `femio/secure` channel.
class MethodChannelSecureScreen implements SecureScreen {
  const MethodChannelSecureScreen();

  static const _channel = MethodChannel('femio/secure');

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
}
