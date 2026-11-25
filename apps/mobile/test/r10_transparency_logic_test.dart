// AI transparency (R10.3): the reasons behind a tip, and the ledger of model calls.
//
// Why it exists: a "why" that names a fact the trigger never checked, or a ledger that keeps her
// own words from a phone-only call, would break the promise the screens make. These cases use
// synthetic records and a fake model bridge.

import 'dart:io';
import 'dart:ui';

import 'package:femio/app.dart';
import 'package:femio/data/ai_ledger_store.dart';
import 'package:femio/data/assistant_channel.dart';
import 'package:femio/data/assistant_gateway.dart';
import 'package:femio/data/key_vault.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/assistant/ai_ledger.dart';
import 'package:femio/domain/assistant/cloud_consent.dart';
import 'package:femio/domain/assistant/cloud_prompt.dart';
import 'package:femio/domain/assistant/personal_triggers.dart' as triggers;
import 'package:femio/domain/assistant/personal_triggers.dart' hide matches;
import 'package:femio/domain/assistant/private_prompt.dart';
import 'package:femio/domain/assistant/pseudonymised_profile.dart';
import 'package:femio/domain/assistant/tip_catalogue.g.dart';
import 'package:femio/domain/assistant/tip_reasons.dart';
import 'package:femio/domain/assistant/uses.dart';
import 'package:femio/features/today/tip_why_sheet.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _today = '2026-06-20';

class _Bridge implements AssistantBridge {
  _Bridge({required this.nano, this.privateReply, this.hybridReply});
  final bool nano;
  final String? privateReply;
  final String? hybridReply;

  @override
  Future<AssistantStatus> status() async =>
      AssistantStatus(configured: true, onDevice: nano ? OnDeviceModel.available : OnDeviceModel.unavailable);

  @override
  Future<bool> downloadModel() async => false;

  @override
  Future<String?> runPrivate(PrivatePrompt prompt) async => privateReply;

  @override
  Future<HybridReply?> runHybrid(CloudPrompt prompt) async =>
      hybridReply == null ? null : HybridReply(text: hybridReply!, onDevice: false);

  @override
  Future<bool> openSource(String url) async => false;
}

TriggerContext _context({Map<String, DayLog> logs = const {}}) => TriggerContext(
      stage: StageBand.ttc,
      today: _today,
      logs: logs,
      tryingFor: TryingFor.sixTo12,
      irregular: true,
      age: 36,
    );

void main() {
  group('tip reasons', () {
    test('each condition of the trigger gives one reason, with her own value', () {
      const trigger = PersonalTrigger(
        stages: {StageBand.ttc},
        term: TermRule('cramps', 2, 30),
        tryingFor: {TryingFor.sixTo12, TryingFor.over12},
        irregular: true,
        ageFrom: 35,
      );
      final c = _context(logs: {
        '2026-06-01': const DayLog(terms: ['cramps']),
        '2026-06-02': const DayLog(terms: ['cramps']),
        '2026-06-10': const DayLog(terms: ['cramps', 'fatigue']),
      });
      expect(triggers.matches(trigger, c), isTrue);
      final r = tipReasons(trigger, c);
      expect(r.length, 1 + 4, reason: 'stage plus four conditions');
      expect((r[0] as StageReason).stage, StageBand.ttc);
      expect((r[1] as TermReason).days, 3, reason: 'her count, not the threshold');
      expect((r[2] as TryingForReason).tryingFor, TryingFor.sixTo12);
      expect((r[3] as IrregularReason).irregular, isTrue);
      expect((r[4] as AgeReason).from, 35);
    });

    test('a stage-only tip says only the stage', () {
      const trigger = PersonalTrigger(stages: {StageBand.ttc});
      expect(tipReasons(trigger, _context()).single, isA<StageReason>());
    });

    test('every fitting catalogue tip can be put into words in all four languages', () async {
      final c = _context(logs: {
        for (var d = 1; d <= 12; d++) '2026-06-${d.toString().padLeft(2, '0')}': const DayLog(terms: ['cramps', 'anxious', 'sad', 'acne']),
      });
      final fits = fitting(tipCatalogue, c);
      expect(fits, isNotEmpty);
      for (final lang in ['en', 'ar', 'fr', 'es']) {
        final l = await L10n.delegate.load(Locale(lang));
        for (final tip in fits) {
          final lines = tipWhyLines(l, tip, c, cloudOrdered: false);
          expect(lines.every((s) => s.trim().isNotEmpty), isTrue, reason: '$lang ${tip.id}');
          expect(lines, contains(l.tipWhyFootnote));
          expect(lines.last, l.tipsSource(tip.publisher));
        }
      }
    });
  });

  group('the ledger', () {
    LedgerEntry e(int i, {bool cloud = false, String? sent}) =>
        LedgerEntry(at: '2026-06-20T10:00:${i.toString().padLeft(2, '0')}Z', use: AssistantUse.tipsOrder, cloud: cloud, answered: true, sent: sent);

    test('newest first, capped, and a phone entry never keeps text', () {
      var l = <LedgerEntry>[];
      for (var i = 0; i < maxLedgerEntries + 5; i++) {
        l = addToLedger(l, e(i % 60));
      }
      expect(l.length, maxLedgerEntries);
      expect(addToLedger(const [], e(1, sent: 'her words')).single.sent, isNull);
      expect(addToLedger(const [], e(1, cloud: true, sent: 'bands')).single.sent, 'bands');
    });

    test('an entry this build cannot read is dropped, not guessed', () {
      expect(LedgerEntry.fromJson({'at': 'x', 'use': 'someFutureUse', 'cloud': false}), isNull);
      final back = LedgerEntry.fromJson(e(3, cloud: true, sent: 's').toJson())!;
      expect((back.use, back.cloud, back.sent), (AssistantUse.tipsOrder, true, 's'));
    });

    test('the sealed file round-trips, drops a damaged file, and clears with its key', () async {
      final dir = await Directory.systemTemp.createTemp('femio-ledger');
      addTearDown(() => dir.delete(recursive: true));
      final vault = MemoryKeyVault();
      final store = EncryptedLedgerStore(vault: vault, directory: dir);
      await store.save([e(1, cloud: true, sent: 'bands'), e(2)]);
      expect((await store.load()).map((x) => x.sent), ['bands', null]);
      final file = File('${dir.path}/$ledgerFileName');
      expect(String.fromCharCodes(await file.readAsBytes()), isNot(contains('bands')), reason: 'sealed, not plain');
      await file.writeAsBytes([1, 2, 3]);
      expect(await store.load(), isEmpty);
      await store.save([e(1)]);
      await store.clear();
      expect(await file.exists(), isFalse);
      expect(await vault.read(ledgerKeyName), isNull);
    });

    test('the gateway records a phone call without text and a cloud call with what was sent', () async {
      final kept = <LedgerEntry>[];
      final profile = Profile(goal: Goal.ttc, locale: 'en', periodStarts: const ['2026-05-01']);
      final bands = pseudonymise(profile, _today);
      final consent = const CloudConsent().grant({CloudPurpose.tips}, '2026-06-20T09:00:00Z');
      final ids = [for (final f in forStage(tipCatalogue, StageBand.ttc)) f.id];

      final phone = AssistantGateway(_Bridge(nano: true, privateReply: '{"ids":["${ids.first}"]}'), record: (x) async => kept.add(x));
      await phone.orderTips(bands, ids, 3, consent);
      expect((kept.single.cloud, kept.single.sent, kept.single.answered), (false, null, true));

      kept.clear();
      final cloud = AssistantGateway(_Bridge(nano: false, hybridReply: 'not json'), record: (x) async => kept.add(x));
      await cloud.orderTips(bands, ids, 3, consent);
      expect(kept.single.cloud, isTrue);
      expect(kept.single.sent, CloudPrompt.tips(bands, 3).text, reason: 'the receipt is exactly what was sent');

      kept.clear();
      await cloud.orderTips(bands, ids, 3, const CloudConsent());
      expect(kept, isEmpty, reason: 'no consent, no call, nothing to record');
    });

    test('delete everything empties the ledger', () async {
      final ledger = MemoryLedgerStore();
      final c = FemioController(MemoryStore(Profile(goal: Goal.period, locale: 'en')), ledger: ledger);
      await c.load();
      await c.recordAiCall(e(1, cloud: true, sent: 'bands'));
      expect(c.aiLedger, hasLength(1));
      await c.deleteEverything();
      expect(c.aiLedger, isEmpty);
      expect(await ledger.load(), isEmpty);
    });
  });
}
