// R14.12: clinical P2 fixes from the 2026-11-26 audit. A long bleed stays one period
// (CLIN-14, also in fixtures/domain/cycle-prediction.json); the fertile window's range
// check uses her observed length once the forecast is her own (CLIN-17); her BMI band is
// named by its numbers, never as a verdict (CLIN-19, MR-55); ovulation is "around" a date
// (CLIN-16). Synthetic fixtures.

import 'package:femio/data/profile.dart';
import 'package:femio/domain/cycle_prediction.dart';
import 'package:femio/domain/fertility.dart';
import 'package:femio/features/tools/weight_gain_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(configureFormatting);
  final l = lookupL10n(const Locale('en'));

  test('CLIN-14 a bleed logged every day for two weeks is one period', () {
    final daily = [for (var i = 1; i <= 14; i++) '2026-01-${i.toString().padLeft(2, '0')}'];
    expect(bleedStarts([...daily, '2026-01-29']), ['2026-01-01', '2026-01-29']);
    // A separate bleed after a dry spell still starts a new period.
    expect(bleedStarts(['2026-01-01', '2026-01-02', '2026-01-17']), ['2026-01-01', '2026-01-17']);
  });

  test('CLIN-17 stated 28 but observed 38: no window is named (MR-08)', () {
    final p = Profile(
      goal: Goal.ttc,
      locale: 'en',
      periodStarts: const ['2026-07-01', '2026-08-08', '2026-09-15', '2026-10-23'],
      cycleLength: 28,
    );
    final pred = predictNextPeriod(p.cycleStarts, p.cycleLength)!;
    expect(pred.basis, 'observed');
    expect(pred.averageLength, 38);
    expect(fertileWindowFor(p, pred), isNull);
    expect(windowStatusFor(p, pred), WindowStatus.outsideRange);
  });

  test('CLIN-17 a stated length still counts before her own cycles do', () {
    final p = Profile(goal: Goal.ttc, locale: 'en', periodStarts: const ['2026-11-01'], cycleLength: 28);
    final pred = predictNextPeriod(p.cycleStarts, p.cycleLength)!;
    expect(fertileWindowFor(p, pred), isNotNull);
  });

  test('CLIN-16 ovulation is "around" a date', () {
    expect(l.predictionOvulation('4 Dec'), 'Likely ovulation around 4 Dec');
  });

  testWidgets('CLIN-19 the BMI band is named by its numbers', (tester) async {
    tester.view.physicalSize = const Size(780, 3000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: FemioTheme.light(),
      localizationsDelegates: const [L10n.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
      supportedLocales: const [Locale('en')],
      home: const WeightGainScreen(),
    ));
    await tester.enterText(find.byKey(const ValueKey('gain-weight')), '90');
    await tester.enterText(find.byKey(const ValueKey('gain-height')), '165');
    await tester.pumpAndSettle();
    expect(find.textContaining(l.toolBandFrom('30')), findsOneWidget);
    expect(find.textContaining('Obese'), findsNothing);
  });
}
