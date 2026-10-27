// The temperature chart card shown on the trying-to-conceive Today screen.
//
// Why it exists: it frames the shared readings chart with a heading and a note, and says
// plainly when there are too few readings to draw a pattern.

import 'package:flutter/material.dart';

import '../domain/bbt.dart';
import '../l10n/app_localizations.dart';
import '../theme/femio_theme.dart';
import '../theme/radii.dart';
import '../theme/spacing.dart';
import 'readings_chart.dart';

/// Her waking temperatures this cycle, drawn as they are. No coverline, no shift
/// marker, no named day: that reading is hers and her clinician's (lib/fertility).
class BbtChartCard extends StatelessWidget {
  const BbtChartCard({super.key, required this.chart});

  /// Null when there are fewer than three readings: a dot is not a pattern.
  final BbtChart? chart;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final c = chart;
    return Container(
      padding: const EdgeInsets.all(space4h),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusLg),
        border: Border.all(color: p.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.bbtChartHeading, style: t.titleMedium),
        const SizedBox(height: space2h),
        if (c == null)
          Text(l.bbtChartNeedData, style: t.bodySmall)
        else ...[
          ReadingsChart(
            ys: [for (final x in c.points) x.y],
            low: c.low,
            high: c.high,
            unit: c.unit == 'c' ? '°C' : '°F',
            semanticsLabel: '${l.bbtChartHeading}: ${c.points.map((x) => x.bbt.toStringAsFixed(2)).join(', ')}',
          ),
          const SizedBox(height: space2),
          Text(l.bbtChartNote, style: t.bodySmall),
        ],
      ]),
    );
  }
}
