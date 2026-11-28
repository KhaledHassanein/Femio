// The Dart end of the assistant's method channel (ADR-078 §5).
//
// Why it exists: model calls run in Kotlin (`assistant/FemioAssistant.kt`), so the Dart code
// holds no network client. This file is the only Dart code allowed to name the channel (the
// privacy tripwire checks it), and its two model calls keep the line ADR-078 and ADR-079 draw:
// [runPrivate] accepts only a [PrivatePrompt] and runs only on the phone (ONLY_ON_DEVICE); [runHybrid] may
// run in the cloud (PREFER_ON_DEVICE) and so accepts only a [CloudPrompt], which can be built
// only from a CloudSafeText or a PseudonymisedProfile plus public data. Every failure returns
// null, so a screen falls back to its rules and never shows an error from a model. Screens never
// call these two methods: they go through `assistant_gateway.dart` (ADR-081).

import 'package:flutter/services.dart';

import '../domain/assistant/cloud_prompt.dart';
import '../domain/assistant/private_prompt.dart';

/// Where Gemini Nano stands on this phone.
enum OnDeviceModel { unavailable, downloadable, downloading, available }

/// What the assistant can do on this phone right now.
class AssistantStatus {
  const AssistantStatus({required this.configured, required this.onDevice});

  /// The build carries a Firebase config (assistant.env); without it the cloud path is off.
  final bool configured;
  final OnDeviceModel onDevice;

  /// Private features (say-it-to-log, visit questions) can use the model.
  bool get canRunPrivate => configured && onDevice == OnDeviceModel.available;

  /// The hybrid call can run at all (on the phone or, with Cloud boost, in the cloud).
  bool get canRunHybrid => configured;

  static const offline = AssistantStatus(configured: false, onDevice: OnDeviceModel.unavailable);
}

/// A hybrid reply and where it ran, so the screen can say so.
class HybridReply {
  const HybridReply({required this.text, required this.onDevice});
  final String text;

  /// True when Gemini Nano answered on the phone; false when the cloud model did.
  final bool onDevice;
}

/// What the Cloud boost check found: [ok] when Google's cloud model answered, else a
/// [reason] code (`app_check`, `service_disabled`, `quota`, `network`, `timeout`, ...);
/// [ms] is how long it took.
class CloudCheck {
  const CloudCheck({required this.ok, this.reason, this.ms});
  final bool ok;
  final String? reason;
  final int? ms;
}

/// The fixed, public sentence the check sends: nothing about her. Same text as
/// `CLOUD_CHECK_PROMPT` in FemioAssistant.kt; the AI ledger shows it as sent.
const cloudCheckPrompt = 'Reply with the single word OK.';

/// A bridge that can test Cloud boost end to end. Only the real Android bridge does; fakes
/// and the offline bridge need not, and screens hide the check when it is missing.
abstract interface class CloudChecker {
  /// Sends [cloudCheckPrompt] to the cloud model only and reports what happened.
  Future<CloudCheck> checkCloud();

  /// The reason code of the last failed [AssistantBridge.runHybrid] call (for example
  /// `app_check`), or null after a call that answered. Never her text.
  String? get lastHybridFailure;
}

/// The channel, behind an interface so tests and screenshots can use a fake.
abstract class AssistantBridge {
  Future<AssistantStatus> status();

  /// Asks Android to download Gemini Nano; true when it is ready.
  Future<bool> downloadModel();

  /// Runs [prompt] with Gemini Nano on the phone only. Null when the model is absent or fails.
  Future<String?> runPrivate(PrivatePrompt prompt);

  /// Runs [prompt] on the phone when Gemini Nano is ready, otherwise in the cloud. Callers use
  /// it only when she has switched Cloud boost on. Null on any failure.
  Future<HybridReply?> runHybrid(CloudPrompt prompt);

  /// Opens an https source in her browser; false when it cannot.
  Future<bool> openSource(String url);
}

/// The real bridge to `FemioAssistant.kt`.
class MethodChannelAssistant implements AssistantBridge, CloudChecker {
  const MethodChannelAssistant();

  static const _channel = MethodChannel('com.femioapp.femio/assistant');

  // Static because the bridge is const; one engine, one bridge.
  static String? _lastHybridFailure;

  /// Which on-phone model answered last: "preview" (Gemini Nano 4) or "stable" (the standard
  /// Gemini Nano), as Kotlin reports it; null before any on-phone answer. Screens use it only
  /// to name the model under an answer.
  static String? lastOnDeviceModel;

  @override
  String? get lastHybridFailure => _lastHybridFailure;

  @override
  Future<AssistantStatus> status() async {
    try {
      final m = await _channel.invokeMapMethod<String, Object?>('status');
      if (m == null) return AssistantStatus.offline;
      return AssistantStatus(
        configured: m['configured'] == true,
        onDevice: OnDeviceModel.values.firstWhere(
          (v) => v.name == m['onDevice'],
          orElse: () => OnDeviceModel.unavailable,
        ),
      );
    } on Object {
      return AssistantStatus.offline;
    }
  }

  @override
  Future<bool> downloadModel() async {
    try {
      return await _channel.invokeMethod<bool>('download') ?? false;
    } on Object {
      return false;
    }
  }

  @override
  Future<String?> runPrivate(PrivatePrompt prompt) async {
    try {
      final image = prompt.image;
      final m = image == null
          ? await _channel.invokeMapMethod<String, Object?>('private', {'prompt': prompt.text})
          : await _channel.invokeMapMethod<String, Object?>('privateImage', {'prompt': prompt.text, 'image': image});
      // Belt and braces: a private call that somehow ran in the cloud is discarded.
      if (m == null || m['source'] != 'ON_DEVICE') return null;
      lastOnDeviceModel = m['model'] as String? ?? lastOnDeviceModel;
      return m['text'] as String?;
    } on Object {
      return null;
    }
  }

  @override
  Future<HybridReply?> runHybrid(CloudPrompt prompt) async {
    _lastHybridFailure = null;
    try {
      final m = await _channel.invokeMapMethod<String, Object?>('hybrid', {'prompt': prompt.text});
      final text = m?['text'] as String?;
      if (m == null || text == null || text.trim().isEmpty) {
        _lastHybridFailure = 'empty';
        return null;
      }
      if (m['source'] == 'ON_DEVICE') lastOnDeviceModel = m['model'] as String? ?? lastOnDeviceModel;
      return HybridReply(text: text.trim(), onDevice: m['source'] == 'ON_DEVICE');
    } on PlatformException catch (e) {
      final details = e.details;
      _lastHybridFailure = details is String ? details : 'other';
      return null;
    } on Object {
      _lastHybridFailure = 'other';
      return null;
    }
  }

  @override
  Future<bool> openSource(String url) async {
    try {
      return await _channel.invokeMethod<bool>('open', {'url': url}) ?? false;
    } on Object {
      return false;
    }
  }

  @override
  Future<CloudCheck> checkCloud() async {
    try {
      final m = await _channel.invokeMapMethod<String, Object?>('check');
      if (m == null) return const CloudCheck(ok: false, reason: 'other');
      return CloudCheck(ok: m['ok'] == true, reason: m['reason'] as String?, ms: (m['ms'] as num?)?.toInt());
    } on PlatformException catch (e) {
      final details = e.details;
      return CloudCheck(ok: false, reason: details is String ? details : 'other');
    } on Object {
      return const CloudCheck(ok: false, reason: 'other');
    }
  }
}
