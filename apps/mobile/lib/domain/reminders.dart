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
import 'health_record.dart';
import 'medicines.dart';

/// What a planned notification is for. The text is the same neutral line for all, except a
/// medicine or refill reminder she gave her own words (see the scheduler).
enum ReminderKind { log, period, appointment, medicine, refill }

/// One notification to show at a local wall-clock moment.
class PlannedReminder {
  const PlannedReminder(this.kind, this.at, {this.label = ''});
  final ReminderKind kind;

  /// Local date and time, as the phone's clock will read it.
  final DateTime at;

  /// Her own words for this notification (a medicine's label); empty means the neutral text.
  final String label;

  @override
  bool operator ==(Object other) =>
      other is PlannedReminder && other.kind == kind && other.at == at && other.label == label;

  @override
  int get hashCode => Object.hash(kind, at, label);

  @override
  String toString() => '${kind.name}@$at${label.isEmpty ? '' : ' "$label"'}';
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

/// How many days ahead medicine reminders are scheduled. Rebuilt on every open and save, so
/// a mark she makes today removes that dose's reminder at once.
const medicineReminderHorizonDays = 7;

/// At most this many medicine and refill reminders are pending at once, soonest first (with
/// the log reminders this stays far below Android's alarm limits).
const maxMedicineReminders = 150;

/// The refill reminder fires at 09:00 local on the day before her refill day.
const refillReminderMinutes = 9 * 60;

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
///
/// Medicine reminders (R11.6), only when the medicine switch is on: for each medicine whose
/// own reminder is on and that is not a contraceptive ([scheduleBlocked]), one per planned
/// time on each of the next [medicineReminderHorizonDays] days she takes it ([takenOn]),
/// skipping a moment already past and a dose she already marked; plus one 09:00 the day
/// before her refill day. Each carries her label. At most [maxMedicineReminders], soonest first.
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
    final prediction = predictNextPeriod(profile.cycleStarts, profile.cycleLength);
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

  if (settings.medicineReminder) plan.addAll(_medicineReminders(profile, now, today));
  return plan;
}

List<PlannedReminder> _medicineReminders(Profile profile, DateTime now, String today) {
  final out = <PlannedReminder>[];
  for (final entry in profile.record) {
    if (entry.kind != RecordKind.medicine || scheduleBlocked(entry)) continue;
    final plan = planFor(profile.medicinePlans, entry.id);
    if (!plan.remind) continue;
    for (var n = 0; n < medicineReminderHorizonDays; n++) {
      final day = addDays(today, n);
      if (!takenOn(entry, day)) continue;
      for (final slot in slotsOn(plan, profile.doses, day)) {
        final at = _at(day, slot.minutes);
        if (slot.mark == null && at.isAfter(now)) out.add(PlannedReminder(ReminderKind.medicine, at, label: plan.label));
      }
    }
    final refill = plan.refillOn;
    if (refill != null && !finished(entry, today)) {
      final at = _at(addDays(refill, -1), refillReminderMinutes);
      if (at.isAfter(now)) out.add(PlannedReminder(ReminderKind.refill, at, label: plan.label));
    }
  }
  out.sort((a, b) => a.at.compareTo(b.at));
  return out.take(maxMedicineReminders).toList();
}

DateTime _at(String iso, int minutes) {
  final d = fromISO(iso);
  return DateTime(d.year, d.month, d.day, minutes ~/ 60, minutes % 60);
}
