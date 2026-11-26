// "My patterns": counts of what she logged against her own cycles (R8.5, R10.4).
//
// Why it exists: after a few cycles she wants to see what repeats ("cramps before my period in
// 4 of 5 cycles") without femio telling her what it means. Everything here is a count from
// `domain/patterns.dart`; the screen only lays the counts out and never adds a verdict, a
// cause or a score (rule 1). The thresholds live in the register (MR-58, MR-59).

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../data/profile.dart';
import '../../domain/dates.dart';
import '../../domain/patterns.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/log_labels.g.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import 'signs_by_day_screen.dart';

/// The most terms the "By phase" table lists (the rest stay in her log).
const patternTableRows = 12;

/// Height of one cycle-length bar.
const patternBarHeight = 12.0;

/// Width kept for the date beside each bar.
const patternBarLabelWidth = 72.0;

/// Opens "My patterns". [today] is her ISO day.
void openPatterns(BuildContext context, FemioController controller, String today) => Navigator.of(context).push(
  MaterialPageRoute<void>(builder: (_) => PatternsScreen(controller: controller, today: today)),
);

/// The Calendar's link to [PatternsScreen].
class PatternsButton extends StatelessWidget {
  const PatternsButton({super.key, required this.controller, required this.today});
  final FemioController controller;
  final String today;

  @override
  Widget build(BuildContext context) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          onPressed: () => openPatterns(context, controller, today),
          icon: const Icon(Icons.insights_outlined, size: 18),
          label: Text(L10n.of(context).patOpen),
        ),
      );
}

/// Her patterns. Cycle goals see cycle lengths and phase counts; pregnancy and
/// menopause see how often each term was logged in the last [recentPatternDays] days.
class PatternsScreen extends StatelessWidget {
  const PatternsScreen({super.key, required this.controller, required this.today});
  final FemioController controller;
  final String today;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final profile = controller.profile!;
        final cycleGoal = profile.goal == Goal.period || profile.goal == Goal.ttc;
        return Scaffold(
          appBar: AppBar(title: Text(l.patTitle)),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(space5, space2, space5, space10),
            children: [
              Text(l.patIntro, style: t.bodyMedium),
              const SizedBox(height: space4),
              if (cycleGoal) ..._cycleSections(context, cyclePatterns(profile)) else ..._recent(context, profile),
              const SizedBox(height: space6),
              Text(l.patNoVerdict, style: t.bodySmall),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _cycleSections(BuildContext context, CyclePatterns c) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    return [
      Text(l.patCycleLength, style: t.titleSmall),
      const SizedBox(height: space2),
      if (!c.hasRange)
        Text(l.patNeedCycles(c.cycles.length), style: t.bodyMedium)
      else ...[
        Text(l.patRange(c.cycles.length, c.shortest, c.longest), style: t.titleMedium),
        const SizedBox(height: space3),
        _LengthBars(cycles: c.cycles, longest: c.longest),
        if (c.varies) ...[
          const SizedBox(height: space3),
          NoticeCard(
            tone: NoticeTone.caution,
            icon: Icons.info_outline_rounded,
            heading: l.patVaries,
            body: l.patVariesSource,
          ),
        ],
      ],
      const SizedBox(height: space6),
      Text(l.patNoticed, style: t.titleSmall),
      const SizedBox(height: space2),
      if (!c.hasCounts)
        Text(l.patNeedLogged, style: t.bodyMedium)
      else ...[
        for (final s in c.statements)
          Padding(
            padding: const EdgeInsets.only(bottom: space2),
            child: Text(l.patSeen(logLabel(l, s.term), _phase(l, s.phase), s.seen, s.cycles), style: t.bodyLarge),
          ),
        const SizedBox(height: space4),
        Text(l.patByPhase, style: t.titleSmall),
        const SizedBox(height: space2),
        _PhaseTable(counts: c.counts),
      ],
      if (c.details.isNotEmpty) ...[
        const SizedBox(height: space6),
        Text(l.patEachCycle, style: t.titleSmall),
        const SizedBox(height: space2),
        for (final d in c.details)
          _CycleRow(
            detail: d,
            onTap: () => openSignsByDay(context, controller.profile!, today, day: d.span.start),
          ),
      ],
    ];
  }

  List<Widget> _recent(BuildContext context, Profile profile) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final rows = recentTermDays(profile, today);
    return [
      Text(l.patRecent, style: t.titleSmall),
      const SizedBox(height: space2),
      if (rows.isEmpty) Text(l.patEmpty, style: t.bodyMedium),
      for (final r in rows)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: space1h),
          child: Row(children: [
            Expanded(child: Text(logLabel(l, r.term), style: t.bodyLarge)),
            Text(l.patDays(r.days), style: t.bodyMedium),
          ]),
        ),
    ];
  }
}

String _phase(L10n l, CyclePhase p) => switch (p) {
      CyclePhase.period => l.patPhasePeriod,
      CyclePhase.beforePeriod => l.patPhaseBefore,
    };

/// One bar per complete cycle, oldest first, as long as the cycle (the longest fills the row).
class _LengthBars extends StatelessWidget {
  const _LengthBars({required this.cycles, required this.longest});
  final List<CycleSpan> cycles;
  final int longest;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Column(children: [
      for (final c in cycles)
        MergeSemantics(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: space1),
            child: Row(children: [
              SizedBox(
                width: patternBarLabelWidth,
                child: Text(DateFormat.MMMd(locale).format(fromISO(c.start)), style: t.bodySmall),
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FractionallySizedBox(
                    widthFactor: c.length / longest,
                    child: Container(
                      height: patternBarHeight,
                      decoration: BoxDecoration(color: p.chart1, borderRadius: BorderRadius.circular(radiusPill)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: space2),
              Text(l.patDays(c.length), style: t.bodySmall),
            ]),
          ),
        ),
    ]);
  }
}

/// Each term with "seen of cycles" during the period and in the 5 days before it.
class _PhaseTable extends StatelessWidget {
  const _PhaseTable({required this.counts});
  final List<PhaseCount> counts;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final byTerm = <String, Map<CyclePhase, PhaseCount>>{};
    for (final c in counts) {
      (byTerm[c.term] ??= {})[c.phase] = c;
    }
    final terms = byTerm.keys.take(patternTableRows).toList();
    String cell(String term, CyclePhase phase) {
      final c = byTerm[term]![phase];
      return c == null ? '–' : l.patOf(c.seen, c.cycles);
    }

    Widget row(List<String> cells, TextStyle? style) => Padding(
          padding: const EdgeInsets.symmetric(vertical: space1h),
          child: Row(children: [
            Expanded(flex: 3, child: Text(cells[0], style: style)),
            Expanded(flex: 2, child: Text(cells[1], style: style, textAlign: TextAlign.end)),
            Expanded(flex: 2, child: Text(cells[2], style: style, textAlign: TextAlign.end)),
          ]),
        );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: space4, vertical: space2),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusMd),
        border: Border.all(color: p.border),
      ),
      child: Column(children: [
        row(['', l.patPhasePeriodShort, l.patPhaseBeforeShort], t.labelMedium),
        for (final term in terms)
          row([logLabel(l, term), cell(term, CyclePhase.period), cell(term, CyclePhase.beforePeriod)], t.bodyMedium),
      ]),
    );
  }
}

/// One complete cycle: when it began, its length, and what she logged in it.
class _CycleRow extends StatelessWidget {
  const _CycleRow({required this.detail, required this.onTap});
  final CycleDetail detail;

  /// Opens this cycle in "Signs by cycle day".
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final d = detail;
    return Padding(
      padding: const EdgeInsets.only(bottom: space2),
      child: Material(
        color: p.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd), side: BorderSide(color: p.border)),
        child: InkWell(
          borderRadius: BorderRadius.circular(radiusMd),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(space3),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(
                      child: Text(
                        l.patCycleFrom(DateFormat.yMMMd(locale).format(fromISO(d.span.start))),
                        style: t.titleSmall,
                      ),
                    ),
                    Text(l.patDays(d.span.length), style: t.bodyMedium),
                  ]),
                  const SizedBox(height: space1),
                  Text(l.patDaysLogged(d.daysLogged), style: t.bodySmall),
                  if (d.opkPositiveDays > 0) Text(l.patOpkDays(d.opkPositiveDays), style: t.bodySmall),
                  if (d.temperatures > 0) Text(l.patTemps(d.temperatures), style: t.bodySmall),
                ]),
              ),
              const SizedBox(width: space2),
              Icon(Icons.chevron_right_rounded, color: p.textSubtle),
            ]),
          ),
        ),
      ),
    );
  }
}
