// A dashed circle outline, for estimates Femio is least sure of.
//
// Why it exists: a "possible" period (low confidence) must look different from a
// "likely" one by shape, not only by colour, so it still reads for someone who does
// not see the colour difference (WCAG 1.4.1, Stitch round 2 calendar).

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Paints a dashed ring inset by half the stroke so it fits its box.
///
/// [color] and [strokeWidth] style the stroke; [dashes] is how many dashes go
/// around the circle (gaps are the same length as the dashes).
class DashedRingPainter extends CustomPainter {
  const DashedRingPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashes = 12,
  });
  final Color color;
  final double strokeWidth;
  final int dashes;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius,
    );
    final step = 2 * math.pi / dashes;
    for (var i = 0; i < dashes; i++) {
      canvas.drawArc(rect, i * step, step / 2, false, paint);
    }
  }

  @override
  bool shouldRepaint(DashedRingPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.dashes != dashes;
}
