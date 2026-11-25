/// The kinds of notification femio can offer, and which of them exist yet. Pure: no UI.
///
/// Why it exists: the consent screen and Settings > Reminders must agree on which kinds
/// there are, which are built and which are on, and that decision does not belong in a
/// widget (R12.1). A kind that is not built is listed here so the consent screen can say
/// "coming in an update" honestly instead of showing a switch that does nothing.
library;

import '../data/profile.dart';

/// Every kind of notification on the roadmap, in the order the consent screen lists them.
enum NotificationKind {
  /// A daily nudge to log (R4.4).
  log,

  /// One notification the day before her expected window opens (R4.4).
  period,

  /// A medicine reminder. Not built: it waits for the medicines record (R11.6).
  medicine,

  /// One notification the day before an appointment she saved (R12.1).
  appointment,

  /// A weekly digest. Not built yet.
  digest,
}

/// What the app knows about each [NotificationKind].
extension NotificationKindInfo on NotificationKind {
  /// Whether the app can schedule this kind today. The others are shown as coming later.
  bool get available => switch (this) {
    NotificationKind.log ||
    NotificationKind.period ||
    NotificationKind.appointment => true,
    NotificationKind.medicine || NotificationKind.digest => false,
  };

  /// Whether this kind is switched on in [settings]. A kind that is not built is never on.
  bool isOn(AppSettings settings) => switch (this) {
    NotificationKind.log => settings.logReminder,
    NotificationKind.period => settings.periodReminder,
    NotificationKind.appointment => settings.appointmentReminder,
    NotificationKind.medicine || NotificationKind.digest => false,
  };
}

/// The kinds she ticked on the consent screen. Only built kinds can be ticked.
class NotificationChoice {
  const NotificationChoice({
    this.log = false,
    this.period = false,
    this.appointment = false,
  });

  /// A choice with only [kind] on (what Settings passes when she turns that one switch on).
  /// A kind that is not built gives an empty choice.
  factory NotificationChoice.only(NotificationKind kind) => NotificationChoice(
    log: kind == NotificationKind.log,
    period: kind == NotificationKind.period,
    appointment: kind == NotificationKind.appointment,
  );

  final bool log;
  final bool period;
  final bool appointment;

  /// Whether at least one kind is ticked; consent needs something to consent to.
  bool get any => log || period || appointment;

  /// Whether [kind] is ticked.
  bool has(NotificationKind kind) => switch (kind) {
    NotificationKind.log => log,
    NotificationKind.period => period,
    NotificationKind.appointment => appointment,
    NotificationKind.medicine || NotificationKind.digest => false,
  };

  /// This choice with [kind] set to [on]. A kind that is not built is left alone.
  NotificationChoice toggled(NotificationKind kind, bool on) =>
      NotificationChoice(
        log: kind == NotificationKind.log ? on : log,
        period: kind == NotificationKind.period ? on : period,
        appointment: kind == NotificationKind.appointment ? on : appointment,
      );
}

/// How the consent screen's request ended.
enum NotificationConsentResult {
  /// Permission given, choice saved with today's date, reminders scheduled.
  granted,

  /// The phone refused the permission. Nothing was saved or scheduled.
  permissionDenied,

  /// She ticked nothing, so there was nothing to consent to. Nothing was saved.
  nothingChosen,
}
