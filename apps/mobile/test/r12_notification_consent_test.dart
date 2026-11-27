// R12.1 notification consent: nothing is scheduled before she has consented, a refused
// phone permission schedules nothing, each kind schedules only itself, old records load,
// and "delete everything" takes the consent with it. The port is a recording fake; the
// plugin needs a phone (not verified here: the real Android 13 prompt). Data is synthetic.

import 'package:femio/app.dart';
import 'package:femio/data/notification_port.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/appointments.dart';
import 'package:femio/domain/notification_kinds.dart';
import 'package:femio/domain/reminders.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 10, 28, 10, 0);

/// Regular cycles (next window 11-16 to 11-20) and three appointments: one ahead, one past,
/// one without a date. Only the one ahead can ever produce a reminder.
Profile _profile({AppSettings settings = const AppSettings()}) => Profile(
      goal: Goal.period,
      locale: 'en',
      periodStarts: const ['2026-07-01', '2026-07-29', '2026-08-26', '2026-09-23', '2026-10-21'],
      cycleLength: 28,
      appointments: const [
        Appointment(id: 'a1', datetime: '2026-11-05T10:30'),
        Appointment(id: 'a2', datetime: '2026-10-20T09:00'),
        Appointment(id: 'a3'),
      ],
      settings: settings,
    );

Set<ReminderKind> _kinds(_FakePort port) => {for (final plan in port.plans) for (final r in plan) r.kind};

Future<(FemioController, _FakePort)> _controller({bool permission = true, Profile? profile}) async {
  final port = _FakePort(permission: permission);
  final c = FemioController(MemoryStore(profile ?? _profile()), reminders: port, clock: () => _now);
  await c.load();
  port.reset();
  return (c, port);
}

void main() {
  group('before consent', () {
    test('a switch without a consent record schedules nothing', () async {
      final p = _profile(settings: const AppSettings(logReminder: true, periodReminder: true, appointmentReminder: true));
      // Built directly (fromJson would read the old switches as a legacy consent).
      expect(p.settings.hasNotificationConsent, isFalse);
      expect(planReminders(p, now: _now), isEmpty);

      final port = _FakePort();
      final c = FemioController(MemoryStore(p), reminders: port, clock: () => _now);
      await c.load();
      expect(port.plans, isEmpty);
    });

    test('turning a switch on without consent is refused and never asks the phone', () async {
      final (c, port) = await _controller();
      expect(c.needsNotificationConsent, isTrue);
      expect(await c.updateReminders(log: true), isFalse);
      expect(port.permissionAsked, 0);
      expect(port.plans, isEmpty);
      expect(c.profile!.settings.logReminder, isFalse);
    });

    test('a fresh record needs consent; no record does not', () async {
      final c = FemioController(MemoryStore());
      await c.load();
      expect(c.needsNotificationConsent, isFalse);
    });
  });

  group('the consent request', () {
    test('refusing the phone permission schedules and saves nothing', () async {
      final (c, port) = await _controller(permission: false);
      final result = await c.grantNotificationConsent(const NotificationChoice(log: true, appointment: true));
      expect(result, NotificationConsentResult.permissionDenied);
      expect(port.permissionAsked, 1);
      expect(port.plans, isEmpty);
      expect(c.profile!.settings.hasNotificationConsent, isFalse);
      expect(c.profile!.settings.logReminder, isFalse);
      expect(c.needsNotificationConsent, isTrue);
    });

    test('ticking nothing is not a consent and does not ask the phone', () async {
      final (c, port) = await _controller();
      expect(await c.grantNotificationConsent(const NotificationChoice()), NotificationConsentResult.nothingChosen);
      expect(port.permissionAsked, 0);
      expect(c.profile!.settings.hasNotificationConsent, isFalse);
    });

    test('granting records the date and the choice, then schedules', () async {
      final (c, port) = await _controller();
      expect(await c.grantNotificationConsent(const NotificationChoice(log: true)), NotificationConsentResult.granted);
      final s = c.profile!.settings;
      expect(s.notificationConsentAt, _now.toIso8601String());
      expect((s.logReminder, s.periodReminder, s.appointmentReminder), (true, false, false));
      expect(port.plans.single.length, logReminderHorizonDays);
      expect(c.needsNotificationConsent, isFalse);
    });

    test('only the ticked kinds are scheduled: log alone', () async {
      final (c, port) = await _controller();
      await c.grantNotificationConsent(const NotificationChoice(log: true));
      expect(_kinds(port), {ReminderKind.log});
    });

    test('only the ticked kinds are scheduled: period alone', () async {
      final (c, port) = await _controller();
      await c.grantNotificationConsent(const NotificationChoice(period: true));
      expect(port.plans.single, [PlannedReminder(ReminderKind.period, DateTime(2026, 11, 15, 9))]);
    });

    test('only the ticked kinds are scheduled: appointment alone, 09:00 the day before, future dated ones only', () async {
      final (c, port) = await _controller();
      await c.grantNotificationConsent(const NotificationChoice(appointment: true));
      expect(port.plans.single, [PlannedReminder(ReminderKind.appointment, DateTime(2026, 11, 4, 9))]);
    });

    test('all three: each kind appears, nothing else', () async {
      final (c, port) = await _controller();
      await c.grantNotificationConsent(const NotificationChoice(log: true, period: true, appointment: true));
      expect(_kinds(port), {ReminderKind.log, ReminderKind.period, ReminderKind.appointment});
    });

    test('after consent, a switch from Settings turns a kind on, and off again cancels it', () async {
      final (c, port) = await _controller();
      await c.grantNotificationConsent(const NotificationChoice(log: true));
      port.reset();
      expect(await c.updateReminders(appointment: true), isTrue);
      expect(port.permissionAsked, 1);
      expect(_kinds(port), {ReminderKind.log, ReminderKind.appointment});

      port.reset();
      expect(await c.updateReminders(log: false, appointment: false), isTrue);
      expect(port.cancelled, 1);
      expect(port.permissionAsked, 0);
    });

    test('an appointment saved after consent is picked up on the next save', () async {
      final (c, port) = await _controller(profile: _profile(settings: const AppSettings()).copyWith(appointments: const []));
      await c.grantNotificationConsent(const NotificationChoice(appointment: true));
      expect(port.plans, isEmpty); // nothing ahead yet, so nothing to schedule
      await c.save(c.profile!.copyWith(appointments: const [Appointment(id: 'n', datetime: '2026-12-02T08:00')]));
      expect(port.plans.single.single.at, DateTime(2026, 12, 1, 9));
    });
  });

  group('kinds', () {
    test('the weekly digest is not built and is never on; the medicine reminder is built (R11.6)', () {
      expect({for (final k in NotificationKind.values) if (!k.available) k}, {NotificationKind.digest});
      const all = AppSettings(logReminder: true, periodReminder: true, appointmentReminder: true, medicineReminder: true);
      expect(NotificationKind.medicine.isOn(all), isTrue);
      expect(NotificationKind.digest.isOn(all), isFalse);
      expect(const NotificationChoice().toggled(NotificationKind.medicine, true).any, isTrue);
      expect(const NotificationChoice().toggled(NotificationKind.digest, true).any, isFalse);
    });
  });

  group('storage', () {
    test('an old record without the new fields loads: not consented, appointment reminder off', () {
      final s = AppSettings.fromJson({'showHijri': true, 'storageNoticeSeen': true});
      expect((s.notificationConsentAt, s.appointmentReminder, s.hasNotificationConsent), (null, false, false));
    });

    test('a record from before R12.1 with a reminder already on keeps working as a consent', () {
      final s = AppSettings.fromJson({'logReminder': true});
      expect(s.logReminder, isTrue);
      expect(s.notificationConsentAt, legacyNotificationConsent);
      expect(planReminders(_profile(settings: s), now: _now), isNotEmpty);
    });

    test('the consent date and the new switch survive a save and load', () {
      const s = AppSettings(notificationConsentAt: '2026-10-28T10:00:00.000', appointmentReminder: true);
      final back = AppSettings.fromJson(s.toJson());
      expect((back.notificationConsentAt, back.appointmentReminder), ('2026-10-28T10:00:00.000', true));
    });

    test('a whole old profile JSON (no new fields) round-trips through Profile', () {
      final json = _profile().toJson();
      (json['settings'] as Map).remove('notificationConsentAt');
      (json['settings'] as Map).remove('appointmentReminder');
      final back = Profile.fromJson(json);
      expect(back.settings.hasNotificationConsent, isFalse);
      expect(back.appointments.length, 3);
    });
  });

  group('delete everything', () {
    test('clears the consent: the next record is asked again, and pending notifications are cancelled', () async {
      final (c, port) = await _controller();
      await c.grantNotificationConsent(const NotificationChoice(log: true));
      port.reset();

      await c.deleteEverything();
      expect(port.cancelled, 1);
      expect(c.profile, isNull);

      await c.save(_profile());
      expect(c.needsNotificationConsent, isTrue);
      expect(c.profile!.settings.logReminder, isFalse);
      expect(port.plans, isEmpty);
    });
  });
}

class _FakePort implements NotificationPort {
  @override
  Future<void> openSettings() async {}
  _FakePort({this.permission = true});
  final bool permission;
  int permissionAsked = 0;
  int cancelled = 0;
  final plans = <List<PlannedReminder>>[];

  void reset() {
    permissionAsked = 0;
    cancelled = 0;
    plans.clear();
  }

  @override
  Future<bool> requestPermission() async {
    permissionAsked++;
    return permission;
  }

  @override
  Future<void> replaceAll(List<PlannedReminder> plan, ReminderTexts texts) async => plans.add(plan);

  @override
  Future<void> cancelAll() async => cancelled++;
}
