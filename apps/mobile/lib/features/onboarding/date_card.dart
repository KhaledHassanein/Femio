// A month calendar for the onboarding date questions (last period, due date, and so on).
//
// Why it exists: Material's own date picker draws its day cells narrower than the 48dp
// Android touch-target floor on a 360-390dp phone, and gives a screen reader no say in
// what a day is called. This one is a plain seven-column grid whose cells are 48dp tall
// and, with the page's narrow side padding, 48dp wide; every day reads its full date.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../domain/dates.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';

/// Height of one day cell: the Android touch-target floor.
const double _cellExtent = 48;

/// Diameter of the circle drawn inside a day cell.
const double _dayCircle = 40;

/// A month calendar in a card. Nothing is selected until she taps a day.
///
/// Days from [first] to [last] can be picked; other days are shown but cannot be tapped.
/// [today], when given, is marked and is where the calendar opens (else it opens on the
/// selected day, else on [first]'s month). [onChanged] receives the day she taps.
class DateCard extends StatefulWidget {
  const DateCard({
    super.key,
    required this.first,
    required this.last,
    required this.selected,
    required this.onChanged,
    this.today,
  });

  final DateTime first;
  final DateTime last;
  final DateTime? selected;
  final DateTime? today;
  final ValueChanged<DateTime> onChanged;

  @override
  State<DateCard> createState() => _DateCardState();
}

class _DateCardState extends State<DateCard> {
  late DateTime _month = _initialMonth();

  DateTime _initialMonth() {
    final today = widget.today;
    final inRange = today != null && !today.isBefore(widget.first) && !today.isAfter(widget.last);
    final d = widget.selected ?? (inRange ? today : widget.first);
    return DateTime.utc(d.year, d.month);
  }

  bool get _canGoBack => _month.isAfter(DateTime.utc(widget.first.year, widget.first.month));
  bool get _canGoForward => _month.isBefore(DateTime.utc(widget.last.year, widget.last.month));

  void _shift(int by) => setState(() => _month = DateTime.utc(_month.year, _month.month + by));

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final ml = MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final firstWeekday = ml.firstDayOfWeekIndex; // 0 = Sunday
    final lead = (_month.weekday % 7 - firstWeekday + 7) % 7;
    final daysInMonth = DateTime.utc(_month.year, _month.month + 1, 0).day;
    final firstIso = toISO(widget.first);
    final lastIso = toISO(widget.last);
    final selectedIso = widget.selected == null ? null : toISO(widget.selected!);
    final todayIso = widget.today == null ? null : toISO(widget.today!);

    Widget day(int d) {
      final date = DateTime.utc(_month.year, _month.month, d);
      final iso = toISO(date);
      final enabled = iso.compareTo(firstIso) >= 0 && iso.compareTo(lastIso) <= 0;
      final selected = iso == selectedIso;
      final isToday = iso == todayIso;
      final full = DateFormat.yMMMMEEEEd(locale).format(date);
      return Semantics(
        button: true,
        enabled: enabled,
        selected: selected,
        excludeSemantics: true,
        label: isToday ? l.calendarDayStates(full, l.calendarStateToday) : full,
        onTap: enabled ? () => widget.onChanged(date) : null,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? () => widget.onChanged(date) : null,
          child: Center(
            child: Container(
              width: _dayCircle,
              height: _dayCircle,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? p.primarySolid : null,
                border: isToday && !selected ? Border.all(color: p.primarySolid, width: 2) : null,
              ),
              child: Text(
                '$d',
                style: t.bodyLarge?.copyWith(
                  color: selected ? p.onPrimarySolid : (enabled ? p.text : p.textMuted),
                  fontWeight: selected || isToday ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: space2, bottom: space3),
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
                onPressed: _canGoBack ? () => _shift(-1) : null,
                icon: Icon(rtl ? Icons.chevron_right_rounded : Icons.chevron_left_rounded),
                tooltip: ml.previousMonthTooltip,
              ),
              Expanded(
                // A live region: stepping to another month announces its name.
                child: Semantics(
                  liveRegion: true,
                  header: true,
                  child: Text(
                    DateFormat.yMMMM(locale).format(_month),
                    textAlign: TextAlign.center,
                    style: t.titleMedium,
                  ),
                ),
              ),
              IconButton(
                onPressed: _canGoForward ? () => _shift(1) : null,
                icon: Icon(rtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded),
                tooltip: ml.nextMonthTooltip,
              ),
            ],
          ),
          GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: _cellExtent,
            ),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // The letters repeat what every day's label already says in full.
              for (var i = 0; i < 7; i++)
                ExcludeSemantics(
                  child: Center(child: Text(ml.narrowWeekdays[(firstWeekday + i) % 7], style: t.labelMedium)),
                ),
              for (var i = 0; i < lead; i++) const SizedBox.shrink(),
              for (var d = 1; d <= daysInMonth; d++) day(d),
            ],
          ),
        ],
      ),
    );
  }
}
