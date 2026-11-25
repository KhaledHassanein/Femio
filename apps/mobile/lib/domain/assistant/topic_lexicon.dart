// Health topics in four languages, so a question in any of them finds English source passages
// (ADR-078 §3, trusted-source registry).
//
// Why it exists: the registry's passages are verbatim English text from US public-domain
// health pages, but she asks in English, Arabic (Egyptian, Gulf or standard), French or
// Spanish. Translating the question would need a model; this table does not. Both the
// question and each passage are reduced to topic ids, and retrieval compares ids. Phrases are
// matched after `normalise`, so spelling variants and Arabic prefixes need no extra entries.

import 'text_normal.dart';
import 'topic_table.dart';

export 'topic_table.dart' show topics;

/// A topic and how much a match on it counts. Broad topics ("doctor", "how long") help rank
/// but can never make a passage relevant on their own.
class Topic {
  const Topic(this.id, this.phrases, {this.broad = false});
  final String id;
  final List<String> phrases;
  final bool broad;
}

final _normalisedTopics = [
  for (final t in topics) (t, [for (final p in t.phrases) words(p)]),
];

/// The topic ids found in [text] in any of the four languages. Empty for text with no topic.
Set<String> topicsOf(String text) {
  final w = words(text);
  if (w.isEmpty) return const {};
  return {
    for (final (topic, phrases) in _normalisedTopics)
      if (phrases.any((p) => findPhrase(w, p) >= 0)) topic.id,
  };
}

/// True for a topic that ranks but cannot make a passage relevant by itself.
bool isBroadTopic(String id) => topics.any((t) => t.id == id && t.broad);
