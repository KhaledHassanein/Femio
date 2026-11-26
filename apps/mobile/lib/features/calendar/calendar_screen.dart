// The Calendar tab: one month, what she logged and what Femio estimates.
//
// Why it exists: logged days and predicted days must never look alike (product rule 3), and
// a tap on a day is the quickest way into that day's log.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/cycle_prediction.dart';
import '../../domain/dates.dart';
import '../../domain/day_marks.dart';
import '../../domain/hijri.dart';
import '../../domain/upcoming_periods.dart';
import '../../data/library.dart';
import '../../data/profile.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../theme/type_sizes.dart';
import '../../widgets/dashed_ring.dart';
import '../../widgets/tab_header.dart';
import '../pregnancy/week_strip.dart';
import 'patterns_screen.dart';
import 'prediction_sheets.dart';
import 'upcoming_periods_card.dart';

/// Month calendar. What she logged is drawn filled; what Femio estimates is drawn in
/// outline or tint, never the same way (rule 3). Tapping a day opens its log.
///
/// [today] is an ISO day (future days cannot be opened); [onDay] receives the ISO day
/// she taps. Needs a loaded [controller].
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    required this.controller,
    required this.today,
    required this.onDay,
    this.library,
  });
  final FemioController controller;
  final String today;
  final ValueChanged<String> onDay;

  /// The guides, for the pregnancy week strip's week sheet (R8.6).
  final Library? library;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _month = DateTime.utc(
    fromISO(widget.today).year,
    fromISO(widget.today).month,
  );

  void _shift(int by) =>
      setState(() => _month = DateTime.utc(_month.year, _month.month + by));

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final ml = MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final profile = widget.controller.profile!;
        final first = toISO(_month);
        final daysInMonth = DateTime.utc(_month.year, _month.month + 1, 0).day;
        final last = addDays(first, daysInMonth - 1);
        final marks = dayMarks(
          profile,
          today: widget.today,
          from: first,
          to: last,
        );
        String range(String a, String b) => l.rangeValue(
          DateFormat.MMMd(locale).format(fromISO(a)),
          DateFormat.MMMd(locale).format(fromISO(b)),
        );
        final predicts = profile.goal == Goal.period || profile.goal == Goal.ttc;
        // R8.6/R8.7: in pregnancy the week is the unit; nothing about periods or fertility.
        final pregnant = profile.goal == Goal.pregnant && profile.birthDate == null && profile.edd != null;
        final upcoming = predicts
            ? upcomingPeriods(
                predictNextPeriod(profile.cycleStarts, profile.cycleLength),
              )
            : const <UpcomingPeriod>[];
        final firstWeekday = ml.firstDayOfWeekIndex; // 0 = Sunday
        final lead = (_month.weekday % 7 - firstWeekday + 7) % 7;
        final headers = [
          for (var i = 0; i < 7; i++) ml.narrowWeekdays[(firstWeekday + i) % 7],
        ];
        final showHijri = profile.settings.showHijri;
        final hijriLine = showHijri ? hijriMonthLine(first, last, locale) : '';

        Widget cell(int day) {
          final iso = addDays(first, day - 1);
          final m = marks[iso];
          final isToday = iso == widget.today;
          final future = iso.compareTo(widget.today) > 0;
          Color? fill;
          Color text = future ? p.textSubtle : p.text;
          Border? border;
          var dashed = false;
          if (m?.bleed ?? false) {
            fill = p.logPeriod;
            text = Colors.white;
          } else if (m?.ovulation ?? false) {
            fill = p.successSoft;
            border = Border.all(color: p.successSolid, width: 2);
            text = p.successText;
          } else if (m?.possible ?? false) {
            dashed = true;
          } else if (m?.predicted ?? false) {
            fill = p.predictionBand.withValues(alpha: 0.14);
            border = Border.all(color: p.predictionBand, width: 1.5);
          } else if (m?.fertile ?? false) {
            fill = p.successSoft;
            text = p.successText;
          } else if (m?.spotting ?? false) {
            border = Border.all(color: p.logPeriod, width: 1.5);
          }
          if (isToday && border == null && !dashed) {
            border = Border.all(color: p.primarySolid, width: 2);
          }

          final hijri = showHijri ? hijriDay(iso) : '';
          // Without Hijri the circle fills its square cell; with it, a fixed circle leaves
          // room for the Hijri day beneath.
          final size = hijri.isEmpty ? null : calendarDayDiameter;
          final number = Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: fill,
              shape: BoxShape.circle,
              border: border,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (dashed)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DashedRingPainter(color: p.predictionBand),
                    ),
                  ),
                Text(
                  '$day',
                  style: t.bodyMedium?.copyWith(
                    color: text,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (m?.logged ?? false)
                  Positioned(
                    bottom: 5,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: (m?.bleed ?? false)
                            ? Colors.white
                            : p.logSymptom,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          );
          final label = DateFormat.yMMMMd(locale).format(fromISO(iso));

          // R10.13: a future day explains its estimate; a long press explains any day.
          void explain() => showDaySheet(
                context,
                profile: profile,
                day: iso,
                today: widget.today,
                range: range,
                onLog: widget.onDay,
              );
          return Semantics(
            button: !future || predicts,
            onLongPressHint: l.dayExplainLink,
            label: hijri.isEmpty
                ? label
                : l.calendarDayLabel(label, hijriFullDate(iso, locale)),
            child: InkWell(
              customBorder: hijri.isEmpty ? const CircleBorder() : null,
              borderRadius: hijri.isEmpty
                  ? null
                  : BorderRadius.circular(radiusMd),
              onTap: future ? (predicts ? explain : null) : () => widget.onDay(iso),
              onLongPress: explain,
              child: hijri.isEmpty
                  ? Padding(padding: const EdgeInsets.all(3), child: number)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        number,
                        // Secondary, quiet: 12px in the subtle text colour (spec 2.3).
                        ExcludeSemantics(
                          child: Text(
                            hijri,
                            style: t.labelSmall?.copyWith(
                              fontSize: fontSizeHijriDay,
                              color: p.textSubtle,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        }

        Widget legend(Widget swatch, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            swatch,
            const SizedBox(width: space1h),
            Text(label, style: t.bodySmall),
          ],
        );
        Widget dot(Color fill, {Color? ring}) => Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: ring == null ? null : Border.all(color: ring, width: 1.5),
          ),
        );

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(space5, space4, space5, fabClearance),
            children: [
              TabHeader(title: l.calendarTitle),
              const SizedBox(height: space4),
              if (pregnant) ...[
                PregnancyWeekStrip(edd: profile.edd!, today: widget.today, library: widget.library ?? Library()),
                const SizedBox(height: space5),
              ],
              Container(
                padding: const EdgeInsets.fromLTRB(
                  space3,
                  space2,
                  space3,
                  space4,
                ),
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(radiusLg),
                  border: Border.all(color: p.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _shift(-1),
                          icon: const Icon(Icons.chevron_left_rounded),
                          tooltip: ml.previousMonthTooltip,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat.yMMMM(locale).format(_month),
                                textAlign: TextAlign.center,
                                style: t.titleMedium,
                              ),
                              if (hijriLine.isNotEmpty)
                                Text(
                                  hijriLine,
                                  textAlign: TextAlign.center,
                                  style: t.labelSmall?.copyWith(
                                    fontSize: fontSizeHijriDay,
                                    color: p.textSubtle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _shift(1),
                          icon: const Icon(Icons.chevron_right_rounded),
                          tooltip: ml.nextMonthTooltip,
                        ),
                      ],
                    ),
                    const SizedBox(height: space1),
                    GridView(
                      // Square cells normally; a fixed 52px row when the Hijri day sits
                      // under the number (spec 2.3).
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisExtent: showHijri
                            ? calendarRowHeightWithHijri
                            : null,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        for (final h in headers)
                          Center(child: Text(h, style: t.labelMedium)),
                        for (var i = 0; i < lead; i++) const SizedBox.shrink(),
                        for (var d = 1; d <= daysInMonth; d++) cell(d),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: space4),
              Wrap(
                spacing: space4,
                runSpacing: space2h,
                children: [
                  legend(dot(p.logPeriod), l.legendPeriod),
                  legend(
                    dot(Colors.transparent, ring: p.logPeriod),
                    l.legendSpotting,
                  ),
                  if (predicts) ...[
                  legend(
                    dot(
                      p.predictionBand.withValues(alpha: 0.14),
                      ring: p.predictionBand,
                    ),
                    l.legendPredicted,
                  ),
                  legend(
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CustomPaint(
                        painter: DashedRingPainter(color: p.predictionBand),
                      ),
                    ),
                    l.legendPossible,
                  ),
                  legend(dot(p.successSoft), l.legendFertile),
                  legend(
                    dot(p.successSoft, ring: p.successSolid),
                    l.legendOvulation,
                  ),
                  ],
                  legend(
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: p.logSymptom,
                        shape: BoxShape.circle,
                      ),
                    ),
                    l.legendLogged,
                  ),
                ],
              ),
              if (upcoming.isNotEmpty) ...[
                const SizedBox(height: space4),
                UpcomingPeriodsCard(periods: upcoming, range: range),
                WhyRangeButton(profile: profile, range: range),
              ],
              PatternsButton(controller: widget.controller, today: widget.today),
              const SizedBox(height: space3h),
              // R8.4: only period and TTC modes draw estimates, so only they mention outlines.
              Text(predicts ? l.calendarHint : l.calendarHintNoEstimates, style: t.bodySmall),
            ],
          ),
        );
      },
    );
  }
}
