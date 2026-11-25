// The one door between femio's screens and the model (ADR-081, R10.1).
//
// Why it exists: the owner's rule (CLAUDE.md rule 7) wants the AI as a companion, kept apart
// from the core like a surgical seam. Screens no longer call the bridge's model methods or
// build prompts: they ask the gateway for a result. The gateway checks the build switch, the
// use's policy and consent, waits a bounded time, parses the reply against what was offered,
// and stops calling a use that keeps returning nonsense. Every method returns the rules
// answer (a null or empty value with `ranOn: rules`) when the model is off, absent or wrong,
// so each screen keeps working with AI off. The privacy tripwire checks this is the only
// Dart file that calls `runPrivate` or `runHybrid`.

import 'dart:async';

import '../domain/assistant/ai_ledger.dart';
import '../domain/assistant/cloud_consent.dart';
import '../domain/assistant/cloud_prompt.dart';
import '../domain/assistant/private_prompt.dart';
import '../domain/assistant/prompts.dart';
import '../domain/assistant/pseudonymised_profile.dart';
import '../domain/assistant/redaction.dart';
import '../domain/assistant/source_registry.dart';
import '../domain/assistant/uses.dart';
import '../domain/assistant/visit_summary.dart';
import 'assistant_channel.dart';

/// Kill switch 2: a build with `--dart-define=FEMIO_ASSISTANT=false` ships rules only.
const assistantBuildEnabled = bool.fromEnvironment('FEMIO_ASSISTANT', defaultValue: true);

/// How long one model call may take before the screen keeps its rules answer.
const assistantCallTimeout = Duration(seconds: 20);

/// Unusable replies in a row after which a use runs on rules for the rest of the session.
const assistantCircuitBreakerLimit = 3;

/// Where an answer came from, so a screen can say so.
enum RanOn { rules, phone, cloud }

/// A gateway answer: [value] is null (or empty) when the rules answer stands.
class AssistantResult<T> {
  const AssistantResult(this.value, this.ranOn);
  const AssistantResult.rules([this.value]) : ranOn = RanOn.rules;
  final T? value;
  final RanOn ranOn;
}

/// The only caller of [AssistantBridge.runPrivate] and [AssistantBridge.runHybrid].
class AssistantGateway {
  /// [enabled] reads her master switch (kill switch 3) at each call; absent means on.
  /// [record] keeps each call in her AI ledger (R10.3); [clock] reads "now" (fixed in tests).
  AssistantGateway(
    this._bridge, {
    bool Function()? enabled,
    Future<void> Function(LedgerEntry entry)? record,
    DateTime Function()? clock,
  })  : _enabled = enabled ?? _always,
        _record = record,
        _clock = clock ?? DateTime.now;

  // Named parameters cannot be private, so these are assigned in the initializer list.
  // ignore_for_file: prefer_initializing_formals
  static bool _always() => true;

  final AssistantBridge _bridge;
  final bool Function() _enabled;
  final Future<void> Function(LedgerEntry entry)? _record;
  final DateTime Function() _clock;
  final _unusable = <AssistantUse, int>{};

  /// What the assistant can do on this phone; offline when the build switch or her master
  /// switch is off.
  Future<AssistantStatus> status() async =>
      assistantBuildEnabled && _enabled() ? _bridge.status() : AssistantStatus.offline;

  bool _open(AssistantUse use) =>
      assistantBuildEnabled &&
      _enabled() &&
      (usePolicies[use]?.enabled ?? false) &&
      (_unusable[use] ?? 0) < assistantCircuitBreakerLimit;

  /// Counts a reply that came back but could not be used; a usable one resets the count.
  T? _judge<T>(AssistantUse use, T? parsed) {
    _unusable[use] = parsed == null ? (_unusable[use] ?? 0) + 1 : 0;
    return parsed;
  }

  /// Writes one ledger entry. A ledger that cannot be saved never stops the answer.
  void _log(AssistantUse use, {required bool cloud, required bool answered, String? sent}) {
    final at = _clock().toUtc().toIso8601String();
    unawaited(_record?.call(LedgerEntry(at: at, use: use, cloud: cloud, answered: answered, sent: sent)).catchError((_) {}));
  }

  Future<String?> _private(PrivatePrompt prompt) async {
    if (!_open(prompt.use)) return null;
    String? reply;
    try {
      reply = await _bridge.runPrivate(prompt).timeout(assistantCallTimeout);
    } on Object {
      // A timeout or any bridge failure leaves the rules answer standing.
      reply = null;
    }
    _log(prompt.use, cloud: false, answered: reply != null);
    return reply;
  }

  Future<HybridReply?> _hybrid(AssistantUse use, CloudPrompt prompt, CloudConsent consent) async {
    final purpose = usePolicies[use]?.consent;
    if (!_open(use) || purpose == null || !consent.allows(purpose)) return null;
    HybridReply? reply;
    try {
      reply = await _bridge.runHybrid(prompt).timeout(assistantCallTimeout);
    } on Object {
      reply = null;
    }
    // Without a reply femio cannot know where the call ran, so it keeps the receipt.
    final cloud = reply == null || !reply.onDevice;
    _log(use, cloud: cloud, answered: reply != null, sent: cloud ? prompt.text : null);
    return reply;
  }

  /// Ask femio on the phone: a cited summary of [passages] for her [question].
  Future<AssistantResult<CitedAnswer>> answerOnPhone(
    String question,
    List<SourceEntry> passages,
    String languageCode,
  ) async {
    if (!(await status()).canRunPrivate) return const AssistantResult.rules();
    final reply = await _private(PrivatePrompt.answer(question, passages, languageCode));
    if (reply == null) return const AssistantResult.rules();
    final parsed = _judge(AssistantUse.askOnPhone, parseAnswer(reply, passages.length));
    return parsed == null ? const AssistantResult.rules() : AssistantResult(parsed, RanOn.phone);
  }

  /// Ask femio with Cloud boost: the general [question] she approved and public [passages].
  /// Runs only when [consent] allows questions.
  Future<AssistantResult<CitedAnswer>> answerWithBoost(
    CloudSafeText question,
    List<SourceEntry> passages,
    String languageCode,
    CloudConsent consent,
  ) async {
    if (!(await status()).canRunHybrid) return const AssistantResult.rules();
    final reply = await _hybrid(
      AssistantUse.askInCloud,
      CloudPrompt.answer(question, passages, languageCode),
      consent,
    );
    if (reply == null) return const AssistantResult.rules();
    final parsed = _judge(AssistantUse.askInCloud, parseAnswer(reply.text, passages.length));
    if (parsed == null) return const AssistantResult.rules();
    return AssistantResult(parsed, reply.onDevice ? RanOn.phone : RanOn.cloud);
  }

  /// Say it to log: log terms read from her [note] on the phone. The screen shows them as
  /// a draft she ticks; nothing here writes to her record.
  Future<AssistantResult<ModelLogSuggestion>> readNote(String note) async {
    if (!(await status()).canRunPrivate) return const AssistantResult.rules();
    final reply = await _private(PrivatePrompt.sayIt(note));
    if (reply == null) return const AssistantResult.rules();
    final s = parseExtraction(reply);
    final usable = s.terms.isNotEmpty || s.flow != null || s.opk != null;
    if (_judge(AssistantUse.sayItToLog, usable ? s : null) == null) return const AssistantResult.rules();
    return AssistantResult(s, RanOn.phone);
  }

  /// Tips for you: an order for the [ids] that fit her, from her coarse [bands]. On the
  /// phone when it can; otherwise in the cloud only when [consent] allows tips.
  Future<AssistantResult<List<String>>> orderTips(
    PseudonymisedProfile bands,
    List<String> ids,
    int pick,
    CloudConsent consent,
  ) async {
    final status = await this.status();
    if (status.canRunPrivate) {
      final reply = await _private(PrivatePrompt.tips(bands, ids, pick));
      if (reply == null) return const AssistantResult.rules();
      final order = parseQuestionIds(reply, ids, pick);
      _judge(AssistantUse.tipsOrder, order.isEmpty ? null : order);
      return order.isEmpty ? const AssistantResult.rules() : AssistantResult(order, RanOn.phone);
    }
    if (!status.canRunHybrid) return const AssistantResult.rules();
    final reply = await _hybrid(AssistantUse.tipsOrder, CloudPrompt.tips(bands, pick), consent);
    if (reply == null) return const AssistantResult.rules();
    final order = parseQuestionIds(reply.text, ids, pick);
    _judge(AssistantUse.tipsOrder, order.isEmpty ? null : order);
    if (order.isEmpty) return const AssistantResult.rules();
    return AssistantResult(order, reply.onDevice ? RanOn.phone : RanOn.cloud);
  }

  /// Visit pack: an order for the summary's reviewed questions, on the phone only.
  Future<AssistantResult<List<String>>> orderVisitQuestions(VisitSummary summary) async {
    if (!(await status()).canRunPrivate) return const AssistantResult.rules();
    final prompt = PrivatePrompt.visitQuestions(summary);
    final reply = await _private(prompt);
    if (reply == null) return const AssistantResult.rules();
    final order = parseQuestionIds(reply, prompt.offered, prompt.offered.length);
    _judge(AssistantUse.visitQuestions, order.isEmpty ? null : order);
    return order.isEmpty ? const AssistantResult.rules() : AssistantResult(order, RanOn.phone);
  }
}
