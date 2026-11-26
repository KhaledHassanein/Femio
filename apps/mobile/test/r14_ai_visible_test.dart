// R14.6 + R14.9: the hybrid AI made visible, and the MR-15 sentence wherever a fertile
// window is drawn. Today's first screen says where the AI runs (Gemini Nano on this phone,
// femio's rules without it, AI off, Cloud boost only when she chose it) and offers the
// one-sentence log; every door goes through the same first-use sheet; Nano is credited
// where it ran. With --update-goldens it writes proof shots (390x844 at 2x, EN and AR,
// light and dark) to testing-results/2026-11-27-r14-ai-visible/ (synthetic fixture; the
// assistant is the offline bridge, so the chip shows the no-Nano state).

import 'package:femio/app.dart';
import 'package:femio/data/assistant_channel.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/dates.dart';
import 'package:femio/features/assistant/ai_status_chip.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:femio/features/calendar/calendar_screen.dart';
import 'package:femio/features/today/today_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-27-r14-ai-visible';
const _today = '2026-11-26';

Profile _profile(String lang, {Goal goal = Goal.period, bool assistantOn = true}) => Profile(
      goal: goal,
      locale: lang,
      birthYear: 1994,
      periodStarts: [for (var d = 0; d < 5; d++) addDays('2026-11-20', d)],
      periodLength: 5,
      cycleLength: 28,
      settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false, assistantOn: assistantOn),
    );

Future<FemioController> _pump(WidgetTester tester, Profile p, Widget Function(FemioController) home,
    {Brightness b = Brightness.light}) async {
  tester.view.physicalSize = const Size(780, 1688);
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

Widget _todayFor(FemioController c) => TodayScreen(controller: c, today: _today);

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  group('the chip states the split honestly', () {
    final l = lookupL10n(const Locale('en'));
    const nano = AssistantStatus(configured: true, onDevice: OnDeviceModel.available);
    const noNano = AssistantStatus(configured: true, onDevice: OnDeviceModel.unavailable);

    test('Gemini Nano only when the phone can run it', () {
      expect(aiRunState(nano, assistantOn: true), AiRunState.nano);
      expect(aiRunState(noNano, assistantOn: true), AiRunState.rules);
      expect(aiRunState(AssistantStatus.offline, assistantOn: true), AiRunState.rules);
      expect(aiRunState(nano, assistantOn: false), AiRunState.off);
    });

    test('Cloud boost is named only when she switched it on, and never when the AI is off', () {
      expect(aiChipText(l, AiRunState.nano, cloudBoost: false), l.aiChipNano);
      expect(aiChipText(l, AiRunState.rules, cloudBoost: true), '${l.aiChipRules} · ${l.aiChipCloud}');
      expect(aiChipText(l, AiRunState.off, cloudBoost: true), l.aiChipOff);
    });
  });

  group('Today', () {
    testWidgets('the chip and the say-it bar sit under the title, before the forecast', (tester) async {
      await _pump(tester, _profile('en'), _todayFor);
      final l = lookupL10n(const Locale('en'));
      expect(find.text(l.aiChipRules), findsOneWidget);
      expect(find.text(l.addSayItPrompt), findsOneWidget);
      final chip = tester.getTopLeft(find.text(l.aiChipRules)).dy;
      final hero = tester.getTopLeft(find.text(l.predictionPeriodTitle.toUpperCase()).first).dy;
      expect(chip, lessThan(hero));
    });

    testWidgets('AI off: the chip says so and the say-it bar goes; Ask still opens (rule 7)', (tester) async {
      await _pump(tester, _profile('en', assistantOn: false), _todayFor);
      final l = lookupL10n(const Locale('en'));
      expect(find.text(l.aiChipOff), findsOneWidget);
      expect(find.text(l.addSayItPrompt), findsNothing);
      await tester.scrollUntilVisible(find.text(l.askTitle), 300, scrollable: find.byType(Scrollable).first);
      expect(find.text(l.askTitle), findsOneWidget);
    });

    testWidgets('the say-it bar opens the first-use sheet once', (tester) async {
      final c = await _pump(tester, _profile('en'), _todayFor);
      final l = lookupL10n(const Locale('en'));
      await tester.tap(find.text(l.addSayItPrompt));
      await tester.pumpAndSettle();
      expect(find.text(l.assistIntroContinue), findsOneWidget);
      await tester.tap(find.text(l.assistIntroContinue));
      await tester.pumpAndSettle();
      expect(c.profile!.settings.assistantIntroSeen, isTrue);
      expect(find.text(l.sayItHint), findsOneWidget); // then the say-it sheet itself
    });
  });

  testWidgets('R14.9: the calendar carries the MR-15 sentence when it draws a window, in period mode too',
      (tester) async {
    await _pump(tester, _profile('en'), (c) => Scaffold(body: CalendarScreen(controller: c, today: _today, onDay: (_) {})));
    final l = lookupL10n(const Locale('en'));
    // November draws this cycle's window (ovulation 4 Dec, window from 29 Nov).
    await tester.scrollUntilVisible(find.text(l.predictionNote), 300, scrollable: find.byType(Scrollable).first);
    expect(find.text(l.legendFertile), findsOneWidget);
    expect(find.text(l.predictionNote), findsOneWidget);
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      testWidgets('proof shots ($lang ${b.name})', (tester) async {
        await _pump(tester, _profile(lang, goal: Goal.ttc), _todayFor, b: b);
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/today_${lang}_${b.name}.png'));
      });
    }
  }
}
