// R14.10: Settings → "What femio helps with". She can change her stage (period, trying,
// pregnant, perimenopause) or correct an onboarding answer; her record stays whole
// (product rule 5, CLIN-1, CLIN-3). With --update-goldens it writes proof shots (390x844
// at 2x, EN and AR, light and dark) to testing-results/2026-11-27-r14-stage-change/
// (synthetic fixture).

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/dates.dart';
import 'package:femio/domain/weight.dart';
import 'package:femio/features/onboarding/onboarding_flow.dart';
import 'package:femio/features/settings/settings_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-27-r14-stage-change';
const _today = '2026-11-26';

Profile _profile(String lang) => Profile(
      goal: Goal.period,
      locale: lang,
      birthYear: 1994,
      periodStarts: const ['2026-10-23', '2026-11-20'],
      periodLength: 5,
      cycleLength: 28,
      logs: const {'2026-11-21': DayLog(note: 'kept')},
      weights: const [WeightEntry('w1', '2026-11-01', 61, 'kg')],
      settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
    );

/// Pumps a Settings screen whose "What femio helps with" row opens the flow in edit mode.
Future<FemioController> _pump(WidgetTester tester, Profile p, {Brightness b = Brightness.light}) async {
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
    home: Scaffold(body: SettingsScreen(controller: c)),
  ));
  await tester.pumpAndSettle();
  return c;
}

Future<void> _openEditor(WidgetTester tester, L10n l) async {
  await tester.scrollUntilVisible(find.text(l.settingsStageSub), 200, scrollable: find.byType(Scrollable).first);
  await tester.tap(find.text(l.settingsStageSub));
  await tester.pumpAndSettle();
}

Future<void> _tapText(WidgetTester tester, String s) async {
  await tester.ensureVisible(find.text(s).last);
  await tester.tap(find.text(s).last);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  final l = lookupL10n(const Locale('en'));

  group('Profile.withAnswers', () {
    test('changes only the answers and keeps every record (rule 5)', () {
      final p = _profile('en');
      final n = p.withAnswers(
        goal: Goal.ttc,
        periodLength: 6,
        cycleLength: 30,
        irregular: false,
        tryingFor: TryingFor.under6,
        edd: null,
        birthDate: null,
        lastPeriodOverYear: false,
        addStarts: const ['2026-11-20', '2026-09-25'],
      );
      expect(n.goal, Goal.ttc);
      expect(n.cycleLength, 30);
      expect(n.periodLength, 6);
      expect(n.tryingFor, TryingFor.under6);
      expect(n.periodStarts, ['2026-09-25', '2026-10-23', '2026-11-20']); // merged, no duplicate
      expect(n.logs, p.logs);
      expect(n.weights, p.weights);
      expect(n.birthYear, p.birthYear);
      expect(n.settings, p.settings);
    });
  });

  testWidgets('Settings has the row; the flow opens at the goal, her answer selected', (tester) async {
    await _pump(tester, _profile('en'));
    await _openEditor(tester, l);
    expect(find.byType(OnboardingFlow), findsOneWidget);
    expect(find.text(l.goalPeriod), findsOneWidget);
    expect(find.text(l.welcomeTitle), findsNothing);
  });

  testWidgets('back on the first question closes the editor and changes nothing', (tester) async {
    final c = await _pump(tester, _profile('en'));
    await _openEditor(tester, l);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingFlow), findsNothing);
    expect(c.profile!.goal, Goal.period);
  });

  testWidgets('period → trying: no age question again, answers prefilled, record kept', (tester) async {
    final c = await _pump(tester, _profile('en'));
    await _openEditor(tester, l);
    await _tapText(tester, l.goalTtc);
    expect(find.text(l.lastPeriodTitle), findsOneWidget); // birth year skipped (MR-48 settled)
    await _tapText(tester, l.continueLabel); // last period: her latest start is selected
    await _tapText(tester, l.continueLabel); // period length 5
    await _tapText(tester, l.continueLabel); // cycle length 28
    await _tapText(tester, l.tryingUnder6);
    expect(find.byType(OnboardingFlow), findsNothing);
    final p = c.profile!;
    expect(p.goal, Goal.ttc);
    expect(p.tryingFor, TryingFor.under6);
    expect(p.cycleLength, 28);
    expect(p.periodStarts, ['2026-10-23', '2026-11-20']);
    expect(p.logs['2026-11-21']?.note, 'kept');
    expect(p.weights, hasLength(1));
  });

  testWidgets('correct an answer: her cycles vary now', (tester) async {
    final c = await _pump(tester, _profile('en'));
    await _openEditor(tester, l);
    await _tapText(tester, l.goalPeriod);
    await _tapText(tester, l.continueLabel);
    await _tapText(tester, l.continueLabel);
    await _tapText(tester, l.irregular);
    final p = c.profile!;
    expect(p.goal, Goal.period);
    expect(p.irregular, isTrue);
    expect(p.cycleLength, isNull);
    expect(p.logs, isNotEmpty);
  });

  testWidgets('trying → pregnant from her last period keeps the cycle record', (tester) async {
    final c = await _pump(tester, _profile('en'));
    await _openEditor(tester, l);
    await _tapText(tester, l.goalPregnant);
    await _tapText(tester, l.dueMethodLmp);
    expect(find.text(l.lastPeriodTitle), findsOneWidget);
    await _tapText(tester, '1'); // 1 November 2026
    await _tapText(tester, l.continueLabel);
    final p = c.profile!;
    expect(p.goal, Goal.pregnant);
    expect(p.edd, isNotNull);
    expect(fromISO(p.edd!).isAfter(fromISO(_today)), isTrue);
    expect(p.periodStarts, ['2026-10-23', '2026-11-20']);
    expect(p.logs['2026-11-21']?.note, 'kept');
  });

  testWidgets('a second pregnancy after a recorded birth is a pregnancy, not after-birth (CLIN-N2-1)', (tester) async {
    // Her baby was born in March, her period came back, and she is trying again.
    final before = _profile('en').withAnswers(
      goal: Goal.ttc,
      periodLength: 5,
      cycleLength: 28,
      irregular: false,
      tryingFor: TryingFor.under6,
      edd: '2026-03-10',
      birthDate: '2026-03-01',
      lastPeriodOverYear: false,
    );
    final c = await _pump(tester, before);
    await _openEditor(tester, l);
    await _tapText(tester, l.goalPregnant);
    await _tapText(tester, l.dueMethodLmp);
    await _tapText(tester, '1'); // 1 November 2026
    await _tapText(tester, l.continueLabel);
    final p = c.profile!;
    expect(p.goal, Goal.pregnant);
    expect(p.birthDate, isNull, reason: 'the old birth would show the after-birth view');
    expect(p.isPostpartum, isFalse);
    expect(fromISO(p.edd!).isAfter(fromISO(_today)), isTrue);
    expect(p.periodStarts, ['2026-10-23', '2026-11-20']);
  });

  testWidgets('trying again after a birth keeps the birth, so old bleeding stays out (MR-60)', (tester) async {
    final before = _profile('en').withAnswers(
      goal: Goal.period,
      periodLength: 5,
      cycleLength: 28,
      irregular: false,
      tryingFor: null,
      edd: '2026-03-10',
      birthDate: '2026-03-01',
      lastPeriodOverYear: false,
    );
    final c = await _pump(tester, before);
    await _openEditor(tester, l);
    await _tapText(tester, l.goalTtc);
    await _tapText(tester, l.continueLabel);
    await _tapText(tester, l.continueLabel);
    await _tapText(tester, l.continueLabel);
    await _tapText(tester, l.tryingUnder6);
    expect(c.profile!.birthDate, '2026-03-01');
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      testWidgets('proof shots ($lang ${b.name})', (tester) async {
        await _pump(tester, _profile(lang), b: b);
        final ll = lookupL10n(Locale(lang));
        await tester.scrollUntilVisible(find.text(ll.settingsStageSub), 200, scrollable: find.byType(Scrollable).first);
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/settings_${lang}_${b.name}.png'));
        await tester.tap(find.text(ll.settingsStageSub));
        await tester.pumpAndSettle();
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/editor_${lang}_${b.name}.png'));
      });
    }
  }
}
