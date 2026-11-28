// A small dot chart for a person's own readings (temperature, weight).
//
// Why it exists: every chart rests on the same rule, her numbers drawn honestly with no
// target and no marker, so one painter serves them all. The record charts (R11.5) add real
// date spacing, a second series (diastolic) and, only when her own lab printed one, a light
// band for that printed range; the temperature and weight charts pass none of these.

import 'package:flutter/material.dart';

import '../theme/femio_theme.dart';

/// Width kept on the left for the axis numbers; a caption under the chart can start here.
const double readingsChartAxisInset = 52;

/// Her readings as dots on her own axis: three gridlines with values, a faint line
/// through the dots, and nothing else. No target, no marker (the BBT and weight charts
/// rest on that call; `domain/bbt.dart`, `domain/weight.dart`). The one band that can
/// appear is [band], and only the range printed on her own report may be passed in.
class ReadingsChart extends StatelessWidget {
  const ReadingsChart({
    super.key,
    required this.ys,
    required this.low,
    required this.high,
    required this.unit,
    required this.semanticsLabel,
    this.decimals = 1,
    this.xs,
    this.ys2,
    this.band,
  });

  /// 0–1, bottom to top, in date order.
  final List<double> ys;
  final double low;
  final double high;
  final String unit;
  final String semanticsLabel;
  final int decimals;

  /// 0–1, left to right, one per dot: real date spacing. Null spaces the dots evenly.
  final List<double>? xs;

  /// A second series (blood pressure's diastolic), drawn as rings so it never depends on colour.
  final List<double>? ys2;

  /// Her report's printed range as 0–1 y positions, drawn as a light band; null draws none.
  final ({double low, double high})? band;

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
          child: CustomPaint(painter: _Painter(this, p.chart1, p.chart2, p.chartGrid, p.textSubtle)),
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  _Painter(this.c, this.ink, this.ink2, this.grid, this.label);
  final ReadingsChart c;
  final Color ink;
  final Color ink2;
  final Color grid;
  final Color label;

  @override
  void paint(Canvas canvas, Size size) {
    const left = readingsChartAxisInset;
    final w = size.width - left - 8;
    final h = size.height - 16;
    final band = c.band;
    if (band != null) {
      canvas.drawRect(
        Rect.fromLTRB(left, 8 + h * (1 - band.high), size.width - 8, 8 + h * (1 - band.low)),
        Paint()..color = ink.withValues(alpha: 0.12),
      );
    }
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
    final xs = c.xs;
    double xAt(int i) => left + (xs != null ? w * xs[i] : (n == 1 ? w / 2 : w * i / (n - 1)));
    void series(List<double> ys, Color color, {required bool ring}) {
      Offset at(int i) => Offset(xAt(i), 8 + h * (1 - ys[i]));
      final line = Path()..moveTo(at(0).dx, at(0).dy);
      for (var i = 1; i < n; i++) {
        line.lineTo(at(i).dx, at(i).dy);
      }
      canvas.drawPath(
        line,
        Paint()
          ..color = color.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
      for (var i = 0; i < n; i++) {
        if (ring) {
          canvas.drawCircle(
            at(i),
            4,
            Paint()
              ..color = color
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2,
          );
        } else {
          canvas.drawCircle(at(i), 4.5, Paint()..color = color);
        }
      }
    }

    final second = c.ys2;
    if (second != null && second.length == n) series(second, ink2, ring: true);
    series(c.ys, ink, ring: false);
  }

  @override
  bool shouldRepaint(_Painter old) =>
      old.c.ys != c.ys ||
      old.c.xs != c.xs ||
      old.c.ys2 != c.ys2 ||
      old.c.band != c.band ||
      old.c.low != c.low ||
      old.c.high != c.high;
}
