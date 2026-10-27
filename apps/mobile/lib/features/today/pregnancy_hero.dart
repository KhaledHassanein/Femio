// The Today hero for the pregnancy goal, including the weeks after birth.
//
// Why it exists: pregnancy is counted in weeks and days to a due date, and after the
// birth the same card counts weeks since. That difference is the whole of this file.

import 'package:flutter/material.dart';

import '../../data/profile.dart';
import '../../domain/dates.dart';
import '../../domain/pregnancy.dart';
import '../../l10n/app_localizations.dart';
import 'hero_card.dart';
import 'hero_meters.dart';
import '../../theme/spacing.dart';

/// Hero for [Goal.pregnant].
///
/// [today] is an ISO day and [date] formats days in her language. With a birth date it
/// shows postpartum weeks (never below zero); with a due date, the trimester, week,
/// days to go (or overdue) and the progress bar; with neither, a prompt for the date.
class PregnancyHero extends StatelessWidget {
  const PregnancyHero({super.key, required this.profile, required this.today, required this.date});
  final Profile profile;
  final String today;
  final IsoDateFormatter date;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    if (profile.birthDate != null) {
      final weeks = diffDays(profile.birthDate!, today) ~/ 7;
      return HeroCard(eyebrow: l.goalPregnant, headline: l.postpartumWeeks(weeks < 0 ? 0 : weeks));
    }
    final progress = profile.edd == null ? null : pregnancyProgress(profile.edd!, today);
    if (progress == null) {
      return HeroCard(eyebrow: l.goalPregnant, headline: l.dueDateTitle);
    }
    return HeroCard(
      eyebrow: l.trimesterLabel(progress.trimester),
      headline: l.pregnancyWeek(progress.weeks, progress.days),
      extra: [
        HeroLine(l.dueDateLabel(date(profile.edd!))),
        HeroLine(progress.overdue
            ? l.pregOverdue(-progress.daysUntilDue)
            : l.pregDaysToGo(progress.daysUntilDue)),
        HeroLine(l.pregTermFrom(date(progress.termStart))),
        const SizedBox(height: space4h),
        PregnancyBar(totalDays: progress.totalDays),
      ],
    );
  }
}
