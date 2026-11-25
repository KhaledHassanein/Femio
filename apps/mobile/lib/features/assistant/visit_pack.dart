// The words of the visit pack: the page she shows or sends to her clinic (R7.3, R10.2, R8.27).
//
// Why it exists: the screen, the copied text and the shared text must say the same thing, in
// her language and, if she chooses, a second language for the clinic. This file only puts
// into words what `domain/assistant/visit_summary.dart` counted and what she saved in her
// visit list; nothing here calculates. Reviewed questions are kept as ids so they can be
// written in either language; her own words stay exactly as she wrote them.

import 'package:intl/intl.dart' show DateFormat;

import '../../data/profile.dart';
import '../../domain/assistant/tip_catalogue.g.dart' show catalogueQuestionEnglish;
import '../../domain/assistant/visit_summary.dart';
import '../../domain/dates.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/log_labels.g.dart';
import 'catalogue_text.g.dart';

/// The reviewed wording of question [id] in [l]'s language.
String visitQuestionText(L10n l, String id) => switch (id) {
      'cycleSpread' => l.visitQ_cycleSpread,
      'ttcTests' => l.visitQ_ttcTests,
      'ovulation' => l.visitQ_ovulation,
      'folicAcid' => l.visitQ_folicAcid,
      'painfulPeriods' => l.visitQ_painfulPeriods,
      'heavyPeriods' => l.visitQ_heavyPeriods,
      'moodCycle' => l.visitQ_moodCycle,
      'skinHair' => l.visitQ_skinHair,
      'tiredness' => l.visitQ_tiredness,
      'menopause' => l.visitQ_menopause,
      'pregnancyNext' => l.visitQ_pregnancyNext,
      'pregnancyMovements' => l.visitQ_pregnancyMovements,
      _ => catalogueQuestionText(l, id) ?? l.visitQ_anythingElse,
    };

/// One line of her visit list: a reviewed question ([id]) or her own [words].
class VisitLine {
  const VisitLine.question(String this.id) : words = null;
  const VisitLine.words(String this.words) : id = null;
  final String? id;
  final String? words;

  /// The line in [l]'s language. Her own words are never translated, only labelled.
  String text(L10n l) => id != null ? visitQuestionText(l, id!) : l.visitInMyWords(words!);
}

/// Every reviewed question id, from both banks.
final Iterable<String> _allQuestionIds = {...visitQuestionEnglish.keys, ...catalogueQuestionEnglish.keys};

/// Her saved visit list ([prep], text as stored) read back into lines. A line that is a
/// reviewed question in her language ([mine]) becomes that question again, so the clinic copy
/// can show it in the clinic's language; anything else is her own words.
List<VisitLine> visitLinesFromPrep(L10n mine, List<String> prep) {
  final byText = {for (final id in _allQuestionIds) visitQuestionText(mine, id): id};
  return [
    for (final line in prep)
      if (byText[line] case final id?) VisitLine.question(id) else VisitLine.words(line),
  ];
}

/// How long she has been trying, in her words from onboarding.
String tryingForLabel(L10n l, TryingFor f) => switch (f) {
      TryingFor.justStarted => l.tryingJustStarted,
      TryingFor.under6 => l.tryingUnder6,
      TryingFor.sixTo12 => l.trying6to12,
      TryingFor.over12 => l.tryingOver12,
    };

/// The facts as lines, in [l]'s language, dates written for [locale].
List<String> visitFactLines(L10n l, VisitSummary s, String locale) => [
      s.cyclesObserved == 0
          ? l.visitCycles(0, 0, 0)
          : l.visitCycles(s.cyclesObserved, s.longestCycle!, s.shortestCycle!),
      if (s.lastPeriodStart != null) l.visitLastPeriod(DateFormat.yMMMd(locale).format(fromISO(s.lastPeriodStart!))),
      if (s.irregular) l.visitIrregular,
      if (s.tryingFor != null) '${l.visitTryingFor}: ${tryingForLabel(l, s.tryingFor!)}',
      if (s.heavyDays > 0) '${l.visitHeavyDays}: ${s.heavyDays}',
      if (s.positiveOvulationTests > 0) '${l.visitOpkPositive}: ${s.positiveOvulationTests}',
      if (s.temperatureDays > 0) '${l.visitTemperatureDays}: ${s.temperatureDays}',
    ];

/// The suggested question ids not already in her own list.
List<String> suggestedNotListed(List<String> suggested, List<VisitLine> mine) {
  final listed = {for (final m in mine) ?m.id};
  return [for (final id in suggested) if (!listed.contains(id)) id];
}

/// The whole page as text in one language.
String visitPackText(
  L10n l, {
  required String locale,
  required String today,
  required VisitSummary summary,
  required List<VisitLine> mine,
  required List<String> suggested,
}) {
  final others = suggestedNotListed(suggested, mine);
  return [
    'femio · ${l.visitTitle}',
    l.visitMadeOn(DateFormat.yMMMd(locale).format(fromISO(today))),
    '',
    ...visitFactLines(l, summary, locale),
    if (summary.topTerms.isNotEmpty) ...[
      '',
      l.visitTopTerms,
      for (final term in summary.topTerms) '- ${logLabel(l, term.key)}: ${l.visitDays(term.days)}',
    ],
    if (mine.isNotEmpty) ...[
      '',
      l.visitYourQuestions,
      for (final (i, line) in mine.indexed) '${i + 1}. ${line.text(l)}',
    ],
    if (others.isNotEmpty) ...[
      '',
      l.visitQuestionsTitle,
      for (final (i, id) in others.indexed) '${i + 1}. ${visitQuestionText(l, id)}',
    ],
  ].join('\n');
}

/// The page in her language, then, when [clinic] is given, the same page in the clinic's.
String visitPackBoth(
  L10n mine, {
  required String myLocale,
  L10n? clinic,
  String? clinicLocale,
  required String today,
  required VisitSummary summary,
  required List<VisitLine> lines,
  required List<String> suggested,
}) {
  String page(L10n l, String locale) =>
      visitPackText(l, locale: locale, today: today, summary: summary, mine: lines, suggested: suggested);
  return [
    page(mine, myLocale),
    if (clinic != null && clinicLocale != null) ...['', '— — —', '', page(clinic, clinicLocale)],
  ].join('\n');
}
