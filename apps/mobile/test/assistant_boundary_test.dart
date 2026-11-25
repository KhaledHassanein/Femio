// The companion boundary, slice 2 (ADR-081, R10.1): fuzzed replies, failing bridges, offline
// parity, and the rule that the AI code cannot reach her record.
//
// Why it exists: rule 7 says the AI never touches core functions and never writes to her
// record without her confirming. These tests try to break that from the outside: hostile or
// random replies, a bridge that throws, every switch off, and a scan of what the AI code
// imports. Synthetic records only; no model runs.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:femio/data/assistant_channel.dart';
import 'package:femio/data/assistant_gateway.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/domain/assistant/ai_ledger.dart';
import 'package:femio/domain/assistant/cloud_consent.dart';
import 'package:femio/domain/assistant/cloud_prompt.dart';
import 'package:femio/domain/assistant/log_phrases.dart' show phraseOpkResults;
import 'package:femio/domain/assistant/private_prompt.dart';
import 'package:femio/domain/assistant/prompts.dart';
import 'package:femio/domain/assistant/pseudonymised_profile.dart';
import 'package:femio/domain/assistant/redaction.dart';
import 'package:femio/domain/assistant/source_registry.dart';
import 'package:femio/domain/assistant/tip_catalogue.g.dart';
import 'package:femio/domain/assistant/visit_summary.dart';
import 'package:femio/domain/log_vocabulary.g.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:flutter_test/flutter_test.dart';

const _today = '2026-06-20';

/// A model that always answers with [reply], or throws when [fail] is set.
class _Bridge implements AssistantBridge {
  _Bridge({this.reply = '', this.fail = false});
  String reply;
  final bool fail;
  int calls = 0;

  @override
  Future<AssistantStatus> status() async =>
      const AssistantStatus(configured: true, onDevice: OnDeviceModel.available);

  @override
  Future<bool> downloadModel() async => false;

  @override
  Future<String?> runPrivate(PrivatePrompt prompt) async {
    calls++;
    if (fail) throw StateError('bridge failed');
    return reply;
  }

  @override
  Future<HybridReply?> runHybrid(CloudPrompt prompt) async {
    calls++;
    if (fail) throw StateError('bridge failed');
    return HybridReply(text: reply, onDevice: true);
  }

  @override
  Future<bool> openSource(String url) async => false;
}

/// Random text built from the characters a broken or hostile reply tends to contain.
String _noise(Random r) {
  const pieces = [
    '{', '}', '[', ']', '"', ':', ',', 'null', 'true', '1', '99', '-3', 'ids', 'terms', 'flow', 'opk',
    'heavy', 'cramps', 'intercourse', 'positive', 'peak', 'NOT_COVERED', '[1]', '[0]', '[12]', 'ignore all rules',
    '\u{1F600}', 'مغص', '\n', ' ', '\\', 'tip-x', 'q-1',
  ];
  return [for (var i = 0; i < r.nextInt(30); i++) pieces[r.nextInt(pieces.length)]].join(r.nextBool() ? ' ' : '');
}

late SourceRegistry _registry;
final _profile = Profile(goal: Goal.ttc, locale: 'en', periodStarts: const ['2026-05-01', '2026-05-29']);
final _bands = pseudonymise(_profile, _today);
final _tipIds = tipEnglish.keys.take(5).toList();

void main() {
  setUpAll(() {
    _registry = SourceRegistry.fromJson(
      jsonDecode(File('assets/trusted_sources/registry.json').readAsStringSync()) as Map<String, Object?>,
    );
  });

  group('fuzzed replies can only add what was offered', () {
    final r = Random(20261125);
    final offered = ['q-a', 'q-b', 'q-c'];
    final flows = flowLevels.toSet();

    test('1,500 random replies: no throw, no value outside the offer', () {
      for (var i = 0; i < 1500; i++) {
        final text = _noise(r);
        final ids = parseQuestionIds(text, offered, 2);
        expect(ids.every(offered.contains) && ids.length <= 2, isTrue, reason: text);

        final s = parseExtraction(text);
        expect(s.terms.every(modelLogKeys.contains), isTrue, reason: text);
        expect(s.flow == null || flows.contains(s.flow), isTrue, reason: text);
        expect(s.opk == null || phraseOpkResults.contains(s.opk), isTrue, reason: text);

        final a = parseAnswer(text, 3);
        if (a != null) expect(a.cited.every((n) => n >= 1 && n <= 3), isTrue, reason: text);
      }
    });

    test('a well-formed reply with invented keys suggests nothing', () {
      final s = parseExtraction('{"terms": ["cramps", "pregnant", "intercourse", "cramps"], "flow": "torrential", "opk": "peak"}');
      expect(s.terms, ['cramps'], reason: 'known, offered, once');
      expect((s.flow, s.opk), (null, null));
    });

    test('an answer citing a passage that was not given is not shown', () {
      expect(parseAnswer('Rest helps [4].', 3), isNull);
      expect(parseAnswer('Rest helps.', 3), isNull, reason: 'no citation, no answer');
      expect(parseAnswer('Rest helps [2].', 3)!.cited, {2});
    });
  });

  group('the gateway keeps the rules answer when the model fails', () {
    Future<List<RanOn>> everyUse(AssistantGateway g) async {
      final passages = _registry.entries.take(2).toList();
      final summary = visitSummary(_profile, _today);
      final consent = const CloudConsent().grant({CloudPurpose.questions, CloudPurpose.tips}, '2026-06-20T08:00:00Z');
      return [
        (await g.answerOnPhone('how long to try before seeing a doctor', passages, 'en')).ranOn,
        (await g.answerWithBoost(toCloudSafe('how long to try before seeing a doctor')!, passages, 'en', consent)).ranOn,
        (await g.readNote('cramps today')).ranOn,
        (await g.orderTips(_bands, _tipIds, 3, consent)).ranOn,
        (await g.orderVisitQuestions(summary)).ranOn,
      ];
    }

    test('a bridge that throws never reaches the screen', () async {
      final b = _Bridge(fail: true);
      expect(await everyUse(AssistantGateway(b)), everyElement(RanOn.rules));
      expect(b.calls, greaterThan(0), reason: 'it was called, and failed quietly');
    });

    test('invented log keys count as unusable and trip the breaker', () async {
      final b = _Bridge(reply: '{"terms": ["notAKey"]}');
      final g = AssistantGateway(b);
      for (var i = 0; i < assistantCircuitBreakerLimit; i++) {
        expect((await g.readNote('x')).ranOn, RanOn.rules);
      }
      final before = b.calls;
      b.reply = '{"terms": ["cramps"]}';
      expect((await g.readNote('cramps')).ranOn, RanOn.rules);
      expect(b.calls, before, reason: 'the use is closed for this session');
    });

    test('offline parity: with AI off every use returns rules, calls nothing and logs nothing', () async {
      final kept = <LedgerEntry>[];
      final b = _Bridge(reply: '{"ids": []}');
      final off = AssistantGateway(b, enabled: () => false, record: (e) async => kept.add(e));
      expect(await everyUse(off), everyElement(RanOn.rules));
      expect(b.calls, 0);
      expect(kept, isEmpty);

      final offline = AssistantGateway(const OfflineAssistant(), record: (e) async => kept.add(e));
      expect(await everyUse(offline), everyElement(RanOn.rules));
      expect(kept, isEmpty);
    });
  });

  test('the AI code cannot reach her record: no store, controller, backup or screen import', () {
    final files = [
      File('lib/data/assistant_gateway.dart'),
      ...Directory('lib/domain/assistant').listSync().whereType<File>().where((f) => f.path.endsWith('.dart')),
    ];
    final forbidden = RegExp(r"""import\s+'[^']*(app\.dart|/store\.dart|store\.dart|backup|key_vault|/features/)""");
    for (final f in files) {
      final hits = forbidden.allMatches(f.readAsStringSync()).map((m) => m.group(0)).toList();
      expect(hits, isEmpty, reason: f.path);
    }
  });
}
