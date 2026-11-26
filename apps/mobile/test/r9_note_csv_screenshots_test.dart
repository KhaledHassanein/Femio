// R9.8 and R9.10 on screen: the note section on the Log screen and the spreadsheet export
// row in Settings, English and Arabic, light and dark, at 390x844. Also checks the note
// saves by itself and that the export row warns it is not encrypted. Goldens are written
// only with --update-goldens, to testing-results/2026-11-26-r9-note-csv/.
import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/features/log/widgets/note_field.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-26-r9-note-csv';
const _today = '2026-11-24';

Profile _profile(String lang) => Profile(
      goal: Goal.ttc,
      locale: lang,
      birthYear: 1994,
      periodStarts: const ['2026-11-01'],
      logs: const {
        '2026-11-24': DayLog(terms: ['happy']),
      },
      settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
    );

Future<FemioController> _pump(WidgetTester tester, String lang, Brightness b) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  tester.platformDispatcher.platformBrightnessTestValue = b;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAllTestValues);
  final c = FemioController(MemoryStore(_profile(lang)), initialLocale: lang);
  await c.load();
  await tester.pumpWidget(FemioApp(controller: c, today: _today));
  await tester.pumpAndSettle();
  return c;
}

final _noteInput = find.descendant(of: find.byType(NoteField), matching: find.byType(TextField));

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  const variants = [
    ('en', Brightness.light),
    ('en', Brightness.dark),
    ('ar', Brightness.light),
    ('ar', Brightness.dark),
  ];

  for (final (lang, b) in variants) {
    testWidgets('log note ($lang ${b.name})', (tester) async {
      final c = await _pump(tester, lang, b);
      final l = lookupL10n(Locale(lang));
      await tester.tap(find.text(l.navLog));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text(l.logNoteSaved), 300, scrollable: find.byType(Scrollable).first);
      final note = lang == 'ar' ? 'بدأتُ الدواء الجديد اليوم.' : 'Started the new tablets today.';
      await tester.enterText(_noteInput, note);
      // Not saved yet: she is still typing.
      expect(c.profile!.logs[_today]!.note, isNull);
      await tester.pump(noteSaveDelay + const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(c.profile!.logs[_today]!.note, note);
      // The chip she tapped earlier is untouched by the note save.
      expect(c.profile!.logs[_today]!.terms, ['happy']);
      if (autoUpdateGoldenFiles) {
        await expectLater(find.byType(MaterialApp).first, matchesGoldenFile('$_out/log_note_${lang}_${b.name}.png'));
      }
    });

    testWidgets('settings export row ($lang ${b.name})', (tester) async {
      await _pump(tester, lang, b);
      final l = lookupL10n(Locale(lang));
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text(l.exportCsv), 300, scrollable: find.byType(Scrollable).first);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -150));
      await tester.pumpAndSettle();
      expect(find.text(l.exportCsv), findsOneWidget);
      expect(find.text(l.csvNotEncrypted), findsOneWidget);
      if (autoUpdateGoldenFiles) {
        await expectLater(find.byType(MaterialApp).first, matchesGoldenFile('$_out/settings_export_${lang}_${b.name}.png'));
      }
    });
  }

  testWidgets('leaving the day saves a note still being typed', (tester) async {
    final c = await _pump(tester, 'en', Brightness.light);
    final l = lookupL10n(const Locale('en'));
    await tester.tap(find.text(l.navLog));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text(l.logNoteSaved), 300, scrollable: find.byType(Scrollable).first);
    await tester.enterText(_noteInput, 'typed fast');
    await tester.scrollUntilVisible(find.byTooltip(l.previousDay), -300, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.byTooltip(l.previousDay));
    await tester.pumpAndSettle();
    expect(c.profile!.logs[_today]!.note, 'typed fast');
  });
}
