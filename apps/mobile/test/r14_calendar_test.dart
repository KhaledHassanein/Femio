// R14.7 + R14.8: the calendar the owner found empty (2026-11-26). Her stated cycle length
// now stands in until three starts (MR-57 extension, owner ruling "Yes, keep it"), a stated
// 36-45 earns a range (MR-03), her "irregular" answer limits the forecast to one period
// (MR-51), no range already past is shown (rule 3), an empty forecast says why and offers
// the fix, the legend lists only what is drawn, and a month with no estimate points to the
// next one. With --update-goldens it writes proof shots (390x844 at 2x, EN and AR, light
// and dark) to testing-results/2026-11-26-r14-calendar/ (synthetic fixture).

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/cycle_prediction.dart';
import 'package:femio/domain/dates.dart';
import 'package:femio/domain/day_marks.dart';
import 'package:femio/domain/fertility.dart';
import 'package:femio/domain/forecast.dart';
import 'package:femio/domain/upcoming_periods.dart';
import 'package:femio/features/calendar/calendar_screen.dart';
import 'package:femio/features/calendar/upcoming_periods_card.dart';
import 'package:femio/features/today/period_hero.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-26-r14-calendar';
const _today = '2026-11-26';

/// Each start bleeds 5 days, logged day by day as the app stores them.
List<String> _bleeds(List<String> starts) => [
      for (final s in starts)
        for (var d = 0; d < 5; d++) addDays(s, d),
    ];

Profile _profile(
  String lang, {
  Goal goal = Goal.ttc,
  List<String> starts = const ['2026-10-25', '2026-11-20'],
  int? cycleLength = 28,
  bool irregular = false,
}) =>
    Profile(
      goal: goal,
      locale: lang,
      birthYear: 1994,
      periodStarts: _bleeds(starts),
      periodLength: 5,
      cycleLength: cycleLength,
      irregular: irregular,
      settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
    );

Future<FemioController> _pump(WidgetTester tester, Profile p, Widget Function(FemioController) home,
    {Brightness b = Brightness.light}) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  final c = FemioController(MemoryStore(p), initialLocale: p.locale);
  await c.load();
  await tester.pumpWidget(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
    locale: Locale(p.locale),
    supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr'), Locale('es')],
    localizationsDelegates: const [
      L10n.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: home(c),
  ));
  await tester.pumpAndSettle();
  return c;
}

Widget _calendar(FemioController c) =>
    Scaffold(body: CalendarScreen(controller: c, today: _today, onDay: (_) {}));

Widget _hero(FemioController c) => Scaffold(
      body: SingleChildScrollView(
        child: PeriodHero(
          profile: c.profile!,
          today: _today,
          range: (a, b) => '$a..$b',
          date: (d) => d,
        ),
      ),
    );

List<UpcomingPeriod> _cardPeriods(WidgetTester tester) =>
    tester.widget<UpcomingPeriodsCard>(find.byType(UpcomingPeriodsCard)).periods;

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  group('R14.8: her stated length stands in until three starts (MR-57)', () {
    test('two starts and a stated 28: three ranges from her latest start, and a window', () {
      final p = _profile('en');
      final pr = predictNextPeriod(p.cycleStarts, p.cycleLength)!;
      expect(pr.basis, 'stated');
      expect(pr.predictedStart, '2026-12-18'); // 28 days from 20 Nov
      expect(upcomingFor(p, pr), hasLength(3));
      expect(fertileWindowsFor(p, pr), isNotEmpty);
      final marks = dayMarks(p, today: _today, from: '2026-11-26', to: '2027-02-28');
      expect(marks.values.where((m) => m.fertile), isNotEmpty);
      expect(marks.values.where((m) => m.predicted), isNotEmpty);
    });

    test('three starts: her own cycles take over', () {
      final p = _profile('en', starts: ['2026-09-28', '2026-10-25', '2026-11-20']);
      final pr = predictNextPeriod(p.cycleStarts, p.cycleLength)!;
      expect(pr.basis, 'observed');
      expect(pr.averageLength, 27); // 27 and 26, not the 28 she stated
    });
  });

  group('R14.7 rules', () {
    test('a stated 40 earns a range; the window stays withheld (MR-03, MR-08)', () {
      final p = _profile('en', goal: Goal.period, starts: ['2026-11-20'], cycleLength: 40);
      final pr = predictNextPeriod(p.cycleStarts, p.cycleLength)!;
      expect(pr.windowStart, '2026-12-26');
      expect(windowStatusFor(p, pr), WindowStatus.outsideRange);
      final marks = dayMarks(p, today: _today, from: '2026-11-26', to: '2027-03-31');
      expect(marks.values.where((m) => m.predicted), isNotEmpty);
      expect(marks.values.where((m) => m.fertile || m.ovulation), isEmpty);
    });

    test('her "irregular" answer keeps the forecast to one period even when logs look steady (MR-51)', () {
      final p = _profile('en', starts: ['2026-09-25', '2026-10-23', '2026-11-20'], cycleLength: null, irregular: true);
      final pr = predictNextPeriod(p.cycleStarts, p.cycleLength)!;
      expect(pr.irregular, isFalse); // her logs alone would give three
      expect(upcomingFor(p, pr), hasLength(1));
    });

    test('why nothing is ahead, in rule order', () {
      expect(forecastGap(_profile('en', starts: const []), _today), ForecastGap.noPeriodLogged);
      expect(forecastGap(_profile('en', starts: ['2026-11-20'], cycleLength: null), _today), ForecastGap.needLength);
      expect(
        forecastGap(_profile('en', starts: ['2026-11-20'], cycleLength: null, irregular: true), _today),
        ForecastGap.needAnother,
      );
      expect(forecastGap(_profile('en', starts: ['2026-06-01']), _today), ForecastGap.allPassed);
      expect(forecastGap(_profile('en'), _today), isNull);
    });

    test('a range already past is left out, on both surfaces', () {
      // Stated 28 from 20 Oct: the first range (13-21 Nov) has passed; the next is 9-21 Dec.
      final p = _profile('en', starts: ['2026-10-20']);
      final ahead = upcomingAhead(p, _today);
      expect(ahead.first.windowStart, '2026-12-09');
      expect(ahead.every((u) => u.windowEnd.compareTo(_today) >= 0), isTrue);
    });
  });

  group('screens', () {
    testWidgets('"Not sure": the calendar says why and the fix fills it in', (tester) async {
      final c = await _pump(tester, _profile('en', starts: ['2026-11-20'], cycleLength: null), _calendar);
      final l = lookupL10n(const Locale('en'));
      final add = find.text(l.gapAddLength);
      await tester.scrollUntilVisible(add, 300, scrollable: find.byType(Scrollable).first);
      expect(find.text(l.gapNeedLengthBody), findsOneWidget);
      expect(find.text(l.calendarHintNoEstimates), findsOneWidget);
      await tester.ensureVisible(add);
      await tester.pumpAndSettle();
      await tester.tap(add);
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.gapSaveLength));
      await tester.pumpAndSettle();
      expect(c.profile!.cycleLength, 28);
      expect(find.text(l.gapNeedLengthBody), findsNothing);
      expect(_cardPeriods(tester), hasLength(3));
    });

    testWidgets('the card lists no past range, and Today names the same first range', (tester) async {
      final p = _profile('en', goal: Goal.period, starts: ['2026-10-20']);
      await _pump(tester, p, _calendar);
      expect(_cardPeriods(tester).first.windowStart, '2026-12-09');
      await _pump(tester, p, _hero);
      expect(find.text('2026-12-09..2026-12-21'), findsOneWidget);
      expect(find.text('2026-11-13..2026-11-21'), findsNothing);
    });

    testWidgets('every range passed: Today says so calmly, with no count', (tester) async {
      await _pump(tester, _profile('en', goal: Goal.period, starts: ['2026-06-01']), _hero);
      final l = lookupL10n(const Locale('en'));
      expect(find.text(l.gapPassedTitle), findsOneWidget);
      expect(find.text(l.gapPassedBody), findsOneWidget);
    });

    testWidgets('a month with no estimate points to the next period, and the link goes there', (tester) async {
      await _pump(tester, _profile('en'), _calendar);
      final l = lookupL10n(const Locale('en'));
      final link = find.textContaining(l.calendarNextPeriodLink('').trim());
      expect(link, findsOneWidget);
      await tester.tap(link);
      await tester.pumpAndSettle();
      expect(find.text('December 2026'), findsOneWidget);
      expect(link, findsNothing); // December draws the range itself
    });

    testWidgets('the legend lists only what is drawn, with the MR-08 reason', (tester) async {
      await _pump(tester, _profile('en', goal: Goal.period, starts: ['2026-11-20'], cycleLength: 40), _calendar);
      final l = lookupL10n(const Locale('en'));
      expect(find.text(l.legendFertile), findsNothing);
      expect(find.text(l.legendOvulation), findsNothing);
      expect(find.text(l.whyRangeWindowOutside(regularCycleMin, regularCycleMax)), findsOneWidget);
    });

    testWidgets('menopause: no fertile or ovulation swatch', (tester) async {
      await _pump(tester, _profile('en', goal: Goal.menopause, starts: ['2026-06-01', '2026-09-20'], cycleLength: null),
          _calendar);
      final l = lookupL10n(const Locale('en'));
      expect(find.text(l.legendFertile), findsNothing);
      expect(find.text(l.legendOvulation), findsNothing);
    });
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      testWidgets('proof shots ($lang ${b.name})', (tester) async {
        // The owner's case: two periods logged, length stated. December holds three ranges' first.
        await _pump(tester, _profile(lang), _calendar, b: b);
        final l = lookupL10n(Locale(lang));
        await tester.tap(find.textContaining(l.calendarNextPeriodLink('').trim()));
        await tester.pumpAndSettle();
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/two_starts_${lang}_${b.name}.png'));
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
        await tester.pumpAndSettle();
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/two_starts_card_${lang}_${b.name}.png'));

        await tester.pumpWidget(const SizedBox()); // a fresh calendar opens on this month
        await _pump(tester, _profile(lang, starts: ['2026-11-20'], cycleLength: null), _calendar, b: b);
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
        await tester.pumpAndSettle();
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/not_sure_${lang}_${b.name}.png'));
      });
    }
  }
}
