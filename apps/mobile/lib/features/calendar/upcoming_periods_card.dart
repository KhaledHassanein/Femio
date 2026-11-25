// The "Next periods" card under the calendar: each predicted period as a range with
// how sure it is (MR-51, R8.10).
//
// Why it exists: the owner asked to see the calculated next periods once she has
// logged. The grid shows them in place; this card says them in words, with the
// confidence the grid can only hint at.

import 'package:flutter/material.dart';

import '../../domain/cycle_prediction.dart';
import '../../domain/upcoming_periods.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/dashed_ring.dart';
import '../today/hero_card.dart' show IsoRangeFormatter;

/// Lists [periods] (from `upcomingPeriods`) with a ring that matches the calendar:
/// solid for likely, dashed for possible (low confidence). [range] formats two ISO
/// days in her language. Says why only one period is shown when that is the case.
class UpcomingPeriodsCard extends StatelessWidget {
  const UpcomingPeriodsCard({
    super.key,
    required this.periods,
    required this.range,
  });
  final List<UpcomingPeriod> periods;
  final IsoRangeFormatter range;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;

    String confidence(Confidence c) => switch (c) {
      Confidence.high => l.confidenceHigh,
      Confidence.medium => l.confidenceMedium,
      Confidence.low => l.confidenceLowShort,
    };

    Widget ring(Confidence c) => SizedBox(
      width: 16,
      height: 16,
      child: c == Confidence.low
          ? CustomPaint(painter: DashedRingPainter(color: p.predictionBand))
          : DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: p.predictionBand, width: 1.5),
              ),
            ),
    );

    return Container(
      padding: const EdgeInsets.all(space4),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusLg),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.upcomingPeriodsTitle, style: t.titleSmall),
          const SizedBox(height: space2h),
          for (final u in periods)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: space1h),
              child: Row(
                children: [
                  ExcludeSemantics(child: ring(u.confidence)),
                  const SizedBox(width: space2h),
                  Expanded(
                    child: Text(
                      range(u.windowStart, u.windowEnd),
                      style: t.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: space2),
                  Text(
                    confidence(u.confidence),
                    style: t.bodySmall?.copyWith(color: p.textSubtle),
                  ),
                ],
              ),
            ),
          const SizedBox(height: space2),
          Text(
            periods.length > 1
                ? l.upcomingPeriodsWider
                : l.upcomingPeriodsOnlyNext,
            style: t.bodySmall?.copyWith(color: p.textSubtle),
          ),
        ],
      ),
    );
  }
}
