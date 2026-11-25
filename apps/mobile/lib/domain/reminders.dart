/// Which reminders to schedule, and when. Pure: no plugin, no clock, no UI.
///
/// Why it exists: the schedule is the part of reminders that can be wrong in ways that
/// matter (a nudge after she already logged, a "period soon" message from a guess too
/// loose to mean anything), so it is a plain function that tests can feed any profile and
/// any "now". The notification plugin only carries out the list this returns
/// (`data/reminder_scheduler.dart`).
///
/// Product rules it holds to: reminders are an offer she turns on (rule 2); a period
/// reminder rests on the same prediction the calendar draws and says nothing when the
/// window is not confident (rule 3); there is no "late" message, so a missed window
/// simply produces no further notification.
library;

import '../data/profile.dart';
import 'cycle_prediction.dart';
import 'dates.dart';

/// What a planned notification is for. The text is the same for all (see the scheduler).
enum ReminderKind { log, period, appointment }

/// One notification to show at a local wall-clock moment.
class PlannedReminder {
  const PlannedReminder(this.kind, this.at);
  final ReminderKind kind;

  /// Local date and time, as the phone's clock will read it.
  final DateTime at;

  @override
  bool operator ==(Object other) => other is PlannedReminder && other.kind == kind && other.at == at;

  @override
  int get hashCode => Object.hash(kind, at);

  @override
  String toString() => '${kind.name}@$at';
}

/// How many days ahead daily reminders are scheduled. The plan is rebuilt whenever she
/// opens the app or saves, so a phone she has not opened for this long goes quiet rather
/// than nagging; it also keeps the pending list far below Android's alarm limits.
const logReminderHorizonDays = 30;

/// The period reminder fires at 09:00 local on the day before the window opens.
const periodReminderMinutes = 9 * 60;

/// The appointment reminder fires at 09:00 local on the day before the appointment.
const appointmentReminderMinutes = 9 * 60;

/// At most this many appointment reminders are pending at once (a bound, not a promise
/// about how many appointments she can save).
const maxAppointmentReminders = 20;

/// Notifications to schedule for [profile], from [now] (local time) onward.
///
/// Nothing at all until she has given notification consent (`settings.hasNotificationConsent`,
/// R12.1): a switch alone is not enough, so a record that somehow carries a switch without a
/// consent record schedules nothing.
///
/// Daily log reminder: one per day at `settings.logReminderMinutes` for the next
/// [logReminderHorizonDays] days, skipping a moment already past and skipping today when
/// she has already logged today (the nudge exists to prompt a log).
///
/// Period reminder: one, 09:00 the day before the predicted window starts, only for the
/// period and trying-to-conceive goals, only when the prediction exists and is not
/// irregular, and only if that moment is still ahead. Returns an empty list when both
/// switches are off.
///
/// Appointment reminder: one per saved appointment that has a date, 09:00 the day before,
/// only while that moment and the appointment are still ahead (at most
/// [maxAppointmentReminders], one per moment).
List<PlannedReminder> planReminders(Profile profile, {required DateTime now}) {
  final settings = profile.settings;
  if (!settings.hasNotificationConsent) return const [];
  final today = toISO(now);
  final plan = <PlannedReminder>[];

  if (settings.logReminder) {
    final loggedToday = !(profile.logs[today]?.isEmpty ?? true);
    for (var n = 0; n < logReminderHorizonDays; n++) {
      if (n == 0 && loggedToday) continue;
      final at = _at(addDays(today, n), settings.logReminderMinutes);
      if (at.isAfter(now)) plan.add(PlannedReminder(ReminderKind.log, at));
    }
  }

  if (settings.periodReminder && (profile.goal == Goal.period || profile.goal == Goal.ttc)) {
    final prediction = predictNextPeriod(profile.periodStarts, profile.cycleLength);
    if (prediction != null && !prediction.irregular && !profile.irregular) {
      final at = _at(addDays(prediction.windowStart, -1), periodReminderMinutes);
      if (at.isAfter(now)) plan.add(PlannedReminder(ReminderKind.period, at));
    }
  }

  if (settings.appointmentReminder) {
    final moments = <DateTime>{};
    for (final a in profile.appointments) {
      final when = a.datetime == null ? null : DateTime.tryParse(a.datetime!);
      if (when == null || !when.isAfter(now)) continue;
      final at = _at(addDays(toISO(when), -1), appointmentReminderMinutes);
      if (at.isAfter(now)) moments.add(at);
    }
    final sorted = moments.toList()..sort();
    for (final at in sorted.take(maxAppointmentReminders)) {
      plan.add(PlannedReminder(ReminderKind.appointment, at));
    }
  }
  return plan;
}

DateTime _at(String iso, int minutes) {
  final d = fromISO(iso);
  return DateTime(d.year, d.month, d.day, minutes ~/ 60, minutes % 60);
}
