// R11.0 / R11.1 (ADR-082): schema v3 carries her health record; the "My record" screen
// adds, lists and edits entries. With --update-goldens it writes proof shots (390x844 at
// 2x, EN and AR, light and dark) to testing-results/2026-11-26-r11-record/.

import 'package:femio/app.dart';
import 'package:femio/data/backup.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/health_record.dart';
import 'package:femio/features/record/record_editor.dart';
import 'package:femio/features/record/record_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-26-r11-record';
const _today = '2026-11-26';

RecordEntry _tsh() => RecordEntry.create(
      id: 'r1',
      kind: RecordKind.lab,
      title: 'TSH',
      happenedOn: '2026-11-02',
      addedOn: '2026-11-20T09:00:00',
      fields: const {RecordField.value: '3.1', RecordField.unit: 'mIU/L', RecordField.printedRange: '0.4 - 4.0'},
    );

RecordEntry _med() => RecordEntry.create(
      id: 'r2',
      kind: RecordKind.medicine,
      title: 'Folic acid',
      happenedOn: '2026-10-15',
      addedOn: '2026-11-21T10:00:00',
      fields: const {RecordField.dose: '400 mcg', RecordField.frequency: 'once a day'},
    );

RecordEntry _visit() => RecordEntry.create(
      id: 'r3',
      kind: RecordKind.visit,
      title: 'Gynaecology check',
      happenedOn: '2026-11-18',
      addedOn: '2026-11-18T19:00:00',
      fields: const {RecordField.place: 'Cairo clinic'},
    ).edit(at: '2026-11-19T08:00:00', fields: const {RecordField.place: 'Cairo clinic, 3rd floor'});

Profile _profile(String lang, [List<RecordEntry> record = const []]) => Profile(
      goal: Goal.ttc,
      locale: lang,
      birthYear: 1994,
      periodStarts: const ['2026-11-05'],
      cycleLength: 28,
      record: record,
      settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
    );

Future<FemioController> _pump(WidgetTester tester, Profile p, Brightness b) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  final c = FemioController(MemoryStore(p), initialLocale: p.locale);
  await c.load();
  await tester.pumpWidget(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
    locale: Locale(p.locale),
    supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr'), Locale('es')],
    localizationsDelegates: const [
      L10n.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: RecordScreen(controller: c, today: _today),
  ));
  await tester.pumpAndSettle();
  return c;
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  group('schema v3', () {
    test('a v2 record loads with an empty health record and saves as v3', () {
      final v2 = {..._profile('en').toJson()}..['v'] = 2;
      final p = Profile.fromJson(migrateRecord(v2));
      expect(p.record, isEmpty);
      expect(p.toJson()['v'], 3);
      expect(p.toJson().containsKey('record'), isFalse, reason: 'empty stays absent');
    });

    test('the record survives JSON and the sealed backup', () async {
      final p = _profile('en', [_tsh(), _med(), _visit()]);
      final back = Profile.fromJson(p.toJson());
      expect([for (final e in back.record) e.toJson()], [for (final e in p.record) e.toJson()]);
      const pass = 'a long enough passphrase';
      final restored = await decodeBackup(await encodeBackup(p, pass), pass);
      expect(restored.record.length, 3);
      expect(restored.record.last.edited, isTrue);
    });

    test('a file from a newer femio is refused, not read without its new parts', () {
      final future = {..._profile('en').toJson()}..['v'] = schemaVersion + 1;
      expect(() => Profile.fromJson(migrateRecord(future)), throwsFormatException);
    });
  });

  testWidgets('adding an entry: title and day are required, then it is listed', (tester) async {
    final c = await _pump(tester, _profile('en'), Brightness.light);
    final l = lookupL10n(const Locale('en'));
    expect(find.text(l.recEmptyHeading), findsOneWidget);
    await tester.tap(find.text(l.recAdd));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.recSave));
    await tester.pumpAndSettle();
    expect(find.text(l.recNeedTitle), findsOneWidget);
    expect(find.text(l.recNeedDate), findsOneWidget);
    expect(c.profile!.record, isEmpty, reason: 'never saved without the day it happened');
    await tester.enterText(find.byType(TextField).first, 'Dr Salma');
    await tester.tap(find.text(l.recFormHappened));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.recSave));
    await tester.pumpAndSettle();
    expect(c.profile!.record.single.title, 'Dr Salma');
    expect(c.profile!.record.single.happenedOn, _today);
    expect(find.byType(RecordEditor), findsNothing);
    expect(find.text('Dr Salma'), findsOneWidget);
  });

  for (final (lang, b) in const [
    ('en', Brightness.light),
    ('en', Brightness.dark),
    ('ar', Brightness.light),
    ('ar', Brightness.dark),
  ]) {
    testWidgets('record shots ($lang ${b.name})', (tester) async {
      await _pump(tester, _profile(lang, [_tsh(), _med(), _visit()]), b);
      expect(find.text('TSH'), findsOneWidget);
      if (autoUpdateGoldenFiles) {
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/record_${lang}_${b.name}.png'));
      }
      await tester.tap(find.text('TSH'));
      await tester.pumpAndSettle();
      expect(find.byType(RecordEditor), findsOneWidget);
      if (autoUpdateGoldenFiles) {
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/editor_${lang}_${b.name}.png'));
      }
    });
  }
}
