// "Say it", several days in one note: the day words that split a note (ADR-078, R10.7).
//
// Why it exists: she writes "yesterday cramps and headache, today spotting" or "امبارح مغص
// وصداع والنهارده تنقيط" and means two different days. This file finds the day words
// (today, yesterday, the day before yesterday, "2 days ago", weekday names, explicit dates like
// 20/6) in English, Egyptian and Gulf Arabic, French and Spanish, cuts the note into one piece
// per day, and runs the existing phrase rules (`draftFromNote`) on each piece. It is rules
// only, so it works with AI off; a model, when the phone has one, only adds to a day's draft
// afterwards (in the sheet, behind `AssistantGateway`).
//
// Rules this file keeps:
// - Never invent a date. Text with no day word belongs to the day she has selected.
// - A day that has not happened yet is refused, not logged (a note is a record of the past).
// - Day words reach at most [sayItMaxDaysBack] days back; older days are refused.
// - Safety runs first, on the whole text, before any splitting (`safetySignalFor`).
// - Nothing here writes to her record; every piece is only a draft she confirms.
//
// Reading choices that are easy to get wrong, so they are written down:
// - A weekday name means the most recent such day, today included ("on Monday", said on a
//   Monday, is today). It is never in the future, and always within the last 7 days.
// - "6/20"-style text is day first ("20/6"), as in Egypt, Saudi Arabia, France and Spain; if
//   only month first makes a real date (6/20), that reading is used. Without a year, only a
//   date inside the last 7 days counts as a day word, so "pain 7/10" is not a date.
// - Arabic "من يومين" can mean "for two days", so only "قبل يومين" counts as "2 days ago".
// - Which side of a day word its symptoms sit on is decided per sentence: if a sentence starts
//   with a day word, each day word leads its words ("yesterday cramps, today spotting");
//   otherwise each day word follows its words ("cramps yesterday and spotting today").

import '../../data/profile.dart';
import '../dates.dart';
import 'log_phrases.dart';
import 'say_it_day_words.dart';
import 'safety.dart';
import 'text_normal.dart';

export 'say_it_day_words.dart' show SayItRefusal, sayItMaxDaysBack;

/// The words of one note that belong to one day, and what the phrase rules read in them.
class SayItDay {
  const SayItDay({required this.date, required this.text, required this.draft});

  /// ISO `YYYY-MM-DD`.
  final String date;

  /// Her own words for this day, with the day words taken out. This, never the whole note,
  /// is what an on-phone model may be asked about for this day.
  final String text;

  /// What the phrase rules found in [text].
  final LogDraft draft;
}

/// A note read for several days: safety first, then one draft per day.
class SayItReading {
  const SayItReading({required this.signal, required this.days, required this.refused});

  /// The danger sign found in the whole note, or [SafetySignal.none].
  final SafetySignal signal;

  /// One entry per day, oldest first. May include days whose draft is empty.
  final List<SayItDay> days;

  /// What was left out, for the plain message under the field.
  final Set<SayItRefusal> refused;

  /// Days with at least one thing the rules found.
  List<SayItDay> get daysWithEntries => [
    for (final d in days)
      if (!d.draft.isEmpty) d,
  ];
}

/// Reads [note] for her: runs the safety rules on the whole text first, then splits it into
/// days relative to [today] (ISO). Text without a day word goes to [selectedDate] (default
/// [today]). [profile] sets which life-stage safety signs count; null reads as not pregnant.
///
/// Never throws; a note with no readable words gives an empty [days].
SayItReading readSayItNote(String note, {Profile? profile, required String today, String? selectedDate}) {
  final signal = profile == null ? safetySignal(note, pregnant: false) : safetySignalFor(note, profile, today);
  final split = splitNoteByDay(note, today: today, selectedDate: selectedDate);
  return SayItReading(
    signal: signal,
    days: [
      for (final p in split.pieces.entries)
        SayItDay(date: p.key, text: p.value.join(' '), draft: _draftOfPieces(p.value)),
    ],
    refused: split.refused,
  );
}

/// The pieces of a note per day (oldest day first) and what was refused.
class DaySplit {
  const DaySplit(this.pieces, this.refused);

  /// ISO date to the pieces of her own words for that day, without the day words.
  final Map<String, List<String>> pieces;
  final Set<SayItRefusal> refused;
}

/// Cuts [note] into pieces per day with the day words described in the file header.
///
/// [today] is an ISO date. [selectedDate] (ISO, default [today]) takes every piece that has no
/// day word; if it is in the future it is refused like any future day. Returns no pieces for
/// an empty note.
DaySplit splitNoteByDay(String note, {required String today, String? selectedDate}) {
  final selected = selectedDate != null && isValidISODate(selectedDate) ? selectedDate : today;
  final dates = <DateWord>[];
  final folded = foldDigits(note).replaceAllMapped(dayDatePattern, (m) {
    final word = dateWordOf(m, today);
    if (word == null) return m[0]!;
    dates.add(word);
    return ' xdate${dates.length - 1} ';
  });

  final byDate = <String, List<String>>{};
  final refused = <SayItRefusal>{};
  void give(String? date, String text) {
    if (text.isEmpty || date == null) return;
    byDate.putIfAbsent(date, () => []).add(text);
  }

  void giveToSelected(String text) {
    if (selected.compareTo(today) > 0) {
      if (text.isNotEmpty) refused.add(SayItRefusal.future);
    } else {
      give(selected, text);
    }
  }

  for (final sentence in folded.split(_sentenceBreak)) {
    final tokens = [
      for (final raw in sentence.split(_spaces))
        if (raw.isNotEmpty) _Token(raw, words(raw)),
    ];
    final flat = <String>[];
    final owner = <int>[];
    for (var i = 0; i < tokens.length; i++) {
      for (final w in tokens[i].words) {
        flat.add(w);
        owner.add(i);
      }
    }
    if (flat.isEmpty) continue;

    final hits = <DayWordHit>[];
    var i = 0;
    while (i < flat.length) {
      final hit = dayWordAt(flat, i, today, dates);
      if (hit == null) {
        i++;
      } else {
        hits.add(hit);
        i = hit.end;
      }
    }
    final markers = [
      for (final h in hits)
        if (h.kind != DayWordKind.ignored) h,
    ];
    final dropped = {
      for (final h in hits)
        for (var k = h.start; k < h.end; k++) k,
    };

    // Piece k lies between marker k-1 and marker k; piece 0 is before the first marker.
    final pieceOf = List<int>.filled(flat.length, 0);
    for (var w = 0; w < flat.length; w++) {
      var k = 0;
      while (k < markers.length && w >= markers[k].end) {
        k++;
      }
      pieceOf[w] = k;
    }
    final pieceTokens = List.generate(markers.length + 1, (_) => <int>[]);
    final pieceHasContent = List.filled(markers.length + 1, false);
    for (var w = 0; w < flat.length; w++) {
      if (dropped.contains(w)) continue;
      final t = owner[w];
      final list = pieceTokens[pieceOf[w]];
      if (!list.contains(t)) list.add(t);
      if (!dayConnectors.contains(flat[w])) pieceHasContent[pieceOf[w]] = true;
    }
    String textOf(int piece) => pieceTokens[piece].map((t) => tokens[t].raw).join(' ').trim();

    if (markers.isEmpty) {
      giveToSelected(textOf(0));
      continue;
    }
    // A day word's own words stay in its day's text, in place, so a phrase that includes the
    // day word ("period today") still matches. A numeric date is not kept (it says nothing).
    String markerText(DayWordHit m) {
      final seen = <int>[];
      for (var w = m.start; w < m.end; w++) {
        if (!seen.contains(owner[w])) seen.add(owner[w]);
      }
      return seen.map((t) => tokens[t].raw).where((r) => !_dateTokenText.hasMatch(r)).join(' ');
    }

    // Trailing style: the words before the first day word are about a day named after them.
    final trailing = pieceHasContent[0];
    for (var k = 0; k < markers.length; k++) {
      final m = markers[k];
      final said = [
        textOf(trailing ? k : k + 1),
        if (trailing && k == markers.length - 1) textOf(markers.length),
      ];
      if (said.every((t) => t.isEmpty)) continue; // a day word with nothing said about it
      final own = markerText(m);
      final text = (trailing
              ? [said.first, own, if (said.length > 1) said[1]]
              : [own, said.first])
          .where((t) => t.isNotEmpty)
          .join(' ');
      if (m.refusal != null) {
        refused.add(m.refusal!);
      } else {
        give(m.date, text);
      }
    }
  }

  final ordered = byDate.keys.toList()..sort();
  return DaySplit({for (final d in ordered) d: byDate[d]!}, refused);
}

/// The ids the sheet uses for a draft's chips: a term's own key, `flow:<level>`, `opk:<result>`.
String flowChipId(String flow) => 'flow:$flow';
String opkChipId(String opk) => 'opk:$opk';

/// [draft] without the chips she unticked (ids as in [flowChipId], [opkChipId] and the term
/// keys). What she saves is always this, never the raw draft.
LogDraft draftWithout(LogDraft draft, Set<String> unticked) => LogDraft(
  terms: [
    for (final t in draft.terms)
      if (!unticked.contains(t)) t,
  ],
  flow: draft.flow != null && !unticked.contains(flowChipId(draft.flow!)) ? draft.flow : null,
  opk: draft.opk != null && !unticked.contains(opkChipId(draft.opk!)) ? draft.opk : null,
);

/// How many entries [draft] holds, for the counted save button: one per chip.
int entryCount(LogDraft draft) => draft.terms.length + (draft.flow != null ? 1 : 0) + (draft.opk != null ? 1 : 0);

/// Merges [draft] into [log] without deleting anything she already recorded (rule 5): her
/// chips stay, new ones are added, the temperature stays, and a flow or test result is only
/// replaced when the note names one. Returns [log] unchanged for an empty draft.
DayLog mergeIntoDayLog(DayLog log, LogDraft draft) => log.copyWith(
  terms: {...log.terms, ...draft.terms}.toList(),
  flow: draft.flow ?? log.flow,
  opk: draft.opk ?? log.opk,
);

LogDraft _draftOfPieces(List<String> pieces) {
  var draft = const LogDraft();
  for (final p in pieces) {
    final next = draftFromNote(p);
    // The first piece's flow and test result win; terms are unioned, in vocabulary order.
    draft = mergeDrafts(draft, modelTerms: next.terms, modelFlow: next.flow, modelOpk: next.opk);
  }
  return draft;
}


class _Token {
  const _Token(this.raw, this.words);
  final String raw;
  final List<String> words;
}

final _spaces = RegExp(r'\s+');
final _dateTokenText = RegExp(r'^xdate\d+$');
final _sentenceBreak = RegExp(r'[.!?؟؛;\n\r]+');
