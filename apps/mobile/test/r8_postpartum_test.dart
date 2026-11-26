// R8.19: the after-birth stage. The healing bleed stays out of the period list, the first
// period after birth restarts the ranges (MR-60), Today follows her weeks since the birth with
// a reviewed guide, a mood check-in and the MR-50 warning signs, and "I had my baby" records
// the birth. With --update-goldens it writes proof shots (390x844 at 2x, EN and AR, light and
// dark) to testing-results/2026-11-26-r8-postpartum/ (synthetic fixture).

import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/library.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/cycle_prediction.dart';
import 'package:femio/domain/day_marks.dart';
import 'package:femio/domain/postpartum.dart';
import 'package:femio/features/log/log_screen.dart';
import 'package:femio/features/today/today_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-26-r8-postpartum';
const _today = '2026-11-26';
const _birth = '2026-11-05';

final _content = {
  for (final loc in ['en', 'ar', 'fr', 'es']) 'assets/content/$loc.json': File('assets/content/$loc.json').readAsStringSync(),
};
Library _library() => Library(load: (path) async => _content[path]!);

Profile _profile(String lang, {String? birthDate = _birth, int? cycleLength}) => Profile(
      goal: Goal.pregnant,
      locale: lang,
      birthYear: 1994,
      periodStarts: const ['2025-12-01', '2025-12-02', '2025-12-29', '2025-12-30', '2026-01-26'],
      cycleLength: cycleLength,
      edd: '2026-11-10',
      birthDate: birthDate,
      settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
    );

Future<FemioController> _pump(WidgetTester tester, Profile p, Brightness b, Widget Function(FemioController) home) async {
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

/// Scrolls Today until [f] is built, then fully into view.
Future<void> _reveal(WidgetTester tester, Finder f) async {
  await tester.scrollUntilVisible(f, 300, scrollable: find.byType(Scrollable).first);
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
}

Widget _todayFor(FemioController c) => TodayScreen(controller: c, today: _today, library: _library());

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  group('the healing bleed and the restart of ranges (MR-60)', () {
    test('bleeding logged after birth stays in the log, out of the period list, and is still drawn', () {
      final p = _profile('en').withDayLog('2026-11-20', const DayLog(flow: 'heavy'));
      expect(p.isPostpartum, isTrue);
      expect(p.logs['2026-11-20']!.flow, 'heavy');
      expect(p.periodStarts.contains('2026-11-20'), isFalse);
      expect(dayMarks(p, today: _today, from: '2026-11-01', to: '2026-11-30')['2026-11-20']!.bleed, isTrue);
    });

    test('the cycle tools read only bleeding from the birth on; the full list is kept', () {
      final p = _profile('en');
      expect(p.cycleStarts, isEmpty);
      expect(p.periodStarts.length, 5);
      expect(_profile('en', birthDate: null).cycleStarts.length, 5);
    });

    testWidgets('her period came back: goal changes, that day starts the ranges', (tester) async {
      final c = await _pump(tester, _profile('en', cycleLength: 28), Brightness.light, (c) => const SizedBox());
      await c.periodCameBack('2027-01-15', Goal.period);
      final p = c.profile!;
      expect(p.goal, Goal.period);
      expect(p.birthDate, _birth, reason: 'the birth stays on her record');
      expect(p.cycleStarts, ['2027-01-15']);
      expect(p.periodStarts.length, 6, reason: 'nothing deleted (rule 5)');
      final next = predictNextPeriod(p.cycleStarts, p.cycleLength)!;
      expect(next.predictedStart, '2027-02-12');
      expect(next.basis, 'stated');
    });

    testWidgets('without a stated length, one period after birth is not enough for a range', (tester) async {
      final c = await _pump(tester, _profile('en'), Brightness.light, (c) => const SizedBox());
      await c.periodCameBack('2027-01-15', Goal.ttc);
      expect(predictNextPeriod(c.profile!.cycleStarts, c.profile!.cycleLength), isNull);
    });
  });

  group('weeks and guides', () {
    test('weeks since birth never go below zero', () {
      expect(weeksSinceBirth(_birth, _today), 3);
      expect(weeksSinceBirth(_birth, '2026-11-01'), 0);
    });

    test('one reviewed guide per week, then none', () {
      expect(recoveryGuideFor(0), 'postpartum-recovery-first-six-weeks');
      expect(recoveryGuideFor(3), 'postpartum-wound-healing');
      expect(recoveryGuideFor(recoveryGuideByWeek.length), isNull);
    });

    test('every guide in the sequence exists in all four languages', () {
      for (final path in _content.keys) {
        for (final slug in [...recoveryGuideByWeek, postpartumWarningGuide, postpartumMoodGuide]) {
          expect(_content[path]!.contains('"slug":"$slug"') || _content[path]!.contains('"slug": "$slug"'), isTrue,
              reason: '$slug in $path');
        }
      }
    });
  });

  group('screens', () {
    testWidgets('Today after birth: weeks, this week\'s guide, mood check-in, period back, warning signs', (tester) async {
      final l = lookupL10n(const Locale('en'));
      final c = await _pump(tester, _profile('en'), Brightness.light, _todayFor);
      expect(find.text(l.postpartumWeeks(3)), findsOneWidget);
      expect(find.text(l.ppGuideEyebrow), findsOneWidget);
      expect(find.text(l.ppMoodTitle), findsOneWidget);
      await tester.tap(find.text(l.logSad));
      await tester.pumpAndSettle();
      expect(c.profile!.logs[_today]!.terms, ['sad']);
      await _reveal(tester, find.text(l.safetyPostpartumHeading));
      expect(find.text(l.safetyPostpartumHeading), findsOneWidget);
      expect(find.text(l.ppHadBaby), findsNothing);
    });

    testWidgets('a year after birth the general notice returns', (tester) async {
      final l = lookupL10n(const Locale('en'));
      await _pump(tester, _profile('en', birthDate: '2025-11-01'), Brightness.light, _todayFor);
      await _reveal(tester, find.text(l.todayUrgentBody));
      expect(find.text(l.safetyPostpartumHeading), findsNothing);
      expect(find.text(l.ppGuideEyebrow), findsNothing);
    });

    testWidgets('pregnant: "I had my baby" records the birth on the day she taps', (tester) async {
      final l = lookupL10n(const Locale('en'));
      final c = await _pump(tester, _profile('en', birthDate: null), Brightness.light, _todayFor);
      await _reveal(tester, find.text(l.ppHadBaby));
      await tester.tap(find.text(l.ppHadBaby));
      await tester.pumpAndSettle();
      expect(find.text(l.birthDateTitle), findsOneWidget);
      await tester.tap(find.text('24'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(c.profile!.birthDate, '2026-11-24');
      expect(find.text(l.ppGuideEyebrow), findsOneWidget);
    });

    testWidgets('"My period came back" asks the day, then what femio helps with', (tester) async {
      final l = lookupL10n(const Locale('en'));
      final c = await _pump(tester, _profile('en'), Brightness.light, _todayFor);
      await _reveal(tester, find.text(l.ppPeriodBackAction));
      await tester.tap(find.text(l.ppPeriodBackAction));
      await tester.pumpAndSettle();
      final track = find.widgetWithText(FilledButton, l.goalPeriod);
      expect(tester.widget<FilledButton>(track).onPressed, isNull, reason: 'no day picked yet');
      await tester.tap(find.text('25'));
      await tester.pumpAndSettle();
      await tester.tap(track);
      await tester.pumpAndSettle();
      expect(c.profile!.goal, Goal.period);
      expect(c.profile!.cycleStarts, ['2026-11-25']);
    });

    testWidgets('the log calls it bleeding after birth, not a period', (tester) async {
      final l = lookupL10n(const Locale('en'));
      await _pump(tester, _profile('en'), Brightness.light,
          (c) => LogScreen(controller: c, today: _today, date: _today, onDateChanged: (_) {}));
      expect(find.text(l.ppBleedingSection), findsOneWidget);
      expect(find.text(l.ppBleedingNote), findsOneWidget);
      expect(find.text(l.sectionPeriod), findsNothing);
    });
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      testWidgets('postpartum shots ($lang ${b.name})', (tester) async {
        final l = lookupL10n(Locale(lang));
        await _pump(tester, _profile(lang), b, _todayFor);
        await _reveal(tester, find.text(l.ppGuideEyebrow));
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/today_${lang}_${b.name}.png'));
        await _reveal(tester, find.text(l.ppPeriodBackAction));
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/today_more_${lang}_${b.name}.png'));
        await tester.tap(find.text(l.ppPeriodBackAction));
        await tester.pumpAndSettle();
        await tester.tap(find.text('25'));
        await tester.pumpAndSettle();
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/period_back_${lang}_${b.name}.png'));
      });
    }
  }
}
