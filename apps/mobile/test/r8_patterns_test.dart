// R8.5 + R10.4: her patterns. Counts of what she logged against her own complete cycles, with
// the minimums, the 5-day window and the variation note from the register (MR-58, MR-59).
// With --update-goldens it writes proof shots (390x844 at 2x, EN and AR, light and dark) to
// testing-results/2026-11-26-r8-patterns/ (synthetic fixture).

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/dates.dart';
import 'package:femio/domain/patterns.dart';
import 'package:femio/features/calendar/calendar_screen.dart';
import 'package:femio/features/calendar/patterns_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-26-r8-patterns';
const _today = '2026-11-26';

/// Period starts from [first] with these cycle [lengths]; each period bleeds [bleed] days.
/// The last start is the cycle still running.
List<String> _starts(String first, List<int> lengths) {
  final out = [first];
  for (final n in lengths) {
    out.add(addDays(out.last, n));
  }
  return out;
}

List<String> _bleeds(List<String> starts, {int bleed = 5}) => [
      for (final s in starts)
        for (var d = 0; d < bleed; d++) addDays(s, d),
    ];

/// Cramps on the first two period days of every complete cycle, a headache 2 days before each
/// next period, bloating once the day before the second period, and an ovulation test and a temperature in the first cycle.
Map<String, DayLog> _logs(List<String> starts) {
  final logs = <String, DayLog>{};
  void add(String day, List<String> terms, {String? opk, double? bbt}) {
    final old = logs[day];
    logs[day] = DayLog(terms: [...?old?.terms, ...terms], opk: opk ?? old?.opk, bbt: bbt ?? old?.bbt);
  }

  for (var i = 0; i + 1 < starts.length; i++) {
    add(starts[i], ['cramps']);
    add(addDays(starts[i], 1), ['cramps']);
    add(addDays(starts[i + 1], -2), ['headache']);
  }
  add(addDays(starts[0], 10), const [], opk: 'positive', bbt: 36.6);
  add(addDays(starts[1], -1), ['bloating']);
  return logs;
}

Profile _profile(String lang, {Goal goal = Goal.ttc, List<String>? starts, Map<String, DayLog>? logs}) {
  final s = starts ?? _starts('2026-06-20', [28, 30, 27, 29, 31]);
  return Profile(
    goal: goal,
    locale: lang,
    birthYear: 1994,
    periodStarts: _bleeds(s),
    cycleLength: 28,
    logs: logs ?? _logs(s),
    settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
  );
}

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

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  group('counts (MR-58)', () {
    test('complete cycles leave out the one still running and keep each bleed length', () {
      final cycles = completeCycles(_profile('en'));
      expect(cycles.map((c) => c.length), [28, 30, 27, 29, 31]);
      expect(cycles.every((c) => c.bleedDays == 5), isTrue);
      expect(cycles.first.start, '2026-06-20');
    });

    test('only the most recent 12 complete cycles are read', () {
      final s = _starts('2025-01-01', List.filled(15, 28));
      expect(completeCycles(_profile('en', starts: s, logs: const {})).length, patternRecentCycles);
    });

    test('"before your period" is exactly the 5 days before the next start', () {
      const c = CycleSpan('2026-01-01', 28, 5);
      expect(c.nextStart, '2026-01-29');
      expect(c.inPhase('2026-01-24', CyclePhase.beforePeriod), isTrue);
      expect(c.inPhase('2026-01-28', CyclePhase.beforePeriod), isTrue);
      expect(c.inPhase('2026-01-23', CyclePhase.beforePeriod), isFalse);
      expect(c.inPhase('2026-01-29', CyclePhase.beforePeriod), isFalse);
      expect(c.inPhase('2026-01-05', CyclePhase.period), isTrue);
      expect(c.inPhase('2026-01-06', CyclePhase.period), isFalse);
      expect(c.contains('2026-01-28'), isTrue);
      expect(c.contains('2026-01-29'), isFalse);
    });

    test('statements: seen in N of M cycles, most cycles first, one cycle is not a pattern', () {
      final c = cyclePatterns(_profile('en'));
      expect(c.loggedCycles, 5);
      expect(c.hasRange && c.hasCounts, isTrue);
      final s = c.statements;
      expect(s.map((x) => (x.term, x.phase, x.seen, x.cycles)), [
        ('cramps', CyclePhase.period, 5, 5),
        ('headache', CyclePhase.beforePeriod, 5, 5),
      ]);
      expect(c.counts.any((x) => x.term == 'bloating' && x.phase == CyclePhase.beforePeriod && x.seen == 1), isTrue);
      expect(s.any((x) => x.term == 'bloating'), isFalse);
    });

    test('a term logged twice in one cycle counts that cycle once', () {
      final c = cyclePatterns(_profile('en'));
      expect(c.counts.firstWhere((x) => x.term == 'cramps').seen, 5);
    });

    test('a cycle she logged nothing in does not count toward M', () {
      final s = _starts('2026-06-20', [28, 30, 27, 29, 31]);
      final logs = _logs(s)..removeWhere((day, _) => day.compareTo(s[1]) < 0);
      // Cycle 1 now has nothing, except the headache logged 2 days before s[1] (still in cycle 1).
      logs.remove(addDays(s[1], -2));
      final c = cyclePatterns(_profile('en', starts: s, logs: logs));
      expect(c.cycles.length, 5);
      expect(c.loggedCycles, 4);
      expect(c.counts.firstWhere((x) => x.term == 'cramps').cycles, 4);
    });

    test('minimums: the range needs 2 complete cycles, counts need 3 logged ones', () {
      final one = cyclePatterns(_profile('en', starts: _starts('2026-10-01', [28])));
      expect(one.hasRange, isFalse);
      expect(one.statements, isEmpty);
      final two = cyclePatterns(_profile('en', starts: _starts('2026-09-01', [28, 29])));
      expect(two.hasRange, isTrue);
      expect(two.hasCounts, isFalse);
      expect(two.statements, isEmpty);
      expect(two.varies, isFalse);
    });

    test('per-cycle details, newest first, count ovulation tests read high or positive and temperatures', () {
      final d = cyclePatterns(_profile('en')).details;
      expect(d.first.span.length, 31);
      expect(d.last.span.start, '2026-06-20');
      expect(d.last.opkPositiveDays, 1);
      expect(d.last.temperatures, 1);
      expect(d.last.daysLogged, 5);
      expect(d.first.opkPositiveDays, 0);
    });
  });

  group('variation note (MR-59)', () {
    test('steady cycles inside 24 to 38 days: no note', () {
      expect(cyclePatterns(_profile('en')).varies, isFalse);
    });

    test('a spread over 9 days: note', () {
      expect(cyclePatterns(_profile('en', starts: _starts('2026-05-01', [26, 36, 28]))).varies, isTrue);
    });

    test('a spread of exactly 9 days: no note', () {
      expect(cyclePatterns(_profile('en', starts: _starts('2026-05-01', [26, 35, 28]))).varies, isFalse);
    });

    test('one cycle under 24 or over 38 days: note', () {
      expect(cyclePatterns(_profile('en', starts: _starts('2026-05-01', [23, 25, 26]))).varies, isTrue);
      expect(cyclePatterns(_profile('en', starts: _starts('2026-05-01', [39, 35, 36]))).varies, isTrue);
    });

    test('the note waits for 3 complete cycles', () {
      expect(cyclePatterns(_profile('en', starts: _starts('2026-08-01', [22, 40]))).varies, isFalse);
    });
  });

  group('recent counts for pregnancy and menopause', () {
    test('counts days per term inside the last 90 days only, most days first', () {
      final logs = {
        '2026-11-26': const DayLog(terms: ['hotFlashes', 'tired']),
        '2026-11-20': const DayLog(terms: ['hotFlashes']),
        '2026-08-29': const DayLog(terms: ['hotFlashes']), // day 90 counting today
        '2026-08-28': const DayLog(terms: ['tired']), // day 91: left out
      };
      final r = recentTermDays(_profile('en', goal: Goal.menopause, logs: logs), _today);
      expect(r, [(term: 'hotFlashes', days: 3), (term: 'tired', days: 1)]);
    });
  });

  group('screen', () {
    testWidgets('a cycle goal sees the range, the statements and no verdict', (tester) async {
      await _pump(tester, _profile('en'), Brightness.light, (c) => PatternsScreen(controller: c, today: _today));
      final l = lookupL10n(const Locale('en'));
      expect(find.text(l.patRange(5, 27, 31)), findsOneWidget);
      expect(find.textContaining('5 of 5 cycles'), findsNWidgets(2));
      expect(find.text(l.patVaries), findsNothing);
      await tester.scrollUntilVisible(find.text(l.patNoVerdict), 300, scrollable: find.byType(Scrollable).first);
      expect(find.text(l.patNoVerdict), findsOneWidget);
    });

    testWidgets('varying cycles show the variation note with its source', (tester) async {
      await _pump(tester, _profile('en', starts: _starts('2026-05-01', [26, 36, 28])), Brightness.light,
          (c) => PatternsScreen(controller: c, today: _today));
      final l = lookupL10n(const Locale('en'));
      expect(find.text(l.patVaries), findsOneWidget);
      expect(find.text(l.patVariesSource), findsOneWidget);
    });

    testWidgets('too few cycles say what is needed, not a guess', (tester) async {
      await _pump(tester, _profile('en', starts: _starts('2026-10-01', [28])), Brightness.light,
          (c) => PatternsScreen(controller: c, today: _today));
      final l = lookupL10n(const Locale('en'));
      expect(find.text(l.patNeedCycles(1)), findsOneWidget);
      expect(find.text(l.patNeedLogged), findsOneWidget);
    });

    testWidgets('pregnancy sees the last 90 days, never cycles', (tester) async {
      final logs = {'2026-11-25': const DayLog(terms: ['nausea']), '2026-11-24': const DayLog(terms: ['nausea'])};
      await _pump(tester, _profile('en', goal: Goal.pregnant, logs: logs), Brightness.light,
          (c) => PatternsScreen(controller: c, today: _today));
      final l = lookupL10n(const Locale('en'));
      expect(find.text(l.patRecent), findsOneWidget);
      expect(find.text(l.patDays(2)), findsOneWidget);
      expect(find.text(l.patCycleLength), findsNothing);
    });

    testWidgets('the Calendar links to Patterns', (tester) async {
      await _pump(tester, _profile('en'), Brightness.light,
          (c) => Scaffold(body: CalendarScreen(controller: c, today: _today, onDay: (_) {})));
      final l = lookupL10n(const Locale('en'));
      await tester.scrollUntilVisible(find.text(l.patOpen), 300, scrollable: find.byType(Scrollable).first);
      await tester.ensureVisible(find.text(l.patOpen));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.patOpen));
      await tester.pumpAndSettle();
      expect(find.byType(PatternsScreen), findsOneWidget);
    });
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      testWidgets('pattern shots ($lang ${b.name})', (tester) async {
        final l = lookupL10n(Locale(lang));
        await _pump(tester, _profile(lang, starts: _starts('2026-05-15', [27, 36, 26, 30, 28, 31])), b,
            (c) => PatternsScreen(controller: c, today: _today));
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/patterns_${lang}_${b.name}.png'));
        await tester.scrollUntilVisible(find.text(l.patEachCycle), 300, scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/patterns_cycles_${lang}_${b.name}.png'));
      });
    }
  }
}
