// The words for an empty forecast, the card the calendar shows, and the sheet that fixes
// the commonest cause.
//
// Why it exists: an empty calendar with no reason looks broken (owner report 2026-11-26,
// R14.7). Each reason from `domain/forecast.dart` gets one plain sentence and, when one
// answer fixes it ("Not sure" for her cycle length), the button that asks it again.
// Nothing here calculates; no AI (works with the assistant off, product rule 7).

import 'package:flutter/material.dart';

import '../../app.dart' show FemioController;
import '../../domain/cycle_prediction.dart' show statedCycleMaxDays, statedCycleMinDays;
import '../../domain/forecast.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../onboarding/widgets.dart' show NumberStepper;

/// The headline and the sentence for [gap], in her language.
(String, String) forecastGapText(L10n l, ForecastGap gap) => switch (gap) {
      ForecastGap.noPeriodLogged => (l.noPredictionTitle, l.gapNoPeriodBody),
      ForecastGap.needLength => (l.noPredictionTitle, l.gapNeedLengthBody),
      ForecastGap.needAnother => (l.noPredictionTitle, l.gapNeedAnotherBody),
      ForecastGap.allPassed => (l.gapPassedTitle, l.gapPassedBody),
    };

/// The card under the calendar when nothing is ahead: why, and the fix when there is one.
/// [onAddLength] is shown only for [ForecastGap.needLength].
class ForecastGapCard extends StatelessWidget {
  const ForecastGapCard({super.key, required this.gap, this.onAddLength});
  final ForecastGap gap;
  final VoidCallback? onAddLength;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final (title, body) = forecastGapText(l, gap);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space4),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusLg),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: t.titleSmall),
          const SizedBox(height: space2),
          Text(body, style: t.bodyMedium),
          if (gap == ForecastGap.needLength && onAddLength != null) ...[
            const SizedBox(height: space3),
            FilledButton.tonal(onPressed: onAddLength, child: Text(l.gapAddLength)),
          ],
        ],
      ),
    );
  }
}

/// Asks her usual cycle length again (the "Not sure" fix) and saves it to her profile.
/// Changes only that answer; her logged days are untouched (product rule 5).
Future<void> showCycleLengthSheet(BuildContext context, FemioController controller) {
  var value = controller.profile?.cycleLength ?? 28;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheet) {
      final l = L10n.of(sheet);
      final t = Theme.of(sheet).textTheme;
      return StatefulBuilder(
        builder: (sheet, setState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(space5, 0, space5, space5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.cycleLengthTitle, style: t.titleLarge),
                const SizedBox(height: space2),
                Text(l.cycleLengthSub, style: t.bodyMedium),
                const SizedBox(height: space4),
                NumberStepper(
                  value: value,
                  min: statedCycleMinDays,
                  max: statedCycleMaxDays,
                  label: l.daysValue(value),
                  onChanged: (v) => setState(() => value = v),
                ),
                const SizedBox(height: space4),
                FilledButton(
                  onPressed: () async {
                    final profile = controller.profile;
                    if (profile != null) await controller.save(profile.copyWith(cycleLength: value));
                    if (sheet.mounted) Navigator.of(sheet).pop();
                  },
                  child: Text(l.gapSaveLength),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
