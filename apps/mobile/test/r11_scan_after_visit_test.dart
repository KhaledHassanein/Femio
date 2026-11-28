// Read a report with AI and After a visit (R11.3, R10.11, ADR-087).
//
// They prove: the reply parser keeps only known line shapes, sane sizes and real dates; the
// gateway sends each page picture to the phone-only call, reads at most three pages, and never
// calls the model on a phone without Gemini Nano; saved entries carry the confirmed date, the
// "scanned" source and the document link; nothing is written until she taps Save; and After a
// visit keeps her words as a visit note even with the AI off. Everything is synthetic.
// Screenshots at 390x844 (EN and AR, light and dark) go to
// testing-results/2026-11-28-r11-scan/ under `--update-goldens` only.

import 'dart:convert';
import 'dart:typed_data';

import 'package:femio/app.dart';
import 'package:femio/data/assistant_channel.dart';
import 'package:femio/data/assistant_gateway.dart';
import 'package:femio/data/document_source.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/assistant/cloud_prompt.dart';
import 'package:femio/domain/assistant/private_prompt.dart';
import 'package:femio/domain/assistant/record_draft.dart';
import 'package:femio/domain/assistant/uses.dart';
import 'package:femio/domain/health_record.dart';
import 'package:femio/features/assistant/after_visit_screen.dart';
import 'package:femio/features/assistant/assistant_scope.dart';
import 'package:femio/features/record/scan_report.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-28-r11-scan';
const _today = '2026-11-28';

final _png = base64Decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==');

const _labReply = '''
DATE|2026-11-02
LAB|TSH|3.1|mIU/L|0.4-4.0
LAB|Free T4|1.2|ng/dL|0.8-1.8
LAB|Patient name|Salma|-|
MED|Folic acid|5 mg|once a day
nonsense line
''';

/// A bridge whose phone answer the test sets; it records every prompt and page it was given.
class _Bridge implements AssistantBridge {
  _Bridge({this.reply, this.nano = true});
  final String? reply;
  final bool nano;
  final prompts = <PrivatePrompt>[];

  @override
  Future<AssistantStatus> status() async =>
      AssistantStatus(configured: true, onDevice: nano ? OnDeviceModel.available : OnDeviceModel.unavailable);

  @override
  Future<bool> downloadModel() async => true;

  @override
  Future<String?> runPrivate(PrivatePrompt prompt) async {
    prompts.add(prompt);
    return reply;
  }

  @override
  Future<HybridReply?> runHybrid(CloudPrompt prompt) async => null;

  @override
  Future<bool> openSource(String url) async => true;
}

class _Device implements DocumentSource {
  List<Uint8List> pages = const [];

  @override
  Future<PickedDocument?> pickFile() async => null;

  @override
  Future<PickedDocument?> takePhoto() async => null;

  @override
  Future<List<Uint8List>> pdfPages(Uint8List pdf) async => pages;

  @override
  Future<bool> share(Uint8List bytes, String name, String mime) async => true;
}

Profile _profile(String lang) => Profile(
      goal: Goal.ttc,
      locale: lang,
      birthYear: 1994,
      periodStarts: const ['2026-11-05'],
      cycleLength: 28,
      settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false, assistantIntroSeen: true),
    );

Future<FemioController> _controller(String lang, {_Device? device}) async {
  final c = FemioController(MemoryStore(_profile(lang)), initialLocale: lang, deviceFiles: device ?? _Device());
  await c.load();
  return c;
}

Future<void> _pump(WidgetTester tester, String lang, Brightness b, AssistantBridge bridge, Widget home) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
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
  ));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  group('parseRecordDraft', () {
    test('keeps known lines with numbers; drops names, unknown shapes and future dates', () {
      final d = parseRecordDraft(_labReply, _today);
      expect(d.date, '2026-11-02');
      expect([for (final l in d.lines) l.title], ['TSH', 'Free T4', 'Folic acid']);
      expect(d.lines.first.fields, {'value': '3.1', 'unit': 'mIU/L', 'printedRange': '0.4-4.0'});
      expect(d.lines.last.kind, DraftKind.medicine);
      expect(d.lines.last.fields, {'dose': '5 mg', 'frequency': 'once a day'});
      expect(parseRecordDraft('DATE|2026-12-30\nLAB|TSH|3|x|', _today).date, isNull, reason: 'a report date cannot be ahead');
      expect(parseRecordDraft('DATE|2026-02-31', _today).date, isNull, reason: 'not a real day');
      expect(parseRecordDraft('NONE', _today).isEmpty, isTrue);
    });

    test('a next visit must be ahead and within two years; long parts are dropped; at most 30 lines', () {
      expect(parseRecordDraft('NEXT|2027-01-10', _today).nextVisit, '2027-01-10');
      expect(parseRecordDraft('NEXT|2026-11-01', _today).nextVisit, isNull);
      expect(parseRecordDraft('NEXT|2030-01-10', _today).nextVisit, isNull);
      expect(parseRecordDraft('LAB|${'x' * 61}|3|u|', _today).lines, isEmpty);
      final many = [for (var i = 0; i < 40; i++) 'LAB|T$i|$i|u|'].join('\n');
      expect(parseRecordDraft(many, _today).lines, hasLength(maxDraftLines));
    });

    test('pages merge: the first date wins and a repeated line on the same day is kept once', () {
      final a = parseRecordDraft('DATE|2026-11-02\nLAB|TSH|3.1|mIU/L|', _today);
      final b = parseRecordDraft('DATE|2026-11-02\nLAB|TSH|3.1|mIU/L|\nLAB|AMH|2.0|ng/mL|', _today);
      final m = a.merge(b);
      expect(m.date, '2026-11-02');
      expect([for (final l in m.lines) l.title], ['TSH', 'AMH']);
      expect(m.lines.every((l) => l.date == null), isTrue, reason: 'same day as the report: no own date');
    });

    test('pages with another date keep every line and their own date (owner bug 2026-11-28)', () {
      final a = parseRecordDraft('DATE|2026-11-20\nMED|Letrozole|5 mg|once a day\nLAB|TSH|3.1|mIU/L|', _today);
      final b = parseRecordDraft('DATE|2026-11-22\nMED|Letrozole|10 mg|once a day\nLAB|TSH|3.1|mIU/L|', _today);
      final m = a.merge(b);
      expect(m.date, '2026-11-20');
      expect([for (final l in m.lines) '${l.title} ${l.date}'],
          ['Letrozole null', 'TSH null', 'Letrozole 2026-11-22', 'TSH 2026-11-22']);
      final e = entriesFromDraft(m.lines, happenedOn: m.date!, addedOn: '2026-11-28T10:00:00', idPrefix: 'r', source: RecordSource.scanned);
      expect([for (final x in e) x.happenedOn], ['2026-11-20', '2026-11-20', '2026-11-22', '2026-11-22']);
      expect(e[2].fields[RecordField.startedOn], '2026-11-22');
      expect(e[2].fields['dose'], '10 mg');
    });

    test('unread pages add up across a merge', () {
      final m = const RecordDraft().withUnreadPages(1).merge(const RecordDraft().withUnreadPages(2));
      expect(m.unreadPages, 3);
    });

    test('entries carry the confirmed date, the source, the document link and a medicine start', () {
      final d = parseRecordDraft(_labReply, _today);
      final e = entriesFromDraft(d.lines, happenedOn: '2026-11-02', addedOn: '2026-11-28T10:00:00', idPrefix: 'r1', source: RecordSource.scanned, attachmentId: 'doc1');
      expect(e.map((x) => x.kind), [RecordKind.lab, RecordKind.lab, RecordKind.medicine]);
      expect(e.every((x) => x.happenedOn == '2026-11-02' && x.source == RecordSource.scanned && x.attachmentIds.single == 'doc1'), isTrue);
      expect(e.last.fields[RecordField.startedOn], '2026-11-02');
      expect(e.map((x) => x.id).toSet(), hasLength(3));
    });
  });

  group('gateway', () {
    test('each page goes to the phone-only call with its picture; at most three pages', () async {
      final b = _Bridge(reply: _labReply);
      final r = await AssistantGateway(b).readDocument(List.filled(5, _png), _today);
      expect(r.ranOn, RanOn.phone);
      expect(b.prompts, hasLength(maxScanPages));
      expect(b.prompts.every((p) => p.use == AssistantUse.scanDocument && p.image != null), isTrue);
      expect(r.value!.lines, hasLength(3));
    });

    test('a page the phone gives no answer for is counted, not dropped silently', () async {
      final r = await AssistantGateway(_Bridge(reply: null)).readDocument([_png, _png], _today);
      expect(r.value?.unreadPages ?? 2, 2);
    });

    test('a phone without Gemini Nano never calls the model', () async {
      final b = _Bridge(reply: _labReply, nano: false);
      expect((await AssistantGateway(b).readDocument([_png], _today)).ranOn, RanOn.rules);
      expect((await AssistantGateway(b).readVisitWords('start folic acid', _today)).ranOn, RanOn.rules);
      expect(b.prompts, isEmpty);
    });

    test('after-visit words reach the phone call with today; NONE is a fair empty answer', () async {
      final b = _Bridge(reply: 'MED|Folic acid|5 mg|daily\nNEXT|2027-01-10\nNOTE|Start folic acid.');
      final r = await AssistantGateway(b).readVisitWords('start folic acid, see you 10 January', _today);
      expect(r.value!.nextVisit, '2027-01-10');
      expect(b.prompts.single.use, AssistantUse.afterVisit);
      expect(b.prompts.single.text, contains(_today));
      final none = await AssistantGateway(_Bridge(reply: 'NONE')).readVisitWords('all fine', _today);
      expect(none.ranOn, RanOn.phone);
      expect(none.value!.isEmpty, isTrue);
    });
  });

  group('screens', () {
    testWidgets('read a report: nothing is saved until Save; unticked lines stay out', (tester) async {
      final c = await _controller('en');
      final doc = (await c.documents.add(_png, 'tsh.png')).attachment!;
      await _pump(tester, 'en', Brightness.light, _Bridge(reply: _labReply),
          ScanDraftScreen(controller: c, documentId: doc.id, today: _today));
      expect(find.text('Check what the AI read'), findsOneWidget);
      expect(find.textContaining('TSH'), findsOneWidget);
      expect(c.profile!.record, isEmpty);
      await tester.tap(find.textContaining('Free T4'));
      await tester.pump();
      await tester.tap(find.text('Save to my record'));
      await tester.pumpAndSettle();
      final saved = c.profile!.record;
      expect(saved.map((e) => e.title), unorderedEquals(['TSH', 'Folic acid']));
      expect(saved.every((e) => e.attachmentIds.contains(doc.id) && e.happenedOn == '2026-11-02'), isTrue);
    });

    testWidgets('read a report: a date is required when none was printed', (tester) async {
      final c = await _controller('en');
      final doc = (await c.documents.add(_png, 'tsh.png')).attachment!;
      await _pump(tester, 'en', Brightness.light, _Bridge(reply: 'LAB|TSH|3.1|mIU/L|'),
          ScanDraftScreen(controller: c, documentId: doc.id, today: _today));
      await tester.tap(find.text('Save to my record'));
      await tester.pumpAndSettle();
      expect(c.profile!.record, isEmpty);
      expect(find.text('Tap to pick the date printed on the report'), findsOneWidget);
    });

    testWidgets('after a visit with the AI off keeps her words as a visit note', (tester) async {
      final c = await _controller('en');
      await _pump(tester, 'en', Brightness.light, _Bridge(nano: false), AfterVisitScreen(controller: c, today: _today));
      await tester.enterText(find.byType(TextField), 'Repeat TSH in six weeks.');
      await tester.tap(find.text('Make a draft'));
      // No Nano: femio offers cloud reading first (ADR-089); she says Not now and nothing is sent.
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();
      expect(find.textContaining("isn't available on this phone"), findsOneWidget);
      await tester.tap(find.text('Save to my record'));
      await tester.pumpAndSettle();
      final visit = c.profile!.record.single;
      expect(visit.kind, RecordKind.visit);
      expect(visit.fields[RecordField.details], 'Repeat TSH in six weeks.');
    });

    testWidgets('after a visit with Gemini Nano saves the ticked medicine and the next visit', (tester) async {
      final c = await _controller('en');
      await _pump(tester, 'en', Brightness.light, _Bridge(reply: 'MED|Folic acid|5 mg|daily\nNEXT|2027-01-10'),
          AfterVisitScreen(controller: c, today: _today));
      await tester.enterText(find.byType(TextField), 'Start folic acid 5 mg daily, next visit 10 January.');
      await tester.tap(find.text('Make a draft'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save to my record'));
      await tester.pumpAndSettle();
      final p = c.profile!;
      expect(p.record.map((e) => e.kind), unorderedEquals([RecordKind.visit, RecordKind.medicine]));
      expect(p.appointments.single.datetime, '2027-01-10T09:00');
    });

    for (final lang in ['en', 'ar']) {
      for (final b in Brightness.values) {
        testWidgets('screenshots $lang ${b.name}', (tester) async {
          final c = await _controller(lang);
          final doc = (await c.documents.add(_png, 'tsh.png')).attachment!;
          await _pump(tester, lang, b, _Bridge(reply: _labReply), ScanDraftScreen(controller: c, documentId: doc.id, today: _today));
          if (autoUpdateGoldenFiles) {
            await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/scan_draft_${lang}_${b.name}.png'));
          }
          await _pump(tester, lang, b, _Bridge(reply: 'MED|Folic acid|5 mg|daily\nNEXT|2027-01-10\nNOTE|Start folic acid.'),
              AfterVisitScreen(controller: c, today: _today));
          await tester.enterText(find.byType(TextField), lang == 'ar' ? 'ابدئي حمض الفوليك 5 ملغ يوميًا' : 'Start folic acid 5 mg daily');
          await tester.tap(find.byIcon(Icons.auto_awesome_rounded));
          await tester.pumpAndSettle();
          if (autoUpdateGoldenFiles) {
            await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/after_visit_${lang}_${b.name}.png'));
          }
        });
      }
    }
  });
}
