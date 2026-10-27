// The Calendar tab: one month, what she logged and what Femio estimates.
//
// Why it exists: logged days and predicted days must never look alike (product rule 3), and
// a tap on a day is the quickest way into that day's log.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/dates.dart';
import '../../domain/day_marks.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';

/// Month calendar. What she logged is drawn filled; what Femio estimates is drawn in
/// outline or tint, never the same way (rule 3). Tapping a day opens its log.
///
/// [today] is an ISO day (future days cannot be opened); [onDay] receives the ISO day
/// she taps. Needs a loaded [controller].
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, required this.controller, required this.today, required this.onDay});
  final FemioController controller;
  final String today;
  final ValueChanged<String> onDay;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _month = DateTime.utc(fromISO(widget.today).year, fromISO(widget.today).month);

  void _shift(int by) => setState(() => _month = DateTime.utc(_month.year, _month.month + by));

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
        final marks = dayMarks(profile, today: widget.today, from: first, to: last);
        final firstWeekday = ml.firstDayOfWeekIndex; // 0 = Sunday
        final lead = (_month.weekday % 7 - firstWeekday + 7) % 7;
        final headers = [for (var i = 0; i < 7; i++) ml.narrowWeekdays[(firstWeekday + i) % 7]];

        Widget cell(int day) {
          final iso = addDays(first, day - 1);
          final m = marks[iso];
          final isToday = iso == widget.today;
          final future = iso.compareTo(widget.today) > 0;
          Color? fill;
          Color text = future ? p.textSubtle : p.text;
          Border? border;
          if (m?.bleed ?? false) {
            fill = p.logPeriod;
            text = Colors.white;
          } else if (m?.ovulation ?? false) {
            fill = p.successSoft;
            border = Border.all(color: p.successSolid, width: 2);
            text = p.successText;
          } else if (m?.predicted ?? false) {
            fill = p.predictionBand.withValues(alpha: 0.14);
            border = Border.all(color: p.predictionBand, width: 1.5);
          } else if (m?.fertile ?? false) {
            fill = p.successSoft;
            text = p.successText;
          } else if (m?.spotting ?? false) {
            border = Border.all(color: p.logPeriod, width: 1.5);
          }
          if (isToday && border == null) border = Border.all(color: p.primarySolid, width: 2);

          return Semantics(
            button: !future,
            label: DateFormat.yMMMMd(locale).format(fromISO(iso)),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: future ? null : () => widget.onDay(iso),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(color: fill, shape: BoxShape.circle, border: border),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text('$day',
                          style: t.bodyMedium?.copyWith(
                            color: text,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                          )),
                      if (m?.logged ?? false)
                        Positioned(
                          bottom: 5,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: (m?.bleed ?? false) ? Colors.white : p.logSymptom,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        Widget legend(Widget swatch, String label) => Row(mainAxisSize: MainAxisSize.min, children: [
              swatch,
              const SizedBox(width: space1h),
              Text(label, style: t.bodySmall),
            ]);
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
            padding: const EdgeInsets.fromLTRB(space5, space4, space5, space6),
            children: [
              Semantics(header: true, child: Text(l.calendarTitle, style: t.headlineMedium)),
              const SizedBox(height: space4),
              Container(
                padding: const EdgeInsets.fromLTRB(space3, space2, space3, space4),
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(radiusLg),
                  border: Border.all(color: p.border),
                ),
                child: Column(children: [
                  Row(children: [
                    IconButton(
                      onPressed: () => _shift(-1),
                      icon: const Icon(Icons.chevron_left_rounded),
                      tooltip: ml.previousMonthTooltip,
                    ),
                    Expanded(
                      child: Text(
                        DateFormat.yMMMM(locale).format(_month),
                        textAlign: TextAlign.center,
                        style: t.titleMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _shift(1),
                      icon: const Icon(Icons.chevron_right_rounded),
                      tooltip: ml.nextMonthTooltip,
                    ),
                  ]),
                  const SizedBox(height: space1),
                  GridView.count(
                    crossAxisCount: 7,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (final h in headers)
                        Center(child: Text(h, style: t.labelMedium)),
                      for (var i = 0; i < lead; i++) const SizedBox.shrink(),
                      for (var d = 1; d <= daysInMonth; d++) cell(d),
                    ],
                  ),
                ]),
              ),
              const SizedBox(height: space4),
              Wrap(spacing: space4, runSpacing: space2h, children: [
                legend(dot(p.logPeriod), l.legendPeriod),
                legend(dot(Colors.transparent, ring: p.logPeriod), l.legendSpotting),
                legend(dot(p.predictionBand.withValues(alpha: 0.14), ring: p.predictionBand), l.legendPredicted),
                legend(dot(p.successSoft), l.legendFertile),
                legend(dot(p.successSoft, ring: p.successSolid), l.legendOvulation),
                legend(Container(width: 6, height: 6, decoration: BoxDecoration(color: p.logSymptom, shape: BoxShape.circle)), l.legendLogged),
              ]),
              const SizedBox(height: space3h),
              Text(l.calendarHint, style: t.bodySmall),
            ],
          ),
        );
      },
    );
  }
}
