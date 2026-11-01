// The seven fixes from the design review's "before the closed test" list, each pinned
// by a test that fails if the fix is undone:
//   1. pregnancy Today shows the term window, never "days to go" / "days overdue" (MR-02)
//   2. the lock screen reaches Help now without unlocking (MR-38)
//   3. trying to conceive with irregular or "not sure" cycles gets the honest hero
//   4. Settings can change her goal and due date, and her records survive (rule 5)
//   5. "My period started today" can be undone, restoring the exact previous day
//   6. wording: "Ovulation likely around", "can give an accurate result"
//   7. the privacy policy row opens the right page, or shows the address to copy
//
// Data is synthetic. Dates are in 2026-2027; no person.

import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/dates.dart';
import 'package:femio/domain/pregnancy.dart';
import 'package:femio/features/help/help_now_screen.dart';
import 'package:femio/features/lock/pin_field.dart';
import 'package:femio/features/settings/my_details_section.dart';
import 'package:femio/features/settings/privacy_policy_link.dart';
import 'package:femio/features/settings/settings_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show DateFormat;

const _today = '2026-10-08';

/// Starts the whole app on [profile] at a 390×844 phone.
Future<FemioController> _app(WidgetTester t, Profile profile, {bool locked = false}) async {
  t.view.physicalSize = const Size(780, 1688);
  t.view.devicePixelRatio = 2;
  addTearDown(t.view.reset);
  final c = FemioController(MemoryStore(profile));
  await c.load();
  if (locked) {
    // PBKDF2 yields to the event loop, which the fake clock never advances.
    await t.runAsync(() => c.setPin('2468'));
    c.locked = true;
  }
  await t.pumpWidget(FemioApp(controller: c, today: _today));
  if (locked) {
    // The PIN field's caret blinks forever, so pumpAndSettle would never return.
    await t.pump(const Duration(milliseconds: 400));
  } else {
    await t.pumpAndSettle();
  }
  return c;
}

/// One screen in a plain MaterialApp, with all four languages' delegates.
Future<void> _screen(WidgetTester t, Widget home, {String lang = 'en'}) async {
  t.view.physicalSize = const Size(780, 1688);
  t.view.devicePixelRatio = 2;
  addTearDown(t.view.reset);
  await t.pumpWidget(
    MaterialApp(
      theme: FemioTheme.light(),
      locale: Locale(lang),
      supportedLocales: [for (final code in supportedLanguages) Locale(code)],
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: home,
    ),
  );
  await t.pumpAndSettle();
}

Profile _ttc(String lang, {bool irregular = false, int? cycleLength, List<String> starts = const ['2026-09-21']}) =>
    Profile(
      goal: Goal.ttc,
      locale: lang,
      birthYear: 1996,
      periodStarts: starts,
      cycleLength: cycleLength,
      irregular: irregular,
    );

String _short(String lang, String iso) => DateFormat.MMMd(lang).format(fromISO(iso));

/// Real fonts: the default test font is as wide as it is tall, which overflows rows that
/// fit on a phone (the Arabic test-timing title), so layout would fail for the wrong reason.
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
  final sdk = Platform.environment['FLUTTER_ROOT'] ?? '/root/sdk/flutter';
  await load('MaterialIcons', ['$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf']);
}

void main() {
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  group('1 · pregnancy Today: the term window replaces the counters', () {
    test('termWindow is 37w0d to 42w0d, 21 days before and 14 days after the due date', () {
      final w = termWindow('2027-05-12')!;
      expect(w.start, '2027-04-21'); // the design spec's own worked example
      expect(w.end, '2027-05-26');
      expect(diffDays(addDays('2027-05-12', -280), w.start), 37 * 7);
      expect(diffDays(addDays('2027-05-12', -280), w.end), 42 * 7);
    });

    test('an invalid date has no window', () {
      expect(termWindow('not a date'), isNull);
      expect(termWindow('2027-02-30'), isNull);
    });

    test('over term begins the day after 42w0d, and only then', () {
      const edd = '2026-09-01';
      expect(isOverTerm(pregnancyProgress(edd, addDays(edd, 14))!), isFalse); // 42w0d
      expect(isOverTerm(pregnancyProgress(edd, addDays(edd, 15))!), isTrue); // 42w1d
      expect(isOverTerm(pregnancyProgress(edd, edd)!), isFalse);
    });

    for (final lang in ['en', 'ar', 'fr', 'es']) {
      testWidgets('inside term: the window sentence, no counter ($lang)', (t) async {
        final l = lookupL10n(Locale(lang));
        await _app(t, Profile(goal: Goal.pregnant, locale: lang, birthYear: 1993, edd: '2027-02-10'));
        expect(
          find.text(
            l.pregTermWindow(_short(lang, '2027-02-10'), _short(lang, '2027-01-20'), _short(lang, '2027-02-24')),
          ),
          findsOneWidget,
        );
        expect(find.text(l.pregPastTerm), findsNothing);
      });
    }

    testWidgets('mid-pregnancy shows no "days to go" in English', (t) async {
      await _app(t, Profile(goal: Goal.pregnant, locale: 'en', birthYear: 1993, edd: '2027-02-10'));
      expect(find.textContaining('to go'), findsNothing);
      expect(find.textContaining('past your due date'), findsNothing);
    });

    testWidgets('past 42 weeks: advice to talk to her midwife or doctor, no day count', (t) async {
      final l = lookupL10n(const Locale('en'));
      // Due 23 days ago: 303 days of pregnancy, inside the 315-day plausibility limit.
      await _app(t, Profile(goal: Goal.pregnant, locale: 'en', birthYear: 1993, edd: '2026-09-15'));
      expect(find.text(l.pregPastTerm), findsOneWidget);
      expect(find.textContaining('most babies arrive'), findsNothing);
      expect(find.textContaining('past your due date'), findsNothing);
      expect(find.textContaining('23'), findsNothing);
    });
  });

  group('2 · the lock screen reaches Help now without unlocking', () {
    testWidgets('the button opens Help now, the record stays locked, back returns to the PIN', (t) async {
      final l = lookupL10n(const Locale('en'));
      final c = await _app(t, _ttc('en', cycleLength: 28), locked: true);
      expect(find.byType(PinField), findsOneWidget);

      await t.tap(find.text(l.helpNowLauncher).last);
      await t.pump(const Duration(milliseconds: 500));
      expect(find.byType(HelpNowScreen), findsOneWidget);
      expect(find.text(l.helpNowImmediateHeading).hitTestable(), findsOneWidget);
      expect(c.locked, isTrue, reason: 'Help now must not unlock the record');
      // Her Today screen is mounted underneath but nothing of it can be reached.
      expect(find.text(l.todayTitle).hitTestable(), findsNothing);

      await t.pageBack();
      await t.pump(const Duration(milliseconds: 500));
      expect(find.byType(HelpNowScreen), findsNothing);
      expect(find.byType(PinField), findsOneWidget);
      expect(c.locked, isTrue);
    });

    testWidgets('the button is there in Arabic too', (t) async {
      final l = lookupL10n(const Locale('ar'));
      await _app(t, _ttc('ar', cycleLength: 28), locked: true);
      expect(find.text(l.helpNowLauncher).hitTestable(), findsOneWidget);
    });
  });

  group('3 · trying to conceive without a prediction', () {
    testWidgets('irregular cycles: no confident window, the clinician line, general test advice', (t) async {
      final l = lookupL10n(const Locale('en'));
      await _app(t, _ttc('en', irregular: true));
      expect(find.text(l.noConfidentWindowTitle), findsOneWidget);
      expect(find.text(l.noConfidentWindowBody), findsOneWidget);
      expect(find.text(l.seeClinicianIrregular), findsOneWidget);
      expect(find.text(l.testTimingGeneral), findsOneWidget);
      // Never a single date and never a late count.
      expect(find.text(l.noPredictionTitle), findsNothing);
      expect(find.textContaining('late'), findsNothing);
      expect(find.textContaining('Ovulation likely'), findsNothing);
    });

    testWidgets('"not sure" about the length: the same honest hero, without the irregular line', (t) async {
      final l = lookupL10n(const Locale('en'));
      await _app(t, _ttc('en')); // cycleLength null, irregular false
      expect(find.text(l.noConfidentWindowTitle), findsOneWidget);
      expect(find.text(l.seeClinicianIrregular), findsNothing);
      expect(find.text(l.testTimingGeneral), findsOneWidget);
    });

    testWidgets('a regular woman who has logged nothing is still asked to log her first period', (t) async {
      final l = lookupL10n(const Locale('en'));
      await _app(t, _ttc('en', cycleLength: 28, starts: const []));
      expect(find.text(l.noPredictionTitle), findsOneWidget);
      expect(find.text(l.noConfidentWindowTitle), findsNothing);
    });

    testWidgets('the Arabic screen shows the same strings', (t) async {
      final l = lookupL10n(const Locale('ar'));
      await _app(t, _ttc('ar', irregular: true));
      expect(find.text(l.noConfidentWindowTitle), findsOneWidget);
      expect(find.text(l.seeClinicianIrregular), findsOneWidget);
    });
  });

  group('4 · Settings changes the goal and the due date over the same record', () {
    Profile rich() => Profile(
      goal: Goal.ttc,
      locale: 'en',
      birthYear: 1996,
      periodStarts: const ['2026-08-24', '2026-09-21'],
      cycleLength: 28,
      logs: const {
        '2026-09-21': DayLog(flow: 'heavy', terms: ['cramps']),
        '2026-09-30': DayLog(opk: 'high', bbt: 36.7),
      },
    );

    test('changing the goal keeps every log, period and the rest of the record', () async {
      final c = FemioController(MemoryStore(rich()));
      await c.load();
      final before = c.profile!;
      await c.setGoal(Goal.pregnant, edd: '2027-03-01');
      final after = c.profile!;
      expect(after.goal, Goal.pregnant);
      expect(after.edd, '2027-03-01');
      expect(after.logs.keys, before.logs.keys);
      expect(after.logs['2026-09-21']!.flow, 'heavy');
      expect(after.logs['2026-09-30']!.bbt, 36.7);
      expect(after.periodStarts, before.periodStarts);
      expect(after.cycleLength, before.cycleLength);
      expect(after.birthYear, before.birthYear);
      // And it was saved: a fresh controller on the same store reads it back.
      final again = FemioController(c.store);
      await again.load();
      expect(again.profile!.goal, Goal.pregnant);
      expect(again.profile!.logs.length, 2);
    });

    test('going back keeps the due date on the record instead of deleting it', () async {
      final c = FemioController(MemoryStore(rich()));
      await c.load();
      await c.setGoal(Goal.pregnant, edd: '2027-03-01');
      await c.setGoal(Goal.period);
      expect(c.profile!.goal, Goal.period);
      expect(c.profile!.edd, '2027-03-01');
      expect(c.profile!.logs.length, 2);
    });

    test('pregnancy needs a due date', () async {
      final c = FemioController(MemoryStore(rich()));
      await c.load();
      expect(() => c.setGoal(Goal.pregnant), throwsArgumentError);
      expect(c.profile!.goal, Goal.ttc);
    });

    test('a new pregnancy after a birth ends the after-birth stage', () async {
      final c = FemioController(
        MemoryStore(rich().copyWith(goal: Goal.pregnant, edd: '2026-06-01', birthDate: '2026-06-03')),
      );
      await c.load();
      await c.setGoal(Goal.pregnant, edd: '2027-08-01');
      expect(c.profile!.birthDate, isNull);
      expect(c.profile!.edd, '2027-08-01');
    });

    test('setDueDate changes only the due date', () async {
      final c = FemioController(MemoryStore(rich().copyWith(goal: Goal.pregnant, edd: '2027-03-01')));
      await c.load();
      await c.setDueDate('2027-03-09');
      expect(c.profile!.edd, '2027-03-09');
      expect(c.profile!.goal, Goal.pregnant);
      expect(c.profile!.logs.length, 2);
    });

    testWidgets('the goal row switches to pregnant only after a due date is saved', (t) async {
      final l = lookupL10n(const Locale('en'));
      final c = FemioController(MemoryStore(rich()));
      await c.load();
      await _screen(t, SettingsScreen(controller: c, today: _today));

      await t.tap(find.text(l.settingsGoal));
      await t.pumpAndSettle();
      expect(find.text(l.settingsGoalNote), findsOneWidget);
      await t.tap(find.text(l.goalPregnant));
      await t.pumpAndSettle();

      // The due date screen is up and nothing has changed yet.
      expect(find.text(l.dueDateTitle), findsOneWidget);
      expect(c.profile!.goal, Goal.ttc);
      expect(_dueScreen(t).saveEnabled, isFalse);

      await t.tap(find.text('20'));
      await t.pumpAndSettle();
      expect(_dueScreen(t).saveEnabled, isTrue);
      await t.tap(find.text(l.saveLabel));
      await t.pumpAndSettle();

      expect(c.profile!.goal, Goal.pregnant);
      expect(c.profile!.edd, '2026-10-20');
      expect(c.profile!.logs.length, 2);
      // Back on Settings, the due date row now exists.
      expect(find.text(l.settingsDueDate), findsOneWidget);
    });

    testWidgets('the due date row edits the date and only the date', (t) async {
      final l = lookupL10n(const Locale('en'));
      final c = FemioController(MemoryStore(rich().copyWith(goal: Goal.pregnant, edd: '2026-10-25')));
      await c.load();
      await _screen(t, SettingsScreen(controller: c, today: _today));
      expect(find.text(l.settingsDueDate), findsOneWidget);

      await t.tap(find.text(l.settingsDueDate));
      await t.pumpAndSettle();
      await t.tap(find.text('27'));
      await t.pumpAndSettle();
      await t.tap(find.text(l.saveLabel));
      await t.pumpAndSettle();

      expect(c.profile!.edd, '2026-10-27');
      expect(c.profile!.goal, Goal.pregnant);
      expect(c.profile!.logs.length, 2);
    });

    testWidgets('no due date row unless she is pregnant', (t) async {
      final l = lookupL10n(const Locale('en'));
      final c = FemioController(MemoryStore(rich()));
      await c.load();
      await _screen(t, SettingsScreen(controller: c, today: _today));
      expect(find.text(l.settingsGoal), findsOneWidget);
      expect(find.text(l.settingsDueDate), findsNothing);
    });

    testWidgets('Arabic Settings shows the goal row', (t) async {
      final l = lookupL10n(const Locale('ar'));
      final c = FemioController(MemoryStore(rich().copyWith(locale: 'ar')));
      await c.load();
      await _screen(
        t,
        SettingsScreen(controller: c, today: _today),
        lang: 'ar',
      );
      expect(find.text(l.settingsGoal), findsOneWidget);
      expect(find.text(goalName(l, Goal.ttc)), findsOneWidget);
    });
  });

  group('5 · "My period started today" can be undone', () {
    testWidgets('Undo puts back the exact previous day, keeping what she had logged', (t) async {
      final l = lookupL10n(const Locale('en'));
      final previous = const DayLog(terms: ['cramps'], opk: 'low', bbt: 36.5);
      final c = await _app(
        t,
        Profile(
          goal: Goal.period,
          locale: 'en',
          birthYear: 1996,
          periodStarts: const ['2026-09-10'],
          cycleLength: 28,
          logs: {_today: previous},
        ),
      );
      await t.ensureVisible(find.text(l.logPeriodToday));
      await t.tap(find.text(l.logPeriodToday));
      await t.pump();
      await t.pump(const Duration(milliseconds: 400));

      // The tap wrote a medium flow and kept her symptoms, ovulation test and temperature.
      final logged = c.profile!.logs[_today]!;
      expect(logged.flow, 'medium');
      expect(logged.terms, ['cramps']);
      expect(logged.opk, 'low');
      expect(logged.bbt, 36.5);
      expect(find.text(l.undoAction), findsOneWidget);

      await t.tap(find.text(l.undoAction));
      await t.pump();
      final restored = c.profile!.logs[_today]!;
      expect(restored.flow, isNull);
      expect(restored.terms, ['cramps']);
      expect(restored.opk, 'low');
      expect(restored.bbt, 36.5);
      expect(c.profile!.periodStarts, ['2026-09-10']);
    });

    testWidgets('Undo on an empty day removes the log again', (t) async {
      final l = lookupL10n(const Locale('en'));
      final c = await _app(
        t,
        Profile(goal: Goal.period, locale: 'en', birthYear: 1996, periodStarts: const ['2026-09-10'], cycleLength: 28),
      );
      await t.ensureVisible(find.text(l.logPeriodToday));
      await t.tap(find.text(l.logPeriodToday));
      await t.pump();
      await t.pump(const Duration(milliseconds: 400));
      expect(c.profile!.periodStarts, contains(_today));

      await t.tap(find.text(l.undoAction));
      await t.pump();
      expect(c.profile!.logs.containsKey(_today), isFalse);
      expect(c.profile!.periodStarts, ['2026-09-10']);
    });

    testWidgets('a period start from onboarding survives log and undo', (t) async {
      final l = lookupL10n(const Locale('en'));
      // She told onboarding her period began today: a start with no day log.
      final c = await _app(
        t,
        Profile(goal: Goal.period, locale: 'en', birthYear: 1996, periodStarts: const [_today], cycleLength: 28),
      );
      await t.ensureVisible(find.text(l.logPeriodToday));
      await t.tap(find.text(l.logPeriodToday));
      await t.pump();
      await t.pump(const Duration(milliseconds: 400));
      await t.tap(find.text(l.undoAction));
      await t.pump();
      expect(c.profile!.periodStarts, [_today]);
      expect(c.profile!.logs.containsKey(_today), isFalse);
    });

    testWidgets('the Undo stays about eight seconds', (t) async {
      final l = lookupL10n(const Locale('en'));
      await _app(
        t,
        Profile(goal: Goal.period, locale: 'en', birthYear: 1996, periodStarts: const ['2026-09-10'], cycleLength: 28),
      );
      await t.ensureVisible(find.text(l.logPeriodToday));
      await t.tap(find.text(l.logPeriodToday));
      await t.pump();
      await t.pump(const Duration(milliseconds: 400));
      await t.pump(const Duration(seconds: 6));
      expect(find.text(l.undoAction), findsOneWidget);
      await t.pump(const Duration(seconds: 3));
      await t.pump(const Duration(milliseconds: 500));
      expect(find.text(l.undoAction), findsNothing);
    });
  });

  group('6 · wording', () {
    test('ovulation is "around" in every language, never a bare "likely ovulation"', () {
      expect(lookupL10n(const Locale('en')).predictionOvulation('Oct 12'), 'Ovulation likely around Oct 12');
      expect(lookupL10n(const Locale('ar')).predictionOvulation('12 أكتوبر'), contains('حوالي'));
      expect(lookupL10n(const Locale('fr')).predictionOvulation('12 oct.'), contains('vers le'));
      expect(lookupL10n(const Locale('es')).predictionOvulation('12 oct'), contains('alrededor del'));
    });

    test('the test-timing sentence makes no reliability promise', () {
      final en = lookupL10n(const Locale('en')).testTimingBody('Oct 12');
      expect(en, contains('most home pregnancy tests can give an accurate result from that day'));
      expect(en, isNot(contains('reliable')));
      expect(lookupL10n(const Locale('ar')).testTimingBody('12 أكتوبر'), isNot(contains('موثوق')));
      expect(lookupL10n(const Locale('fr')).testTimingBody('12 oct.'), isNot(contains('fiable')));
      expect(lookupL10n(const Locale('es')).testTimingBody('12 oct'), isNot(contains('fiable')));
    });

    test('the ads notice says Google serves the ads and what it receives (A2)', () {
      for (final lang in supportedLanguages) {
        expect(lookupL10n(Locale(lang)).adsNotice, contains('Google'), reason: lang);
      }
      expect(lookupL10n(const Locale('en')).adsNotice, contains('advertising ID'));
    });
  });

  group('7 · the privacy policy row', () {
    test('the address follows her language, and falls back to English', () {
      expect(privacyPolicyUri('en').toString(), 'https://femioapp.com/en/privacy');
      expect(privacyPolicyUri('ar').toString(), 'https://femioapp.com/ar/privacy');
      expect(privacyPolicyUri('fr').toString(), 'https://femioapp.com/fr/privacy');
      expect(privacyPolicyUri('es').toString(), 'https://femioapp.com/es/privacy');
      expect(privacyPolicyUri('de').toString(), 'https://femioapp.com/en/privacy');
    });

    testWidgets('Settings lists the row under Privacy', (t) async {
      final l = lookupL10n(const Locale('en'));
      final c = FemioController(MemoryStore(_ttc('en', cycleLength: 28)));
      await c.load();
      await _screen(t, SettingsScreen(controller: c, today: _today));
      await t.scrollUntilVisible(find.text(l.privacyPolicyTitle), 200);
      expect(find.text(l.privacyPolicySubtitle), findsOneWidget);
    });

    testWidgets('a tap hands the Arabic address to the browser', (t) async {
      final l = lookupL10n(const Locale('ar'));
      Uri? opened;
      await _screen(
        t,
        Scaffold(
          body: PrivacyPolicyTile(
            open: (uri) async {
              opened = uri;
              return true;
            },
          ),
        ),
        lang: 'ar',
      );
      await t.tap(find.text(l.privacyPolicyTitle));
      await t.pumpAndSettle();
      expect(opened.toString(), 'https://femioapp.com/ar/privacy');
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('when no browser opens, the address is shown as selectable text with a Copy button', (t) async {
      final l = lookupL10n(const Locale('en'));
      // The test binding does not answer clipboard calls; keep what is copied.
      String? copied;
      t.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData') copied = (call.arguments as Map)['text'] as String?;
        return null;
      });
      addTearDown(() => t.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
      await _screen(t, Scaffold(body: PrivacyPolicyTile(open: (_) async => false)));
      await t.tap(find.text(l.privacyPolicyTitle));
      await t.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(l.privacyPolicyOpenFailed), findsOneWidget);
      expect(find.byType(SelectableText), findsOneWidget);
      expect(find.text('https://femioapp.com/en/privacy'), findsOneWidget);

      await t.tap(find.text(l.copyLabel));
      await t.pump();
      expect(copied, 'https://femioapp.com/en/privacy');
      expect(find.text(l.learnLinkCopied), findsOneWidget);

      await t.tap(find.text(l.closeLabel));
      await t.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}

/// Reads the Save button on the due date screen.
_Due _dueScreen(WidgetTester t) => _Due(t);

class _Due {
  _Due(this.t);
  final WidgetTester t;

  bool get saveEnabled {
    final l = lookupL10n(const Locale('en'));
    final button = t.widget<FilledButton>(
      find.ancestor(of: find.text(l.saveLabel), matching: find.byType(FilledButton)),
    );
    return button.onPressed != null;
  }
}
