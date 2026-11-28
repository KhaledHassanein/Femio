// The translation bridge for the AI on this phone (ADR-087 §6).
//
// Why it exists: Gemini Nano is validated in English, so a question in another language is
// translated to English on the phone, answered, and translated back. These tests pin the
// parts that can go wrong: citation marks survive translation, any failed step falls back to
// the old path (never a half-translated answer), English needs no translator, and the
// settings row downloads only on her tap. Fakes only; no model or translator runs.

import 'dart:convert';
import 'dart:io';

import 'package:femio/data/assistant_channel.dart';
import 'package:femio/data/assistant_gateway.dart';
import 'package:femio/data/translate_channel.dart';
import 'package:femio/domain/assistant/cited_translation.dart';
import 'package:femio/domain/assistant/cloud_prompt.dart';
import 'package:femio/domain/assistant/private_prompt.dart';
import 'package:femio/domain/assistant/source_registry.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:femio/features/assistant/translation_tile.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/theme/femio_theme.dart';
import 'package:femio/domain/assistant/prompts.dart';
import 'package:femio/features/assistant/answer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

/// A Nano that records every prompt and answers with [reply].
class _Bridge implements AssistantBridge {
  _Bridge(this.reply);
  final String reply;
  final prompts = <String>[];

  @override
  Future<AssistantStatus> status() async => const AssistantStatus(configured: true, onDevice: OnDeviceModel.available);
  @override
  Future<bool> downloadModel() async => false;
  @override
  Future<String?> runPrivate(PrivatePrompt prompt) async {
    prompts.add(prompt.text);
    return reply;
  }

  @override
  Future<HybridReply?> runHybrid(CloudPrompt prompt) async => null;
  @override
  Future<bool> openSource(String url) async => false;
}

/// A translator that tags text with the target language, so tests can see what ran.
class _Translator implements TranslatorPort {
  _Translator({this.ready_ = true, this.failBack = false});
  bool ready_;
  final bool failBack;
  int downloads = 0;
  final calls = <String>[];

  @override
  Future<bool> ready(String lang) async => lang == 'en' || ready_;
  @override
  Future<bool> download(String lang) async {
    downloads++;
    ready_ = true;
    return true;
  }

  @override
  Future<bool> remove(String lang) async {
    ready_ = false;
    return true;
  }

  @override
  Future<String?> translate(String text, {required String from, required String to}) async {
    calls.add('$from>$to:$text');
    if (failBack && to != 'en') return null;
    return '<$to>$text';
  }
}

const _out = '../../../testing-results/2026-11-28-r11-translate';

void main() {
  late List<SourceEntry> passages;
  late SourceRegistry registry;
  setUpAll(() async {
    await loadAppFonts();
    registry = SourceRegistry.fromJson(
      jsonDecode(File('assets/trusted_sources/registry.json').readAsStringSync()) as Map<String, Object?>,
    );
    passages = registry.entries.take(2).toList();
  });

  group('citation marks survive translation', () {
    test('each piece keeps its own marks', () {
      final pieces = citedPieces('Rest helps [1]. See a doctor after a year [1][2]. Tail');
      expect(pieces.map((p) => p.marks.replaceAll(' ', '')), ['[1]', '[1][2]', '']);
    });

    test('words are translated and the marks put back as they were', () async {
      final out = await translateCited('Rest helps [1]. Sleep too [2].', (w) async => 'T($w)');
      expect(out, 'T(Rest helps) [1]. T(Sleep too) [2].');
    });

    test('one failed piece fails the whole answer', () async {
      var n = 0;
      final out = await translateCited('A [1]. B [2].', (w) async => ++n == 2 ? null : w);
      expect(out, isNull);
    });
  });

  group('Ask on the phone through English', () {
    test('Arabic question: translated, answered in English, translated back', () async {
      final bridge = _Bridge('Talk to a clinician after twelve months [1].');
      final t = _Translator();
      final g = AssistantGateway(bridge, translator: t);
      final r = await g.answerOnPhone('سؤالي', passages, 'ar');
      expect(r.ranOn, RanOn.phone);
      expect(r.value!.translated, isTrue);
      expect(r.value!.cited, {1});
      expect(r.value!.text, contains('[1]'));
      expect(r.value!.text, startsWith('<ar>'));
      expect(bridge.prompts.single, contains('<en>سؤالي'), reason: 'Nano reads the English question');
      expect(bridge.prompts.single, contains('Answer in English'));
    });

    test('no language file: Nano is asked in her language, untranslated', () async {
      final bridge = _Bridge('Talk to a clinician [1].');
      final t = _Translator(ready_: false);
      final r = await AssistantGateway(bridge, translator: t).answerOnPhone('سؤالي', passages, 'ar');
      expect(r.value!.translated, isFalse);
      expect(t.calls, isEmpty);
      expect(bridge.prompts.single, contains('سؤالي'));
    });

    test('a failed translation back falls back to asking in her language', () async {
      final bridge = _Bridge('Talk to a clinician [1].');
      final r = await AssistantGateway(bridge, translator: _Translator(failBack: true)).answerOnPhone('q', passages, 'fr');
      expect(r.value!.translated, isFalse);
      expect(bridge.prompts, hasLength(2), reason: 'English attempt, then the old path');
    });

    test('English needs no translator', () async {
      final t = _Translator();
      final r = await AssistantGateway(_Bridge('Rest [1].'), translator: t).answerOnPhone('q', passages, 'en');
      expect(r.value!.translated, isFalse);
      expect(t.calls, isEmpty);
      expect(await AssistantGateway(_Bridge(''), translator: t).questionInEnglish('q', 'en'), isNull);
    });

    test('her question in English, for finding passages', () async {
      final g = AssistantGateway(_Bridge(''), translator: _Translator());
      expect(await g.questionInEnglish('pregunta', 'es'), '<en>pregunta');
      expect(await AssistantGateway(_Bridge('')).questionInEnglish('pregunta', 'es'), isNull);
    });
  });

  group('the settings row', () {
    Widget host(_Translator t, Locale locale, {bool nano = true}) => MaterialApp(
          locale: locale,
          theme: FemioTheme.light(),
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          home: AssistantScope(
            bridge: const OfflineAssistant(),
            translator: t,
            child: Scaffold(body: TranslationTile(nanoPossible: nano)),
          ),
        );

    testWidgets('downloads only when she taps Download', (tester) async {
      final t = _Translator(ready_: false);
      await tester.pumpWidget(host(t, const Locale('ar')));
      await tester.pumpAndSettle();
      expect(t.downloads, 0);
      final l = await L10n.delegate.load(const Locale('ar'));
      await tester.tap(find.text(l.translateDownload));
      await tester.pumpAndSettle();
      expect(t.downloads, 1);
      expect(find.text(l.translateReady), findsOneWidget);
    });

    testWidgets('hidden in English and on phones without Gemini Nano', (tester) async {
      await tester.pumpWidget(host(_Translator(), const Locale('en')));
      await tester.pumpAndSettle();
      expect(find.byType(TranslationTile), findsOneWidget);
      expect(find.byIcon(Icons.translate_rounded), findsNothing);
      await tester.pumpWidget(host(_Translator(), const Locale('fr'), nano: false));
      await tester.pumpAndSettle();
      expect(find.byType(TranslationTile), findsOneWidget);
      expect(find.byIcon(Icons.translate_rounded), findsNothing);
    });
  });

  // The row and a translated answer at 390x844, Arabic, light and dark: the screenshot is the
  // test (CLAUDE.md). Written under --update-goldens only.
  for (final b in Brightness.values) {
    testWidgets('screenshot ar ${b.name}', (tester) async {
      tester.view.physicalSize = const Size(780, 1688);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      final found = searchRegistry('how long to try before seeing a doctor', registry);
      await tester.pumpWidget(MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
        locale: const Locale('ar'),
        supportedLocales: L10n.supportedLocales,
        localizationsDelegates: const [
          L10n.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: AssistantScope(
          bridge: const OfflineAssistant(),
          translator: _Translator(ready_: false),
          child: Scaffold(
            body: ListView(padding: const EdgeInsets.all(20), children: [
              const TranslationTile(nanoPossible: true),
              AnswerCard(
                answer: found,
                summary: const CitedAnswer('تحدّثي مع طبيبك إذا لم يحدث حمل بعد سنة من المحاولة [1].', {1}, translated: true),
                origin: AnswerOrigin.onPhone,
              ),
            ]),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.translate_rounded), findsOneWidget);
      if (autoUpdateGoldenFiles) {
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/translate_ar_${b.name}.png'));
      }
    });
  }
}
