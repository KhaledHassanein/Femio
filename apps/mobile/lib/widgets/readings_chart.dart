// A small dot chart for a person's own readings (temperature, weight).
//
// Why it exists: both charts rest on the same rule, her numbers drawn honestly with no
// target, band or marker, so one painter serves both.

import 'package:flutter/material.dart';

import '../theme/femio_theme.dart';

/// Her readings as dots on her own axis: three gridlines with values, a faint line
/// through the dots, and nothing else. No band, no target, no marker (the BBT and
/// weight charts both rest on that call; `domain/bbt.dart`, `domain/weight.dart`).
class ReadingsChart extends StatelessWidget {
  const ReadingsChart({
    super.key,
    required this.ys,
    required this.low,
    required this.high,
    required this.unit,
    required this.semanticsLabel,
    this.decimals = 1,
  });

  /// 0–1, bottom to top, in date order.
  final List<double> ys;
  final double low;
  final double high;
  final String unit;
  final String semanticsLabel;
  final int decimals;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      label: semanticsLabel,
      child: SizedBox(
        height: 140,
        width: double.infinity,
        // The axis reads left to right in every language, like the numbers on it.
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: CustomPaint(painter: _Painter(this, p.chart1, p.chartGrid, p.textSubtle)),
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  _Painter(this.c, this.ink, this.grid, this.label);
  final ReadingsChart c;
  final Color ink;
  final Color grid;
  final Color label;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 52.0;
    final w = size.width - left - 8;
    final h = size.height - 16;
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (final f in [0.0, 0.5, 1.0]) {
      final y = 8 + h * (1 - f);
      canvas.drawLine(Offset(left, y), Offset(size.width - 8, y), gridPaint);
      final value = c.low + (c.high - c.low) * f;
      final tp = TextPainter(
        text: TextSpan(
          text: '${value.toStringAsFixed(c.decimals)}${c.unit}',
          style: TextStyle(color: label, fontSize: 10, fontFamily: 'PlusJakartaSans'),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: left - 4);
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }
    final n = c.ys.length;
    if (n == 0) return;
    Offset at(int i) => Offset(left + (n == 1 ? w / 2 : w * i / (n - 1)), 8 + h * (1 - c.ys[i]));
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
  bool shouldRepaint(_Painter old) => old.c.ys != c.ys || old.c.low != c.low || old.c.high != c.high;
}
