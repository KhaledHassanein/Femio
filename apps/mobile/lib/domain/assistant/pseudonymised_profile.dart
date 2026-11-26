// The only description of her that may ever reach the cloud model (ADR-079, Cloud boost).
//
// Why it exists: personal tips are best when they fit her, and some phones have no Gemini Nano
// to choose them on the device. If she switches Cloud boost on, the phone may send a few coarse,
// derived bands instead of her record: life stage, how regular her cycles look, which kinds of
// symptom she logs, and how long she has been logging. No dates, no free text, no numbers she
// typed, no names, no contacts, no device or install identifier. The constructor is private,
// so the only way to make one is [pseudonymise], and the consent screen shows exactly
// [features] before she agrees.

import '../../data/profile.dart';
import '../cycle_prediction.dart';
import '../dates.dart';
import '../log_vocabulary.g.dart';

/// Her life stage, as the app already layers it (rule 5): after birth is its own band.
enum StageBand { period, ttc, pregnant, postpartum, menopause }

/// Her [StageBand]: her goal, with pregnancy split at the birth date (rule 5). The one
/// place the app derives it; tips, hints and the cloud bands all read this.
StageBand stageBandOf(Profile profile) => switch (profile.goal) {
      Goal.period => StageBand.period,
      Goal.ttc => StageBand.ttc,
      Goal.pregnant => profile.birthDate == null ? StageBand.pregnant : StageBand.postpartum,
      Goal.menopause => StageBand.menopause,
    };

/// How regular her cycles look from her own log; unknown until there is enough to say.
enum RegularityBand { regular, variable, unknown, notApplicable }

/// A kind of symptom, never the symptom itself.
enum SymptomCategory { pain, mood, digestion, sleepAndEnergy, skinAndHair, hotFlashes, bladder, other }

/// How long she has been logging, in broad steps.
enum StreakBand { none, underAWeek, weeks, overAMonth }

/// Days back the symptom categories look at.
const pseudonymWindowDays = 30;

/// A category counts only when its terms were logged on at least this many days in the window,
/// so one stray tap says nothing about her.
const pseudonymMinDays = 2;

/// Which category each non-elevated symptom and mood term belongs to. Elevated terms
/// (intercourse, libido, painDuringSex, vaginalDryness) never enter the profile.
const _categoryOf = <String, SymptomCategory>{
  'cramps': SymptomCategory.pain,
  'headache': SymptomCategory.pain,
  'backache': SymptomCategory.pain,
  'jointPain': SymptomCategory.pain,
  'musclePain': SymptomCategory.pain,
  'breastTenderness': SymptomCategory.pain,
  'bloating': SymptomCategory.digestion,
  'nausea': SymptomCategory.digestion,
  'constipation': SymptomCategory.digestion,
  'diarrhea': SymptomCategory.digestion,
  'cravings': SymptomCategory.digestion,
  'fatigue': SymptomCategory.sleepAndEnergy,
  'insomnia': SymptomCategory.sleepAndEnergy,
  'brainFog': SymptomCategory.sleepAndEnergy,
  'acne': SymptomCategory.skinAndHair,
  'hairThinning': SymptomCategory.skinAndHair,
  'dryItchySkin': SymptomCategory.skinAndHair,
  'brittleNails': SymptomCategory.skinAndHair,
  'hotFlashes': SymptomCategory.hotFlashes,
  'nightSweats': SymptomCategory.hotFlashes,
  'bladderUrgency': SymptomCategory.bladder,
  'bladderLeaks': SymptomCategory.bladder,
};

/// Coarse bands derived on the phone. Only [pseudonymise] can make one.
class PseudonymisedProfile {
  const PseudonymisedProfile._({
    required this.stage,
    required this.regularity,
    required this.categories,
    required this.streak,
  });

  final StageBand stage;
  final RegularityBand regularity;

  /// Sorted by name, so two phones with the same bands send the same text.
  final List<SymptomCategory> categories;
  final StreakBand streak;

  /// Exactly what would be sent, as plain English pairs; the consent screen shows the same
  /// values through its own translations.
  Map<String, String> get features => {
    'life stage': stage.name,
    'cycle regularity': regularity.name,
    'symptom kinds logged in the last month': categories.isEmpty ? 'none' : categories.map((c) => c.name).join(', '),
    'logging streak': streak.name,
  };
}

/// Builds her [PseudonymisedProfile] from [profile] as of [today] (yyyy-mm-dd). Never fails;
/// an empty record gives the "unknown" and "none" bands.
PseudonymisedProfile pseudonymise(Profile profile, String today) {
  final stage = stageBandOf(profile);
  final regularity = switch (stage) {
    StageBand.pregnant || StageBand.postpartum || StageBand.menopause => RegularityBand.notApplicable,
    _ => _regularity(profile),
  };
  final days = <SymptomCategory, int>{};
  final start = addDays(today, -pseudonymWindowDays);
  for (final MapEntry(key: date, value: log) in profile.logs.entries) {
    if (date.compareTo(start) <= 0 || date.compareTo(today) > 0) continue;
    final seen = <SymptomCategory>{};
    for (final term in log.terms) {
      final dim = logTerms.where((t) => t.key == term).firstOrNull;
      if (dim == null || dim.elevated) continue;
      seen.add(dim.dimension == LogDimension.mood ? SymptomCategory.mood : _categoryOf[term] ?? SymptomCategory.other);
    }
    for (final c in seen) {
      days[c] = (days[c] ?? 0) + 1;
    }
  }
  final categories = [
    for (final e in days.entries)
      if (e.value >= pseudonymMinDays) e.key,
  ]..sort((a, b) => a.name.compareTo(b.name));
  return PseudonymisedProfile._(
    stage: stage,
    regularity: regularity,
    categories: categories,
    streak: _streak(profile, today),
  );
}

RegularityBand _regularity(Profile profile) {
  if (profile.irregular) return RegularityBand.variable;
  final prediction = predictNextPeriod(profile.cycleStarts, profile.cycleLength);
  if (prediction == null || prediction.learning) return RegularityBand.unknown;
  return prediction.irregular || prediction.confidence == Confidence.low ? RegularityBand.variable : RegularityBand.regular;
}

/// Consecutive days with a log entry, ending today or yesterday, in broad bands.
StreakBand _streak(Profile profile, String today) {
  var day = profile.logs[today]?.isEmpty == false ? today : addDays(today, -1);
  var run = 0;
  while (profile.logs[day]?.isEmpty == false) {
    run++;
    day = addDays(day, -1);
  }
  if (run == 0) return StreakBand.none;
  if (run < 7) return StreakBand.underAWeek;
  if (run < 30) return StreakBand.weeks;
  return StreakBand.overAMonth;
}
