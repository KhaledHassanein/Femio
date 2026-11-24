// The Tools screens (R11.1-R11.3, R11.5): each one reaches its result from taps alone
// in all four languages, and the 390×844 screenshots in
// testing-results/2026-11-25-r11-calculators/app/ (Arabic light and dark, English
// light) are written only under `flutter test --update-goldens`. A plain run still
// drives every screen, which is the part that can regress silently. The dates and
// numbers are pinned by the golden fixtures; these tests check the screens draw them.

import 'dart:io';

import 'package:femio/data/library.dart';
import 'package:femio/features/learn/learn_screen.dart';
import 'package:femio/features/tools/due_date_tool_screen.dart';
import 'package:femio/features/tools/pregnancy_calendar_screen.dart';
import 'package:femio/features/tools/tool_widgets.dart';
import 'package:femio/features/tools/tools_screen.dart';
import 'package:femio/features/tools/weight_gain_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show NumberFormat;

/// Relative to this file (matchesGoldenFile resolves against the test's directory).
const _out = '../../../testing-results/2026-11-25-r11-calculators/app';

/// A fixed "today" so the taps land on known dates.
const _today = '2026-11-25';

Future<String> _fromDisk(String path) => File(path).readAsString();

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
  final sdk = Platform.environment['FLUTTER_ROOT'];
  if (sdk != null) {
    final icons = File('$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
    if (icons.existsSync()) await load('MaterialIcons', [icons.path]);
  }
}

Widget _app(String locale, Brightness b, Widget home) => MaterialApp(
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
      home: home,
    );

Future<L10n> _l10n(String locale) => L10n.delegate.load(Locale(locale));

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

/// Moves the month calendar [count] months back (negative) or ahead (positive).
Future<void> _months(WidgetTester tester, String locale, int count) async {
  final m = await GlobalMaterialLocalizations.delegate.load(Locale(locale));
  final tooltip = count < 0 ? m.previousMonthTooltip : m.nextMonthTooltip;
  for (var i = 0; i < count.abs(); i++) {
    await tester.tap(find.byTooltip(tooltip));
    await tester.pumpAndSettle();
  }
}

/// Lets the library's real file read finish (it runs outside the test's fake clock).
Future<void> _settleIo(WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(const Duration(seconds: 1)));
  await tester.pump();
}

/// Scrolls the screen's list until [finder] is built and on screen.
Future<void> _reveal(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(finder, 200, scrollable: find.byType(Scrollable).first);
  await tester.pumpAndSettle();
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

  const shots = [('ar', Brightness.light), ('ar', Brightness.dark), ('en', Brightness.light)];
  const locales = ['en', 'ar', 'fr', 'es'];

  for (final lang in locales) {
    testWidgets('due date from a last period shows the date, the window and the week ($lang)', (tester) async {
      _phone(tester);
      final l = await _l10n(lang);
      await tester.pumpWidget(_app(lang, Brightness.light, const DueDateToolScreen(today: _today)));
      await tester.pumpAndSettle();
      expect(find.byType(ToolResult), findsNothing);
      await _months(tester, lang, -5); // June 2026
      await tester.tap(find.text('15').last);
      await tester.pumpAndSettle();
      // LMP 2026-06-15, cycle 28 → due 2027-03-22; on 2026-11-25 she is 23w2d.
      await _reveal(tester, find.text(l.pregnancyWeek(23, 2)));
      expect(find.byType(ToolResult), findsOneWidget);
    });

    testWidgets('the weight-gain tool shows the IOM range for one baby ($lang)', (tester) async {
      _phone(tester);
      final l = await _l10n(lang);
      await tester.pumpWidget(_app(lang, Brightness.light, const WeightGainScreen()));
      await tester.enterText(find.byKey(const ValueKey('gain-weight')), '62');
      await tester.enterText(find.byKey(const ValueKey('gain-height')), '165');
      await tester.pumpAndSettle();
      final low = NumberFormat.decimalPatternDigits(locale: lang, decimalDigits: 1).format(11.5);
      expect(find.text(l.toolGainRangeKg(low, '16')), findsOneWidget);
    });
  }

  testWidgets('the due date from a scan uses the weeks on the report', (tester) async {
    _phone(tester);
    final l = await _l10n('en');
    await tester.pumpWidget(_app('en', Brightness.light, const DueDateToolScreen(today: _today)));
    await tester.tap(find.text(l.toolDueMethodScan));
    await tester.pumpAndSettle();
    expect(find.text(l.toolScanWeeksLabel), findsOneWidget);
    await tester.tap(find.text('10').last); // scan on 2026-11-10 at 12w0d
    await tester.pumpAndSettle();
    await _reveal(tester, find.text(l.toolScanNote));
    expect(find.text(l.pregnancyWeek(14, 1)), findsOneWidget);
  });

  testWidgets('weight gain refuses a height outside the accepted range, and twins under 18.5 get no range',
      (tester) async {
    _phone(tester);
    final l = await _l10n('en');
    await tester.pumpWidget(_app('en', Brightness.light, const WeightGainScreen()));
    await tester.enterText(find.byKey(const ValueKey('gain-weight')), '50');
    await tester.enterText(find.byKey(const ValueKey('gain-height')), '90');
    await tester.pumpAndSettle();
    expect(find.text(l.toolGainOutOfRange('25', '300', '120', '220')), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('gain-height')), '170');
    await tester.tap(find.text(l.toolGainBabiesTwo));
    await tester.pumpAndSettle();
    expect(find.text(l.toolGainNoRangeTwins), findsOneWidget);
  });

  test('a typed number reads Eastern digits and a comma or Arabic decimal mark', () {
    expect(parseTypedNumber('٦٢٫٥'), 62.5);
    expect(parseTypedNumber('62,5'), 62.5);
    expect(parseTypedNumber(' 165 '), 165);
    expect(parseTypedNumber('abc'), isNull);
  });

  testWidgets('Learn opens the Tools hub, which lists the three tools', (tester) async {
    _phone(tester);
    final l = await _l10n('en');
    await tester.pumpWidget(_app('en', Brightness.light, LearnScreen(library: Library(load: _fromDisk))));
    await _settleIo(tester);
    await tester.tap(find.text(l.toolsTitle));
    await tester.pumpAndSettle();
    expect(find.byType(ToolsScreen), findsOneWidget);
    for (final title in [l.toolDueTitle, l.toolCalTitle, l.toolGainTitle]) {
      expect(find.text(title), findsOneWidget);
    }
  });

  for (final (lang, b) in shots) {
    final tag = '${lang}_${b.name}';

    testWidgets('tools hub ($tag)', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_app(lang, b, ToolsScreen(library: Library(load: _fromDisk))));
      await tester.pumpAndSettle();
      await _shoot('${tag}_tools_hub');
    });

    testWidgets('due date result ($tag)', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_app(lang, b, const DueDateToolScreen(today: _today)));
      await tester.pumpAndSettle();
      await _months(tester, lang, -5);
      await tester.tap(find.text('15').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(ToolResult));
      await tester.pumpAndSettle();
      await _shoot('${tag}_due_date');
    });

    testWidgets('pregnancy calendar with the current week ($tag)', (tester) async {
      _phone(tester);
      final l = await _l10n(lang);
      final library = Library(load: _fromDisk);
      await tester.runAsync(() => library.articles(lang)); // cached, so the screen's read is instant
      await tester.pumpWidget(_app(lang, b, PregnancyCalendarScreen(library: library, today: _today)));
      await tester.pumpAndSettle();
      await _months(tester, lang, 4); // March 2027
      await tester.tap(find.text('15').last);
      await tester.pumpAndSettle();
      // Due 2027-03-15 → on 2026-11-25 she is 24w2d: the week-24 row is "this week".
      final current = find.text(l.toolCalCurrent);
      await _reveal(tester, current);
      expect(current, findsOneWidget);
      expect(find.byIcon(Icons.chevron_right_rounded), findsWidgets); // each week opens its guide
      await Scrollable.ensureVisible(tester.element(current), alignment: 0.4);
      await tester.pumpAndSettle();
      await _shoot('${tag}_pregnancy_calendar');
    });

    testWidgets('weight gain result ($tag)', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_app(lang, b, const WeightGainScreen()));
      await tester.enterText(find.byKey(const ValueKey('gain-weight')), '62');
      await tester.enterText(find.byKey(const ValueKey('gain-height')), '165');
      await tester.pumpAndSettle();
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.ensureVisible(find.byType(ToolResult));
      await tester.pumpAndSettle();
      await _shoot('${tag}_weight_gain');
    });
  }
}
