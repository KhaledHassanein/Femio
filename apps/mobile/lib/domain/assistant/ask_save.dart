// What "Save this to your record?" may write after an Ask femio answer (owner 2026-11-27).
//
// Why it exists: after femio answers, what she asked is often worth keeping: the symptoms she
// named belong in today's log, and the question with its answer belongs in her visit handout.
// This file holds the pure rules; the card in `features/assistant/save_to_record_card.dart`
// only shows them and calls `withAskSaved` after she taps Save. Two safety lines live here:
// the terms come from HER question only (never from the answer, which may be model text), and
// only keys the log vocabulary already knows can be returned.

import '../../data/profile.dart';
import 'log_phrases.dart';
import 'say_it_days.dart' show mergeIntoDayLog;
import 'visit_worry.dart' show withVisitPrep;

/// Longest answer excerpt kept in a visit note, in characters, so the handout stays readable.
const maxNoteAnswerLength = 280;

/// The log terms named in [question], read with the same phrase rules as "Say it". Flow and
/// ovulation-test results are not offered here: a question is not a report of her day.
/// Returns vocabulary keys in vocabulary order; empty when the rules find nothing.
List<String> termsFromQuestion(String question) =>
    draftFromNote(question.replaceAll(_arabicWhat, ' ')).terms;

/// The Arabic question word "ما" ("what") before a question phrase ("ما الذي يخفف مغص"). The
/// phrase rules read a bare "ما" as a negation ("ما عندي مغص", "I have no cramps"), which would
/// hide the term in a question, so it is taken out first.
final _arabicWhat = RegExp(
  r'(?<![؀-ۿ])ما\s+(?=الذي|هو|هي|هذا|هذه|أفضل|أسباب|اسباب|سبب|علاج|أعراض|اعراض)',
);

final _citation = RegExp(r'\s*\[\d{1,2}\]');

/// A short, plain excerpt of [answer] for a visit note: citation markers like `[1]` removed,
/// whitespace collapsed, cut at a word boundary within [maxNoteAnswerLength] and ended with an
/// ellipsis when cut. Returns an empty string for an empty answer.
String answerExcerpt(String answer) {
  final plain = answer
      .replaceAll(_citation, '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (plain.length <= maxNoteAnswerLength) return plain;
  final cut = plain.substring(0, maxNoteAnswerLength);
  final space = cut.lastIndexOf(' ');
  return '${(space > maxNoteAnswerLength ~/ 2 ? cut.substring(0, space) : cut).trimRight()}…';
}

/// [profile] with the ticked parts of the prompt applied: [terms] merged into [today]'s log
/// (nothing she already logged is removed, product rule 5) and [noteLine], when not null, added
/// to her visit questions (the next appointment's prep, or a new undated one with [newId]).
/// Called only after she taps Save. Returns [profile] unchanged when both are empty.
Profile withAskSaved(
  Profile profile,
  String today, {
  List<String> terms = const [],
  String? noteLine,
  required String newId,
}) {
  var next = profile;
  if (terms.isNotEmpty) {
    next = next.withDayLog(
      today,
      mergeIntoDayLog(
        next.logs[today] ?? const DayLog(),
        LogDraft(terms: terms),
      ),
    );
  }
  if (noteLine != null && noteLine.trim().isNotEmpty) {
    next = withVisitPrep(next, [noteLine], today, newId: newId);
  }
  return next;
}
