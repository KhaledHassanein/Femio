// Tests for the companion boundary (ADR-081, R10.1): the gateway is the only door to the
// model, and every path that is off, absent, unconsented or wrong returns the rules answer.

import 'package:femio/data/assistant_channel.dart';
import 'package:femio/data/assistant_gateway.dart';
import 'package:femio/domain/assistant/redaction.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/domain/assistant/ai_ledger.dart';
import 'package:femio/domain/assistant/cloud_consent.dart';
import 'package:femio/domain/assistant/cloud_prompt.dart';
import 'package:femio/domain/assistant/private_prompt.dart';
import 'package:femio/domain/assistant/pseudonymised_profile.dart';
import 'package:femio/domain/assistant/tip_catalogue.g.dart';
import 'package:femio/domain/assistant/uses.dart';
import 'package:flutter_test/flutter_test.dart';

class _Bridge implements AssistantBridge {
  _Bridge({this.nano = true, this.configured = true, this.privateReply, this.hybridReply});

  final bool nano;
  final bool configured;
  String? privateReply;
  String? hybridReply;
  final private = <PrivatePrompt>[];
  final hybrid = <CloudPrompt>[];

  @override
  Future<AssistantStatus> status() async => AssistantStatus(
    configured: configured,
    onDevice: nano ? OnDeviceModel.available : OnDeviceModel.unavailable,
  );

  @override
  Future<String?> runPrivate(PrivatePrompt prompt) async {
    private.add(prompt);
    return privateReply;
  }

  @override
  Future<HybridReply?> runHybrid(CloudPrompt prompt) async {
    hybrid.add(prompt);
    return hybridReply == null ? null : HybridReply(text: hybridReply!, onDevice: false);
  }

  // Model download and source links are not part of the boundary under test.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// A bridge that can also run the native Cloud boost check; [result] null makes it throw.
class _Checker extends _Bridge implements CloudChecker {
  _Checker(this.result) : super(nano: false);
  final CloudCheck? result;
  int calls = 0;

  /// What the native side reports for the last failed hybrid call.
  String? failure;

  @override
  String? get lastHybridFailure => failure;

  @override
  Future<CloudCheck> checkCloud() async {
    calls += 1;
    final r = result;
    if (r == null) throw StateError('bridge failed');
    return r;
  }
}

final _bands = pseudonymise(const Profile(goal: Goal.ttc, locale: 'en'), '2026-11-24');
final _ids = tipEnglish.keys.take(3).toList();
final _tipsConsent = const CloudConsent().grant({CloudPurpose.tips}, '2026-11-24T10:00:00Z');

void main() {
  test('every use has a policy; only the reading uses may offer a draft, in the cloud only under the records consent', () {
    expect(usePolicies.keys.toSet(), AssistantUse.values.toSet());
    const onPhone = {AssistantUse.sayItToLog, AssistantUse.scanDocument, AssistantUse.afterVisit};
    const inCloud = {AssistantUse.sayItInCloud, AssistantUse.scanInCloud, AssistantUse.afterVisitInCloud};
    for (final MapEntry(:key, :value) in usePolicies.entries) {
      expect(value.write == AssistantWrite.draftSheConfirms, onPhone.contains(key) || inCloud.contains(key), reason: '$key');
      if (onPhone.contains(key)) expect(value.tier, AssistantTier.phone, reason: '$key');
      if (inCloud.contains(key)) expect(value.consent, CloudPurpose.records, reason: '$key (ADR-089)');
      if (value.tier == AssistantTier.hybrid) expect(value.consent, isNotNull, reason: '$key');
    }
  });

  test('every use names what it sees; a cloud-capable use sees her record only under the records consent, one item', () {
    const cloudSafe = {
      AssistantInput.approvedQuestion,
      AssistantInput.trustedPassages,
      AssistantInput.fourBands,
      AssistantInput.reviewedIds,
    };
    // ADR-089: her own record reaches a cloud-capable use only under the records consent,
    // and then only the one thing she approved on the preview sheet.
    const approvedRecord = {AssistantInput.herDocument, AssistantInput.herVisitWords, AssistantInput.herNote};
    for (final MapEntry(:key, :value) in usePolicies.entries) {
      expect(value.sees, isNotEmpty, reason: '$key');
      if (value.tier == AssistantTier.hybrid) {
        final allowed = value.consent == CloudPurpose.records ? approvedRecord : cloudSafe;
        expect(allowed.containsAll(value.sees), isTrue, reason: '$key');
        expect(value.sees.length, value.consent == CloudPurpose.records ? 1 : greaterThan(0), reason: '$key');
      }
    }
  });

  test('a phone without the model gets the rules answer and the model is never called', () async {
    final b = _Bridge(nano: false, configured: false, privateReply: '{"terms":["cramps"]}');
    final r = await AssistantGateway(b).readNote('cramps today');
    expect(r.ranOn, RanOn.rules);
    expect(r.value, isNull);
    expect(b.private, isEmpty);
  });

  test('Say it returns a draft read on the phone, never written by the gateway', () async {
    final b = _Bridge(privateReply: '{"terms":["cramps"]}');
    final r = await AssistantGateway(b).readNote('cramps today');
    expect(r.ranOn, RanOn.phone);
    expect(r.value!.terms, ['cramps']);
    expect(b.private.single.use, AssistantUse.sayItToLog);
  });

  test('three unusable replies in a row switch a use to rules for the session', () async {
    final b = _Bridge(privateReply: 'not json');
    final g = AssistantGateway(b);
    for (var i = 0; i < assistantCircuitBreakerLimit; i++) {
      expect((await g.readNote('x')).ranOn, RanOn.rules);
    }
    b.privateReply = '{"terms":["cramps"]}';
    expect((await g.readNote('x')).ranOn, RanOn.rules);
    expect(b.private, hasLength(assistantCircuitBreakerLimit));
  });

  test('a usable reply resets the count', () async {
    final b = _Bridge(privateReply: 'not json');
    final g = AssistantGateway(b);
    await g.readNote('x');
    await g.readNote('x');
    b.privateReply = '{"terms":["cramps"]}';
    expect((await g.readNote('x')).ranOn, RanOn.phone);
    b.privateReply = 'not json';
    await g.readNote('x');
    await g.readNote('x');
    b.privateReply = '{"terms":["cramps"]}';
    expect((await g.readNote('x')).ranOn, RanOn.phone);
  });

  test('tips run on the phone from the bands and keep only offered ids', () async {
    final b = _Bridge(privateReply: '{"ids":["${_ids[1]}","made-up"]}');
    final r = await AssistantGateway(b).orderTips(_bands, _ids, 2, const CloudConsent());
    expect(r.ranOn, RanOn.phone);
    expect(r.value, [_ids[1]]);
    expect(b.private.single.offered, _ids);
    expect(b.hybrid, isEmpty);
  });

  test('without Nano, tips go to the cloud only with tips consent', () async {
    final b = _Bridge(nano: false, hybridReply: '{"ids":["${_ids[0]}"]}');
    final none = await AssistantGateway(b).orderTips(_bands, _ids, 2, const CloudConsent());
    expect(none.ranOn, RanOn.rules);
    expect(b.hybrid, isEmpty);
    final questionsOnly = const CloudConsent().grant({CloudPurpose.questions}, '2026-11-24T10:00:00Z');
    await AssistantGateway(b).orderTips(_bands, _ids, 2, questionsOnly);
    expect(b.hybrid, isEmpty);
    final yes = await AssistantGateway(b).orderTips(_bands, _ids, 2, _tipsConsent);
    expect(yes.ranOn, RanOn.cloud);
    expect(yes.value, [_ids[0]]);
    expect(b.hybrid, hasLength(1));
  });

  test('a withdrawn consent stops the cloud path', () async {
    final b = _Bridge(nano: false, hybridReply: '{"ids":["${_ids[0]}"]}');
    final withdrawn = _tipsConsent.withdraw('2026-11-24T11:00:00Z');
    final r = await AssistantGateway(b).orderTips(_bands, _ids, 2, withdrawn);
    expect(r.ranOn, RanOn.rules);
    expect(b.hybrid, isEmpty);
  });

  test('her master switch off: no model call anywhere, rules answer, offline status', () async {
    var on = false;
    final b = _Bridge(nano: false, privateReply: '{"terms":["cramps"]}', hybridReply: '{"ids":["${_ids[0]}"]}');
    final g = AssistantGateway(b, enabled: () => on);
    expect((await g.status()).canRunPrivate, isFalse);
    expect((await g.readNote('cramps today')).ranOn, RanOn.rules);
    expect((await g.orderTips(_bands, _ids, 2, _tipsConsent)).ranOn, RanOn.rules);
    expect(b.private, isEmpty);
    expect(b.hybrid, isEmpty);
    on = true;
    expect((await g.orderTips(_bands, _ids, 2, _tipsConsent)).ranOn, RanOn.cloud);
  });

  group('Check Cloud boost (owner 2026-11-27)', () {
    final questions = const CloudConsent().grant({CloudPurpose.questions}, '2026-11-24T10:00:00Z');

    test('a bridge that cannot check gives no answer, so the button stays hidden', () async {
      expect(await AssistantGateway(_Bridge()).checkCloud(questions), isNull);
    });

    test('the check runs under any Cloud boost purpose with her AI on, and is kept in her ledger', () async {
      var on = true;
      final b = _Checker(const CloudCheck(ok: false, reason: 'app_check'));
      final ledger = <LedgerEntry>[];
      final g = AssistantGateway(b, enabled: () => on, record: (e) async => ledger.add(e));
      expect(await g.checkCloud(const CloudConsent()), isNull);
      on = false;
      expect(await g.checkCloud(questions), isNull);
      expect(b.calls, 0);
      on = true;
      // ADR-089: the fixed sentence holds nothing about her, so any purpose allows the check.
      expect(await g.checkCloud(_tipsConsent), isNotNull);
      expect(b.calls, 1);
      on = true;
      final r = await g.checkCloud(questions);
      expect(r!.ok, isFalse);
      expect(r.reason, 'app_check');
      expect(b.calls, 2);
      await Future<void>.delayed(Duration.zero);
      expect(ledger, hasLength(2));
      expect(ledger.last.cloud, isTrue);
      expect(ledger.last.sent, cloudCheckPrompt, reason: 'she can see exactly what the check sent');
    });

    test('a bridge that throws reads as a timeout, never a crash', () async {
      final r = await AssistantGateway(_Checker(null)).checkCloud(questions);
      expect(r!.ok, isFalse);
      expect(r.reason, 'timeout');
    });

    test('after a lasting failure Cloud boost pauses and names why; a passing check ends it', () async {
      var now = DateTime.utc(2026, 11, 27, 20);
      final b = _Checker(const CloudCheck(ok: true, ms: 900))..failure = 'app_check';
      final g = AssistantGateway(b, clock: () => now);
      final q = toCloudSafe('What helps with period cramps?')!;
      expect((await g.answerWithBoost(q, const [], 'en', questions)).value, isNull);
      expect(b.hybrid, hasLength(1));
      expect(g.cloudPaused, 'app_check');
      expect((await g.answerWithBoost(q, const [], 'en', questions)).value, isNull);
      expect(b.hybrid, hasLength(1), reason: 'nothing is sent while paused, so she does not wait again');
      expect(g.lastCloudFailure, 'app_check');
      await g.checkCloud(questions);
      expect(g.cloudPaused, isNull, reason: 'a passing check ends the pause');
      await g.answerWithBoost(q, const [], 'en', questions);
      expect(b.hybrid, hasLength(2));
      expect(g.cloudPaused, 'app_check');
      now = now.add(cloudPauseAfterLastingFailure + const Duration(minutes: 1));
      expect(g.cloudPaused, isNull, reason: 'the pause ends by itself');
      b.failure = 'network';
      await g.answerWithBoost(q, const [], 'en', questions);
      expect(g.cloudPaused, isNull, reason: 'a passing network problem does not pause Cloud boost');
      expect(g.lastCloudFailure, 'network');
    });
  });

  test('the master switch is saved with her settings and defaults to on', () {
    expect(const AppSettings().assistantOn, isTrue);
    expect(AppSettings.fromJson(const {}).assistantOn, isTrue);
    expect(AppSettings.fromJson(const AppSettings(assistantOn: false).toJson()).assistantOn, isFalse);
  });
}

