// The pregnancy calendar: every week's dates, the trimesters, and each week's guide
// (R11.2, MR-53).
//
// Why it exists: "what dates is week 24?" and "when does my third trimester start?"
// are among the questions women in pregnancy apps ask most, and femio already carries
// a reviewed guide for weeks 4 to 40. This screen joins the two without saving
// anything. The dates come from `pregnancyCalendar` in `lib/domain/`; this file draws.

import 'package:flutter/material.dart';

import '../../data/library.dart';
import '../../domain/dates.dart';
import '../../domain/pregnancy.dart';
import '../../domain/pregnancy_calendar.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import '../learn/article_screen.dart';
import '../onboarding/widgets.dart';
import 'tool_widgets.dart';

/// How far a date can sit from today: past 300 days back or ahead, no pregnancy fits.
const _spanDays = 300;

/// Which date she knows.
enum _Anchor { edd, lmp }

/// The pregnancy calendar. [library] opens each week's guide; [today] is injectable
/// for tests and defaults to the device day.
class PregnancyCalendarScreen extends StatefulWidget {
  const PregnancyCalendarScreen({super.key, required this.library, this.today});
  final Library library;
  final String? today;

  @override
  State<PregnancyCalendarScreen> createState() => _PregnancyCalendarScreenState();
}

class _PregnancyCalendarScreenState extends State<PregnancyCalendarScreen> {
  late final String _today = widget.today ?? todayISO();
  _Anchor _anchor = _Anchor.edd;
  String? _date;
  Future<List<Article>>? _articles;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _articles ??= widget.library.articles(Localizations.localeOf(context).languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final p = context.palette;
    final edd = _date == null ? null : (_anchor == _Anchor.edd ? _date : eddFromLmp(_date!));
    final cal = edd == null ? null : pregnancyCalendar(edd, _today);
    final isEdd = _anchor == _Anchor.edd;

    return Scaffold(
      appBar: AppBar(title: Text(l.toolCalTitle)),
      body: FutureBuilder<List<Article>>(
        future: _articles,
        builder: (context, snapshot) {
          final guides = {for (final a in snapshot.data ?? const <Article>[]) a.slug: a};
          return ListView(
            padding: const EdgeInsets.fromLTRB(space5, space2, space5, space8),
            children: [
              Text(l.toolNothingSaved, style: t.bodySmall?.copyWith(color: p.textMuted)),
              const SizedBox(height: space4),
              ToolChoice<_Anchor>(
                label: l.toolCalMethodLabel,
                options: {_Anchor.edd: l.toolCalMethodEdd, _Anchor.lmp: l.toolCalMethodLmp},
                value: _anchor,
                onChanged: (a) => setState(() {
                  _anchor = a;
                  _date = null;
                }),
              ),
              const SizedBox(height: space5),
              Text(isEdd ? l.toolCalPromptEdd : l.toolPromptLmp, style: t.titleSmall),
              const SizedBox(height: space2),
              DateCard(
                key: ValueKey(_anchor),
                first: fromISO(addDays(_today, -_spanDays)),
                last: fromISO(isEdd ? addDays(_today, _spanDays) : _today),
                today: fromISO(_today),
                selected: _date == null ? null : fromISO(_date!),
                onChanged: (d) => setState(() => _date = toISO(d)),
              ),
              if (cal != null) ...[
                const SizedBox(height: space5),
                ToolResult(
                  eyebrow: l.toolCalEyebrow,
                  headline: l.dueDateLabel(toolDate(context, cal.edd)),
                  lines: [
                    l.toolCalTrimesterLine(toolDate(context, cal.secondTrimester), toolDate(context, cal.thirdTrimester)),
                    l.toolTermWindow(toolDate(context, cal.termStart), toolDate(context, cal.termEnd)),
                  ],
                  children: [HijriLine(iso: cal.edd)],
                ),
                for (final trimester in const [1, 2, 3]) ...[
                  const SizedBox(height: space5),
                  Semantics(
                    header: true,
                    child: Text(l.trimesterLabel(trimester), style: t.titleMedium),
                  ),
                  const SizedBox(height: space2),
                  for (final row in cal.weeks.where((w) => w.trimester == trimester))
                    _WeekRow(
                      row: row,
                      current: row.week == cal.currentWeek,
                      guide: row.guide == null ? null : guides[row.guide],
                    ),
                ],
                ToolNote(l.toolEstimateNote),
                ToolNote(l.toolClinicianAdjust),
                const SizedBox(height: space4),
                NoticeCard(tone: NoticeTone.urgent, heading: l.pregRedFlagsHeading, body: l.pregRedFlagsBody),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// One week: its number, its dates, a "this week" badge, and a tap to its guide.
class _WeekRow extends StatelessWidget {
  const _WeekRow({required this.row, required this.current, required this.guide});
  final PregnancyWeekRow row;
  final bool current;
  final Article? guide;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final dates = l.rangeValue(toolDate(context, row.start), toolDate(context, row.end));
    final open = guide == null
        ? null
        : () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ArticleScreen(article: guide!)));
    return Padding(
      padding: const EdgeInsets.only(bottom: space2),
      child: Material(
        color: current ? p.primarySoft : p.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: BorderSide(color: current ? p.primary : p.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(radiusMd),
          onTap: open,
          child: Semantics(
            button: open != null,
            selected: current,
            hint: open == null ? null : l.toolCalReadGuide('${row.week}'),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: space3h, vertical: space2h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(l.toolCalWeek('${row.week}'), style: t.titleSmall),
                          if (current) ...[
                            const SizedBox(width: space2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: space2, vertical: spaceHalf),
                              decoration: BoxDecoration(
                                color: p.primarySolid,
                                borderRadius: BorderRadius.circular(radiusPill),
                              ),
                              child: Text(l.toolCalCurrent, style: t.labelSmall?.copyWith(color: p.onPrimarySolid)),
                            ),
                          ],
                        ]),
                        const SizedBox(height: spaceHalf),
                        Text(dates, style: t.bodySmall?.copyWith(color: p.textMuted)),
                      ],
                    ),
                  ),
                  if (open != null) Icon(Icons.chevron_right_rounded, color: p.textSubtle, textDirection: Directionality.of(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
