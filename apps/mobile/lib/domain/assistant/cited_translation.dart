// Translating a cited answer without losing where each sentence came from (ADR-087 §6).
//
// Why it exists: an answer femio shows must cite a trusted passage after every sentence, like
// "[1]". A translator may move, drop or reshape those marks, so the answer is cut into pieces
// that each end in their marks; only the words are translated and the marks are put back
// exactly as they were. If any piece fails, the whole translation fails and the caller keeps
// the untranslated path: a half-translated answer is never shown.

/// One piece of a cited answer: its words and the citation marks that close it ("" at the end).
typedef CitedPiece = ({String words, String marks});

/// Sentence-closing marks in the four app languages.
final _leadingPunctuation = RegExp(r'^[.!?;:,،؛؟]+');

final _piece = RegExp(r'([^\[]*?)((?:\s*\[\d{1,2}\])+)|([^\[]+$)');

/// Cuts [answer] into pieces that each end in their citation marks. Text with no marks at the
/// end becomes a last piece with empty marks.
List<CitedPiece> citedPieces(String answer) => [
      for (final m in _piece.allMatches(answer))
        if (m.group(3) != null) (words: m.group(3)!, marks: '') else (words: m.group(1)!, marks: m.group(2)!),
    ];

/// [answer] with each piece's words passed through [translate] and its marks kept as they
/// were. Returns null when a piece cannot be translated.
Future<String?> translateCited(String answer, Future<String?> Function(String words) translate) async {
  final out = StringBuffer();
  for (final p in citedPieces(answer)) {
    // Punctuation that closes the previous sentence ("[1]. Next") stays with that sentence.
    final lead = _leadingPunctuation.stringMatch(p.words.trimLeft()) ?? '';
    out.write(lead);
    final words = p.words.trimLeft().substring(lead.length).trim();
    final marks = p.marks.replaceAll(RegExp(r'\s+'), '');
    if (words.isEmpty) {
      out.write(marks);
      continue;
    }
    final translated = await translate(words);
    if (translated == null || translated.trim().isEmpty) return null;
    if (out.isNotEmpty) out.write(' ');
    out
      ..write(translated.trim())
      ..write(marks.isEmpty ? '' : ' $marks');
  }
  return out.isEmpty ? null : out.toString();
}
