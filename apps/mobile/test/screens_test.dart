import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/appointments.dart';
import 'package:femio/domain/contractions.dart';
import 'package:femio/domain/movements.dart';
import 'package:femio/domain/weight.dart';
import 'package:femio/features/lock/pin_field.dart';
import 'package:femio/features/onboarding/widgets.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Screens at a 390×844 phone, in English and Arabic, light and dark (CLAUDE.md: a
/// screenshot is the test). Writes PNGs to `test/screenshots/` with
/// `flutter test --update-goldens test/screens_test.dart`; they are reviewed by eye
/// and not committed (fonts render slightly differently per platform).
const today = '2026-10-08';

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
  final sdk = Platform.environment['FLUTTER_ROOT'] ?? '/root/sdk/flutter';
  await load('MaterialIcons', ['$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf']);
}

Future<void> _pump(WidgetTester tester, FemioController c, Brightness b) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  tester.platformDispatcher.platformBrightnessTestValue = b;
  await c.load();
  await tester.pumpWidget(FemioApp(controller: c, today: today));
  await tester.pumpAndSettle();
}

/// Captures only under `--update-goldens`. The PNGs are not committed, so a plain
/// `flutter test` would have nothing to compare against; it still walks every screen
/// and checks the saved record, which is the part that can regress silently.
Future<void> _shoot(WidgetTester tester, String name) async {
  await tester.pumpAndSettle();
  if (!autoUpdateGoldenFiles) return;
  // Shadows render as solid outlines under flutter_test (debugDisableShadows); the
  // phone draws them soft. Turning them on per capture made the suite time out.
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('screenshots/$name.png'));
}

void main() {
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  for (final b in Brightness.values) {
    final mode = b.name;
    for (final lang in ['en', 'ar']) {
      testWidgets('onboarding walk-through ($lang, $mode)', (tester) async {
        final c = FemioController(MemoryStore(), initialLocale: lang);
        await _pump(tester, c, b);
        await _shoot(tester, '${lang}_${mode}_01_welcome');

        await tester.tap(find.byType(FilledButton));
        await _shoot(tester, '${lang}_${mode}_02_goal');

        await tester.tap(find.byType(OptionTile).at(1)); // Get pregnant
        await _shoot(tester, '${lang}_${mode}_03_birth_year');

        await tester.tap(find.byType(FilledButton));
        await tester.pumpAndSettle();
        await tester.tap(find.text('1')); // 1 October, a week before 'today'
        await _shoot(tester, '${lang}_${mode}_04_last_period');

        await tester.tap(find.byType(FilledButton));
        await _shoot(tester, '${lang}_${mode}_05_period_length');
        await tester.tap(find.byType(FilledButton));
        await _shoot(tester, '${lang}_${mode}_06_cycle_length');
        await tester.tap(find.byType(FilledButton));
        await _shoot(tester, '${lang}_${mode}_07_trying');
        await tester.tap(find.byType(OptionTile).at(2)); // 6 to 12 months
        await _shoot(tester, '${lang}_${mode}_08_today_ttc');
        expect(c.profile?.goal, Goal.ttc);
        expect(c.profile?.periodStarts, ['2026-10-01']);
      });
    }

    testWidgets('today, each goal ($mode)', (tester) async {
      final profiles = {
        'period': const Profile(goal: Goal.period, locale: 'en', birthYear: 1995, periodStarts: ['2026-09-21'], periodLength: 5, cycleLength: 28),
        'pregnant': const Profile(goal: Goal.pregnant, locale: 'ar', birthYear: 1993, edd: '2027-02-10'),
        'menopause': const Profile(goal: Goal.menopause, locale: 'en', birthYear: 1972, periodStarts: ['2026-05-02']),
        'irregular': const Profile(goal: Goal.period, locale: 'ar', birthYear: 1998, periodStarts: ['2026-09-21'], irregular: true),
      };
      for (final e in profiles.entries) {
        final c = FemioController(MemoryStore(e.value));
        await _pump(tester, c, b);
        await _shoot(tester, '${e.value.locale}_${mode}_today_${e.key}');
      }
    });
  }

  for (final b in Brightness.values) {
    for (final lang in ['en', 'ar']) {
      testWidgets('calendar and log ($lang, ${b.name})', (tester) async {
        var p = Profile(goal: Goal.ttc, locale: lang, birthYear: 1994, periodStarts: const ['2026-09-10'], cycleLength: 28);
        for (final d in ['2026-10-01', '2026-10-02', '2026-10-03', '2026-10-04']) {
          p = p.withDayLog(d, DayLog(flow: d == '2026-10-02' ? 'heavy' : 'medium', terms: d == '2026-10-01' ? const ['cramps', 'fatigue'] : const []));
        }
        p = p.withDayLog('2026-10-06', const DayLog(flow: 'spotting', terms: ['calm', 'headache']));
        p = p.withDayLog('2026-10-08', const DayLog(terms: ['happy', 'bloating', 'creamy']));
        final c = FemioController(MemoryStore(p));
        await _pump(tester, c, b);
        await tester.tap(find.byIcon(Icons.calendar_month_outlined));
        await _shoot(tester, '${lang}_${b.name}_09_calendar');
        await tester.tap(find.byIcon(Icons.edit_note_outlined));
        await _shoot(tester, '${lang}_${b.name}_10_log');
        // Logging from the screen saves to the record.
        await tester.tap(find.text(lang == 'en' ? 'Acne' : 'حبّ الشباب'));
        await tester.pumpAndSettle();
        expect(c.profile!.logs[today]!.terms, contains('acne'));
      });
    }
  }

  for (final b in Brightness.values) {
    for (final lang in ['en', 'ar']) {
      testWidgets('ttc tools on Today and Log ($lang, ${b.name})', (tester) async {
        var p = Profile(goal: Goal.ttc, locale: lang, birthYear: 1990, periodStarts: const ['2026-09-30'], cycleLength: 29, tryingFor: TryingFor.over12);
        final temps = {'2026-10-03': 36.42, '2026-10-04': 36.38, '2026-10-05': 36.45, '2026-10-06': 36.40, '2026-10-07': 36.47};
        for (final e in temps.entries) {
          p = p.withDayLog(e.key, DayLog(bbt: e.value, opk: e.key == '2026-10-07' ? 'high' : 'negative'));
        }
        final c = FemioController(MemoryStore(p));
        await _pump(tester, c, b);
        tester.view.physicalSize = const Size(780, 3000);
        await tester.pumpAndSettle();
        await _shoot(tester, '${lang}_${b.name}_11_today_ttc_tools');
        tester.view.physicalSize = const Size(780, 1688);
        await tester.tap(find.byIcon(Icons.edit_note_outlined));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView).last, const Offset(0, -2400));
        await _shoot(tester, '${lang}_${b.name}_12_log_ttc');
        // Typing a temperature saves it; a typo is refused rather than recorded.
        await tester.enterText(find.byType(TextField), '365');
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();
        expect(c.profile!.logs[today]?.bbt, isNull);
        await tester.enterText(find.byType(TextField), '36.52');
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();
        expect(c.profile!.logs[today]!.bbt, 36.52);
      });
    }
  }

  for (final b in Brightness.values) {
    for (final lang in ['en', 'ar']) {
      testWidgets('pregnancy tools ($lang, ${b.name})', (tester) async {
        // Real clock: the tools are opened from Today, as she would. Times are relative.
        final now = DateTime.now().toUtc();
        String ago(int minutes, [int seconds = 0]) =>
            now.subtract(Duration(minutes: minutes, seconds: seconds)).toIso8601String();
        final p = Profile(
          goal: Goal.pregnant,
          locale: lang,
          birthYear: 1993,
          edd: '2026-10-28', // 37 weeks: the contraction timer comes first
          contractions: [
            for (final (i, m) in [40, 31, 23, 16, 10].indexed) Contraction('c$i', ago(m), ago(m - 1, 10)),
          ],
          movements: [
            for (final (i, (h, mins)) in [(5, 18), (4, 22), (3, 20), (2, 20), (1, 34)].indexed)
              MovementSession('m$i', ago(h * 60), ago(h * 60 - mins), 10),
          ],
          weights: const [
            WeightEntry('w1', '2026-08-01', 63.0, 'kg'),
            WeightEntry('w2', '2026-08-29', 64.4, 'kg'),
            WeightEntry('w3', '2026-09-26', 65.9, 'kg'),
          ],
          appointments: const [
            Appointment(id: 'a1', type: 'Growth scan', clinician: 'Dr Mansour', datetime: '2026-10-12T09:30',
                prep: ['Is the baby head down?', 'When do I stop work?']),
            Appointment(id: 'a2', type: 'Glucose test', datetime: '2026-09-24T08:00', resultsDue: '2026-10-01'),
          ],
        );
        final c = FemioController(MemoryStore(p));
        await _pump(tester, c, b);
        tester.view.physicalSize = const Size(780, 2600);
        await tester.pumpAndSettle();
        await _shoot(tester, '${lang}_${b.name}_13_today_pregnant_tools');

        await tester.ensureVisible(find.byIcon(Icons.timer_outlined));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.timer_outlined));
        await tester.pumpAndSettle();
        tester.view.physicalSize = const Size(780, 1688);
        await _shoot(tester, '${lang}_${b.name}_14_contractions');
        // Start, then stop: one more contraction, finished. (The ticker runs while timing,
        // so this pumps frames rather than settling.)
        await tester.tap(find.byType(FilledButton).first);
        await tester.pump(const Duration(seconds: 1));
        expect(c.profile!.contractions.last.endedAt, isNull);
        await tester.tap(find.byType(FilledButton).first);
        await tester.pumpAndSettle();
        expect(c.profile!.contractions, hasLength(6));
        expect(c.profile!.contractions.last.endedAt, isNotNull);
        // pageBack() looks for the English "Back" tooltip; tap the button itself.
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byIcon(Icons.touch_app_outlined));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.touch_app_outlined));
        await tester.pumpAndSettle();
        await _shoot(tester, '${lang}_${b.name}_15_movements');
        // A session: start, three movements, finish. Saved on every tap.
        await tester.tap(find.byIcon(Icons.play_arrow_rounded));
        await tester.pumpAndSettle();
        for (var i = 0; i < 3; i++) {
          await tester.tap(find.byType(FilledButton).first);
          await tester.pumpAndSettle();
        }
        await _shoot(tester, '${lang}_${b.name}_16_movements_session');
        expect(c.profile!.movements.last.movementCount, 3);
        await tester.tap(find.byType(OutlinedButton));
        await tester.pumpAndSettle();
        expect(c.profile!.movements.last.endedAt, isNotNull);
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byIcon(Icons.event_note_outlined));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.event_note_outlined));
        await tester.pumpAndSettle();
        await _shoot(tester, '${lang}_${b.name}_17_appointments');
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byIcon(Icons.monitor_weight_outlined));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.monitor_weight_outlined));
        await tester.pumpAndSettle();
        // A typo is refused; a reading is saved as typed.
        await tester.enterText(find.byType(TextField), '665');
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();
        expect(c.profile!.weights, hasLength(3));
        await tester.enterText(find.byType(TextField), '66.4');
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();
        expect(c.profile!.weights.last.value, 66.4);
        await _shoot(tester, '${lang}_${b.name}_18_weight');
      });
    }
  }

  for (final b in Brightness.values) {
    for (final lang in ['en', 'ar']) {
      testWidgets('settings and lock ($lang, ${b.name})', (tester) async {
        final p = Profile(goal: Goal.ttc, locale: lang, birthYear: 1994, periodStarts: const ['2026-09-10'], cycleLength: 28);
        final c = FemioController(MemoryStore(p));
        await _pump(tester, c, b);
        // The one-time storage notice shows on Today until she dismisses it.
        await _shoot(tester, '${lang}_${b.name}_12_today_notice');
        await tester.tap(find.byIcon(Icons.settings_outlined));
        await tester.pumpAndSettle();
        await _shoot(tester, '${lang}_${b.name}_13_settings');
        expect(find.byType(SwitchListTile), findsNWidgets(2));
        // Setting a PIN locks the next launch; the lock screen opens the record again.
        // PBKDF2 yields to the event loop, which testWidgets' fake clock never advances,
        // so the key derivation runs under runAsync (real time).
        await tester.runAsync(() => c.setPin('2468'));
        c.locked = true;
        c.notifyListeners();
        // The PIN field's caret blinks forever, so pumpAndSettle would never return;
        // pump a fixed frame and capture without settling.
        await tester.pump(const Duration(milliseconds: 400));
        if (autoUpdateGoldenFiles) {
          await expectLater(find.byType(MaterialApp), matchesGoldenFile('screenshots/${lang}_${b.name}_14_lock.png'));
        }
        expect(find.byType(PinField), findsOneWidget);
        expect(await tester.runAsync(() => c.unlock('0000')), isFalse);
        expect(await tester.runAsync(() => c.unlock('2468')), isTrue);
      });
    }
  }
}
