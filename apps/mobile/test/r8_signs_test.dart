// R8.8: signs by cycle day. Bleeding, waking temperature, ovulation tests and discharge line up
// by cycle day exactly as logged; no shift, no ovulation day (MR-16, MR-17). With
// --update-goldens it writes proof shots (390x844 at 2x, EN and AR, light and dark) to
// testing-results/2026-11-26-r8-signs/ (synthetic fixture).

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/cycle_sign_days.dart';
import 'package:femio/domain/cycle_signs.dart';
import 'package:femio/domain/dates.dart';
import 'package:femio/features/calendar/patterns_screen.dart';
import 'package:femio/features/calendar/signs_by_day_screen.dart';
import 'package:femio/features/today/cycle_signs_card.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-26-r8-signs';
const _today = '2026-11-26';
const _starts = ['2026-09-07', '2026-10-07', '2026-11-06'];

/// The current cycle (from 6 Nov) has 20 temperatures, tests on days 10 to 15 and discharge
/// words; the one before has only 2 temperatures (no chart, MR-17).
Map<String, DayLog> _logs() {
  final logs = <String, DayLog>{};
  const cur = '2026-11-06';
  for (var d = 1; d <= 20; d++) {
    logs[addDays(cur, d - 1)] = DayLog(bbt: d < 16 ? 36.3 + (d % 3) * 0.05 : 36.7);
  }
  void put(int day, {String? opk, List<String> terms = const []}) {
    final k = addDays(cur, day - 1);
    final o = logs[k]!;
    logs[k] = DayLog(bbt: o.bbt, opk: opk ?? o.opk, terms: [...o.terms, ...terms]);
  }

  put(8, terms: ['sticky']);
  put(10, opk: 'negative', terms: ['creamy']);
  put(12, opk: 'low');
  put(13, opk: 'high', terms: ['eggWhite']);
  put(14, opk: 'positive', terms: ['eggWhite', 'watery']);
  put(15, opk: 'negative');
  put(17, terms: ['dry']);
  logs['2026-10-20'] = const DayLog(bbt: 36.4);
  logs['2026-10-21'] = const DayLog(bbt: 36.5, flow: 'spotting');
  return logs;
}

Profile _profile(String lang, {List<String> starts = _starts, Map<String, DayLog>? logs}) => Profile(
      goal: Goal.ttc,
      locale: lang,
      birthYear: 1994,
      periodStarts: [
        for (final s in starts)
          for (var d = 0; d < 5; d++) addDays(s, d),
      ],
      cycleLength: 30,
      logs: logs ?? _logs(),
      settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
    );

Widget _app(String lang, Brightness b, Widget home) => MaterialApp(
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
      home: home,
    );

Future<void> _pump(WidgetTester tester, String lang, Brightness b, Widget home) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_app(lang, b, home));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  group('days', () {
    test('cycles: the complete ones and the one still running, oldest first', () {
      final c = signCycles(_profile('en'), _today);
      expect(c.map((x) => (x.start, x.end, x.complete)), [
        ('2026-09-07', '2026-10-06', true),
        ('2026-10-07', '2026-11-05', true),
        ('2026-11-06', _today, false),
      ]);
      expect(c.last.days, 21);
      expect(signCycles(_profile('en', starts: const [], logs: const {}), _today), isEmpty);
    });

    test('a future period start is not a cycle yet', () {
      final c = signCycles(_profile('en', starts: [..._starts, '2026-12-06']), _today);
      expect(c.last.start, '2026-11-06');
      expect(c.last.complete, isFalse);
    });

    test('at most the last 13 cycles are offered', () {
      final starts = [for (var i = 0; i < 20; i++) addDays('2025-04-01', i * 28)];
      expect(signCycles(_profile('en', starts: starts, logs: const {}), _today).length, 13);
    });

    test('each day holds what she logged, as she logged it', () {
      final p = _profile('en');
      final cur = signDays(p, signCycles(p, _today).last);
      expect(cur.days.length, 21);
      expect(cur.days.where((d) => d.bleeding).map((d) => d.cycleDay), [1, 2, 3, 4, 5]);
      final d14 = cur.days[13];
      expect((d14.cycleDay, d14.opk), (14, 'positive'));
      expect(d14.discharge, ['watery', 'eggWhite']);
      expect(cur.days[20].isEmpty, isTrue);
      expect(cur.chart, isNotNull);
      expect(cur.days.where((d) => d.bbtY != null).length, 20);
      expect(cur.hasOpk, isTrue);
    });

    test('fewer than 3 temperatures: no chart and no heights (MR-17); a flow day counts as bleeding', () {
      final p = _profile('en');
      final prev = signDays(p, signCycles(p, _today)[1]);
      expect(prev.temperatures, 2);
      expect(prev.chart, isNull);
      expect(prev.days.every((d) => d.bbtY == null), isTrue);
      expect(prev.days.firstWhere((d) => d.day == '2026-10-21').bleeding, isTrue);
      expect(prev.hasOpk, isFalse);
    });

    test('marks are drawn by list order only', () {
      expect(opkFill('negative'), 0);
      expect(opkFill('positive'), 1);
      expect(opkFill('high'), 0.5);
      expect(dischargeFill(const ['dry']), 0);
      expect(dischargeFill(const ['sticky', 'eggWhite']), 1);
      expect(dischargeFill(const []), 0);
    });

    test('the cycle holding a day', () {
      final c = signCycles(_profile('en'), _today);
      expect(cycleHolding(c, '2026-10-20')!.start, '2026-10-07');
      expect(cycleHolding(c, '2026-01-01'), isNull);
    });
  });

  group('screen', () {
    testWidgets('opens on this cycle at the last sign, and a tap shows that day', (tester) async {
      final l = lookupL10n(const Locale('en'));
      await _pump(tester, 'en', Brightness.light, SignsByDayScreen(profile: _profile('en'), today: _today));
      expect(find.text(l.signsDaysCurrent('Nov 6, 2026')), findsOneWidget);
      expect(find.textContaining('Cycle day 20,'), findsOneWidget);
      expect(find.text(l.signsStripLine), findsOneWidget);
      await tester.ensureVisible(find.text('14'));
      await tester.tap(find.text('14'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Cycle day 14,'), findsOneWidget);
      expect(find.text('${l.sectionOvulationTest}: ${l.opkPositive}'), findsOneWidget);
      expect(find.text('${l.sectionDischarge}: ${l.logWatery}, ${l.logEggWhite}'), findsOneWidget);
    });

    testWidgets('earlier cycles: length, no strip line without a test, the 3-reading note', (tester) async {
      final l = lookupL10n(const Locale('en'));
      await _pump(tester, 'en', Brightness.light, SignsByDayScreen(profile: _profile('en'), today: _today));
      await tester.tap(find.byTooltip(l.signsDaysEarlier));
      await tester.pumpAndSettle();
      expect(find.text(l.signsDaysPast('Oct 7, 2026', l.patDays(30))), findsOneWidget);
      expect(find.text(l.signsStripLine), findsNothing);
      expect(find.text(l.bbtChartNeedData), findsOneWidget);
      await tester.tap(find.byTooltip(l.signsDaysEarlier));
      await tester.pumpAndSettle();
      expect(find.text(l.signsDaysEmpty), findsOneWidget);
      final earlier = tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.chevron_left_rounded));
      expect(earlier.onPressed, isNull);
    });

    testWidgets('no period logged yet says how to start', (tester) async {
      final l = lookupL10n(const Locale('en'));
      await _pump(tester, 'en', Brightness.light,
          SignsByDayScreen(profile: _profile('en', starts: const [], logs: const {}), today: _today));
      expect(find.text(l.signsDaysNoCycle), findsOneWidget);
    });

    testWidgets('the Today signs card links here', (tester) async {
      final l = lookupL10n(const Locale('en'));
      var opened = false;
      final p = _profile('en');
      await _pump(tester, 'en', Brightness.light, Scaffold(
        body: ListView(children: [
          CycleSignsCard(signs: cycleSigns(p.logs, p.periodStarts, _today), date: (d) => d, onOpenDays: () => opened = true),
        ]),
      ));
      await tester.tap(find.text(l.signsDaysOpen));
      expect(opened, isTrue);
    });

    testWidgets('a cycle on Patterns opens that cycle here', (tester) async {
      final l = lookupL10n(const Locale('en'));
      final c = FemioController(MemoryStore(_profile('en')), initialLocale: 'en');
      await c.load();
      await _pump(tester, 'en', Brightness.light, PatternsScreen(controller: c, today: _today));
      final row = find.text(l.patCycleFrom('Oct 7, 2026'));
      await tester.scrollUntilVisible(row, 300, scrollable: find.byType(Scrollable).first);
      await tester.tap(row);
      await tester.pumpAndSettle();
      expect(find.byType(SignsByDayScreen), findsOneWidget);
      expect(find.text(l.signsDaysPast('Oct 7, 2026', l.patDays(30))), findsOneWidget);
    });
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      testWidgets('signs shots ($lang ${b.name})', (tester) async {
        await _pump(tester, lang, b, SignsByDayScreen(profile: _profile(lang), today: _today, day: '2026-11-19'));
        await tester.ensureVisible(find.text('14'));
        await tester.tap(find.text('14'));
        await tester.pumpAndSettle();
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/signs_${lang}_${b.name}.png'));
      });
    }
  }
}
