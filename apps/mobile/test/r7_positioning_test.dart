// R7.7: the positioning line "femio: AI-assisted women's health & wellness" (ADR-078 §8)
// appears on the app's welcome screen in the same words as the website hero, in all
// four languages. The parity check reads the website catalogues directly, so a change
// on one side without the other fails here. Screenshots land in
// testing-results/2026-11-25-r7-positioning/ under `--update-goldens` (this file only).
import 'dart:convert';
import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/store.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-25-r7-positioning';

/// The website's hero eyebrow for [lang], read from `apps/web/messages/<lang>.json`.
String _webTagline(String lang) {
  final json = jsonDecode(File('../web/messages/$lang.json').readAsStringSync()) as Map<String, dynamic>;
  return ((json['home'] as Map)['hero'] as Map)['eyebrow'] as String;
}

void main() {
  setUpAll(() async {
    configureFormatting();
    await loadAppFonts();
  });

  for (final lang in ['en', 'ar', 'fr', 'es']) {
    test('the welcome tagline matches the website word for word ($lang)', () async {
      final l = await L10n.delegate.load(Locale(lang));
      expect(l.welcomeTagline, _webTagline(lang));
    });
  }

  for (final (lang, b) in [
    ('en', Brightness.light),
    ('en', Brightness.dark),
    ('ar', Brightness.light),
    ('ar', Brightness.dark),
  ]) {
    testWidgets('the welcome screen shows the tagline (${lang}_${b.name})', (tester) async {
      tester.view.physicalSize = const Size(780, 1688);
      tester.view.devicePixelRatio = 2;
      tester.platformDispatcher.platformBrightnessTestValue = b;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      final c = FemioController(MemoryStore(), initialLocale: lang);
      await c.load();
      await tester.pumpWidget(FemioApp(controller: c, today: '2026-11-25'));
      await tester.pumpAndSettle();
      final l = await L10n.delegate.load(Locale(lang));
      expect(find.text(l.welcomeTagline), findsOneWidget);
      if (autoUpdateGoldenFiles) {
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/${lang}_${b.name}_welcome.png'));
      }
    });
  }
}
