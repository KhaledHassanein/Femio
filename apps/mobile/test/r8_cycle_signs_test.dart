// The "Signs you logged this cycle" card (R8.27): what it gathers, and how it looks.
//
// Why it exists: the card must show only this cycle's latest readings, as she logged them,
// never a conclusion, and always carry the MR-16 sentence beside a strip result. Synthetic
// records only. Screenshots land in testing-results/2026-11-25-r8-cycle-signs/ under
// `--update-goldens`.

import 'package:femio/data/profile.dart';
import 'package:femio/domain/cycle_signs.dart';
import 'package:femio/features/today/cycle_signs_card.dart';
import 'package:femio/features/today/period_hero.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-25-r8-cycle-signs';
const _today = '2026-06-14';
const _starts = ['2026-04-03', '2026-05-01', '2026-05-30'];

final _logs = <String, DayLog>{
  '2026-05-20': const DayLog(terms: ['eggWhite'], opk: 'peak', bbt: 36.9), // last cycle
  '2026-06-08': const DayLog(terms: ['creamy'], bbt: 36.35),
  '2026-06-10': const DayLog(terms: ['watery', 'cramps'], opk: 'low', bbt: 36.4),
  '2026-06-12': const DayLog(opk: 'high', bbt: 36.45),
  '2026-06-20': const DayLog(terms: ['dry'], opk: 'negative', bbt: 37.0), // future
};

void main() {
  group('gathering', () {
    test('only the current cycle, only up to today, latest of each', () {
      final s = cycleSigns(_logs, _starts, _today);
      expect(s.discharge!.day, '2026-06-10');
      expect(s.discharge!.value, ['watery']);
      expect((s.opk!.day, s.opk!.value), ('2026-06-12', 'high'));
      expect((s.bbt!.day, s.bbt!.value, s.bbtUnit), ('2026-06-12', 36.45, 'c'));
      expect(s.bbtCount, 3, reason: 'last cycle and the future day do not count');
    });

    test('nothing logged this cycle gives an empty card', () {
      final s = cycleSigns({'2026-05-20': const DayLog(opk: 'peak')}, _starts, _today);
      expect(s.isEmpty, isTrue);
    });

    test('with no period logged every past day counts', () {
      final s = cycleSigns({'2026-01-02': const DayLog(bbt: 97.9)}, const [], _today);
      expect((s.bbt!.value, s.bbtUnit, s.bbtCount), (97.9, 'f', 1));
    });

    test('symptoms are not discharge', () {
      final s = cycleSigns({'2026-06-01': const DayLog(terms: ['cramps'])}, _starts, _today);
      expect(s.discharge, isNull);
      expect(s.isEmpty, isTrue);
    });
  });

  group('words', () {
    for (final lang in ['en', 'ar', 'fr', 'es']) {
      testWidgets('the strip sentence sits beside a test result, and no verdict words ($lang)', (tester) async {
        final l = await L10n.delegate.load(Locale(lang));
        await tester.pumpWidget(_app(lang, Brightness.light, CycleSignsCard(signs: cycleSigns(_logs, _starts, _today), date: (d) => d)));
        await tester.pumpAndSettle();
        expect(find.text(l.signsStripLine), findsOneWidget);
        expect(find.text(l.signsNote), findsOneWidget);
        expect(find.text(l.signsTempCount(3)), findsOneWidget);
        final shown = tester.widgetList<Text>(find.byType(Text)).map((t) => t.data ?? '').join(' ').toLowerCase();
        if (lang == 'en') {
          expect(shown, isNot(contains('you ovulated on')));
          expect(shown, isNot(contains('confirmed')));
        }
      });
    }

    testWidgets('no test result, no strip sentence', (tester) async {
      final l = await L10n.delegate.load(const Locale('en'));
      final signs = cycleSigns({'2026-06-08': const DayLog(terms: ['creamy'])}, _starts, _today);
      await tester.pumpWidget(_app('en', Brightness.light, CycleSignsCard(signs: signs, date: (d) => d)));
      expect(find.text(l.signsStripLine), findsNothing);
      expect(find.text(l.signsNote), findsOneWidget);
    });
  });

  group('screens', () {
    setUpAll(() async {
      await loadAppFonts();
      configureFormatting();
    });

    for (final (lang, b) in const [
      ('en', Brightness.light),
      ('en', Brightness.dark),
      ('ar', Brightness.light),
      ('ar', Brightness.dark),
    ]) {
      testWidgets('trying to conceive shows the card on Today (${lang}_${b.name})', (tester) async {
        tester.view.physicalSize = const Size(780, 1688);
        tester.view.devicePixelRatio = 2;
        addTearDown(tester.view.reset);
        final l = await L10n.delegate.load(Locale(lang));
        final profile = Profile(goal: Goal.ttc, locale: lang, periodStarts: _starts, logs: _logs);
        await tester.pumpWidget(_app(lang, b, Builder(builder: (context) {
          String date(String iso) => MaterialLocalizations.of(context).formatShortMonthDay(DateTime.parse(iso));
          return PeriodHero(profile: profile, today: _today, date: date, range: (a, z) => l.rangeValue(date(a), date(z)));
        })));
        await tester.pumpAndSettle();
        final card = find.byType(CycleSignsCard);
        await tester.dragUntilVisible(card, find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();
        expect(find.text(l.signsTitle), findsOneWidget);
        if (autoUpdateGoldenFiles) {
          await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/${lang}_${b.name}_signs.png'));
        }
      });
    }

    testWidgets('tracking a period does not show it', (tester) async {
      final profile = Profile(goal: Goal.period, locale: 'en', periodStarts: _starts, logs: _logs);
      await tester.pumpWidget(_app('en', Brightness.light, PeriodHero(profile: profile, today: _today, date: (d) => d, range: (a, z) => '$a–$z')));
      await tester.pumpAndSettle();
      expect(find.byType(CycleSignsCard), findsNothing);
    });
  });
}

Widget _app(String lang, Brightness b, Widget child) => MaterialApp(
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
      home: Scaffold(body: ListView(padding: const EdgeInsets.all(20), children: [child])),
    );
