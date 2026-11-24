// Gives every screen the assistant bridge without passing it through constructors (ADR-078).
//
// Why it exists: the assistant is reached from Log, Today, Learn and Settings. An inherited
// widget at the app root hands them all the same bridge, and tests and screenshots swap in a
// fake. With no scope at all (isolated widget tests) screens get [OfflineAssistant], so every
// feature runs on the phone's rules.

import 'package:flutter/widgets.dart';

import '../../data/assistant_channel.dart';
import '../../domain/assistant/cloud_prompt.dart';

/// A bridge with no model and no cloud: every call reports "not available".
class OfflineAssistant implements AssistantBridge {
  const OfflineAssistant();

  @override
  Future<AssistantStatus> status() async => AssistantStatus.offline;

  @override
  Future<bool> downloadModel() async => false;

  @override
  Future<String?> runPrivate(String prompt) async => null;

  @override
  Future<HybridReply?> runHybrid(CloudPrompt prompt) async => null;

  @override
  Future<bool> openSource(String url) async => false;
}

/// Provides the [AssistantBridge] to the app.
class AssistantScope extends InheritedWidget {
  const AssistantScope({super.key, required this.bridge, required super.child});

  final AssistantBridge bridge;

  /// The bridge in scope, or [OfflineAssistant] when there is none.
  static AssistantBridge of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AssistantScope>()?.bridge ?? const OfflineAssistant();

  @override
  bool updateShouldNotify(AssistantScope oldWidget) => bridge != oldWidget.bridge;
}
