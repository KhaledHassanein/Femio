// Chooses which hero card Today shows for her goal.
//
// Why it exists: the screen should not know how a period, a pregnancy or menopause is
// drawn. It hands over the profile; this file picks the hero. A new goal adds one case
// here (the compiler forces it) and one hero file.

import 'package:flutter/material.dart';

import '../../data/profile.dart';
import 'hero_card.dart';
import 'menopause_hero.dart';
import 'period_hero.dart';
import 'pregnancy_hero.dart';

/// The hero for [profile]'s goal.
///
/// [today] is an ISO day; [range] and [date] format days in her language.
class TodayHero extends StatelessWidget {
  const TodayHero({
    super.key,
    required this.profile,
    required this.today,
    required this.range,
    required this.date,
    this.onAddLength,
    this.onOpenWeek,
  });
  final Profile profile;
  final String today;
  final IsoRangeFormatter range;
  final IsoDateFormatter date;

  /// Asks her cycle length again (passed to [PeriodHero]).
  final VoidCallback? onAddLength;

  /// Opens her pregnancy week's guide (passed to [PregnancyHero]).
  final VoidCallback? onOpenWeek;

  @override
  Widget build(BuildContext context) => switch (profile.goal) {
        Goal.period || Goal.ttc => PeriodHero(profile: profile, today: today, range: range, date: date, onAddLength: onAddLength),
        Goal.pregnant => PregnancyHero(profile: profile, today: today, date: date, onOpenWeek: onOpenWeek),
        Goal.menopause => MenopauseHero(profile: profile, today: today, range: range),
      };
}
