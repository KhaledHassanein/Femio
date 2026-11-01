// Accessibility gate: every main screen, in Arabic and English, light and dark, checked
// against Flutter's built-in guidelines (48x48 tap targets, every tappable thing labelled)
// and a text-contrast check of its own, then again at 1.3x and 2.0x text size, where it
// fails on any layout overflow or any text that has been cut off.
//
// Why the contrast check is our own: Flutter's textContrastGuideline reads the rendered
// pixels at one pixel per logical pixel, so thin antialiased text on a good 8:1 pair
// measures 1.4 to 3.4:1 and the guideline fails on screens that are fine. `_textContrast`
// compares the colour a text declares with the fill the widget tree paints behind it (the
// worst stop of a gradient), which is what WCAG 1.4.3 actually measures. A self-test below
// proves it still catches pale text on white.
//
// Why it exists: WCAG 2.2 AA and the Google Play / Android accessibility guidance are not
// something a screenshot shows. TalkBack users and large-text users meet the app through
// semantics and layout, so this test reads those directly. Data is synthetic (dates in
// 2026, no person), fonts are the bundled ones, and "today" is fixed.
//
// Two kinds of test: the guideline tests pump each screen once per language and theme;
// the large-text tests pump each screen per language at each scale, on a phone-sized
// view and on a tall view (so lazily built list rows are laid out too).

import 'dart:convert';
import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/library.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/appointments.dart';
import 'package:femio/domain/contractions.dart';
import 'package:femio/domain/movements.dart';
import 'package:femio/domain/weight.dart';
import 'package:femio/features/learn/article_screen.dart';
import 'package:femio/features/learn/learn_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _today = '2026-10-08';
const _phone = Size(390, 844);
const _tall = Size(390, 3000);

/// Layout is in logical pixels; 1x keeps the long views cheap.
const _pixelRatio = 1.0;
const _scales = [1.3, 2.0];
const _longTest = Timeout(Duration(minutes: 3));

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
    for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) 'assets/fonts/IBMPlexSansArabic-$w.ttf',
  ]);
  final sdk = Platform.environment['FLUTTER_ROOT'] ?? '/root/sdk/flutter';
  await load('MaterialIcons', ['$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf']);
}

// ---- synthetic records ----------------------------------------------------------------

AppSettings _settings(String lang, {bool notice = true}) =>
    AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: notice);

Profile _period(String lang) => Profile(
  goal: Goal.period,
  locale: lang,
  birthYear: 1995,
  periodStarts: const ['2026-08-24', '2026-09-21'],
  periodLength: 5,
  cycleLength: 28,
  settings: _settings(lang, notice: false),
);

Profile _ttc(String lang) {
  var p = Profile(
    goal: Goal.ttc,
    locale: lang,
    birthYear: 1992,
    periodStarts: const ['2026-09-30'],
    cycleLength: 29,
    tryingFor: TryingFor.over12,
    settings: _settings(lang),
  );
  for (final e in {'2026-10-03': 36.42, '2026-10-04': 36.38, '2026-10-05': 36.45, '2026-10-06': 36.4}.entries) {
    p = p.withDayLog(e.key, DayLog(bbt: e.value, opk: 'negative'));
  }
  for (final d in ['2026-09-30', '2026-10-01', '2026-10-02']) {
    p = p.withDayLog(d, DayLog(flow: d == '2026-10-01' ? 'heavy' : 'medium', terms: const ['cramps']));
  }
  return p.withDayLog('2026-10-04', const DayLog(flow: 'spotting', terms: ['happy']));
}

Profile _irregular(String lang) => Profile(
  goal: Goal.period,
  locale: lang,
  birthYear: 1998,
  periodStarts: const ['2026-09-21'],
  irregular: true,
  settings: _settings(lang),
);

Profile _pregnant(String lang) => Profile(
  goal: Goal.pregnant,
  locale: lang,
  birthYear: 1993,
  edd: '2026-10-28', // 37 weeks: the contraction timer is listed first
  contractions: const [
    Contraction('c0', '2026-10-08T08:00:00Z', '2026-10-08T08:01:10Z'),
    Contraction('c1', '2026-10-08T08:09:00Z', '2026-10-08T08:10:10Z'),
  ],
  movements: const [MovementSession('m1', '2026-10-07T10:00:00Z', '2026-10-07T10:20:00Z', 10)],
  weights: const [WeightEntry('w1', '2026-08-01', 63.0, 'kg'), WeightEntry('w2', '2026-09-26', 65.9, 'kg')],
  appointments: const [
    Appointment(
      id: 'a1',
      type: 'Growth scan',
      clinician: 'Dr Mansour',
      datetime: '2026-10-12T09:30',
      prep: ['Is the baby head down?'],
    ),
  ],
  settings: _settings(lang),
);

// ---- the screens ------------------------------------------------------------------------

typedef _Step = Future<void> Function(WidgetTester tester);

/// One screen to check. [profile] is null for onboarding. [steps] run in order and the
/// checks run after each, so a flow (onboarding) is covered step by step.
class _Case {
  const _Case(this.name, this.profile, this.steps, {this.animated = false, this.pin = false, this.hijri = false});
  final String name;
  final Profile Function(String lang)? profile;
  final List<_Step> steps;

  /// A blinking caret never settles, so pump a fixed time instead of waiting.
  final bool animated;
  final bool pin;
  final bool hijri;
}

Future<void> _settle(WidgetTester t, {bool animated = false}) async {
  if (animated) {
    await t.pump(const Duration(milliseconds: 400));
    await t.pump(const Duration(milliseconds: 400));
  } else {
    await t.pumpAndSettle();
  }
}

Future<void> _tapIcon(WidgetTester t, IconData icon) async {
  // On a short screen the tile may sit below the fold of a lazily built list: scroll to it.
  if (find.byIcon(icon).evaluate().isEmpty) {
    await t.scrollUntilVisible(find.byIcon(icon), 300, scrollable: find.byType(Scrollable).first);
  }
  final f = find.byIcon(icon).first;
  await t.ensureVisible(f);
  await t.pump();
  await t.tap(f);
  await _settle(t);
}

Future<void> _onboardingNext(WidgetTester t) async {
  final button = find.byType(FilledButton).last;
  await t.ensureVisible(button);
  await t.pump();
  await t.tap(button);
  await _settle(t);
}

Future<void> _none(WidgetTester t) async {}

final _cases = <_Case>[
  _Case('onboarding', null, [
    _none, // welcome
    _onboardingNext, // goal
    (t) async {
      await t.tap(find.byType(InkWell).at(1)); // a goal; moves to the next step
      await _settle(t);
    },
    _onboardingNext,
    _onboardingNext,
  ]),
  _Case('today period', _period, [_none]),
  _Case('today trying to conceive', _ttc, [_none]),
  _Case('today irregular', _irregular, [_none]),
  _Case('today pregnancy and tools', _pregnant, [_none]),
  _Case('calendar', _ttc, [(t) => _tapIcon(t, Icons.calendar_month_outlined)]),
  _Case('calendar with hijri', _period, [(t) => _tapIcon(t, Icons.calendar_month_outlined)], hijri: true),
  _Case('log', _ttc, [(t) => _tapIcon(t, Icons.edit_note_outlined)]),
  _Case('pregnancy movements', _pregnant, [(t) => _tapIcon(t, Icons.touch_app_outlined)]),
  _Case('pregnancy contractions', _pregnant, [(t) => _tapIcon(t, Icons.timer_outlined)]),
  _Case('pregnancy appointments', _pregnant, [(t) => _tapIcon(t, Icons.event_note_outlined)]),
  _Case('pregnancy weight', _pregnant, [(t) => _tapIcon(t, Icons.monitor_weight_outlined)]),
  _Case('settings', _ttc, [(t) => _tapIcon(t, Icons.settings_outlined)]),
  _Case('help now', _ttc, [(t) => _tapIcon(t, Icons.support_outlined)]),
  _Case('lock', _ttc, [_none], animated: true, pin: true),
];

// ---- harness ----------------------------------------------------------------------------

void _configureView(WidgetTester t, Size size, {Brightness b = Brightness.light, double scale = 1}) {
  t.view.physicalSize = size * _pixelRatio;
  t.view.devicePixelRatio = _pixelRatio;
  t.platformDispatcher.platformBrightnessTestValue = b;
  t.platformDispatcher.textScaleFactorTestValue = scale;
}

/// Starts the app on [c]'s first screen at [size].
Future<void> _start(WidgetTester t, _Case c, String lang, Brightness b, {double scale = 1, Size size = _tall}) async {
  _configureView(t, size, b: b, scale: scale);
  var profile = c.profile?.call(lang);
  if (profile != null && c.hijri) profile = profile.copyWith(settings: profile.settings.copyWith(showHijri: true));
  final ctl = FemioController(MemoryStore(profile), initialLocale: lang);
  await ctl.load();
  if (c.pin) {
    await t.runAsync(() => ctl.setPin('2468'));
    ctl.locked = true;
  }
  // Unmount whatever the last start left (a screen she navigated to) so each start is fresh.
  await t.pumpWidget(const SizedBox.shrink());
  await t.pumpWidget(FemioApp(controller: ctl, today: _today));
  await _settle(t, animated: c.animated);
}

/// Every layout failure (overflow stripes and the like) reported while [body] runs.
Future<List<String>> _collectErrors(Future<void> Function() body) async {
  final seen = <String>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (d) {
    // The first line says what overflowed; the first source location says which widget.
    final where = RegExp(r'lib/[\w/]+\.dart:\d+').firstMatch(d.toDiagnosticsNode().toStringDeep())?.group(0);
    seen.add('${d.exceptionAsString().split('\n').first}${where == null ? '' : ' at $where'}');
  };
  try {
    await body();
  } finally {
    FlutterError.onError = previous;
  }
  return seen;
}

/// Text that did not fit its box and was cut off with an ellipsis, on a visible tab.
List<String> _clippedText(WidgetTester t) {
  final out = <String>[];
  for (final ro in t.allRenderObjects) {
    if (ro is! RenderParagraph || !ro.didExceedMaxLines) continue;
    if (_isShown(t, ro)) {
      out.add('text cut off (maxLines ${ro.maxLines}): "${ro.text.toPlainText().replaceAll('\n', ' ')}"');
    }
  }
  return out;
}

/// The colours that can sit behind [from]: the nearest opaque fill above it in the widget
/// tree (a gradient gives every stop; a translucent tint is laid over what is under it).
/// Reading the tree, not the pixels, keeps antialiased glyph edges and neighbouring tiles
/// out of the answer.
List<Color> _backgrounds(Element from) {
  final theme = Theme.of(from);
  final layers = <List<Color>>[]; // nearest first
  var opaque = false;
  from.visitAncestorElements((a) {
    final w = a.widget;
    List<Color>? c;
    if (w is DecoratedBox && w.position == DecorationPosition.background && w.decoration is BoxDecoration) {
      final d = w.decoration as BoxDecoration;
      c = d.gradient?.colors ?? (d.color == null ? null : [d.color!]);
    } else if (w is ColoredBox) {
      c = [w.color];
    } else if (w is Material && w.type != MaterialType.transparency) {
      c = [w.color ?? (w.type == MaterialType.card ? theme.cardColor : theme.canvasColor)];
    } else if (w is Scaffold) {
      c = [w.backgroundColor ?? theme.scaffoldBackgroundColor];
    } else if (w is PhysicalModel) {
      c = [w.color];
    } else if (w is PhysicalShape) {
      c = [w.color];
    } else if (w is AnimatedPhysicalModel) {
      c = [w.color];
    }
    if (c != null) {
      layers.add(c);
      if (c.every((x) => x.a >= 0.999)) opaque = true;
    }
    return !opaque;
  });
  var result = opaque ? layers.removeLast() : [theme.scaffoldBackgroundColor];
  for (final layer in layers.reversed) {
    result = [
      for (final under in result)
        for (final c in layer) Color.alphaBlend(c, under),
    ];
  }
  return result;
}

/// True when [ro] is on screen and not covered: a tap at its centre reaches it. Text of a
/// tab that is off stage, of a route below the current one, or under the lock screen is
/// not what she sees, so it is not judged.
bool _isShown(WidgetTester t, RenderParagraph ro) {
  final view = t.view;
  final centre = ro.localToGlobal(ro.size.center(Offset.zero));
  if (centre.dx < 0 || centre.dy < 0 || centre.dx > view.physicalSize.width || centre.dy > view.physicalSize.height) {
    return false;
  }
  final hit = t.hitTestOnBinding(centre);
  return hit.path.any((entry) => entry.target == ro);
}

/// True when [e] sits inside a disabled button, which WCAG 1.4.3 does not ask to be legible.
bool _inDisabledButton(Element e) {
  var disabled = false;
  e.visitAncestorElements((a) {
    final w = a.widget;
    if (w is ButtonStyleButton && w.onPressed == null && w.onLongPress == null) disabled = true;
    return !disabled;
  });
  return disabled;
}

/// WCAG 1.4.3 text contrast (4.5:1, or 3:1 for large text: 18px, or 14px bold).
///
/// Flutter's own `textContrastGuideline` takes the commonest dark pixel in a text box as
/// the ink; for thin antialiased text that is a faint in-between shade, so it reports 1.4
/// to 3.4 on pairs that are 8:1. This check takes the colour the text is declared in and
/// the fill the widget tree paints behind it (see [_backgrounds]); the worst stop of a
/// gradient decides. A real clash still fails (see the self-test below).
List<String> _textContrast(WidgetTester t) {
  final out = <String>[];
  for (final ro in t.allRenderObjects) {
    if (ro is! RenderParagraph || !ro.attached || !ro.hasSize || ro.size.isEmpty) continue;
    final element = (ro.debugCreator as DebugCreator?)?.element;
    if (element == null) continue;
    if (!_isShown(t, ro) || _inDisabledButton(element)) continue;

    final runs = <(String, Color, double, bool)>[];
    void walk(InlineSpan span, TextStyle inherited) {
      final style = span.style == null ? inherited : inherited.merge(span.style);
      if (span is TextSpan) {
        final text = span.text?.trim() ?? '';
        if (text.isNotEmpty && style.color != null) {
          runs.add((text, style.color!, style.fontSize ?? 14, (style.fontWeight?.value ?? 400) >= 700));
        }
        for (final c in span.children ?? const <InlineSpan>[]) {
          walk(c, style);
        }
      }
    }

    walk(ro.text, const TextStyle());
    if (runs.isEmpty) continue;
    final backgrounds = _backgrounds(element);
    for (final (text, ink, size, bold) in runs) {
      var worst = double.infinity;
      for (final bg in backgrounds) {
        final a = Color.alphaBlend(ink, bg).computeLuminance(), b = bg.computeLuminance();
        final r = (a > b ? a + 0.05 : b + 0.05) / (a > b ? b + 0.05 : a + 0.05);
        if (r < worst) worst = r;
      }
      final needed = (size >= 18 || (bold && size >= 14)) ? 3.0 : 4.5;
      if (worst + 0.01 < needed) {
        out.add(
          'contrast: "${text.length > 50 ? text.substring(0, 50) : text}" is ${worst.toStringAsFixed(2)}:1, needs $needed ($size px)',
        );
      }
    }
  }
  return out.toSet().toList();
}

/// Tap-target size and tap-target labels from Flutter's guidelines, plus text contrast.
Future<List<String>> _guidelines(WidgetTester t) async {
  final out = <String>[];
  for (final (name, g) in [('tap-target', androidTapTargetGuideline), ('label', labeledTapTargetGuideline)]) {
    final e = await g.evaluate(t);
    if (e.passed) continue;
    for (final line in (e.reason ?? name).split('\n')) {
      if (line.startsWith('SemanticsNode') || line.startsWith('Expected')) out.add('$name: $line');
    }
  }
  return [...out, ..._textContrast(t)];
}

/// Fails with every finding listed. When A11Y_REPORT names a file, the findings are also
/// appended there unwrapped (one tab-separated line each), for counting per screen.
void expectNone(String name, List<String> failures) {
  final report = Platform.environment['A11Y_REPORT'];
  if (report != null && failures.isNotEmpty) {
    File(report)
        .writeAsStringSync(failures.map((f) => '$name\t${f.replaceAll('\n', ' ')}\n').join(), mode: FileMode.append);
  }
  expect(failures, isEmpty, reason: '${failures.length} failure(s)\n${failures.join('\n')}');
}

void main() {
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  // The checker itself must be able to fail: pale grey on white is caught, the real ink is not.
  testWidgets('the contrast check catches a pale-on-white clash and passes real ink', (t) async {
    addTearDown(t.view.reset);
    _configureView(t, _phone);
    Future<List<String>> run(Color ink) async {
      await t.pumpWidget(
        MaterialApp(
          home: Material(
            color: Colors.white,
            child: Center(
              child: Text('Sample sentence for contrast', style: TextStyle(fontSize: 15, color: ink)),
            ),
          ),
        ),
      );
      return _textContrast(t);
    }

    expect(await run(const Color(0xFFBBBBBB)), hasLength(1));
    expect(await run(const Color(0xFF24141F)), isEmpty);
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      for (final c in _cases) {
        testWidgets('guidelines: ${c.name} ($lang, ${b.name})', (t) async {
          addTearDown(t.view.reset);
          addTearDown(t.platformDispatcher.clearAllTestValues);
          final handle = t.ensureSemantics();
          final failures = <String>[];
          await _start(t, c, lang, b);
          for (final (i, step) in c.steps.indexed) {
            await step(t);
            failures.addAll((await _guidelines(t)).map((f) => 'step ${i + 1}: $f'));
          }
          handle.dispose();
          expectNone('guidelines: ${c.name} ($lang, ${b.name})', failures);
        }, timeout: _longTest);
      }
    }
  }

  for (final lang in ['en', 'ar']) {
    for (final scale in _scales) {
      for (final c in _cases) {
        testWidgets('text x$scale: ${c.name} ($lang)', (t) async {
          addTearDown(t.view.reset);
          addTearDown(t.platformDispatcher.clearAllTestValues);
          final failures = <String>[];
          failures.addAll(
            await _collectErrors(() async {
              for (final size in [_phone, _tall]) {
                await _start(t, c, lang, Brightness.light, scale: scale, size: size);
                for (final (i, step) in c.steps.indexed) {
                  await step(t);
                  failures.addAll(_clippedText(t).map((s) => '${size.height.toInt()}px step ${i + 1}: $s'));
                }
              }
            }),
          );
          expectNone('text x$scale: ${c.name} ($lang)', failures.toSet().toList());
        }, timeout: _longTest);
      }
    }
  }

  // The guide list and one guide are built straight from their widgets, on a library read
  // from disk (the asset bundle needs real async I/O, which the test clock does not run).
  group('learn', () {
    Widget app(Widget home, String lang, Brightness b) => MaterialApp(
      theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
      locale: Locale(lang),
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr'), Locale('es')],
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: home,
    );

    Future<(Library, Article)> content(WidgetTester t, String lang) async {
      final lib = Library(load: (p) => File(p).readAsString());
      await t.runAsync(() => lib.articles(lang));
      final raw = (jsonDecode(File('assets/content/$lang.json').readAsStringSync()) as List).firstWhere(
        (a) => (a as Map)['slug'] == 'fertile-window-explained',
      ) as Map;
      return (lib, Article.fromJson(Map<String, Object?>.from(raw), lang));
    }

    for (final lang in ['en', 'ar']) {
      for (final b in Brightness.values) {
        for (final article in [false, true]) {
          testWidgets('guidelines: learn ${article ? 'article' : 'list'} ($lang, ${b.name})', (t) async {
            addTearDown(t.view.reset);
            addTearDown(t.platformDispatcher.clearAllTestValues);
            final handle = t.ensureSemantics();
            _configureView(t, _tall, b: b);
            final (lib, a) = await content(t, lang);
            await t.pumpWidget(app(article ? ArticleScreen(article: a) : LearnScreen(library: lib), lang, b));
            await t.pumpAndSettle();
            final failures = await _guidelines(t);
            handle.dispose();
            expectNone('guidelines: learn ${article ? 'article' : 'list'} ($lang, ${b.name})', failures);
          }, timeout: _longTest);
        }
      }
      for (final scale in _scales) {
        testWidgets('text x$scale: learn list and article ($lang)', (t) async {
          addTearDown(t.view.reset);
          addTearDown(t.platformDispatcher.clearAllTestValues);
          final (lib, a) = await content(t, lang);
          final failures = <String>[];
          failures.addAll(
            await _collectErrors(() async {
              for (final size in [_phone, _tall]) {
                _configureView(t, size, scale: scale);
                for (final home in [LearnScreen(library: lib), ArticleScreen(article: a)]) {
                  await t.pumpWidget(app(home, lang, Brightness.light));
                  await t.pumpAndSettle();
                  failures.addAll(_clippedText(t).map((s) => '${size.height.toInt()}px ${home.runtimeType}: $s'));
                }
              }
            }),
          );
          expectNone('text x$scale: learn ($lang)', failures.toSet().toList());
        }, timeout: _longTest);
      }
    }
  });
}
