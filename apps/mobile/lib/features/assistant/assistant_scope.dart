// Gives every screen the assistant bridge without passing it through constructors (ADR-078).
//
// Why it exists: the assistant is reached from Log, Today, Learn and Settings. An inherited
// widget at the app root hands them all the same bridge, and tests and screenshots swap in a
// fake. With no scope at all (isolated widget tests) screens get [OfflineAssistant], so every
// feature runs on the phone's rules.

import 'package:flutter/widgets.dart';

import '../../data/assistant_channel.dart';
import '../../data/assistant_gateway.dart';
import '../../data/translate_channel.dart';
import '../../domain/assistant/ai_ledger.dart';
import '../../domain/assistant/cloud_prompt.dart';
import '../../domain/assistant/private_prompt.dart';

/// A bridge with no model and no cloud: every call reports "not available".
class OfflineAssistant implements AssistantBridge {
  const OfflineAssistant();

  @override
  Future<AssistantStatus> status() async => AssistantStatus.offline;

  @override
  Future<bool> downloadModel() async => false;

  @override
  Future<String?> runPrivate(PrivatePrompt prompt) async => null;

  @override
  Future<HybridReply?> runHybrid(CloudPrompt prompt) async => null;

  @override
  Future<bool> openSource(String url) async => false;
}

/// Provides the [AssistantBridge] to the app.
class AssistantScope extends InheritedWidget {
  const AssistantScope({
    super.key,
    required this.bridge,
    this.enabled,
    this.record,
    this.translator,
    required super.child,
  });

  final AssistantBridge bridge;

  /// Reads her master AI switch; null means always on (tests, onboarding).
  final bool Function()? enabled;

  /// Keeps each model call in the AI ledger (R10.3); null keeps none (tests).
  final Future<void> Function(LedgerEntry entry)? record;

  /// The phone's own translator for the AI (ADR-087 §6); null means none (tests).
  final TranslatorPort? translator;

  /// The translator in scope, or null when there is none.
  static TranslatorPort? translatorOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AssistantScope>()?.translator;

  /// The bridge in scope, or [OfflineAssistant] when there is none.
  static AssistantBridge of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AssistantScope>()?.bridge ?? const OfflineAssistant();

  static final _gateways = Expando<AssistantGateway>('assistant gateway');

  /// The gateway for the bridge in scope: the only way a screen reaches the model (ADR-081).
  /// One per bridge, so its circuit breaker lasts the session.
  static AssistantGateway gatewayOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AssistantScope>();
    final bridge = scope?.bridge ?? const OfflineAssistant();
    return _gateways[bridge] ??= AssistantGateway(
      bridge,
      enabled: scope?.enabled,
      record: scope?.record,
      translator: scope?.translator,
    );
  }

  @override
  bool updateShouldNotify(AssistantScope oldWidget) => bridge != oldWidget.bridge;
}
