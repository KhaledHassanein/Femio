// The only text that may be sent to a model that can run in the cloud (ADR-079).
//
// Why it exists: the hybrid call (PREFER_ON_DEVICE) uses Gemini Nano when the phone has it and
// Google's cloud model when it does not, so whatever it is given may leave the phone. The
// channel method accepts only a [CloudPrompt], and a CloudPrompt can be made only from the two
// cloud-safe types plus public data:
//   - [CloudPrompt.answer]: a [CloudSafeText] question and public registry passages;
//   - [CloudPrompt.tips]: a [PseudonymisedProfile] and the reviewed tips for her whole life
//     stage (never the subset that fits her, which would itself describe her);
//   - [CloudPrompt.record]: an [ApprovedRecord], one item from her record she approved on a
//     preview sheet under her "Read my reports in the cloud" consent (ADR-089). Only this
//     factory may carry a page picture ([image]).
// The constructor is private, and the privacy tripwire checks that no other constructor exists.

import 'dart:typed_data';

import 'approved_record.dart';
import 'personal_triggers.dart';
import 'prompts.dart';
import 'pseudonymised_profile.dart';
import 'record_draft.dart';
import 'redaction.dart';
import 'source_registry.dart';
import 'tip_catalogue.g.dart';

/// A prompt that may leave the phone. Build it with [CloudPrompt.answer], [CloudPrompt.tips]
/// or [CloudPrompt.record]; read it with [text] (and [image]).
class CloudPrompt {
  const CloudPrompt._(this.text, [this.image]);

  /// A redacted general [question] answered from public registry [passages] in [languageCode].
  factory CloudPrompt.answer(
    CloudSafeText question,
    List<SourceEntry> passages,
    String languageCode,
  ) => CloudPrompt._(
    answerPrompt(question.value, [
      for (final p in passages) (publisher: p.publisher, text: p.text),
    ], languageCode),
  );

  /// Asks for the [pick] reviewed tips that best suit the coarse bands in [profile]. The list
  /// offered is every tip for her whole life stage ([forStage]), built here so no caller can
  /// pass the subset that fits her.
  factory CloudPrompt.tips(PseudonymisedProfile profile, int pick) =>
      CloudPrompt._(
        tipsPrompt(
          [for (final e in profile.features.entries) '${e.key}: ${e.value}'],
          {
            for (final item in forStage(tipCatalogue, profile.stage))
              item.id: tipEnglish[item.id]!,
          },
          pick,
        ),
      );

  /// Part [part] of what she approved in [approved]: one page picture of a report with the
  /// reading instructions, her visit words, or one day's part of her Say it note. Throws a
  /// RangeError for a part she did not approve.
  factory CloudPrompt.record(ApprovedRecord approved, int part) => switch (approved.reading) {
        RecordReading.report => CloudPrompt._(scanPagePrompt(), approved.pages[part]),
        RecordReading.visitWords => CloudPrompt._(afterVisitPrompt(approved.parts[part], approved.today)),
        RecordReading.note => CloudPrompt._(extractionPrompt(approved.parts[part])),
      };

  /// Exactly what will be sent.
  final String text;

  /// The page picture sent with [text]; only [CloudPrompt.record] for a report sets it.
  final Uint8List? image;
}
