// The Today hero for the "track my period" and "trying to conceive" goals.
//
// Why it exists: both goals start from the same next-period prediction, and trying to
// conceive adds the fertile window, test timing and the temperature chart on top. One
// file keeps that shared start and its one difference side by side.

import 'package:flutter/material.dart';

import '../../data/profile.dart';
import '../../domain/bbt.dart';
import '../../domain/cycle_prediction.dart';
import '../../domain/cycle_signs.dart';
import '../../domain/dates.dart';
import '../../domain/fertility.dart';
import '../../domain/forecast.dart';
import '../../domain/guidance.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/bbt_chart.dart';
import '../calendar/forecast_gap.dart' show forecastGapText;
import '../calendar/prediction_sheets.dart';
import '../calendar/signs_by_day_screen.dart';
import 'cycle_signs_card.dart';
import 'hero_card.dart';
import 'hero_meters.dart';
import 'test_timing_card.dart';
import '../../theme/spacing.dart';

/// Hero for [Goal.period] and [Goal.ttc].
///
/// [today] is an ISO day; [range] and [date] format days in her language. Every number
/// is a range with a confidence (rule 3). With nothing ahead it says why, from the same
/// reasons the calendar uses (R14.7), and offers [onAddLength] when her length is the fix.
class PeriodHero extends StatelessWidget {
  const PeriodHero({
    super.key,
    required this.profile,
    required this.today,
    required this.range,
    required this.date,
    this.onAddLength,
  });
  final Profile profile;
  final String today;
  final IsoRangeFormatter range;
  final IsoDateFormatter date;

  /// Opens the cycle-length question again; shown only when "Not sure" withheld the range.
  final VoidCallback? onAddLength;


  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    String confidence(Confidence c) => switch (c) {
          Confidence.low => l.confidenceLow,
          Confidence.medium => l.confidenceMedium,
          Confidence.high => l.confidenceHigh,
        };

    final prediction = predictNextPeriod(profile.cycleStarts, profile.cycleLength);
    final gap = forecastGap(profile, today);
    Widget gapCard() {
      final (headline, body) = forecastGapText(l, gap!);
      return HeroCard(eyebrow: l.predictionPeriodTitle, headline: headline, extra: [
        HeroLine(body),
        if (gap == ForecastGap.needLength && onAddLength != null)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(onPressed: onAddLength, child: Text(l.gapAddLength)),
          ),
      ]);
    }

    if (prediction == null) {
      return Column(children: [gapCard(), if (profile.irregular) HeroNote(l.irregularNote)]);
    }
    // The first range not yet over, as the calendar draws it (R14.7: never a past range).
    final ahead = upcomingAhead(profile, today);
    final period = ahead.isEmpty ? null : range(ahead.first.windowStart, ahead.first.windowEnd);
    final extra = <Widget>[
      HeroLine(confidence(prediction.confidence)),
      if (prediction.basis == 'stated') HeroLine(l.basisStated),
      const SizedBox(height: space4h),
      CycleBand(lastStart: profile.cycleStarts.last, prediction: prediction, today: today),
    ];
    if (profile.goal == Goal.period) {
      return Column(children: [
        if (period == null) gapCard() else HeroCard(eyebrow: l.predictionPeriodTitle, headline: period, extra: extra),
        WhyRangeButton(profile: profile, range: range),
      ]);
    }
    // The window and the seek-help clock are domain rules with fixtures (MR-06..08,
    // MR-13/14); this screen only draws what they return.
    final fertile = currentOrNextFertileWindow(profile, prediction, today);
    final age = profile.birthYear == null ? null : fromISO(today).year - profile.birthYear!;
    final guidance = ttcGuidance(tryingFor: profile.tryingFor, age: age, irregular: profile.irregular || prediction.irregular);
    return Column(children: [
      if (fertile != null)
        HeroCard(
          eyebrow: l.predictionFertileTitle,
          headline: range(fertile.windowStart, fertile.windowEnd),
          extra: [
            HeroLine(l.predictionOvulation(date(fertile.ovulation))),
            if (period != null) HeroLine(l.predictionNextPeriod(period)),
            ...extra,
          ],
        )
      else if (period == null)
        gapCard()
      else
        HeroCard(
          eyebrow: l.predictionFertileTitle,
          headline: l.noConfidentWindowTitle,
          extra: [HeroLine(l.noConfidentWindowBody), HeroLine(l.predictionNextPeriod(period)), ...extra],
        ),
      HeroNote(l.predictionNote),
      WhyRangeButton(profile: profile, range: range),
      if (guidance.suggestClinician)
        HeroNote(switch (guidance.reason!) {
          GuidanceReason.irregularCycles => l.seeClinicianIrregular,
          GuidanceReason.twelveMonths || GuidanceReason.sixMonthsFrom35 => l.seeClinicianTtc,
        }),
      const SizedBox(height: space3),
      TestTimingCard(prediction: prediction, date: date),
      if (cycleSigns(profile.logs, profile.cycleStarts, today) case final signs when !signs.isEmpty) ...[
        const SizedBox(height: space3),
        CycleSignsCard(signs: signs, date: date, onOpenDays: () => openSignsByDay(context, profile, today)),
      ],
      const SizedBox(height: space3),
      BbtChartCard(chart: _cycleBbt(profile, today)),
    ]);
  }
}

/// Temperatures since her last period started, up to [today]: the current cycle's chart.
BbtChart? _cycleBbt(Profile profile, String today) {
  final starts = [for (final s in bleedStarts(profile.cycleStarts)) if (s.compareTo(today) <= 0) s];
  final since = starts.isEmpty ? null : starts.last;
  return bbtChart([
    for (final e in profile.logs.entries)
      if (e.value.bbt != null && e.key.compareTo(today) <= 0 && (since == null || e.key.compareTo(since) >= 0))
        BbtEntry(e.key, e.key, e.value.bbt!),
  ], since);
}
