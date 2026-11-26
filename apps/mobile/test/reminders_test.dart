// Reminders: the schedule maths (a pure function), the settings that drive it, and the
// controller's promises (ask permission on the way in, reschedule on every save, cancel
// everything on "delete everything"). The notification plugin itself needs a phone; the
// scheduler here is a recording fake, and that gap is listed in the R4.4 ledger line.

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/reminder_scheduler.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/reminders.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Five regular 28-day cycles: the next period is predicted for 2026-11-18, window
/// 11-16 to 11-20, so the period reminder belongs on 2026-11-15 at 09:00.
Profile _regular({AppSettings settings = const AppSettings(), Goal goal = Goal.period, bool irregular = false}) => Profile(
      goal: goal,
      locale: 'en',
      periodStarts: const ['2026-07-01', '2026-07-29', '2026-08-26', '2026-09-23', '2026-10-21'],
      cycleLength: 28,
      irregular: irregular,
      settings: settings,
    );

final _now = DateTime(2026, 10, 28, 10, 0);

/// A consent record, so the plan is allowed to schedule (R12.1 gates everything on it).
const _consented = '2026-10-01T09:00:00.000';

void main() {
  group('planReminders', () {
    test('both off: nothing is scheduled', () {
      expect(planReminders(_regular(), now: _now), isEmpty);
    });

    test('daily reminder: today at the chosen time, then one a day, for 30 days', () {
      final plan = planReminders(_regular(settings: const AppSettings(notificationConsentAt: _consented, logReminder: true)), now: _now);
      expect(plan.length, logReminderHorizonDays);
      expect(plan.first, PlannedReminder(ReminderKind.log, DateTime(2026, 10, 28, 20, 0)));
      expect(plan.last.at, DateTime(2026, 11, 26, 20, 0));
      expect(plan.every((r) => r.kind == ReminderKind.log), isTrue);
    });

    test('a moment already past is skipped: after 20:00 the first one is tomorrow', () {
      final plan = planReminders(_regular(settings: const AppSettings(notificationConsentAt: _consented, logReminder: true)), now: DateTime(2026, 10, 28, 21, 15));
      expect(plan.first.at, DateTime(2026, 10, 29, 20, 0));
      expect(plan.length, logReminderHorizonDays - 1);
    });

    test('she picks the time: 07:30 has passed today, so the first is tomorrow morning', () {
      final plan = planReminders(_regular(settings: const AppSettings(notificationConsentAt: _consented, logReminder: true, logReminderMinutes: 7 * 60 + 30)), now: _now);
      expect(plan.first.at, DateTime(2026, 10, 29, 7, 30));
    });

    test('today is skipped once she has logged today', () {
      final p = _regular(settings: const AppSettings(notificationConsentAt: _consented, logReminder: true)).withDayLog('2026-10-28', const DayLog(terms: ['cramps']));
      expect(planReminders(p, now: _now).first.at, DateTime(2026, 10, 29, 20, 0));
    });

    test('a log from another day does not suppress today', () {
      final p = _regular(settings: const AppSettings(notificationConsentAt: _consented, logReminder: true)).withDayLog('2026-10-27', const DayLog(terms: ['cramps']));
      expect(planReminders(p, now: _now).first.at, DateTime(2026, 10, 28, 20, 0));
    });

    test('period reminder: one, 09:00 the day before the predicted window opens', () {
      final plan = planReminders(_regular(settings: const AppSettings(notificationConsentAt: _consented, periodReminder: true)), now: _now);
      expect(plan, [PlannedReminder(ReminderKind.period, DateTime(2026, 11, 15, 9, 0))]);
    });

    test('the same works when trying to conceive', () {
      final plan = planReminders(_regular(goal: Goal.ttc, settings: const AppSettings(notificationConsentAt: _consented, periodReminder: true)), now: _now);
      expect(plan.single.at, DateTime(2026, 11, 15, 9, 0));
    });

    test('no period reminder when she is pregnant or in menopause', () {
      for (final goal in [Goal.pregnant, Goal.menopause]) {
        expect(planReminders(_regular(goal: goal, settings: const AppSettings(notificationConsentAt: _consented, periodReminder: true)), now: _now), isEmpty);
      }
    });

    test('no period reminder when she said her cycles are irregular', () {
      expect(planReminders(_regular(irregular: true, settings: const AppSettings(notificationConsentAt: _consented, periodReminder: true)), now: _now), isEmpty);
    });

    test('no period reminder when logged cycles vary too much to give a confident window', () {
      final wild = Profile(
        goal: Goal.period,
        locale: 'en',
        periodStarts: const ['2026-05-01', '2026-05-25', '2026-07-10', '2026-08-02', '2026-09-30'],
        settings: const AppSettings(notificationConsentAt: _consented, periodReminder: true),
      );
      expect(planReminders(wild, now: _now), isEmpty);
    });

    test('no period reminder with no prediction at all, and none once its moment has passed', () {
      final none = Profile(goal: Goal.period, locale: 'en', settings: const AppSettings(notificationConsentAt: _consented, periodReminder: true));
      expect(planReminders(none, now: _now), isEmpty);
      expect(planReminders(_regular(settings: const AppSettings(notificationConsentAt: _consented, periodReminder: true)), now: DateTime(2026, 11, 15, 9, 30)), isEmpty);
    });

    test('both switches on: the daily ones plus the one period reminder', () {
      final plan = planReminders(_regular(settings: const AppSettings(notificationConsentAt: _consented, logReminder: true, periodReminder: true)), now: _now);
      expect(plan.where((r) => r.kind == ReminderKind.period).length, 1);
      expect(plan.length, logReminderHorizonDays + 1);
    });
  });

  group('settings', () {
    test('an older record has no reminder fields: both off, 20:00', () {
      final s = AppSettings.fromJson({'showHijri': true, 'storageNoticeSeen': true});
      expect((s.logReminder, s.periodReminder, s.logReminderMinutes), (false, false, defaultLogReminderMinutes));
    });

    test('reminder settings survive a save and load', () {
      const s = AppSettings(notificationConsentAt: _consented, logReminder: true, logReminderMinutes: 450, periodReminder: true);
      final back = AppSettings.fromJson(s.toJson());
      expect((back.logReminder, back.logReminderMinutes, back.periodReminder), (true, 450, true));
    });

    test('a time outside the clock falls back to the default', () {
      expect(AppSettings.fromJson({'logReminderMinutes': 5000}).logReminderMinutes, defaultLogReminderMinutes);
      expect(AppSettings.fromJson({'logReminderMinutes': -3}).logReminderMinutes, defaultLogReminderMinutes);
    });

    // Reminders added no schema version: absent means off. v3 is ADR-082's record.
    test('reminders need no schema bump of their own', () {
      expect(_regular().toJson()['v'], 3);
    });
  });

  group('wording', () {
    test('the reminder carries no health word in any language', () {
      for (final code in supportedLanguages) {
        final l = lookupL10n(Locale(code));
        expect(l.reminderTitle, 'femio');
        final text = '${l.reminderTitle} ${l.reminderBody} ${l.reminderChannelName}'.toLowerCase();
        for (final banned in ['period', 'cycle', 'fertil', 'pregnan', 'règle', 'cycl', 'regla', 'دورة', 'خصوب', 'حمل', 'ovul']) {
          expect(text.contains(banned), isFalse, reason: '$code reminder mentions "$banned"');
        }
      }
      expect(lookupL10n(const Locale('ar')).reminderBody, 'افتحي التطبيق');
      expect(lookupL10n(const Locale('en')).reminderBody, 'Open the app');
    });
  });

  group('FemioController', () {
    test('turning a reminder on asks for permission; a refusal changes nothing', () async {
      final fake = _Recorder(permission: false);
      final c = FemioController(MemoryStore(_regular(settings: const AppSettings(notificationConsentAt: _consented))), reminders: fake, clock: () => _now);
      await c.load();
      fake.reset();

      expect(await c.updateReminders(log: true), isFalse);
      expect(c.profile!.settings.logReminder, isFalse);
      expect(fake.permissionAsked, 1);
      expect(fake.plans, isEmpty);
    });

    test('granted: saves the switch and schedules the plan in her language', () async {
      final fake = _Recorder();
      final c = FemioController(MemoryStore(_regular(settings: const AppSettings(notificationConsentAt: _consented))), reminders: fake, clock: () => _now);
      await c.load();
      fake.reset();

      expect(await c.updateReminders(log: true), isTrue);
      expect(c.profile!.settings.logReminder, isTrue);
      expect(fake.plans.single.length, logReminderHorizonDays);
      expect(fake.texts.single.body, 'Open the app');
    });

    test('turning one off needs no permission and cancels', () async {
      final fake = _Recorder();
      final c = FemioController(MemoryStore(_regular(settings: const AppSettings(notificationConsentAt: _consented, logReminder: true))), reminders: fake, clock: () => _now);
      await c.load();
      fake.reset();

      expect(await c.updateReminders(log: false), isTrue);
      expect(fake.permissionAsked, 0);
      expect(fake.cancelled, 1);
    });

    test('moving the time reschedules without asking again', () async {
      final fake = _Recorder();
      final c = FemioController(MemoryStore(_regular(settings: const AppSettings(notificationConsentAt: _consented, logReminder: true))), reminders: fake, clock: () => _now);
      await c.load();
      fake.reset();

      await c.updateReminders(logMinutes: 8 * 60);
      expect(fake.permissionAsked, 0);
      expect(fake.plans.single.first.at, DateTime(2026, 10, 29, 8, 0));
    });

    test('a save that leaves the plan unchanged does not reschedule', () async {
      final fake = _Recorder();
      final c = FemioController(MemoryStore(_regular(settings: const AppSettings(notificationConsentAt: _consented, logReminder: true))), reminders: fake, clock: () => _now);
      await c.load();
      fake.reset();

      await c.setSettings(c.profile!.settings.copyWith(showHijri: true)); // not a reminder setting
      expect(fake.plans, isEmpty);
    });

    test('logging today rebuilds the plan: today is no longer nudged', () async {
      final fake = _Recorder();
      final c = FemioController(MemoryStore(_regular(settings: const AppSettings(notificationConsentAt: _consented, logReminder: true))), reminders: fake, clock: () => _now);
      await c.load();
      fake.reset();

      await c.setDayLog('2026-10-28', const DayLog(terms: ['cramps']));
      expect(fake.plans.single.first.at, DateTime(2026, 10, 29, 20, 0));
    });

    test('delete everything cancels every pending reminder', () async {
      final fake = _Recorder();
      final c = FemioController(MemoryStore(_regular(settings: const AppSettings(notificationConsentAt: _consented, logReminder: true))), reminders: fake, clock: () => _now);
      await c.load();
      fake.reset();

      await c.deleteEverything();
      expect(fake.cancelled, 1);
    });

    test('a failing notification system never costs her the save', () async {
      final fake = _Recorder(throwOnSchedule: true);
      final store = MemoryStore(_regular());
      final c = FemioController(store, reminders: fake, clock: () => _now);
      await c.load();

      await c.save(c.profile!.copyWith(settings: const AppSettings(notificationConsentAt: _consented, logReminder: true)));
      expect(c.profile!.settings.logReminder, isTrue);
      expect((await store.load() as Loaded).profile.settings.logReminder, isTrue);
    });
  });
}

class _Recorder implements ReminderScheduler {
  _Recorder({this.permission = true, this.throwOnSchedule = false});
  final bool permission;
  final bool throwOnSchedule;
  int permissionAsked = 0;
  int cancelled = 0;
  final plans = <List<PlannedReminder>>[];
  final texts = <ReminderTexts>[];

  void reset() {
    permissionAsked = 0;
    cancelled = 0;
    plans.clear();
    texts.clear();
  }

  @override
  Future<bool> requestPermission() async {
    permissionAsked++;
    return permission;
  }

  @override
  Future<void> replaceAll(List<PlannedReminder> plan, ReminderTexts t) async {
    if (throwOnSchedule) throw StateError('plugin unavailable');
    plans.add(plan);
    texts.add(t);
  }

  @override
  Future<void> cancelAll() async => cancelled++;
}
