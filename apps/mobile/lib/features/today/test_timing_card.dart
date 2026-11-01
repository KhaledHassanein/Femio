// The "when to take a pregnancy test" card on the trying-to-conceive Today screen.
//
// Why it exists: testing before a period is missed is the common cause of a false
// negative, so the card names the honest day rather than the earliest possible one.

import 'package:flutter/material.dart';

import '../../domain/cycle_prediction.dart';
import '../../domain/test_timing.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/radii.dart';
import 'hero_card.dart';

/// The day comes from `domain/test_timing.dart` (MR-21, NHS): the end of the predicted
/// window, or general advice when cycles are irregular. This card only draws it.
///
/// [prediction] supplies the window; with irregular cycles, or no prediction at all
/// (null), the card gives general advice instead of a date. [date] formats the day in
/// her language and is only needed when a date is named.
class TestTimingCard extends StatelessWidget {
  const TestTimingCard({super.key, required this.prediction, required this.date});
  final CyclePrediction? prediction;
  final IsoDateFormatter? date;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(space4h),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusLg),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.science_outlined, color: p.primary),
              const SizedBox(width: space2),
              Text(l.testTimingTitle, style: t.titleMedium),
            ],
          ),
          const SizedBox(height: space2),
          Text(_body(l), style: t.bodyMedium),
          const SizedBox(height: space1h),
          Text(l.testTimingSource, style: t.bodySmall),
        ],
      ),
    );
  }

  /// The sentence: the first honest day when the domain names one, else general advice.
  String _body(L10n l) {
    final p = prediction;
    final format = date;
    final day = p == null ? null : pregnancyTestDay(windowEnd: p.windowEnd, irregular: p.irregular);
    return day == null || format == null ? l.testTimingGeneral : l.testTimingBody(format(day));
  }
}
