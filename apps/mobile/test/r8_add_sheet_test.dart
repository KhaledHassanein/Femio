// R8.29: the "+" in the middle of the navigation bar (owner 2026-11-26).
//
// Checks that the "+" opens the add sheet without changing tab, that a mood or flow tap
// saves to today at once, that "more to log" lands on today's Log, and that the assistant
// doors follow her master switch. With --update-goldens it also writes the proof shots
// (390x844 at 2x, EN and AR, light and dark) to testing-results/2026-11-26-r8-add-sheet/.

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/features/home/add_sheet.dart';
import 'package:femio/features/log/log_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-26-r8-add-sheet';
const _today = '2026-11-26';

Profile _profile(String lang, {bool assistantOn = true}) => Profile(
      goal: Goal.ttc,
      locale: lang,
      birthYear: 1994,
      periodStarts: const ['2026-11-05'],
      periodLength: 5,
      cycleLength: 28,
      settings: AppSettings.defaultsFor(lang).copyWith(
        storageNoticeSeen: true,
        assistantIntroSeen: true,
        assistantOn: assistantOn,
      ),
    );

Future<FemioController> _pump(WidgetTester tester, Profile p, [Brightness b = Brightness.light]) async {
  tester.platformDispatcher.platformBrightnessTestValue = b;
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  final c = FemioController(MemoryStore(p), initialLocale: p.locale);
  await c.load();
  await tester.pumpWidget(FemioApp(controller: c, today: _today));
  await tester.pumpAndSettle();
  return c;
}

Future<void> _openAdd(WidgetTester tester, L10n l) async {
  await tester.tap(find.text(l.navAdd));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  testWidgets('a mood and a flow tap save to today; the tab does not change', (tester) async {
    final c = await _pump(tester, _profile('en'));
    final l = lookupL10n(const Locale('en'));
    await _openAdd(tester, l);
    expect(find.byType(AddSheet), findsOneWidget);
    await tester.tap(find.text(l.logHappy));
    await tester.tap(find.text(l.flowLight));
    await tester.pumpAndSettle();
    expect(c.profile!.logs[_today]!.terms, ['happy']);
    expect(c.profile!.logs[_today]!.flow, 'light');
    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(bar.selectedIndex, 0, reason: 'the + is an action, never the selected tab');
  });

  testWidgets('"more to log" opens Log on today', (tester) async {
    await _pump(tester, _profile('en'));
    final l = lookupL10n(const Locale('en'));
    await _openAdd(tester, l);
    await tester.tap(find.text(l.addMoreToLog));
    await tester.pumpAndSettle();
    expect(find.byType(AddSheet), findsNothing);
    final log = tester.widget<LogScreen>(find.byType(LogScreen));
    expect(log.date, _today);
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 3);
  });

  testWidgets('with the assistant off the sheet has no assistant doors', (tester) async {
    await _pump(tester, _profile('en', assistantOn: false));
    final l = lookupL10n(const Locale('en'));
    await _openAdd(tester, l);
    expect(find.text(l.addSayItPrompt), findsNothing);
    expect(find.text(l.addAsk), findsNothing);
    expect(find.text(l.sectionMood), findsOneWidget);
  });

  for (final (lang, b) in const [
    ('en', Brightness.light),
    ('en', Brightness.dark),
    ('ar', Brightness.light),
    ('ar', Brightness.dark),
  ]) {
    testWidgets('add sheet shot ($lang ${b.name})', (tester) async {
      await _pump(tester, _profile(lang), b);
      final l = lookupL10n(Locale(lang));
      if (autoUpdateGoldenFiles) {
        await expectLater(find.byType(FemioApp), matchesGoldenFile('$_out/nav_${lang}_${b.name}.png'));
      }
      await _openAdd(tester, l);
      await tester.tap(find.text(l.logCalm));
      await tester.pumpAndSettle();
      expect(find.text(l.addSheetTitle), findsWidgets);
      if (autoUpdateGoldenFiles) {
        await expectLater(find.byType(FemioApp), matchesGoldenFile('$_out/add_sheet_${lang}_${b.name}.png'));
      }
    });
  }
}
