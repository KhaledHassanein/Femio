// Plain explanations of the calendar's estimates: why this range, what a day means, and
// what changed after a log (R9.6, R10.13; MR-01, MR-06, MR-51).
//
// Why it exists: a range she cannot question reads like a verdict, and a prediction that
// moves without a word reads like a mistake (C1 and B6 trust-breakers). Everything here is
// read from the same rules that draw the calendar (`predictNextPeriod`, `upcomingPeriods`,
// `fertileWindowBefore`, `dayMarks`); it adds no threshold and no model. The screens turn
// these values into sentences.

import '../data/profile.dart';
import 'cycle_prediction.dart';
import 'day_marks.dart';
import 'fertility.dart';
import 'upcoming_periods.dart';

/// Everything the "Why this range?" sheet says, read from her own prediction.
class RangeExplanation {
  const RangeExplanation({
    required this.prediction,
    required this.window,
    this.nextLevel,
    this.cyclesToNextLevel,
  });

  /// The prediction itself: basis, evidence (cycles used, spread, margin), confidence.
  final CyclePrediction prediction;

  /// For trying to conceive: whether a fertile window is named. Null in period mode,
  /// where no window is offered as advice.
  final WindowStatus? window;

  /// The next confidence step logging alone could reach, or null when none can: already
  /// high, or her cycles vary more than that step allows.
  final Confidence? nextLevel;

  /// How many more logged cycles, at the same steadiness, reach [nextLevel].
  final int? cyclesToNextLevel;
}

/// Explains the next-period range for [profile], or null when there is no prediction or
/// her goal draws none (pregnancy, menopause). Never fails.
RangeExplanation? explainRange(Profile profile) {
  if (profile.goal != Goal.period && profile.goal != Goal.ttc) return null;
  final prediction = predictNextPeriod(profile.periodStarts, profile.cycleLength);
  if (prediction == null) return null;
  final cycles = prediction.evidence.cyclesUsed;
  final spread = prediction.evidence.spread;
  Confidence? next;
  int? more;
  switch (prediction.confidence) {
    case Confidence.low when spread <= irregularSpreadDays:
      next = Confidence.medium;
      more = mediumConfidenceCycles - cycles;
    case Confidence.medium when spread <= highConfidenceSpreadDays:
      next = Confidence.high;
      more = highConfidenceCycles - cycles;
    default:
      break;
  }
  if (more != null && more <= 0) {
    next = null;
    more = null;
  }
  return RangeExplanation(
    prediction: prediction,
    window: profile.goal == Goal.ttc ? windowStatusFor(profile, prediction) : null,
    nextLevel: next,
    cyclesToNextLevel: more,
  );
}

/// What one calendar day shows, each as a separate fact (rule 3: logged facts and
/// estimates never blur).
class DayExplanation {
  const DayExplanation({
    required this.day,
    required this.future,
    required this.mark,
    this.period,
    this.periodIndex,
    this.fertile,
  });

  /// The ISO day explained.
  final String day;

  /// True for a day after today: nothing can be logged on it yet.
  final bool future;

  /// The calendar's own marks for that day (empty when nothing is drawn).
  final DayMark mark;

  /// The predicted period range the day falls in, and which one (0 = the next period).
  final UpcomingPeriod? period;
  final int? periodIndex;

  /// The fertile window the day falls in, when it is marked fertile or ovulation.
  final FertileWindow? fertile;

  /// True when any estimate is drawn on the day.
  bool get hasEstimate => mark.predicted || mark.fertile || mark.ovulation;

  /// True when she logged anything on the day.
  bool get hasFact => mark.bleed || mark.spotting || mark.logged;
}

/// Explains [day] for [profile] as of [today] (both ISO). Never fails.
DayExplanation explainDay(Profile profile, {required String day, required String today}) {
  final mark = dayMarks(profile, today: today, from: day, to: day)[day] ?? DayMark();
  UpcomingPeriod? period;
  int? index;
  FertileWindow? fertile;
  if (mark.predicted || mark.fertile || mark.ovulation) {
    final prediction = predictNextPeriod(profile.periodStarts, profile.cycleLength);
    if (prediction != null) {
      final periods = upcomingPeriods(prediction);
      for (var i = 0; i < periods.length; i++) {
        final u = periods[i];
        if (day.compareTo(u.windowStart) >= 0 && day.compareTo(u.windowEnd) <= 0) {
          period = u;
          index = i;
          break;
        }
      }
      if (mark.fertile || mark.ovulation) {
        // The window this day sits in: this cycle's or a later one (MR-57).
        for (final w in fertileWindowsFor(profile, prediction)) {
          if (day.compareTo(w.windowStart) >= 0 && day.compareTo(w.windowEnd) <= 0) {
            fertile = w;
            break;
          }
        }
      }
    }
  }
  return DayExplanation(
    day: day,
    future: day.compareTo(today) > 0,
    mark: mark,
    period: period,
    periodIndex: index,
    fertile: fertile,
  );
}

/// The next-period estimate before and after a change to her record.
class PredictionChange {
  const PredictionChange({required this.after, this.before});

  /// The previous next-period range, or null when there was none.
  final UpcomingPeriod? before;

  /// The new next-period range.
  final UpcomingPeriod after;
}

/// What changed in the next-period estimate between [before] and [after], or null when
/// nothing she can see changed (same range and confidence), when the new record draws no
/// prediction, or when her goal draws none. Ranges only, never one date (rule 3).
PredictionChange? predictionChange(Profile before, Profile after) {
  if (after.goal != Goal.period && after.goal != Goal.ttc) return null;
  UpcomingPeriod? next(Profile p) {
    final prediction = predictNextPeriod(p.periodStarts, p.cycleLength);
    if (prediction == null) return null;
    final periods = upcomingPeriods(prediction);
    return periods.isEmpty ? null : periods.first;
  }

  final now = next(after);
  if (now == null) return null;
  final was = next(before);
  if (was != null &&
      was.windowStart == now.windowStart &&
      was.windowEnd == now.windowEnd &&
      was.confidence == now.confidence) {
    return null;
  }
  return PredictionChange(before: was, after: now);
}
