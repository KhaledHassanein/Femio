// The Today hero for the menopause goal.
//
// Why it exists: menopause is read as months since the last period, not as a cycle, so
// the card shows that one number and a plain note that the picture is hers to read with
// her clinician.

import 'package:flutter/material.dart';

import '../../data/profile.dart';
import '../../domain/cycle_prediction.dart';
import '../../domain/perimenopause.dart';
import '../../l10n/app_localizations.dart';
import 'hero_card.dart';

/// Hero for [Goal.menopause].
///
/// [today] is an ISO day. With no period date on record it shows twelve months when she
/// said her last period was over a year ago, and zero otherwise. Months are counted in
/// 30-day steps, which is a display approximation, not a clinical measurement.
class MenopauseHero extends StatelessWidget {
  const MenopauseHero({super.key, required this.profile, required this.today, this.range});
  final Profile profile;
  final String today;

  /// Formats a day range in her language; with it, a wide next-period range is shown while
  /// her periods still come (R8.20, MR-61).
  final IsoRangeFormatter? range;

  /// The over-a-year answer is shown as the twelve months that define it.
  static const _monthsWhenOverYear = 12;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    if (profile.periodStarts.isEmpty) {
      return HeroCard(
        eyebrow: l.goalMenopause,
        // CLIN-13: "Not sure" gives no date, so no month count is claimed.
        headline: profile.lastPeriodOverYear ? l.menoMonths(_monthsWhenOverYear) : l.menoNoDate,
        extra: [HeroLine(l.menoUnknown)],
      );
    }
    final months = monthsSinceLastPeriod(profile, today) ?? 0;
    final next = range != null && menopauseShowsRanges(profile, today)
        ? predictNextPeriod(profile.cycleStarts, profile.cycleLength)
        : null;
    return HeroCard(eyebrow: l.goalMenopause, headline: l.menoMonths(months), extra: [
      if (next != null) ...[
        HeroLine(l.menoNextRange(range!(next.windowStart, next.windowEnd))),
        HeroLine(l.menoRangeNote),
      ],
      HeroLine(l.menoUnknown),
    ]);
  }
}
