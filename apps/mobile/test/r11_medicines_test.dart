// R11.6: her medicines. The plan and dose marks travel with the record; reminders follow her
// times, skip a dose she marked and never exist for a contraceptive; the screens mark a dose
// and set times. With --update-goldens it writes proof shots (390x844 at 2x, EN and AR, light
// and dark) to testing-results/2026-11-26-r11-medicines/.

import 'package:femio/app.dart';
import 'package:femio/data/backup.dart';
import 'package:femio/data/notification_port.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/health_record.dart';
import 'package:femio/domain/medicines.dart';
import 'package:femio/domain/notification_kinds.dart';
import 'package:femio/domain/reminders.dart';
import 'package:femio/features/record/medicine_page.dart';
import 'package:femio/features/record/medicines_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-26-r11-medicines';
const _today = '2026-11-26';
final _now = DateTime(2026, 11, 26, 7, 30);

RecordEntry _med(String id, String title, {Map<String, String> fields = const {}}) => RecordEntry.create(
      id: id,
      kind: RecordKind.medicine,
      title: title,
      happenedOn: '2026-11-01',
      addedOn: '2026-11-01T09:00:00',
      fields: fields,
    );

final _folic = _med('m1', 'Folic acid', fields: const {RecordField.dose: '400 mcg', RecordField.frequency: 'once a day'});
final _metformin = _med('m2', 'Metformin', fields: const {
  RecordField.dose: '500 mg',
  RecordField.frequency: 'twice a day with meals',
  RecordField.endedOn: '2026-12-31',
});
final _course = _med('m3', 'Antibiotic', fields: const {RecordField.endedOn: '2026-11-10'});
final _pill = _med('m4', 'Yasmin (birth control)');

Profile _profile(String lang, {List<MedicinePlan> plans = const [], List<DoseMark> doses = const [], bool consent = true}) =>
    Profile(
      goal: Goal.ttc,
      locale: lang,
      birthYear: 1994,
      periodStarts: const ['2026-11-05'],
      cycleLength: 28,
      record: [_folic, _metformin, _course, _pill],
      medicinePlans: plans,
      doses: doses,
      settings: AppSettings.defaultsFor(lang).copyWith(
        storageNoticeSeen: true,
        showHijri: false,
        medicineReminder: consent,
        notificationConsentAt: consent ? '2026-11-20T10:00:00' : null,
      ),
    );

const _plans = [
  MedicinePlan(entryId: 'm1', times: [8 * 60], remind: true, refillOn: '2026-12-01'),
  MedicinePlan(entryId: 'm2', times: [9 * 60, 21 * 60], remind: true, label: 'Evening'),
];

class _Port implements NotificationPort {
  @override
  Future<void> openSettings() async {}
  final plans = <List<PlannedReminder>>[];
  @override
  Future<bool> requestPermission() async => true;
  @override
  Future<void> replaceAll(List<PlannedReminder> plan, ReminderTexts texts) async => plans.add(plan);
  @override
  Future<void> cancelAll() async {}
}

Future<FemioController> _pump(WidgetTester tester, Profile p, Brightness b, Widget Function(FemioController) home,
    {NotificationPort? port}) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  final c = FemioController(MemoryStore(p), initialLocale: p.locale, reminders: port, clock: () => _now);
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

  group('plans and marks', () {
    test('the plan and the marks survive JSON and the sealed backup; old records load empty', () async {
      final p = _profile('en', plans: _plans, doses: const [
        DoseMark(entryId: 'm1', day: '2026-11-25', slot: 480, status: DoseStatus.taken, at: '2026-11-25T08:05:00'),
      ]);
      final back = Profile.fromJson(p.toJson());
      expect(back.medicinePlans, _plans);
      expect(back.doses.single.at, '2026-11-25T08:05:00');
      final restored = await decodeBackup(await encodeBackup(p, 'a long enough passphrase'), 'a long enough passphrase');
      expect(restored.medicinePlans, _plans);
      final old = Profile.fromJson({...p.toJson()}..remove('medicinePlans')..remove('doses'));
      expect(old.medicinePlans, isEmpty);
      expect(old.doses, isEmpty);
    });

    test('times are kept sorted, unique, on the clock and at most six; a label is trimmed and cut', () {
      expect(cleanTimes([600, 480, 480, -5, 1440, 1, 2, 3, 4, 5]), [1, 2, 3, 4, 5, 480]);
      expect(cleanLabel('  ${'x' * 60}  ').length, maxMedicineLabelLength);
    });

    test('"later than planned" only past the display threshold, never for a skip', () {
      DoseMark m(String at, [DoseStatus s = DoseStatus.taken]) =>
          DoseMark(entryId: 'm1', day: _today, slot: 480, status: s, at: at);
      expect(m('2026-11-26T09:00:00').later, isFalse, reason: 'exactly an hour is not later');
      expect(m('2026-11-26T09:01:00').later, isTrue);
      expect(m('2026-11-26T11:00:00', DoseStatus.skipped).later, isFalse);
    });

    test('a contraceptive gets no schedule; other medicines do', () {
      expect(scheduleBlocked(_pill), isTrue);
      expect(scheduleBlocked(_med('x', 'Microgynon', fields: const {RecordField.details: 'the pill'})), isTrue);
      expect(scheduleBlocked(_med('x', 'حبوب منع الحمل')), isTrue);
      expect(scheduleBlocked(_folic), isFalse);
      expect(scheduleBlocked(_metformin), isFalse);
    });

    test('current and finished follow her written end day', () {
      final split = medicinesByStatus(_profile('en').record, _today);
      expect([for (final e in split.current) e.id], containsAll(['m1', 'm2', 'm4']));
      expect([for (final e in split.finished) e.id], ['m3']);
      expect(takenOn(_metformin, '2027-01-01'), isFalse);
    });
  });

  group('reminders', () {
    test('one per planned time for a week, with her label, skipping marked doses and past moments', () {
      final p = _profile('en', plans: _plans, doses: const [
        DoseMark(entryId: 'm2', day: _today, slot: 9 * 60, status: DoseStatus.taken, at: '2026-11-26T07:00:00'),
      ]);
      final plan = planReminders(p, now: _now).where((r) => r.kind == ReminderKind.medicine).toList();
      // Folic acid 08:00 x7, metformin 09:00 x6 (today marked) and 21:00 x7.
      expect(plan.length, 7 + 6 + 7);
      expect(plan.first, PlannedReminder(ReminderKind.medicine, DateTime(2026, 11, 26, 8)));
      expect(plan.where((r) => r.label == 'Evening').length, 13);
      expect(plan.any((r) => r.at == DateTime(2026, 11, 26, 9)), isFalse, reason: 'already marked taken');
    });

    test('a refill reminder at 09:00 the day before, with the label', () {
      final plan = planReminders(_profile('en', plans: _plans), now: _now);
      expect(plan.where((r) => r.kind == ReminderKind.refill), [PlannedReminder(ReminderKind.refill, DateTime(2026, 11, 30, 9))]);
    });

    test('nothing without consent, with the switch off, or for a contraceptive', () {
      expect(planReminders(_profile('en', plans: _plans, consent: false), now: _now), isEmpty);
      final off = _profile('en', plans: _plans);
      expect(
        planReminders(off.copyWith(settings: off.settings.copyWith(medicineReminder: false)), now: _now)
            .where((r) => r.kind == ReminderKind.medicine),
        isEmpty,
      );
      final pill = _profile('en', plans: const [MedicinePlan(entryId: 'm4', times: [480], remind: true)]);
      expect(planReminders(pill, now: _now), isEmpty);
    });

    test('no reminder after the written end day', () {
      final p = _profile('en', plans: const [MedicinePlan(entryId: 'm3', times: [480], remind: true)]);
      expect(planReminders(p, now: _now), isEmpty);
    });

    test('the medicine kind is built and can be chosen on the consent screen', () {
      expect(NotificationKind.medicine.available, isTrue);
      expect(NotificationChoice.only(NotificationKind.medicine).medicine, isTrue);
    });
  });

  group('controller', () {
    testWidgets('marking a dose saves it, replaces it, clears it, and refuses a contraceptive', (tester) async {
      final c = FemioController(MemoryStore(_profile('en', plans: _plans)), clock: () => _now);
      await c.load();
      await c.markDose(entryId: 'm1', day: _today, slot: 480, status: DoseStatus.taken);
      expect(c.profile!.doses.single.at, '2026-11-26T07:30:00');
      await c.markDose(entryId: 'm1', day: _today, slot: 480, status: DoseStatus.skipped);
      expect(c.profile!.doses.single.status, DoseStatus.skipped);
      await c.markDose(entryId: 'm1', day: _today, slot: 480);
      expect(c.profile!.doses, isEmpty);
      await c.markDose(entryId: 'm4', day: _today, status: DoseStatus.taken);
      expect(c.profile!.doses, isEmpty);
      await c.markDose(entryId: 'm1', day: _today, status: DoseStatus.taken);
      await c.markDose(entryId: 'm1', day: _today, status: DoseStatus.taken);
      expect(asNeededOn(c.profile!.doses, 'm1', _today).length, 2, reason: 'doses taken when needed add up');
    });

    testWidgets('deleting the medicine removes its plan and marks', (tester) async {
      final c = FemioController(MemoryStore(_profile('en', plans: _plans, doses: const [
        DoseMark(entryId: 'm1', day: _today, slot: 480, status: DoseStatus.taken, at: '2026-11-26T08:00:00'),
      ])), clock: () => _now);
      await c.load();
      await c.deleteRecordEntry('m1');
      expect(c.profile!.medicinePlans.map((m) => m.entryId), ['m2']);
      expect(c.profile!.doses, isEmpty);
    });
  });

  group('screens', () {
    testWidgets('the list marks a dose from its chip', (tester) async {
      final port = _Port();
      final c = await _pump(tester, _profile('en', plans: _plans), Brightness.light,
          (c) => MedicinesScreen(controller: c, today: _today), port: port);
      final l = lookupL10n(const Locale('en'));
      await tester.tap(find.textContaining('Not marked').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.medMarkTaken));
      await tester.pumpAndSettle();
      expect(c.profile!.doses.single.slot, 480);
      expect(find.textContaining('Taken'), findsWidgets);
      expect(port.plans.last.any((r) => r.at == DateTime(2026, 11, 26, 8)), isFalse, reason: 'its reminder is gone');
    });

    testWidgets('a medicine page adds a time and a contraceptive shows no controls', (tester) async {
      final c = await _pump(tester, _profile('en'), Brightness.light,
          (c) => MedicinePage(controller: c, entryId: 'm1', today: _today));
      final l = lookupL10n(const Locale('en'));
      await tester.tap(find.text(l.medAddTime));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(planFor(c.profile!.medicinePlans, 'm1').times, [480]);

      await _pump(tester, _profile('en'), Brightness.light, (c) => MedicinePage(controller: c, entryId: 'm4', today: _today));
      expect(find.text(l.medBlocked), findsOneWidget);
      expect(find.text(l.medAddTime), findsNothing);
      expect(find.text(l.medRemind), findsNothing);
    });
  });

  for (final lang in ['en', 'ar']) {
    for (final b in Brightness.values) {
      testWidgets('medicine shots ($lang ${b.name})', (tester) async {
        final doses = [
          DoseMark(entryId: 'm2', day: _today, slot: 9 * 60, status: DoseStatus.taken, at: '2026-11-26T10:40:00'),
          for (var d = 1; d < 5; d++) ...[
            DoseMark(entryId: 'm2', day: '2026-11-2${6 - d}', slot: 9 * 60, status: DoseStatus.taken, at: '2026-11-2${6 - d}T09:05:00'),
            DoseMark(
              entryId: 'm2',
              day: '2026-11-2${6 - d}',
              slot: 21 * 60,
              status: d == 2 ? DoseStatus.skipped : DoseStatus.taken,
              at: '2026-11-2${6 - d}T21:10:00',
            ),
          ],
        ];
        final p = _profile(lang, plans: _plans, doses: doses);
        await _pump(tester, p, b, (c) => MedicinesScreen(controller: c, today: _today));
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/medicines_${lang}_${b.name}.png'));
        await _pump(tester, p, b, (c) => Scaffold(
              body: SafeArea(
                child: ListView(padding: const EdgeInsets.all(20), children: [MedicinesTodayCard(controller: c, today: _today)]),
              ),
            ));
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/today_card_${lang}_${b.name}.png'));
        await _pump(tester, p, b, (c) => MedicinePage(controller: c, entryId: 'm2', today: _today));
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/medicine_page_${lang}_${b.name}.png'));
        await tester.scrollUntilVisible(find.text(lookupL10n(Locale(lang)).medHistory), 300,
            scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/medicine_history_${lang}_${b.name}.png'));
      });
    }
  }
}
