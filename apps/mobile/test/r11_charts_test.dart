// R11.5: charts built from what she has. Blood pressure and glucose are typed record kinds
// that survive JSON and old records; the series builder keeps units apart, spaces dates for
// real, reads only her own printed range and never says what a number means; the Charts
// screen and the editor work in English and Arabic. With --update-goldens it writes proof
// shots (390x844 at 2x, EN and AR, light and dark) to testing-results/2026-11-28-r11-charts/.
// All data here is synthetic.

import 'dart:convert';
import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/backup.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/health_record.dart';
import 'package:femio/domain/record_charts.dart';
import 'package:femio/domain/weight.dart';
import 'package:femio/features/record/charts_screen.dart';
import 'package:femio/features/record/record_editor.dart';
import 'package:femio/features/record/record_labels.dart';
import 'package:femio/features/record/record_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-28-r11-charts';
const _today = '2026-11-28';
final _now = DateTime(2026, 11, 28, 9);

var _n = 0;
RecordEntry _e(RecordKind kind, String title, String day, Map<String, String> fields) => RecordEntry.create(
      id: 'e${_n++}',
      kind: kind,
      title: title,
      happenedOn: day,
      addedOn: '${day}T09:00:00',
      fields: fields,
    );

RecordEntry _bp(String day, String sys, String dia, [String? pulse]) => _e(
      RecordKind.bloodPressure,
      'Blood pressure',
      day,
      {RecordField.systolic: sys, RecordField.diastolic: dia, RecordField.pulse: ?pulse},
    );

RecordEntry _glucose(String day, String value, String unit, [String? context]) => _e(
      RecordKind.glucose,
      'Glucose',
      day,
      {RecordField.value: value, RecordField.unit: unit, RecordField.context: ?context},
    );

RecordEntry _lab(String title, String day, String value, {String unit = '', String? range}) => _e(
      RecordKind.lab,
      title,
      day,
      {RecordField.value: value, if (unit.isNotEmpty) RecordField.unit: unit, RecordField.printedRange: ?range},
    );

List<RecordEntry> _sampleRecord() => [
      _bp('2026-09-02', '118', '76', '70'),
      _bp('2026-10-04', '122', '80', '74'),
      _bp('2026-11-20', '116', '74'),
      _glucose('2026-10-01', '92', 'mg/dL', 'fasting'),
      _glucose('2026-10-15', '118', 'mg/dL', 'afterMeal'),
      _glucose('2026-11-10', '5.1', 'mmol/L', 'fasting'),
      _glucose('2026-11-18', '5.4', 'mmol/L', 'fasting'),
      _lab('TSH', '2026-06-10', '3.1', unit: 'mIU/L', range: '0.4 - 4.0'),
      _lab('TSH', '2026-11-02', '2.4', unit: 'mIU/L', range: '0.4 - 4.0'),
      _lab('Vitamin D', '2026-07-01', '22', unit: 'ng/mL', range: '30-100'),
      _lab('Vitamin D', '2026-11-05', '31', unit: 'ng/mL', range: '30-100'),
      _lab('AMH', '2026-08-12', '1.8', unit: 'ng/mL'),
      _lab('AMH', '2026-11-12', '1.6', unit: 'ng/mL'),
      _lab('HbA1c', '2026-05-01', '5.3', unit: '%', range: 'below 5.7'),
      _lab('HbA1c', '2026-11-01', '5.2', unit: '%', range: 'below 5.7'),
    ];

Profile _profile(String lang, {List<RecordEntry>? record, List<WeightEntry> weights = const []}) => Profile(
      goal: Goal.ttc,
      locale: lang,
      birthYear: 1994,
      periodStarts: const ['2026-11-05'],
      cycleLength: 28,
      record: record ?? _sampleRecord(),
      weights: weights,
      settings: AppSettings.defaultsFor(lang).copyWith(storageNoticeSeen: true, showHijri: false),
    );

Future<FemioController> _pump(WidgetTester tester, Profile p, Brightness b, Widget Function(FemioController) home) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  final c = FemioController(MemoryStore(p), initialLocale: p.locale, clock: () => _now);
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
    home: home(c),
  ));
  await tester.pumpAndSettle();
  return c;
}

/// Matches when either pattern does (the Arabic words have no `` word edge in Dart).
class _Either {
  const _Either(this.a, this.b);
  final RegExp a;
  final RegExp b;
  bool hasMatch(String s) => a.hasMatch(s) || b.hasMatch(s);
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  group('the record carries blood pressure and glucose', () {
    test('both survive JSON, the profile and the sealed backup', () async {
      final bp = _bp('2026-11-20', '116', '74', '68');
      final g = _glucose('2026-11-18', '5.4', 'mmol/L', 'afterMeal');
      for (final e in [bp, g]) {
        final back = RecordEntry.fromJson(jsonDecode(jsonEncode(e.toJson())) as Map<String, Object?>);
        expect(back.kind, e.kind);
        expect(back.fields, e.fields);
        expect(back.happenedOn, e.happenedOn);
      }
      final p = _profile('en', record: [bp, g]);
      final back = Profile.fromJson(jsonDecode(jsonEncode(p.toJson())) as Map<String, Object?>);
      expect(back.record.map((e) => e.kind), [RecordKind.bloodPressure, RecordKind.glucose]);
      expect(back.record.first.fields[RecordField.pulse], '68');
      final restored = await decodeBackup(await encodeBackup(p, 'a long enough passphrase'), 'a long enough passphrase');
      expect(restored.record.last.fields[RecordField.context], 'afterMeal');
    });

    test('a record written before these kinds loads unchanged; an unknown kind still falls back to a note', () {
      final old = _profile('en', record: [
        _lab('TSH', '2026-06-10', '3.1', unit: 'mIU/L'),
        _e(RecordKind.visit, 'Dr Salma', '2026-05-01', const {RecordField.place: 'Clinic'}),
      ]);
      final back = Profile.fromJson(jsonDecode(jsonEncode(old.toJson())) as Map<String, Object?>);
      expect(back.record.map((e) => e.toJson()), old.record.map((e) => e.toJson()));
      final odd = RecordEntry.fromJson({'id': 'x', 'kind': 'someFutureKind', 'title': 't', 'happenedOn': '2026-01-01'});
      expect(odd.kind, RecordKind.note);
    });

    test('a blood-pressure row reads "120/80 mmHg · 72 bpm" and a glucose row keeps its unit and context', () {
      final l = lookupL10n(const Locale('en'));
      expect(recordSummary(_bp('2026-11-20', '120', '80', '72')), contains('120/80 mmHg'));
      expect(recordSummary(_bp('2026-11-20', '120', '80', '72')), contains('72 bpm'));
      final g = recordSummary(_glucose('2026-11-18', '5.4', 'mmol/L', 'afterMeal'), l: l);
      expect(g, contains('5.4 mmol/L'));
      expect(g, contains(l.chartContextAfterMeal));
    });
  });

  group('printed range and numbers', () {
    test('a printed low-high range parses; anything else gives no band', () {
      expect(parsePrintedRange('0.4 - 4.0'), const PrintedRange(0.4, 4.0));
      expect(parsePrintedRange('0.4–4.0'), const PrintedRange(0.4, 4.0));
      expect(parsePrintedRange('0.4-4.0 mIU/L'), const PrintedRange(0.4, 4.0));
      expect(parsePrintedRange('(30 to 100)'), const PrintedRange(30, 100));
      expect(parsePrintedRange('0,4 – 4,0'), const PrintedRange(0.4, 4.0));
      expect(parsePrintedRange('٠٫٤ - ٤٫٠'), const PrintedRange(0.4, 4.0));
      expect(parsePrintedRange('1,000-2,000'), const PrintedRange(1000, 2000));
      for (final bad in ['', 'below 5.7', '<5', '> 3', '4.0 - 0.4', '5-5', '1-2-3', '10^9/L 4-10', 'abc', '-']) {
        expect(parsePrintedRange(bad), isNull, reason: bad);
      }
    });

    test('a reading must be a plain number', () {
      expect(parseReadingNumber('3.1'), 3.1);
      expect(parseReadingNumber(' 5,4 '), 5.4);
      expect(parseReadingNumber('٥٫٤'), 5.4);
      expect(parseReadingNumber('120'), 120);
      for (final bad in ['', '<0.5', 'positive', '5 to 6', '1.2.3', '-3']) {
        expect(parseReadingNumber(bad), isNull, reason: bad);
      }
    });

    test('axis ends are clean steps with a clean middle line', () {
      final a = niceAxis(2.4, 3.1);
      expect(a.low, lessThan(2.4));
      expect(a.high, greaterThan(3.1));
      expect(a.decimals, 1);
      final wide = niceAxis(92, 118);
      expect(wide.decimals, 0);
      expect(wide.low, lessThan(92));
      final flat = niceAxis(5, 5);
      expect(flat.low, lessThan(5));
      expect(flat.high, greaterThan(5));
    });
  });

  group('series', () {
    test('blood pressure needs two readings, uses both numbers and is in mmHg', () {
      expect(buildChartSeries([_bp('2026-11-20', '116', '74')]), isEmpty);
      final s = buildChartSeries([_bp('2026-11-20', '116', '74'), _bp('2026-09-02', '118', '76', '70')]).single;
      expect(s.kind, ChartKind.bloodPressure);
      expect(s.unit, 'mmHg');
      expect(s.readings.map((r) => r.day), ['2026-09-02', '2026-11-20']);
      expect(s.ys2, hasLength(2));
      expect(s.ys.every((y) => y > 0 && y < 1) && s.ys2.every((y) => y > 0 && y < 1), isTrue);
    });

    test('glucose in different units is two series, never mixed or converted', () {
      final series = buildChartSeries(_sampleRecord()).where((s) => s.kind == ChartKind.glucose).toList();
      expect(series.map((s) => s.unit), ['mg/dL', 'mmol/L']);
      expect(series[0].readings.map((r) => r.value), [92, 118]);
      expect(series[1].readings.map((r) => r.value), [5.1, 5.4]);
      // One mg/dL reading and one mmol/L reading do not make a series.
      expect(
        buildChartSeries([_glucose('2026-10-01', '92', 'mg/dL'), _glucose('2026-10-02', '5.1', 'mmol/L')]),
        isEmpty,
      );
      // The same unit typed with other spacing or case is the same unit.
      expect(
        buildChartSeries([_glucose('2026-10-01', '92', 'mg/dl'), _glucose('2026-10-02', '95', 'mg / dL')]),
        hasLength(1),
      );
    });

    test('a lab becomes a series by name and unit, case ignored, newest spelling drawn', () {
      final series = buildChartSeries([
        _lab('tsh', '2026-01-10', '2.0', unit: 'mIU/L'),
        _lab('TSH', '2026-06-10', '3.1', unit: 'mIU/L'),
        _lab('TSH', '2026-07-10', '9.0', unit: 'uIU/mL'),
        _lab('Ferritin', '2026-07-10', '40', unit: 'ng/mL'),
      ]);
      expect(series, hasLength(1));
      expect(series.single.title, 'TSH');
      expect(series.single.readings.map((r) => r.value), [2.0, 3.1]);
    });

    test('values that are not plain numbers stay out of the chart; the series order is blood pressure, glucose, labs by name', () {
      final series = buildChartSeries([
        _lab('hCG', '2026-01-10', '<5', unit: 'mIU/mL'),
        _lab('hCG', '2026-01-12', '12', unit: 'mIU/mL'),
        ..._sampleRecord(),
      ]);
      expect([for (final s in series) s.kind], [
        ChartKind.bloodPressure,
        ChartKind.glucose,
        ChartKind.glucose,
        ChartKind.lab,
        ChartKind.lab,
        ChartKind.lab,
        ChartKind.lab,
      ]);
      expect([for (final s in series) if (s.kind == ChartKind.lab) s.title], ['AMH', 'HbA1c', 'TSH', 'Vitamin D']);
    });

    test('dots sit at real date spacing; readings on one day sit in the middle', () {
      final s = buildChartSeries([
        _lab('TSH', '2026-01-01', '2', unit: 'x'),
        _lab('TSH', '2026-01-11', '3', unit: 'x'),
        _lab('TSH', '2026-01-31', '4', unit: 'x'),
      ]).single;
      expect(s.xs, [0, closeTo(1 / 3, 1e-9), 1]);
      final same = buildChartSeries([_lab('TSH', '2026-01-01', '2'), _lab('TSH', '2026-01-01', '3')]).single;
      expect(same.xs, [0.5, 0.5]);
    });

    test('the band is the range printed on her newest reading, and only when it parses', () {
      final tsh = buildChartSeries(_sampleRecord()).firstWhere((s) => s.title == 'TSH');
      expect(tsh.band, const PrintedRange(0.4, 4.0));
      final y = tsh.bandY!;
      expect(y.low, inInclusiveRange(0, 1));
      expect(y.high, inInclusiveRange(y.low, 1));
      expect(buildChartSeries(_sampleRecord()).firstWhere((s) => s.title == 'AMH').band, isNull);
      expect(buildChartSeries(_sampleRecord()).firstWhere((s) => s.title == 'HbA1c').band, isNull,
          reason: '"below 5.7" is one-sided: no band');
      // The axis makes room for the whole printed band.
      expect(tsh.axisLow, lessThanOrEqualTo(0.4));
      expect(tsh.axisHigh, greaterThanOrEqualTo(4.0));
    });

    test('blood pressure and glucose never get a band of femio\'s own', () {
      for (final s in buildChartSeries(_sampleRecord()).where((s) => s.kind != ChartKind.lab)) {
        expect(s.band, isNull);
        expect(s.bandY, isNull);
      }
    });
  });

  test('no verdict word in any new string, in any language', () {
    final latin = RegExp(
      r'\b(high|low|normal|abnormal|good|bad|healthy|target|goal|streak|great|well done|elevated|ideal|optimal|'
      r'élevé|élevée|bon|bonne|mauvais|objectif|alto|alta|bajo|baja|bueno|buena|malo|objetivo)\b',
      caseSensitive: false,
    );
    final arabic = RegExp('مرتفع|منخفض|طبيعي|جيد|سيئ|عالٍ|هدف');
    final verdict = _Either(latin, arabic);
    for (final loc in ['en', 'ar', 'fr', 'es']) {
      final arb = jsonDecode(File('lib/l10n/app_$loc.arb').readAsStringSync()) as Map<String, Object?>;
      for (final e in arb.entries) {
        if (!(e.key.startsWith('chart') || e.key.startsWith('medMonth')) || e.value is! String) continue;
        expect(verdict.hasMatch(e.value! as String), isFalse, reason: '$loc ${e.key}: ${e.value}');
      }
    }
  });

  group('screens', () {
    testWidgets('Charts lists every series with its dates and readings, and links to the weight chart', (tester) async {
      final weights = [WeightEntry('w1', '2026-10-01', 62, 'kg'), WeightEntry('w2', '2026-11-01', 63, 'kg')];
      await _pump(tester, _profile('en', weights: weights), Brightness.light, (c) => ChartsScreen(controller: c, today: _today));
      final l = lookupL10n(const Locale('en'));
      expect(find.text('${l.chartKindBloodPressure} · mmHg'), findsOneWidget);
      // A tall phone so every card is built; one glucose chart per unit (the unit is
      // isolated for right-to-left, so match by part).
      tester.view.physicalSize = const Size(780, 9000);
      await tester.pumpAndSettle();
      expect(find.textContaining('${l.chartKindGlucose} · '), findsNWidgets(2));
      expect(find.textContaining('TSH'), findsWidgets);
      expect(find.text(l.chartBpLegend), findsOneWidget);
      // The weight chart is linked, not redrawn.
      await tester.tap(find.text(l.weightHeading));
      await tester.pumpAndSettle();
      expect(find.text(l.weightNeedData), findsNothing);
      expect(find.byType(ChartsScreen), findsNothing);
    });

    testWidgets('the band caption shows only for a series whose printed range parsed', (tester) async {
      final l = lookupL10n(const Locale('en'));
      await _pump(
        tester,
        _profile('en', record: [_lab('TSH', '2026-06-10', '3.1', range: '0.4-4.0'), _lab('TSH', '2026-11-02', '2.4', range: '0.4-4.0')]),
        Brightness.light,
        (c) => ChartsScreen(controller: c, today: _today),
      );
      expect(find.text(l.chartBandNote), findsOneWidget);
      await _pump(
        tester,
        _profile('en', record: [_lab('AMH', '2026-06-10', '3.1'), _lab('AMH', '2026-11-02', '2.4')]),
        Brightness.light,
        (c) => ChartsScreen(controller: c, today: _today),
      );
      expect(find.text(l.chartBandNote), findsNothing);
    });

    testWidgets('with fewer than two readings of anything, Charts says when a chart will appear', (tester) async {
      final l = lookupL10n(const Locale('en'));
      await _pump(tester, _profile('en', record: [_bp('2026-11-20', '116', '74')]), Brightness.light,
          (c) => ChartsScreen(controller: c, today: _today));
      expect(find.text(l.chartEmptyHeading), findsOneWidget);
    });

    testWidgets('the record screen opens Charts', (tester) async {
      final l = lookupL10n(const Locale('en'));
      await _pump(tester, _profile('en'), Brightness.light, (c) => RecordScreen(controller: c, today: _today));
      await tester.tap(find.byTooltip(l.chartTitle));
      await tester.pumpAndSettle();
      expect(find.byType(ChartsScreen), findsOneWidget);
    });

    testWidgets('the editor saves a blood-pressure reading from two numbers and refuses a blank one', (tester) async {
      final l = lookupL10n(const Locale('en'));
      final c = await _pump(tester, _profile('en', record: const []), Brightness.light,
          (c) => RecordEditor(controller: c, today: _today, initialKind: RecordKind.bloodPressure));
      Future<void> save() async {
        await tester.scrollUntilVisible(find.text(l.recSave), 300, scrollable: find.byType(Scrollable).first);
        await tester.tap(find.text(l.recSave));
        await tester.pumpAndSettle();
      }

      // The day comes from the calendar, never a typed date.
      await tester.tap(find.text(l.recFormHappened));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await save();
      expect(find.text(l.chartNeedNumber), findsWidgets);
      expect(c.profile!.record, isEmpty);

      await tester.enterText(find.widgetWithText(TextField, l.chartFieldSystolic), '121');
      await tester.enterText(find.widgetWithText(TextField, l.chartFieldDiastolic), '79');
      await save();
      final saved = c.profile!.record.single;
      expect(saved.kind, RecordKind.bloodPressure);
      expect(saved.title, l.chartKindBloodPressure);
      expect(saved.happenedOn, _today);
      expect(saved.fields, {RecordField.systolic: '121', RecordField.diastolic: '79'});
    });

    testWidgets('the editor saves glucose with the unit chosen on a chip, never converted', (tester) async {
      final l = lookupL10n(const Locale('en'));
      final c = await _pump(tester, _profile('en', record: const []), Brightness.light,
          (c) => RecordEditor(controller: c, today: _today, initialKind: RecordKind.glucose));
      await tester.tap(find.text(l.recFormHappened));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, l.recFieldValue), '5.4');
      await tester.tap(find.text('mmol/L'));
      await tester.tap(find.text(l.chartContextFasting));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text(l.recSave), 300, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.text(l.recSave));
      await tester.pumpAndSettle();
      final saved = c.profile!.record.single;
      expect(saved.fields, {RecordField.value: '5.4', RecordField.unit: 'mmol/L', RecordField.context: 'fasting'});
    });
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      testWidgets('charts shots ($lang ${b.name})', (tester) async {
        if (!autoUpdateGoldenFiles) return;
        final p = _profile(lang);
        await _pump(tester, p, b, (c) => ChartsScreen(controller: c, today: _today));
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/charts_top_${lang}_${b.name}.png'));
        await tester.scrollUntilVisible(find.byType(ChartsScreen), 0, scrollable: find.byType(Scrollable).first);
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -1100));
        await tester.pumpAndSettle();
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/charts_labs_${lang}_${b.name}.png'));
        await _pump(tester, p, b, (c) => RecordEditor(controller: c, today: _today, initialKind: RecordKind.bloodPressure));
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/editor_bp_${lang}_${b.name}.png'));
      });
    }
  }
}
