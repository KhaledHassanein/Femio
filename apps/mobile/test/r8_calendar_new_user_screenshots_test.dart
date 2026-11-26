// R8.10c proof screenshots (owner 2026-11-26): a new user who gave her last period, a 5-day
// period and a 28-day cycle sees her period days, this cycle's fertile window and ovulation
// (already past), and the next period. Written only with --update-goldens, to
// testing-results/2026-11-26-r8-calendar-new-user/.
import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/features/calendar/calendar_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-26-r8-calendar-new-user';
const _today = '2026-11-26';

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  for (final (lang, b) in const [
    ('en', Brightness.light),
    ('en', Brightness.dark),
    ('ar', Brightness.light),
    ('ar', Brightness.dark),
  ]) {
    testWidgets('new-user calendar ($lang ${b.name})', (
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
            periodStarts: const ['2026-11-05'],
            periodLength: 5,
            cycleLength: 28,
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
