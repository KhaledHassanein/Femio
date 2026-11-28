// R11.6 month view: the day-by-day status of one medicine and its plain count, and the grid on
// the medicine page. Facts only (taken, partly, not taken, not marked); a medicine femio keeps
// no schedule for stays out. With --update-goldens it writes proof shots (390x844 at 2x, EN and
// AR, light and dark) to testing-results/2026-11-28-r11-charts/. All data here is synthetic.

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/health_record.dart';
import 'package:femio/domain/medicine_month.dart';
import 'package:femio/domain/medicines.dart';
import 'package:femio/features/record/medicine_month_view.dart';
import 'package:femio/features/record/medicine_page.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-28-r11-charts';
const _today = '2026-11-28';
final _now = DateTime(2026, 11, 28, 7, 30);

RecordEntry _med(String id, String title, {Map<String, String> fields = const {}}) => RecordEntry.create(
      id: id,
      kind: RecordKind.medicine,
      title: title,
      happenedOn: '2026-10-20',
      addedOn: '2026-10-20T09:00:00',
      fields: fields,
    );

final _metformin = _med('m1', 'Metformin', fields: const {RecordField.startedOn: '2026-11-01', RecordField.dose: '500 mg'});
final _pill = _med('m2', 'Yasmin (birth control)', fields: const {RecordField.startedOn: '2026-11-01'});
final _asNeeded = _med('m3', 'Paracetamol');

const _morning = 9 * 60;
const _evening = 21 * 60;
const _plan = MedicinePlan(entryId: 'm1', times: [_morning, _evening]);

DoseMark _mark(String id, String day, int slot, DoseStatus s) => DoseMark(
      entryId: id,
      day: day,
      slot: slot,
      status: s,
      at: '${day}T${(slot ~/ 60).toString().padLeft(2, '0')}:05:00',
    );

String _d(int n) => '2026-11-${n.toString().padLeft(2, '0')}';

/// Days 1-9 both doses taken, 10 one taken and one not, 11 both marked not taken, the rest unmarked.
List<DoseMark> _marks() => [
      for (var n = 1; n <= 9; n++) ...[
        _mark('m1', _d(n), _morning, DoseStatus.taken),
        _mark('m1', _d(n), _evening, DoseStatus.taken),
      ],
      _mark('m1', _d(10), _morning, DoseStatus.taken),
      _mark('m1', _d(10), _evening, DoseStatus.skipped),
      _mark('m1', _d(11), _morning, DoseStatus.skipped),
      _mark('m1', _d(11), _evening, DoseStatus.skipped),
    ];

MedicineMonth _nov({RecordEntry? entry, MedicinePlan plan = _plan, List<DoseMark>? doses, String today = _today}) => medicineMonth(
      entry: entry ?? _metformin,
      plan: plan,
      doses: doses ?? _marks(),
      year: 2026,
      month: 11,
      today: today,
    );

MonthDayStatus _on(MedicineMonth m, int day) => m.days[day - 1].status;

Profile _profile(String lang, {List<DoseMark>? doses}) => Profile(
      goal: Goal.ttc,
      locale: lang,
      birthYear: 1994,
      periodStarts: const ['2026-11-05'],
      cycleLength: 28,
      record: [_metformin, _pill, _asNeeded],
      medicinePlans: const [
        _plan,
        MedicinePlan(entryId: 'm2', times: [_morning]),
      ],
      doses: doses ?? _marks(),
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

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  group('day status', () {
    test('every planned dose taken, some taken, none taken, nothing marked', () {
      final m = _nov();
      expect(_on(m, 1), MonthDayStatus.taken);
      expect(_on(m, 9), MonthDayStatus.taken);
      expect(_on(m, 10), MonthDayStatus.partly);
      expect(_on(m, 11), MonthDayStatus.notTaken);
      expect(_on(m, 12), MonthDayStatus.notMarked);
      expect(_on(m, 27), MonthDayStatus.notMarked);
    });

    test('the count is days with every planned dose taken out of planned days up to today; today waits until marked', () {
      final m = _nov();
      // Days 1 to 27 were planned and over; today (28) is unmarked, so it is not counted yet.
      expect(m.plannedDays, 27);
      expect(m.takenDays, 9);
      expect(_on(m, 28), MonthDayStatus.notMarked);
      final marked = _nov(doses: [
        ..._marks(),
        _mark('m1', _today, _morning, DoseStatus.taken),
        _mark('m1', _today, _evening, DoseStatus.taken),
      ]);
      expect(marked.plannedDays, 28);
      expect(marked.takenDays, 10);
    });

    test('days after today are upcoming, and days before the written start or after the end are not planned', () {
      final m = _nov();
      expect(_on(m, 29), MonthDayStatus.upcoming);
      expect(_on(m, 30), MonthDayStatus.upcoming);
      final oct = medicineMonth(
        entry: _metformin,
        plan: _plan,
        doses: _marks(),
        year: 2026,
        month: 10,
        today: _today,
      );
      expect(oct.days.every((d) => d.status == MonthDayStatus.notPlanned), isTrue);
      expect(oct.plannedDays, 0);
      final ended = _med('m1', 'Metformin', fields: const {RecordField.startedOn: '2026-11-01', RecordField.endedOn: '2026-11-15'});
      final e = _nov(entry: ended);
      expect(_on(e, 16), MonthDayStatus.notPlanned);
      expect(e.plannedDays, 15);
    });

    test('a medicine femio keeps no schedule for stays out, exactly as marks and reminders do', () {
      final m = _nov(
        entry: _pill,
        plan: const MedicinePlan(entryId: 'm2', times: [_morning]),
        doses: [_mark('m2', _d(3), _morning, DoseStatus.taken)],
      );
      expect(m.days.every((d) => d.status == MonthDayStatus.notPlanned), isTrue);
      expect(m.plannedDays, 0);
      expect(m.takenDays, 0);
    });

    test('a medicine taken when needed counts the days she marked a dose, with no planned days', () {
      final m = _nov(
        entry: _asNeeded,
        plan: const MedicinePlan(entryId: 'm3'),
        doses: [
          DoseMark(entryId: 'm3', day: _d(4), status: DoseStatus.taken, at: '${_d(4)}T10:00:00'),
          DoseMark(entryId: 'm3', day: _d(4), status: DoseStatus.taken, at: '${_d(4)}T18:00:00'),
          DoseMark(entryId: 'm3', day: _d(9), status: DoseStatus.taken, at: '${_d(9)}T10:00:00'),
        ],
      );
      expect(m.asNeeded, isTrue);
      expect(m.plannedDays, 0);
      expect(m.takenDays, 2);
      expect(_on(m, 4), MonthDayStatus.taken);
      expect(_on(m, 5), MonthDayStatus.notPlanned);
    });

    test('a time she has since removed still counts for the day she marked it', () {
      final m = _nov(
        plan: const MedicinePlan(entryId: 'm1', times: [_morning]),
        doses: [_mark('m1', _d(5), _morning, DoseStatus.taken), _mark('m1', _d(5), _evening, DoseStatus.taken)],
      );
      expect(_on(m, 5), MonthDayStatus.taken);
      final half = _nov(
        plan: const MedicinePlan(entryId: 'm1', times: [_morning]),
        doses: [_mark('m1', _d(5), _evening, DoseStatus.taken)],
      );
      expect(_on(half, 5), MonthDayStatus.partly);
    });

    test('another medicine\'s marks never count', () {
      final m = _nov(doses: [_mark('other', _d(2), _morning, DoseStatus.taken), _mark('other', _d(2), _evening, DoseStatus.taken)]);
      expect(_on(m, 2), MonthDayStatus.notMarked);
      expect(m.takenDays, 0);
    });
  });

  group('months', () {
    test('the arrows run from the month the medicine started to this month', () {
      final b = medicineMonthBounds(entry: _metformin, doses: _marks(), today: _today);
      expect(b.first, (year: 2026, month: 11));
      expect(b.last, (year: 2026, month: 11));
      // No written start: the day it was added; an older mark reaches further back.
      final plain = medicineMonthBounds(entry: _asNeeded, doses: const [], today: _today);
      expect(plain.first, (year: 2026, month: 10));
      final older = medicineMonthBounds(
        entry: _asNeeded,
        doses: [DoseMark(entryId: 'm3', day: '2026-08-30', status: DoseStatus.taken, at: '2026-08-30T08:00:00')],
        today: _today,
      );
      expect(older.first, (year: 2026, month: 8));
    });

    test('adding months crosses the year both ways', () {
      expect(addMonths((year: 2026, month: 12), 1), (year: 2027, month: 1));
      expect(addMonths((year: 2026, month: 1), -1), (year: 2025, month: 12));
      expect(monthBefore((year: 2025, month: 12), (year: 2026, month: 1)), isTrue);
      expect(monthBefore((year: 2026, month: 1), (year: 2026, month: 1)), isFalse);
    });

    test('February in a leap year has 29 days', () {
      final m = medicineMonth(entry: _asNeeded, plan: const MedicinePlan(entryId: 'm3'), doses: const [], year: 2028, month: 2, today: '2028-03-01');
      expect(m.days, hasLength(29));
    });
  });

  group('the grid on the medicine page', () {
    testWidgets('shows the month, the plain count and the legend; the back arrow stops at the first month', (tester) async {
      await _pump(tester, _profile('en'), Brightness.light, (c) => MedicinePage(controller: c, entryId: 'm1', today: _today));
      final l = lookupL10n(const Locale('en'));
      await tester.scrollUntilVisible(find.text(l.medMonthHeading), 300, scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      expect(find.text('November 2026'), findsOneWidget);
      expect(find.text(l.medMonthCount(9, 27)), findsOneWidget);
      expect(find.text(l.medMonthCount(9, 27)), findsOneWidget);
      expect(find.text(l.medMonthTaken), findsOneWidget);
      expect(find.text(l.medMonthPartly), findsOneWidget);
      expect(find.text(l.medMonthNotTaken), findsOneWidget);
      expect(find.text(l.medMonthNotMarked), findsOneWidget);
      // Started in November and today is in November: both arrows are off.
      expect(tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.chevron_left_rounded)).onPressed, isNull);
      expect(tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.chevron_right_rounded)).onPressed, isNull);
    });

    testWidgets('the arrows move between months of a medicine with earlier marks', (tester) async {
      final doses = [
        DoseMark(entryId: 'm3', day: '2026-10-05', status: DoseStatus.taken, at: '2026-10-05T10:00:00'),
        DoseMark(entryId: 'm3', day: '2026-11-06', status: DoseStatus.taken, at: '2026-11-06T10:00:00'),
        DoseMark(entryId: 'm3', day: '2026-11-07', status: DoseStatus.taken, at: '2026-11-07T10:00:00'),
      ];
      await _pump(tester, _profile('en', doses: doses), Brightness.light,
          (c) => Scaffold(body: SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
                MedicineMonthView(controller: c, entry: _asNeeded, today: _today),
              ]))));
      final l = lookupL10n(const Locale('en'));
      expect(find.text('November 2026'), findsOneWidget);
      expect(find.text(l.medMonthCountAsNeeded(2)), findsOneWidget);
      await tester.tap(find.byTooltip(l.medMonthPrevious));
      await tester.pumpAndSettle();
      expect(find.text('October 2026'), findsOneWidget);
      expect(find.text(l.medMonthCountAsNeeded(1)), findsOneWidget);
      expect(tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.chevron_left_rounded)).onPressed, isNull);
      await tester.tap(find.byTooltip(l.medMonthNext));
      await tester.pumpAndSettle();
      expect(find.text('November 2026'), findsOneWidget);
    });

    testWidgets('a birth-control medicine page has no month grid', (tester) async {
      await _pump(tester, _profile('en'), Brightness.light, (c) => MedicinePage(controller: c, entryId: 'm2', today: _today));
      expect(find.text(lookupL10n(const Locale('en')).medMonthHeading), findsNothing);
    });

    test('the count line is a fact in all four languages, with no praise or score words', () {
      final praise = RegExp(r'\b(great|well done|perfect|streak|score|good|bad|missed|failed|bravo|parfait|excelente|perfecto)\b', caseSensitive: false);
      for (final loc in ['en', 'ar', 'fr', 'es']) {
        final l = lookupL10n(Locale(loc));
        for (final line in [l.medMonthCount(18, 23), l.medMonthCount(1, 1), l.medMonthCountAsNeeded(0), l.medMonthCountAsNeeded(3), l.medMonthCountNone]) {
          expect(praise.hasMatch(line), isFalse, reason: '$loc: $line');
        }
      }
      final en = lookupL10n(const Locale('en'));
      expect(en.medMonthCount(18, 23), 'Every planned dose marked taken on 18 of 23 planned days.');
      expect(en.medMonthCount(1, 1), 'Every planned dose marked taken on 1 of 1 planned day.');
      // Arabic keeps Western digits.
      expect(lookupL10n(const Locale('ar')).medMonthCount(18, 23), contains('18'));
    });
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      testWidgets('month shots ($lang ${b.name})', (tester) async {
        if (!autoUpdateGoldenFiles) return;
        await _pump(tester, _profile(lang), b, (c) => MedicinePage(controller: c, entryId: 'm1', today: _today));
        await tester.scrollUntilVisible(find.text(lookupL10n(Locale(lang)).medMonthHeading), 300,
            scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/medicine_month_${lang}_${b.name}.png'));
      });
    }
  }
}
