// Help now: the approved sentence is always visible, numbers appear only after a
// country is chosen, and emergency lines are drawn apart from support lines.

import 'package:femio/features/help/help_now_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/theme/femio_theme.dart';
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

void main() {
  testWidgets('shows the global guidance first and no number until a country is picked', (tester) async {
    await tester.pumpWidget(_app('en'));
    await tester.pumpAndSettle();
    expect(find.textContaining('contact the emergency services available where you are now'), findsOneWidget);
    expect(find.text('123'), findsNothing);
    expect(find.text('997'), findsNothing);
  });

  testWidgets('Egypt shows its ambulance and support numbers, apart', (tester) async {
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
}
