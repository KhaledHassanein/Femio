// Screens for AI transparency (R10.3): "Why am I seeing this?" on a tip, and "What the AI did".
//
// Why it exists: both pages make a promise in words; the screenshot is the check that the words
// match what the code did, in English and Arabic, light and dark. Synthetic record and ledger.
// Screenshots land in testing-results/2026-11-25-r10-transparency/ under `--update-goldens`.

import 'package:femio/app.dart';
import 'package:femio/data/ai_ledger_store.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/assistant/ai_ledger.dart';
import 'package:femio/domain/assistant/cloud_prompt.dart';
import 'package:femio/domain/assistant/pseudonymised_profile.dart';
import 'package:femio/domain/assistant/uses.dart';
import 'package:femio/features/assistant/ai_ledger_screen.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:femio/features/today/tips_card.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-25-r10-transparency';
const _today = '2026-06-20';

Profile _profile(String lang) => Profile(
      goal: Goal.ttc,
      locale: lang,
      birthYear: 1989,
      tryingFor: TryingFor.sixTo12,
      periodStarts: const ['2026-04-26', '2026-05-24'],
      logs: {
        for (var d = 1; d <= 6; d++) '2026-06-0$d': const DayLog(terms: ['anxious']),
      },
      settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
    );

Future<FemioController> _controller(String lang, {List<LedgerEntry> ledger = const []}) async {
  final c = FemioController(MemoryStore(_profile(lang)), initialLocale: lang, ledger: MemoryLedgerStore(ledger));
  await c.load();
  return c;
}

Widget _app(String lang, Brightness b, Widget home) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
      locale: Locale(lang),
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr'), Locale('es')],
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => AssistantScope(bridge: const OfflineAssistant(), child: child!),
      home: home,
    );

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

Future<void> _shoot(String name) async {
  if (!autoUpdateGoldenFiles) return;
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/$name.png'));
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  for (final (lang, b) in const [
    ('en', Brightness.light),
    ('en', Brightness.dark),
    ('ar', Brightness.light),
    ('ar', Brightness.dark),
  ]) {
    final tag = '${lang}_${b.name}';

    testWidgets('a tip says why it was chosen ($tag)', (tester) async {
      _phone(tester);
      final c = await _controller(lang);
      final l = lookupL10n(Locale(lang));
      await tester.pumpWidget(_app(
        lang,
        b,
        Scaffold(body: ListView(padding: const EdgeInsets.all(20), children: [TipsCard(controller: c, today: _today)])),
      ));
      await tester.pumpAndSettle();
      expect(find.text(l.tipWhyAction), findsWidgets);
      await tester.tap(find.text(l.tipWhyAction).first);
      await tester.pumpAndSettle();
      expect(find.text(l.tipWhyTitle), findsOneWidget);
      expect(find.text(l.tipWhyStage('ttc')), findsOneWidget);
      expect(find.text(l.tipWhyFootnote), findsOneWidget);
      await _shoot('${tag}_tip_why');
    });

    testWidgets('the ledger lists each call and keeps the cloud receipt ($tag)', (tester) async {
      _phone(tester);
      final bands = pseudonymise(_profile(lang), _today);
      final sent = CloudPrompt.tips(bands, 3).text;
      final c = await _controller(lang, ledger: [
        const LedgerEntry(at: '2026-06-20T09:12:00Z', use: AssistantUse.sayItToLog, cloud: false, answered: true),
        LedgerEntry(at: '2026-06-19T18:40:00Z', use: AssistantUse.tipsOrder, cloud: true, answered: true, sent: sent),
        const LedgerEntry(at: '2026-06-18T07:05:00Z', use: AssistantUse.askOnPhone, cloud: false, answered: false),
      ]);
      final l = lookupL10n(Locale(lang));
      await tester.pumpWidget(_app(lang, b, AiLedgerScreen(controller: c)));
      await tester.pumpAndSettle();
      expect(find.text(l.aiLedgerInCloud), findsOneWidget);
      expect(find.text(l.aiLedgerOnPhone), findsNWidgets(2));
      expect(find.text(l.aiLedgerNoReply), findsOneWidget);
      await tester.tap(find.text(l.aiLedgerSent));
      await tester.pumpAndSettle();
      expect(find.byWidgetPredicate((w) => w is SelectableText && w.data == sent), findsOneWidget,
          reason: 'the receipt shows exactly what was sent');
      await _shoot('${tag}_ledger');

      final clear = find.text(l.aiLedgerClear);
      await tester.dragUntilVisible(clear, find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      await tester.tap(clear);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, l.aiLedgerClear));
      await tester.pumpAndSettle();
      expect(find.text(l.aiLedgerEmpty), findsOneWidget);
      expect(c.aiLedger, isEmpty);
    });
  }
}
