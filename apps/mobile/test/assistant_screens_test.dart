// Widget tests and screenshots for the assistant screens (ADR-078, R7.3, R7.4).
//
// A fake bridge stands in for Firebase, so the tests prove what the screens do with each
// answer the bridge can give: the safety rules stop a question before any call, answers come
// only from the bundled registry with numbered sources (ADR-079), her own words go only to the
// on-phone model, the cloud sees a question only with Cloud boost on and her approval, and
// say-it entries reach the record. Screenshots at 390×844 (light, dark, Arabic)
// are written to testing-results/2026-11-24-r7-assistant/ under `--update-goldens` only.

import 'dart:convert';
import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/assistant_channel.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/assistant/cloud_consent.dart';
import 'package:femio/domain/assistant/cloud_prompt.dart';
import 'package:femio/domain/assistant/private_prompt.dart';
import 'package:femio/domain/assistant/source_registry.dart';
import 'package:femio/domain/assistant/uses.dart';
import 'package:femio/features/assistant/ai_choices_wizard.dart';
import 'package:femio/features/assistant/ai_choices_record_screen.dart';
import 'package:femio/features/assistant/ai_sees_screen.dart';
import 'package:femio/features/assistant/ask_screen.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:femio/features/assistant/assistant_settings_screen.dart';
import 'package:femio/features/assistant/cloud_boost_screen.dart';
import 'package:femio/features/assistant/say_it_sheet.dart';
import 'package:femio/features/assistant/visit_summary_screen.dart';
import 'package:femio/features/today/tips_card.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _out = '../../../testing-results/2026-11-24-r7-assistant';
const _today = '2026-11-24';

/// A bridge whose answers the test sets, and which records what reached the cloud.
class FakeAssistant implements AssistantBridge {
  FakeAssistant({
    this.nano = true,
    this.cloud = true,
    this.privateReply,
    this.hybridReply,
  });
  final bool nano;
  final bool cloud;
  String? privateReply;
  String? hybridReply;
  final List<String> sentToCloud = [];
  final List<String> privatePrompts = [];

  @override
  Future<AssistantStatus> status() async => AssistantStatus(
    configured: cloud,
    onDevice: nano ? OnDeviceModel.available : OnDeviceModel.unavailable,
  );

  @override
  Future<bool> downloadModel() async => true;

  @override
  Future<String?> runPrivate(PrivatePrompt prompt) async {
    privatePrompts.add(prompt.text);
    return nano ? privateReply : null;
  }

  @override
  Future<HybridReply?> runHybrid(CloudPrompt prompt) async {
    sentToCloud.add(prompt.text);
    final r = hybridReply;
    return r == null ? null : HybridReply(text: r, onDevice: false);
  }

  @override
  Future<bool> openSource(String url) async => true;
}

/// The registry the app ships, read from the asset file.
final _registry = SourceRegistry.fromJson(
  jsonDecode(File('assets/trusted_sources/registry.json').readAsStringSync())
      as Map<String, Object?>,
);

Future<void> _loadFonts() async {
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final f in files) {
      final bytes = File(f).readAsBytesSync();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
    await loader.load();
  }

  await load('Newsreader', ['assets/fonts/Newsreader.ttf']);
  await load('PlusJakartaSans', ['assets/fonts/PlusJakartaSans.ttf']);
  await load('IBMPlexSansArabic', [
    'assets/fonts/IBMPlexSansArabic-Regular.ttf',
    'assets/fonts/IBMPlexSansArabic-Medium.ttf',
    'assets/fonts/IBMPlexSansArabic-SemiBold.ttf',
    'assets/fonts/IBMPlexSansArabic-Bold.ttf',
  ]);
  final sdk = Platform.environment['FLUTTER_ROOT'] ?? '/root/sdk/flutter';
  await load('MaterialIcons', [
    '$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  ]);
}

Widget _app(String locale, Brightness b, AssistantBridge bridge, Widget home) =>
    MaterialApp(
      // The shots feed the website tour: no debug ribbon.
      debugShowCheckedModeBanner: false,
      theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
      locale: Locale(locale),
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
        Locale('es'),
      ],
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) =>
          AssistantScope(bridge: bridge, child: child!),
      home: home,
    );

Future<FemioController> _controller(Profile p, {bool boost = false}) async {
  if (boost) {
    p = p.copyWith(
      settings: p.settings.copyWith(
        cloud: const CloudConsent().grant(CloudPurpose.values.toSet(), '2026-11-24T10:00:00Z'),
      ),
    );
  }
  final c = FemioController(MemoryStore(p));
  await c.load();
  return c;
}

Profile _ttc(String lang) {
  var p = Profile(
    goal: Goal.ttc,
    locale: lang,
    birthYear: 1990,
    periodStarts: const [
      '2026-08-01',
      '2026-08-30',
      '2026-10-01',
      '2026-10-29',
    ],
    tryingFor: TryingFor.sixTo12,
  );
  for (final d in ['2026-10-29', '2026-10-30', '2026-10-31']) {
    p = p.withDayLog(
      d,
      DayLog(
        flow: d == '2026-10-29' ? 'heavy' : 'medium',
        terms: const ['cramps', 'fatigue'],
      ),
    );
  }
  return p.withDayLog(
    '2026-11-12',
    const DayLog(opk: 'positive', terms: ['bloating']),
  );
}

Future<void> _size(WidgetTester tester) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

Future<void> _shoot(String name) async {
  if (!autoUpdateGoldenFiles) return;
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('$_out/$name.png'),
  );
}

void main() {
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  group('Ask femio', () {
    Widget ask(FemioController c) =>
        AskScreen(controller: c, registry: _registry, today: _today);

    Future<void> askIt(WidgetTester tester, String q) async {
      await tester.enterText(find.byType(TextField).first, q);
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();
    }

    testWidgets(
      'a birth-control question gets the fixed answer and never reaches a model',
      (tester) async {
        final bridge = FakeAssistant();
        final c = await _controller(_ttc('en'), boost: true);
        await tester.pumpWidget(_app('en', Brightness.light, bridge, ask(c)));
        await askIt(tester, 'which are the safe days to avoid pregnancy?');
        expect(
          find.textContaining('not a way to avoid pregnancy'),
          findsOneWidget,
        );
        expect(bridge.sentToCloud, isEmpty);
        expect(bridge.privatePrompts, isEmpty);
      },
    );

    testWidgets(
      'heavy bleeding with dizziness shows the emergency card first',
      (tester) async {
        await _size(tester);
        final bridge = FakeAssistant();
        final c = await _controller(_ttc('en'));
        await tester.pumpWidget(_app('en', Brightness.light, bridge, ask(c)));
        await askIt(tester, 'heavy bleeding and I feel dizzy');
        expect(find.text('Heavy bleeding with dizziness'), findsOneWidget);
        expect(bridge.privatePrompts, isEmpty);
        await _shoot('en_light_ask_heavy_bleeding');
      },
    );

    testWidgets(
      'with Nano, her own words are answered on the phone from registry passages',
      (tester) async {
        final bridge = FakeAssistant(
          privateReply: 'Heat on the lower belly and exercise may help [1].',
        );
        final c = await _controller(_ttc('en'), boost: true);
        await tester.pumpWidget(_app('en', Brightness.light, bridge, ask(c)));
        await askIt(
          tester,
          'I am 34 and my period cramps are awful, what can I do?',
        );
        expect(bridge.privatePrompts.single, contains('Passages:'));
        expect(bridge.privatePrompts.single, contains('I am 34'));
        expect(
          bridge.sentToCloud,
          isEmpty,
          reason: 'Nano is on the phone; nothing leaves',
        );
        expect(find.textContaining('Heat on the lower belly'), findsOneWidget);
        expect(find.textContaining('Gemini Nano'), findsOneWidget);
        expect(find.text('Sources'), findsOneWidget);
      },
    );

    testWidgets(
      'an answer that cites no passage is replaced by the passages word for word',
      (tester) async {
        final bridge = FakeAssistant(privateReply: 'Drink celery juice.');
        final c = await _controller(_ttc('en'));
        await tester.pumpWidget(_app('en', Brightness.light, bridge, ask(c)));
        await askIt(tester, 'what helps period cramps?');
        expect(find.textContaining('celery'), findsNothing);
        expect(find.text('Word for word from trusted sources'), findsOneWidget);
      },
    );

    testWidgets('without Nano and with Cloud boost off, nothing is sent', (
      tester,
    ) async {
      final bridge = FakeAssistant(nano: false);
      final c = await _controller(_ttc('en'));
      await tester.pumpWidget(_app('en', Brightness.light, bridge, ask(c)));
      await askIt(tester, 'what helps period cramps?');
      expect(bridge.sentToCloud, isEmpty);
      expect(find.text('Word for word from trusted sources'), findsOneWidget);
    });

    testWidgets('without Nano and with Cloud boost off, she is offered Cloud boost (owner 2026-11-28)', (
      tester,
    ) async {
      final bridge = FakeAssistant(nano: false);
      final c = await _controller(_ttc('en'));
      await tester.pumpWidget(_app('en', Brightness.light, bridge, ask(c)));
      await askIt(tester, 'what helps period cramps?');
      final button = find.text('Turn on Cloud boost');
      await tester.scrollUntilVisible(button, 200, scrollable: find.byType(Scrollable).first);
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.byType(AiChoicesWizard), findsOneWidget);
      expect(bridge.sentToCloud, isEmpty, reason: 'offering is not sending');
    });

    for (final (lang, b) in const [('en', Brightness.light), ('ar', Brightness.light), ('ar', Brightness.dark)]) {
      testWidgets('screenshot: Cloud boost offered without Nano ($lang, ${b.name})', (tester) async {
        await _size(tester);
        final c = await _controller(_ttc(lang));
        await tester.pumpWidget(_app(lang, b, FakeAssistant(nano: false), ask(c)));
        await askIt(tester, lang == 'ar' ? 'ما الذي يساعد في تقلصات الدورة؟' : 'what helps period cramps?');
        final l = lookupL10n(Locale(lang));
        await tester.scrollUntilVisible(find.text(l.askTurnOnBoost), 200, scrollable: find.byType(Scrollable).first);
        await tester.drag(find.byType(Scrollable).first, const Offset(0, 260));
        await tester.pumpAndSettle();
        await _shoot('boost_offer_${lang}_${b.name}');
      });
    }

    testWidgets(
      'with Cloud boost on, a question about her still stays on the phone',
      (tester) async {
        final bridge = FakeAssistant(nano: false, hybridReply: 'x [1]');
        final c = await _controller(_ttc('en'), boost: true);
        await tester.pumpWidget(_app('en', Brightness.light, bridge, ask(c)));
        await askIt(tester, 'my period cramps are awful, what helps?');
        expect(bridge.sentToCloud, isEmpty);
        expect(find.textContaining('stays on this phone'), findsOneWidget);
      },
    );

    testWidgets(
      'with Cloud boost on, a general question is sent only after she approves it',
      (tester) async {
        final bridge = FakeAssistant(
          nano: false,
          hybridReply: 'Heat and exercise may help [1].',
        );
        final c = await _controller(_ttc('en'), boost: true);
        await tester.pumpWidget(_app('en', Brightness.light, bridge, ask(c)));
        await askIt(tester, 'what helps period cramps?');
        expect(
          bridge.sentToCloud,
          isEmpty,
          reason: 'nothing leaves before she approves',
        );
        await tester.tap(find.byIcon(Icons.cloud_outlined));
        await tester.pumpAndSettle();
        expect(
          bridge.sentToCloud.single,
          contains('Question: """what helps period cramps?"""'),
        );
        expect(find.textContaining("Google's cloud AI"), findsOneWidget);
      },
    );

    testWidgets('a question the registry does not cover says so', (
      tester,
    ) async {
      final bridge = FakeAssistant(privateReply: 'Paris [1].');
      final c = await _controller(_ttc('en'));
      await tester.pumpWidget(_app('en', Brightness.light, bridge, ask(c)));
      await askIt(tester, 'what is the capital of France?');
      expect(find.text('Not covered yet'), findsOneWidget);
      expect(bridge.privatePrompts, isEmpty);
      // R8.27: the not-covered card offers the visit pack, starting from her question.
      await tester.ensureVisible(find.text('Prepare a visit pack'));
      await tester.tap(find.text('Prepare a visit pack'));
      await tester.pumpAndSettle();
      expect(find.byType(VisitSummaryScreen), findsOneWidget);
      expect(find.text('what is the capital of France?'), findsOneWidget, reason: 'her question is the worry');
    });

    for (final (lang, b) in [
      ('en', Brightness.light),
      ('ar', Brightness.dark),
      ('ar', Brightness.light),
    ]) {
      testWidgets('screenshot: answered ($lang, ${b.name})', (tester) async {
        await _size(tester);
        final arabic = lang == 'ar';
        final bridge = FakeAssistant(
          privateReply: arabic
              ? 'قد يساعد وضع الحرارة على أسفل البطن وممارسة الرياضة في تخفيف ألم الدورة [1]. راجعي الطبيبة إذا كان الألم شديداً [2].'
              : 'Heat on the lower belly and exercise may ease period pain [1]. See a doctor if the pain is severe [2].',
        );
        final c = await _controller(_ttc(lang));
        await tester.pumpWidget(_app(lang, b, bridge, ask(c)));
        await askIt(
          tester,
          arabic
              ? 'ما الذي يخفف مغص الدورة؟'
              : 'what helps with period cramps?',
        );
        expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
        await _shoot('${lang}_${b.name}_ask_answer');
      });
    }
  });

  group('Ask femio: "do I have X?" (R7.14)', () {
    for (final (lang, b) in [
      ('en', Brightness.light),
      ('ar', Brightness.dark),
      ('ar', Brightness.light),
    ]) {
      testWidgets('screenshot: only a clinician can tell ($lang, ${b.name})', (tester) async {
        await _size(tester);
        final arabic = lang == 'ar';
        final bridge = FakeAssistant();
        final c = await _controller(_ttc(lang));
        await tester.pumpWidget(
          _app(lang, b, bridge, AskScreen(controller: c, registry: _registry, today: _today)),
        );
        await tester.enterText(find.byType(TextField).first, arabic ? 'هل عندي تكيس مبايض؟' : 'Do I have PCOS?');
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();
        expect(
          find.text(arabic ? 'الطبيب وحده يستطيع أن يحدّد' : 'Only a clinician can tell'),
          findsOneWidget,
        );
        expect(find.text('Not covered yet'), findsNothing);
        await _shoot('${lang}_${b.name}_ask_diagnosis');
      });
    }
  });

  group('Say it in your words', () {
    for (final (lang, b) in [
      ('en', Brightness.light),
      ('ar', Brightness.dark),
      ('ar', Brightness.light),
    ]) {
      testWidgets('a sentence becomes log entries ($lang, ${b.name})', (
        tester,
      ) async {
        await _size(tester);
        final bridge = FakeAssistant(
          privateReply: '{"terms":["bloating"],"flow":null,"opk":null}',
        );
        final c = await _controller(_ttc(lang));
        await tester.pumpWidget(
          _app(
            lang,
            b,
            bridge,
            Scaffold(
              body: SayItSheet(controller: c, date: _today, today: _today),
            ),
          ),
        );
        await tester.enterText(
          find.byType(TextField),
          lang == 'ar'
              ? 'عندي مغص جامد وصداع وتعبانة'
              : 'Bad cramps and a headache today, so tired',
        );
        await tester.tap(find.byIcon(Icons.auto_awesome_rounded));
        await tester.pumpAndSettle();
        await _shoot('${lang}_${b.name}_say_it');
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();
        expect(
          c.profile!.logs[_today]!.terms,
          containsAll(['cramps', 'headache', 'fatigue', 'bloating']),
        );
      });
    }

    testWidgets('a danger sign shows the help card', (tester) async {
      final c = await _controller(_ttc('en'));
      await tester.pumpWidget(
        _app(
          'en',
          Brightness.light,
          FakeAssistant(),
          Scaffold(
            body: SayItSheet(controller: c, date: _today, today: _today),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'chest pain and cramps');
      await tester.tap(find.byIcon(Icons.auto_awesome_rounded));
      await tester.pumpAndSettle();
      expect(find.text('This may need urgent care'), findsOneWidget);
    });
  });

  group('For you tips', () {
    for (final (lang, b) in [
      ('en', Brightness.light),
      ('ar', Brightness.dark),
      ('ar', Brightness.light),
    ]) {
      testWidgets(
        'reviewed tips that fit her, each with a source ($lang, ${b.name})',
        (tester) async {
          await _size(tester);
          final bridge = FakeAssistant(
            privateReply: '{"ids":["folicAcidBeforePregnancy"]}',
          );
          final c = await _controller(_ttc(lang));
          await tester.pumpWidget(
            _app(
              lang,
              b,
              bridge,
              Scaffold(
                body: ListView(
                  children: [TipsCard(controller: c, today: _today)],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await _shoot('${lang}_${b.name}_tips_card');
          if (lang == 'en') {
            expect(find.text('For you'), findsOneWidget);
            expect(find.textContaining('Source: '), findsNWidgets(3));
            // Nano's choice comes first; its prompt carried only bands, never dates.
            final folic = tester.getTopLeft(
              find.textContaining('Folic acid, a B vitamin'),
            );
            expect(
              folic.dy,
              lessThan(
                tester.getTopLeft(find.textContaining('Source: ').last).dy,
              ),
            );
            expect(bridge.privatePrompts.single, isNot(contains('2026')));
          }
        },
      );
    }

    testWidgets(
      'with Cloud boost and no Nano, the cloud sees the whole stage list, not her fit',
      (tester) async {
        final bridge = FakeAssistant(
          nano: false,
          hybridReply: '{"ids":["ttcAgeSixMonths"]}',
        );
        final c = await _controller(_ttc('en'), boost: true);
        await tester.pumpWidget(
          _app(
            'en',
            Brightness.light,
            bridge,
            Scaffold(
              body: ListView(
                children: [TipsCard(controller: c, today: _today)],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(bridge.sentToCloud.single, contains('- testingTooEarly:'));
        expect(bridge.sentToCloud.single, isNot(contains('2026')));
        expect(
          find.textContaining('Put in order with Cloud boost'),
          findsOneWidget,
        );
      },
    );
  });

  group('What the AI can see', () {
    for (final (lang, b) in [
      ('en', Brightness.light),
      ('en', Brightness.dark),
      ('ar', Brightness.light),
      ('ar', Brightness.dark),
    ]) {
      testWidgets('one card per use, from the policy table ($lang, ${b.name})', (tester) async {
        await _size(tester);
        final c = await _controller(_ttc(lang));
        await tester.pumpWidget(_app(lang, b, FakeAssistant(), AiSeesScreen(controller: c)));
        await tester.pumpAndSettle();
        await _shoot('${lang}_${b.name}_ai_sees');
        final l = await L10n.delegate.load(Locale(lang));
        for (final MapEntry(key: use, value: policy) in usePolicies.entries) {
          final name = find.text(aiUseName(l, use));
          await tester.scrollUntilVisible(name, 200);
          expect(name, findsOneWidget, reason: '$use');
          for (final input in policy.sees) {
            expect(find.text(aiInputText(l, input), skipOffstage: false), findsWidgets, reason: '$use $input');
          }
        }
      });
    }

    testWidgets('her master switch off says none of it runs', (tester) async {
      await _size(tester);
      final p = _ttc('en');
      final c = await _controller(p.copyWith(settings: p.settings.copyWith(assistantOn: false)));
      await tester.pumpWidget(_app('en', Brightness.light, FakeAssistant(), AiSeesScreen(controller: c)));
      await tester.pumpAndSettle();
      expect(find.text('The assistant is off, so none of these run.'), findsOneWidget);
    });
  });

  group('Visit summary', () {
    for (final (lang, b) in [
      ('en', Brightness.light),
      ('ar', Brightness.dark),
      ('ar', Brightness.light),
    ]) {
      testWidgets(
        'counts her log and lists reviewed questions ($lang, ${b.name})',
        (tester) async {
          await _size(tester);
          final bridge = FakeAssistant(
            privateReply: '{"ids":["painfulPeriods","folicAcid"]}',
          );
          final c = await _controller(_ttc(lang));
          await tester.pumpWidget(
            _app(
              lang,
              b,
              bridge,
              VisitSummaryScreen(controller: c, today: _today),
            ),
          );
          await tester.pumpAndSettle();
          await _shoot('${lang}_${b.name}_visit_summary');
          if (lang == 'en') {
            expect(find.text('3 cycles logged: 28 to 32 days'), findsOneWidget);
            // The on-device order is applied: pain first, then folic acid. The worry box
            // (R10.2) sits above the list, so scroll to it first.
            await tester.dragUntilVisible(
              find.text('Should I be taking folic acid now?'),
              find.byType(ListView),
              const Offset(0, -300),
            );
            await tester.pumpAndSettle();
            final pain = tester.getTopLeft(
              find.text('My period pain affects my days. What can help?'),
            );
            final folic = tester.getTopLeft(
              find.text('Should I be taking folic acid now?'),
            );
            expect(pain.dy, lessThan(folic.dy));
          }
        },
      );
    }
  });

  /// Taps a widget found by [f] after scrolling it into view.
  Future<void> tapVisible(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'one wizard turns AI and Cloud boost on and off, each with a confirmation and a sealed receipt',
    (tester) async {
      await _size(tester);
      final c = await _controller(_ttc('en'));
      await tester.pumpWidget(
        _app(
          'en',
          Brightness.light,
          FakeAssistant(nano: false, cloud: true),
          AssistantSettingsScreen(controller: c),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Not available on this phone'), findsOneWidget);
      expect(find.text('On, on this phone only. Your words and records are not sent.'), findsOneWidget);
      expect(find.byType(Switch), findsNothing, reason: 'no switch changes the AI without the wizard');
      await _shoot('en_light_assistant_settings');

      // Turn on Cloud boost for questions.
      await tester.tap(find.text('AI and Cloud boost'));
      await tester.pumpAndSettle();
      expect(find.text('Step 1 of 3'), findsOneWidget);
      await _shoot('en_light_ai_wizard_1');
      await tapVisible(tester, find.text('AI on this phone, plus Cloud boost'));
      await tapVisible(tester, find.widgetWithText(FilledButton, 'Next'));
      expect(find.text('What may be sent'), findsOneWidget);
      expect(find.text('Trying to conceive'), findsOneWidget, reason: 'her own bands are shown');
      await _shoot('en_light_ai_wizard_2_cloud');
      await tapVisible(tester, find.widgetWithText(FilledButton, 'Next'));
      final confirm = find.widgetWithText(FilledButton, 'Confirm my choice');
      expect(tester.widget<FilledButton>(confirm).onPressed, isNull, reason: 'nothing is pre-ticked');
      await tapVisible(tester, find.textContaining('wellness information from trusted sources'));
      await tapVisible(tester, find.text("I have read femio's privacy notice."));
      await tapVisible(tester, find.textContaining('may send a general question'));
      expect(tester.widget<FilledButton>(confirm).onPressed, isNull, reason: 'the Cloud boost statement is still unticked');
      await tapVisible(tester, find.textContaining('I understand what Cloud boost may send'));
      await _shoot('en_light_ai_wizard_3_cloud');
      await tapVisible(tester, confirm);
      expect(find.text('Confirm this change?'), findsOneWidget);
      expect(c.profile!.settings.cloudBoost, isFalse, reason: 'nothing changes before the dialog is confirmed');
      await tester.tap(find.widgetWithText(FilledButton, 'Confirm'));
      await tester.pumpAndSettle();
      var consent = c.profile!.settings.cloud;
      expect(consent.allows(CloudPurpose.questions), isTrue);
      expect(consent.allows(CloudPurpose.tips), isFalse, reason: 'each purpose is its own choice');
      expect(consent.current!.ai, isTrue);
      expect(consent.current!.acks, [AiAck.wellness, AiAck.notice, AiAck.cloud]);
      expect(consent.current!.version, cloudConsentVersion);
      expect(DateTime.tryParse(consent.grantedAt!), isNotNull, reason: 'the receipt is dated');
      expect(consent.sealIntact, isTrue);
      expect(find.textContaining('On, with Cloud boost for: General questions'), findsOneWidget);
      expect(find.text('Check Cloud boost'), findsNothing, reason: 'the fake bridge cannot run the check');

      // Step down to on-phone AI: a withdrawal, so no boxes, one confirmation (PRIV-N3-1).
      await tester.tap(find.text('AI and Cloud boost'));
      await tester.pumpAndSettle();
      await tapVisible(tester, find.text('AI on this phone only'));
      await tapVisible(tester, find.widgetWithText(FilledButton, 'Next'));
      await tapVisible(tester, find.widgetWithText(FilledButton, 'Next'));
      expect(find.byType(CheckboxListTile), findsNothing, reason: 'stepping down asks for no ticks');
      expect(find.textContaining('using less of the AI is always one step'), findsOneWidget);
      await tapVisible(tester, find.widgetWithText(FilledButton, 'Confirm my choice'));
      await tester.tap(find.widgetWithText(FilledButton, 'Confirm'));
      await tester.pumpAndSettle();
      expect(c.profile!.settings.assistantOn, isTrue);
      expect(c.profile!.settings.cloudBoost, isFalse);
      expect(c.profile!.settings.cloud.current!.acks, isEmpty);

      // Turn the AI off: no boxes, one confirmation.
      await tester.tap(find.text('AI and Cloud boost'));
      await tester.pumpAndSettle();
      await tapVisible(tester, find.text('No AI'));
      await tapVisible(tester, find.widgetWithText(FilledButton, 'Next'));
      await tapVisible(tester, find.widgetWithText(FilledButton, 'Next'));
      expect(find.byType(CheckboxListTile), findsNothing, reason: 'withdrawing is as easy as agreeing');
      await tapVisible(tester, find.widgetWithText(FilledButton, 'Confirm my choice'));
      await tester.tap(find.widgetWithText(FilledButton, 'Confirm'));
      await tester.pumpAndSettle();
      consent = c.profile!.settings.cloud;
      expect(c.profile!.settings.assistantOn, isFalse);
      expect(c.profile!.settings.cloudBoost, isFalse);
      expect(consent.current!.isWithdrawal, isTrue);
      expect(consent.current!.ai, isFalse);
      expect(consent.log, hasLength(3));
      expect(consent.log.last.prev, consent.log[1].seal);

      // The record shows both receipts, sealed.
      await tapVisible(tester, find.text('My AI choices'));
      expect(find.text('Seals check out: every receipt matches the seal written with it.'), findsOneWidget);
      expect(find.text('AI on this phone: Off'), findsOneWidget);
      expect(find.text('AI on this phone: On'), findsNWidgets(2));
      expect(find.text('Cloud boost: General questions'), findsOneWidget);
      await _shoot('en_light_ai_choices_record');
    },
  );

  test('the shared copy carries every receipt with its full seal', () {
    final l = lookupL10n(const Locale('en'));
    final consent = const CloudConsent()
        .choose(ai: true, purposes: const {CloudPurpose.tips}, at: '2026-11-27T09:00:00Z', lang: 'en', acks: const [AiAck.cloud]);
    final text = receiptsAsText(l, consent, 'en');
    expect(text, contains(consent.current!.seal!));
    expect(text, contains('2026-11-27T09:00:00Z'));
    expect(text, contains('Cloud boost: Tips from four broad facts'));
  });

  for (final (lang, b) in [('ar', Brightness.dark), ('ar', Brightness.light), ('en', Brightness.light)]) {
    testWidgets('screenshot: Cloud boost consent ($lang, ${b.name})', (
      tester,
    ) async {
      await _size(tester);
      final l = lookupL10n(Locale(lang));
      final c = await _controller(_ttc(lang));
      await tester.pumpWidget(
        _app(
          lang,
          b,
          FakeAssistant(nano: false, cloud: true),
          CloudBoostScreen(controller: c, today: _today),
        ),
      );
      await tester.pumpAndSettle();
      await _shoot('${lang}_${b.name}_cloud_boost_consent');
      // Step 2: her own four values and what may be sent; step 3: the boxes, ticked by her.
      await tester.tap(find.widgetWithText(FilledButton, l.aiWizardNext));
      await tester.pumpAndSettle();
      await _shoot('${lang}_${b.name}_cloud_boost_sends');
      await tester.tap(find.widgetWithText(FilledButton, l.aiWizardNext));
      await tester.pumpAndSettle();
      for (final text in [l.aiAckWellness, l.aiAckNotice, l.boostAgreeQuestions]) {
        await tester.ensureVisible(find.text(text));
        await tester.pumpAndSettle();
        await tester.tap(find.text(text));
        await tester.pumpAndSettle();
      }
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 2000));
      await tester.pumpAndSettle();
      await _shoot('${lang}_${b.name}_cloud_boost_ticks');
    });
  }
}
