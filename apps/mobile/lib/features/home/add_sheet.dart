// The "+" sheet: log anything or ask femio, one tap from every tab (R8.29).
//
// Why it exists: the owner found logging and the assistant hard to reach (26 Nov 2026).
// The best trackers put one add button in the middle of the bar; this sheet is ours. The
// common things (flow, mood) save with one tap, right here; the AI is two equal choices on
// top, "Ask femio" (a question) and "Log with femio" (say it in her words), with the visit
// summary as a small link; everything else is one more tap into the full Log. Every tap saves at once, as on
// the Log screen, and the assistant doors follow her master switch (product rule 7).

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../data/library.dart';
import '../../data/profile.dart';
import '../../domain/dates.dart';
import '../../domain/log_vocabulary.g.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/log_labels.g.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../theme/type_sizes.dart';
import '../assistant/assistant_pill.dart';
import '../log/widgets/log_chip.dart';
import '../record/record_screen.dart';

/// What the sheet asks the shell to do after it closes.
enum AddChoice { fullLog, record }

/// Opens the sheet for [today]. When she picks "more to log", [onOpenLog] opens the Log
/// tab on today. The assistant doors open after the sheet has closed, so their own
/// sheets and screens stack on the shell, not on this one.
Future<void> showAddSheet(
  BuildContext context, {
  required FemioController controller,
  required String today,
  required VoidCallback onOpenLog,
  Library? library,
}) async {
  final choice = await showModalBottomSheet<Object>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => AddSheet(controller: controller, today: today),
  );
  if (!context.mounted) return;
  if (choice == AddChoice.fullLog) {
    onOpenLog();
  } else if (choice == AddChoice.record) {
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => RecordScreen(controller: controller, today: today),
    ));
  } else if (choice is AssistantDoor) {
    await openAssistantDoor(context, choice, controller: controller, today: today, library: library);
  }
}

/// The sheet's body. Pops an [AssistantDoor] or [AddChoice], or nothing when she only
/// tapped chips (they are already saved). Public for screenshots and tests.
class AddSheet extends StatelessWidget {
  const AddSheet({super.key, required this.controller, required this.today});
  final FemioController controller;
  final String today;

  /// The moods offered here; the rest are one tap away in the full Log.
  static const quickMoods = ['happy', 'calm', 'anxious', 'irritable', 'sad'];

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
        // Read at tap time, not build time: two quick taps before a rebuild must both land.
        DayLog current() {
          final now = controller.profile!;
          return now.logs[today] ?? (now.periodStarts.contains(today) ? const DayLog(flow: 'medium') : const DayLog());
        }

        final log = current();
        final pregnant = profile.goal == Goal.pregnant && profile.birthDate == null;
        final assistantOn = profile.settings.assistantOn;
        void save(DayLog next) => controller.setDayLog(today, next);
        void pop(Object choice) => Navigator.of(context).pop(choice);

        Widget heading(String text) => Padding(
              padding: const EdgeInsets.only(top: space4, bottom: space2),
              child: Semantics(header: true, child: Text(text, style: t.titleSmall)),
            );

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(space5, 0, space5, space4),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(l.addSheetTitle, style: t.titleLarge),
              Text(DateFormat.MMMMEEEEd(locale).format(fromISO(today)),
                  style: t.bodySmall?.copyWith(color: p.textMuted)),
              if (assistantOn) ...[
                const SizedBox(height: space4),
                // Two equal choices: ask a question, or say her day in her own words (ADR-078).
                // Ask offers to save to her record afterwards.
                IntrinsicHeight(
                  child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Expanded(
                      child: _AiChoice(
                        icon: Icons.auto_stories_rounded,
                        title: l.addAsk,
                        hint: l.addAskSub,
                        onTap: () => pop(AssistantDoor.ask),
                      ),
                    ),
                    const SizedBox(width: space2),
                    Expanded(
                      child: _AiChoice(
                        icon: Icons.auto_awesome_rounded,
                        title: l.addLogWithFemio,
                        hint: l.addLogSub,
                        onTap: () => pop(AssistantDoor.sayIt),
                      ),
                    ),
                  ]),
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    onPressed: () => pop(AssistantDoor.visit),
                    icon: const Icon(Icons.event_note_outlined),
                    label: Text(l.addVisit),
                  ),
                ),
              ],
              // In pregnancy bleeding is a warning sign with its own note on the Log screen
              // (R8.7), so it is logged there, not as a one-tap chip.
              if (!pregnant) ...[
                heading(l.sectionPeriod),
                Wrap(spacing: space2, runSpacing: space2, children: [
                  for (final f in flowLevels)
                    LogChip(
                      label: flowLabel(l, f),
                      selected: log.flow == f,
                      tint: p.logPeriodAlt,
                      ink: p.logPeriod,
                      icon: Icons.water_drop_rounded,
                      onTap: () {
                        final now = current();
                        save(now.copyWith(flow: now.flow == f ? null : f));
                      },
                    ),
                ]),
              ],
              heading(l.sectionMood),
              Wrap(spacing: space2, runSpacing: space2, children: [
                for (final key in quickMoods)
                  LogChip(
                    label: logLabel(l, key),
                    selected: log.terms.contains(key),
                    tint: p.logMoodAlt,
                    ink: p.logMood,
                    onTap: () {
                      final now = current();
                      final terms = [...now.terms];
                      terms.contains(key) ? terms.remove(key) : terms.add(key);
                      save(now.copyWith(terms: terms));
                    },
                  ),
              ]),
              const SizedBox(height: space3),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.edit_note_rounded, color: p.primary),
                title: Text(l.addMoreToLog),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => pop(AddChoice.fullLog),
              ),
              // R11.1: her own health file, one tap from every tab.
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.folder_shared_outlined, color: p.primary),
                title: Text(l.addRecord),
                subtitle: Text(l.addRecordSub),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => pop(AddChoice.record),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.lock_outline_rounded, size: iconSizeInline, color: p.textSubtle),
                const SizedBox(width: space1h),
                Flexible(child: Text(l.logSavedNote, style: t.bodySmall)),
              ]),
            ]),
          ),
        );
      },
    );
  }
}

/// One of the two equal AI choices in the sheet: an icon, a title and a one-line hint.
class _AiChoice extends StatelessWidget {
  const _AiChoice({required this.icon, required this.title, required this.hint, required this.onTap});
  final IconData icon;
  final String title;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Material(
      color: p.surfaceSunken,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd), side: BorderSide(color: p.border)),
      child: InkWell(
        borderRadius: BorderRadius.circular(radiusMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(space3),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: p.primary),
            const SizedBox(height: space2),
            Text(title, style: t.titleSmall),
            const SizedBox(height: space1),
            Text(hint, style: t.bodySmall?.copyWith(color: p.textMuted)),
          ]),
        ),
      ),
    );
  }
}
