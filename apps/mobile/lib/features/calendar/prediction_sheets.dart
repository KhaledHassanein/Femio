// The explainers for the calendar's estimates: "Why this range?", "Explain this day" and the
// note after a log moves the next period (R9.6, R10.13).
//
// Why it exists: an estimate she cannot question reads like a verdict (rule 3). These sheets
// only put into words what `domain/prediction_explain.dart` reads from the same rules that
// draw the calendar; nothing here calculates. No AI: every sentence is a fixed, translated
// string with her own numbers in it, so it works with the assistant off (product rule 7).

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../data/profile.dart';
import '../../domain/cycle_prediction.dart';
import '../../domain/dates.dart';
import '../../domain/fertility.dart';
import '../../domain/prediction_explain.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../today/hero_card.dart' show IsoRangeFormatter;

/// The confidence word the calendar uses, for one line in a sheet.
String confidenceLine(L10n l, Confidence c) => switch (c) {
      Confidence.high => l.confidenceHigh,
      Confidence.medium => l.confidenceMedium,
      Confidence.low => l.confidenceLowShort,
    };

/// The sentences of the "Why this range?" sheet, in reading order. Exposed for tests.
List<String> whyRangeLines(L10n l, RangeExplanation e) {
  final pr = e.prediction;
  final ev = pr.evidence;
  final lines = <String>[];
  if (pr.basis == 'stated') {
    lines.add(l.whyRangeStated(l.daysValue(pr.averageLength), l.daysValue(ev.margin)));
  } else {
    lines.add(l.whyRangeCycles(ev.cyclesUsed));
    lines.add(l.whyRangeAverage(l.daysValue(pr.averageLength)));
    lines.add(ev.spread == 0
        ? l.whyRangeSpreadNone(l.daysValue(ev.margin))
        : l.whyRangeSpread(l.daysValue(ev.spread), l.daysValue(ev.margin)));
  }
  if (pr.irregular) lines.add(l.whyRangeIrregular(l.daysValue(irregularSpreadDays)));
  switch ((e.nextLevel, e.cyclesToNextLevel)) {
    case (Confidence.medium, final int n):
      lines.add(l.whyRangeNextMedium(n));
    case (Confidence.high, final int n):
      lines.add(l.whyRangeNextHigh(n));
    default:
      if (pr.confidence == Confidence.medium) {
        lines.add(l.whyRangeHighNeedsSteady(l.daysValue(highConfidenceSpreadDays)));
      }
  }
  switch (e.window) {
    case WindowStatus.shown:
      lines.add(l.whyRangeWindowShown);
    case WindowStatus.irregular:
      lines.add(l.whyRangeWindowIrregular);
    case WindowStatus.learning:
      lines.add(l.whyRangeWindowLearning);
    case WindowStatus.outsideRange:
      lines.add(l.whyRangeWindowOutside(regularCycleMin, regularCycleMax));
    case null:
      break;
  }
  return lines;
}

/// The sentences of the "Explain this day" sheet. Exposed for tests.
List<String> dayLines(L10n l, DayExplanation e, IsoRangeFormatter range) {
  final m = e.mark;
  final lines = <String>[
    if (m.bleed) l.dayFactBleed,
    if (m.spotting) l.dayFactSpotting,
    if (m.logged && !m.bleed) l.dayFactLogged,
  ];
  if (e.period case final u?) {
    lines.add(e.periodIndex == 0 ? l.dayFactNextPeriod(range(u.windowStart, u.windowEnd)) : l.dayFactLaterPeriod(range(u.windowStart, u.windowEnd)));
    lines.add(confidenceLine(l, u.confidence));
  }
  if (e.fertile case final f? when m.fertile) lines.add(l.dayFactFertile(range(f.windowStart, f.windowEnd)));
  if (m.ovulation) lines.add(l.dayFactOvulation);
  if (lines.isEmpty) lines.add(e.future ? l.dayFactNothingFuture : l.dayFactNothingPast);
  if (e.hasEstimate) lines.add(l.predictionNote);
  return lines;
}

/// The words for a moved estimate, or null when nothing moved. Exposed for tests.
String? predictionChangeText(L10n l, PredictionChange? c, IsoRangeFormatter range) {
  if (c == null) return null;
  final after = range(c.after.windowStart, c.after.windowEnd);
  final before = c.before;
  return before == null ? l.predictionNew(after) : l.predictionMoved(after, range(before.windowStart, before.windowEnd));
}

Future<void> _sheet(BuildContext context, String title, List<String> lines, {Widget? action}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      final t = Theme.of(context).textTheme;
      final p = context.palette;
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.8),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(space5, 0, space5, space5),
            children: [
              Semantics(header: true, child: Text(title, style: t.titleLarge)),
              const SizedBox(height: space3),
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: space3),
                  child: Text(line, style: t.bodyMedium?.copyWith(color: p.text)),
                ),
              if (action != null) Align(alignment: AlignmentDirectional.centerStart, child: action),
            ],
          ),
        ),
      );
    },
  );
}

/// Opens "Why this range?" for [profile]. Does nothing when there is no prediction.
Future<void> showWhyRangeSheet(BuildContext context, {required Profile profile, required IsoRangeFormatter range}) async {
  final e = explainRange(profile);
  if (e == null) return;
  final l = L10n.of(context);
  final lines = [
    l.predictionNextPeriod(range(e.prediction.windowStart, e.prediction.windowEnd)),
    confidenceLine(l, e.prediction.confidence),
    ...whyRangeLines(l, e),
    l.predictionNote,
  ];
  await _sheet(context, l.whyRangeTitle, lines);
}

/// Opens "Explain this day" for [day]. [onLog] opens the Log on that day; it is offered only
/// for today and past days.
Future<void> showDaySheet(
  BuildContext context, {
  required Profile profile,
  required String day,
  required String today,
  required IsoRangeFormatter range,
  ValueChanged<String>? onLog,
}) async {
  final l = L10n.of(context);
  final e = explainDay(profile, day: day, today: today);
  final locale = Localizations.localeOf(context).toLanguageTag();
  final title = DateFormat.yMMMMEEEEd(locale).format(fromISO(day));
  final canLog = !e.future && onLog != null;
  await _sheet(
    context,
    title,
    dayLines(l, e, range),
    action: canLog
        ? FilledButton.tonal(
            onPressed: () {
              Navigator.of(context).pop();
              onLog(day);
            },
            child: Text(l.dayLogAction),
          )
        : null,
  );
}

/// The "Why this range?" link under a next-period estimate.
class WhyRangeButton extends StatelessWidget {
  const WhyRangeButton({super.key, required this.profile, required this.range});
  final Profile profile;
  final IsoRangeFormatter range;

  @override
  Widget build(BuildContext context) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          onPressed: () => showWhyRangeSheet(context, profile: profile, range: range),
          icon: const Icon(Icons.help_outline_rounded, size: 18),
          label: Text(L10n.of(context).whyRangeAction),
        ),
      );
}
