// The only text that may be given to the on-phone model (ADR-081, R10.1).
//
// Why it exists: the on-phone call used to accept any string, and four screens each built
// their own prompt. That kept her data on the phone but did not keep the AI "surgical": any
// screen could hand the model anything. A PrivatePrompt can be made only by the factories
// below, each tied to one [AssistantUse] and given only the narrow inputs that use needs.
// The constructor is private, and the privacy tripwire checks nothing else builds one.

import 'dart:typed_data';

import 'prompts.dart';
import 'record_draft.dart';
import 'pseudonymised_profile.dart';
import 'source_registry.dart';
import 'tip_catalogue.g.dart';
import 'uses.dart';
import 'visit_summary.dart';

/// A prompt for Gemini Nano on the phone. [offered] holds the ids the reply may pick from,
/// so the gateway's parser can reject anything outside them.
class PrivatePrompt {
  const PrivatePrompt._(this.use, this.text, [this.offered = const [], this.image]);

  final AssistantUse use;
  final String text;
  final List<String> offered;

  /// One page picture (PNG or JPEG) sent with [text]; only [PrivatePrompt.scanPage] has one.
  final Uint8List? image;

  /// Read a report: one [page] picture of the document she chose, read on the phone.
  factory PrivatePrompt.scanPage(Uint8List page) =>
      PrivatePrompt._(AssistantUse.scanDocument, scanPagePrompt(), const [], page);

  /// After a visit: her [words] and [today] (ISO day), read on the phone.
  factory PrivatePrompt.afterVisit(String words, String today) =>
      PrivatePrompt._(AssistantUse.afterVisit, afterVisitPrompt(words, today));

  /// Ask femio: her [question] (read only on the phone) and the registry [passages].
  factory PrivatePrompt.answer(String question, List<SourceEntry> passages, String languageCode) =>
      PrivatePrompt._(
        AssistantUse.askOnPhone,
        answerPrompt(question, [for (final p in passages) (publisher: p.publisher, text: p.text)], languageCode),
      );

  /// Say it to log: the [note] she typed, turned into log terms she then confirms.
  factory PrivatePrompt.sayIt(String note) => PrivatePrompt._(AssistantUse.sayItToLog, extractionPrompt(note));

  /// Tips for you: the coarse [bands] and the reviewed tips [ids] that already fit her.
  /// The model sees the bands, never her log.
  factory PrivatePrompt.tips(PseudonymisedProfile bands, List<String> ids, int pick) => PrivatePrompt._(
    AssistantUse.tipsOrder,
    tipsPrompt(
      [for (final e in bands.features.entries) '${e.key}: ${e.value}'],
      {for (final id in ids) id: tipEnglish[id]!},
      pick,
    ),
    ids,
  );

  /// Visit pack: the summary's facts in English and its reviewed question ids to order.
  factory PrivatePrompt.visitQuestions(VisitSummary summary) {
    final candidates = {
      for (final id in summary.questionIds)
        if (id != 'anythingElse') id: questionEnglish(id)!,
    };
    return PrivatePrompt._(
      AssistantUse.visitQuestions,
      visitQuestionsPrompt(summary.factsInEnglish(), candidates, candidates.length),
      candidates.keys.toList(),
    );
  }
}
