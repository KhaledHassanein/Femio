// R14.19: three ports from the old release branch, rebuilt on v3. Help now opens from the
// lock screen without the PIN (MR-38); a save that fails is never silent; onboarding ends
// by introducing the assistant (R14.6a). With --update-goldens it writes proof shots
// (390x844 at 2x, EN and AR, light and dark) to testing-results/2026-11-27-r14-19/
// (synthetic fixture).

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/features/help/help_now_screen.dart';
import 'package:femio/features/lock/lock_screen.dart';
import 'package:femio/features/onboarding/steps/assistant_intro_step.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-27-r14-19';
const _today = '2026-11-26';

/// A store whose writes fail while [failing] is true, as a full phone would.
class _FlakyStore extends MemoryStore {
  _FlakyStore(super.profile);
  bool failing = true;

  @override
  Future<void> save(Profile profile) async {
    if (failing) throw const FileSystemFull();
    return super.save(profile);
  }
}

class FileSystemFull implements Exception {
  const FileSystemFull();
}

Profile _profile(String lang) => Profile(
      goal: Goal.period,
      locale: lang,
      birthYear: 1994,
      periodStarts: const ['2026-10-23', '2026-11-20'],
      cycleLength: 28,
      settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, assistantIntroSeen: true, showHijri: false),
    );

Future<void> _pump(WidgetTester tester, FemioController c, Brightness b) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  tester.platformDispatcher.platformBrightnessTestValue = b;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
  await c.load();
  await tester.pumpWidget(FemioApp(controller: c, today: _today));
  await tester.pumpAndSettle();
}

Future<void> _shoot(WidgetTester tester, String name) async {
  await tester.pumpAndSettle();
  if (!autoUpdateGoldenFiles) return;
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/$name.png'));
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      final l = lookupL10n(Locale(lang));
      final tag = '${lang}_${b.name}';

      testWidgets('Help now opens over the lock without the PIN ($tag)', (tester) async {
        final c = FemioController(MemoryStore(_profile(lang)), initialLocale: lang);
        await _pump(tester, c, b);
        c.locked = true;
        c.notifyListeners();
        await tester.pumpAndSettle();
        expect(find.byType(LockScreen), findsOneWidget);
        await _shoot(tester, '${tag}_01_lock_help');

        await tester.tap(find.byTooltip(l.helpNowLauncher).last);
        await tester.pumpAndSettle();
        expect(find.byType(HelpNowScreen), findsOneWidget);
        expect(c.locked, isTrue, reason: 'Help now must not unlock her record');
        await _shoot(tester, '${tag}_02_help_over_lock');

        // The system back closes Help now and leaves the lock in place (never the routes under it).
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.byType(HelpNowScreen), findsNothing);
        expect(find.byType(LockScreen), findsOneWidget);
      });

      testWidgets('a failed save is shown and can be retried ($tag)', (tester) async {
        final store = _FlakyStore(_profile(lang));
        final c = FemioController(store, initialLocale: lang);
        await _pump(tester, c, b);
        await c.setDayLog('2026-11-26', const DayLog(note: 'cramps'));
        await tester.pumpAndSettle();
        expect(c.saveFailed, isTrue);
        expect(c.profile!.logs['2026-11-26']?.note, 'cramps', reason: 'what she typed stays in memory');
        expect(find.text(l.saveFailedTitle), findsOneWidget);
        await _shoot(tester, '${tag}_03_save_failed');

        store.failing = false;
        await tester.tap(find.text(l.saveFailedRetry));
        await tester.pumpAndSettle();
        expect(c.saveFailed, isFalse);
        expect(find.text(l.saveFailedTitle), findsNothing);
        final saved = await store.load();
        expect((saved as Loaded).profile.logs['2026-11-26']?.note, 'cramps');
      });

      testWidgets('onboarding ends by meeting the assistant ($tag)', (tester) async {
        final c = FemioController(MemoryStore(), initialLocale: lang);
        await _pump(tester, c, b);
        await tester.tap(find.byType(FilledButton)); // welcome
        await tester.pumpAndSettle();
        await tester.tap(find.text(l.goalMenopause));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(FilledButton)); // birth year, default
        await tester.pumpAndSettle();
        await tester.tap(find.text(l.notSure));
        await tester.pumpAndSettle();
        expect(find.byType(AssistantIntroStep), findsOneWidget);
        expect(c.profile, isNull, reason: 'nothing is saved before the last step');
        await _shoot(tester, '${tag}_04_assistant_intro');

        await tester.tap(find.text(l.assistIntroContinue));
        await tester.pumpAndSettle();
        expect(c.profile?.goal, Goal.menopause);
        expect(c.profile?.settings.assistantIntroSeen, isTrue);
      });
    }
  }
}
