// "Signs you logged this cycle": the trying-to-conceive Today card for fluid, ovulation
// tests and waking temperature (R8.27, Stitch round 1).
//
// Why it exists: these three signs are logged on different days and screens; seeing the
// latest of each in one place helps her notice her own pattern. The facts come from
// `domain/cycle_signs.dart`; this card only words them. It never draws a conclusion
// (MR-16, MR-17): a strip result always carries the MR-16 sentence.

import 'package:flutter/material.dart';

import '../../domain/cycle_signs.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/log_labels.g.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import 'hero_card.dart' show IsoDateFormatter;

/// The card, or nothing when she has logged none of the three signs this cycle (Today
/// stays short; the Log tab is where she adds them).
class CycleSignsCard extends StatelessWidget {
  const CycleSignsCard({super.key, required this.signs, required this.date});
  final CycleSigns signs;

  /// Formats an ISO day in her language.
  final IsoDateFormatter date;

  @override
  Widget build(BuildContext context) {
    if (signs.isEmpty) return const SizedBox.shrink();
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final discharge = signs.discharge;
    final opk = signs.opk;
    final bbt = signs.bbt;
    String temp(double v) {
      final unit = switch (signs.bbtUnit) { 'c' => ' °C', 'f' => ' °F', _ => '' };
      // Isolated left-to-right so "36.45 °C" keeps its order inside Arabic text.
      return '\u2066${v.toStringAsFixed(2)}$unit\u2069';
    }

    return Container(
      padding: const EdgeInsets.all(space4h),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusLg),
        border: Border.all(color: p.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Semantics(header: true, child: Text(l.signsTitle, style: t.titleMedium)),
        const SizedBox(height: space2),
        if (discharge != null)
          _Row(
            icon: Icons.water_drop_outlined,
            label: l.sectionDischarge,
            value: l.signsValueOn(discharge.value.map((k) => logLabel(l, k)).join(', '), date(discharge.day)),
          ),
        if (opk != null)
          _Row(
            icon: Icons.science_outlined,
            label: l.sectionOvulationTest,
            value: l.signsValueOn(opkLabel(l, opk.value), date(opk.day)),
          ),
        if (bbt != null)
          _Row(
            icon: Icons.thermostat_rounded,
            label: l.sectionTemperature,
            value: l.signsValueOn(temp(bbt.value), date(bbt.day)),
            detail: l.signsTempCount(signs.bbtCount),
          ),
        const SizedBox(height: space2),
        if (opk != null) ...[
          Text(l.signsStripLine, style: t.bodySmall),
          const SizedBox(height: space1h),
        ],
        Text(l.signsNote, style: t.bodySmall?.copyWith(color: p.textMuted)),
      ]),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.value, this.detail});
  final IconData icon;
  final String label;
  final String value;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: space1h),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: p.primary),
        const SizedBox(width: space2h),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: t.labelLarge),
            Text(value, style: t.bodyMedium),
            if (detail != null) Text(detail!, style: t.bodySmall?.copyWith(color: p.textMuted)),
          ]),
        ),
      ]),
    );
  }
}
