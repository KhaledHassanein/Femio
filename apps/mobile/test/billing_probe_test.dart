// R6.9 spike: the probe tile reports what the injected probe returns, never a guess,
// and the result reads in Arabic as well as English. The real probe talks to the Play
// Store app and is exercised on a phone (testing-results/2026-10-29-play-billing-spike).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:femio/features/plus/billing_probe.dart';
import 'package:femio/features/plus/billing_probe_tile.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/theme/femio_theme.dart';

Future<void> _pump(WidgetTester tester, Locale locale, Future<BillingProbeResult> Function() probe) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: FemioTheme.light(),
      locale: locale,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      home: Scaffold(body: BillingProbeTile(probe: probe)),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the invitation before any tap and the store answer after it', (tester) async {
    var calls = 0;
    await _pump(tester, const Locale('en'), () async {
      calls++;
      return const BillingProbeResult(available: true, productFound: false);
    });
    expect(find.textContaining('Tap to ask Google Play'), findsOneWidget);
    expect(calls, 0, reason: 'the probe only runs on a tap, never on build');

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(find.textContaining('Play Billing reachable: yes'), findsOneWidget);
    expect(find.textContaining('not found yet'), findsOneWidget);
  });

  testWidgets('reports an unreachable store and its message, in Arabic', (tester) async {
    await _pump(tester, const Locale('ar'), () async => const BillingProbeResult(available: false, productFound: false, error: 'BillingResponse.billingUnavailable'));
    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();
    expect(find.textContaining('فوترة Play متاحة: لا'), findsOneWidget);
    expect(find.textContaining('billingUnavailable'), findsOneWidget);
    expect(find.textContaining('femio_plus'), findsNothing, reason: 'no product line when the store is unreachable');
  });

  test('the product id is the one the owner creates in Play Console', () {
    expect(plusProductId, 'femio_plus');
  });
}
