// One medicine's page: what she wrote, today's doses, her times, the reminder with its words,
// the refill day, and the last 14 days of marks (R11.6).
//
// Why it exists: the times and the reminder are hers to set, next to the medicine they belong
// to. femio suggests no time, dose or catch-up (rule 1), and a contraceptive gets no
// schedule at all: the page says so instead of showing the controls.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/bidi_text.dart';
import '../../domain/dates.dart';
import '../../domain/health_record.dart';
import '../../domain/medicines.dart';
import '../../domain/notification_kinds.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import '../settings/notification_consent_screen.dart';
import 'medicine_doses.dart';
import 'record_editor.dart';
import 'record_labels.dart';

/// How far ahead a refill day may be set.
const refillHorizonDays = 2 * 365;

/// How long the reminder words wait after her last keystroke before they are saved.
const _labelSaveDelay = Duration(milliseconds: 600);

/// Opens the page for medicine entry [entryId].
void openMedicinePage(BuildContext context, FemioController controller, String entryId, String today) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MedicinePage(controller: controller, entryId: entryId, today: today),
      ),
    );

/// The page. Closes itself if the entry is deleted while it is open.
class MedicinePage extends StatefulWidget {
  const MedicinePage({super.key, required this.controller, required this.entryId, required this.today});
  final FemioController controller;
  final String entryId;
  final String today;

  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  late final _label = TextEditingController(text: _plan.label);
  Timer? _labelTimer;

  MedicinePlan get _plan => planFor(widget.controller.profile!.medicinePlans, widget.entryId);

  Future<void> _setPlan(MedicinePlan plan) => widget.controller.setMedicinePlan(plan);

  @override
  void dispose() {
    if (_labelTimer?.isActive ?? false) {
      _labelTimer!.cancel();
      unawaited(_saveLabel());
    }
    _label.dispose();
    super.dispose();
  }

  Future<void> _saveLabel() async {
    if (widget.controller.profile == null) return;
    final plan = _plan;
    if (cleanLabel(_label.text) != plan.label) await _setPlan(plan.copyWith(label: _label.text));
  }

  Future<void> _addTime() async {
    final l = L10n.of(context);
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
      helpText: l.medAddTime,
    );
    if (picked == null) return;
    final plan = _plan;
    await _setPlan(plan.copyWith(times: [...plan.times, picked.hour * 60 + picked.minute]));
  }

  /// Turns this medicine's reminder on or off. On needs consent (the consent screen, with the
  /// medicine kind ticked) and the medicine switch in Settings (turned on here too).
  Future<void> _setRemind(bool on) async {
    final l = L10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final c = widget.controller;
    if (on) {
      if (c.needsNotificationConsent) {
        if (!await showNotificationConsent(context, c, initial: NotificationKind.medicine)) return;
      } else if (!c.profile!.settings.medicineReminder) {
        if (!await c.updateReminders(medicine: true)) {
          messenger.showSnackBar(SnackBar(
            content: Text(l.reminderPermissionDenied),
            action: SnackBarAction(label: l.notifOpenSettings, onPressed: c.openNotificationSettings),
          ));
          return;
        }
      }
    }
    await _setPlan(_plan.copyWith(remind: on));
  }

  Future<void> _pickRefill() async {
    final plan = _plan;
    final today = fromISO(widget.today);
    final initial = plan.refillOn == null ? today : fromISO(plan.refillOn!);
    final date = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(today) ? today : initial,
      firstDate: today,
      lastDate: today.add(const Duration(days: refillHorizonDays)),
      helpText: L10n.of(context).medRefill,
    );
    if (date != null) await _setPlan(plan.copyWith(refillOn: toISO(date)));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final profile = widget.controller.profile;
        final entry = profile?.record.where((e) => e.id == widget.entryId).firstOrNull;
        if (entry == null) return const Scaffold();
        return _page(context, entry);
      },
    );
  }

  Widget _page(BuildContext context, RecordEntry entry) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    String day(String iso) => DateFormat.yMMMd(locale).format(fromISO(iso));
    final plan = _plan;
    final blocked = scheduleBlocked(entry);
    final current = !finished(entry, widget.today);
    final started = entry.fields[RecordField.startedOn];
    final ended = entry.fields[RecordField.endedOn];
    final marks = history(widget.controller.profile!.doses, entry.id, widget.today);
    Widget heading(String text) => Padding(
      padding: const EdgeInsets.only(top: space5, bottom: space2),
      child: Text(text, style: t.titleSmall),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title),
        actions: [
          IconButton(
            tooltip: l.medEdit,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => RecordEditor(
                  controller: widget.controller,
                  today: widget.today,
                  initialKind: RecordKind.medicine,
                  existing: entry,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(space5, space2, space5, space8),
        children: [
          for (final k in [RecordField.dose, RecordField.frequency, RecordField.prescriber])
            if (entry.fields[k] case final v?) Text('${recordFieldLabel(l, k)}: ${isolateText(v)}', style: t.bodyLarge),
          if (started != null) Text(l.medSince(day(started)), style: t.bodyMedium),
          if (ended != null) Text(current ? l.medUntil(day(ended)) : l.medEnded(day(ended)), style: t.bodyMedium),
          if (blocked) ...[
            const SizedBox(height: space4),
            NoticeCard(tone: NoticeTone.quiet, heading: l.medTitle, body: l.medBlocked),
          ] else ...[
            if (current && takenOn(entry, widget.today)) ...[
              heading(l.medToday),
              MedicineDoses(controller: widget.controller, entry: entry, day: widget.today),
            ],
            heading(l.medTimes),
            if (plan.times.isEmpty) Text(l.medTimesNone, style: t.bodySmall),
            Wrap(
              spacing: space2,
              runSpacing: space2,
              children: [
                for (final m in plan.times)
                  InputChip(
                    avatar: const Icon(Icons.schedule_rounded, size: 18),
                    label: Text(formatClock(context, m)),
                    onDeleted: () => _setPlan(
                      plan.copyWith(
                        times: [
                          for (final x in plan.times)
                            if (x != m) x,
                        ],
                      ),
                    ),
                    deleteButtonTooltipMessage: l.medRemoveTime(formatClock(context, m)),
                  ),
                if (plan.times.length < maxMedicineTimes)
                  ActionChip(
                    avatar: const Icon(Icons.add_rounded, size: 18),
                    label: Text(l.medAddTime),
                    onPressed: _addTime,
                  ),
              ],
            ),
            if (current) ...[
              const SizedBox(height: space3),
              Material(
                color: p.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radiusMd),
                  side: BorderSide(color: p.border),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: plan.remind,
                      title: Text(l.medRemind),
                      subtitle: Text(l.medRemindNote),
                      onChanged: plan.times.isEmpty && plan.refillOn == null ? null : _setRemind,
                    ),
                    if (plan.remind)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(space4, 0, space4, space3),
                        child: TextField(
                          controller: _label,
                          maxLength: maxMedicineLabelLength,
                          decoration: InputDecoration(
                            labelText: l.medLabel,
                            helperText: l.medLabelNote,
                            helperMaxLines: 3,
                          ),
                          onChanged: (_) {
                            _labelTimer?.cancel();
                            _labelTimer = Timer(_labelSaveDelay, _saveLabel);
                          },
                        ),
                      ),
                  ],
                ),
              ),
              heading(l.medRefill),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickRefill,
                      icon: const Icon(Icons.event_outlined),
                      label: Text(plan.refillOn == null ? l.medRefillNone : day(plan.refillOn!)),
                    ),
                  ),
                  if (plan.refillOn != null)
                    IconButton(
                      tooltip: l.medRefillClear,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => _setPlan(plan.copyWith(clearRefill: true)),
                    ),
                ],
              ),
            ],
            heading(l.medHistory),
            if (marks.isEmpty)
              Text(l.medHistoryEmpty, style: t.bodySmall)
            else
              for (final m in marks)
                Padding(
                  padding: const EdgeInsets.only(bottom: space1h),
                  child: Text(
                    [
                      day(m.day),
                      if (m.slot != null) formatClock(context, m.slot!) else l.medAsNeeded,
                      doseMarkText(context, m),
                    ].join(' · '),
                    style: t.bodyMedium,
                  ),
                ),
          ],
          const SizedBox(height: space5),
          Text(l.medNoAdviceNote, style: t.bodySmall?.copyWith(color: p.textMuted)),
        ],
      ),
    );
  }
}
