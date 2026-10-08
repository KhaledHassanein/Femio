import 'package:flutter/material.dart';

import '../domain/bbt.dart';
import '../l10n/app_localizations.dart';
import '../theme/femio_theme.dart';
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: p.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.bbtChartHeading, style: t.titleMedium),
        const SizedBox(height: 10),
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
          const SizedBox(height: 8),
          Text(l.bbtChartNote, style: t.bodySmall),
        ],
      ]),
    );
  }
}
