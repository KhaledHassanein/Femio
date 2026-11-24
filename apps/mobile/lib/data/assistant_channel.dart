// The Dart end of the assistant's method channel (ADR-078 §5).
//
// Why it exists: model calls run in Kotlin (`assistant/FemioAssistant.kt`), so the Dart code
// holds no network client. This file is the only Dart code allowed to name the channel (the
// privacy tripwire checks it), and its two calls keep the line ADR-078 draws: [runPrivate]
// accepts any text but runs only on the phone; [askGrounded] runs in the cloud and accepts only
// a [CloudSafeText], which only the redaction step can make. Every failure returns null, so a
// screen falls back to its rules and never shows an error from a model.

import 'package:flutter/services.dart';

import '../domain/assistant/redaction.dart';
import '../domain/assistant/trusted_sources.dart';

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

  /// "Ask femio" can reach trusted sources.
  bool get canAskCloud => configured;

  static const offline = AssistantStatus(configured: false, onDevice: OnDeviceModel.unavailable);
}

/// A grounded answer with what the grounding terms require the app to show alongside it.
class GroundedAnswer {
  const GroundedAnswer({required this.text, required this.sources, required this.suggestionsHtml});
  final String text;
  final List<WebSource> sources;

  /// Google's search-suggestions chip, as HTML/CSS to render unchanged (may be null).
  final String? suggestionsHtml;
}

/// The channel, behind an interface so tests and screenshots can use a fake.
abstract class AssistantBridge {
  Future<AssistantStatus> status();

  /// Asks Android to download Gemini Nano; true when it is ready.
  Future<bool> downloadModel();

  /// Runs [prompt] with Gemini Nano on the phone only. Null when the model is absent or fails.
  Future<String?> runPrivate(String prompt);

  /// Answers [question] in the cloud with Google Search grounding. Null on any failure.
  Future<GroundedAnswer?> askGrounded(CloudSafeText question, {required String instruction});

  /// Opens an https source in her browser; false when it cannot.
  Future<bool> openSource(String url);
}

/// The real bridge to `FemioAssistant.kt`.
class MethodChannelAssistant implements AssistantBridge {
  const MethodChannelAssistant();

  static const _channel = MethodChannel('com.femioapp.femio/assistant');

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
  Future<String?> runPrivate(String prompt) async {
    try {
      final m = await _channel.invokeMapMethod<String, Object?>('private', {'prompt': prompt});
      // Belt and braces: a private call that somehow ran in the cloud is discarded.
      if (m == null || m['source'] != 'ON_DEVICE') return null;
      return m['text'] as String?;
    } on Object {
      return null;
    }
  }

  @override
  Future<GroundedAnswer?> askGrounded(CloudSafeText question, {required String instruction}) async {
    try {
      final m = await _channel.invokeMapMethod<String, Object?>('grounded', {
        'question': question.value,
        'instruction': instruction,
      });
      final text = m?['text'] as String?;
      if (m == null || text == null || text.trim().isEmpty) return null;
      final sources = [
        for (final s in (m['sources'] as List?) ?? const [])
          if (s is Map) WebSource(title: '${s['title'] ?? ''}', uri: '${s['uri'] ?? ''}'),
      ];
      return GroundedAnswer(text: text.trim(), sources: sources, suggestionsHtml: m['suggestionsHtml'] as String?);
    } on Object {
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
}
