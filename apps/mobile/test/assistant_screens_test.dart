// Widget tests and screenshots for the assistant screens (ADR-078, R7.3, R7.4).
//
// A fake bridge stands in for Firebase, so the tests prove what the screens do with each
// answer the bridge can give: the safety rules stop a question before any call, a personal
// question is rewritten and shown before it leaves, an answer without a trusted source is
// hidden, and say-it entries reach the record. Screenshots at 390×844 (light, dark, Arabic)
// are written to testing-results/2026-11-24-r7-assistant/ under `--update-goldens` only.

import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/assistant_channel.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/assistant/redaction.dart';
import 'package:femio/domain/assistant/trusted_sources.dart';
import 'package:femio/features/assistant/ask_screen.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:femio/features/assistant/assistant_settings_screen.dart';
import 'package:femio/features/assistant/say_it_sheet.dart';
import 'package:femio/features/assistant/visit_summary_screen.dart';
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
  FakeAssistant({this.nano = true, this.cloud = true, this.privateReply, this.answer});
  final bool nano;
  final bool cloud;
  String? privateReply;
  GroundedAnswer? answer;
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
  Future<GroundedAnswer?> askGrounded(CloudSafeText question, {required String instruction}) async {
    sentToCloud.add(question.value);
    return answer;
  }

  @override
  Future<bool> openSource(String url) async => true;
}

const _nhsAnswer = GroundedAnswer(
  text:
      'Period pain is common. Heat on your tummy, gentle exercise and over-the-counter pain relief can help. '
      'See a GP if the pain is severe or stops you doing everyday things.',
  sources: [
    WebSource(title: 'nhs.uk', uri: 'https://www.nhs.uk/conditions/period-pain/'),
    WebSource(title: 'acog.org', uri: 'https://www.acog.org/womens-health/faqs/dysmenorrhea-painful-periods'),
    WebSource(title: 'healthblog.example', uri: 'https://healthblog.example/cramps'),
  ],
  suggestionsHtml: null,
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
  await load('MaterialIcons', ['$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf']);
}

Widget _app(String locale, Brightness b, AssistantBridge bridge, Widget home) => MaterialApp(
  theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
  locale: Locale(locale),
  supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr'), Locale('es')],
  localizationsDelegates: const [
    L10n.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  builder: (context, child) => AssistantScope(bridge: bridge, child: child!),
  home: home,
);

Future<FemioController> _controller(Profile p) async {
  final c = FemioController(MemoryStore(p));
  await c.load();
  return c;
}

Profile _ttc(String lang) {
  var p = Profile(
    goal: Goal.ttc,
    locale: lang,
    birthYear: 1990,
    periodStarts: const ['2026-08-01', '2026-08-30', '2026-10-01', '2026-10-29'],
    tryingFor: TryingFor.sixTo12,
  );
  for (final d in ['2026-10-29', '2026-10-30', '2026-10-31']) {
    p = p.withDayLog(d, DayLog(flow: d == '2026-10-29' ? 'heavy' : 'medium', terms: const ['cramps', 'fatigue']));
  }
  return p.withDayLog('2026-11-12', const DayLog(opk: 'positive', terms: ['bloating']));
}

Future<void> _size(WidgetTester tester) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

Future<void> _shoot(String name) async {
  if (!autoUpdateGoldenFiles) return;
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/$name.png'));
}

void main() {
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  group('Ask femio', () {
    testWidgets('a birth-control question gets the fixed answer and never reaches a model', (tester) async {
      final bridge = FakeAssistant(answer: _nhsAnswer);
      final c = await _controller(_ttc('en'));
      await tester.pumpWidget(_app('en', Brightness.light, bridge, AskScreen(controller: c)));
      await tester.enterText(find.byType(TextField), 'which are the safe days to avoid pregnancy?');
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();
      expect(find.textContaining('not a way to avoid pregnancy'), findsOneWidget);
      expect(bridge.sentToCloud, isEmpty);
      expect(bridge.privatePrompts, isEmpty);
    });

    testWidgets('a personal question is rewritten on the phone and shown before it is sent', (tester) async {
      final bridge = FakeAssistant(privateReply: 'What helps with period cramps?', answer: _nhsAnswer);
      final c = await _controller(_ttc('en'));
      await tester.pumpWidget(_app('en', Brightness.light, bridge, AskScreen(controller: c)));
      await tester.enterText(find.byType(TextField), 'I am 34 and my cramps are awful, what can I do?');
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();
      expect(find.text('What helps with period cramps?'), findsOneWidget);
      expect(bridge.sentToCloud, isEmpty, reason: 'nothing leaves before she approves');
      await tester.tap(find.byIcon(Icons.travel_explore_rounded));
      await tester.pumpAndSettle();
      expect(bridge.sentToCloud, ['What helps with period cramps?']);
      expect(find.textContaining('Heat on your tummy'), findsOneWidget);
      expect(find.text('Trusted source'), findsNWidgets(2));
      expect(find.text("Not on femio's trusted list"), findsOneWidget);
    });

    testWidgets('she cannot send a question that is still about her', (tester) async {
      final bridge = FakeAssistant(nano: false, answer: _nhsAnswer);
      final c = await _controller(_ttc('en'));
      await tester.pumpWidget(_app('en', Brightness.light, bridge, AskScreen(controller: c)));
      await tester.enterText(find.byType(TextField), 'my period is late');
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.travel_explore_rounded));
      await tester.pumpAndSettle();
      expect(bridge.sentToCloud, isEmpty);
      expect(find.textContaining('This still mentions you'), findsOneWidget);
    });

    testWidgets('an answer with no trusted source is not shown', (tester) async {
      final bridge = FakeAssistant(
        answer: const GroundedAnswer(
          text: 'Some blog says drink celery juice.',
          sources: [WebSource(title: 'healthblog.example', uri: 'https://healthblog.example/x')],
          suggestionsHtml: null,
        ),
      );
      final c = await _controller(_ttc('en'));
      await tester.pumpWidget(_app('en', Brightness.light, bridge, AskScreen(controller: c)));
      await tester.enterText(find.byType(TextField), 'what helps with bloating?');
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.travel_explore_rounded));
      await tester.pumpAndSettle();
      expect(find.textContaining('celery'), findsNothing);
      expect(find.textContaining('no answer from a trusted health source'), findsOneWidget);
    });

    for (final (lang, b) in [('en', Brightness.light), ('ar', Brightness.dark), ('ar', Brightness.light)]) {
      testWidgets('screenshot: answered ($lang, ${b.name})', (tester) async {
        await _size(tester);
        final arabic = lang == 'ar';
        final bridge = FakeAssistant(
          answer: arabic
              ? const GroundedAnswer(
                  text:
                      'ألم الدورة شائع. قد تساعد الحرارة على البطن والحركة الخفيفة ومسكنات الألم المتاحة دون وصفة. '
                      'راجعي الطبيبة إذا كان الألم شديداً أو يمنعكِ من أنشطتكِ اليومية.',
                  sources: [
                    WebSource(title: 'who.int', uri: 'https://www.who.int/'),
                    WebSource(title: 'nhs.uk', uri: 'https://www.nhs.uk/conditions/period-pain/'),
                  ],
                  suggestionsHtml: null,
                )
              : _nhsAnswer,
        );
        final c = await _controller(_ttc(lang));
        await tester.pumpWidget(_app(lang, b, bridge, AskScreen(controller: c)));
        await tester.enterText(find.byType(TextField), arabic ? 'ما الذي يخفف مغص الدورة؟' : 'what helps with period cramps?');
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();
        await _shoot('${lang}_${b.name}_ask_confirm');
        await tester.tap(find.byIcon(Icons.travel_explore_rounded));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
        await _shoot('${lang}_${b.name}_ask_answer');
      });
    }
  });

  group('Say it in your words', () {
    for (final (lang, b) in [('en', Brightness.light), ('ar', Brightness.dark), ('ar', Brightness.light)]) {
      testWidgets('a sentence becomes log entries ($lang, ${b.name})', (tester) async {
        await _size(tester);
        final bridge = FakeAssistant(privateReply: '{"terms":["bloating"],"flow":null,"opk":null}');
        final c = await _controller(_ttc(lang));
        await tester.pumpWidget(_app(lang, b, bridge, Scaffold(body: SayItSheet(controller: c, date: _today))));
        await tester.enterText(
          find.byType(TextField),
          lang == 'ar' ? 'عندي مغص جامد وصداع وتعبانة' : 'Bad cramps and a headache today, so tired',
        );
        await tester.tap(find.byIcon(Icons.auto_awesome_rounded));
        await tester.pumpAndSettle();
        await _shoot('${lang}_${b.name}_say_it');
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();
        expect(c.profile!.logs[_today]!.terms, containsAll(['cramps', 'headache', 'fatigue', 'bloating']));
      });
    }

    testWidgets('a danger sign shows the help card', (tester) async {
      final c = await _controller(_ttc('en'));
      await tester.pumpWidget(
        _app('en', Brightness.light, FakeAssistant(), Scaffold(body: SayItSheet(controller: c, date: _today))),
      );
      await tester.enterText(find.byType(TextField), 'chest pain and cramps');
      await tester.tap(find.byIcon(Icons.auto_awesome_rounded));
      await tester.pumpAndSettle();
      expect(find.text('This may need urgent care'), findsOneWidget);
    });
  });

  group('Visit summary', () {
    for (final (lang, b) in [('en', Brightness.light), ('ar', Brightness.dark), ('ar', Brightness.light)]) {
      testWidgets('counts her log and lists reviewed questions ($lang, ${b.name})', (tester) async {
        await _size(tester);
        final bridge = FakeAssistant(privateReply: '{"ids":["painfulPeriods","folicAcid"]}');
        final c = await _controller(_ttc(lang));
        await tester.pumpWidget(_app(lang, b, bridge, VisitSummaryScreen(controller: c, today: _today)));
        await tester.pumpAndSettle();
        await _shoot('${lang}_${b.name}_visit_summary');
        if (lang == 'en') {
          expect(find.text('3 cycles logged: 28 to 32 days'), findsOneWidget);
          // The on-device order is applied: pain first, then folic acid.
          final pain = tester.getTopLeft(find.text('My period pain affects my days. What can help?'));
          final folic = tester.getTopLeft(find.text('Should I be taking folic acid now?'));
          expect(pain.dy, lessThan(folic.dy));
        }
      });
    }
  });

  testWidgets('settings shows what runs where', (tester) async {
    await _size(tester);
    await tester.pumpWidget(
      _app('en', Brightness.light, FakeAssistant(nano: false, cloud: true), const AssistantSettingsScreen()),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Not available on this phone'), findsOneWidget);
    expect(find.textContaining('Only general questions you approve'), findsOneWidget);
    await _shoot('en_light_assistant_settings');
  });
}
