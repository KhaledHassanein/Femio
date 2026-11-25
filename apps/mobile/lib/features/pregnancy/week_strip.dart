// The pregnancy weeks on the Calendar tab: every week from 4 to 41, her current one ringed
// (R8.6).
//
// Why it exists: in pregnancy the useful calendar unit is the week, not the period day. The
// strip reads `pregnancyCalendar` (MR-54, the same rows the website's calendar draws), shows
// each week's dates, and opens that week's guide.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../data/library.dart';
import '../../domain/dates.dart';
import '../../domain/pregnancy_calendar.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import 'this_week_card.dart';

/// Width of one week tile: the week number and a two-line date range.
const _tileWidth = 76.0;

/// The strip for the pregnancy due on [edd]. Renders nothing for an invalid date.
class PregnancyWeekStrip extends StatefulWidget {
  const PregnancyWeekStrip({super.key, required this.edd, required this.today, required this.library});
  final String edd;
  final String today;
  final Library library;

  @override
  State<PregnancyWeekStrip> createState() => _PregnancyWeekStripState();
}

class _PregnancyWeekStripState extends State<PregnancyWeekStrip> {
  late final ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    final current = pregnancyCalendar(widget.edd, widget.today)?.currentWeek;
    // Open on her week, with one week of context before it.
    final index = current == null ? 0 : current - firstRowWeek - 1;
    _scroll = ScrollController(initialScrollOffset: (index < 0 ? 0 : index) * (_tileWidth + space2));
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final cal = pregnancyCalendar(widget.edd, widget.today);
    if (cal == null) return const SizedBox.shrink();
    final locale = Localizations.localeOf(context).toLanguageTag();
    String day(String iso) => DateFormat.MMMd(locale).format(fromISO(iso));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Semantics(header: true, child: Text(l.pregWeeksTitle, style: t.titleMedium)),
      const SizedBox(height: space1),
      Text(l.pregWeeksHint, style: t.bodySmall),
      const SizedBox(height: space2),
      SizedBox(
        height: 92,
        child: ListView.separated(
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          itemCount: cal.weeks.length,
          separatorBuilder: (_, _) => const SizedBox(width: space2),
          itemBuilder: (context, i) {
            final row = cal.weeks[i];
            final current = row.week == cal.currentWeek;
            return Semantics(
              button: row.guide != null,
              selected: current,
              label: current ? l.pregWeekCurrentLabel(row.week) : l.weekGuideTitle(row.week),
              excludeSemantics: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(radiusMd),
                onTap: row.guide == null
                    ? null
                    : () => showWeekSheet(context, library: widget.library, week: row.week, current: current),
                child: Container(
                  width: _tileWidth,
                  padding: const EdgeInsets.all(space2),
                  decoration: BoxDecoration(
                    color: current ? p.primarySoft : p.surface,
                    borderRadius: BorderRadius.circular(radiusMd),
                    border: Border.all(color: current ? p.primarySolid : p.border, width: current ? 2 : 1),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('${row.week}', style: t.titleLarge),
                    Text(day(row.start), style: t.labelSmall, maxLines: 1),
                    Text(day(row.end), style: t.labelSmall, maxLines: 1),
                  ]),
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }
}
