// R8.9 and R8.10 proof screenshots: the calendar with steady cycles shows the next three
// periods as widening ranges (the last dashed, "possible") and the ovulation day inside the
// fertile window. Written only with --update-goldens, to testing-results/2026-11-24-r8-calendar/.
import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/features/calendar/calendar_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _out = '../../../testing-results/2026-11-24-r8-calendar';
const _today = '2026-06-20';

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
  await load('MaterialIcons', [
    '$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  ]);
}

void main() {
  setUpAll(() async {
    await _loadFonts();
    configureFormatting();
  });

  for (final (lang, b) in const [
    ('en', Brightness.light),
    ('ar', Brightness.light),
    ('ar', Brightness.dark),
  ]) {
    testWidgets('calendar with three predicted periods ($lang ${b.name})', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(780, 2300);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      final c = FemioController(
        MemoryStore(
          Profile(
            goal: Goal.ttc,
            locale: lang,
            birthYear: 1994,
            periodStarts: const [
              '2026-01-01',
              '2026-01-29',
              '2026-02-26',
              '2026-03-26',
              '2026-04-23',
              '2026-05-21',
              '2026-06-18',
            ],
            settings: AppSettings.defaultsFor(lang)
                .copyWith(storageNoticeSeen: true, showHijri: false),
          ),
        ),
        initialLocale: lang,
      );
      await c.load();
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
          locale: Locale(lang),
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
            Locale('fr'),
            Locale('es'),
          ],
          localizationsDelegates: const [
            L10n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: CalendarScreen(controller: c, today: _today, onDay: (_) {}),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Move to July so the first predicted period and its fertile window are both on screen.
      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pumpAndSettle();
      final l = lookupL10n(Locale(lang));
      expect(find.text(l.upcomingPeriodsTitle), findsOneWidget);
      expect(find.text(l.upcomingPeriodsWider), findsOneWidget);
      if (autoUpdateGoldenFiles) {
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('$_out/calendar_${lang}_${b.name}.png'),
        );
      }
    });
  }
}
