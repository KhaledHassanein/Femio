// A month grid for one medicine: what she marked on each day, and a plain count (R11.6).
//
// Why it exists: the medicine page lists the last 14 days of marks. This grid shows a whole
// month at a glance, with arrows to move between months. Each day says taken, partly,
// not taken or not marked, with a shape as well as a colour so it reads without colour. The
// line under it is a count of her own marks: no score, no streak, no praise (rule 1). The
// day logic is `domain/medicine_month.dart`; this file only draws it.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/dates.dart';
import '../../domain/health_record.dart';
import '../../domain/medicine_month.dart';
import '../../domain/medicines.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';

/// Side of one day in the grid: a comfortable tap-sized square, drawn as a circle.
const double medicineMonthCell = 40;

/// The month grid and its count line for [entry]. Shows the current month first.
class MedicineMonthView extends StatefulWidget {
  const MedicineMonthView({super.key, required this.controller, required this.entry, required this.today});
  final FemioController controller;
  final RecordEntry entry;
  final String today;

  @override
  State<MedicineMonthView> createState() => _MedicineMonthViewState();
}

class _MedicineMonthViewState extends State<MedicineMonthView> {
  late YearMonth _at = () {
    final d = fromISO(widget.today);
    return (year: d.year, month: d.month);
  }();

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
        final bounds = medicineMonthBounds(entry: widget.entry, doses: profile.doses, today: widget.today);
        final at = monthBefore(_at, bounds.first) ? bounds.first : _at;
        final month = medicineMonth(
          entry: widget.entry,
          plan: planFor(profile.medicinePlans, widget.entry.id),
          doses: profile.doses,
          year: at.year,
          month: at.month,
          today: widget.today,
        );
        final canBack = monthBefore(bounds.first, at);
        final canForward = monthBefore(at, bounds.last);
        final firstWeekday = ml.firstDayOfWeekIndex; // 0 = Sunday
        final lead = (DateTime.utc(at.year, at.month).weekday % 7 - firstWeekday + 7) % 7;
        final title = DateFormat.yMMMM(locale).format(DateTime(at.year, at.month));
        final countLine = month.asNeeded
            ? l.medMonthCountAsNeeded(month.takenDays)
            : month.plannedDays == 0
                ? l.medMonthCountNone
                : l.medMonthCount(month.takenDays, month.plannedDays);

        String statusWord(MonthDayStatus s) => switch (s) {
              MonthDayStatus.taken => l.medMonthTaken,
              MonthDayStatus.partly => l.medMonthPartly,
              MonthDayStatus.notTaken => l.medMonthNotTaken,
              MonthDayStatus.notMarked => l.medMonthNotMarked,
              MonthDayStatus.notPlanned || MonthDayStatus.upcoming => '',
            };

        Widget cell(MonthDay d) {
          final n = fromISO(d.day).day;
          final shown = d.status != MonthDayStatus.notPlanned && d.status != MonthDayStatus.upcoming;
          final fill = switch (d.status) {
            MonthDayStatus.taken => p.primarySoft,
            _ => null,
          };
          final edge = switch (d.status) {
            MonthDayStatus.taken || MonthDayStatus.partly => p.primarySolid,
            MonthDayStatus.notTaken => p.borderStrong,
            MonthDayStatus.notMarked => p.border,
            _ => Colors.transparent,
          };
          final glyph = switch (d.status) {
            MonthDayStatus.taken => Icons.check_rounded,
            MonthDayStatus.partly => Icons.contrast_rounded,
            MonthDayStatus.notTaken => Icons.close_rounded,
            _ => null,
          };
          final word = statusWord(d.status);
          final label = DateFormat.MMMMd(locale).format(fromISO(d.day));
          return Semantics(
            label: word.isEmpty ? label : l.medMonthCellSemantics(label, word),
            excludeSemantics: true,
            child: Center(
              child: Container(
                width: medicineMonthCell,
                height: medicineMonthCell,
                decoration: BoxDecoration(
                  color: fill,
                  shape: BoxShape.circle,
                  border: Border.all(color: edge, width: d.day == widget.today ? 2 : 1),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    '$n',
                    style: t.bodySmall?.copyWith(color: shown ? p.text : p.textSubtle, height: 1.1),
                  ),
                  if (glyph != null) Icon(glyph, size: medicineMonthGlyph, color: p.primarySoftText),
                ]),
              ),
            ),
          );
        }

        Widget legend(IconData icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, size: medicineMonthGlyph, color: p.textSubtle),
              const SizedBox(width: space1),
              Text(text, style: t.bodySmall),
            ]);

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            IconButton(
              tooltip: l.medMonthPrevious,
              onPressed: canBack ? () => setState(() => _at = addMonths(at, -1)) : null,
              // Flutter mirrors these two icons in right-to-left on its own.
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Expanded(child: Text(title, textAlign: TextAlign.center, style: t.titleSmall)),
            IconButton(
              tooltip: l.medMonthNext,
              onPressed: canForward ? () => setState(() => _at = addMonths(at, 1)) : null,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ]),
          Row(children: [
            for (var i = 0; i < 7; i++)
              Expanded(
                child: Center(child: Text(ml.narrowWeekdays[(firstWeekday + i) % 7], style: t.bodySmall)),
              ),
          ]),
          const SizedBox(height: space1),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: space1,
            children: [
              for (var i = 0; i < lead; i++) const SizedBox.shrink(),
              for (final d in month.days) cell(d),
            ],
          ),
          const SizedBox(height: space2),
          Wrap(spacing: space3, runSpacing: space1, children: [
            legend(Icons.check_rounded, l.medMonthTaken),
            legend(Icons.contrast_rounded, l.medMonthPartly),
            legend(Icons.close_rounded, l.medMonthNotTaken),
            legend(Icons.circle_outlined, l.medMonthNotMarked),
          ]),
          const SizedBox(height: space2),
          Text(countLine, style: t.bodyMedium),
        ]);
      },
    );
  }
}

/// Size of the small shape under a day number.
const double medicineMonthGlyph = 14;
