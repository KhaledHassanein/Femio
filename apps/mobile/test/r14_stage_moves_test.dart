// Stage moves without reset (owner 2026-11-27): "I'm pregnant" from trying, "My pregnancy has
// ended" (MR-35), the breastfeeding layer after birth, and the stage row on Today. Every move
// keeps her record (product rule 5). With --update-goldens it writes proof shots (390x844 at
// 2x, EN and AR, light and dark) to testing-results/2026-11-27-stage-moves/ (synthetic fixture).

import 'package:femio/app.dart';
import 'package:femio/data/library.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/absent_period.dart';
import 'package:femio/domain/pregnancy_end.dart';
import 'package:femio/features/today/today_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-27-stage-moves';
const _today = '2026-11-26';

AppSettings _settings(String lang) => AppSettings.defaultsFor(lang).copyWith(
      storageNoticeSeen: true,
      showHijri: false,
      notificationConsentAt: '2026-10-01T09:00:00Z',
      logReminder: true,
      periodReminder: true,
      appointmentReminder: true,
      medicineReminder: true,
    );

Profile _pregnant(String lang) => Profile(
      goal: Goal.pregnant,
      locale: lang,
      birthYear: 1993,
      periodStarts: const ['2026-08-20', '2026-09-18'],
      edd: '2027-06-25',
      logs: const {'2026-11-10': DayLog(note: 'kept')},
      settings: _settings(lang),
    );

Profile _ttc(String lang) => Profile(
      goal: Goal.ttc,
      locale: lang,
      birthYear: 1993,
      periodStarts: const ['2026-10-01', '2026-10-29'],
      cycleLength: 28,
      tryingFor: TryingFor.sixTo12,
      settings: _settings(lang),
    );

Profile _afterBirth(String lang) => _pregnant(lang).copyWith(birthDate: '2026-11-01');

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
    home: ListenableBuilder(
      listenable: c,
      builder: (_, _) => TodayScreen(controller: c, today: _today, library: Library(load: (_) async => '[]')),
    ),
  ));
  await tester.pumpAndSettle();
  return c;
}

/// Scrolls Today (a lazy list) until [f] is built and on screen.
Future<void> _reveal(WidgetTester tester, Finder f) async {
  if (f.evaluate().isEmpty) await tester.scrollUntilVisible(f, 300, scrollable: find.byType(Scrollable).first);
  await tester.ensureVisible(f.last);
  await tester.pumpAndSettle();
}

Future<void> _tapText(WidgetTester tester, String s) async {
  await _reveal(tester, find.text(s));
  await tester.ensureVisible(find.text(s).last);
  await tester.pumpAndSettle();
  await tester.tap(find.text(s).last);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  final l = lookupL10n(const Locale('en'));

  group('the record', () {
    test('ending a pregnancy keeps every record, moves the goal and stops the reminders', () {
      final p = _pregnant('en').endPregnancy('2026-11-20', Goal.ttc);
      expect(p.goal, Goal.ttc);
      expect(p.pregnancyEnded, '2026-11-20');
      expect(p.edd, '2027-06-25', reason: 'the pregnancy record stays');
      expect(p.logs['2026-11-10']?.note, 'kept');
      expect(p.periodStarts, ['2026-08-20', '2026-09-18']);
      expect(p.settings.logReminder, isFalse);
      expect(p.settings.periodReminder, isFalse);
      expect(p.settings.appointmentReminder, isFalse);
      expect(p.settings.medicineReminder, isTrue, reason: 'her medicines may be for her own care');
    });

    test('bleeding up to the day it ended never counts; a period after it starts her ranges', () {
      var p = _pregnant('en').endPregnancy('2026-11-20', Goal.period);
      p = p.withDayLog('2026-11-20', const DayLog(flow: 'heavy'));
      expect(p.cycleStarts, isEmpty);
      expect(showAfterLoss(p, _today), isTrue);
      p = p.withDayLog('2026-12-24', const DayLog(flow: 'medium'));
      expect(p.cycleStarts, ['2026-12-24']);
      expect(showAfterLoss(p, '2026-12-25'), isFalse, reason: 'her period came back');
    });

    test('the after-loss card stays for a while, then steps back', () {
      final p = _pregnant('en').endPregnancy('2026-10-01', Goal.period);
      expect(showAfterLoss(p, '2026-10-02'), isTrue);
      expect(showAfterLoss(p, '2027-03-01'), isFalse);
    });

    test('a new pregnancy clears the ended day; both layers survive a save and load', () {
      final ended = _pregnant('en').endPregnancy('2026-11-20', Goal.ttc).copyWith(breastfeeding: true);
      final back = Profile.fromJson(ended.toJson());
      expect(back.pregnancyEnded, '2026-11-20');
      expect(back.breastfeeding, isTrue);
      final again = back.withAnswers(
        goal: Goal.pregnant,
        periodLength: back.periodLength,
        cycleLength: back.cycleLength,
        irregular: back.irregular,
        tryingFor: back.tryingFor,
        edd: '2027-09-01',
        birthDate: null,
        lastPeriodOverYear: false,
      );
      expect(again.pregnancyEnded, isNull);
      expect(again.breastfeeding, isTrue);
      expect(showAfterLoss(again, _today), isFalse);
    });

    test('after a loss, no pregnancy-test prompt until 90 days after the end (CLIN-N3-1)', () {
      final p = _pregnant('en').endPregnancy('2026-11-20', Goal.ttc);
      expect(periodAbsentFor(p, '2026-11-21'), isFalse, reason: 'the last bleed before the pregnancy does not count');
      expect(periodAbsentFor(p, '2027-02-17'), isFalse);
      expect(periodAbsentFor(p, '2027-02-18'), isTrue, reason: '90 days after the end with no bleed');
    });

    test('an old record without the new fields reads as before', () {
      final json = _ttc('en').toJson();
      expect(json.containsKey('pregnancyEnded'), isFalse);
      expect(json.containsKey('breastfeeding'), isFalse);
      expect(Profile.fromJson(json).breastfeeding, isFalse);
    });
  });

  testWidgets('Today names the stage; Change opens the questions', (tester) async {
    await _pump(tester, _ttc('en'));
    expect(find.text(l.stageNow(l.goalTtc)), findsOneWidget);
    await tester.tap(find.text(l.stageChange));
    await tester.pumpAndSettle();
    expect(find.text(l.goalTitle), findsOneWidget);
  });

  testWidgets('in pregnancy, Change offers "My pregnancy has ended" before the questions', (tester) async {
    await _pump(tester, _pregnant('en'));
    await tester.tap(find.text(l.stageChange));
    await tester.pumpAndSettle();
    expect(find.text(l.stageEditAnswers), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, l.endedAction));
    await tester.pumpAndSettle();
    expect(find.text(l.endedTitle), findsOneWidget, reason: 'the loss path, not the bare questions');
  });

  testWidgets("trying: one tap on I'm pregnant opens the due-date question", (tester) async {
    await _pump(tester, _ttc('en'));
    await _tapText(tester, l.goalPregnant);
    expect(find.text(l.dueMethodLmp), findsOneWidget);
  });

  testWidgets('pregnancy ended: the day, then period tracking; Today shows the after-loss card', (tester) async {
    final c = await _pump(tester, _pregnant('en'));
    await _tapText(tester, l.endedAction);
    expect(find.text(l.endedTitle), findsOneWidget);
    expect(find.text(l.endedNote), findsOneWidget);
    // The sheet is the last scrollable on screen.
    await tester.tap(find.text('20').last);
    await tester.pumpAndSettle();
    final track = find.widgetWithText(FilledButton, l.goalPeriod);
    await tester.scrollUntilVisible(track, 200, scrollable: find.byType(Scrollable).last);
    await tester.tap(track);
    await tester.pumpAndSettle();
    final p = c.profile!;
    expect(p.goal, Goal.period);
    expect(p.pregnancyEnded, '2026-11-20');
    expect(p.logs['2026-11-10']?.note, 'kept');
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 3000)); // back to the top
    await tester.pumpAndSettle();
    await _reveal(tester, find.text(l.endedCardTitle));
    await _reveal(tester, find.textContaining('soaking a pad'));
    expect(find.text(l.endedAction), findsNothing, reason: 'the pregnancy view is gone');
  });

  testWidgets('after birth: the breastfeeding layer shows the guides and names the stage', (tester) async {
    final c = await _pump(tester, _afterBirth('en'));
    expect(find.text(l.stageNow(l.stageAfterBirth)), findsOneWidget);
    expect(find.text(l.feedingGuideFirst), findsNothing);
    await _tapText(tester, l.feedingTitle);
    expect(c.profile!.breastfeeding, isTrue);
    expect(find.text(l.feedingGuideFirst), findsOneWidget);
    await _reveal(tester, find.text(l.feedingGuideHelp));
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 3000));
    await tester.pumpAndSettle();
    expect(find.text(l.stageNow(l.stageWithBreastfeeding(l.stageAfterBirth))), findsOneWidget);
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      testWidgets('proof shots ($lang ${b.name})', (tester) async {
        final ll = lookupL10n(Locale(lang));
        await _pump(tester, _pregnant(lang).endPregnancy('2026-11-20', Goal.period), b: b);
        await _reveal(tester, find.text(ll.endedCardTitle));
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/after_loss_${lang}_${b.name}.png'));
        await _pump(tester, _afterBirth(lang).copyWith(breastfeeding: true), b: b);
        await _reveal(tester, find.text(ll.feedingTitle));
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/breastfeeding_${lang}_${b.name}.png'));
      });
    }
  }
}
