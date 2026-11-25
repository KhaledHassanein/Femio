// Text normalisation shared by the assistant's rules (ADR-078).
//
// Why it exists: she types in Egyptian or Gulf Arabic, English, French or Spanish, with or
// without diacritics, accents and the many ways Arabic spells the same letter. Every rule in
// `lib/domain/assistant/` compares normalised text with normalised phrases, so one spelling
// rule lives here and nowhere else.

final _arabicMarks = RegExp('[ً-ْٰـ]'); // harakat, dagger alef, tatweel
final _punctuation = RegExp(r"[^\p{L}\p{N}\s]", unicode: true);
final _spaces = RegExp(r'\s+');

const _latinFolds = {
  'à': 'a',
  'á': 'a',
  'â': 'a',
  'ä': 'a',
  'ã': 'a',
  'ç': 'c',
  'è': 'e',
  'é': 'e',
  'ê': 'e',
  'ë': 'e',
  'ì': 'i',
  'í': 'i',
  'î': 'i',
  'ï': 'i',
  'ñ': 'n',
  'ò': 'o',
  'ó': 'o',
  'ô': 'o',
  'ö': 'o',
  'õ': 'o',
  'ù': 'u',
  'ú': 'u',
  'û': 'u',
  'ü': 'u',
  'œ': 'oe',
  '’': "'",
};

const _arabicFolds = {
  'أ': 'ا', 'إ': 'ا', 'آ': 'ا', 'ٱ': 'ا',
  'ة': 'ه', 'ى': 'ي', 'ؤ': 'و', 'ئ': 'ي',
  // Arabic-Indic and Persian digits become Western ones (ADR-069).
  '٠': '0', '١': '1', '٢': '2', '٣': '3', '٤': '4', '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9',
  '۰': '0', '۱': '1', '۲': '2', '۳': '3', '۴': '4', '۵': '5', '۶': '6', '۷': '7', '۸': '8', '۹': '9',
};

/// Lower-cases [text], folds accents and Arabic letter variants, drops diacritics and
/// punctuation, and collapses spaces. Two spellings of the same word give the same result.
///
/// Never fails; an empty or whitespace-only input returns an empty string.
String normalise(String text) {
  final lower = text.toLowerCase().replaceAll(_arabicMarks, '');
  final buffer = StringBuffer();
  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    buffer.write(_latinFolds[ch] ?? _arabicFolds[ch] ?? ch);
  }
  return buffer.toString().replaceAll(_punctuation, ' ').replaceAll(_spaces, ' ').trim();
}

/// The words of [text] after [normalise], in order.
List<String> words(String text) {
  final n = normalise(text);
  return n.isEmpty ? const [] : n.split(' ');
}

/// True when the normalised [phrase] occurs in the normalised word list [haystack] as whole
/// words. Returns the index of the first word of the first match, or -1.
int findPhrase(List<String> haystack, List<String> phrase) {
  if (phrase.isEmpty || phrase.length > haystack.length) return -1;
  outer:
  for (var i = 0; i <= haystack.length - phrase.length; i++) {
    for (var j = 0; j < phrase.length; j++) {
      if (!_wordMatches(haystack[i + j], phrase[j])) continue outer;
    }
    return i;
  }
  return -1;
}

/// Arabic glues the article and some prepositions to the word (الصداع, بالصداع, والصداع), and
/// English adds plurals; a phrase word matches when the text word is the same word with one
/// of those attachments.
bool _wordMatches(String word, String phraseWord) {
  if (word == phraseWord) return true;
  const arabicPrefixes = ['ال', 'وال', 'بال', 'لل', 'فال', 'و', 'ب', 'ف', 'ل'];
  for (final p in arabicPrefixes) {
    if (word.startsWith(p) && word.substring(p.length) == phraseWord) return true;
  }
  if (word == '${phraseWord}s' || word == '${phraseWord}es') return true;
  return false;
}
