import 'package:flutter/material.dart';

import '../domain/bbt.dart';
import '../l10n/app_localizations.dart';
import '../theme/femio_theme.dart';

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
          Semantics(
            label: '${l.bbtChartHeading}: ${c.points.map((x) => x.bbt.toStringAsFixed(2)).join(', ')}',
            child: SizedBox(
              height: 140,
              width: double.infinity,
              child: CustomPaint(painter: _BbtPainter(c, p.chart1, p.chartGrid, p.textSubtle)),
            ),
          ),
          const SizedBox(height: 8),
          Text(l.bbtChartNote, style: t.bodySmall),
        ],
      ]),
    );
  }
}

class _BbtPainter extends CustomPainter {
  _BbtPainter(this.chart, this.ink, this.grid, this.label);
  final BbtChart chart;
  final Color ink;
  final Color grid;
  final Color label;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 44.0;
    final w = size.width - left - 8;
    final h = size.height - 16;
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    final unit = chart.unit == 'c' ? '°C' : '°F';
    for (final f in [0.0, 0.5, 1.0]) {
      final y = 8 + h * (1 - f);
      canvas.drawLine(Offset(left, y), Offset(size.width - 8, y), gridPaint);
      final value = chart.low + (chart.high - chart.low) * f;
      final tp = TextPainter(
        text: TextSpan(text: '${value.toStringAsFixed(1)}$unit', style: TextStyle(color: label, fontSize: 10, fontFamily: 'PlusJakartaSans')),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }
    final n = chart.points.length;
    Offset at(int i) => Offset(left + (n == 1 ? w / 2 : w * i / (n - 1)), 8 + h * (1 - chart.points[i].y));
    final line = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 1; i < n; i++) {
      line.lineTo(at(i).dx, at(i).dy);
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = ink.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    for (var i = 0; i < n; i++) {
      canvas.drawCircle(at(i), 4.5, Paint()..color = ink);
    }
  }

  @override
  bool shouldRepaint(_BbtPainter old) => old.chart != chart;
}
