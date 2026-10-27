// The two small meters drawn on the Today hero: the cycle band and the pregnancy bar.
//
// Why it exists: both are decoration over a number the screen already states in words,
// so both hide from screen readers, and both must flip for right-to-left. Keeping them
// together keeps that mirroring logic in one place.

import 'package:flutter/material.dart';

import '../../domain/cycle_prediction.dart';
import '../../domain/dates.dart';
import '../../domain/pregnancy.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';

/// From her last period to the predicted window, with today marked. The window is
/// drawn soft (rule 3): a band, never a ring and never a single tick.
///
/// [lastStart] and [today] are ISO days; [prediction] supplies the window. The band is
/// mirrored in right-to-left languages.
class CycleBand extends StatelessWidget {
  const CycleBand({super.key, required this.lastStart, required this.prediction, required this.today});
  final String lastStart;
  final CyclePrediction prediction;
  final String today;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final span = diffDays(lastStart, prediction.windowEnd).clamp(1, 120);
    double at(String iso) => (diffDays(lastStart, iso) / span).clamp(0.0, 1.0);
    return ExcludeSemantics(
      child: LayoutBuilder(builder: (context, c) {
        final w = c.maxWidth;
        final rtl = Directionality.of(context) == TextDirection.rtl;
        double x(double f) => rtl ? w * (1 - f) : w * f;
        final a = x(at(prediction.windowStart));
        final b = x(at(prediction.windowEnd));
        return SizedBox(
          height: 18,
          child: Stack(children: [
            Positioned.fill(
              top: 6,
              bottom: 6,
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), borderRadius: BorderRadius.circular(radiusMeter)),
              ),
            ),
            Positioned(
              left: a < b ? a : b,
              width: (a - b).abs().clamp(8, w),
              top: 4,
              bottom: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radiusMeter),
                  gradient: LinearGradient(colors: [
                    p.predictionBand.withValues(alpha: 0.35),
                    p.predictionBand,
                    p.predictionBand.withValues(alpha: 0.35),
                  ]),
                ),
              ),
            ),
            Positioned(
              left: x(at(today)) - 9,
              top: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: p.primarySolid, width: 3),
                ),
              ),
            ),
          ]),
        );
      }),
    );
  }
}

/// Three trimester segments with a marker at how far she is. [totalDays] is the days
/// since the start of term; the marker is clamped to the bar. Mirrored in RTL.
class PregnancyBar extends StatelessWidget {
  const PregnancyBar({super.key, required this.totalDays});
  final int totalDays;

  @override
  Widget build(BuildContext context) {
    final f = (totalDays / gestationDays).clamp(0.0, 1.0);
    return ExcludeSemantics(
      child: LayoutBuilder(builder: (context, c) {
        final w = c.maxWidth;
        final rtl = Directionality.of(context) == TextDirection.rtl;
        // Three segments, one per trimester, fading from strongest to softest.
        Widget seg(int flex, double alpha) => Expanded(
              flex: flex,
              child: Container(
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: alpha), borderRadius: BorderRadius.circular(radiusSegment)),
              ),
            );
        return SizedBox(
          height: 18,
          child: Stack(alignment: Alignment.centerLeft, children: [
            Row(children: [seg(14, 0.55), seg(14, 0.4), seg(12, 0.28)]),
            Positioned(
              left: (rtl ? 1 - f : f) * w - 9,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          ]),
        );
      }),
    );
  }
}
