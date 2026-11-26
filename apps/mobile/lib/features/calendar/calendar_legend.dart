// The key under the calendar: only the marks this month actually draws, plus why no
// fertile window is drawn when the rules withhold one.
//
// Why it exists: the legend listed fertile and ovulation swatches in months, and stages,
// that drew neither, so a missing window looked like a bug (Stitch review fix 6, R14.7).
// A swatch here always matches something on the grid above it.

import 'package:flutter/material.dart';

import '../../domain/day_marks.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../widgets/dashed_ring.dart';

/// Swatch size, matching the day circles' rings at legend scale.
const _swatch = 14.0;

/// The legend for [marks] (one month from `dayMarks`). The period swatch always shows, as
/// the anchor of the key; every other swatch only when the month draws it. [windowNote] is
/// the MR-06/08 sentence, shown when a cycle goal has a forecast but no window. Whenever the
/// month draws a fertile window or ovulation day, the MR-15 sentence follows (R14.9, owner
/// row 41: windows in both cycle modes, always with it).
class CalendarLegend extends StatelessWidget {
  const CalendarLegend({super.key, required this.marks, this.windowNote});
  final Map<String, DayMark> marks;
  final String? windowNote;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    bool any(bool Function(DayMark) test) => marks.values.any(test);

    Widget item(Widget swatch, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [swatch, const SizedBox(width: space1h), Text(label, style: t.bodySmall)],
        );
    Widget dot(Color fill, {Color? ring}) => Container(
          width: _swatch,
          height: _swatch,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: ring == null ? null : Border.all(color: ring, width: 1.5),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: space4,
          runSpacing: space2h,
          children: [
            item(dot(p.logPeriod), l.legendPeriod),
            if (any((m) => m.spotting)) item(dot(Colors.transparent, ring: p.logPeriod), l.legendSpotting),
            if (any((m) => m.predicted && !m.possible))
              item(dot(p.predictionBand.withValues(alpha: 0.14), ring: p.predictionBand), l.legendPredicted),
            if (any((m) => m.possible))
              item(
                SizedBox(
                  width: _swatch,
                  height: _swatch,
                  child: CustomPaint(painter: DashedRingPainter(color: p.predictionBand)),
                ),
                l.legendPossible,
              ),
            if (any((m) => m.fertile)) item(dot(p.successSoft), l.legendFertile),
            if (any((m) => m.ovulation)) item(dot(p.successSoft, ring: p.successSolid), l.legendOvulation),
            if (any((m) => m.logged))
              item(
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(color: p.logSymptom, shape: BoxShape.circle),
                ),
                l.legendLogged,
              ),
          ],
        ),
        if (any((m) => m.fertile || m.ovulation)) ...[
          const SizedBox(height: space2h),
          Text(l.predictionNote, style: t.bodySmall?.copyWith(color: p.textSubtle)),
        ],
        if (windowNote case final note?) ...[
          const SizedBox(height: space2h),
          Text(note, style: t.bodySmall?.copyWith(color: p.textSubtle)),
        ],
      ],
    );
  }
}
