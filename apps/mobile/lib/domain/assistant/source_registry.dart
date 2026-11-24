// The trusted-source registry: what "Ask femio" may answer from, and how it finds it on the
// phone (ADR-078 §3 as revised by ADR-079; owner 2026-11-24: "I need the AI to get from
// trusted sources", answered by "bundled registry").
//
// Why it exists: an answer is only as good as what it stands on. The registry is a versioned
// file shipped inside the app (`assets/trusted_sources/registry.json`), so it works offline
// and every answer names a publisher, a link and a date. Two kinds of entry:
// - a passage: verbatim text from a US federal public-domain page (CDC, MedlinePlus, Office on
//   Women's Health, NIH institutes and offices), which a model may read and summarise and which
//   the app may show word for word;
// - a link: a page from a source whose text Femio may not copy (WHO, NHS, ACOG, RCOG, NICE,
//   Saudi MOH), shown as "read more" with a one-line description Femio wrote.
// The licence rule is enforced here, when the file is read: a passage from a publisher not on
// the public-domain list is rejected, so a copyrighted page cannot slip into the app.

import 'text_normal.dart';
import 'topic_lexicon.dart';

/// Whether an entry carries text a model may read, or only a link.
enum SourceKind { passage, link }

/// Publishers whose pages are US federal government works (17 U.S.C. §105), so their text
/// may be bundled and shown verbatim.
const publicDomainPublishers = {
  'CDC',
  'MedlinePlus (NLM)',
  "Office on Women's Health (womenshealth.gov)",
  'NICHD (NIH)',
  'NIDDK (NIH)',
  'NCI (NIH)',
  // Added by the coverage pass of 2026-11-24 (ADR-079 addendum): also NIH, also §105 works.
  'NIA (NIH)',
  'NIMH (NIH)',
  'NHLBI (NIH)',
  'NIH ODS',
  'NIAMS (NIH)',
};

/// Publishers Femio links to but never copies from.
const linkOnlyPublishers = {'WHO', 'NHS', 'ACOG', 'RCOG', 'NICE', 'Saudi MOH'};

/// Languages an entry's page may be written in; a missing `lang` means English.
const registryLanguages = {'en', 'ar', 'fr', 'es'};

/// One registry entry, as read from the bundled file.
class SourceEntry {
  const SourceEntry._({
    required this.id,
    required this.kind,
    required this.publisher,
    required this.title,
    required this.url,
    required this.retrieved,
    required this.reviewed,
    required this.text,
    required this.topicIds,
    required this.goals,
    required this.lang,
    required this.vocabulary,
  });

  /// Reads one entry. Throws [FormatException] when a field is missing, the link is not https,
  /// or the publisher is not allowed for the entry's kind.
  factory SourceEntry.fromJson(Map<String, Object?> j) {
    String req(String k) {
      final v = j[k];
      if (v is! String || v.trim().isEmpty) throw FormatException('registry entry missing "$k"', j['id']);
      return v.trim();
    }

    final id = req('id');
    final kind = switch (j['kind']) {
      'passage' => SourceKind.passage,
      'link' => SourceKind.link,
      _ => throw FormatException('registry entry $id has an unknown kind', j['kind']),
    };
    final publisher = req('publisher');
    final allowed = kind == SourceKind.passage ? publicDomainPublishers : linkOnlyPublishers;
    if (!allowed.contains(publisher)) {
      throw FormatException('registry entry $id: "$publisher" is not allowed for a ${kind.name}');
    }
    final url = req('url');
    if (!url.startsWith('https://')) throw FormatException('registry entry $id: link must be https', url);
    final text = kind == SourceKind.passage ? req('text') : req('summaryEn');
    final topicWords = [for (final t in (j['topics'] as List?) ?? const []) '$t'];
    final lang = j['lang'] ?? 'en';
    if (lang is! String || !registryLanguages.contains(lang)) {
      throw FormatException('registry entry $id: unknown language', lang);
    }
    return SourceEntry._(
      id: id,
      kind: kind,
      publisher: publisher,
      title: req('title'),
      url: url,
      retrieved: req('retrieved'),
      reviewed: j['reviewed'] is String ? j['reviewed'] as String : null,
      text: text,
      // Topics are computed once, from the title, the editor's keywords and the text.
      topicIds: topicsOf([req('title'), ...topicWords, text].join(' . ')),
      goals: {for (final g in (j['goals'] as List?) ?? const []) '$g'},
      lang: lang,
      vocabulary: {...words('${req('title')} ${topicWords.join(' ')} $text')},
    );
  }

  final String id;
  final SourceKind kind;
  final String publisher;
  final String title;
  final String url;

  /// The date Femio copied the page (yyyy-mm-dd).
  final String retrieved;

  /// The page's own last-reviewed date, when it shows one.
  final String? reviewed;

  /// The verbatim passage, or for a link the one-line description Femio wrote.
  final String text;

  /// Topic ids from [topicsOf].
  final Set<String> topicIds;

  /// Life stages the entry is written for (period, ttc, pregnant, menopause); may be empty.
  final Set<String> goals;

  /// The language of the page itself (en, ar, fr or es). Passages are English today.
  final String lang;

  /// The entry's normalised words (title, keywords, text), for the same-word ranking bonus.
  final Set<String> vocabulary;
}

/// The whole registry, with the version shown in Settings and in every answer's footer.
class SourceRegistry {
  const SourceRegistry._(this.version, this.entries);

  /// Reads the bundled file. Throws [FormatException] on any bad entry or a repeated id, so a
  /// broken registry fails a test instead of reaching her.
  factory SourceRegistry.fromJson(Map<String, Object?> j) {
    final version = j['version'];
    if (version is! String || version.isEmpty) throw const FormatException('registry has no version');
    final entries = [
      for (final e in (j['entries'] as List?) ?? const [])
        if (e is Map<String, Object?>) SourceEntry.fromJson(e) else throw FormatException('bad registry entry', e),
    ];
    final ids = <String>{};
    for (final e in entries) {
      if (!ids.add(e.id)) throw FormatException('registry id repeated', e.id);
    }
    return SourceRegistry._(version, entries);
  }

  static const empty = SourceRegistry._('none', []);

  final String version;
  final List<SourceEntry> entries;
}

/// How many passages one answer may stand on, and how many "read more" links it shows.
const maxAnswerPassages = 3;
const maxAnswerLinks = 2;

/// The weight of a specific topic match; a broad topic counts one.
const _specificTopicWeight = 3;

/// The most a passage gains from sharing her own uncommon words ("mastitis", "bilirubin"):
/// enough to order passages that share the same topics, never enough to outrank a topic.
const _maxSameWordBonus = 2;

/// Words too common in this registry to say anything about which passage fits best.
const _commonWords = {
  'about', 'after', 'before', 'being', 'could', 'during', 'having', 'normal', 'should', 'their',
  'there', 'these', 'which', 'would', 'women', 'woman', 'pregnant', 'pregnancy', 'period', 'periods',
};

/// Her words that count for the same-word bonus: five letters or more and not in [_commonWords].
Set<String> _uncommonWords(String question) =>
    {for (final w in words(question)) if (w.length >= 5 && !_commonWords.contains(w)) w};

/// How many specific topics a passage must share with the question to count as answering it:
/// all of them when she named one, at least two when she named more.
int _requiredOverlap(int askedSpecific) => askedSpecific < 2 ? askedSpecific : 2;

/// What the registry holds for one question.
class RegistryAnswer {
  const RegistryAnswer({required this.passages, required this.links});
  final List<SourceEntry> passages;
  final List<SourceEntry> links;

  /// True when no passage answers the question: the app says "not covered" instead of guessing.
  bool get notCovered => passages.isEmpty;
}

/// Finds the passages and links for [question] in [registry], on the phone. A passage answers
/// only when it shares enough specific topics with the question ([_requiredOverlap]); a link
/// needs one. Entries written for her life stage [goal] rank one point higher but are never
/// made relevant by it. A link whose page is in her language [lang] ranks one point higher.
/// Never fails; returns an empty answer for a question with no topic.
RegistryAnswer searchRegistry(String question, SourceRegistry registry, {String? goal, String? lang}) {
  final asked = topicsOf(question);
  final ownWords = _uncommonWords(question);
  final specific = asked.where((t) => !isBroadTopic(t)).toSet();
  if (specific.isEmpty) return const RegistryAnswer(passages: [], links: []);
  final scored = <(SourceEntry, int, bool)>[];
  for (final e in registry.entries) {
    final shared = e.topicIds.intersection(asked);
    final sharedSpecific = shared.where(specific.contains).length;
    if (sharedSpecific == 0) continue;
    final relevant = sharedSpecific >= _requiredOverlap(specific.length);
    var score = 0;
    for (final t in shared) {
      score += isBroadTopic(t) ? 1 : _specificTopicWeight;
    }
    final same = ownWords.where(e.vocabulary.contains).length;
    score += same < _maxSameWordBonus ? same : _maxSameWordBonus;
    if (goal != null && e.goals.contains(goal)) score += 1;
    if (lang != null && e.kind == SourceKind.link && e.lang == lang) score += 1;
    scored.add((e, score, relevant));
  }
  // Highest score first; on a tie, the entry with fewer specific topics she did not ask about
  // is the more focused one (broad topics such as "doctor" or "age" do not count against it).
  int offTopic(SourceEntry e) => e.topicIds.where((t) => !isBroadTopic(t) && !asked.contains(t)).length;
  scored.sort((a, b) {
    final byScore = b.$2.compareTo(a.$2);
    return byScore != 0 ? byScore : offTopic(a.$1).compareTo(offTopic(b.$1));
  });
  return RegistryAnswer(
    passages: [
      for (final (e, _, relevant) in scored)
        if (e.kind == SourceKind.passage && relevant) e,
    ].take(maxAnswerPassages).toList(),
    links: [
      for (final (e, _, _) in scored)
        if (e.kind == SourceKind.link) e,
    ].take(maxAnswerLinks).toList(),
  );
}
