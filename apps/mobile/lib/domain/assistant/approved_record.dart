// Something from her record that she approved, one time, for Google's cloud AI to read
// (ADR-089, owner 2026-11-28).
//
// Why it exists: on a phone without Gemini Nano, reading a report, her words after a visit or
// a Say it note can only happen in the cloud. That is her record, so it may leave the phone
// only when she has agreed to "Read my reports in the cloud" (CloudPurpose.records) AND has
// seen exactly what goes on a preview sheet and tapped Send. This type is the proof of that
// second step: the constructor is private, and [ApprovedRecord.approvedOnSheet] is called only
// by the preview sheet (lib/features/assistant/cloud_reading.dart; the privacy tripwire checks
// it). [CloudPrompt.record] accepts nothing else from her record.

import 'dart:typed_data';

/// What she approved for reading.
enum RecordReading {
  /// Page pictures of a report or prescription (a photo, or PDF pages as pictures).
  report,

  /// The words she typed or said about her visit.
  visitWords,

  /// A Say it note, one part per day it names.
  note,
}

/// One approval, for one reading. [parts] are her words (one per part); [pages] are page
/// pictures; [today] is the ISO day the reading is dated against.
class ApprovedRecord {
  const ApprovedRecord._(this.reading, this.parts, this.pages, this.today);

  /// Made by the preview sheet only, after she tapped Send on a sheet that showed [parts] or
  /// the number of [pages]. Anything else calling it breaks the privacy tripwire.
  factory ApprovedRecord.approvedOnSheet({
    required RecordReading reading,
    List<String> parts = const [],
    List<Uint8List> pages = const [],
    required String today,
  }) =>
      ApprovedRecord._(reading, List.unmodifiable(parts), List.unmodifiable(pages), today);

  final RecordReading reading;

  /// Her words, exactly as shown on the sheet.
  final List<String> parts;

  /// Page pictures, exactly the number shown on the sheet.
  final List<Uint8List> pages;

  final String today;

  /// How many separate calls this reading makes: one per page or per part.
  int get count => reading == RecordReading.report ? pages.length : parts.length;
}
