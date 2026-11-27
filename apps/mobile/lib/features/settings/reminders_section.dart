// The Reminders block of Settings: two switches and a time.
//
// Why it exists: reminders are an offer, never a score (product rule 2), so they live in
// one quiet place and start off. The first switch she turns on opens the consent screen
// (R12.1), which asks for the phone's notification permission in context, not at install;
// the switches here and the ones on that screen are the same settings. All the scheduling
// logic is in `domain/reminders.dart`; this file only reads and writes her settings.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../data/profile.dart';
import '../../domain/notification_kinds.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import 'notification_consent_screen.dart';

/// Section header, log-reminder switch with its time, period-reminder switch (only for
/// the goals that have a period to expect), and the two honest notes.
class RemindersSection extends StatelessWidget {
  const RemindersSection({super.key, required this.controller, required this.profile});
  final FemioController controller;
  final Profile profile;

  /// Applies a change and, when the phone refused permission, says so in one line.
  Future<void> _apply(BuildContext context, {bool? log, bool? period, bool? appointment, bool? medicine, int? logMinutes}) async {
    final l = L10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (controller.needsNotificationConsent && (log == true || period == true || appointment == true || medicine == true)) {
      // First reminder ever: the consent screen asks, ticks this kind, and does the rest.
      final kind = log == true
          ? NotificationKind.log
          : period == true
              ? NotificationKind.period
              : appointment == true
                  ? NotificationKind.appointment
                  : NotificationKind.medicine;
      await showNotificationConsent(context, controller, initial: kind);
      return;
    }
    final ok = await controller.updateReminders(log: log, period: period, appointment: appointment, medicine: medicine, logMinutes: logMinutes);
    if (!ok) {
      messenger.showSnackBar(SnackBar(
        content: Text(l.reminderPermissionDenied),
        action: SnackBarAction(label: l.notifOpenSettings, onPressed: controller.openNotificationSettings),
      ));
    }
  }

  Future<void> _pickTime(BuildContext context, AppSettings settings) async {
    final current = TimeOfDay(hour: settings.logReminderMinutes ~/ 60, minute: settings.logReminderMinutes % 60);
    final picked = await showTimePicker(context: context, initialTime: current, helpText: L10n.of(context).reminderLogTime);
    if (picked == null || !context.mounted) return;
    await _apply(context, logMinutes: picked.hour * 60 + picked.minute);
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final settings = profile.settings;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final hasPeriod = profile.goal == Goal.period || profile.goal == Goal.ttc;
    final time = DateFormat.jm(locale).format(DateTime(2000, 1, 1, settings.logReminderMinutes ~/ 60, settings.logReminderMinutes % 60));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(space4, space4, space4, space1),
          child: Text(l.settingsReminders, style: t.labelLarge?.copyWith(color: p.textMuted)),
        ),
        SwitchListTile(
          value: settings.logReminder,
          title: Text(l.reminderLog),
          subtitle: Text(l.reminderLogNote),
          onChanged: (on) => _apply(context, log: on),
        ),
        if (settings.logReminder)
          ListTile(
            leading: const Icon(Icons.schedule_rounded),
            title: Text(l.reminderLogTime),
            trailing: Text(time, style: t.titleMedium),
            onTap: () => _pickTime(context, settings),
          ),
        if (hasPeriod)
          SwitchListTile(
            value: settings.periodReminder,
            title: Text(l.reminderPeriod),
            subtitle: Text(l.reminderPeriodNote),
            onChanged: (on) => _apply(context, period: on),
          ),
        SwitchListTile(
          value: settings.appointmentReminder,
          title: Text(l.reminderAppointment),
          subtitle: Text(l.reminderAppointmentNote),
          onChanged: (on) => _apply(context, appointment: on),
        ),
        SwitchListTile(
          value: settings.medicineReminder,
          title: Text(l.notifKindMedicine),
          subtitle: Text(l.reminderMedicineNote),
          onChanged: (on) => _apply(context, medicine: on),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(space4, space2, space4, 0),
          child: Text(l.remindersPrivacyNote, style: t.bodySmall?.copyWith(color: p.textMuted)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(space4, space1, space4, 0),
          child: Text(l.remindersTimingNote, style: t.bodySmall?.copyWith(color: p.textMuted)),
        ),
      ],
    );
  }
}
