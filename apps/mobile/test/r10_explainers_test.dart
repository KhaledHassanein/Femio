// Screens for the calendar explainers (R9.6, R10.13): "Why this range?", "Explain this day"
// on a future day, and the note after a logged period moves the estimate.
//
// Why it exists: the sheets must say what the calendar shows, in her language, and the note
// must appear only when the estimate moved. Screenshots land in
// testing-results/2026-11-25-r10-explainers/ under `--update-goldens`.

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/cycle_prediction.dart';
import 'package:femio/features/calendar/calendar_screen.dart';
import 'package:femio/features/log/log_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/l10n/log_labels.g.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-25-r10-explainers';
const _today = '2026-06-20';

/// Three steady 28-day cycles: medium confidence, next period around 16 July.
const _starts = ['2026-03-26', '2026-04-23', '2026-05-21', '2026-06-18'];

Future<FemioController> _controller(String lang) async {
  final c = FemioController(
    MemoryStore(
      Profile(
        goal: Goal.ttc,
        locale: lang,
        birthYear: 1994,
        periodStarts: _starts,
        settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
      ),
    ),
    initialLocale: lang,
  );
  await c.load();
  return c;
}

Widget _app(String lang, Brightness b, Widget body) => MaterialApp(
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
      home: Scaffold(body: body),
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

    testWidgets('why this range and explain a future day ($tag)', (tester) async {
      _phone(tester);
      final c = await _controller(lang);
      final l = lookupL10n(Locale(lang));
      await tester.pumpWidget(_app(lang, b, CalendarScreen(controller: c, today: _today, onDay: (_) {})));
      await tester.pumpAndSettle();

      final why = find.text(l.whyRangeAction, skipOffstage: false);
      await tester.ensureVisible(why);
      await tester.pumpAndSettle();
      await tester.tap(why);
      await tester.pumpAndSettle();
      expect(find.text(l.whyRangeTitle), findsOneWidget);
      expect(find.text(l.whyRangeCycles(3)), findsOneWidget, reason: 'three cycles measured');
      expect(find.text(l.whyRangeNextHigh(3)), findsOneWidget, reason: 'three more steady cycles reach high');
      await _shoot('${tag}_why_range');
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      // July holds the next period (around 16 July); a tap on that future day explains it.
      await tester.scrollUntilVisible(find.byIcon(Icons.chevron_right_rounded), -300, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pumpAndSettle();
      final next = predictNextPeriod(_starts)!;
      expect(next.predictedStart, '2026-07-16');
      await tester.tap(find.text('16'));
      await tester.pumpAndSettle();
      expect(find.text(l.dayLogAction), findsNothing, reason: 'a future day cannot be logged');
      expect(find.text(l.predictionNote), findsOneWidget, reason: 'an estimate always says it is one');
      await _shoot('${tag}_explain_day');
    });

    testWidgets('logging a period says how the next one moved ($tag)', (tester) async {
      _phone(tester);
      final c = await _controller(lang);
      final l = lookupL10n(Locale(lang));
      var date = '2026-07-15';
      await tester.pumpWidget(_app(
        lang,
        b,
        StatefulBuilder(
          builder: (context, set) => LogScreen(
            controller: c,
            today: '2026-07-15',
            date: date,
            onDateChanged: (d) => set(() => date = d),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text(flowLabel(l, 'medium')));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(l.predictionWhy), findsOneWidget);
      await _shoot('${tag}_moved_note');

      // "Why?" on the note opens the same range explainer.
      await tester.tap(find.text(l.predictionWhy));
      await tester.pumpAndSettle();
      expect(find.text(l.whyRangeTitle), findsOneWidget);
    });
  }
}
