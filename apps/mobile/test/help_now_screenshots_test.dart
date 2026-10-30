// Screenshots of the Help now screen at 390×844 with a country chosen (R6.17): Arabic
// light and dark with Lebanon, English light with the United Kingdom. They are the
// evidence in testing-results/2026-10-30-help-now-app/ and are written only under
// `flutter test --update-goldens`; a plain run still builds the screen in each
// combination and taps the chip, which is the part that can regress silently. The number
// asserted is the emergency one, which is inside the 844px fold; the support lines below
// it are the widget test's job (help_now_test.dart).

import 'dart:io';

import 'package:femio/features/help/help_now_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Relative to this file (matchesGoldenFile resolves against the test's directory).
const _out = '../../../testing-results/2026-10-30-help-now-app';

Future<void> _loadFonts() async {
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final f in files) {
      final bytes = File(f).readAsBytesSync();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
    await loader.load();
  }

  await load('Newsreader', ['assets/fonts/Newsreader.ttf']);
  await load('PlusJakartaSans', ['assets/fonts/PlusJakartaSans.ttf']);
  await load('IBMPlexSansArabic', [
    'assets/fonts/IBMPlexSansArabic-Regular.ttf',
    'assets/fonts/IBMPlexSansArabic-Medium.ttf',
    'assets/fonts/IBMPlexSansArabic-SemiBold.ttf',
    'assets/fonts/IBMPlexSansArabic-Bold.ttf',
  ]);
  final sdk = Platform.environment['FLUTTER_ROOT'] ?? '/root/sdk/flutter';
  await load('MaterialIcons', ['$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf']);
}

Widget _app(String locale, Brightness b) => MaterialApp(
      theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
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
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  const cases = [
    ('ar', Brightness.light, 'لبنان', '140'),
    ('ar', Brightness.dark, 'لبنان', '140'),
    ('en', Brightness.light, 'United Kingdom', '999'),
  ];
  for (final (lang, b, chip, number) in cases) {
    final tag = '${lang}_${b.name}';
    testWidgets('help now with a country chosen ($tag)', (tester) async {
      tester.view.physicalSize = const Size(780, 1688);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(lang, b));
      await tester.pumpAndSettle();
      expect(find.text(number), findsNothing);
      await tester.tap(find.text(chip));
      await tester.pumpAndSettle();
      expect(find.text(number), findsOneWidget);
      if (!autoUpdateGoldenFiles) return;
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/${tag}_help_now.png'));
    });
  }
}
