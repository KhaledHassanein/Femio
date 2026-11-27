// The two screens this work changed, pumped on their own (not through the home shell):
// the calendar with and without the Hijri line, and Settings with its Reminders block.
// Captures PNGs under test/screenshots with `flutter test --update-goldens`, like
// screens_test.dart; a plain run checks behaviour only.

import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/reminder_scheduler.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/hijri.dart';
import 'package:femio/domain/reminders.dart';
import 'package:femio/features/calendar/calendar_screen.dart';
import 'package:femio/features/settings/settings_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _today = '2026-10-08';

/// The first tappable day inside the month grid (not the month arrows).
final _firstDayCell = find.descendant(of: find.byType(GridView), matching: find.byType(InkWell)).first;

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

Profile _profile(String lang, {bool hijri = false, AppSettings? settings}) => Profile(
      goal: Goal.ttc,
      locale: lang,
      birthYear: 1994,
      periodStarts: const ['2026-09-10'],
      cycleLength: 28,
      settings: settings ?? AppSettings(showHijri: hijri),
    );

Future<void> _pump(WidgetTester tester, FemioController c, Widget home, String lang, Brightness b) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  tester.platformDispatcher.platformBrightnessTestValue = b;
  addTearDown(tester.view.reset);
  await c.load();
  await tester.pumpWidget(MaterialApp(
    theme: FemioTheme.light(),
    darkTheme: FemioTheme.dark(),
    locale: Locale(lang),
    supportedLocales: [for (final code in supportedLanguages) Locale(code)],
    localizationsDelegates: const [
      L10n.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: home,
  ));
  await tester.pumpAndSettle();
}

Future<void> _shoot(WidgetTester tester, String name) async {
  if (!autoUpdateGoldenFiles) return;
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('screenshots/$name.png'));
}

void main() {
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  group('calendar', () {
    for (final b in Brightness.values) {
      testWidgets('Hijri day under each date and the month line under the title (ar, ${b.name})', (tester) async {
        final c = FemioController(MemoryStore(_profile('ar', hijri: true)));
        await _pump(tester, c, Scaffold(body: CalendarScreen(controller: c, today: _today, onDay: (_) {})), 'ar', b);
        await _shoot(tester, 'ar_${b.name}_hijri_calendar');

        // One Hijri label per Gregorian day of October, same text as the website prints.
        for (var d = 1; d <= 31; d++) {
          final iso = '2026-10-${d.toString().padLeft(2, '0')}';
          expect(find.text(hijriDay(iso)), findsWidgets, reason: iso);
        }
        expect(find.text(hijriMonthLine('2026-10-01', '2026-10-31', 'ar')), findsOneWidget);
        // The Hijri text is 12px and takes the subtle colour; each row is 52 tall.
        final label = tester.widget<Text>(find.text(hijriDay('2026-10-08')).first);
        expect(label.style?.fontSize, 12);
        expect(tester.getSize(_firstDayCell).height, 52);
      });
    }

    testWidgets('Hijri off: no Hijri labels and no month line (en)', (tester) async {
      final c = FemioController(MemoryStore(_profile('en')));
      await _pump(tester, c, Scaffold(body: CalendarScreen(controller: c, today: _today, onDay: (_) {})), 'en', Brightness.light);
      await _shoot(tester, 'en_light_plain_calendar');
      expect(find.text(hijriMonthLine('2026-10-01', '2026-10-31', 'en')), findsNothing);
      // Without Hijri the cells stay square, as before.
      final cell = tester.getSize(_firstDayCell);
      expect(cell.height, cell.width);
    });

    testWidgets('Hijri switched on in English shows English month names', (tester) async {
      final c = FemioController(MemoryStore(_profile('en', hijri: true)));
      await _pump(tester, c, Scaffold(body: CalendarScreen(controller: c, today: _today, onDay: (_) {})), 'en', Brightness.light);
      await _shoot(tester, 'en_light_hijri_calendar');
      expect(find.text(hijriMonthLine('2026-10-01', '2026-10-31', 'en')), findsOneWidget);
    });
  });

  group('settings reminders', () {
    for (final b in Brightness.values) {
      for (final lang in ['en', 'ar']) {
        testWidgets('both switches, the time and the honest notes ($lang, ${b.name})', (tester) async {
          final recorder = _Granting();
          final c = FemioController(MemoryStore(_profile(lang)), reminders: recorder, clock: () => DateTime(2026, 10, 8, 10));
          await _pump(tester, c, SettingsScreen(controller: c), lang, b);
          final l = lookupL10n(Locale(lang));
          await tester.scrollUntilVisible(find.text(l.reminderLog), 200, scrollable: find.byType(Scrollable).first);
          await _shoot(tester, '${lang}_${b.name}_reminders_off');

          expect(find.text(l.reminderPeriod), findsOneWidget); // trying to conceive has a period to expect
          expect(find.text(l.reminderLogTime), findsNothing); // the time only appears once the nudge is on

          // The first switch ever opens the consent screen (R12.1); Allow asks the phone.
          await tester.tap(find.text(l.reminderLog));
          await tester.pumpAndSettle();
          expect(find.text(l.notifConsentTitle), findsOneWidget);
          await tester.scrollUntilVisible(find.text(l.notifConsentAllow), 200, scrollable: find.byType(Scrollable).first);
          await tester.tap(find.text(l.notifConsentAllow));
          await tester.pumpAndSettle();
          expect(recorder.asked, 1);
          expect(c.profile!.settings.logReminder, isTrue);
          expect(find.text(l.reminderLogTime), findsOneWidget);
          await tester.scrollUntilVisible(find.text(l.remindersTimingNote), 200, scrollable: find.byType(Scrollable).first);
          await _shoot(tester, '${lang}_${b.name}_reminders_on');

          // The time reads as 8:00 PM / 8:00 م, Western digits (ADR-069).
          expect(find.textContaining('8:00'), findsOneWidget);
        });
      }
    }

    testWidgets('a refusal leaves the switch off and says why', (tester) async {
      final c = FemioController(MemoryStore(_profile('en')), reminders: _Granting(grant: false), clock: () => DateTime(2026, 10, 8, 10));
      await _pump(tester, c, SettingsScreen(controller: c), 'en', Brightness.light);
      final l = lookupL10n(const Locale('en'));
      await tester.scrollUntilVisible(find.text(l.reminderLog), 200, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.text(l.reminderLog));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text(l.notifConsentAllow), 200, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.text(l.notifConsentAllow));
      await tester.pumpAndSettle();
      expect(c.profile!.settings.logReminder, isFalse);
      expect(find.text(l.notifConsentDeniedTitle), findsOneWidget);
    });

    testWidgets('no period switch for a pregnant record', (tester) async {
      final p = Profile(goal: Goal.pregnant, locale: 'en', edd: '2027-02-01');
      final c = FemioController(MemoryStore(p));
      await _pump(tester, c, SettingsScreen(controller: c), 'en', Brightness.light);
      final l = lookupL10n(const Locale('en'));
      await tester.scrollUntilVisible(find.text(l.reminderLog), 200, scrollable: find.byType(Scrollable).first);
      expect(find.text(l.reminderPeriod), findsNothing);
    });
  });
}

class _Granting implements ReminderScheduler {
  @override
  Future<void> openSettings() async {}
  _Granting({this.grant = true});
  final bool grant;
  int asked = 0;
  @override
  Future<bool> requestPermission() async {
    asked++;
    return grant;
  }

  @override
  Future<void> replaceAll(List<PlannedReminder> plan, ReminderTexts texts) async {}
  @override
  Future<void> cancelAll() async {}
}
