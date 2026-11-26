// "My medicines": what she takes now with today's doses, and what she has finished (R11.6).
// Also the small Today card that shows the doses still to mark.
//
// Why it exists: a medicine is an entry of her record, but day to day she needs one place to
// see what she takes, mark a dose and reach each medicine's times, reminder and refill day.
// The entries are added with the record editor, so the medicine itself is written once.

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
import '../../widgets/notice_card.dart';
import 'medicine_doses.dart';
import 'medicine_page.dart';
import 'record_editor.dart';
import 'record_labels.dart';
import 'record_screen.dart' show recordListBottomClearance;

/// Opens "My medicines".
void openMedicines(BuildContext context, FemioController controller, String today) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => MedicinesScreen(controller: controller, today: today),
  ),
);

/// The list. [today] is her ISO day.
class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({super.key, required this.controller, required this.today});
  final FemioController controller;
  final String today;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final split = medicinesByStatus(controller.profile!.record, today);
        return Scaffold(
          appBar: AppBar(title: Text(l.medTitle)),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => RecordEditor(controller: controller, today: today, initialKind: RecordKind.medicine),
              ),
            ),
            icon: const Icon(Icons.add_rounded),
            label: Text(l.medAdd),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(space5, space2, space5, recordListBottomClearance),
            children: [
              Text(l.medIntro, style: t.bodyMedium),
              const SizedBox(height: space4),
              if (split.current.isEmpty && split.finished.isEmpty)
                NoticeCard(tone: NoticeTone.quiet, heading: l.medEmptyHeading, body: l.medEmptyBody),
              if (split.current.isNotEmpty) ...[
                Text(l.medCurrent, style: t.titleSmall),
                const SizedBox(height: space2),
                for (final e in split.current) _MedicineCard(controller: controller, entry: e, today: today),
              ],
              if (split.finished.isNotEmpty) ...[
                const SizedBox(height: space4),
                Text(l.medFinished, style: t.titleSmall),
                const SizedBox(height: space2),
                for (final e in split.finished) _MedicineCard(controller: controller, entry: e, today: today),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// One medicine: name, dose and how often as written, refill day, and today's doses.
class _MedicineCard extends StatelessWidget {
  const _MedicineCard({required this.controller, required this.entry, required this.today});
  final FemioController controller;
  final RecordEntry entry;
  final String today;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final plan = planFor(controller.profile!.medicinePlans, entry.id);
    final summary = recordSummary(entry);
    final ended = entry.fields[RecordField.endedOn];
    final blocked = scheduleBlocked(entry);
    final showDoses = !blocked && !finished(entry, today) && takenOn(entry, today);
    return Padding(
      padding: const EdgeInsets.only(bottom: space2h),
      child: Material(
        color: p.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusOption),
          side: BorderSide(color: p.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(radiusOption),
          onTap: () => openMedicinePage(context, controller, entry.id, today),
          child: Padding(
            padding: const EdgeInsets.all(space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.medication_outlined, color: p.primary),
                    const SizedBox(width: space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.title, style: t.titleMedium),
                          if (summary.isNotEmpty) Text(summary, style: t.bodyMedium),
                          if (finished(entry, today) && ended != null)
                            Text(l.medEnded(DateFormat.yMMMd(locale).format(fromISO(ended))), style: t.bodySmall),
                          if (!finished(entry, today) && plan.refillOn != null && !blocked)
                            Text(
                              l.medRefillSoon(DateFormat.yMMMd(locale).format(fromISO(plan.refillOn!))),
                              style: t.bodySmall,
                            ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: p.textSubtle),
                  ],
                ),
                if (showDoses) ...[
                  const SizedBox(height: space3),
                  MedicineDoses(controller: controller, entry: entry, day: today),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The doses still to mark today, for the Today screen. Draws nothing unless she has a
/// current medicine with set times.
class MedicinesTodayCard extends StatelessWidget {
  const MedicinesTodayCard({super.key, required this.controller, required this.today});
  final FemioController controller;
  final String today;

  @override
  Widget build(BuildContext context) {
    final profile = controller.profile!;
    final due = [
      for (final e in medicinesByStatus(profile.record, today).current)
        if (!scheduleBlocked(e) && takenOn(e, today) && planFor(profile.medicinePlans, e.id).times.isNotEmpty) e,
    ];
    if (due.isEmpty) return const SizedBox.shrink();
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final open = [
      for (final e in due)
        for (final s in slotsOn(planFor(profile.medicinePlans, e.id), profile.doses, today))
          if (s.mark == null) s,
    ].length;
    return Padding(
      padding: const EdgeInsets.only(top: space4),
      child: Material(
        color: p.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusOption),
          side: BorderSide(color: p.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => openMedicines(context, controller, today),
                child: Row(
                  children: [
                    Icon(Icons.medication_outlined, color: p.primary),
                    const SizedBox(width: space2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.medTitle, style: t.titleMedium),
                          Text(l.medTodayCount(open), style: t.bodySmall),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: p.textSubtle),
                  ],
                ),
              ),
              for (final e in due) ...[
                const SizedBox(height: space3),
                Text(e.title, style: t.titleSmall),
                const SizedBox(height: space1),
                MedicineDoses(controller: controller, entry: e, day: today),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
