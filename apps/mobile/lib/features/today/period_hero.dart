// The Today hero for the "track my period" and "trying to conceive" goals.
//
// Why it exists: both goals start from the same next-period prediction, and trying to
// conceive adds the fertile window, test timing and the temperature chart on top. One
// file keeps that shared start and its one difference side by side.

import 'package:flutter/material.dart';

import '../../data/profile.dart';
import '../../domain/bbt.dart';
import '../../domain/cycle_prediction.dart';
import '../../domain/dates.dart';
import '../../domain/fertility.dart';
import '../../domain/guidance.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/bbt_chart.dart';
import 'hero_card.dart';
import 'hero_meters.dart';
import 'test_timing_card.dart';
import '../../theme/spacing.dart';

/// Hero for [Goal.period] and [Goal.ttc].
///
/// [today] is an ISO day; [range] and [date] format days in her language. Every number
/// is a range with a confidence (rule 3). With no prediction yet it says so and, when
/// she called her cycles irregular, explains why.
class PeriodHero extends StatelessWidget {
  const PeriodHero({
    super.key,
    required this.profile,
    required this.today,
    required this.range,
    required this.date,
  });
  final Profile profile;
  final String today;
  final IsoRangeFormatter range;
  final IsoDateFormatter date;


  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    String confidence(Confidence c) => switch (c) {
          Confidence.low => l.confidenceLow,
          Confidence.medium => l.confidenceMedium,
          Confidence.high => l.confidenceHigh,
        };

    final prediction = predictNextPeriod(profile.periodStarts, profile.cycleLength);
    if (prediction == null) {
      return Column(children: [
        HeroCard(eyebrow: l.predictionPeriodTitle, headline: l.noPredictionTitle, extra: [HeroLine(l.noPredictionBody)]),
        if (profile.irregular) HeroNote(l.irregularNote),
      ]);
    }
    final period = range(prediction.windowStart, prediction.windowEnd);
    final extra = <Widget>[
      HeroLine(confidence(prediction.confidence)),
      if (prediction.basis == 'stated') HeroLine(l.basisStated),
      const SizedBox(height: space4h),
      CycleBand(lastStart: profile.periodStarts.last, prediction: prediction, today: today),
    ];
    if (profile.goal == Goal.period) {
      return HeroCard(eyebrow: l.predictionPeriodTitle, headline: period, extra: extra);
    }
    // The window and the seek-help clock are domain rules with fixtures (MR-06..08,
    // MR-13/14); this screen only draws what they return.
    final fertile = fertileWindowBefore(
      prediction.predictedStart,
      cycleLength: profile.cycleLength ?? prediction.averageLength,
      irregular: prediction.irregular || profile.irregular,
      learning: prediction.learning && prediction.basis != 'stated',
    );
    final age = profile.birthYear == null ? null : fromISO(today).year - profile.birthYear!;
    final guidance = ttcGuidance(tryingFor: profile.tryingFor, age: age, irregular: profile.irregular || prediction.irregular);
    return Column(children: [
      if (fertile != null)
        HeroCard(
          eyebrow: l.predictionFertileTitle,
          headline: range(fertile.windowStart, fertile.windowEnd),
          extra: [
            HeroLine(l.predictionOvulation(date(fertile.ovulation))),
            HeroLine(l.predictionNextPeriod(period)),
            ...extra,
          ],
        )
      else
        HeroCard(
          eyebrow: l.predictionFertileTitle,
          headline: l.noConfidentWindowTitle,
          extra: [HeroLine(l.noConfidentWindowBody), HeroLine(l.predictionNextPeriod(period)), ...extra],
        ),
      HeroNote(l.predictionNote),
      if (guidance.suggestClinician)
        HeroNote(switch (guidance.reason!) {
          GuidanceReason.irregularCycles => l.seeClinicianIrregular,
          GuidanceReason.twelveMonths || GuidanceReason.sixMonthsFrom35 => l.seeClinicianTtc,
        }),
      const SizedBox(height: space3),
      TestTimingCard(prediction: prediction, date: date),
      const SizedBox(height: space3),
      BbtChartCard(chart: _cycleBbt(profile)),
    ]);
  }
}

/// Temperatures since her last period started: the current cycle's chart.
BbtChart? _cycleBbt(Profile profile) {
  final starts = bleedStarts(profile.periodStarts);
  final since = starts.isEmpty ? null : starts.last;
  return bbtChart([
    for (final e in profile.logs.entries)
      if (e.value.bbt != null && (since == null || e.key.compareTo(since) >= 0))
        BbtEntry(e.key, e.key, e.value.bbt!),
  ], since);
}
