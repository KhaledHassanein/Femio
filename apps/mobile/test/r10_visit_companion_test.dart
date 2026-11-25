// Screens for the visit companion (R10.2, R8.27): her worry becomes reviewed questions, the
// ones she keeps join her visit list, and the pack goes to the share sheet in her language
// plus one for the clinic. Runs with the AI off (OfflineAssistant): nothing here needs a model.
//
// Why it exists: the saved list and the shared text are what she takes to a real visit; both
// must hold exactly what she chose. Screenshots land in
// testing-results/2026-11-25-r10-visit-companion/ under `--update-goldens`.

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/share_channel.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/appointments.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:femio/features/assistant/visit_pack.dart' show visitQuestionText;
import 'package:femio/features/assistant/visit_summary_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-25-r10-visit-companion';
const _today = '2026-06-20';

const _worry = {'en': 'I have bad cramps every month', 'ar': 'عندي مغص شديد مع الدورة'};
const _clinic = {'en': 'ar', 'ar': 'en'};

Future<FemioController> _controller(String lang) async {
  final c = FemioController(
    MemoryStore(
      Profile(
        goal: Goal.period,
        locale: lang,
        birthYear: 1994,
        periodStarts: const ['2026-04-26', '2026-05-24'],
        logs: const {
          '2026-05-24': DayLog(flow: 'medium', terms: ['cramps']),
          '2026-05-25': DayLog(flow: 'heavy', terms: ['cramps', 'fatigue']),
        },
        appointments: const [Appointment(id: 'a1', datetime: '2026-06-28T10:00')],
        settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
      ),
    ),
    initialLocale: lang,
  );
  await c.load();
  return c;
}

Widget _app(String lang, Brightness b, Widget home) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
      locale: Locale(lang),
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr'), Locale('es')],
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => AssistantScope(bridge: const OfflineAssistant(), child: child!),
      home: home,
    );

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

Future<void> _shoot(String name) async {
  if (!autoUpdateGoldenFiles) return;
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/$name.png'));
}

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
    final tag = '${lang}_${b.name}';

    testWidgets('worry to questions, saved to her visit, shared in two languages ($tag)', (tester) async {
      _phone(tester);
      final c = await _controller(lang);
      final l = lookupL10n(Locale(lang));
      final clinic = lookupL10n(Locale(_clinic[lang]!));
      String? shared;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(shareChannel, (call) async {
        shared = (call.arguments as Map)['text'] as String;
        return true;
      });
      addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(shareChannel, null));

      await tester.pumpWidget(_app(lang, b, VisitSummaryScreen(controller: c, today: _today)));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), _worry[lang]!);
      await tester.tap(find.text(l.visitWorryFind));
      await tester.pumpAndSettle();
      expect(find.text(l.visitWorrySuggested), findsOneWidget);
      final pain = visitQuestionText(l, 'painCauseChecks');
      expect(find.text(pain), findsOneWidget, reason: 'the reviewed pain question fits');
      await _shoot('${tag}_worry');

      final add = find.text(l.visitWorryAdd);
      await tester.ensureVisible(add);
      await tester.tap(add);
      await tester.pumpAndSettle();
      final prep = c.profile!.appointments.single.prep;
      expect(prep, contains(pain));
      expect(prep.last, _worry[lang], reason: 'her own words, as she wrote them');
      expect(find.byType(SnackBar), findsOneWidget);

      final mine = find.text(l.visitYourQuestions);
      await tester.ensureVisible(mine);
      await tester.pumpAndSettle();
      await _shoot('${tag}_visit_list');

      final chip = find.widgetWithText(ChoiceChip, {'en': 'English', 'ar': 'العربية'}[_clinic[lang]]!);
      await tester.ensureVisible(chip);
      await tester.tap(chip);
      await tester.pumpAndSettle();
      final share = find.text(l.visitShare);
      await tester.ensureVisible(share);
      await tester.tap(share);
      await tester.pumpAndSettle();
      expect(shared, isNotNull, reason: 'the system share sheet got the pack');
      expect(shared, contains(l.visitTitle));
      expect(shared, contains(clinic.visitTitle));
      expect(shared, contains(visitQuestionText(clinic, 'painCauseChecks')), reason: 'the question in the clinic language');
      expect(shared, contains(clinic.visitInMyWords(_worry[lang]!)), reason: 'her words, labelled, never translated');
      await _shoot('${tag}_share_language');

      // Removing a line takes it out of her saved list.
      await tester.dragUntilVisible(mine, find.byType(ListView), const Offset(0, 300));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip(l.visitRemoveQuestion).first);
      await tester.pumpAndSettle();
      expect(c.profile!.appointments.single.prep, isNot(contains(pain)));
    });
  }
}
