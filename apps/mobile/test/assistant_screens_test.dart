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
import 'package:femio/domain/assistant/cloud_prompt.dart';
import 'package:femio/domain/assistant/source_registry.dart';
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
  Future<String?> runPrivate(String prompt) async {
    privatePrompts.add(prompt);
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
  if (boost) p = p.copyWith(settings: p.settings.copyWith(cloudBoost: true));
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
              body: SayItSheet(controller: c, date: _today),
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
            body: SayItSheet(controller: c, date: _today),
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
            // The on-device order is applied: pain first, then folic acid.
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

  testWidgets(
    'settings shows what runs where, and Cloud boost needs the consent screen',
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
      expect(
        find.textContaining('Not available on this phone'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Off. Everything is done on this phone'),
        findsOneWidget,
      );
      await _shoot('en_light_assistant_settings');
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(
        c.profile!.settings.cloudBoost,
        isFalse,
        reason: 'the switch opens the consent screen, it does not agree',
      );
      expect(find.text('What may be sent'), findsOneWidget);
      expect(find.text('Trying to conceive'), findsOneWidget);
      await _shoot('en_light_cloud_boost_consent');
      await tester.scrollUntilVisible(find.text('Turn on Cloud boost'), 200);
      await tester.tap(find.text('Turn on Cloud boost'));
      await tester.pumpAndSettle();
      expect(c.profile!.settings.cloudBoost, isTrue);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(
        c.profile!.settings.cloudBoost,
        isFalse,
        reason: 'turning it off is one tap',
      );
    },
  );

  for (final (lang, b) in [('ar', Brightness.dark), ('ar', Brightness.light)]) {
    testWidgets('screenshot: Cloud boost consent ($lang, ${b.name})', (
      tester,
    ) async {
      await _size(tester);
      final c = await _controller(_ttc(lang));
      await tester.pumpWidget(
        _app(
          lang,
          b,
          FakeAssistant(nano: false),
          CloudBoostScreen(controller: c, today: _today),
        ),
      );
      await tester.pumpAndSettle();
      await _shoot('${lang}_${b.name}_cloud_boost_consent');
    });
  }
}
