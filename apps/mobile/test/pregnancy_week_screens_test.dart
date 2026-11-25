// Screens for pregnancy by week (R8.6, R9.1): the "This week" card, the week strip and the
// week sheet, in English and Arabic, light and dark.
//
// Why it exists: the card shows the reviewed guide's own words, so the test reads the
// library from disk (already cached, so no file read races the test clock) and checks that
// each chip shows that section and nothing else. Screenshots land in
// testing-results/2026-11-25-r8-pregnancy-week/ under `--update-goldens`.

import 'dart:io';

import 'package:femio/data/library.dart';
import 'package:femio/data/week_guide.dart';
import 'package:femio/features/pregnancy/this_week_card.dart';
import 'package:femio/features/pregnancy/week_strip.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _out = '../../../testing-results/2026-11-25-r8-pregnancy-week';

/// Due 2027-02-10, so on this day she is 22w1d: the week 22 guide.
const _edd = '2027-02-10';
const _today = '2026-10-08';
const _week = 22;
const _totalDays = 155;

Future<String> _fromDisk(String path) => File(path).readAsString();

Future<void> _loadFonts() async {
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final f in files) {
      loader.addFont(Future.value(ByteData.view(File(f).readAsBytesSync().buffer)));
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
  final sdk = Platform.environment['FLUTTER_ROOT'];
  if (sdk != null) {
    final icons = File('$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
    if (icons.existsSync()) await load('MaterialIcons', [icons.path]);
  }
}

Widget _app(String locale, Brightness b, Widget body) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
      locale: Locale(locale),
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr'), Locale('es')],
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: SafeArea(child: body)),
    );

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

Future<void> _shoot(String name) async {
  if (!autoUpdateGoldenFiles) return;
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/$name.png'));
}

/// Lets the cached library's future resolve outside the fake clock.
Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  for (final (lang, b) in [('en', Brightness.light), ('en', Brightness.dark), ('ar', Brightness.light), ('ar', Brightness.dark)]) {
    final tag = '${lang}_${b.name}';

    testWidgets('this week card: daily line and one section per chip ($tag)', (tester) async {
      _phone(tester);
      final l = await L10n.delegate.load(Locale(lang));
      final library = Library(load: _fromDisk);
      final guide = (await tester.runAsync(() => loadWeekGuide(library, lang, _week)))!;
      await tester.pumpWidget(_app(
        lang,
        b,
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ThisWeekCard(library: library, week: _week, totalDays: _totalDays),
        ),
      ));
      await _settle(tester);
      expect(find.text(l.thisWeekTitle(_week)), findsOneWidget);
      expect(find.text(guide.dailyLine(_totalDays)!), findsOneWidget, reason: 'the daily line is the guide\'s own sentence');
      // The baby section shows first, verbatim, and only it.
      expect(find.text(guide.sections[WeekSection.baby]!.first), findsOneWidget);
      expect(find.text(guide.sections[WeekSection.tip]!.first), findsNothing);
      await _shoot('${tag}_this_week_baby');
      await tester.tap(find.text(l.weekSecTip));
      await tester.pumpAndSettle();
      expect(find.text(guide.sections[WeekSection.tip]!.first), findsOneWidget);
      expect(find.text(guide.sections[WeekSection.baby]!.first), findsNothing);
      await _shoot('${tag}_this_week_tip');
    });

    testWidgets('week strip: her week marked, a tap opens that week ($tag)', (tester) async {
      _phone(tester);
      final l = await L10n.delegate.load(Locale(lang));
      final library = Library(load: _fromDisk);
      await tester.runAsync(() => library.articles(lang));
      await tester.pumpWidget(_app(
        lang,
        b,
        Padding(
          padding: const EdgeInsets.all(20),
          child: PregnancyWeekStrip(edd: _edd, today: _today, library: library),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel(l.pregWeekCurrentLabel(_week)), findsOneWidget);
      await _shoot('${tag}_week_strip');
      await tester.tap(find.text('23'));
      await tester.pumpAndSettle();
      await _settle(tester);
      expect(find.text(l.weekGuideTitle(23)), findsOneWidget, reason: 'a week opened from the strip is named, not "this week"');
      await _shoot('${tag}_week_sheet');
    });
  }
}
