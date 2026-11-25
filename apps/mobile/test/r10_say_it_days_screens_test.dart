// Widget tests and screenshots for "Say it, several days in one note" (R10.7, R8.27).
//
// They prove what the sheet does with the day split: one draft card per day, nothing written
// until the counted save, an unticked chip or a removed day lowering the count, a merge that
// keeps what was already logged, a refusal message for a future day, the safety notice for a
// danger sign, and the model (a fake bridge here) being asked about one day's words at a time.
// Everything is synthetic. Screenshots at 390x844 (light, dark; English and Arabic) are
// written to testing-results/2026-11-25-r10-say-it-days/ under `--update-goldens` only.

import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/assistant_channel.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/assistant/cloud_prompt.dart';
import 'package:femio/domain/assistant/private_prompt.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:femio/features/assistant/say_it_sheet.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _out = '../../../testing-results/2026-11-25-r10-say-it-days';
const _today = '2026-11-25';
const _yesterday = '2026-11-24';

/// A bridge whose on-phone answer the test sets; it records every note the model was shown.
class _FakeBridge implements AssistantBridge {
  _FakeBridge({this.reply});
  final String? reply;
  final List<String> prompts = [];

  @override
  Future<AssistantStatus> status() async =>
      AssistantStatus(configured: true, onDevice: reply == null ? OnDeviceModel.unavailable : OnDeviceModel.available);

  @override
  Future<bool> downloadModel() async => true;

  @override
  Future<String?> runPrivate(PrivatePrompt prompt) async {
    prompts.add(prompt.text);
    return reply;
  }

  @override
  Future<HybridReply?> runHybrid(CloudPrompt prompt) async => null;

  @override
  Future<bool> openSource(String url) async => true;
}

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

Widget _app(String locale, Brightness b, AssistantBridge bridge, Widget home) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
  locale: Locale(locale),
  supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr'), Locale('es')],
  localizationsDelegates: const [
    L10n.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  builder: (context, child) => AssistantScope(bridge: bridge, child: child!),
  home: home,
);

/// A synthetic profile with one earlier entry on "yesterday", so a merge has something to keep.
Future<FemioController> _controller(String lang, {bool hijri = false}) async {
  var p = Profile(
    goal: Goal.ttc,
    locale: lang,
    birthYear: 1990,
    periodStarts: const ['2026-09-01', '2026-09-30', '2026-10-29'],
    tryingFor: TryingFor.sixTo12,
  ).withDayLog(_yesterday, const DayLog(flow: 'medium', terms: ['bloating'], bbt: 36.6));
  if (hijri) p = p.copyWith(settings: p.settings.copyWith(showHijri: true));
  final c = FemioController(MemoryStore(p));
  await c.load();
  return c;
}

Future<void> _size(WidgetTester tester) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

Future<void> _shoot(String name) async {
  if (!autoUpdateGoldenFiles) return;
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/$name.png'));
}

Future<void> _open(WidgetTester tester, FemioController c, String lang, Brightness b, {_FakeBridge? bridge}) async {
  await tester.pumpWidget(
    _app(lang, b, bridge ?? _FakeBridge(), Scaffold(body: SayItSheet(controller: c, date: _today, today: _today))),
  );
}

Future<void> _say(WidgetTester tester, String note) async {
  await tester.enterText(find.byType(TextField), note);
  await tester.tap(find.byIcon(Icons.auto_awesome_rounded));
  await tester.pumpAndSettle();
}

const _enNote = 'Yesterday bad cramps and a headache, today light flow and so tired';
const _arNote = 'امبارح مغص جامد وصداع والنهارده نزول خفيف وتعبانة';

void main() {
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  for (final (lang, b) in [
    ('en', Brightness.light),
    ('en', Brightness.dark),
    ('ar', Brightness.light),
    ('ar', Brightness.dark),
  ]) {
    testWidgets('two days become two drafts and one counted save ($lang, ${b.name})', (tester) async {
      await _size(tester);
      final c = await _controller(lang, hijri: lang == 'ar');
      await _open(tester, c, lang, b);
      await _say(tester, lang == 'ar' ? _arNote : _enNote);
      await _shoot('${lang}_${b.name}_two_days');

      expect(find.byType(FilterChip), findsNWidgets(4));
      // Nothing is written until she taps save.
      expect(c.profile!.logs[_today], isNull);
      expect(c.profile!.logs[_yesterday]!.terms, ['bloating']);

      if (lang == 'en') expect(find.text('Save 4 entries on 2 days'), findsOneWidget);
      await tester.tap(find.byType(FilledButton).last);
      await tester.pumpAndSettle();

      final y = c.profile!.logs[_yesterday]!;
      expect(y.terms, containsAll(['bloating', 'cramps', 'headache']));
      expect(y.flow, 'medium'); // what was there stays
      expect(y.bbt, 36.6);
      final t = c.profile!.logs[_today]!;
      expect(t.terms, contains('fatigue'));
      expect(t.flow, 'light');
    });
  }

  testWidgets('unticking a chip and removing a day lower the count', (tester) async {
    await _size(tester);
    final c = await _controller('en');
    await _open(tester, c, 'en', Brightness.light);
    await _say(tester, _enNote);
    expect(find.text('Save 4 entries on 2 days'), findsOneWidget);

    await tester.tap(find.byType(FilterChip).first);
    await tester.pumpAndSettle();
    expect(find.text('Save 3 entries on 2 days'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove this day').first);
    await tester.pumpAndSettle();
    expect(find.text('Save 2 entries on 1 day'), findsOneWidget);
    expect(find.byType(FilterChip), findsNWidgets(2));

    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    expect(c.profile!.logs[_yesterday]!.terms, ['bloating']); // the removed day wrote nothing
    expect(c.profile!.logs[_today]!.flow, 'light');
  });

  testWidgets('a future day is refused with a plain message and nothing is saved for it', (tester) async {
    await _size(tester);
    final c = await _controller('en');
    await _open(tester, c, 'en', Brightness.light);
    await _say(tester, 'today cramps, tomorrow headache');
    expect(find.textContaining("hasn't happened yet"), findsOneWidget);
    expect(find.text('Save 1 entry on 1 day'), findsOneWidget);
    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    expect(c.profile!.logs[_today]!.terms, ['cramps']);
    expect(c.profile!.logs.keys.where((d) => d.compareTo(_today) > 0), isEmpty);
  });

  testWidgets('a note older than 7 days back says so', (tester) async {
    await _size(tester);
    final c = await _controller('en');
    await _open(tester, c, 'en', Brightness.light);
    await _say(tester, '9 days ago cramps');
    expect(find.textContaining('up to 7 days back'), findsOneWidget);
    expect(find.byType(FilterChip), findsNothing);
  });

  testWidgets('words with no day word go to the selected day', (tester) async {
    await _size(tester);
    final c = await _controller('en');
    await tester.pumpWidget(
      _app('en', Brightness.light, _FakeBridge(), Scaffold(body: SayItSheet(controller: c, date: '2026-11-22', today: _today))),
    );
    await _say(tester, 'bad cramps');
    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    expect(c.profile!.logs['2026-11-22']!.terms, ['cramps']);
  });

  testWidgets('a danger sign shows the safety notice and saves nothing by itself', (tester) async {
    await _size(tester);
    final c = await _controller('en');
    await _open(tester, c, 'en', Brightness.light);
    await _say(tester, 'yesterday cramps, today chest pain');
    expect(find.text('This may need urgent care'), findsOneWidget);
    expect(c.profile!.logs[_today], isNull);
    expect(c.profile!.logs[_yesterday]!.terms, ['bloating']);
  });

  testWidgets('the keyboard-dictation hint sits under the field and needs no permission', (tester) async {
    await _size(tester);
    final c = await _controller('en');
    await _open(tester, c, 'en', Brightness.light);
    expect(find.textContaining('microphone on your keyboard'), findsOneWidget);
  });

  testWidgets('the on-phone model is asked about one day\'s words at a time', (tester) async {
    await _size(tester);
    final c = await _controller('en');
    final bridge = _FakeBridge(reply: '{"terms":["nausea"],"flow":null,"opk":null}');
    await _open(tester, c, 'en', Brightness.light, bridge: bridge);
    // The made-up words stand for each day's own text; the prompt also lists the vocabulary.
    await _say(tester, 'yesterday zzalpha cramps, today zzbeta headache');
    expect(bridge.prompts, hasLength(2));
    expect(bridge.prompts.first, contains('zzalpha'));
    expect(bridge.prompts.first, isNot(contains('zzbeta')));
    expect(bridge.prompts.last, contains('zzbeta'));
    expect(bridge.prompts.last, isNot(contains('zzalpha')));
  });
}
