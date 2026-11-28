// Tests for cloud reading on phones without Gemini Nano (ADR-089, owner 2026-11-28) and the
// Cloud boost check's technical details line.
//
// What they prove: her record reaches the cloud only with the "Read my reports in the cloud"
// consent AND her approval on a preview sheet; without the consent femio offers the AI wizard
// instead of sending; a phone with Nano never uses the cloud path; the page picture travels
// only inside CloudPrompt.record; and a failed check shows Android's technical line.
// Screenshots at 390x844 (light, dark, Arabic) go to testing-results/2026-11-28-r15-cloud-reading/
// under `--update-goldens` only.

import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/assistant_channel.dart';
import 'package:femio/data/assistant_gateway.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/assistant/approved_record.dart';
import 'package:femio/domain/assistant/cloud_consent.dart';
import 'package:femio/domain/assistant/cloud_prompt.dart';
import 'package:femio/domain/assistant/private_prompt.dart';
import 'package:femio/features/assistant/after_visit_screen.dart';
import 'package:femio/features/assistant/ai_choices_wizard.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:femio/features/assistant/assistant_settings_screen.dart';
import 'package:femio/features/assistant/cloud_reading.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _out = '../../../testing-results/2026-11-28-r15-cloud-reading';
const _today = '2026-11-28';
const _visitReply = 'MED|Metformin|500 mg twice a day\nNEXT|2026-12-20';

/// A phone bridge whose Nano and cloud answers the test sets; records what reached the cloud.
class _Bridge implements AssistantBridge, CloudChecker {
  _Bridge({this.nano = false, this.hybridReply, this.check});
  final bool nano;
  String? hybridReply;
  final CloudCheck? check;
  final sent = <CloudPrompt>[];

  @override
  Future<AssistantStatus> status() async =>
      AssistantStatus(configured: true, onDevice: nano ? OnDeviceModel.available : OnDeviceModel.unavailable);

  @override
  Future<bool> downloadModel() async => false;

  @override
  Future<String?> runPrivate(PrivatePrompt prompt) async => nano ? 'NONE' : null;

  @override
  Future<HybridReply?> runHybrid(CloudPrompt prompt) async {
    sent.add(prompt);
    final r = hybridReply;
    return r == null ? null : HybridReply(text: r, onDevice: false);
  }

  @override
  Future<bool> openSource(String url) async => true;

  @override
  Future<CloudCheck> checkCloud() async => check ?? const CloudCheck(ok: true, ms: 900);

  @override
  String? get lastHybridFailure => null;
}

CloudConsent _consent(Set<CloudPurpose> purposes) => const CloudConsent().grant(purposes, '2026-11-28T08:00:00Z');

Future<FemioController> _controller(String lang, Set<CloudPurpose> purposes) async {
  final p = Profile(goal: Goal.ttc, locale: lang, birthYear: 1990, periodStarts: const ['2026-10-01', '2026-10-29']);
  final c = FemioController(MemoryStore(p.copyWith(settings: p.settings.copyWith(cloud: _consent(purposes)))));
  await c.load();
  return c;
}

Widget _app(String lang, Brightness b, AssistantBridge bridge, Widget home) => MaterialApp(
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
      builder: (context, child) => AssistantScope(bridge: bridge, child: child!),
      home: home,
    );

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
    'assets/fonts/IBMPlexSansArabic-Regular.ttf',
    'assets/fonts/IBMPlexSansArabic-Medium.ttf',
    'assets/fonts/IBMPlexSansArabic-SemiBold.ttf',
    'assets/fonts/IBMPlexSansArabic-Bold.ttf',
  ]);
  final sdk = Platform.environment['FLUTTER_ROOT'] ?? '/root/sdk/flutter';
  await load('MaterialIcons', ['$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf']);
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

Future<void> _pumpFor(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

ApprovedRecord _report(int pages) => ApprovedRecord.approvedOnSheet(
      reading: RecordReading.report,
      pages: [for (var i = 0; i < pages; i++) Uint8List.fromList([i, 1, 2])],
      today: _today,
    );

void main() {
  setUpAll(() async {
    configureFormatting();
    await _loadFonts();
  });

  group('gateway', () {
    test('a report she approved is read in the cloud, one page picture per call, only with the records consent', () async {
      final b = _Bridge(hybridReply: 'LAB|TSH|2.1|mIU/L|');
      final g = AssistantGateway(b);
      final none = await g.readDocumentInCloud(_report(2), _consent({CloudPurpose.questions, CloudPurpose.tips}));
      expect(none.ranOn, RanOn.rules);
      expect(b.sent, isEmpty, reason: 'Cloud boost for questions or tips is not consent to send her record');

      final r = await g.readDocumentInCloud(_report(2), _consent({CloudPurpose.records}));
      expect(r.ranOn, RanOn.cloud);
      expect(r.value!.lines, isNotEmpty);
      expect(b.sent, hasLength(2));
      expect(b.sent.every((p) => p.image != null), isTrue);
    });

    test('a phone with Gemini Nano never takes the cloud reading path', () async {
      final b = _Bridge(nano: true, hybridReply: 'LAB|TSH|2.1|mIU/L|');
      final r = await AssistantGateway(b).readDocumentInCloud(_report(1), _consent({CloudPurpose.records}));
      expect(r.ranOn, RanOn.rules);
      expect(b.sent, isEmpty);
    });

    test('an approval for one reading cannot be spent on another', () async {
      final b = _Bridge(hybridReply: _visitReply);
      final g = AssistantGateway(b);
      final consent = _consent({CloudPurpose.records});
      expect((await g.readVisitWordsInCloud(_report(1), consent)).ranOn, RanOn.rules);
      expect((await g.readNoteInCloud(_report(1), 0, consent)).ranOn, RanOn.rules);
      expect(b.sent, isEmpty);
    });

    test('visit words and a Say it note carry no picture, only the words she approved', () async {
      final b = _Bridge(hybridReply: _visitReply);
      final g = AssistantGateway(b);
      final consent = _consent({CloudPurpose.records});
      final visit = ApprovedRecord.approvedOnSheet(reading: RecordReading.visitWords, parts: ['metformin 500 twice a day'], today: _today);
      final r = await g.readVisitWordsInCloud(visit, consent);
      expect(r.ranOn, RanOn.cloud);
      expect(r.value!.nextVisit, '2026-12-20');
      expect(b.sent.single.image, isNull);
      expect(b.sent.single.text, contains('metformin 500 twice a day'));
    });

    test('the Cloud boost check runs under any purpose, records included', () async {
      final b = _Bridge(check: const CloudCheck(ok: false, reason: 'app_check', detail: 'FirebaseException: Too many attempts'));
      final r = await AssistantGateway(b).checkCloud(_consent({CloudPurpose.records}));
      expect(r!.detail, contains('Too many attempts'));
    });
  });

  group('screens', () {
    testWidgets('After a visit without Nano and without cloud reading offers the wizard, and sends nothing', (tester) async {
      await _size(tester);
      final b = _Bridge(hybridReply: _visitReply);
      final c = await _controller('en', {CloudPurpose.questions});
      await tester.pumpWidget(_app('en', Brightness.light, b, AfterVisitScreen(controller: c, today: _today)));
      await tester.pumpAndSettle();
      final l = lookupL10n(const Locale('en'));
      await tester.enterText(find.byType(TextField), 'metformin 500 twice a day, back on 20 December');
      await tester.tap(find.text(l.afterVisitRead));
      // The Read button spins while the dialog or sheet is open, so settle by time.
      await _pumpFor(tester);
      expect(find.text(l.cloudReadOfferTitle), findsOneWidget);
      await tester.tap(find.text(l.cloudReadTurnOn));
      await tester.pumpAndSettle();
      expect(find.byType(AiChoicesWizard), findsOneWidget);
      expect(b.sent, isEmpty);
    });

    testWidgets('After a visit with cloud reading shows the preview, and Send reads her words into a draft', (tester) async {
      await _size(tester);
      final b = _Bridge(hybridReply: _visitReply);
      final c = await _controller('en', {CloudPurpose.records});
      await tester.pumpWidget(_app('en', Brightness.light, b, AfterVisitScreen(controller: c, today: _today)));
      await tester.pumpAndSettle();
      final l = lookupL10n(const Locale('en'));
      await tester.enterText(find.byType(TextField), 'metformin 500 twice a day, back on 20 December');
      await tester.tap(find.text(l.afterVisitRead));
      // The Read button spins while the dialog or sheet is open, so settle by time.
      await _pumpFor(tester);
      expect(find.byType(CloudReadingSheet), findsOneWidget);
      expect(b.sent, isEmpty, reason: 'nothing goes before Send');
      await tester.tap(find.text(l.cloudReadSend));
      await tester.pumpAndSettle();
      expect(b.sent, hasLength(1));
      expect(find.text(l.afterVisitCheck), findsOneWidget);
      expect(find.text(l.cloudReadDone), findsOneWidget);
    });

    testWidgets('Not now on the preview sends nothing and keeps her words as a note', (tester) async {
      await _size(tester);
      final b = _Bridge(hybridReply: _visitReply);
      final c = await _controller('en', {CloudPurpose.records});
      await tester.pumpWidget(_app('en', Brightness.light, b, AfterVisitScreen(controller: c, today: _today)));
      await tester.pumpAndSettle();
      final l = lookupL10n(const Locale('en'));
      await tester.enterText(find.byType(TextField), 'all fine');
      await tester.tap(find.text(l.afterVisitRead));
      // The Read button spins while the dialog or sheet is open, so settle by time.
      await _pumpFor(tester);
      await tester.tap(find.text(l.cloudReadNotNow));
      await tester.pumpAndSettle();
      expect(b.sent, isEmpty);
      expect(find.text(l.afterVisitNoAi), findsOneWidget);
      expect(find.text(l.cloudReadButton), findsOneWidget, reason: 'she can still change her mind');
    });

    testWidgets('a failed Cloud boost check shows the technical details line', (tester) async {
      await _size(tester);
      const detail = 'FirebaseException: Error returned from API. code: 403 body: App attestation failed.';
      final b = _Bridge(check: const CloudCheck(ok: false, reason: 'app_check', detail: detail));
      final c = await _controller('en', {CloudPurpose.records});
      await tester.pumpWidget(_app('en', Brightness.light, b, AssistantSettingsScreen(controller: c)));
      await tester.pumpAndSettle();
      final l = lookupL10n(const Locale('en'));
      await tester.scrollUntilVisible(find.text(l.cloudCheckButton), 200, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.text(l.cloudCheckButton));
      await tester.pumpAndSettle();
      expect(find.text(l.cloudCheckDetail(detail)), findsOneWidget);
      await _shoot('check_detail_en_light');
    });

    for (final (lang, b) in const [('en', Brightness.light), ('ar', Brightness.light), ('ar', Brightness.dark)]) {
      testWidgets('screenshot: the cloud reading preview ($lang, ${b.name})', (tester) async {
        await _size(tester);
        await tester.pumpWidget(_app(lang, b, _Bridge(), Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (_) => CloudReadingSheet(
                    reading: RecordReading.visitWords,
                    parts: [lang == 'ar' ? 'ميتفورمين 500 مرتين يومياً، والمتابعة يوم 20 ديسمبر' : 'Metformin 500 twice a day, back on 20 December'],
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        )));
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
        await _shoot('preview_words_${lang}_${b.name}');
      });

      testWidgets('screenshot: the wizard offers cloud reading as its own box ($lang, ${b.name})', (tester) async {
        await _size(tester);
        final c = await _controller(lang, const {});
        await tester.pumpWidget(_app(lang, b, _Bridge(), AiChoicesWizard(controller: c, start: AiMode.cloud, today: _today)));
        await tester.pumpAndSettle();
        final l = lookupL10n(Locale(lang));
        await tester.tap(find.text(l.aiWizardNext));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l.aiWizardNext));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(find.text(l.boostAgreeRecords), 200, scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        expect(find.text(l.boostAgreeRecords), findsOneWidget);
        await _shoot('wizard_records_${lang}_${b.name}');
      });
    }
  });
}
