// What the on-phone model may propose for her record, and how its reply is checked (ADR-087).
//
// Why it exists: two companion uses read something of hers and suggest record entries: a photo
// or PDF page of a report (`scanDocument`) and the words she says after a visit (`afterVisit`).
// Both run on Gemini Nano only, and both end in a draft she checks line by line before
// anything is saved (CLAUDE.md rule 7). The model answers in short pipe-separated lines,
// because Google advises on-device replies under 256 tokens and a lab page in JSON would not
// fit. This file holds the two prompts and the one parser, so a reply can only ever produce
// fields femio knows, with sizes it accepts, and dates that make sense.
//
// It never interprets: a value, its unit and the range are kept exactly as printed, never
// judged or converted (ADR-082).

import '../dates.dart';
import '../health_record.dart';

/// At most this many lines are kept from one reply (a dense lab page is about 25 tests).
const maxDraftLines = 30;

/// At most this many pages of a PDF are read; each page is one model call.
const maxScanPages = 3;

/// Longest test or medicine name kept from a reply.
const maxDraftTitle = 60;

/// Longest value, unit, dose or frequency kept from a reply.
const maxDraftField = 40;

/// A next appointment may be at most this many days ahead.
const maxNextVisitDays = 730;

/// The earliest year a report date may carry.
const earliestDraftYear = 1990;

/// What one draft line would become.
enum DraftKind { lab, medicine }

/// One suggested entry. [fields] uses the RecordField names (`value`, `unit`,
/// `printedRange`, `dose`, `frequency`).
class DraftLine {
  const DraftLine(this.kind, this.title, this.fields);
  final DraftKind kind;
  final String title;
  final Map<String, String> fields;
}

/// Everything one reply proposed. [date] is the report or collection date printed on the
/// page (never guessed by femio; she confirms or picks it). [nextVisit] and [note] come only
/// from her after-visit words.
class RecordDraft {
  const RecordDraft({this.date, this.lines = const [], this.nextVisit, this.note});
  final String? date;
  final List<DraftLine> lines;
  final String? nextVisit;
  final String? note;

  bool get isEmpty => lines.isEmpty && nextVisit == null && (note == null || note!.isEmpty);

  /// This draft followed by [other] (the next page): the first date found wins, lines are
  /// added up to [maxDraftLines], a line already present is not repeated.
  RecordDraft merge(RecordDraft other) {
    final seen = {for (final l in lines) _key(l)};
    final added = [
      ...lines,
      for (final l in other.lines)
        if (seen.add(_key(l))) l,
    ];
    return RecordDraft(
      date: date ?? other.date,
      lines: added.take(maxDraftLines).toList(),
      nextVisit: nextVisit ?? other.nextVisit,
      note: note ?? other.note,
    );
  }

  static String _key(DraftLine l) => '${l.kind.name}|${l.title.toLowerCase()}|${l.fields['value'] ?? ''}';
}

/// The instruction sent with one page image of her report or prescription.
String scanPagePrompt() => '''
You read one page of a medical lab report or prescription in the image.
Copy what is printed. Never calculate, judge or add anything. Skip names of people, ID numbers, addresses and phone numbers.
Reply only with lines in exactly these shapes, one per line, no other text:
DATE|YYYY-MM-DD   (the collection or report date printed on the page, once, only if printed)
LAB|test name|value|unit|reference range as printed
MED|medicine name|dose as written|how often as written
Leave a part empty if it is not printed, for example LAB|TSH|3.1|mIU/L|
If the page has no test results and no medicines, reply NONE.''';

/// The instruction for what she said after a visit; [words] stay on the phone. [today] lets
/// the model turn "in two weeks" into a date, which she then checks.
String afterVisitPrompt(String words, String today) => '''
You turn a woman's own notes after a doctor visit into draft record entries. Today is $today.
The notes may be in English, Arabic (including Egyptian or Gulf dialect), French or Spanish.
Only write what the notes clearly say. Never add advice, doses or tests she did not mention.
Reply only with lines in exactly these shapes, one per line, no other text:
MED|medicine name|dose as said|how often as said
LAB|test name|value|unit|range
NEXT|YYYY-MM-DD   (the next visit date, only if she said one)
NOTE|one short sentence in her language summarising what the doctor said
If there is nothing to record, reply NONE.

Notes: """$words"""''';

/// Reads a reply to [scanPagePrompt] or [afterVisitPrompt]. Unknown line shapes, empty names,
/// lab lines without a number, oversized parts and impossible dates are dropped, so a bad reply
/// can only add nothing. [today] is an ISO day; report dates after it are dropped, and a next
/// visit must fall after it and within [maxNextVisitDays].
RecordDraft parseRecordDraft(String reply, String today) {
  String? date;
  String? next;
  String? note;
  final lines = <DraftLine>[];
  final now = fromISO(today);
  for (final raw in reply.split('\n')) {
    final parts = raw.trim().replaceAll('`', '').split('|').map((p) => p.trim()).toList();
    if (parts.length < 2) continue;
    final tag = parts.first.toUpperCase();
    String part(int i) => i < parts.length ? parts[i] : '';
    switch (tag) {
      case 'DATE':
        final d = _day(part(1));
        if (date == null && d != null && !d.isAfter(now) && d.year >= earliestDraftYear) date = toISO(d);
      case 'NEXT':
        final d = _day(part(1));
        if (next == null && d != null && d.isAfter(now) && d.difference(now).inDays <= maxNextVisitDays) next = toISO(d);
      case 'NOTE':
        final n = parts.sublist(1).join(' ').trim();
        if (note == null && n.isNotEmpty) note = n.length > 200 ? '${n.substring(0, 200)}…' : n;
      case 'LAB':
        final title = part(1);
        final value = part(2);
        if (!_fits(title, maxDraftTitle) || !RegExp(r'\d').hasMatch(value) || value.length > maxDraftField) continue;
        if (part(3).length > maxDraftField || part(4).length > maxDraftField) continue;
        lines.add(DraftLine(DraftKind.lab, title, _clean({'value': value, 'unit': part(3), 'printedRange': part(4)})));
      case 'MED':
        final title = part(1);
        if (!_fits(title, maxDraftTitle) || part(2).length > maxDraftField || part(3).length > maxDraftField) continue;
        lines.add(DraftLine(DraftKind.medicine, title, _clean({'dose': part(2), 'frequency': part(3)})));
    }
    if (lines.length >= maxDraftLines) break;
  }
  return RecordDraft(date: date, lines: lines, nextVisit: next, note: note);
}

bool _fits(String s, int max) => s.isNotEmpty && s.length <= max;

Map<String, String> _clean(Map<String, String> m) => {
      for (final e in m.entries)
        if (e.value.isNotEmpty) e.key: e.value,
    };

DateTime? _day(String s) {
  final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(s);
  if (m == null) return null;
  final y = int.parse(m.group(1)!);
  final mo = int.parse(m.group(2)!);
  final d = int.parse(m.group(3)!);
  final date = DateTime(y, mo, d);
  // DateTime rolls 31 February into March; a date that does not round-trip was not real.
  return date.year == y && date.month == mo && date.day == d ? date : null;
}

/// The record entries for the [chosen] lines she kept, all dated [happenedOn] (the report
/// date she confirmed) and stamped [addedOn]. [idPrefix] makes each id unique (the caller
/// passes something random or time-based, never her words); [attachmentId] links each entry
/// to the document it was read from. Medicines start on [happenedOn].
List<RecordEntry> entriesFromDraft(
  List<DraftLine> chosen, {
  required String happenedOn,
  required String addedOn,
  required String idPrefix,
  required RecordSource source,
  String? attachmentId,
}) =>
    [
      for (final (i, line) in chosen.indexed)
        RecordEntry.create(
          id: '$idPrefix-$i',
          kind: line.kind == DraftKind.lab ? RecordKind.lab : RecordKind.medicine,
          title: line.title,
          happenedOn: happenedOn,
          addedOn: addedOn,
          source: source,
          fields: {
            ...line.fields,
            if (line.kind == DraftKind.medicine) RecordField.startedOn: happenedOn,
          },
          attachmentIds: [?attachmentId],
        ),
    ];
