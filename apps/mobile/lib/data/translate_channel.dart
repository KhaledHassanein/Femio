// The bridge to the phone's own translator (ADR-087 §6).
//
// Why it exists: Gemini Nano is validated for English, so when her app language is Arabic,
// French or Spanish femio can translate her question to English and the answer back, on the
// phone, with Google's ML Kit (Kotlin `translate/TranslateChannel.kt`). The language file is
// downloaded only when she taps Download in Assistant settings. This file carries text across
// the channel and never throws; tests swap it for a fake ([TranslatorPort]).

import 'package:flutter/services.dart';

/// What the gateway and the settings screen need from a translator. Tests use a fake.
abstract interface class TranslatorPort {
  /// Whether the language file for [lang] (en, ar, fr, es) is on the phone. English always is.
  Future<bool> ready(String lang);

  /// Downloads the language file for [lang]. True when it is now on the phone.
  Future<bool> download(String lang);

  /// Deletes the language file for [lang] from the phone. True when it is gone.
  Future<bool> remove(String lang);

  /// [text] translated from [from] to [to] on the phone, or null when it cannot be.
  Future<String?> translate(String text, {required String from, required String to});
}

/// The real bridge over the `femio/translate` channel.
class MethodChannelTranslator implements TranslatorPort {
  const MethodChannelTranslator();

  static const _channel = MethodChannel('femio/translate');

  Future<T?> _call<T>(String method, Map<String, Object?> args) async {
    try {
      return await _channel.invokeMethod<T>(method, args);
    } on PlatformException {
      return null;
    } on MissingPluginException {
      // Not Android, or a test without the channel: no translator.
      return null;
    }
  }

  @override
  Future<bool> ready(String lang) async => lang == 'en' || (await _call<bool>('ready', {'lang': lang}) ?? false);

  @override
  Future<bool> download(String lang) async => await _call<bool>('download', {'lang': lang}) ?? false;

  @override
  Future<bool> remove(String lang) async => await _call<bool>('remove', {'lang': lang}) ?? false;

  @override
  Future<String?> translate(String text, {required String from, required String to}) {
    if (from == to) return Future.value(text);
    return _call<String>('translate', {'text': text, 'from': from, 'to': to});
  }
}
