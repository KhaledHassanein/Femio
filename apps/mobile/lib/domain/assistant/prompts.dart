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

/// Instruction for turning her note into log keys. Runs only on the phone.
String extractionPrompt(String note) {
  final keys = [
    for (final t in logTerms)
      if (t.dimension != LogDimension.intercourse) t.key,
  ].join(', ');
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

/// Reads the model's JSON reply to [extractionPrompt]. Returns an empty suggestion for
/// anything that is not the expected shape, so a bad reply can only add nothing.
ModelLogSuggestion parseExtraction(String reply) {
  final json = _firstJsonObject(reply);
  if (json == null) return const ModelLogSuggestion();
  final terms = json['terms'];
  return ModelLogSuggestion(
    terms: terms is List
        ? [
            for (final t in terms)
              if (t is String) t,
          ]
        : const [],
    flow: json['flow'] is String ? json['flow'] as String : null,
    opk: json['opk'] is String ? json['opk'] as String : null,
  );
}

/// Instruction for rewriting a personal question as a general one. Runs only on the phone,
/// so her own words never leave it; she sees and can edit the result before it is sent.
String generalisePrompt(String question) => '''
Rewrite the question below as a short, general women's health question that a public health
website could answer. Remove every personal detail: names, ages, dates, numbers, places,
her own symptoms as "I/my", partners and family. Keep the topic. Keep the language of the
original question. Reply with the rewritten question only.

Question: """$question"""''';

/// Cleans the model's rewrite: first line only, quotes trimmed, at most 300 characters.
String parseGeneralised(String reply) {
  var line = reply.trim().split('\n').firstWhere((l) => l.trim().isNotEmpty, orElse: () => '').trim();
  for (final q in ['"', '“', '”', '«', '»', "'"]) {
    if (line.startsWith(q)) line = line.substring(1);
    if (line.endsWith(q)) line = line.substring(0, line.length - 1);
  }
  return line.length > 300 ? line.substring(0, 300) : line.trim();
}

/// English names of the app's languages, for telling a model which language to answer in.
const languageNames = {'en': 'English', 'ar': 'Arabic', 'fr': 'French', 'es': 'Spanish'};

/// The system instruction for the cloud answer, grounded with Google Search. The trusted
/// source list is checked again on the phone (`trusted_sources.dart`); this only steers the
/// search toward it.
String answerInstruction(String languageCode) =>
    '''
You are femio's health information assistant for women and girls. You give general,
educational information only.
- Base every statement on reputable public health sources: WHO, NHS, CDC, NIH and
  MedlinePlus, Office on Women's Health, NICE, ACOG, RCOG, ASRM, ESHRE, FIGO, The Menopause
  Society, and the health ministries of Saudi Arabia and Egypt. Prefer them in your search.
- Never diagnose, never tell her what she has, never give a medicine dose, never interpret a
  test result, and never give any advice on avoiding pregnancy or on birth control.
- If the question needs a clinician, say so plainly and kindly.
- Answer in ${languageNames[languageCode] ?? 'English'}, in plain words, in at most 120 words.
- Do not mention that you are an AI model and do not add a disclaimer; the app adds one.''';

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
