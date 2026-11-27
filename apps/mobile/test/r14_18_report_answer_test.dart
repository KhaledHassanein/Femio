// R14.18: every answer the AI wrote can be reported in the app (Play AI-Generated Content
// policy). The report holds the reason, where the answer was made and the answer itself,
// never her question or record, and goes to the share sheet addressed to support. With
// --update-goldens it writes proof shots (390x844 at 2x, EN and AR, light and dark) to
// testing-results/2026-11-27-r14-18/ (synthetic fixture).

import 'dart:convert';
import 'dart:io';

import 'package:femio/data/share_channel.dart';
import 'package:femio/domain/assistant/prompts.dart';
import 'package:femio/domain/assistant/source_registry.dart';
import 'package:femio/features/assistant/answer_card.dart';
import 'package:femio/features/assistant/report_answer_sheet.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-27-r14-18';
const _question = 'my period is 9 days late, could I be pregnant';

final _registry = SourceRegistry.fromJson(
  jsonDecode(File('assets/trusted_sources/registry.json').readAsStringSync()) as Map<String, Object?>,
);

Future<void> _pump(WidgetTester tester, String lang, Brightness b, {CitedAnswer? summary}) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  final found = searchRegistry('when should I take a pregnancy test', _registry, lang: 'en');
  expect(found.notCovered, isFalse);
  await tester.pumpWidget(MaterialApp(
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
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AnswerCard(answer: found, summary: summary, origin: AnswerOrigin.cloud),
      ),
    ),
  ));
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

  const summary = CitedAnswer('A home pregnancy test is most reliable from the first day of a missed period [1].', {1});

  testWidgets('no report button when the passages are shown word for word', (tester) async {
    await _pump(tester, 'en', Brightness.light);
    expect(find.text(lookupL10n(const Locale('en')).reportAnswer), findsNothing);
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      final l = lookupL10n(Locale(lang));
      final tag = '${lang}_${b.name}';

      testWidgets('an AI answer can be reported, and only the answer leaves ($tag)', (tester) async {
        Map<Object?, Object?>? sent;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(shareChannel, (call) async {
          sent = call.arguments as Map<Object?, Object?>;
          return true;
        });
        addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(shareChannel, null));

        await _pump(tester, lang, b, summary: summary);
        await tester.tap(find.text(l.reportAnswer));
        await tester.pumpAndSettle();
        expect(find.byType(ReportAnswerSheet), findsOneWidget);
        final send = find.widgetWithText(FilledButton, l.reportSend);
        expect(tester.widget<FilledButton>(send).onPressed, isNull, reason: 'a reason first');
        expect(find.text(l.reportPreview), findsNothing);
        await tester.tap(find.text(l.reportUnsafe));
        await tester.pumpAndSettle();
        // PRIV-N2-2: the exact text is shown before it leaves.
        expect(find.text(l.reportPreview), findsOneWidget);
        final shown = tester.widget<SelectableText>(find.descendant(of: find.byType(ReportAnswerSheet), matching: find.byType(SelectableText))).data!;
        expect(shown, contains(summary.text));
        await _shoot(tester, '${tag}_05_report_answer');

        await tester.tap(send);
        await tester.pumpAndSettle();
        expect(sent?['to'], answerReportAddress);
        expect(sent?['subject'], l.reportSubject);
        final text = sent?['text'] as String;
        expect(text, shown, reason: 'what was shown is what was sent');
        expect(text, contains(summary.text));
        expect(text, contains(l.reportUnsafe));
        expect(text, contains(l.askAnswerCloud));
        expect(text, isNot(contains(_question)));
        expect(find.byType(ReportAnswerSheet), findsNothing);
        expect(find.text(l.reportThanks), findsOneWidget);
      });
    }
  }

  test('the report text is the reason, the origin and the answer, nothing else', () {
    final l = lookupL10n(const Locale('en'));
    final text = answerReportText(l, reason: ReportReason.wrong, origin: l.askAnswerOnPhone, answer: summary.text);
    expect(text, 'Reason: ${l.reportWrong}\nMade by: ${l.askAnswerOnPhone}\n\nAnswer:\n${summary.text}');
  });

  testWidgets('no share sheet: the report is copied instead', (tester) async {
    final l = lookupL10n(const Locale('en'));
    final calls = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      calls.add(call.method);
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
    // The sheet could not open (Android said no): the channel answers false.
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(shareChannel, (_) async => false);
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(shareChannel, null));
    await _pump(tester, 'en', Brightness.light, summary: summary);
    await tester.tap(find.text(l.reportAnswer));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.reportWrong));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.reportSend));
    await tester.pumpAndSettle();
    expect(calls, contains('Clipboard.setData'));
    expect(find.text(l.reportCopied(answerReportAddress)), findsOneWidget);
  });
}
