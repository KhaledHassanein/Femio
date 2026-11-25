// Tests for the companion boundary (ADR-081, R10.1): the gateway is the only door to the
// model, and every path that is off, absent, unconsented or wrong returns the rules answer.

import 'package:femio/data/assistant_channel.dart';
import 'package:femio/data/assistant_gateway.dart';
import 'package:femio/data/profile.dart';
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

final _bands = pseudonymise(const Profile(goal: Goal.ttc, locale: 'en'), '2026-11-24');
final _ids = tipEnglish.keys.take(3).toList();
final _tipsConsent = const CloudConsent().grant({CloudPurpose.tips}, '2026-11-24T10:00:00Z');

void main() {
  test('every use has a policy; only Say it may offer a draft, and every hybrid use needs consent', () {
    expect(usePolicies.keys.toSet(), AssistantUse.values.toSet());
    for (final MapEntry(:key, :value) in usePolicies.entries) {
      expect(value.write == AssistantWrite.draftSheConfirms, key == AssistantUse.sayItToLog, reason: '$key');
      if (value.tier == AssistantTier.hybrid) expect(value.consent, isNotNull, reason: '$key');
    }
  });

  test('every use names what it sees; a use that may reach the cloud never sees her note or visit facts', () {
    const cloudSafe = {
      AssistantInput.approvedQuestion,
      AssistantInput.trustedPassages,
      AssistantInput.fourBands,
      AssistantInput.reviewedIds,
    };
    for (final MapEntry(:key, :value) in usePolicies.entries) {
      expect(value.sees, isNotEmpty, reason: '$key');
      if (value.tier == AssistantTier.hybrid) {
        expect(cloudSafe.containsAll(value.sees), isTrue, reason: '$key');
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

  test('the master switch is saved with her settings and defaults to on', () {
    expect(const AppSettings().assistantOn, isTrue);
    expect(AppSettings.fromJson(const {}).assistantOn, isTrue);
    expect(AppSettings.fromJson(const AppSettings(assistantOn: false).toJson()).assistantOn, isFalse);
  });
}

