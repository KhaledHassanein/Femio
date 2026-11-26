// R8.20: the menopause stage while periods still come and after they stop (MR-61). Ranges stay
// while her last period started less than a year ago, never a fertile window; any bleeding
// after a year without one raises a caution to see a doctor; Patterns and the visit summary
// count each symptom month by month; the visit summary lists her current medicines. With
// --update-goldens it writes proof shots (390x844 at 2x, EN and AR, light and dark) to
// testing-results/2026-11-26-r8-perimenopause/ (synthetic fixture).

import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/library.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/assistant/visit_summary.dart';
import 'package:femio/domain/day_marks.dart';
import 'package:femio/domain/health_record.dart';
import 'package:femio/domain/perimenopause.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:femio/features/assistant/visit_pack.dart';
import 'package:femio/features/assistant/visit_summary_screen.dart';
import 'package:femio/features/calendar/patterns_screen.dart';
import 'package:femio/features/log/log_screen.dart';
import 'package:femio/features/today/today_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:femio/widgets/monthly_terms_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-26-r8-perimenopause';
const _today = '2026-11-26';

final _content = {
  for (final loc in ['en', 'ar', 'fr', 'es']) 'assets/content/$loc.json': File('assets/content/$loc.json').readAsStringSync(),
};
Library _library() => Library(load: (path) async => _content[path]!);

final _hrt = RecordEntry.create(
  id: 'm1',
  kind: RecordKind.medicine,
  title: 'Estradiol gel',
  happenedOn: '2026-09-01',
  addedOn: '2026-09-01T09:00:00',
  fields: const {RecordField.dose: '1 pump'},
);
final _old = RecordEntry.create(
  id: 'm2',
  kind: RecordKind.medicine,
  title: 'Antibiotic',
  happenedOn: '2026-08-01',
  addedOn: '2026-08-01T09:00:00',
  fields: const {RecordField.endedOn: '2026-08-08'},
);

/// Periods still coming, further apart; hot flushes most months, night sweats lately.
Profile _peri(String lang) => Profile(
      goal: Goal.menopause,
      locale: lang,
      birthYear: 1977,
      periodStarts: const ['2026-05-04', '2026-05-05', '2026-06-20', '2026-08-15', '2026-10-20', '2026-10-21'],
      logs: {
        for (final d in ['2026-06-03', '2026-06-11', '2026-07-08', '2026-08-02', '2026-08-09', '2026-08-23', '2026-09-14',
          '2026-10-05', '2026-10-06', '2026-11-02', '2026-11-12', '2026-11-20'])
          d: DayLog(terms: d.startsWith('2026-1') ? const ['hotFlashes', 'nightSweats'] : const ['hotFlashes']),
        '2026-11-21': const DayLog(terms: ['heartFlutters']),
        '2026-12-01': const DayLog(terms: ['hotFlashes']),
      },
      record: [_hrt, _old],
      settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
    );

/// A year and more without a period, then spotting last week.
Profile _after(String lang, {bool spot = true, bool overYear = false, List<String> starts = const ['2025-08-01']}) =>
    Profile(
      goal: Goal.menopause,
      locale: lang,
      birthYear: 1972,
      periodStarts: starts,
      lastPeriodOverYear: overYear,
      logs: {if (spot) '2026-11-20': const DayLog(flow: 'spotting')},
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
    builder: (context, child) => AssistantScope(bridge: const OfflineAssistant(), child: child!),
    home: home(c),
  ));
  await tester.pumpAndSettle();
  return c;
}

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
    await initializeDateFormatting();
  });

  group('ranges while periods still come (MR-61)', () {
    test('ranges show only for menopause, and only within a year of the last period', () {
      expect(menopauseShowsRanges(_peri('en'), _today), isTrue);
      expect(menopauseShowsRanges(_peri('en'), '2027-10-20'), isFalse);
      expect(menopauseShowsRanges(_after('en'), _today), isFalse);
      expect(menopauseShowsRanges(_peri('en').copyWith(goal: Goal.period), _today), isFalse);
    });

    test('the calendar draws the predicted period, never a fertile window', () {
      final marks = dayMarks(_peri('en'), today: _today, from: _today, to: '2027-03-31');
      expect(marks.values.any((m) => m.predicted), isTrue);
      expect(marks.values.any((m) => m.fertile || m.ovulation), isFalse);
    });

    test('months since her last period', () {
      expect(monthsSinceLastPeriod(_peri('en'), _today), 1);
      expect(monthsSinceLastPeriod(_after('en', starts: const []), _today), isNull);
    });
  });

  group('bleeding after a year without one', () {
    test('spotting counts', () => expect(bleedAfterYear(_after('en'), _today), '2026-11-20'));

    test('a gap under a year is not flagged', () {
      expect(bleedAfterYear(_after('en', starts: const ['2026-01-10']), _today), isNull);
    });

    test('her onboarding answer "over a year" counts when no earlier period is logged', () {
      expect(bleedAfterYear(_after('en', starts: const [], overYear: true), _today), '2026-11-20');
      expect(bleedAfterYear(_after('en', starts: const []), _today), isNull);
    });

    test('the caution lasts a year from that bleed, then goes', () {
      expect(bleedAfterYear(_after('en'), '2027-11-19'), '2026-11-20');
      expect(bleedAfterYear(_after('en'), '2027-11-20'), isNull);
    });

    test('only for the menopause stage; no bleed, no caution', () {
      expect(bleedAfterYear(_after('en').copyWith(goal: Goal.period), _today), isNull);
      expect(bleedAfterYear(_after('en', spot: false), _today), isNull);
    });
  });

  group('month by month', () {
    test('six calendar months, oldest first, most days first, future days left out', () {
      final m = monthlyTermDays(_peri('en'), _today);
      expect(m.months, ['2026-06', '2026-07', '2026-08', '2026-09', '2026-10', '2026-11']);
      expect(m.rows.first.term, 'hotFlashes');
      expect(m.rows.first.days, [2, 1, 3, 1, 2, 3]);
      final sweats = m.rows.firstWhere((r) => r.term == 'nightSweats');
      expect(sweats.days, [0, 0, 0, 0, 2, 3]);
      expect(m.rows.last.term, 'heartFlutters');
    });

    test('the visit summary carries the months, the table and her current medicines only', () {
      final s = visitSummary(_peri('en'), _today);
      expect(s.monthsSinceLastPeriod, 1);
      expect(s.monthly!.rows.first.term, 'hotFlashes');
      expect([for (final e in s.currentMedicines) e.title], ['Estradiol gel']);
      expect(s.factsInEnglish(), isNot(contains('Estradiol')), reason: 'the model never sees her record');
      final cycling = visitSummary(_peri('en').copyWith(goal: Goal.period), _today);
      expect(cycling.monthly, isNull);
      expect(cycling.monthsSinceLastPeriod, isNull);
    });

    test('the pack text lists months, the monthly counts and the medicines', () {
      final l = lookupL10n(const Locale('en'));
      final text = visitPackText(l,
          locale: 'en', today: _today, summary: visitSummary(_peri('en'), _today), mine: const [], suggested: const []);
      expect(text, contains(l.menoMonths(1)));
      expect(text, contains(l.patMonthly));
      expect(text, contains('Jun 2'));
      expect(text, contains(l.visitMedicines));
      expect(text, contains('Estradiol gel · '));
      expect(text, contains('1 pump'), reason: 'the dose as she wrote it, direction-isolated');
      expect(text, isNot(contains('Antibiotic')));
    });
  });

  group('screens', () {
    testWidgets('Today: months, the next range with its note', (tester) async {
      final l = lookupL10n(const Locale('en'));
      await _pump(tester, _peri('en'), Brightness.light, _todayFor);
      expect(find.text(l.menoMonths(1)), findsOneWidget);
      expect(find.text(l.menoRangeNote), findsOneWidget);
      expect(find.text(l.menoBleedHeading), findsNothing);
    });

    testWidgets('Today after a year: the bleeding caution and the reviewed guide', (tester) async {
      final l = lookupL10n(const Locale('en'));
      await _pump(tester, _after('en'), Brightness.light, _todayFor);
      expect(find.text(l.menoRangeNote), findsNothing);
      await _reveal(tester, find.text(l.menoBleedHeading));
      expect(find.text(l.menoBleedHeading), findsOneWidget);
      expect(find.text(l.menoBleedMore), findsOneWidget);
    });

    testWidgets('the log says any bleeding after a year needs a doctor', (tester) async {
      final l = lookupL10n(const Locale('en'));
      await _pump(tester, _peri('en'), Brightness.light,
          (c) => LogScreen(controller: c, today: _today, date: _today, onDateChanged: (_) {}));
      expect(find.text(l.menoBleedLogNote), findsOneWidget);
    });

    testWidgets('Patterns shows the month table for menopause', (tester) async {
      await _pump(tester, _peri('en'), Brightness.light, (c) => PatternsScreen(controller: c, today: _today));
      expect(find.byType(MonthlyTermsTable), findsOneWidget);
      expect(find.text('Jun'), findsOneWidget);
    });

    testWidgets('the visit summary shows the month table and her medicines', (tester) async {
      final l = lookupL10n(const Locale('en'));
      await _pump(tester, _peri('en'), Brightness.light, (c) => VisitSummaryScreen(controller: c, today: _today));
      Future<void> drag(Finder f) async {
        await tester.dragUntilVisible(f, find.byType(ListView), const Offset(0, -200));
        await tester.pumpAndSettle();
      }
      await drag(find.byType(MonthlyTermsTable));
      expect(find.byType(MonthlyTermsTable), findsOneWidget);
      await drag(find.text(l.visitMedicines));
      await drag(find.textContaining('1 pump'));
      expect(find.textContaining('Antibiotic'), findsNothing);
    });

    test('the reviewed guide on bleeding after menopause exists in all four languages', () {
      for (final path in _content.keys) {
        expect(_content[path]!.contains('"slug":"$postmenopausalBleedingGuide"') ||
            _content[path]!.contains('"slug": "$postmenopausalBleedingGuide"'), isTrue, reason: path);
      }
    });
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      testWidgets('perimenopause shots ($lang ${b.name})', (tester) async {
        final l = lookupL10n(Locale(lang));
        await _pump(tester, _peri(lang), b, _todayFor);
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/today_${lang}_${b.name}.png'));
        await _pump(tester, _peri(lang), b, (c) => PatternsScreen(controller: c, today: _today));
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/patterns_${lang}_${b.name}.png'));
        await _pump(tester, _after(lang), b, _todayFor);
        await _reveal(tester, find.text(l.menoBleedHeading));
        await tester.drag(find.byType(Scrollable).first, const Offset(0, 320));
        await tester.pumpAndSettle();
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/bleed_${lang}_${b.name}.png'));
      });
    }
  }
}
