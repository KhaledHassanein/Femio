// The pregnancy warning-signs screen (MR-29): the sourced sentence, the five symptoms
// as a list, both sources, and the link to the guide when the library has it.

import 'dart:convert';

import 'package:femio/data/library.dart';
import 'package:femio/features/help/red_flags_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// A library whose only guide is the warning-signs one, in English.
Library _library() => Library(
      load: (path) async => path.endsWith('/en.json')
          ? jsonEncode([
              {'slug': 'pregnancy-warning-signs', 'title': 'Pregnancy warning signs', 'body': {}, 'sources': []},
            ])
          : '[]',
    );

Widget _app(String locale, {Library? library}) => MaterialApp(
      theme: FemioTheme.light(),
      locale: Locale(locale),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: RedFlagsScreen(library: library),
    );

/// A phone-shaped, tall viewport so the whole list is built (the ListView is lazy).
Future<void> _pump(WidgetTester tester, Widget app) async {
  tester.view.physicalSize = const Size(1170, 6000);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('English: the sourced sentence, five symptoms and two sources', (tester) async {
    await _pump(tester, _app('en'));
    expect(find.textContaining('swelling of the face or hands, or difficulty breathing'), findsOneWidget);
    for (final s in ['A severe headache', 'Changes in your vision', 'Pain in the upper abdomen', 'Swelling of the face or hands', 'Difficulty breathing']) {
      expect(find.text(s), findsOneWidget);
    }
    expect(find.text('acog.org'), findsOneWidget);
    expect(find.text('cdc.gov'), findsOneWidget);
    // The unsourced additions are not on the screen.
    expect(find.textContaining('Bleeding'), findsNothing);
    expect(find.textContaining('reduced movements'), findsNothing);
  });

  testWidgets('Arabic: the same list in Arabic, no guide link without a library', (tester) async {
    await _pump(tester, _app('ar'));
    expect(find.text('صداع شديد'), findsOneWidget);
    expect(find.text('صعوبة في التنفس'), findsOneWidget);
    expect(find.textContaining('اطلبي الرعاية فورًا إذا كان لديكِ'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('with a library the guide link appears and opens the guide', (tester) async {
    await _pump(tester, _app('en', library: _library()));
    expect(find.text('Read the pregnancy warning signs'), findsOneWidget);
    await tester.tap(find.text('Read the pregnancy warning signs'));
    await tester.pumpAndSettle();
    expect(find.text('Pregnancy warning signs'), findsWidgets);
  });
}
