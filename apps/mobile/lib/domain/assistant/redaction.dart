// The only door to the cloud model (ADR-078 §3).
//
// Why it exists: "Ask femio" may use Google's cloud model when the phone has no Gemini Nano,
// but only for a question that says nothing about her. This file decides that, and it is the
// only place a [CloudSafeText] can be made: its constructor is private, so the channel method
// that may fall back to the cloud cannot be called with anything that skipped these checks.
//
// Two rules, both on the phone:
// 1. A question in the first person about her body or her plans ("my period is late",
//    "عندي مغص", "je suis enceinte") stays on the device. Better a guide link than a leak.
// 2. Anything left is stripped of numbers, dates, contacts and links before it may leave.

import 'text_normal.dart';

/// Text that has passed [toCloudSafe]: no first-person health statement, no digits, no
/// contacts or links, at most [maxCloudQuestionChars] characters.
class CloudSafeText {
  const CloudSafeText._(this.value);

  /// The redacted question, as it will be sent.
  final String value;
}

/// The longest question the cloud path accepts; longer ones are cut at a word boundary.
const maxCloudQuestionChars = 300;

/// Words that make a question about her rather than about a topic. Matched as whole words
/// after [normalise], so "my" does not match "myth".
const _firstPerson = [
  // English (normalise turns "I'm" into "i m", so "i" covers the contractions)
  'i', 'me', 'my', 'mine', 'myself', 'our', 'we', 'us', 'wife', 'husband',
  // Arabic (Egyptian, Gulf, standard)
  'انا',
  'عندي',
  'عندى',
  'معايا',
  'ليا',
  'حاسه',
  'بحس',
  'احس',
  'دورتي',
  'جسمي',
  'بطني',
  'جوزي',
  'زوجي',
  'بقالي',
  'لي',
  'اتاخرت',
  'حملي',
  'نفسي',
  // French
  'je', 'j', 'moi', 'mon', 'ma', 'mes', 'nous', 'notre', 'mari',
  // Spanish
  'yo', 'mi', 'mis', 'tengo', 'estoy', 'me', 'nosotros', 'nuestro', 'marido', 'esposo',
];

final _email = RegExp(r'\S+@\S+');
final _url = RegExp(r'(https?://|www\.)\S+', caseSensitive: false);
final _digits = RegExp(r'[0-9٠-٩۰-۹]+');
final _spaces = RegExp(r'\s+');

/// True when [question] talks about her own body, cycle, pregnancy or partner.
bool isAboutHer(String question) => words(question).any(_firstPerson.contains);

/// Returns [question] made safe for the cloud model, or null when it must stay on the phone
/// (it is about her, or nothing is left after redaction).
CloudSafeText? toCloudSafe(String question) {
  if (isAboutHer(question)) return null;
  var text = question
      .replaceAll(_email, ' ')
      .replaceAll(_url, ' ')
      .replaceAll(_digits, ' ')
      .replaceAll(_spaces, ' ')
      .trim();
  if (text.length > maxCloudQuestionChars) {
    final cut = text.lastIndexOf(' ', maxCloudQuestionChars);
    text = text.substring(0, cut > 0 ? cut : maxCloudQuestionChars);
  }
  if (words(text).length < 2) return null;
  return CloudSafeText._(text);
}
