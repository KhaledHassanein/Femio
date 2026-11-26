// R8.2 proof screenshots: Today with the dashboard on top, then the log, the assistant and
// the tips, and the two notices (urgent care, privacy) at the bottom. Trying to conceive and
// pregnancy, in English light, Arabic light and Arabic dark. Written only with
// --update-goldens, to testing-results/2026-11-24-r8-today/.
import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-24-r8-today';
const _today = '2026-11-24';

Profile _ttc(String lang) => Profile(
  goal: Goal.ttc,
  locale: lang,
  birthYear: 1994,
  periodStarts: const ['2026-08-08', '2026-09-05', '2026-10-04', '2026-11-01'],
  settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
);

Profile _pregnant(String lang) => Profile(
  goal: Goal.pregnant,
  locale: lang,
  birthYear: 1993,
  edd: '2027-03-10',
  settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
);

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  for (final (slug, make) in [('ttc', _ttc), ('pregnant', _pregnant)]) {
    for (final (lang, b) in const [('en', Brightness.light), ('ar', Brightness.light), ('ar', Brightness.dark)]) {
      testWidgets('today $slug ($lang ${b.name})', (tester) async {
        tester.view.physicalSize = const Size(780, 4800);
        tester.view.devicePixelRatio = 2;
        tester.platformDispatcher.platformBrightnessTestValue = b;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearAllTestValues);
        final c = FemioController(MemoryStore(make(lang)), initialLocale: lang);
        await c.load();
        await tester.pumpWidget(FemioApp(controller: c, today: _today));
        await tester.pumpAndSettle();
        final l = lookupL10n(Locale(lang));
        // The urgent-care notice comes after the tips, and the privacy line is last.
        final urgent = tester.getTopLeft(find.text(l.pregRedFlagsHeading)).dy;
        final privacy = tester.getTopLeft(find.text(l.privacyLine)).dy;
        expect(urgent, lessThan(privacy));
        if (autoUpdateGoldenFiles) {
          await expectLater(find.byType(MaterialApp).first, matchesGoldenFile('$_out/today_${slug}_${lang}_${b.name}.png'));
        }
      });
    }
  }
}
