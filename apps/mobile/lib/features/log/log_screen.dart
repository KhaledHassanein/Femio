// The Log tab: one day's flow, mood, symptoms, discharge, ovulation test, temperature, note.
//
// Why it exists: logging must take seconds, so every tap saves at once (no save button
// to forget). The chip and the temperature field are widgets under widgets/; this file
// is only the layout and the wiring from a tap to the saved day.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../data/profile.dart';
import '../../domain/dates.dart';
import '../../domain/log_vocabulary.g.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/log_labels.g.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/radii.dart';
import '../../theme/type_sizes.dart';
import '../../widgets/tab_header.dart';
import '../assistant/say_it_sheet.dart';
import 'widgets/log_chip.dart';
import 'widgets/note_field.dart';
import 'widgets/temperature_field.dart';

/// One day's log. Every tap saves (no save button to forget); the vocabulary is the
/// website's, generated (`scripts/mobile/sync-log-vocabulary.mjs`), and every term is
/// available whatever her goal (rule 2).
///
/// [date] is the ISO day being edited and [today] the latest day she may open (no
/// logging the future); [onDateChanged] receives the day when she steps back or forward.
class LogScreen extends StatelessWidget {
  const LogScreen({
    super.key,
    required this.controller,
    required this.today,
    required this.date,
    required this.onDateChanged,
  });
  final FemioController controller;
  final String today;
  final String date;
  final ValueChanged<String> onDateChanged;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final profile = controller.profile!;
        final log =
            profile.logs[date] ?? (profile.periodStarts.contains(date) ? const DayLog(flow: 'medium') : const DayLog());

        void save(DayLog next) => controller.setDayLog(date, next);
        void setFlow(String? flow) => save(log.copyWith(flow: flow));
        void toggle(String key) {
          final terms = [...log.terms];
          terms.contains(key) ? terms.remove(key) : terms.add(key);
          save(log.copyWith(terms: terms));
        }

        Widget section(String title, List<Widget> chips) => Padding(
          padding: const EdgeInsets.only(top: space5h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(header: true, child: Text(title, style: t.titleMedium)),
              const SizedBox(height: space2h),
              Wrap(spacing: space2, runSpacing: space2, children: chips),
            ],
          ),
        );

        Widget termChips(LogDimension d, Color tint, Color ink) => Wrap(
          spacing: space2,
          runSpacing: space2,
          children: [
            for (final term in logTerms.where((x) => x.dimension == d))
              LogChip(
                label: logLabel(l, term.key),
                selected: log.terms.contains(term.key),
                // Elevated terms stay quiet on a shared screen (vocabulary.ts).
                tint: term.elevated ? p.surfaceSunken : tint,
                ink: term.elevated ? p.text : ink,
                onTap: () => toggle(term.key),
              ),
          ],
        );

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(space5, space4, space5, space8),
            children: [
              TabHeader(title: l.logTitle),
              const SizedBox(height: space3),
              Container(
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(radiusPill),
                  border: Border.all(color: p.border),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => onDateChanged(addDays(date, -1)),
                      icon: const Icon(Icons.chevron_left_rounded),
                      tooltip: l.previousDay,
                    ),
                    Expanded(
                      child: Text(
                        date == today
                            ? '${l.navToday} · ${DateFormat.MMMd(locale).format(fromISO(date))}'
                            : DateFormat.MMMMEEEEd(locale).format(fromISO(date)),
                        textAlign: TextAlign.center,
                        style: t.titleMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: date.compareTo(today) >= 0 ? null : () => onDateChanged(addDays(date, 1)),
                      icon: const Icon(Icons.chevron_right_rounded),
                      tooltip: l.nextDay,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: space3),
              // ADR-078: one sentence instead of forty taps, read on the phone.
              OutlinedButton.icon(
                onPressed: () => showSayItSheet(context, controller: controller, date: date),
                icon: const Icon(Icons.auto_awesome_rounded),
                label: Text(l.sayItButton),
              ),
              section(l.sectionPeriod, [
                LogChip(
                  label: l.flowNone,
                  selected: log.flow == null,
                  tint: p.surfaceSunken,
                  ink: p.text,
                  onTap: () => setFlow(null),
                ),
                for (final f in flowLevels)
                  LogChip(
                    label: flowLabel(l, f),
                    selected: log.flow == f,
                    tint: p.logPeriodAlt,
                    ink: p.logPeriod,
                    icon: Icons.water_drop_rounded,
                    onTap: () => setFlow(f),
                  ),
              ]),
              section(l.sectionMood, [termChips(LogDimension.mood, p.logMoodAlt, p.logMood)]),
              section(l.sectionSymptoms, [termChips(LogDimension.symptom, p.logSymptomAlt, p.logSymptom)]),
              section(l.sectionDischarge, [termChips(LogDimension.discharge, p.logDischargeAlt, p.logDischarge)]),
              section(l.sectionOvulationTest, [
                for (final r in opkResults)
                  LogChip(
                    label: opkLabel(l, r),
                    selected: log.opk == r,
                    tint: p.successSoft,
                    ink: p.successText,
                    onTap: () => save(log.copyWith(opk: log.opk == r ? null : r)),
                  ),
              ]),
              section(l.sectionTemperature, [
                TemperatureField(
                  key: ValueKey('bbt-$date'),
                  initial: log.bbt,
                  hint: l.temperatureHint,
                  saveLabel: l.temperatureSave,
                  clearLabel: l.temperatureClear,
                  invalid: l.invalidBbt,
                  onSave: (v) => save(log.copyWith(bbt: v)),
                ),
              ]),
              section(l.sectionMore, [termChips(LogDimension.intercourse, p.surfaceSunken, p.text)]),
              section(l.logNoteSection, [
                NoteField(
                  key: ValueKey('note-$date'),
                  initial: log.note,
                  hint: l.logNoteHint,
                  reassurance: l.logNoteSaved,
                  onSave: (v) => save(log.copyWith(note: v)),
                ),
              ]),
              const SizedBox(height: space6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline_rounded, size: iconSizeInline, color: p.textSubtle),
                  const SizedBox(width: space1h),
                  Flexible(child: Text(l.logSavedNote, style: t.bodySmall)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
