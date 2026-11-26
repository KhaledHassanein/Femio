// R11.2 (ADR-082 §2): documents and photos in her health record. Sealed files, limits, links,
// the backup, the editor and the viewer. With --update-goldens it writes proof shots (390x844
// at 2x, EN and AR, light and dark) to testing-results/2026-11-26-r11-documents/.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:femio/app.dart';
import 'package:femio/data/attachment_store.dart';
import 'package:femio/data/document_source.dart';
import 'package:femio/data/key_vault.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/record_documents.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/health_record.dart';
import 'package:femio/domain/record_attachment.dart';
import 'package:femio/features/record/document_thumb.dart';
import 'package:femio/features/record/document_viewer.dart';
import 'package:femio/features/record/documents_section.dart';
import 'package:femio/features/record/record_editor.dart';
import 'package:femio/features/record/record_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-26-r11-documents';
const _today = '2026-11-26';

/// A 1x1 PNG, enough for the store and the controller.
final _png = base64Decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==');

/// A drawn "lab report" page, so the screenshots show something that reads like one.
Future<Uint8List> _reportPage(String heading) async {
  final rec = ui.PictureRecorder();
  final c = Canvas(rec);
  const w = 600.0, h = 800.0;
  c.drawRect(const Rect.fromLTWH(0, 0, w, h), Paint()..color = const Color(0xFFFFFFFF));
  final ink = Paint()..color = const Color(0xFF5B4A63);
  c.drawRect(const Rect.fromLTWH(40, 40, 260, 26), ink);
  final grey = Paint()..color = const Color(0xFFCFC6D3);
  for (var i = 0; i < 14; i++) {
    c.drawRect(Rect.fromLTWH(40, 110.0 + i * 44, i.isEven ? 520 : 380, 14), grey);
  }
  final img = await rec.endRecording().toImage(w.toInt(), h.toInt());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

class _FakeDevice implements DocumentSource {
  PickedDocument? nextFile;
  PickedDocument? nextPhoto;
  List<Uint8List> pages = const [];
  final shared = <String>[];

  @override
  Future<PickedDocument?> pickFile() async => nextFile;

  @override
  Future<PickedDocument?> takePhoto() async => nextPhoto;

  @override
  Future<List<Uint8List>> pdfPages(Uint8List pdf) async => pages;

  @override
  Future<bool> share(Uint8List bytes, String name, String mime) async {
    shared.add(name);
    return true;
  }
}

Profile _profile(String lang, {List<RecordEntry> record = const []}) => Profile(
      goal: Goal.ttc,
      locale: lang,
      birthYear: 1994,
      periodStarts: const ['2026-11-05'],
      cycleLength: 28,
      record: record,
      settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
    );

RecordEntry _visit({List<String> ids = const []}) => RecordEntry.create(
      id: 'v1',
      kind: RecordKind.lab,
      title: 'TSH',
      happenedOn: '2026-11-02',
      addedOn: '2026-11-20T09:00:00',
      fields: const {RecordField.value: '3.1', RecordField.unit: 'mIU/L', RecordField.printedRange: '0.4 - 4.0'},
      attachmentIds: ids,
    );

Future<FemioController> _controller(Profile p, {_FakeDevice? device, AttachmentStore? files}) async {
  final c = FemioController(MemoryStore(p), initialLocale: p.locale, deviceFiles: device ?? _FakeDevice(), files: files);
  await c.load();
  return c;
}

Future<void> _pump(WidgetTester tester, FemioController c, Widget home, Brightness b) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
    locale: Locale(c.profile!.locale),
    supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr'), Locale('es')],
    localizationsDelegates: const [
      L10n.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: home,
  ));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  group('RecordAttachment', () {
    test('round-trips JSON; the type comes from the name; names are trimmed and capped', () {
      const a = RecordAttachment(id: 'abcdefgh12', name: 'Lab.pdf', mime: 'application/pdf', sizeBytes: 1200, addedOn: '2026-11-26T10:00:00');
      expect(RecordAttachment.fromJson(a.toJson()), a);
      expect(attachmentMimeFor('Scan.JPG'), 'image/jpeg');
      expect(attachmentMimeFor('notes.docx'), isNull);
      expect(a.renamed('   ').name, 'Lab.pdf');
      expect(a.renamed('x' * 200).name.length, maxAttachmentNameLength);
      expect(() => RecordAttachment.fromJson(const {'name': 'x'}), throwsFormatException);
    });

    test('a record without documents writes no attachments key, and old files load', () {
      final p = _profile('en');
      expect(p.toJson().containsKey('attachments'), isFalse);
      expect(Profile.fromJson(p.toJson()).attachments, isEmpty);
    });
  });

  group('sealed files', () {
    test('bytes are sealed on disk, open again with the key, and a bad id is refused', () async {
      final dir = await Directory.systemTemp.createTemp('femio-docs');
      addTearDown(() => dir.delete(recursive: true));
      final vault = MemoryKeyVault();
      final store = EncryptedAttachmentStore(vault: vault, directory: dir);
      final plain = utf8.encode('%PDF-1.4 TSH 3.1 mIU/L');
      await store.put('abcdefgh1234', plain);
      final onDisk = File('${dir.path}/$attachmentFolder/abcdefgh1234').readAsBytesSync();
      expect(utf8.decode(onDisk, allowMalformed: true).contains('TSH'), isFalse, reason: 'never plain on disk');
      expect(await store.read('abcdefgh1234'), plain);
      expect(() => store.put('../../escape', plain), throwsArgumentError);
      expect(await store.read('../../escape'), isNull);
      // Without the key (after "delete everything") the file cannot be read.
      await vault.delete(recordKeyName);
      expect(await store.read('abcdefgh1234'), isNull);
      await store.clear();
      expect(Directory('${dir.path}/$attachmentFolder').existsSync(), isFalse);
    });
  });

  group('the controller', () {
    test('adds within the limits, links on save, deletes everywhere with an edit trail', () async {
      final files = MemoryAttachmentStore();
      final c = await _controller(_profile('en', record: [_visit()]), files: files);
      expect((await c.documents.add(_png, 'notes.docx')).failure, AddDocumentFailure.unsupportedType);
      expect((await c.documents.add(Uint8List(maxAttachmentBytes + 1), 'big.pdf')).failure, AddDocumentFailure.tooLarge);
      expect((await c.documents.add(const [], 'empty.pdf')).failure, AddDocumentFailure.empty);
      final added = (await c.documents.add(_png, 'tsh-report.png')).attachment!;
      expect(added.mime, 'image/png');
      expect(files.files.containsKey(added.id), isTrue);
      await c.saveRecordEntry(c.profile!.record.single.edit(at: '2026-11-26T10:00:00', attachmentIds: [added.id]));
      expect(entriesLinking(c.profile!, added.id).single.id, 'v1');
      await c.documents.delete(added.id);
      expect(c.profile!.attachments, isEmpty);
      expect(c.profile!.record.single.attachmentIds, isEmpty);
      expect(c.profile!.record.single.edits.last.fields, contains('attachments'));
      expect(files.files, isEmpty);
    });

    test('a document added and abandoned is dropped; a linked one stays', () async {
      final c = await _controller(_profile('en', record: [_visit()]));
      final kept = (await c.documents.add(_png, 'kept.png')).attachment!;
      final left = (await c.documents.add(_png, 'left.png')).attachment!;
      await c.saveRecordEntry(c.profile!.record.single.edit(at: '2026-11-26T10:00:00', attachmentIds: [kept.id]));
      await c.documents.dropUnlinked([kept.id, left.id]);
      expect([for (final a in c.profile!.attachments) a.name], ['kept.png']);
    });

    test('the backup carries the documents to a new phone, and refuses over 100 MB', () async {
      final c = await _controller(_profile('en', record: [_visit()]));
      final a = (await c.documents.add(_png, 'tsh.png')).attachment!;
      await c.saveRecordEntry(c.profile!.record.single.edit(at: '2026-11-26T10:00:00', attachmentIds: [a.id]));
      const pass = 'a long enough passphrase';
      final file = await c.exportBackup(pass);

      final newPhone = MemoryAttachmentStore();
      final d = await _controller(_profile('en'), files: newPhone);
      await d.importBackup(file, pass);
      expect(d.profile!.attachments.single.name, 'tsh.png');
      expect(d.profile!.record.single.attachmentIds, [a.id]);
      expect(newPhone.files[a.id], _png);

      final huge = await _controller(_profile('en').copyWith(attachments: [
        for (var i = 0; i < 11; i++)
          RecordAttachment(id: 'doc$i-abcdefg', name: '$i.pdf', mime: 'application/pdf', sizeBytes: maxAttachmentBytes, addedOn: '2026-11-26T10:00:00'),
      ]));
      expect(() => huge.exportBackup(pass), throwsA(isA<BackupTooLargeError>()));
    });

    test('delete everything removes the document files', () async {
      final files = MemoryAttachmentStore();
      final c = await _controller(_profile('en'), files: files);
      await c.documents.add(_png, 'a.png');
      await c.deleteEverything();
      expect(files.files, isEmpty);
    });
  });

  testWidgets('the editor attaches a picked file and keeps it only when saved', (tester) async {
    final device = _FakeDevice()..nextFile = PickedDocument(_png, 'tsh-report.png');
    final c = await _controller(_profile('en', record: [_visit()]), device: device);
    final l = lookupL10n(const Locale('en'));
    await _pump(tester, c, RecordEditor(controller: c, today: _today, initialKind: RecordKind.lab, existing: c.profile!.record.single), Brightness.light);
    await tester.scrollUntilVisible(find.text(l.recDocsAddFile), 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text(l.recDocsAddFile));
    await tester.pumpAndSettle();
    expect(find.byType(DocumentThumb), findsOneWidget);
    await tester.tap(find.text(l.recSave));
    await tester.pumpAndSettle();
    final id = c.profile!.attachments.single.id;
    expect(c.profile!.record.single.attachmentIds, [id]);
  });

  testWidgets('too big a file is refused in words', (tester) async {
    final device = _FakeDevice()..nextFile = const PickedDocument.tooLarge();
    final c = await _controller(_profile('en', record: [_visit()]), device: device);
    final l = lookupL10n(const Locale('en'));
    await _pump(tester, c, RecordEditor(controller: c, today: _today, initialKind: RecordKind.lab, existing: c.profile!.record.single), Brightness.light);
    await tester.scrollUntilVisible(find.text(l.recDocsAddFile), 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text(l.recDocsAddFile));
    await tester.pump();
    expect(find.text(l.recDocsTooLarge), findsOneWidget);
    expect(c.profile!.attachments, isEmpty);
  });

  testWidgets('the viewer renames, shares and deletes after a confirmation', (tester) async {
    final device = _FakeDevice();
    final c = await _controller(_profile('en', record: [_visit()]), device: device);
    final a = (await c.documents.add(_png, 'scan.png')).attachment!;
    final l = lookupL10n(const Locale('en'));
    await _pump(tester, c, DocumentViewer(controller: c, id: a.id), Brightness.light);
    await tester.tap(find.byTooltip(l.recDocShare));
    await tester.pumpAndSettle();
    expect(device.shared, ['scan.png']);
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.recDocRename).last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'TSH November');
    await tester.tap(find.text(l.recSave));
    await tester.pumpAndSettle();
    expect(c.documents.byId(a.id)!.name, 'TSH November');
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.recDocDelete));
    await tester.pumpAndSettle();
    expect(find.text(l.recDocDeleteTitle), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, l.recDelete));
    await tester.pumpAndSettle();
    expect(c.profile!.attachments, isEmpty);
  });

  for (final (lang, b) in const [
    ('en', Brightness.light),
    ('en', Brightness.dark),
    ('ar', Brightness.light),
    ('ar', Brightness.dark),
  ]) {
    testWidgets('document shots ($lang ${b.name})', (tester) async {
      final pages = await tester.runAsync(() async => [await _reportPage('TSH'), await _reportPage('page 2')]);
      final photo = await tester.runAsync(() => _reportPage('scan'));
      final device = _FakeDevice()..pages = pages!;
      final c = await _controller(_profile(lang, record: [_visit()]), device: device);
      final pdf = (await c.documents.add(utf8.encode('%PDF-1.4 fake'), 'TSH report, Cairo lab.pdf')).attachment!;
      final scan = (await c.documents.add(photo!, 'scan.png')).attachment!;
      await c.saveRecordEntry(c.profile!.record.single.edit(at: '2026-11-26T10:00:00', attachmentIds: [pdf.id, scan.id]));

      await _pump(tester, c, RecordEditor(controller: c, today: _today, initialKind: RecordKind.lab, existing: c.profile!.record.single), b);
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.scrollUntilVisible(find.byType(DocumentsSection), 300, scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      if (autoUpdateGoldenFiles) {
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/editor_docs_${lang}_${b.name}.png'));
      }

      await _pump(tester, c, DocumentViewer(controller: c, id: pdf.id), b);
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsWidgets);
      if (autoUpdateGoldenFiles) {
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/viewer_pdf_${lang}_${b.name}.png'));
      }

      await _pump(tester, c, RecordScreen(controller: c, today: _today), b);
      await tester.tap(find.byIcon(Icons.folder_outlined));
      await tester.pumpAndSettle();
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pumpAndSettle();
      expect(find.byType(DocumentsLibraryScreen), findsOneWidget);
      if (autoUpdateGoldenFiles) {
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/library_${lang}_${b.name}.png'));
      }
    });
  }
}
