// The Today hero for the pregnancy goal, including the weeks after birth.
//
// Why it exists: pregnancy is counted in weeks and days, never down to a due date and
// never past it (MR-02: no "days to go", no "days overdue"). The due date is shown as a
// term window, "most babies arrive between ...", computed in domain/pregnancy.dart.
// After the birth the same card counts weeks since. That difference is the whole of
// this file.

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
/// shows postpartum weeks (never below zero); with a due date, the trimester, the week,
/// the term-window sentence and the progress bar (past 42 weeks, advice to talk to her
/// midwife or doctor instead of the window); with neither, a prompt for the date.
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
    final window = profile.edd == null ? null : termWindow(profile.edd!);
    if (progress == null || window == null) {
      return HeroCard(eyebrow: l.goalPregnant, headline: l.dueDateTitle);
    }
    return HeroCard(
      eyebrow: l.trimesterLabel(progress.trimester),
      headline: l.pregnancyWeek(progress.weeks, progress.days),
      extra: [
        ..._dateLines(l, progress, window),
        const SizedBox(height: space4h),
        PregnancyBar(totalDays: progress.totalDays),
      ],
    );
  }

  /// The line(s) under the week: the term window, or past 42 weeks the advice to talk to
  /// her midwife or doctor. Never a count of days (MR-02).
  List<Widget> _dateLines(L10n l, PregnancyProgress progress, TermWindow window) => isOverTerm(progress)
      ? [HeroLine(l.dueDateLabel(date(profile.edd!))), HeroLine(l.pregPastTerm)]
      : [HeroLine(l.pregTermWindow(date(profile.edd!), date(window.start), date(window.end)))];
}
