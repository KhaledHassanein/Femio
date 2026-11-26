// The visit summary: her own log, condensed for a clinic visit (ADR-078, R7.1; persona docs
// B1 item 12, B6 item 5, C1 item 9, C6 item 7, F1 item 6, D1 item 12).
//
// Why it exists: the most common thing a tracker owes her is a clear page to show a doctor.
// Every number here is counted from what she logged; nothing is interpreted. The questions
// come from fixed, reviewed banks (ARB keys `visitQ_<id>`): the rule bank below and the sourced
// persona catalogue (`tip_catalogue.g.dart`, ADR-079), chosen on the phone; on a phone with
// Gemini Nano the model may reorder the rule picks, never add to them. No threshold is new:
// the TTC suggestion reuses the seek-help clock (MR-13, MR-14) and "irregular" is the
// prediction's own flag.

import '../../data/profile.dart';
import '../cycle_prediction.dart';
import '../dates.dart';
import '../guidance.dart';
import '../log_vocabulary.g.dart';
import 'personal_triggers.dart';
import 'tip_catalogue.g.dart';

/// How far back the summary looks at symptoms and moods.
const visitWindowDays = 90;

/// A term counts as "logged often" from this many days in the window. A display rule for
/// what to list first, not a medical threshold.
const oftenLoggedDays = 3;

/// The most terms the summary lists.
const maxListedTerms = 8;

/// The most questions the summary suggests.
const maxVisitQuestions = 5;

/// The question bank: ids in the order they are suggested when several apply. The words are
/// in the ARB files (`visitQ_<id>`); [visitQuestionEnglish] is the same text for the model.
const visitQuestionEnglish = <String, String>{
  'cycleSpread': 'My cycle lengths vary. Is that worth looking into?',
  'ttcTests':
      'Given how long we have been trying, which checks would you suggest?',
  'ovulation': 'How can we find out whether I am ovulating?',
  'folicAcid': 'Should I be taking folic acid now?',
  'painfulPeriods': 'My period pain affects my days. What can help?',
  'heavyPeriods': 'My periods are heavy. Is a blood test worth doing?',
  'moodCycle': 'My mood changes a lot around my period. Can we talk about it?',
  'skinHair': 'I have skin or hair changes along with irregular cycles. Should these be checked together?',
  'tiredness': 'I often feel tired. Is anything worth checking?',
  'menopause':
      'Could my symptoms be linked to perimenopause, and what are my options?',
  'pregnancyNext': 'What should I look out for before our next visit?',
  'pregnancyMovements':
      "When should I start paying attention to the baby's movements?",
  'anythingElse':
      'Is there anything in my log you would like to look at more closely?',
};

/// A catalogue question that, when chosen, replaces the questions that ask the same thing.
const questionSupersedes = <String, List<String>>{
  'ttcOverThirtyFiveSooner': ['ttcTests', 'checksForCouple'],
  'checksForCouple': ['ttcTests'],
  'irregularTryingNow': ['ttcTests'],
  'painCauseChecks': ['painfulPeriods'],
  'heavyAndTiredBloodTest': ['heavyPeriods', 'tiredness'],
  'irregularCauses': ['cycleSpread'],
  'periodsStoppedChecks': ['cycleSpread'],
  'irregularAcneChecks': ['skinHair'],
  'thyroidCheckIrregular': ['skinHair'],
  'diaryReviewCycle': ['moodCycle'],
  'movementsCallWho': ['pregnancyMovements'],
  'hotFlushOptions': ['menopause'],
  'thyroidAfterBirth': ['tiredness'],
};

/// The English text of any question id, from either bank, for the model that orders them.
String? questionEnglish(String id) =>
    visitQuestionEnglish[id] ?? catalogueQuestionEnglish[id];

/// One term and on how many days in the window she logged it.
class TermCount {
  const TermCount(this.key, this.days);
  final String key;
  final int days;
}

/// What the summary shows. Every field is a count or a date from her own record.
class VisitSummary {
  const VisitSummary({
    required this.goal,
    required this.cyclesObserved,
    required this.shortestCycle,
    required this.longestCycle,
    required this.lastPeriodStart,
    required this.irregular,
    required this.topTerms,
    required this.heavyDays,
    required this.positiveOvulationTests,
    required this.temperatureDays,
    required this.tryingFor,
    required this.questionIds,
  });

  final Goal goal;

  /// Complete cycles between logged period starts (0 when she has logged fewer than two).
  final int cyclesObserved;
  final int? shortestCycle;
  final int? longestCycle;
  final String? lastPeriodStart;

  /// Her stated irregularity or the prediction's own flag.
  final bool irregular;

  /// Terms logged in the window, most days first, at most [maxListedTerms].
  final List<TermCount> topTerms;

  /// Days with heavy flow in the window.
  final int heavyDays;

  /// Days with a positive ovulation test in the window.
  final int positiveOvulationTests;

  /// Days with a waking temperature in the window.
  final int temperatureDays;
  final TryingFor? tryingFor;

  /// Suggested question ids from either bank (see [questionEnglish]), at most
  /// [maxVisitQuestions].
  final List<String> questionIds;

  /// The facts as short English lines, for the on-device model that orders the questions.
  /// Counts and keys only; no date, no name.
  String factsInEnglish() => [
    'Goal: ${goal.name}.',
    if (cyclesObserved > 0)
      'Cycles logged: $cyclesObserved, from $shortestCycle to $longestCycle days.',
    if (irregular) 'Cycles described as irregular.',
    if (tryingFor != null) 'Trying to conceive for: ${tryingFor!.name}.',
    if (topTerms.isNotEmpty)
      'Logged often: ${topTerms.map((t) => '${t.key} (${t.days} days)').join(', ')}.',
    if (heavyDays > 0) 'Heavy flow days: $heavyDays.',
    if (positiveOvulationTests > 0)
      'Positive ovulation tests: $positiveOvulationTests.',
  ].join('\n');
}

/// Builds the summary from [profile] as of [today] (ISO date).
VisitSummary visitSummary(Profile profile, String today) {
  final starts = bleedStarts(profile.cycleStarts);
  final lengths = <int>[
    for (var i = 1; i < starts.length; i++) diffDays(starts[i - 1], starts[i]),
  ].where((d) => d > 0).toList();
  final prediction = predictNextPeriod(
    profile.cycleStarts,
    profile.cycleLength,
  );
  final irregular = profile.irregular || (prediction?.irregular ?? false);

  final from = addDays(today, -visitWindowDays);
  final counts = <String, int>{};
  var heavy = 0, positive = 0, temps = 0;
  profile.logs.forEach((date, log) {
    if (date.compareTo(from) < 0 || date.compareTo(today) > 0) return;
    for (final t in log.terms.toSet()) {
      counts[t] = (counts[t] ?? 0) + 1;
    }
    if (log.flow == 'heavy') heavy++;
    if (log.opk == 'positive' || log.opk == 'peak') positive++;
    if (log.bbt != null) temps++;
  });
  final order = {for (var i = 0; i < logTerms.length; i++) logTerms[i].key: i};
  final elevated = {
    for (final t in logTerms)
      if (t.elevated || t.dimension == LogDimension.intercourse) t.key,
  };
  final top =
      counts.entries
          .where((e) => order.containsKey(e.key) && !elevated.contains(e.key))
          .toList()
        ..sort(
          (a, b) => b.value != a.value
              ? b.value.compareTo(a.value)
              : order[a.key]!.compareTo(order[b.key]!),
        );

  int days(String key) => counts[key] ?? 0;
  bool often(List<String> keys) =>
      keys.fold<int>(0, (s, k) => s + days(k)) >= oftenLoggedDays;
  final age = profile.birthYear == null
      ? null
      : int.parse(today.substring(0, 4)) - profile.birthYear!;
  final ttc = profile.goal == Goal.ttc;
  final pregnant = profile.goal == Goal.pregnant && profile.birthDate == null;
  final afterBirth = profile.goal == Goal.pregnant && profile.birthDate != null;
  final cycling = !pregnant && !afterBirth;
  final fits = fitting(visitQuestionCatalogue, triggerContext(profile, today));
  final rules = <String>[
    if (cycling && irregular) 'cycleSpread',
    if (ttc &&
        ttcGuidance(
          tryingFor: profile.tryingFor,
          age: age,
          irregular: irregular,
        ).suggestClinician)
      'ttcTests',
    if (ttc && (irregular || positive == 0)) 'ovulation',
    if (ttc) 'folicAcid',
    if (pregnant) 'pregnancyNext',
    if (pregnant) 'pregnancyMovements',
    if (cycling && often(['cramps', 'backache'])) 'painfulPeriods',
    if (cycling && heavy >= 2) 'heavyPeriods',
    if (cycling &&
        often(['moodSwings', 'irritable', 'sad', 'anxious', 'tearfulness']))
      'moodCycle',
    if (cycling && irregular && often(['acne', 'hairThinning', 'weightChange']))
      'skinHair',
    if (often(['fatigue'])) 'tiredness',
    if (profile.goal == Goal.menopause ||
        (cycling && often(['hotFlashes', 'nightSweats'])))
      'menopause',
  ];
  // Catalogue questions with a personal condition first, then the rule bank, then the
  // catalogue's general questions for her stage.
  final ids = <String>{
    for (final f in fits)
      if (f.trigger.specificity > 0) f.id,
    ...rules,
    for (final f in fits)
      if (f.trigger.specificity == 0) f.id,
  };
  final replaced = {for (final id in ids) ...?questionSupersedes[id]};
  final questions = [
    ...ids.where((id) => !replaced.contains(id)).take(maxVisitQuestions - 1),
    'anythingElse',
  ];

  return VisitSummary(
    goal: profile.goal,
    cyclesObserved: lengths.length,
    shortestCycle: lengths.isEmpty
        ? null
        : lengths.reduce((a, b) => a < b ? a : b),
    longestCycle: lengths.isEmpty
        ? null
        : lengths.reduce((a, b) => a > b ? a : b),
    lastPeriodStart: starts.isEmpty ? null : starts.last,
    irregular: irregular,
    topTerms: [
      for (final e in top.take(maxListedTerms)) TermCount(e.key, e.value),
    ],
    heavyDays: heavy,
    positiveOvulationTests: positive,
    temperatureDays: temps,
    tryingFor: profile.tryingFor,
    questionIds: questions,
  );
}

/// Applies a model's preferred order to the rule picks: ids the model ranked come first in its
/// order, the rest keep theirs, and nothing outside [ruleIds] is ever added. "anythingElse"
/// stays last.
List<String> reorderQuestions(List<String> ruleIds, List<String> modelOrder) {
  final core = ruleIds.where((id) => id != 'anythingElse').toList();
  final ranked = [
    for (final id in modelOrder)
      if (core.contains(id)) id,
  ];
  return [
    ...ranked,
    ...core.where((id) => !ranked.contains(id)),
    if (ruleIds.contains('anythingElse')) 'anythingElse',
  ];
}
