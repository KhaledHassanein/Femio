// The bridge to femio's on-device speech to text (owner 2026-11-27, ADR-086).
//
// Why it exists: the mic on Ask femio and Say it turns her voice into words with Android's
// on-device recognizer (Kotlin `speech/SpeechChannel.kt`); audio is never recorded, kept or
// sent. This file only carries the words back and names, as a [SpeechProblem], why it could
// not run, so the screen can tell her in her words. Swappable for tests ([SpeechPort]).

import 'package:flutter/services.dart';

/// Why speech to text did not give words.
enum SpeechProblem {
  /// Android 11 or older: there is no on-device recognizer to use.
  oldAndroid,

  /// The phone has no recognizer that works on the phone itself.
  notAvailable,

  /// She said no to the microphone; Android may ask again.
  noPermission,

  /// The microphone is refused for femio and Android will not ask again: only Settings can.
  noPermissionSettings,

  /// No speech pack for this language on the phone.
  language,

  /// The mic listened but heard no words.
  noSpeech,

  /// Another app holds the microphone or the recognizer.
  busy,

  /// The microphone could not start, or anything else.
  other,
}

/// Maps the Kotlin reason code to a [SpeechProblem]; unknown codes become [SpeechProblem.other].
SpeechProblem speechProblemFrom(String code) => switch (code) {
      'old_android' => SpeechProblem.oldAndroid,
      'not_available' => SpeechProblem.notAvailable,
      'no_permission' => SpeechProblem.noPermission,
      'no_permission_settings' => SpeechProblem.noPermissionSettings,
      'language' => SpeechProblem.language,
      'no_speech' => SpeechProblem.noSpeech,
      'busy' => SpeechProblem.busy,
      _ => SpeechProblem.other,
    };

/// What one listen gave: her words, or why there are none.
class SpeechOutcome {
  const SpeechOutcome.words(String this.text) : problem = null;
  const SpeechOutcome.failed(SpeechProblem this.problem) : text = null;
  final String? text;
  final SpeechProblem? problem;
}

/// What the mic button needs. Tests use a fake.
abstract interface class SpeechPort {
  /// Listens once in [locale] (a BCP 47 tag) until she stops speaking or calls [stop].
  /// [onPartial] receives the running guess. Never throws.
  Future<SpeechOutcome> listen(String locale, void Function(String partial) onPartial);

  /// Stops listening; the words heard so far come back from [listen].
  Future<void> stop();

  /// Opens femio's page in the phone's settings, to allow the microphone again.
  Future<void> openAppSettings();

  /// Asks the phone to download its offline speech pack for [locale]. True when Android's own
  /// download prompt was started; false when a settings page was opened instead.
  Future<bool> downloadPack(String locale);
}

/// The real bridge over the `femio/speech` channel.
class MethodChannelSpeech implements SpeechPort {
  const MethodChannelSpeech();

  static const _channel = MethodChannel('femio/speech');
  static void Function(String)? _onPartial;

  @override
  Future<SpeechOutcome> listen(String locale, void Function(String partial) onPartial) async {
    _onPartial = onPartial;
    _channel.setMethodCallHandler((call) async {
      final words = call.arguments;
      if (call.method == 'partial' && words is String) _onPartial?.call(words);
    });
    try {
      final text = await _channel.invokeMethod<String>('listen', {'locale': locale});
      return SpeechOutcome.words(text ?? '');
    } on PlatformException catch (e) {
      return SpeechOutcome.failed(speechProblemFrom(e.code));
    } on MissingPluginException {
      return const SpeechOutcome.failed(SpeechProblem.notAvailable);
    } finally {
      _onPartial = null;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _channel.invokeMethod<void>('stop');
    } on Object {
      // Nothing is listening; nothing to stop.
    }
  }

  @override
  Future<void> openAppSettings() async {
    try {
      await _channel.invokeMethod<void>('appSettings');
    } on Object {
      // No settings page on this platform.
    }
  }

  @override
  Future<bool> downloadPack(String locale) async {
    try {
      return await _channel.invokeMethod<String>('downloadPack', {'locale': locale}) == 'started';
    } on Object {
      return false;
    }
  }
}
