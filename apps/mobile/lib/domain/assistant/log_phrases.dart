// "Say it in your words": everyday phrases → the shared log vocabulary (ADR-078, R7.1).
//
// Why it exists: she should be able to write "مغص من الصبح وتعبانة" or "cramps since this
// morning, so tired" and get the same chips she would have tapped. This file is the rule
// floor that works on every phone and in all four languages; on a phone with Gemini Nano the
// model's suggestions are merged on top (`mergeDrafts`), but only keys this vocabulary knows
// can ever reach her log. Nothing here decides anything medical: it maps words to the
// existing chips, and she confirms every one before it is saved.
//
// Intercourse is deliberately absent (OD-5, conservative register): it is only ever tapped.

import '../log_vocabulary.g.dart';
import 'log_phrases_lexicon.dart';
import 'text_normal.dart';

export 'log_phrases_lexicon.dart' show termPhrases, flowPhrases, opkPhrases;

/// Ovulation-test results a phrase can set (a subset of the generated `opkResults`).
const phraseOpkResults = ['negative', 'positive'];

/// Words that turn the next few words into a denial ("no cramps", "مفيش مغص").
const _negations = [
  'no',
  'not',
  'without',
  'never',
  'didnt',
  'dont',
  'isnt',
  'havent',
  'none',
  'مفيش',
  'مافيش',
  'مش',
  'ما',
  'مو',
  'بدون',
  'ولا',
  'مافي',
  'ماكانش',
  'لا',
  'pas',
  'sans',
  'aucun',
  'aucune',
  'jamais',
  'sin',
  'ni',
  'nunca',
];

/// How many words before a phrase a negation still applies to.
const _negationReach = 3;

/// What one note turns into before she confirms it: chips to add, maybe a flow, maybe an
/// ovulation-test result. Every value is one the log screen already knows.
class LogDraft {
  const LogDraft({this.terms = const [], this.flow, this.opk});

  /// Vocabulary keys, in the order the vocabulary lists them, without duplicates.
  final List<String> terms;

  /// One of [flowLevels], or null.
  final String? flow;

  /// One of [phraseOpkResults], or null.
  final String? opk;

  bool get isEmpty => terms.isEmpty && flow == null && opk == null;
}

final Set<String> _knownTerms = {for (final t in logTerms) t.key};

/// Reads [note] with the phrase rules above and returns what it names. A phrase preceded
/// within three words by a negation ("no cramps", "مفيش صداع") is skipped.
LogDraft draftFromNote(String note) {
  final text = words(note);
  if (text.isEmpty) return const LogDraft();
  bool says(List<String> phrases) =>
      phrases.any((p) => _affirmed(text, words(p)));

  final found = <String>{
    for (final entry in termPhrases.entries)
      if (_knownTerms.contains(entry.key) && says(entry.value)) entry.key,
  };
  String? flow;
  for (final level in ['heavy', 'light', 'medium', 'spotting']) {
    if (says(flowPhrases[level]!)) {
      flow = level;
      break;
    }
  }
  String? opk;
  for (final result in phraseOpkResults) {
    if (says(opkPhrases[result]!)) {
      opk = result;
      break;
    }
  }
  return LogDraft(terms: _inVocabularyOrder(found), flow: flow, opk: opk);
}

/// Combines the rule draft with a model's suggestion. Anything the model names that is not
/// in the vocabulary, the flow levels or the test results is dropped here, so a model can
/// never write a value the app does not know. The rules win when both name a flow.
LogDraft mergeDrafts(
  LogDraft rules, {
  Iterable<String> modelTerms = const [],
  String? modelFlow,
  String? modelOpk,
}) {
  final terms = {...rules.terms, ...modelTerms.where(_knownTerms.contains)};
  return LogDraft(
    terms: _inVocabularyOrder(terms),
    flow: rules.flow ?? (flowLevels.contains(modelFlow) ? modelFlow : null),
    opk: rules.opk ?? (phraseOpkResults.contains(modelOpk) ? modelOpk : null),
  );
}

List<String> _inVocabularyOrder(Set<String> keys) => [
  for (final t in logTerms)
    if (keys.contains(t.key)) t.key,
];

bool _affirmed(List<String> text, List<String> phrase) {
  var start = 0;
  while (start <= text.length - phrase.length) {
    final at = findPhrase(text.sublist(start), phrase);
    if (at < 0) return false;
    final index = start + at;
    final before = text.sublist(
      (index - _negationReach).clamp(0, index),
      index,
    );
    if (!before.any(_negations.contains)) return true;
    start = index + 1;
  }
  return false;
}
