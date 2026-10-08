import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
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
}
