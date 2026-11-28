// Plain Google Play screenshots: four real app screens per language, full screen, with no
// caption, frame or marketing line (owner 2026-11-28). 1080×1920 PNG in
// docs/store/screenshots/plain/{en,ar,fr,es}/.
//
// Why it exists: the owner wanted the listing to show the app as it is. Rendering from the real
// widgets with synthetic data keeps the images in step with the code:
// `flutter test --update-goldens test/store_plain_screenshots_test.dart` rebuilds all sixteen;
// a plain run builds every screen, checks the expected text is on it, and writes nothing.
// The phone is laid out at 360×640 (9:16) because Play refuses images longer than 2:1.
// Data is synthetic: dates in 2026, no person.

import 'dart:convert';
import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/assistant_channel.dart';
import 'package:femio/data/library.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/assistant/cloud_prompt.dart';
import 'package:femio/domain/assistant/private_prompt.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:femio/features/learn/article_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Logical phone size and pixel ratio: 360×640 at 3x is Play's 1080×1920.
const _width = 360.0;
const _height = 640.0;
const _ratio = 3.0;

/// Output folder, relative to this test file.
const _out = '../../../docs/store/screenshots/plain';

/// The pretend "today" on every screen.
const _today = '2026-10-08';

const _langs = ['en', 'ar', 'fr', 'es'];

/// The four screens, in listing order.
const _slugs = ['01-today-ai', '02-calendar', '03-pregnancy', '04-learn'];

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

AppSettings _settings(String lang) => AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false);

/// The synthetic record behind screen [index].
Profile _profile(String lang, int index) {
  switch (index) {
    case 0: // trying to conceive, Gemini Nano ready: Today with the fertile range and the AI
      return Profile(
        goal: Goal.ttc,
        locale: lang,
        birthYear: 1993,
        periodStarts: const ['2026-08-30', '2026-09-27'],
        cycleLength: 28,
        settings: _settings(lang),
      );
    case 1: // calendar with logged days and the fertile range
      var p = Profile(
        goal: Goal.ttc,
        locale: lang,
        birthYear: 1992,
        periodStarts: const ['2026-10-01'],
        cycleLength: 28,
        settings: _settings(lang),
      );
      for (final d in ['2026-10-01', '2026-10-02', '2026-10-03', '2026-10-04']) {
        p = p.withDayLog(d, DayLog(flow: d == '2026-10-02' ? 'heavy' : 'medium', terms: d == '2026-10-01' ? const ['cramps'] : const []));
      }
      return p.withDayLog('2026-10-06', const DayLog(terms: ['happy']));
    default: // pregnancy, second trimester
      return Profile(goal: Goal.pregnant, locale: lang, birthYear: 1993, edd: '2027-02-10', settings: _settings(lang));
  }
}

/// One real guide from the bundled library, as she would open it.
Article _guide(String lang) {
  final all = jsonDecode(File('assets/content/$lang.json').readAsStringSync()) as List;
  final raw = Map<String, Object?>.from(all.firstWhere((a) => (a as Map)['slug'] == 'fertile-window-explained') as Map);
  return Article.fromJson(raw, lang);
}

Widget _app(String lang, Widget home) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FemioTheme.light(),
      locale: Locale(lang),
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: home,
    );

Future<void> _shoot(WidgetTester tester, String lang, int index) async {
  tester.view.physicalSize = const Size(_width * _ratio, _height * _ratio);
  tester.view.devicePixelRatio = _ratio;
  addTearDown(tester.view.reset);
  final l = lookupL10n(Locale(lang));

  if (index == 3) {
    await tester.pumpWidget(_app(lang, ArticleScreen(article: _guide(lang))));
    await tester.pumpAndSettle();
    expect(find.byType(ArticleScreen), findsOneWidget);
  } else {
    final c = FemioController(MemoryStore(_profile(lang, index)), initialLocale: lang);
    await c.load();
    await tester.pumpWidget(FemioApp(controller: c, today: _today, assistant: index == 0 ? const _NanoReady() : const OfflineAssistant()));
    await tester.pumpAndSettle();
    if (index == 1) {
      // The "+" takes bar slot 2; Calendar is slot 1.
      tester.widget<NavigationBar>(find.byType(NavigationBar)).onDestinationSelected!(1);
      await tester.pumpAndSettle();
      expect(find.text(l.calendarTitle), findsWidgets);
    }
    if (index == 0) expect(find.text(l.aiChipNano), findsOneWidget);
    if (index == 2) expect(find.text(l.trimesterLabel(2).toUpperCase()), findsOneWidget);
  }

  if (!autoUpdateGoldenFiles) return;
  await expectLater(find.byType(MaterialApp).first, matchesGoldenFile('$_out/$lang/${_slugs[index]}.png'));
}

/// A phone with Gemini Nano downloaded. Status only: no prompt runs.
class _NanoReady implements AssistantBridge {
  const _NanoReady();

  @override
  Future<AssistantStatus> status() async => const AssistantStatus(configured: true, onDevice: OnDeviceModel.available);

  @override
  Future<bool> downloadModel() async => true;

  @override
  Future<String?> runPrivate(PrivatePrompt prompt) async => null;

  @override
  Future<HybridReply?> runHybrid(CloudPrompt prompt) async => null;

  @override
  Future<bool> openSource(String url) async => false;
}

void main() {
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  for (final lang in _langs) {
    for (var i = 0; i < _slugs.length; i++) {
      testWidgets('plain store screenshot ${_slugs[i]} ($lang)', (tester) => _shoot(tester, lang, i));
    }
  }
}
