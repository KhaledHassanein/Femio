// Turns a guide's Lexical body into plain paragraphs for the related-guides search (ADR-078).
//
// Why it exists: guides are stored as Lexical JSON for rendering; the search in
// `domain/assistant/guide_search.dart` needs plain text and must not know the storage shape.

import '../domain/assistant/guide_search.dart';
import 'library.dart';

/// [article] as a [GuideText]: its slug, title, summary and one string per block.
GuideText guideTextOf(Article article) {
  final root = (article.body['root'] as Map?) ?? article.body;
  final paragraphs = <String>[
    for (final block in (root['children'] as List?) ?? const [])
      if (block is Map) _text(block).trim(),
  ].where((p) => p.isNotEmpty).toList();
  return GuideText(slug: article.slug, title: article.title, excerpt: article.excerpt, paragraphs: paragraphs);
}

String _text(Map<dynamic, dynamic> node) {
  if (node['type'] == 'text') return '${node['text'] ?? ''}';
  if (node['type'] == 'linebreak') return ' ';
  final children = (node['children'] as List?) ?? const [];
  final sep = node['type'] == 'list' ? ' ' : '';
  return children.whereType<Map<dynamic, dynamic>>().map(_text).join(sep);
}
