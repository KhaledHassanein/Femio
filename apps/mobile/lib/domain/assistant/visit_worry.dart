// The visit companion: what she wants to raise at a visit, turned into reviewed questions
// (ADR-078, R10.2; personas U25, U26).
//
// Why it exists: "what should I ask?" is the hardest part of a short appointment. She writes
// her worry in her own words; the safety rules read it first (a danger sign opens help, never
// a question list); then the topic table finds the reviewed questions that fit her worry and
// her life stage. No model is needed, so it works with the AI off (product rule 7). Nothing is
// saved until she confirms, and then only into `Appointment.prep`, her own visit list.

import '../../data/profile.dart';
import '../appointments.dart';
import 'pseudonymised_profile.dart' show StageBand, stageBandOf;
import 'safety.dart';
import 'tip_catalogue.g.dart';
import 'visit_summary.dart' show questionSupersedes;
import 'topic_lexicon.dart';

/// The most questions one worry suggests: enough to choose from, few enough to read.
const maxWorryQuestions = 3;

/// The longest worry kept as her own words in the visit list.
const maxWorryLength = 280;

/// The health topics each reviewed question is about, for both banks (`visitQ_<id>` and the
/// sourced catalogue). A question fits a worry that names one of its topics. Topic ids come
/// from `topic_table.dart`; a test keeps the two in step.
const questionTopics = <String, Set<String>>{
  // Catalogue questions first: each has a source and a narrower subject.
  'periodsStoppedChecks': {'irregular', 'poi'},
  'irregularCauses': {'irregular', 'cycleLength', 'pcos'},
  'irregularAcneChecks': {'acne', 'pcos'},
  'painCauseChecks': {'periodPain', 'endometriosis', 'adenomyosis'},
  'heavyAndTiredBloodTest': {'heavyBleeding', 'anemia', 'fatigue'},
  'diaryReviewCycle': {'pms', 'mood'},
  'headacheDiaryReview': {'headache'},
  'cervicalScreeningDue': {'screening'},
  'checksForCouple': {'fertility', 'maleFactor'},
  'ttcOverThirtyFiveSooner': {'fertility'},
  'irregularTryingNow': {'irregular', 'fertility'},
  'preconceptionReview': {'preconception', 'medicines'},
  'ttcSupportOptions': {'stress', 'mood'},
  'pregnancyTestsOffered': {'prenatalTests', 'screening', 'ultrasound'},
  'glucoseTestWhen': {'diabetes'},
  'movementsCallWho': {'fetalMovement'},
  'sameDayWarningSigns': {'warningSigns'},
  'rhFactorChecked': {'rh'},
  'pregnancyLowMoodSupport': {'mood', 'stress'},
  'severeSicknessHelp': {'nausea', 'hyperemesis'},
  'itchBloodTests': {'cholestasis'},
  'pretermSignsPlan': {'preterm', 'labor'},
  'postnatalCheckTalk': {'postpartum', 'pelvicFloor'},
  'postnatalMoodHelp': {'babyBlues', 'mood'},
  'latchCheck': {'breastfeeding', 'breastIssues'},
  'warningSignsYearAfter': {'warningSigns'},
  'thyroidAfterBirth': {'thyroid', 'fatigue'},
  'urineLeaksHelp': {'urinary', 'pelvicFloor'},
  'hotFlushOptions': {'hotFlashes', 'menopause'},
  'changedBleedingChecks': {'bleeding', 'perimenopause'},
  'bleedingAfterMenopauseChecks': {'bleeding'},
  'boneAndHeartHealth': {'bones', 'heart'},
  'drynessWhatHelps': {'gsm', 'vaginalHealth'},
  'urineTestAgain': {'urinary'},
  'thyroidCheckIrregular': {'thyroid', 'hairLoss'},
  // The rule bank: broader questions, also for the stages the catalogue leaves out.
  'cycleSpread': {'irregular', 'cycleLength'},
  'ttcTests': {'fertility'},
  'ovulation': {'ovulation'},
  'folicAcid': {'preconception', 'nutrition'},
  'painfulPeriods': {'periodPain'},
  'heavyPeriods': {'heavyBleeding', 'anemia'},
  'moodCycle': {'mood', 'pms'},
  'skinHair': {'acne', 'hairLoss', 'pcos'},
  'tiredness': {'fatigue', 'anemia', 'sleep'},
  'menopause': {'menopause', 'perimenopause', 'hotFlashes'},
  'pregnancyNext': {'pregnancy', 'trimester'},
  'pregnancyMovements': {'fetalMovement'},
};

const _cycling = {StageBand.period, StageBand.ttc, StageBand.menopause};

/// The stages the rule-bank questions are written for, matching `visitSummary`'s own rules.
const _ruleStages = <String, Set<StageBand>>{
  'cycleSpread': _cycling,
  'ttcTests': {StageBand.ttc},
  'ovulation': {StageBand.ttc},
  'folicAcid': {StageBand.ttc},
  'painfulPeriods': _cycling,
  'heavyPeriods': _cycling,
  'moodCycle': _cycling,
  'skinHair': _cycling,
  'tiredness': {...StageBand.values},
  'menopause': {StageBand.period, StageBand.menopause},
  'pregnancyNext': {StageBand.pregnant},
  'pregnancyMovements': {StageBand.pregnant},
};

/// The stages question [id] is written for.
Set<StageBand> questionStages(String id) {
  for (final item in visitQuestionCatalogue) {
    if (item.id == id) return item.trigger.stages;
  }
  return _ruleStages[id] ?? const {};
}

/// What femio found in her worry.
class WorryMatch {
  const WorryMatch({required this.signal, required this.questionIds, required this.ownWords});

  /// What the safety rules found. Anything but [SafetySignal.none] means: show help, suggest
  /// nothing.
  final SafetySignal signal;

  /// Reviewed questions that fit, best first, at most [maxWorryQuestions].
  final List<String> questionIds;

  /// Her worry as she wrote it, trimmed and capped at [maxWorryLength].
  final String ownWords;
}

/// Reads [worry] for [profile] as of [today] (yyyy-mm-dd). The safety rules run first; then
/// each question that fits her stage scores one point per topic it shares with the worry
/// (broad topics such as "doctor" never count). Ties keep [questionTopics] order, and a
/// question another one supersedes ([questionSupersedes]) is left out.
WorryMatch matchWorry(String worry, Profile profile, String today) {
  final words = worry.trim();
  final own = words.length > maxWorryLength ? words.substring(0, maxWorryLength).trimRight() : words;
  final signal = safetySignalFor(words, profile, today);
  if (signal != SafetySignal.none || words.isEmpty) {
    return WorryMatch(signal: signal, questionIds: const [], ownWords: own);
  }
  final asked = topicsOf(words).where((t) => !isBroadTopic(t)).toSet();
  final stage = stageBandOf(profile);
  final scored = <(String, int)>[
    for (final MapEntry(key: id, value: topics) in questionTopics.entries)
      if (questionStages(id).contains(stage)) (id, topics.intersection(asked).length),
  ].where((s) => s.$2 > 0).toList();
  // A stable sort: higher score first, list order otherwise.
  final ranked = [for (final (i, s) in scored.indexed) (i, s)]
    ..sort((a, b) => b.$2.$2 != a.$2.$2 ? b.$2.$2.compareTo(a.$2.$2) : a.$1.compareTo(b.$1));
  // A narrower catalogue question replaces the broader one that asks the same thing.
  final ids = [for (final r in ranked) r.$2.$1];
  final replaced = {for (final id in ids) ...?questionSupersedes[id]};
  return WorryMatch(
    signal: signal,
    questionIds: ids.where((id) => !replaced.contains(id)).take(maxWorryQuestions).toList(),
    ownWords: own,
  );
}

/// The appointment her visit list belongs to: the next one ahead (an undated one first, as
/// the appointments screen orders them), or null when none is ahead.
Appointment? visitAppointment(Profile profile, String today) {
  final ahead = splitAppointments(profile.appointments, today).upcoming;
  return ahead.isEmpty ? null : ahead.first;
}

/// [profile] with [lines] added to the prep of [visitAppointment], or to a new undated
/// appointment with [newId] when none is ahead. Lines already in that prep are not repeated.
/// Called only after she confirms; never removes or reorders anything she wrote.
Profile withVisitPrep(Profile profile, List<String> lines, String today, {required String newId}) {
  final target = visitAppointment(profile, today);
  final prep = [...?target?.prep];
  for (final line in lines.map((s) => s.trim())) {
    if (line.isNotEmpty && !prep.contains(line)) prep.add(line);
  }
  final updated = Appointment(
    id: target?.id ?? newId,
    clinician: target?.clinician,
    type: target?.type,
    datetime: target?.datetime,
    prep: prep,
    resultsDue: target?.resultsDue,
  );
  return profile.copyWith(appointments: [
    for (final a in profile.appointments)
      if (a.id == updated.id) updated else a,
    if (target == null) updated,
  ]);
}

/// [profile] with [line] taken out of the prep of the appointment [appointmentId].
Profile withoutVisitPrep(Profile profile, String appointmentId, String line) => profile.copyWith(appointments: [
      for (final a in profile.appointments)
        if (a.id != appointmentId)
          a
        else
          Appointment(
            id: a.id,
            clinician: a.clinician,
            type: a.type,
            datetime: a.datetime,
            prep: [for (final p in a.prep) if (p != line) p],
            resultsDue: a.resultsDue,
          ),
    ]);
