// The Google Play screenshots: eight real app screens per language, each under a
// caption, 1080×1920 PNG. They are the files in docs/store/screenshots/{ar,en}/.
//
// Why it exists: store images drift from the app the moment a screen changes. Rendering
// them from the real widgets, with synthetic data, means `flutter test --update-goldens
// test/store_screenshots_test.dart` rebuilds all sixteen. A plain run builds every frame
// and checks the screen is really on it, and writes nothing.
//
// Each frame is: cream background, the wordmark and a caption in the top third, then the
// live screen inside a plain phone outline that runs off the bottom edge. All colours,
// fonts and radii come from the theme tokens. Data is synthetic: dates in 2026, no person.
// Product rules shown honestly: a fertile range (never one day), no "late" counter in
// irregular mode, Western digits, the Latin wordmark.

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:femio/app.dart';
import 'package:femio/data/library.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/assistant/source_registry.dart';
import 'package:femio/features/assistant/ask_screen.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:femio/features/learn/article_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:femio/theme/spacing.dart';
import 'package:femio/widgets/bloom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

// ---- frame geometry (logical pixels; the view is 360×640 at 3x = 1080×1920) -----------

const _frameWidth = 360.0;
const _frameHeight = 640.0;
const _pixelRatio = 3.0;

/// The phone screen is laid out as a normal 390×844 phone, then scaled to fit the outline.
const _phoneWidth = 390.0;
const _phoneHeight = 844.0;

/// Side margin of the phone outline, and where it starts: just under the top third.
const _sideInset = 28.0;
const _deviceTop = 222.0;
const _bezel = 7.0;
const _deviceRadius = 36.0;
const _captionTop = 44.0;
const _captionSize = 29.0;
const _wordmarkSize = 21.0;

/// Output folder, relative to this file (matchesGoldenFile resolves against the test's
/// directory): the repository's docs/store/screenshots.
const _out = '../../../docs/store/screenshots';

/// The pretend "today" on every screen.
const _today = '2026-10-08';

/// Extra scroll after a heading is brought near the top, in the phone's own pixels, so
/// the heading sits just under the app bar and the previous section's tail is out of view.
/// Found by looking at the renders.
const _toolsNudge = 57.0;

/// The pregnancy-tools frame uses a shorter phone so its list can scroll far enough to
/// start at the wanted heading (a tall phone runs out of list in Arabic).
const _shortPhoneHeight = 600.0;

// ---- the eight screens and their captions --------------------------------------------

class _Shot {
  const _Shot(this.slug, this.en, this.ar);
  final String slug;
  final String en;
  final String ar;
}

// Captions 1-7 are the ones in docs/store/play-listing.{en,ar}.md, except caption 5, which is
// changed: the app's calendar does not draw a due date, so the listing's wording
// ("Due date on a calendar, with Hijri dates") would promise what the screen does not show.
const _shots = [
  _Shot('01-private', 'Your records stay on your phone', 'سجلاتكِ تبقى على هاتفكِ'),
  _Shot('02-fertile-range', 'Your fertile days as an honest range', 'أيام خصوبتكِ كنطاق صادق، لا يوم واحد'),
  _Shot('03-irregular', 'Irregular cycles or PCOS? No "late" counter', 'دورة غير منتظمة أو تكيس مبايض؟ بلا عدّاد للتأخير'),
  _Shot('04-pregnancy', 'Your pregnancy, week by week', 'حملكِ أسبوعًا بأسبوع'),
  _Shot('05-hijri', 'Your calendar, with Hijri dates beside each day', 'تقويمكِ، والتاريخ الهجري بجانب كل يوم'),
  _Shot('06-learn', 'Physician-written guides, with sources', 'مقالات كتبها طبيب، مع مصادرها'),
  _Shot('07-tools', 'Movement log and contraction timer, no verdicts', 'سجل حركة الجنين ومؤقّت الانقباضات، بلا أحكام'),
  _Shot('08-ask', 'Ask a question, get an answer with its source', 'اسألي، وتأتيكِ الإجابة مع مصدرها'),
];

/// The question shown on screenshot 8, one common trying-to-conceive question. The passages
/// under it are whatever the bundled registry returns for it; nothing is written by hand.
const _askQuestion = (
  en: 'How long should we try to conceive before seeing a doctor?',
  ar: 'كم أنتظر قبل أن أزور الطبيب لتأخر الحمل؟',
);

/// The trusted-source registry the app ships.
SourceRegistry _registry() => SourceRegistry.fromJson(
      jsonDecode(File('assets/trusted_sources/registry.json').readAsStringSync()) as Map<String, Object?>,
    );

// ---- harness (fonts copied from screens_test.dart) ------------------------------------

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

const _frameKey = ValueKey('store-frame');

/// The frame: wordmark and caption on top, the live [screen] below in a phone outline.
Widget _frame(String lang, String caption, Widget screen, {double phoneHeight = _phoneHeight}) => MaterialApp(
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
      home: Builder(builder: (context) {
        final p = context.palette;
        final t = Theme.of(context).textTheme;
        return RepaintBoundary(
          key: _frameKey,
          child: ColoredBox(
            color: p.bg,
            child: Stack(
              children: [
                PositionedDirectional(
                  start: _sideInset,
                  end: _sideInset,
                  top: _captionTop,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // The wordmark is always the Latin "femio", in every language.
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Bloom(size: _wordmarkSize),
                            const SizedBox(width: space2),
                            Text('femio', style: t.headlineSmall?.copyWith(color: p.primary, fontSize: _wordmarkSize)),
                          ],
                        ),
                      ),
                      const SizedBox(height: space4),
                      Text(caption, style: t.headlineMedium?.copyWith(color: p.plum700, fontSize: _captionSize, height: 1.25)),
                    ],
                  ),
                ),
                PositionedDirectional(
                  start: _sideInset,
                  end: _sideInset,
                  top: _deviceTop,
                  bottom: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: p.plum900,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(_deviceRadius)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(_bezel, _bezel, _bezel, 0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(_deviceRadius - _bezel)),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: _phoneWidth,
                            height: phoneHeight,
                            child: MediaQuery(
                              data: MediaQuery.of(context).copyWith(size: Size(_phoneWidth, phoneHeight)),
                              child: screen,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );

// ---- synthetic records ----------------------------------------------------------------

AppSettings _settings(String lang, {bool noticeSeen = true, bool? hijri}) =>
    AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: noticeSeen, showHijri: hijri);

Profile _profile(String lang, int index) {
  switch (index) {
    case 0: // private by design: the one-time notice is still on Today
      return Profile(
        goal: Goal.period,
        locale: lang,
        birthYear: 1995,
        periodStarts: const ['2026-07-27', '2026-08-24', '2026-09-21'],
        periodLength: 5,
        cycleLength: 28,
        settings: _settings(lang, noticeSeen: false, hijri: false),
      );
    case 1: // calendar with the fertile range
      var p = Profile(
        goal: Goal.ttc,
        locale: lang,
        birthYear: 1992,
        periodStarts: const ['2026-10-01'],
        cycleLength: 28,
        settings: _settings(lang, hijri: false),
      );
      for (final d in ['2026-10-01', '2026-10-02', '2026-10-03', '2026-10-04']) {
        p = p.withDayLog(d, DayLog(flow: d == '2026-10-02' ? 'heavy' : 'medium', terms: d == '2026-10-01' ? const ['cramps'] : const []));
      }
      return p.withDayLog('2026-10-06', const DayLog(terms: ['happy']));
    case 2: // irregular mode: one start so far, so no date is named and the note says why
      return Profile(
        goal: Goal.period,
        locale: lang,
        birthYear: 1998,
        periodStarts: const ['2026-09-21'],
        irregular: true,
        settings: _settings(lang, hijri: false),
      );
    case 3: // pregnancy week card
      return Profile(goal: Goal.pregnant, locale: lang, birthYear: 1993, edd: '2027-02-10', settings: _settings(lang, hijri: false));
    case 4: // Hijri beside Gregorian
      return Profile(
        goal: Goal.period,
        locale: lang,
        birthYear: 1994,
        periodStarts: const ['2026-09-17'],
        cycleLength: 28,
        settings: _settings(lang, hijri: true),
      );
    case 6: // 37 weeks: the pregnancy tools
      return Profile(goal: Goal.pregnant, locale: lang, birthYear: 1993, edd: '2026-10-28', settings: _settings(lang, hijri: false));
    default: // Ask femio: trying to conceive, so the trying-to-conceive passages rank first
      return Profile(
        goal: Goal.ttc,
        locale: lang,
        birthYear: 1992,
        periodStarts: const ['2026-09-10'],
        cycleLength: 28,
        tryingFor: TryingFor.sixTo12,
        settings: _settings(lang, hijri: false),
      );
  }
}

/// One real guide from the bundled library, cut to its opening paragraph so its sources
/// show inside the crop.
Article _guide(String lang) {
  final all = (jsonDecode(File('assets/content/$lang.json').readAsStringSync()) as List);
  final raw = Map<String, Object?>.from(all.firstWhere((a) => (a as Map)['slug'] == 'fertile-window-explained') as Map);
  final body = Map<String, Object?>.from(raw['body'] as Map);
  final root = Map<String, Object?>.from(body['root'] as Map);
  root['children'] = (root['children'] as List).take(1).toList();
  body['root'] = root;
  raw['body'] = body;
  return Article.fromJson(raw, lang);
}

// ---- running one screen ---------------------------------------------------------------

/// Scrolls the first visible list until [target] is built, then puts it at [alignment]
/// (0 = top edge). Jumps rather than drags: the phone is scaled and cropped inside the
/// frame, so a drag could start outside the 360x640 view.
Future<void> _scrollTo(WidgetTester tester, Finder target, {required double nudge, double alignment = 0.17}) async {
  await tester.pumpAndSettle();
  final position = tester.state<ScrollableState>(find.byType(Scrollable).first).position;
  while (target.evaluate().isEmpty && position.pixels < position.maxScrollExtent) {
    position.jumpTo(math.min(position.pixels + 200, position.maxScrollExtent));
    await tester.pump();
  }
  Scrollable.ensureVisible(tester.element(target), alignment: alignment);
  await tester.pumpAndSettle();
  // The line above the heading is the tail of the previous section; push it out of view.
  position.jumpTo(position.pixels + nudge);
  await tester.pumpAndSettle();
}

/// Opens tab [index] of the bottom bar. The bar sits below the crop, so it is driven
/// through its own callback rather than by a tap that would land outside the frame.
Future<void> _openTab(WidgetTester tester, int index) async {
  // The "+" takes bar slot 2 (R8.29); tabs from Log on move one along.
  tester.widget<NavigationBar>(find.byType(NavigationBar)).onDestinationSelected!(index < 2 ? index : index + 1);
  await tester.pumpAndSettle();
}

Future<void> _shoot(WidgetTester tester, String lang, _Shot shot, int index) async {
  tester.view.physicalSize = const Size(_frameWidth * _pixelRatio, _frameHeight * _pixelRatio);
  tester.view.devicePixelRatio = _pixelRatio;
  addTearDown(tester.view.reset);
  final caption = lang == 'ar' ? shot.ar : shot.en;
  final l = lookupL10n(Locale(lang));

  Future<FemioController> start({bool pin = false}) async {
    final c = FemioController(MemoryStore(_profile(lang, index)), initialLocale: lang);
    await c.load();
    if (pin) await tester.runAsync(() => c.setPin('2468'));
    await tester.pumpWidget(_frame(lang, caption, FemioApp(controller: c, today: _today),
        phoneHeight: index == 6 ? _shortPhoneHeight : _phoneHeight));
    await tester.pumpAndSettle();
    return c;
  }

  switch (index) {
    case 0 || 2 || 3: // Today
      await start();
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      if (index == 0) expect(find.text(l.firstRunStorageTitle), findsOneWidget);
      if (index == 2) expect(find.text(l.irregularNote), findsOneWidget);
      if (index == 3) expect(find.text(l.trimesterLabel(2).toUpperCase()), findsOneWidget);
    case 1 || 4: // Calendar
      await start();
      await _openTab(tester, 1);
      expect(find.text(l.calendarTitle), findsWidgets);
    case 5: // Learn: one guide with its sources
      final a = _guide(lang);
      await tester.pumpWidget(_frame(
        lang,
        caption,
        MaterialApp(
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
          home: ArticleScreen(article: a),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text(l.learnSources), findsOneWidget);
    case 6: // Pregnancy tools: the timer and the movement log, side by side on Today
      await start();
      await _scrollTo(tester, find.text(l.pregnancyToolsTitle), nudge: _toolsNudge);
      expect(find.text(l.movementsHeading), findsOneWidget);
      expect(find.text(l.contractionsHeading), findsOneWidget);
    default: // Ask femio: a real registry answer, word for word, with its source
      final c = FemioController(MemoryStore(_profile(lang, index)), initialLocale: lang);
      await c.load();
      await tester.pumpWidget(_frame(
        lang,
        caption,
        MaterialApp(
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
          // No model on the phone: the rules path shows the registry passage itself.
          builder: (context, child) => AssistantScope(bridge: const OfflineAssistant(), child: child!),
          home: AskScreen(controller: c, registry: _registry(), today: _today),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, lang == 'ar' ? _askQuestion.ar : _askQuestion.en);
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();
      expect(find.text(l.askVerbatimLabel), findsOneWidget);
      // Scroll the intro away so the answer and its source list are what the frame shows.
      Scrollable.ensureVisible(tester.element(find.byType(TextField).first), alignment: 0.0);
      await tester.pumpAndSettle();
      expect(find.text(l.askNotCoveredHeading), findsNothing);
  }

  if (!autoUpdateGoldenFiles) return;
  await expectLater(find.byType(MaterialApp).first, matchesGoldenFile('$_out/$lang/${shot.slug}.png'));
}

void main() {
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  for (final lang in ['ar', 'en']) {
    for (final (i, shot) in _shots.indexed) {
      testWidgets('store screenshot ${shot.slug} ($lang)', (tester) => _shoot(tester, lang, shot, i));
    }
  }
}
