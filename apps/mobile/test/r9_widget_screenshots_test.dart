// Screenshots of the home-screen widget switch in Settings (R9.11) at 390x844: English and
// Arabic, light and dark, switch off (the default) and on. The native widget cannot be
// golden-tested in Flutter, so its look is checked on a phone or emulator; these show
// the part Flutter draws. PNGs are written to testing-results/2026-11-26-r9-widget/ only
// under `flutter test --update-goldens` on this file; a plain run still builds each
// screen and checks the switch, which is the part that can regress silently.

import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/features/settings/settings_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Relative to this file (matchesGoldenFile resolves against the test's directory).
const _out = '../../../testing-results/2026-11-26-r9-widget';

Future<void> _loadFonts() async {
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final f in files) {
      loader.addFont(Future.value(ByteData.view(File(f).readAsBytesSync().buffer)));
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

Profile _profile(String lang, bool on) => Profile(
      goal: Goal.pregnant,
      locale: lang,
      birthYear: 1994,
      edd: '2027-02-01',
      settings: AppSettings(widgetDetails: on),
    );

void main() {
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      for (final on in [false, true]) {
        final tag = '${lang}_${b.name}_${on ? 'on' : 'off'}';
        testWidgets('the widget switch in Settings ($tag)', (tester) async {
          tester.view.physicalSize = const Size(780, 1688);
          tester.view.devicePixelRatio = 2;
          tester.platformDispatcher.platformBrightnessTestValue = b;
          addTearDown(tester.view.reset);
          final c = FemioController(MemoryStore(_profile(lang, on)));
          await c.load();
          await tester.pumpWidget(MaterialApp(
            theme: FemioTheme.light(),
            darkTheme: FemioTheme.dark(),
            locale: Locale(lang),
            supportedLocales: [for (final code in supportedLanguages) Locale(code)],
            localizationsDelegates: const [
              L10n.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: SettingsScreen(controller: c),
          ));
          await tester.pumpAndSettle();
          final l = lookupL10n(Locale(lang));
          await tester.scrollUntilVisible(find.text(l.settingsWidgetDetailsNote), 200, scrollable: find.byType(Scrollable).first);
          // Bring the switch's title back under the app bar, so the shot shows title, note and switch.
          await tester.drag(find.byType(Scrollable).first, const Offset(0, 200));
          await tester.pumpAndSettle();
          expect(find.text(l.settingsWidgetDetails), findsOneWidget);
          expect(tester.widget<SwitchListTile>(find.widgetWithText(SwitchListTile, l.settingsWidgetDetails)).value, on);
          if (autoUpdateGoldenFiles) {
            await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/settings_$tag.png'));
          }
        });
      }
    }
  }
}
