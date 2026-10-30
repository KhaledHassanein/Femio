// Help now: the approved sentence is always visible, numbers appear only after a
// country is chosen, and emergency lines are drawn apart from support lines.

import 'package:femio/features/help/help_now_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/theme/femio_theme.dart';
import 'package:femio/widgets/tab_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(String locale) => MaterialApp(
  theme: FemioTheme.light(),
  locale: Locale(locale),
  supportedLocales: const [Locale('en'), Locale('ar')],
  localizationsDelegates: const [
    L10n.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: const HelpNowScreen(),
);

/// A tall viewport: the ListView is lazy, and with sixteen chips the support lines sit
/// below the default 600px fold, where a finder would not see them.
void _tall(WidgetTester tester) {
  tester.view.physicalSize = const Size(780, 3200);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('shows the global guidance first and no number until a country is picked', (tester) async {
    await tester.pumpWidget(_app('en'));
    await tester.pumpAndSettle();
    expect(find.textContaining('contact the emergency services available where you are now'), findsOneWidget);
    expect(find.text('123'), findsNothing);
    expect(find.text('997'), findsNothing);
  });

  testWidgets('Egypt shows its ambulance and support numbers, apart', (tester) async {
    _tall(tester);
    await tester.pumpWidget(_app('ar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('مصر'));
    await tester.pumpAndSettle();
    expect(find.text('123'), findsOneWidget);
    expect(find.text('16328'), findsOneWidget);
    expect(find.text('997'), findsNothing);
    expect(find.text('خدمات الطوارئ'), findsOneWidget);
    expect(find.text('خطوط الدعم'), findsOneWidget);
  });

  testWidgets('sixteen country chips; Lebanon shows the Red Cross line and the lifeline, nothing from Egypt', (tester) async {
    _tall(tester);
    await tester.pumpWidget(_app('ar'));
    await tester.pumpAndSettle();
    expect(find.byType(ChoiceChip), findsNWidgets(16));
    await tester.tap(find.text('لبنان'));
    await tester.pumpAndSettle();
    expect(find.text('140'), findsOneWidget);
    expect(find.text('1564'), findsOneWidget);
    expect(find.text('123'), findsNothing);
  });

  testWidgets('a country with emergency lines only draws no empty support group', (tester) async {
    _tall(tester);
    await tester.pumpWidget(_app('en'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kuwait'));
    await tester.pumpAndSettle();
    expect(find.text('112'), findsOneWidget);
    expect(find.text('Emergency services'), findsWidgets);
    expect(find.text('Support lines'), findsNothing);
  });

  testWidgets('the tab header carries the Help now button and it opens the screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FemioTheme.light(),
        localizationsDelegates: const [
          L10n.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: const Scaffold(body: TabHeader(title: 'Calendar')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Calendar'), findsOneWidget);
    await tester.tap(find.byTooltip('Need help now?'));
    await tester.pumpAndSettle();
    expect(find.byType(HelpNowScreen), findsOneWidget);
  });
}
