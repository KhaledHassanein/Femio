// Spots a question that asks femio to say whether she has a condition (R7.14, product rule 1).
//
// Why it exists: femio never diagnoses. A birth-control question is stopped outright, but "Do I
// have PCOS?" deserves an answer about PCOS, just not a verdict. So this rule does not stop the
// search: the screen shows a fixed sentence first ("only a clinician can tell"), then the
// sourced passages. It is a word rule in four languages, like `safety.dart`, so it behaves the
// same with or without a model, and a test proves each phrase.
//
// A question counts when it has a cue ("do I have", "هل عندي", "est-ce que j'ai", "¿tengo")
// and names a condition from the topic table. Without a condition ("Do I have to fast before
// the test?") it is an ordinary question.

import 'text_normal.dart';
import 'topic_lexicon.dart';

/// Topic ids that name a condition or a state only a clinician or a test can confirm.
const diagnosisTopics = {
  'pcos',
  'endometriosis',
  'adenomyosis',
  'fibroids',
  'thyroid',
  'fertility',
  'poi',
  'diabetes',
  'bloodPressure',
  'menopause',
  'anemia',
  'cholestasis',
  'pregnancy',
  'pregnancyTest',
  'loss',
  'babyBlues',
  'mood',
  'breastIssues',
  'urinary',
  'vaginalHealth',
  'toxicShock',
};

/// Cues anywhere in the question.
const _cues = [
  'do i have',
  'have i got',
  'could i have',
  'might i have',
  'do you think i have',
  'i think i have',
  'how do i know if i have',
  'how can i tell if i have',
  'how do i know if i m',
  'am i infertile',
  'am i in menopause',
  'am i pregnant',
  'am i going through',
  'هل عندي',
  'هل انا عندي',
  'يكون عندي',
  'ممكن عندي',
  'عندي ولا لا',
  'هل انا مصابه',
  'هل انا دخلت',
  'هل انا حامل',
  'ازاي اعرف ان عندي',
  'ازاي اعرف اذا عندي',
  'كيف اعرف ان عندي',
  'كيف اعرف اذا عندي',
  'est ce que j ai',
  'ai je',
  'suis je',
  'est ce que je suis',
  'comment savoir si j ai',
  'comment savoir si je suis',
  'je pense avoir',
  'sera que tengo',
  'creo que tengo',
  'como saber si tengo',
  'como se si tengo',
  'puede que tenga',
];

/// "Do I have to…", "why do I have…": a question about what to do or why, not whether she has
/// something.
const _notCues = ['why do i have', 'do i have to', 'have i got to', 'est ce que j ai besoin', 'tengo que'];

/// Words that are a cue only when they open a question ("¿Tengo SOP?", "Am I…?"); inside a
/// sentence they are usually a statement ("tengo SOP y…").
const _openers = ['tengo', 'soy', 'estoy', 'am i'];

/// True when [text] asks whether she has a condition. The screen then shows the fixed
/// "only a clinician can tell" sentence before any passage. Never throws; empty text is false.
bool asksForDiagnosis(String text) {
  final w = words(text);
  if (w.isEmpty) return false;
  if (!topicsOf(text).any(diagnosisTopics.contains)) return false;
  if (_notCues.any((c) => findPhrase(w, words(c)) >= 0)) return false;
  if (_cues.any((c) => findPhrase(w, words(c)) >= 0)) return true;
  final question = text.contains('?') || text.contains('؟');
  return question && _openers.any((o) => findPhrase(w, words(o)) == 0);
}
