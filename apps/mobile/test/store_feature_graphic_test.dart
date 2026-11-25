// Renders the Google Play feature graphic (1024 × 500) in English, Arabic, French and Spanish.
//
// Why it exists: the store graphic should be drawn from the same tokens, fonts and bloom as
// the app, and re-rendered in one command when the wording changes. Run
// `flutter test --update-goldens test/store_feature_graphic_test.dart`; the PNGs land in
// docs/store/graphics/ and scripts/store/flatten-graphics.py removes the alpha channel Play
// refuses (docs/store/graphics-brief.md).

import 'dart:io';

import 'package:femio/theme/femio_theme.dart';
import 'package:femio/widgets/bloom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _w = 1024.0;
const _h = 500.0;
const _out = '../../../docs/store/graphics';

/// The two lines per listing language, from docs/store/play-listing.*.md.
const _copy = {
  'en': (
    'Your records stay on your phone.',
    'Period  ·  Ovulation  ·  Pregnancy',
  ),
  'ar': ('سجلاتكِ تبقى على هاتفكِ.', 'الدورة  ·  التبويض  ·  الحمل'),
  'fr': ('Vos données restent sur votre téléphone.', 'Règles  ·  Ovulation  ·  Grossesse'),
  'es': ('Tus registros se quedan en tu teléfono.', 'Regla  ·  Ovulación  ·  Embarazo'),
};

Future<void> _loadFonts() async {
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final f in files) {
      loader.addFont(
        Future.value(ByteData.view(File(f).readAsBytesSync().buffer)),
      );
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
}

Widget _graphic(String lang) {
  final (line, stages) = _copy[lang]!;
  final rtl = lang == 'ar';
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: FemioTheme.light(),
    home: Builder(
      builder: (context) {
        final p = context.palette;
        final body = rtl ? 'IBMPlexSansArabic' : 'PlusJakartaSans';
        // Material gives the text its default style (no debug underline).
        return Material(
          type: MaterialType.transparency,
          child: Directionality(
            textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                  colors: [p.plum900, p.artPlum, p.rose400],
                ),
              ),
              child: Stack(
                children: [
                  // The bloom as atmosphere on the far side, never behind the words.
                  const PositionedDirectional(
                    end: -70,
                    top: -40,
                    child: Bloom(size: 520, opacity: .25),
                  ),
                  PositionedDirectional(
                    start: 88,
                    end: 300,
                    top: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // The wordmark is always the Latin "femio".
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            'femio',
                            style: TextStyle(
                              fontFamily: 'Newsreader',
                              fontSize: 92,
                              height: 1,
                              color: p.rose50,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          line,
                          style: TextStyle(
                            fontFamily: body,
                            fontSize: 36,
                            height: 1.25,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          stages,
                          style: TextStyle(
                            fontFamily: body,
                            fontSize: 24,
                            color: p.rose100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

void main() {
  setUpAll(_loadFonts);

  for (final lang in _copy.keys) {
    testWidgets('feature graphic ($lang)', (tester) async {
      tester.view.physicalSize = const Size(_w, _h);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_graphic(lang));
      await tester.pumpAndSettle();
      expect(find.text('femio'), findsOneWidget);
      if (autoUpdateGoldenFiles) {
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('$_out/feature-graphic-$lang.png'),
        );
      }
    });
  }
}
