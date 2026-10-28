// The guide library inside the app: the reviewed articles, bundled as assets.
//
// Why it exists: the website's guides are the product's medical voice, and the app
// must carry them without a network (ADR-070). `scripts/content/build-content.mjs`
// writes `assets/content/<locale>.json` from the same source the website reads, so
// both show the same words. Loading is lazy and cached: nothing is parsed until she
// opens Learn, and nothing is parsed twice.

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// One guide as the build script writes it: the rich text is the website's Lexical
/// JSON tree, rendered by `widgets/lexical_view.dart`.
class Article {
  const Article({
    required this.slug,
    required this.title,
    required this.excerpt,
    required this.body,
    required this.sources,
    required this.reviewer,
    required this.lastReviewed,
    required this.disclaimerType,
    required this.locale,
  });

  final String slug;
  final String title;
  final String excerpt;

  /// The Lexical root node (`{"root": {...}}`).
  final Map<String, Object?> body;
  final List<ArticleSource> sources;

  /// The reviewing clinician's name, or null while review is pending.
  final String? reviewer;

  /// ISO date of the review, or null.
  final String? lastReviewed;
  final String disclaimerType;

  /// The language the text is in: her locale, or `en` when it fell back.
  final String locale;

  static Article fromJson(Map<String, Object?> j, String locale) => Article(
        slug: j['slug'] as String,
        title: j['title'] as String,
        excerpt: (j['excerpt'] as String?) ?? '',
        body: Map<String, Object?>.from((j['body'] as Map?) ?? const {}),
        sources: [
          for (final s in (j['sources'] as List?) ?? const [])
            ArticleSource(title: (s as Map)['title'] as String, url: s['url'] as String?),
        ],
        reviewer: j['reviewer'] as String?,
        lastReviewed: (j['lastReviewed'] as String?)?.substring(0, 10),
        disclaimerType: (j['disclaimerType'] as String?) ?? 'general',
        locale: locale,
      );
}

/// A cited source: the guideline or page the guide rests on.
class ArticleSource {
  const ArticleSource({required this.title, this.url});
  final String title;
  final String? url;
}

/// Slugs the wedge leads with, in the order the website's `topics.ts` lists them:
/// trying to conceive, then pregnancy, then PCOS. Everything else stays reachable
/// below (rule 2); this only decides what comes first.
const wedgeSlugs = [
  'trying-to-conceive-guide',
  'fertile-window-explained',
  'irregular-cycles-and-timing',
  'when-to-take-pregnancy-test',
  'age-and-fertility',
  'preconception-appointment',
  'pcos-and-fertility',
  'when-to-seek-fertility-help',
  'pregnancy-basics',
  'early-pregnancy-changes',
  'first-pregnancy-appointment',
  'pregnancy-warning-signs',
  'ramadan-fasting-pregnancy',
  'pcos-signs',
  'how-pcos-is-assessed',
  'pcos-lifestyle-and-weight',
  'pcos-insulin-resistance',
  'pcos-treatment-options-to-discuss',
  'pcos-hair-skin-and-mood',
];

/// Loads and caches the guides for a language, filling gaps from English.
class Library {
  Library({Future<String> Function(String path)? load}) : _load = load ?? rootBundle.loadString;
  final Future<String> Function(String path) _load;
  final Map<String, List<Article>> _cache = {};

  /// Every guide for [locale]: translated ones in her language, the rest in English
  /// (marked by [Article.locale]), ordered wedge first, then by title.
  Future<List<Article>> articles(String locale) async {
    if (_cache.containsKey(locale)) return _cache[locale]!;
    final own = await _read(locale);
    final english = locale == 'en' ? own : await _read('en');
    final bySlug = <String, Article>{for (final a in english) a.slug: a};
    for (final a in own) {
      bySlug[a.slug] = a;
    }
    final list = bySlug.values.toList()
      ..sort((a, b) {
        final ia = wedgeSlugs.indexOf(a.slug);
        final ib = wedgeSlugs.indexOf(b.slug);
        if (ia != ib) return (ia == -1 ? wedgeSlugs.length : ia).compareTo(ib == -1 ? wedgeSlugs.length : ib);
        return a.title.compareTo(b.title);
      });
    _cache[locale] = list;
    return list;
  }

  Future<List<Article>> _read(String locale) async {
    try {
      final text = await _load('assets/content/$locale.json');
      final raw = jsonDecode(text) as List;
      return [for (final j in raw) Article.fromJson(Map<String, Object?>.from(j as Map), locale)];
    } catch (_) {
      // A missing or empty file is "no translations", never a crash.
      return const [];
    }
  }
}
