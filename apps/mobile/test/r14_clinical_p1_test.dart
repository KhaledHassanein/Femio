// R14.11: clinical P1 fixes from the 2026-11-26 audit (CLIN-8 to CLIN-13). The day note
// runs the safety rules; the after-birth mood check-in names the sign that needs help now;
// perimenopause "Not sure" claims no month; the test card gives the NHS 21-day rule when
// no day can be named; a long gap gets the MR-10 prompt; the pregnancy warning list has
// CDC Hear Her's signs. With --update-goldens it writes proof shots (390x844 at 2x, EN and
// AR, light and dark) to testing-results/2026-11-27-r14-clinical/ (synthetic fixture).

import 'package:femio/app.dart';
import 'package:femio/data/library.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/absent_period.dart';
import 'package:femio/domain/assistant/safety.dart';
import 'package:femio/domain/cycle_prediction.dart';
import 'package:femio/domain/red_flags.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:femio/features/help/red_flags_screen.dart';
import 'package:femio/features/log/log_screen.dart';
import 'package:femio/features/today/test_timing_card.dart';
import 'package:femio/features/today/today_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-27-r14-clinical';
const _today = '2026-11-26';

AppSettings _settings(String lang) =>
    AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false, assistantOn: false);

Future<FemioController> _pump(WidgetTester tester, Profile p, Widget Function(FemioController) home,
    {Brightness b = Brightness.light, double height = 1688}) async {
  tester.view.physicalSize = Size(780, height);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  final c = FemioController(MemoryStore(p), initialLocale: p.locale);
  await c.load();
  await tester.pumpWidget(AssistantScope(
    bridge: const OfflineAssistant(),
    child: MaterialApp(
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
    ),
  ));
  await tester.pumpAndSettle();
  return c;
}

Widget _todayFor(FemioController c) => TodayScreen(controller: c, today: _today, library: Library(load: (_) async => '[]'));

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });
  final l = lookupL10n(const Locale('en'));

  group('CLIN-12 the day note runs the safety rules', () {
    Profile noted(String note) => Profile(
          goal: Goal.period,
          locale: 'en',
          birthYear: 1994,
          periodStarts: const ['2026-11-20'],
          cycleLength: 28,
          logs: {_today: DayLog(note: note)},
          settings: _settings('en'),
        );

    testWidgets('a crisis line in the note shows the crisis card with Help now', (tester) async {
      await _pump(tester, noted('honestly I want to die'),
          (c) => Scaffold(body: LogScreen(controller: c, today: _today, date: _today, onDateChanged: (_) {})),
          height: 4000);
      await tester.scrollUntilVisible(find.text(l.logNoteSaved), 300, scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      expect(find.text(l.safetyCrisisHeading), findsOneWidget);
      expect(find.text(l.helpNowLauncher), findsOneWidget);
    });

    testWidgets('a pill reminder is not a birth-control question', (tester) async {
      expect(safetySignalFor('which contraception is best', noted('x'), _today), SafetySignal.birthControl);
      await _pump(tester, noted('which contraception is best'),
          (c) => Scaffold(body: LogScreen(controller: c, today: _today, date: _today, onDateChanged: (_) {})),
          height: 4000);
      await tester.scrollUntilVisible(find.text(l.logNoteSaved), 300, scrollable: find.byType(Scrollable).first);
      expect(find.text(l.safetyBirthControl), findsNothing);
    });

    testWidgets('an ordinary note shows nothing', (tester) async {
      await _pump(tester, noted('argued with my sister'),
          (c) => Scaffold(body: LogScreen(controller: c, today: _today, date: _today, onDateChanged: (_) {})),
          height: 4000);
      await tester.scrollUntilVisible(find.text(l.logNoteSaved), 300, scrollable: find.byType(Scrollable).first);
      expect(find.text(l.safetyCrisisHeading), findsNothing);
      expect(find.text(l.safetyUrgentHeading), findsNothing);
    });
  });

  testWidgets('CLIN-11 the after-birth mood check-in names harmful thoughts and opens Help now', (tester) async {
    await _pump(
      tester,
      Profile(goal: Goal.pregnant, locale: 'en', birthYear: 1994, edd: '2026-11-10', birthDate: '2026-11-08', settings: _settings('en')),
      _todayFor,
      height: 6000,
    );
    expect(find.text(l.ppMoodCrisis), findsOneWidget);
    expect(l.safetyPostpartumBody, contains('thoughts of harming yourself or your baby'));
  });

  testWidgets('CLIN-13 perimenopause "Not sure" claims no month', (tester) async {
    await _pump(tester, Profile(goal: Goal.menopause, locale: 'en', birthYear: 1975, settings: _settings('en')), _todayFor);
    expect(find.text(l.menoNoDate), findsOneWidget);
    expect(find.text(l.menoMonths(0)), findsNothing);
  });

  testWidgets('CLIN-8 with no day to name, the card gives the 21-day rule (MR-21)', (tester) async {
    final pred = predictNextPeriod(const ['2026-06-01', '2026-06-25', '2026-08-10', '2026-09-05'], null)!;
    expect(pred.irregular, isTrue);
    await _pump(tester, Profile(goal: Goal.ttc, locale: 'en', settings: _settings('en')),
        (c) => Scaffold(body: TestTimingCard(prediction: pred, date: (s) => s)));
    expect(find.textContaining(l.testTimingUnknown), findsOneWidget);
    expect(l.testTimingUnknown, contains('21 days'));
  });

  group('CLIN-9 MR-10 a long gap gets a calm next step', () {
    Profile gap(String last) => Profile(
          goal: Goal.period,
          locale: 'en',
          birthYear: 1994,
          periodStarts: [last],
          cycleLength: 28,
          settings: _settings('en'),
        );

    test('from 90 days, never in the year after a birth', () {
      expect(periodAbsentFor(gap('2026-08-28'), _today), isTrue);
      expect(periodAbsentFor(gap('2026-08-29'), _today), isFalse);
    });

    testWidgets('Today shows the card, with no count of days', (tester) async {
      await _pump(tester, gap('2026-08-01'), _todayFor, height: 4000);
      expect(find.text(l.absentTitle), findsOneWidget);
      expect(l.absentBody, isNot(contains('days')));
    });

    testWidgets('not before 90 days', (tester) async {
      await _pump(tester, gap('2026-11-01'), _todayFor, height: 4000);
      expect(find.text(l.absentTitle), findsNothing);
    });
  });

  testWidgets('CLIN-10 the warning list carries CDC Hear Her\'s pregnancy signs', (tester) async {
    tester.view.physicalSize = const Size(1170, 8000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: FemioTheme.light(),
      localizationsDelegates: const [L10n.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
      supportedLocales: const [Locale('en')],
      home: const RedFlagsScreen(),
    ));
    await tester.pumpAndSettle();
    expect(RedFlagSymptom.values, hasLength(16));
    for (final s in [l.redFlagDizziness, l.redFlagFever, l.redFlagChestPain, l.redFlagHarmThoughts, l.redFlagLimb]) {
      expect(find.text(s), findsOneWidget);
    }
    expect(l.pregRedFlagsBody, contains('thoughts of harming yourself or your baby'));
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      testWidgets('proof shots ($lang ${b.name})', (tester) async {
        await _pump(
          tester,
          Profile(goal: Goal.period, locale: lang, birthYear: 1994, periodStarts: const ['2026-08-01'], cycleLength: 28, settings: _settings(lang)),
          _todayFor,
          b: b,
        );
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/absent_${lang}_${b.name}.png'));
        await tester.pumpWidget(const SizedBox());
        await _pump(
          tester,
          Profile(goal: Goal.pregnant, locale: lang, birthYear: 1994, edd: '2026-11-10', birthDate: '2026-11-08', settings: _settings(lang)),
          _todayFor,
          b: b,
        );
        final ll = lookupL10n(Locale(lang));
        await tester.scrollUntilVisible(find.text(ll.ppMoodCrisis), 300, scrollable: find.byType(Scrollable).first);
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/mood_${lang}_${b.name}.png'));
      });
    }
  }
}
