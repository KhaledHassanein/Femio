// The Google Play graphics: the 512×512 store icon and the 1024×500 feature graphic in
// English and Arabic. They are the files in docs/store/graphics/.
//
// Why it exists: like the screenshots, store graphics drift from the brand the moment a
// token or the launcher icon changes. Rendering them from the theme tokens and the real
// launcher layers means `flutter test --update-goldens test/store_graphics_test.dart`
// rebuilds all three. A plain run builds every frame and checks it, and writes nothing.
//
// Play's rules (support.google.com/googleplay/android-developer/answer/9866151, read
// 2026-11-01):
//  - Icon: 512×512, 32-bit PNG with alpha, at most 1024 KB, a full-bleed square (Play
//    applies the mask and shadow), no badges or text beyond the logo.
//  - Feature graphic: 1024×500, JPEG or 24-bit PNG with NO alpha channel; keep the logo,
//    name and slogan near the centre because the edges may be cropped or overlaid.
// The files are therefore written by the small PNG encoder below rather than by
// matchesGoldenFile, which always writes RGBA: the icon keeps its alpha channel and the
// feature graphics are written as plain RGB.
//
// The icon is the adaptive launcher icon composed exactly as Android does it: the flat
// ic_launcher_background colour (plum-900, from the tokens) under the ic_launcher_foreground
// layer from the xxxhdpi mipmap folder. All other colours, fonts and sizes come from the
// theme tokens. The wordmark is always the Latin "femio", also in the Arabic graphic.

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:femio/theme/femio_theme.dart';
import 'package:femio/theme/spacing.dart';
import 'package:femio/widgets/bloom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:femio/l10n/app_localizations.dart';

// ---- geometry (logical pixels) ---------------------------------------------------------

const _iconSize = 512.0;
const _graphicWidth = 512.0;
const _graphicHeight = 250.0;

/// The feature graphic is laid out at half size and rendered at 2x: 1024×500 pixels.
const _graphicRatio = 2.0;

/// Side margin of the text block: well inside the edges Play may crop.
const _graphicInset = 56.0;

/// Width of the text block; the line wraps to two short lines inside it.
const _textWidth = 236.0;
const _heroSize = 168.0;
const _heroInset = 36.0;
const _wordmarkSize = 52.0;
const _lineSize = 20.0;

/// The adaptive launcher foreground (432 px = 108 dp at xxxhdpi), relative to apps/mobile.
const _foreground = 'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_foreground.png';

/// Output folder, relative to apps/mobile (the working directory of `flutter test`).
const _out = '../../docs/store/graphics';

/// The one line under the wordmark: the feature-graphic line of docs/store/play-listing.*.md.
const _lines = {'en': 'Your records never leave your phone.', 'ar': 'سجلاتكِ لا تغادر هاتفكِ.'};

// ---- harness ---------------------------------------------------------------------------

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
}

const _boundaryKey = ValueKey('store-graphic');

Widget _app(String lang, Widget Function(BuildContext) build) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: FemioTheme.light(),
  locale: Locale(lang),
  supportedLocales: const [Locale('en'), Locale('ar')],
  localizationsDelegates: const [
    L10n.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: Builder(
    builder: (context) => RepaintBoundary(key: _boundaryKey, child: build(context)),
  ),
);

// ---- the two graphics ------------------------------------------------------------------

/// The store icon: plum-900 background layer with the launcher's foreground layer on top,
/// full-bleed and square (Play applies the mask itself).
Widget _icon(BuildContext context, ui.Image foreground) => ColoredBox(
  color: context.palette.plum900,
  child: SizedBox.expand(
    child: RawImage(image: foreground, fit: BoxFit.fill, filterQuality: FilterQuality.high),
  ),
);

/// The feature graphic: Dusk Bloom gradient, the wordmark and one line at the start edge,
/// the Bloom as the hero at the other. In Arabic the whole layout mirrors (RTL) but the
/// wordmark stays Latin and left-to-right.
Widget _featureGraphic(BuildContext context, String lang) {
  final p = context.palette;
  final t = Theme.of(context).textTheme;
  return DecoratedBox(
    decoration: BoxDecoration(
      // The same dusk as the app icon: a plum-400 glow high on the hero side, falling
      // through plum-700 to plum-900.
      gradient: RadialGradient(
        center: const AlignmentDirectional(0.5, -0.5),
        radius: 1.0,
        colors: [p.plum400, p.plum700, p.plum900],
        stops: const [0, 0.5, 1],
      ),
    ),
    child: Stack(
      children: [
        PositionedDirectional(
          start: _graphicInset,
          top: 0,
          bottom: 0,
          width: _textWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  'femio',
                  style: t.displaySmall?.copyWith(color: p.artCream, fontSize: _wordmarkSize, height: 1.1),
                ),
              ),
              const SizedBox(height: space3),
              Text(
                _lines[lang]!,
                style: t.titleLarge?.copyWith(color: p.artCream, fontSize: _lineSize, height: 1.35),
              ),
            ],
          ),
        ),
        PositionedDirectional(
          end: _heroInset,
          top: (_graphicHeight - _heroSize) / 2,
          child: Bloom(size: _heroSize),
        ),
      ],
    ),
  );
}

// ---- PNG writing -----------------------------------------------------------------------

/// CRC-32 of [bytes], as PNG chunks require.
int _crc32(List<int> bytes) {
  var crc = 0xFFFFFFFF;
  for (final b in bytes) {
    crc ^= b;
    for (var k = 0; k < 8; k++) {
      crc = (crc & 1) != 0 ? (crc >> 1) ^ 0xEDB88320 : crc >> 1;
    }
  }
  return crc ^ 0xFFFFFFFF;
}

/// Encodes straight RGBA pixels as a PNG: colour type 6 (32-bit, with alpha) when
/// [withAlpha], else colour type 2 (24-bit RGB, no alpha channel at all).
Uint8List _encodePng(Uint8List rgba, int width, int height, {required bool withAlpha}) {
  final channels = withAlpha ? 4 : 3;
  final raw = BytesBuilder();
  for (var y = 0; y < height; y++) {
    raw.addByte(0); // filter: none
    for (var x = 0; x < width; x++) {
      final i = (y * width + x) * 4;
      raw.add(withAlpha ? rgba.sublist(i, i + 4) : rgba.sublist(i, i + 3));
    }
  }
  assert(raw.length == height * (1 + width * channels));
  final out = BytesBuilder()..add(const [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);
  void chunk(String type, List<int> data) {
    final body = [...type.codeUnits, ...data];
    out
      ..add((ByteData(4)..setUint32(0, data.length)).buffer.asUint8List())
      ..add(body)
      ..add((ByteData(4)..setUint32(0, _crc32(body))).buffer.asUint8List());
  }

  final header = ByteData(13)
    ..setUint32(0, width)
    ..setUint32(4, height)
    ..setUint8(8, 8) // bit depth
    ..setUint8(9, withAlpha ? 6 : 2);
  chunk('IHDR', header.buffer.asUint8List());
  chunk('IDAT', ZLibCodec(level: 9).encode(raw.toBytes()));
  chunk('IEND', const []);
  return out.toBytes();
}

/// Renders the boundary and, under --update-goldens, writes it to [name] in [_out].
Future<void> _write(
  WidgetTester tester,
  String name,
  int width,
  int height,
  double ratio, {
  required bool withAlpha,
}) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_boundaryKey));
  final image = await tester.runAsync(() => boundary.toImage(pixelRatio: ratio));
  expect((image!.width, image.height), (width, height));
  if (!autoUpdateGoldenFiles) return;
  final data = await tester.runAsync(() => image.toByteData(format: ui.ImageByteFormat.rawStraightRgba));
  Directory(_out).createSync(recursive: true);
  File('$_out/$name').writeAsBytesSync(_encodePng(data!.buffer.asUint8List(), width, height, withAlpha: withAlpha));
}

void main() {
  setUpAll(_loadFonts);

  testWidgets('store icon 512', (tester) async {
    tester.view.physicalSize = const Size(_iconSize, _iconSize);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final bytes = File(_foreground).readAsBytesSync();
    final foreground = (await tester.runAsync(
      () async => (await (await ui.instantiateImageCodec(bytes)).getNextFrame()).image,
    ))!;
    await tester.pumpWidget(_app('en', (c) => _icon(c, foreground)));
    await tester.pump();
    await _write(tester, 'icon-512.png', 512, 512, 1, withAlpha: true);
  });

  for (final lang in ['en', 'ar']) {
    testWidgets('feature graphic ($lang)', (tester) async {
      tester.view.physicalSize = const Size(_graphicWidth * _graphicRatio, _graphicHeight * _graphicRatio);
      tester.view.devicePixelRatio = _graphicRatio;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(lang, (c) => _featureGraphic(c, lang)));
      await tester.pumpAndSettle();
      expect(find.text(_lines[lang]!), findsOneWidget);
      expect(find.text('femio'), findsOneWidget);
      await _write(tester, 'feature-graphic-$lang.png', 1024, 500, _graphicRatio, withAlpha: false);
    });
  }
}
