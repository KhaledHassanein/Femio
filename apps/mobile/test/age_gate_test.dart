// The 18+ gate in onboarding (MR-48, D-01): a birth year exactly eighteen calendar years
// back asks one question; "no" shows the adults-only notice, "yes" continues her path.

import 'package:femio/app.dart';
import 'package:femio/data/store.dart';
import 'package:femio/features/onboarding/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Today in the tests, so the wheel's years are fixed: 2008 is eighteen years back.
const today = '2026-10-28';

/// Walks welcome → goal (track my period) → the birth-year wheel, then scrolls the
/// wheel by [items] rows from its default (28 years back) towards newer years.
Future<void> _reachYear(WidgetTester tester, {required int items}) async {
  final c = FemioController(MemoryStore(), initialLocale: 'en');
  await c.load();
  await tester.pumpWidget(FemioApp(controller: c, today: today));
  await tester.pumpAndSettle();
  await tester.tap(find.byType(FilledButton));
  await tester.pumpAndSettle();
  await tester.tap(find.byType(OptionTile).first);
  await tester.pumpAndSettle();
  // Dragging down moves the wheel to earlier rows, which are newer years.
  await tester.drag(find.byType(ListWheelScrollView), Offset(0, 52.0 * items));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('born eighteen calendar years ago: the birthday question, then no → the notice', (tester) async {
    await _reachYear(tester, items: 10); // 1998 → 2008
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.text('Has your 18th birthday passed?'), findsOneWidget);

    await tester.tap(find.text('No, not yet'));
    await tester.pumpAndSettle();
    expect(find.text('The tracker is for adults, for now'), findsOneWidget);
  });

  testWidgets('born eighteen calendar years ago: yes → her path continues', (tester) async {
    await _reachYear(tester, items: 10);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    expect(find.text('When did your last period start?'), findsOneWidget);
  });

  testWidgets('born nineteen years ago: no question', (tester) async {
    await _reachYear(tester, items: 9); // 1998 → 2007
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.text('Has your 18th birthday passed?'), findsNothing);
    expect(find.text('When did your last period start?'), findsOneWidget);
  });

  testWidgets('born seventeen years ago: the notice straight away', (tester) async {
    await _reachYear(tester, items: 11); // 1998 → 2009
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.text('The tracker is for adults, for now'), findsOneWidget);
  });
}
