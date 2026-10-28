// Screenshots of the two R4.8 screens at 390×844, light and dark, Arabic and English:
// the 18th-birthday question and the pregnancy warning-signs screen. They are the
// evidence in testing-results/2026-10-28-r48-age-redflags/ and are written only under
// `flutter test --update-goldens`; a plain run still builds both screens in all four
// combinations, which is the part that can regress silently.

import 'dart:io';

import 'package:femio/data/library.dart';
import 'package:femio/features/help/red_flags_screen.dart';
import 'package:femio/features/onboarding/steps/eighteen_step.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Relative to this file (matchesGoldenFile resolves against the test's directory).
const _out = '../../../testing-results/2026-10-28-r48-age-redflags';

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

Widget _app(String locale, Brightness b, Widget home) => MaterialApp(
      theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
      locale: Locale(locale),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: home,
    );

/// The warning-signs guide alone, so the foot of the screen shows its link.
Library _library() => Library(
      load: (path) async => path.endsWith('/en.json')
          ? '[{"slug":"pregnancy-warning-signs","title":"Pregnancy warning signs","body":{},"sources":[]}]'
          : '[]',
    );

Future<void> _shoot(WidgetTester tester, Widget app, String name) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
  if (!autoUpdateGoldenFiles) return;
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/$name.png'));
}

void main() {
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  for (final b in Brightness.values) {
    for (final lang in ['en', 'ar']) {
      final tag = '${lang}_${b.name}';
      testWidgets('18th-birthday question ($tag)', (tester) async {
        await _shoot(tester, _app(lang, b, EighteenStep(progress: 0.3, onBack: () {}, onYes: () {}, onNo: () {})), '${tag}_eighteen');
        expect(find.byType(EighteenStep), findsOneWidget);
      });
      testWidgets('warning-signs screen ($tag)', (tester) async {
        await _shoot(tester, _app(lang, b, RedFlagsScreen(library: _library())), '${tag}_red_flags');
        expect(find.byType(RedFlagsScreen), findsOneWidget);
      });
    }
  }
}
