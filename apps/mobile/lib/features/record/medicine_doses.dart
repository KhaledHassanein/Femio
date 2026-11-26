// One medicine's doses for a day: a chip per planned time, or "I took one" when she takes it
// when needed (R11.6).
//
// Why it exists: the medicines list, a medicine's page and the Today card all show the same
// row, so marking a dose works the same everywhere. A tap opens a sheet with her choices:
// taken now, taken at another time, not taken, or clear. The words are facts of her own
// marks ("Taken 10:40, later than planned"), never a score, a warning or a catch-up hint.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/dates.dart';
import '../../domain/health_record.dart';
import '../../domain/medicines.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';

/// A dose chip is at least a comfortable tap target tall.
const doseChipMinHeight = 48.0;

/// [minutes] after midnight as her phone's clock writes a time ("8:00 AM", "08:00").
String formatClock(BuildContext context, int minutes) =>
    DateFormat.jm(Localizations.localeOf(context).toLanguageTag())
        .format(DateTime(2000, 1, 1, minutes ~/ 60, minutes % 60));

/// The time part of a mark's moment, as [formatClock] writes it.
String formatMarkTime(BuildContext context, DoseMark mark) {
  final at = DateTime.tryParse(mark.at);
  return at == null ? '' : formatClock(context, at.hour * 60 + at.minute);
}

/// What a mark says: taken (with its time, and "later than planned" when it was) or not taken.
String doseMarkText(BuildContext context, DoseMark mark) {
  final l = L10n.of(context);
  if (mark.status == DoseStatus.skipped) return l.medSkippedAt;
  final time = formatMarkTime(context, mark);
  return mark.later ? l.medTakenLater(time) : l.medTakenAt(time);
}

/// The doses of [entry] on [day]: chips for its planned times, or the when-needed button.
class MedicineDoses extends StatelessWidget {
  const MedicineDoses({super.key, required this.controller, required this.entry, required this.day});
  final FemioController controller;
  final RecordEntry entry;
  final String day;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final profile = controller.profile!;
    final plan = planFor(profile.medicinePlans, entry.id);
    if (plan.times.isEmpty) {
      final taken = asNeededOn(profile.doses, entry.id, day);
      return Wrap(
        spacing: space2,
        runSpacing: space2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          OutlinedButton.icon(
            onPressed: () => controller.markDose(entryId: entry.id, day: day, status: DoseStatus.taken),
            icon: const Icon(Icons.add_task_rounded),
            label: Text(l.medLogDose),
          ),
          for (final m in taken)
            InputChip(
              avatar: const Icon(Icons.check_rounded, size: 18),
              label: Text(doseMarkText(context, m)),
              onDeleted: () => controller.removeDose(m),
              deleteButtonTooltipMessage: l.medMarkClear,
            ),
        ],
      );
    }
    return Wrap(
      spacing: space2,
      runSpacing: space2,
      children: [
        for (final slot in slotsOn(plan, profile.doses, day))
          _SlotChip(
            time: formatClock(context, slot.minutes),
            mark: slot.mark,
            onTap: () => _openSheet(context, slot.minutes, slot.mark),
          ),
      ],
    );
  }

  Future<void> _openSheet(BuildContext context, int slot, DoseMark? mark) async {
    final l = L10n.of(context);
    final choice = await showModalBottomSheet<_Choice>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(space5, 0, space5, space2),
              child: Text(
                l.medDoseTitle(entry.title, formatClock(context, slot)),
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            if (mark != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(space5, 0, space5, space2),
                child: Text(doseMarkText(context, mark), style: Theme.of(ctx).textTheme.bodyMedium),
              ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline_rounded),
              title: Text(l.medMarkTaken),
              onTap: () => Navigator.of(ctx).pop(_Choice.takenNow),
            ),
            ListTile(
              leading: const Icon(Icons.schedule_rounded),
              title: Text(l.medMarkTakenAt),
              onTap: () => Navigator.of(ctx).pop(_Choice.takenAt),
            ),
            ListTile(
              leading: const Icon(Icons.do_not_disturb_on_outlined),
              title: Text(l.medMarkSkipped),
              onTap: () => Navigator.of(ctx).pop(_Choice.skipped),
            ),
            if (mark != null)
              ListTile(
                leading: const Icon(Icons.undo_rounded),
                title: Text(l.medMarkClear),
                onTap: () => Navigator.of(ctx).pop(_Choice.clear),
              ),
            const SizedBox(height: space2),
          ],
        ),
      ),
    );
    if (choice == null || !context.mounted) return;
    switch (choice) {
      case _Choice.takenNow:
        await controller.markDose(entryId: entry.id, day: day, slot: slot, status: DoseStatus.taken);
      case _Choice.takenAt:
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: slot ~/ 60, minute: slot % 60),
          helpText: l.medMarkTakenAt,
        );
        if (picked == null) return;
        final d = fromISO(day);
        await controller.markDose(
          entryId: entry.id,
          day: day,
          slot: slot,
          status: DoseStatus.taken,
          at: DateTime(d.year, d.month, d.day, picked.hour, picked.minute),
        );
      case _Choice.skipped:
        await controller.markDose(entryId: entry.id, day: day, slot: slot, status: DoseStatus.skipped);
      case _Choice.clear:
        await controller.markDose(entryId: entry.id, day: day, slot: slot);
    }
  }
}

enum _Choice { takenNow, takenAt, skipped, clear }

/// One planned time: the time, then what she marked, or "Not marked".
class _SlotChip extends StatelessWidget {
  const _SlotChip({required this.time, required this.mark, required this.onTap});
  final String time;
  final DoseMark? mark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final m = mark;
    final icon = m == null
        ? Icons.radio_button_unchecked_rounded
        : (m.status == DoseStatus.taken ? Icons.check_circle_rounded : Icons.do_not_disturb_on_outlined);
    final status = m == null ? l.medNotMarked : doseMarkText(context, m);
    return Material(
      color: p.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        side: BorderSide(color: p.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(radiusMd),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: doseChipMinHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: space3, vertical: space2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: m?.status == DoseStatus.taken ? p.primary : p.textSubtle),
                const SizedBox(width: space2),
                Flexible(child: Text('$time · $status', style: t.labelLarge)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
