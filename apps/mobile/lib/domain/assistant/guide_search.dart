// Finds the guides that answer a question, on the phone (ADR-078 §1, "the model reads").
//
// Why it exists: "Ask femio" answers only from Femio's own reviewed guides. This search picks
// the guides and the paragraphs a model may read; with no model at all, the guide cards it
// returns are still the answer. Plain word overlap with light Arabic and English stemming is
// enough for 110 guides and needs no index, no embedding model and no network.

import 'text_normal.dart';

/// A guide reduced to what search needs: its slug, title, summary and paragraphs.
class GuideText {
  const GuideText({required this.slug, required this.title, required this.excerpt, required this.paragraphs});
  final String slug;
  final String title;
  final String excerpt;

  /// The body as plain paragraphs, in reading order.
  final List<String> paragraphs;
}

/// One search result: the guide and the paragraphs that matched best.
class GuideHit {
  const GuideHit({required this.guide, required this.score, required this.passages});
  final GuideText guide;
  final int score;

  /// Up to [maxPassagesPerGuide] paragraphs, most relevant first.
  final List<String> passages;
}

/// How many guides an answer may cite.
const maxGuideHits = 3;

/// How many paragraphs of each guide a model may read.
const maxPassagesPerGuide = 2;

/// The most characters of guide text sent to a model in total. Gemini Nano takes about 4,000
/// tokens per request; Arabic costs more tokens per character than English, so this stays
/// well under the limit with the instructions and the question added.
const maxPassageChars = 2400;

const _stopWords = {
  // English
  'a', 'an', 'the', 'is', 'are', 'was', 'be', 'to', 'of', 'in', 'on', 'for', 'and', 'or', 'with', 'what', 'how',
  'when', 'why', 'which', 'who', 'can', 'do', 'does', 'it', 'this', 'that', 'about', 'should', 'there', 'any', 'get',
  // Arabic
  'في', 'من', 'على', 'عن', 'الى', 'هل', 'ما', 'ماذا', 'ايه', 'ازاي', 'كيف', 'امتى', 'متى', 'ليه', 'لماذا', 'هو', 'هي',
  'ده', 'دي', 'هذا', 'هذه', 'او', 'و', 'يا', 'اللي', 'التي', 'الذي', 'كده', 'ممكن', 'يعني',
  // French
  'le', 'la', 'les', 'un', 'une', 'des', 'de', 'du', 'et', 'ou', 'est', 'que', 'qui', 'quoi', 'comment', 'pourquoi',
  'quand', 'pour', 'dans', 'sur', 'avec', 'ce', 'cette',
  // Spanish
  'el', 'los', 'las', 'una', 'unos', 'y', 'o', 'es', 'como', 'por', 'para', 'en', 'con', 'cuando', 'del', 'al',
};

/// Reduces a word to a rough stem so "periods" finds "period" and "الدورة" finds "دوره".
String _stem(String w) {
  var s = w;
  for (final p in ['وال', 'بال', 'فال', 'لل', 'ال']) {
    if (s.length > p.length + 2 && s.startsWith(p)) {
      s = s.substring(p.length);
      break;
    }
  }
  if (s.length > 4 && s.endsWith('ies')) return '${s.substring(0, s.length - 3)}y';
  if (s.length > 3 && s.endsWith('s') && !s.endsWith('ss')) return s.substring(0, s.length - 1);
  return s;
}

Set<String> _terms(String text) => {
  for (final w in words(text))
    if (w.length > 1 && !_stopWords.contains(w)) _stem(w),
};

int _overlap(Set<String> query, String text) {
  final t = _terms(text);
  return query.where(t.contains).length;
}

/// Ranks [guides] for [question] and returns at most [maxGuideHits], best first, with their
/// best paragraphs. Title matches weigh three, the summary two, the body one (capped so a long
/// guide cannot win on length). Returns an empty list when nothing overlaps.
List<GuideHit> searchGuides(String question, List<GuideText> guides) {
  final query = _terms(question);
  if (query.isEmpty) return const [];
  final hits = <GuideHit>[];
  for (final g in guides) {
    final scored = [for (final p in g.paragraphs) (p, _overlap(query, p))]..sort((a, b) => b.$2.compareTo(a.$2));
    final body = scored.take(3).fold<int>(0, (sum, e) => sum + e.$2);
    final score = 3 * _overlap(query, g.title) + 2 * _overlap(query, g.excerpt) + body;
    if (score == 0) continue;
    final passages = [
      for (final (p, s) in scored.take(maxPassagesPerGuide))
        if (s > 0) p,
    ];
    hits.add(GuideHit(guide: g, score: score, passages: passages.isEmpty ? [g.excerpt] : passages));
  }
  hits.sort((a, b) => b.score.compareTo(a.score));
  return hits.take(maxGuideHits).toList();
}

/// The guide text a model may read for [hits], cut to [maxPassageChars] in total, each block
/// headed by its guide's title so the answer can name where it came from.
String passagesFor(List<GuideHit> hits) {
  final buffer = StringBuffer();
  for (final h in hits) {
    for (final p in [h.guide.title, ...h.passages]) {
      final remaining = maxPassageChars - buffer.length;
      if (remaining <= 0) return buffer.toString();
      final line = p.length > remaining ? p.substring(0, remaining) : p;
      buffer.writeln(identical(p, h.guide.title) ? '## $line' : line);
    }
    buffer.writeln();
  }
  return buffer.toString().trim();
}
