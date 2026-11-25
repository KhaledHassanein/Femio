// Every instruction femio gives a model, and the parsers for what comes back (ADR-078).
//
// Why it exists: prompts are product rules in prose. Keeping them in one pure file means a
// test can read them, a reviewer can check them against rule 1 (never diagnose, never
// contraception), and no screen writes its own. On-device prompts stay short and in English,
// the language Gemini Nano is validated for; the model is asked for keys and ids, not prose.

import 'dart:convert';

import '../log_vocabulary.g.dart';
import 'log_phrases.dart';

/// Output budget for on-device calls; Google advises staying under 256 tokens.
const onDeviceMaxOutputTokens = 200;

/// The log keys a model may suggest from a note: every term except intercourse, which she
/// only ever logs herself.
final Set<String> modelLogKeys = {
  for (final t in logTerms)
    if (t.dimension != LogDimension.intercourse) t.key,
};

/// Instruction for turning her note into log keys. Runs only on the phone.
String extractionPrompt(String note) {
  final keys = modelLogKeys.join(', ');
  return '''
You convert a short personal health note into tracker entries.
The note may be in English, Arabic (including Egyptian or Gulf dialect), French or Spanish.
Allowed symptom and mood keys: $keys.
Allowed flow values: ${flowLevels.join(', ')}.
Allowed ovulation test values: ${phraseOpkResults.join(', ')}.
Only include what the note clearly says she has. Ignore anything she says she does not have.
Reply with JSON only, no other text, in this shape:
{"terms": ["key"], "flow": null, "opk": null}

Note: """$note"""''';
}

/// What the model suggested for a note, before [mergeDrafts] keeps only known values.
class ModelLogSuggestion {
  const ModelLogSuggestion({this.terms = const [], this.flow, this.opk});
  final List<String> terms;
  final String? flow;
  final String? opk;
}

/// Reads the model's JSON reply to [extractionPrompt], keeping only values that were offered
/// ([modelLogKeys], [flowLevels], [phraseOpkResults]). Returns an empty suggestion for anything
/// else, so a bad reply can only add nothing, and a reply of invented keys counts as unusable.
ModelLogSuggestion parseExtraction(String reply) {
  final json = _firstJsonObject(reply);
  if (json == null) return const ModelLogSuggestion();
  final terms = json['terms'];
  final flow = json['flow'];
  final opk = json['opk'];
  return ModelLogSuggestion(
    terms: terms is List
        ? <String>{
            for (final t in terms)
              if (t is String && modelLogKeys.contains(t)) t,
          }.toList()
        : const [],
    flow: flow is String && flowLevels.contains(flow) ? flow : null,
    opk: opk is String && phraseOpkResults.contains(opk) ? opk : null,
  );
}

/// English names of the app's languages, for telling a model which language to answer in.
const languageNames = {'en': 'English', 'ar': 'Arabic', 'fr': 'French', 'es': 'Spanish'};

/// What a model must reply when the passages do not answer the question.
const notCoveredReply = 'NOT_COVERED';

/// The most words an answer may have.
const maxAnswerWords = 110;

/// Instruction for answering [question] from the numbered registry [passages] only. Used on the
/// phone with her own words, and (through `CloudPrompt.answer`) in the cloud with a redacted
/// question. The model may only select and restate; every sentence must cite a passage number.
String answerPrompt(String question, List<({String publisher, String text})> passages, String languageCode) {
  final numbered = [
    for (var i = 0; i < passages.length; i++) '[${i + 1}] (${passages[i].publisher}) ${passages[i].text}',
  ].join('\n');
  return '''
Answer the health question using ONLY the numbered passages from trusted health sources below.
- Use only facts stated in the passages. Add nothing from your own knowledge.
- End every sentence with the number of the passage it comes from, like [1].
- Never diagnose, never say what she has, never give a medicine or dose, never advise on avoiding pregnancy.
- If the passages do not answer the question, reply exactly: $notCoveredReply
- Answer in ${languageNames[languageCode] ?? 'English'}, in plain words, in at most $maxAnswerWords words.

Passages:
$numbered

Question: """$question"""''';
}

/// A model's answer with the passage numbers it cited (1-based).
class CitedAnswer {
  const CitedAnswer(this.text, this.cited);
  final String text;
  final Set<int> cited;
}

final _citation = RegExp(r'\[(\d{1,2})\]');

/// Reads a reply to [answerPrompt] over [passageCount] passages. Returns null when the model
/// said it is not covered, cited nothing, or cited a passage that does not exist: an answer that
/// cannot show where it came from is not shown.
CitedAnswer? parseAnswer(String reply, int passageCount) {
  final text = reply.trim();
  if (text.isEmpty || text.contains(notCoveredReply)) return null;
  final cited = {for (final m in _citation.allMatches(text)) int.parse(m.group(1)!)};
  if (cited.isEmpty || cited.any((n) => n < 1 || n > passageCount)) return null;
  final words = text.split(RegExp(r'\s+'));
  final cut = words.length > maxAnswerWords * 1.3 ? '${words.take((maxAnswerWords * 1.3).round()).join(' ')}…' : text;
  return CitedAnswer(cut, cited);
}

/// Instruction for putting reviewed tips in order for her. [facts] are plain English lines;
/// [candidates] maps tip id to its reviewed English text. Reply: JSON ids only.
String tipsPrompt(List<String> facts, Map<String, String> candidates, int pick) {
  final list = candidates.entries.map((e) => '- ${e.key}: ${e.value}').join('\n');
  return '''
Facts about a woman using a health tracker:
${facts.map((f) => '- $f').join('\n')}

Choose the $pick tips from this list that would help her most, most helpful first.
$list

Reply with JSON only: {"ids": ["id"]}''';
}

/// The visit-summary question ids a model may choose from, with their English text, so the
/// on-device model can pick the most relevant ones. The text she reads comes from the ARB
/// files, never from the model.
String visitQuestionsPrompt(String factsInEnglish, Map<String, String> candidates, int pick) {
  final list = candidates.entries.map((e) => '- ${e.key}: ${e.value}').join('\n');
  return '''
A woman is preparing for a clinic visit. Facts from her own tracker:
$factsInEnglish

Choose the $pick questions from this list that matter most for her visit, most important first.
$list

Reply with JSON only: {"ids": ["id"]}''';
}

/// Reads the model's id list, keeping only ids in [allowed], in the model's order, at most [pick].
List<String> parseQuestionIds(String reply, Iterable<String> allowed, int pick) {
  final json = _firstJsonObject(reply);
  final ids = json?['ids'];
  if (ids is! List) return const [];
  final ok = allowed.toSet();
  return <String>{
    for (final id in ids)
      if (id is String && ok.contains(id)) id,
  }.take(pick).toList();
}

Map<String, Object?>? _firstJsonObject(String text) {
  final start = text.indexOf('{');
  final end = text.lastIndexOf('}');
  if (start < 0 || end <= start) return null;
  try {
    final decoded = jsonDecode(text.substring(start, end + 1));
    return decoded is Map<String, Object?> ? decoded : null;
  } catch (_) {
    return null;
  }
}
