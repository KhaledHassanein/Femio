// The language-selection page (WelcomeStep) sits on a dark Dusk gradient and keeps AA
// contrast (owner 2026-11-27: "too light now"). The contrast test is plain arithmetic on
// the design tokens; with --update-goldens the shot test also writes proof PNGs (390x844 at
// 2x, EN and AR, light and dark) to testing-results/2026-11-27-language-page/
// (synthetic fixture, no record data).

import 'dart:math' as math;

import 'package:femio/app.dart';
import 'package:femio/data/store.dart';
import 'package:femio/features/onboarding/steps/welcome_step.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:femio/theme/tokens.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-27-language-page';

/// WCAG relative-luminance contrast ratio of an opaque [fg] over an opaque [bg].
double _contrast(Color fg, Color bg) {
  final a = fg.computeLuminance(), b = bg.computeLuminance();
  return (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05);
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  test('text and controls on the lightest point of the gradient keep AA', () {
    for (final p in [FemioPalette.light, FemioPalette.dark]) {
      final ground = p.plum700; // the lightest stop of the gradient
      final white90 = Color.alphaBlend(Colors.white.withValues(alpha: 0.9), ground);
      final pill = Color.alphaBlend(Colors.white.withValues(alpha: 0.14), ground);
      expect(_contrast(Colors.white, ground), greaterThanOrEqualTo(4.5)); // title, labels
      expect(_contrast(white90, ground), greaterThanOrEqualTo(4.5)); // body, tagline
      expect(_contrast(Colors.white, pill), greaterThanOrEqualTo(4.5)); // unselected pill text
      expect(_contrast(p.auroraGround, Colors.white), greaterThanOrEqualTo(4.5)); // selected pill
      expect(_contrast(p.primarySolid, Colors.white), greaterThanOrEqualTo(4.5)); // start button
    }
  });

  for (final b in Brightness.values) {
    for (final lang in ['en', 'ar']) {
      testWidgets('language page shot ($lang, ${b.name})', (tester) async {
        tester.view.physicalSize = const Size(780, 1688);
        tester.view.devicePixelRatio = 2;
        addTearDown(tester.view.reset);
        final c = FemioController(MemoryStore(), initialLocale: lang);
        await c.load();
        await tester.pumpWidget(MaterialApp(
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
          home: WelcomeStep(controller: c, onStart: () {}),
        ));
        await tester.pumpAndSettle();
        expect(find.byType(WelcomeStep), findsOneWidget);
        if (!autoUpdateGoldenFiles) return;
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/${lang}_${b.name}.png'));
      });
    }
  }
}
