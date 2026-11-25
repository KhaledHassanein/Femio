// Screenshots of the CURRENT app for side-by-side comparison with the Stitch design mockups.
//
// Why it exists: the design review needs the real screens, rendered from the real widgets with
// synthetic data (dates in 2026, no person), in the same three variants as the mockups: English
// light, Arabic light, Arabic dark, at a 390x844 phone with device pixel ratio 2. Files are
// written only under `--update-goldens`; a plain run just builds each screen. Helpers are
// copied from assistant_screens_test.dart and store_screenshots_test.dart on purpose.

import 'dart:convert';
import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/assistant_channel.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/assistant/cloud_prompt.dart';
import 'package:femio/domain/assistant/private_prompt.dart';
import 'package:femio/domain/assistant/source_registry.dart';
import 'package:femio/features/assistant/ask_screen.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:femio/features/assistant/say_it_sheet.dart';
import 'package:femio/features/assistant/visit_summary_screen.dart';
import 'package:femio/features/help/help_now_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Relative to this file (matchesGoldenFile resolves against the test's directory).
const _out = '../../../testing-results/2026-11-24-stitch-compare/app';
const _today = '2026-11-24';

const _variants = [
  ('en', Brightness.light),
  ('ar', Brightness.light),
  ('ar', Brightness.dark),
];

/// Bridge with a canned private reply; nothing leaves the test.
class _FakeAssistant implements AssistantBridge {
  _FakeAssistant({this.privateReply});
  final String? privateReply;
  @override
  Future<AssistantStatus> status() async =>
      const AssistantStatus(configured: true, onDevice: OnDeviceModel.available);
  @override
  Future<bool> downloadModel() async => true;
  @override
  Future<String?> runPrivate(PrivatePrompt prompt) async => privateReply;
  @override
  Future<HybridReply?> runHybrid(CloudPrompt prompt) async => null;
  @override
  Future<bool> openSource(String url) async => true;
}

final _registry = SourceRegistry.fromJson(
  jsonDecode(File('assets/trusted_sources/registry.json').readAsStringSync()) as Map<String, Object?>,
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

/// A bare MaterialApp around one widget, for screens that are not reached through FemioApp.
Widget _wrap(String lang, Brightness b, AssistantBridge bridge, Widget home) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
      locale: Locale(lang),
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

void _size(WidgetTester tester, Brightness b) {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  tester.platformDispatcher.platformBrightnessTestValue = b;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAllTestValues);
}

Future<void> _shoot(String slug, String lang, Brightness b, {String suffix = ''}) async {
  if (!autoUpdateGoldenFiles) return;
  await expectLater(find.byType(MaterialApp).first, matchesGoldenFile('$_out/${slug}_${lang}_${b.name}$suffix.png'));
}

Future<FemioController> _controller(Profile p, String lang) async {
  final c = FemioController(MemoryStore(p), initialLocale: lang);
  await c.load();
  return c;
}

AppSettings _settings(String lang) => AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false);

/// Trying to conceive with irregular cycles (about 36 to 45 days apart) and a few logs.
Profile _ttcPcos(String lang) {
  var p = Profile(
    goal: Goal.ttc,
    locale: lang,
    birthYear: 1994,
    periodStarts: const ['2026-05-02', '2026-06-17', '2026-07-24', '2026-09-05', '2026-10-14'],
    irregular: true,
    tryingFor: TryingFor.sixTo12,
    settings: _settings(lang),
  );
  for (final d in ['2026-10-14', '2026-10-15', '2026-10-16']) {
    p = p.withDayLog(d, DayLog(flow: d == '2026-10-14' ? 'heavy' : 'medium', terms: const ['cramps', 'fatigue']));
  }
  return p.withDayLog('2026-11-18', const DayLog(terms: ['bloating']));
}

/// Same as the assistant tests: three regular cycles, a positive OPK, a few symptoms.
Profile _ttcRegular(String lang) {
  var p = Profile(
    goal: Goal.ttc,
    locale: lang,
    birthYear: 1990,
    periodStarts: const ['2026-08-01', '2026-08-30', '2026-10-01', '2026-10-29'],
    tryingFor: TryingFor.sixTo12,
    settings: _settings(lang),
  );
  for (final d in ['2026-10-29', '2026-10-30', '2026-10-31']) {
    p = p.withDayLog(d, DayLog(flow: d == '2026-10-29' ? 'heavy' : 'medium', terms: const ['cramps', 'fatigue']));
  }
  return p.withDayLog('2026-11-12', const DayLog(opk: 'positive', terms: ['bloating']));
}

Profile _pregnant(String lang) =>
    Profile(goal: Goal.pregnant, locale: lang, birthYear: 1993, edd: '2027-03-10', settings: _settings(lang));

Future<void> _openTab(WidgetTester tester, int index) async {
  tester.widget<NavigationBar>(find.byType(NavigationBar)).onDestinationSelected!(index);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  for (final (lang, b) in _variants) {
    final tag = '$lang ${b.name}';

    testWidgets('1 onboarding ($tag)', (tester) async {
      _size(tester, b);
      final c = FemioController(MemoryStore(), initialLocale: lang);
      await c.load();
      await tester.pumpWidget(FemioApp(controller: c, today: _today));
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsNothing);
      await _shoot('1_onboarding', lang, b);
    });

    testWidgets('2 today ttc pcos ($tag)', (tester) async {
      _size(tester, b);
      final c = await _controller(_ttcPcos(lang), lang);
      await tester.pumpWidget(FemioApp(controller: c, today: _today));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      await _shoot('2_today_ttc_pcos', lang, b);
      final position = tester.state<ScrollableState>(find.byType(Scrollable).first).position;
      position.jumpTo(position.maxScrollExtent < 640 ? position.maxScrollExtent : 640);
      await tester.pumpAndSettle();
      await _shoot('2_today_ttc_pcos', lang, b, suffix: '_b');
    });

    testWidgets('3 today pregnancy ($tag)', (tester) async {
      _size(tester, b);
      final c = await _controller(_pregnant(lang), lang);
      await tester.pumpWidget(FemioApp(controller: c, today: _today));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      await _shoot('3_today_pregnancy', lang, b);
    });

    testWidgets('4 say it to log ($tag)', (tester) async {
      _size(tester, b);
      final bridge = _FakeAssistant(privateReply: '{"terms":["bloating"],"flow":null,"opk":null}');
      final c = await _controller(_ttcRegular(lang), lang);
      await tester.pumpWidget(_wrap(lang, b, bridge, Scaffold(body: SayItSheet(controller: c, date: _today, today: _today))));
      await tester.enterText(
        find.byType(TextField),
        lang == 'ar' ? 'عندي مغص جامد وصداع وتعبانة' : 'Bad cramps and a headache today, so tired',
      );
      await tester.tap(find.byIcon(Icons.auto_awesome_rounded));
      await tester.pumpAndSettle();
      await _shoot('4_say_it_to_log', lang, b);
    });

    testWidgets('5 ask femio ($tag)', (tester) async {
      _size(tester, b);
      final arabic = lang == 'ar';
      final bridge = _FakeAssistant(
        privateReply: arabic
            ? 'قد يساعد وضع الحرارة على أسفل البطن وممارسة الرياضة في تخفيف ألم الدورة [1]. راجعي الطبيبة إذا كان الألم شديداً [2].'
            : 'Heat on the lower belly and exercise may ease period pain [1]. See a doctor if the pain is severe [2].',
      );
      final c = await _controller(_ttcRegular(lang), lang);
      await tester.pumpWidget(_wrap(lang, b, bridge, AskScreen(controller: c, registry: _registry, today: _today)));
      await tester.enterText(find.byType(TextField).first, arabic ? 'ما الذي يخفف مغص الدورة؟' : 'what helps with period cramps?');
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
      await _shoot('5_ask_femio', lang, b);
    });

    testWidgets('6 calendar ($tag)', (tester) async {
      _size(tester, b);
      final c = await _controller(_ttcRegular(lang), lang);
      await tester.pumpWidget(FemioApp(controller: c, today: _today));
      await tester.pumpAndSettle();
      await _openTab(tester, 1);
      expect(find.text(lookupL10n(Locale(lang)).calendarTitle), findsWidgets);
      await _shoot('6_calendar', lang, b);
    });

    testWidgets('8 doctor visit pack ($tag)', (tester) async {
      _size(tester, b);
      final bridge = _FakeAssistant(privateReply: '{"ids":["painfulPeriods","folicAcid"]}');
      final c = await _controller(_ttcRegular(lang), lang);
      await tester.pumpWidget(_wrap(lang, b, bridge, VisitSummaryScreen(controller: c, today: _today)));
      await tester.pumpAndSettle();
      await _shoot('8_doctor_visit_pack', lang, b);
    });

    testWidgets('9 help now ($tag)', (tester) async {
      _size(tester, b);
      await tester.pumpWidget(_wrap(lang, b, _FakeAssistant(), const HelpNowScreen()));
      await tester.pumpAndSettle();
      await _shoot('9_help_now', lang, b);
    });
  }
}
