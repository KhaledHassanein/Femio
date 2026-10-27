// The Bloom logo mark, drawn in code.
//
// Why it exists: a drawn mark stays crisp at any size and follows the theme's colours,
// where an image file would need one copy per size and per theme.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/femio_theme.dart';

/// The Bloom: the six petals of Femio's logo, drawn rather than shipped as an image so
/// it is crisp at any size and takes its colours from the theme. The same motif the
/// website uses (`apps/web/src/components/site/motifs.tsx`).
class Bloom extends StatelessWidget {
  const Bloom({super.key, this.size = 96, this.opacity = 1});
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ExcludeSemantics(
      child: Opacity(
        opacity: opacity,
        child: CustomPaint(
          size: Size.square(size),
          painter: _BloomPainter(p.artRose, p.artPeach, p.artSaffron, p.artCream, p.artPlum),
        ),
      ),
    );
  }
}

class _BloomPainter extends CustomPainter {
  _BloomPainter(this.c1, this.c2, this.c3, this.cream, this.plum);
  final Color c1, c2, c3, cream, plum;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 96;
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(s);
    final petal = Path()
      ..moveTo(0, 4)
      ..cubicTo(7.5, -9, 7.5, -27, 0, -40)
      ..cubicTo(-7.5, -27, -7.5, -9, 0, 4)
      ..close();
    // Along each petal, as on the app icon: rose at the heart, saffron at the tip.
    // The canvas is rotated per petal, so one shader in petal space serves all six.
    final shader = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [c1, c2, c3],
      stops: const [0, 0.55, 1],
    ).createShader(const Rect.fromLTRB(-8, -40, 8, 4));
    for (var i = 0; i < 6; i++) {
      canvas.save();
      canvas.rotate(i * math.pi / 3);
      canvas.drawPath(
        petal,
        Paint()
          ..shader = shader
          ..color = Colors.white.withValues(alpha: i.isEven ? 0.94 : 0.82),
      );
      canvas.restore();
    }
    canvas.drawCircle(Offset.zero, 7.5, Paint()..color = cream);
    canvas.drawCircle(Offset.zero, 4, Paint()..color = plum);
  }

  @override
  bool shouldRepaint(_BloomPainter old) => old.c2 != c2 || old.plum != plum;
}
