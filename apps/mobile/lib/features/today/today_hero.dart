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
  });
  final Profile profile;
  final String today;
  final IsoRangeFormatter range;
  final IsoDateFormatter date;

  @override
  Widget build(BuildContext context) => switch (profile.goal) {
        Goal.period || Goal.ttc => PeriodHero(profile: profile, today: today, range: range, date: date),
        Goal.pregnant => PregnancyHero(profile: profile, today: today, date: date),
        Goal.menopause => MenopauseHero(profile: profile, today: today),
      };
}
