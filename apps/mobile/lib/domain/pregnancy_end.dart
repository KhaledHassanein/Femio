// When a pregnancy ends without a birth, and the breastfeeding layer (owner 2026-11-27).
//
// Why it exists: femio is a companion for her whole health life, so she moves between stages
// without deleting or resetting anything (product rule 5). Before this, a pregnancy that ended
// had no path except "I had my baby" (wrong and hurtful) or "Delete everything" (study audit
// CLIN-1, MR-35). These rules decide only what Today shows and for how long; the wording lives
// in the catalogue and the urgent line follows the NHS miscarriage page.

import '../data/profile.dart';
import 'dates.dart';

/// How far back "My pregnancy has ended" accepts a day: the length of a pregnancy.
const pregnancyEndedMaxDaysAgo = 300;

/// How long Today keeps the gentle after-loss card, unless a period is logged sooner. A
/// product choice (enough time for the first periods to return), not a medical threshold.
const afterLossCardDays = 120;

/// Whether Today shows the after-loss card on [today]: her pregnancy ended (and no new one
/// started), it ended at most [afterLossCardDays] ago, and no period has been logged since.
bool showAfterLoss(Profile p, String today) {
  final ended = p.pregnancyEnded;
  if (ended == null || p.goal == Goal.pregnant) return false;
  final days = diffDays(ended, today);
  if (days < 0 || days > afterLossCardDays) return false;
  return p.cycleStarts.isEmpty;
}

/// The reviewed breastfeeding guides Today offers while she says she is breastfeeding.
const breastfeedingGuides = ['breastfeeding-first-two-weeks', 'when-breastfeeding-is-not-working'];
