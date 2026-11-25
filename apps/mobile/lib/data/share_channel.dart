// Hands text to Android's own share sheet (R10.2, R8.27).
//
// Why it exists: the visit pack is hers to send to a clinic, a partner or her notes. The
// system sheet lets her pick the app; femio itself sends nothing and adds no sharing SDK or
// dependency. The Kotlin side is a few lines in `MainActivity.kt` (channel `femio/share`).

import 'package:flutter/services.dart';

/// The channel name; tests mock it.
const shareChannel = MethodChannel('femio/share');

/// Opens the system share sheet with [text]. Returns false when the sheet could not open
/// (no Android host, as in tests or on another platform), so the caller can fall back to
/// copying the text instead.
Future<bool> shareText(String text, {String? subject}) async {
  try {
    return await shareChannel.invokeMethod<bool>('text', {'text': text, 'subject': subject}) ?? false;
  } on MissingPluginException {
    return false;
  } on PlatformException {
    return false;
  }
}
