// The "+" sheet's two AI choices (Ask femio / Log with femio) and the "Save this to your
// record?" prompt under an Ask femio answer (owner 2026-11-27).
//
// Checks: both choices sit side by side and open their doors; the AI off hides them; after an
// answer the prompt offers the terms from HER question as chips (deselectable) and a visit
// note; nothing is written until Save; Not now writes nothing; with no terms only the note is
// offered. With --update-goldens it also writes proof shots (390x844 at 2x, EN and AR, light
// and dark) to testing-results/2026-11-27-ask-log/ (synthetic fixture, no real record).

import 'dart:convert';
import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/assistant/ask_save.dart';
import 'package:femio/domain/assistant/source_registry.dart';
import 'package:femio/features/assistant/ask_screen.dart';
import 'package:femio/features/assistant/assistant_pill.dart'
    show AssistantDoor;
import 'package:femio/features/home/add_sheet.dart';
import 'package:femio/features/assistant/mic_button.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/l10n/log_labels.g.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-27-ask-log';
const _today = '2026-11-27';
const _questionEn = 'what helps with period cramps and headache?';
const _questionAr = 'ما الذي يخفف مغص الدورة وصداع؟';
const _questionNoTerms = 'when should I take a pregnancy test';

final _registry = SourceRegistry.fromJson(
  jsonDecode(File('assets/trusted_sources/registry.json').readAsStringSync())
      as Map<String, Object?>,
);

Profile _profile(
  String lang, {
  bool assistantOn = true,
  Map<String, DayLog> logs = const {},
}) => Profile(
  goal: Goal.ttc,
  locale: lang,
  birthYear: 1994,
  periodStarts: const ['2026-11-05'],
  periodLength: 5,
  cycleLength: 28,
  logs: logs,
  settings: AppSettings.defaultsFor(lang).copyWith(
    storageNoticeSeen: true,
    assistantIntroSeen: true,
    assistantOn: assistantOn,
  ),
);

void _size(WidgetTester tester, Brightness b) {
  tester.platformDispatcher.platformBrightnessTestValue = b;
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

Future<FemioController> _controller(Profile p) async {
  final c = FemioController(MemoryStore(p), initialLocale: p.locale);
  await c.load();
  return c;
}

/// A bare app around [home], in [lang] and [b].
Widget _app(String lang, Brightness b, Widget home) => MaterialApp(
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
  home: home,
);

Future<void> _ask(WidgetTester tester, String q) async {
  await tester.enterText(find.byType(TextField).first, q);
  await tester.tap(find.byIcon(Icons.search_rounded));
  await tester.pumpAndSettle();
}

Future<FemioController> _askScreen(
  WidgetTester tester,
  String lang,
  String question, {
  Brightness b = Brightness.light,
  Map<String, DayLog> logs = const {},
}) async {
  _size(tester, b);
  final c = await _controller(_profile(lang, logs: logs));
  await tester.pumpWidget(
    _app(lang, b, AskScreen(controller: c, registry: _registry, today: _today)),
  );
  await _ask(tester, question);
  return c;
}

/// Scrolls the answer to its end, where the save prompt and its buttons are.
Future<void> _toBottom(WidgetTester tester) async {
  await tester.drag(find.byType(Scrollable).first, const Offset(0, -3000));
  await tester.pumpAndSettle();
}

Future<void> _shoot(WidgetTester tester, String name) async {
  await tester.pumpAndSettle();
  if (!autoUpdateGoldenFiles) return;
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('$_out/$name.png'),
  );
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  final en = lookupL10n(const Locale('en'));

  group('the + sheet: two equal AI choices', () {
    Future<Object?> openSheet(
      WidgetTester tester,
      FemioController c,
      String lang,
    ) async {
      Object? result;
      await tester.pumpWidget(
        _app(
          lang,
          Brightness.light,
          Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () async =>
                      result = await showModalBottomSheet<Object>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => AddSheet(controller: c, today: _today),
                      ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return Future.value(result);
    }

    testWidgets(
      'Ask and Log sit side by side at the same size; Visit stays a link',
      (tester) async {
        _size(tester, Brightness.light);
        final c = await _controller(_profile('en'));
        await openSheet(tester, c, 'en');
        final ask = tester.getRect(
          find
              .ancestor(
                of: find.text(en.addAsk),
                matching: find.byType(InkWell),
              )
              .first,
        );
        final log = tester.getRect(
          find
              .ancestor(
                of: find.text(en.addLogWithFemio),
                matching: find.byType(InkWell),
              )
              .first,
        );
        expect(ask.top, log.top);
        expect(ask.size, log.size, reason: 'equal choices');
        expect(find.text(en.addVisit), findsOneWidget);
        expect(
          find.text(en.addSayItPrompt),
          findsNothing,
          reason: 'the old say-it bar is gone from the sheet',
        );
        // The quick rows are untouched.
        expect(find.text(en.sectionMood), findsOneWidget);
        expect(find.text(en.addMoreToLog), findsOneWidget);
      },
    );

    for (final (label, pick, door) in [
      ('Ask femio', (L10n l) => l.addAsk, AssistantDoor.ask),
      ('Log with femio', (L10n l) => l.addLogWithFemio, AssistantDoor.sayIt),
      ('For my visit', (L10n l) => l.addVisit, AssistantDoor.visit),
    ]) {
      testWidgets('"$label" closes the sheet with its door', (tester) async {
        _size(tester, Brightness.light);
        final c = await _controller(_profile('en'));
        Object? result;
        await tester.pumpWidget(
          _app(
            'en',
            Brightness.light,
            Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async =>
                      result = await showModalBottomSheet<Object>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => AddSheet(controller: c, today: _today),
                      ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
        await tester.tap(find.text(pick(en)));
        await tester.pumpAndSettle();
        expect(result, door);
      });
    }

    testWidgets('with the assistant off neither choice is shown (rule 7)', (
      tester,
    ) async {
      _size(tester, Brightness.light);
      final c = await _controller(_profile('en', assistantOn: false));
      await openSheet(tester, c, 'en');
      expect(find.text(en.addAsk), findsNothing);
      expect(find.text(en.addLogWithFemio), findsNothing);
      expect(find.text(en.addVisit), findsNothing);
      expect(find.text(en.sectionMood), findsOneWidget);
    });
  });

  group('every assistant box ends with a paperclip and a mic (owner 2026-11-28)', () {
    testWidgets('Ask femio: Add a report and the mic sit in the text box', (tester) async {
      _size(tester, Brightness.light);
      final c = await _controller(_profile('en'));
      await tester.pumpWidget(_app('en', Brightness.light, AskScreen(controller: c, registry: _registry, today: _today)));
      await tester.pumpAndSettle();
      final en = lookupL10n(const Locale('en'));
      final field = find.byType(TextField).first;
      expect(find.descendant(of: field, matching: find.byTooltip(en.attachReport)), findsOneWidget);
      expect(find.descendant(of: field, matching: find.byType(MicButton)), findsOneWidget);
    });
  });

  group('Save this to your record?', () {
    test('the terms come from her question only, in vocabulary order', () {
      final terms = termsFromQuestion(_questionEn);
      expect(
        terms.length,
        greaterThanOrEqualTo(2),
        reason: 'cramps and headache are both named',
      );
      expect(termsFromQuestion(_questionNoTerms), isEmpty);
      expect(
        termsFromQuestion(_questionAr).length,
        greaterThanOrEqualTo(2),
        reason: 'the Arabic "what" is not a negation',
      );
      expect(
        termsFromQuestion('ما عندي مغص'),
        isEmpty,
        reason: 'a real denial still is one',
      );
    });

    test('the excerpt drops citation markers and is cut at a word', () {
      expect(
        answerExcerpt('Heat may help [1]. See a doctor [2].'),
        'Heat may help. See a doctor.',
      );
      final long = answerExcerpt('word ' * 200);
      expect(long.length, lessThanOrEqualTo(maxNoteAnswerLength + 1));
      expect(long.endsWith('…'), isTrue);
    });

    testWidgets(
      'nothing is ticked at first; tick the terms, deselect one; Save writes only the rest',
      (tester) async {
        final terms = termsFromQuestion(_questionEn);
        final c = await _askScreen(
          tester,
          'en',
          _questionEn,
          logs: {
            _today: const DayLog(terms: ['tired']),
          },
        );
        await _toBottom(tester);
        // Nothing is written by showing the prompt, and nothing starts ticked.
        expect(c.profile!.logs[_today]!.terms, ['tired']);
        expect(c.profile!.appointments, isEmpty);
        expect(find.byType(FilterChip), findsNothing);
        expect(
          tester.widget<FilledButton>(find.widgetWithText(FilledButton, en.askSaveAction)).onPressed,
          isNull,
          reason: 'Save waits for her tick',
        );
        await tester.tap(find.text(en.askSaveTerms));
        await tester.pumpAndSettle();
        for (final t in terms) {
          final chip = tester.widget<FilterChip>(
            find.widgetWithText(FilterChip, logLabel(en, t)),
          );
          expect(chip.selected, isTrue, reason: '$t is preselected');
        }
        await tester.tap(
          find.widgetWithText(FilterChip, logLabel(en, terms.last)),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text(en.askSaveAction));
        await tester.pumpAndSettle();
        final saved = c.profile!.logs[_today]!.terms;
        expect(saved, containsAll(['tired', ...terms.take(terms.length - 1)]));
        expect(
          saved.contains(terms.last),
          isFalse,
          reason: 'the deselected term is not saved',
        );
        expect(
          c.profile!.appointments,
          isEmpty,
          reason: 'the note was not ticked',
        );
        expect(
          find.text(en.askSaveTitle),
          findsNothing,
          reason: 'the prompt closes after Save',
        );
      },
    );

    testWidgets('Not now writes nothing', (tester) async {
      final c = await _askScreen(tester, 'en', _questionEn);
      await _toBottom(tester);
      final before = jsonEncode(c.profile!.toJson());
      await tester.tap(find.text(en.askSaveNotNow));
      await tester.pumpAndSettle();
      expect(find.text(en.askSaveTitle), findsNothing);
      expect(jsonEncode(c.profile!.toJson()), before);
    });

    testWidgets(
      'ticking the note keeps question and answer in the visit questions',
      (tester) async {
        final c = await _askScreen(tester, 'en', _questionEn);
        await _toBottom(tester);
        await tester.tap(find.text(en.askSaveNote));
        await tester.pumpAndSettle();
        await tester.tap(find.text(en.askSaveAction));
        await tester.pumpAndSettle();
        final prep = c.profile!.appointments.single.prep.single;
        expect(prep, startsWith('Asked femio: “$_questionEn” Answer: '));
        expect(
          prep.length,
          greaterThan('Asked femio: “$_questionEn” Answer: '.length + 20),
        );
        expect(
          c.profile!.logs[_today]?.terms ?? const [],
          isEmpty,
          reason: 'the terms were not ticked, so none were logged',
        );
      },
    );

    testWidgets(
      'with no terms found only the note is offered, and Save waits for a tick',
      (tester) async {
        final c = await _askScreen(tester, 'en', _questionNoTerms);
        await _toBottom(tester);
        expect(find.text(en.askSaveTerms), findsNothing);
        expect(find.byType(FilterChip), findsNothing);
        expect(
          tester
              .widget<FilledButton>(
                find.widgetWithText(FilledButton, en.askSaveAction),
              )
              .onPressed,
          isNull,
        );
        await tester.tap(find.text(en.askSaveNote));
        await tester.pumpAndSettle();
        await tester.tap(find.text(en.askSaveAction));
        await tester.pumpAndSettle();
        expect(
          c.profile!.appointments.single.prep.single,
          contains(_questionNoTerms),
        );
        expect(c.profile!.logs, isEmpty);
      },
    );

    testWidgets(
      'a question femio cannot answer can still be kept for the visit',
      (tester) async {
        final c = await _askScreen(tester, 'en', 'does my cat like jazz');
        await _toBottom(tester);
        await tester.tap(find.text(en.askSaveNote));
        await tester.pumpAndSettle();
        await tester.tap(find.text(en.askSaveAction));
        await tester.pumpAndSettle();
        expect(
          c.profile!.appointments.single.prep.single,
          en.askSaveNoteLineNoAnswer('does my cat like jazz'),
        );
      },
    );
  });

  for (final (lang, b) in const [
    ('en', Brightness.light),
    ('en', Brightness.dark),
    ('ar', Brightness.light),
    ('ar', Brightness.dark),
  ]) {
    testWidgets('shots: + sheet and save prompt ($lang ${b.name})', (
      tester,
    ) async {
      _size(tester, b);
      final l = lookupL10n(Locale(lang));
      final c = await _controller(_profile(lang));
      await tester.pumpWidget(FemioApp(controller: c, today: _today));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.navAdd));
      await tester.pumpAndSettle();
      expect(find.text(l.addLogWithFemio), findsOneWidget);
      await _shoot(tester, 'add_sheet_${lang}_${b.name}');

      await tester.pumpWidget(
        _app(
          lang,
          b,
          AskScreen(controller: c, registry: _registry, today: _today),
        ),
      );
      await tester.pumpAndSettle();
      await _ask(tester, lang == 'ar' ? _questionAr : _questionEn);
      await tester.scrollUntilVisible(
        find.text(l.askSaveTitle),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -120));
      await tester.pumpAndSettle();
      expect(find.text(l.askSaveTitle), findsOneWidget);
      await _shoot(tester, 'save_prompt_${lang}_${b.name}');
    });
  }
}
