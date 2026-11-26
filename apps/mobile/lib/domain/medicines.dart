/// Her medicines: the times she chose, the doses she marked, and the refill date (R11.6).
/// Pure: no plugin, no clock, no UI.
///
/// Why it exists: a medicine is an entry of her record (`RecordKind.medicine`, with the dose
/// and how often exactly as written). What this file adds is the layer on top that she
/// controls: the times she takes it, a mark for each dose (taken or skipped, with its time),
/// a refill date, and whether the phone reminds her. The record entry itself is never
/// changed by any of this (rule 5).
///
/// Product rules it holds to:
/// - femio never suggests a dose, a time, a catch-up or an interaction (rule 1). Times are
///   hers; femio only keeps them and, if she asks, reminds her.
/// - Never a contraceptive schedule or missed-pill advice (rule 1): a medicine whose words
///   say birth control gets no times, no marks and no reminders ([scheduleBlocked]). It
///   stays in her record as history.
/// - "Later than planned" is a plain fact of her own marks, never a score or a warning.
library;

import 'assistant/safety.dart';
import 'assistant/text_normal.dart';
import 'dates.dart';
import 'health_record.dart';

/// The most times a day she can set for one medicine.
const maxMedicineTimes = 6;

/// The longest reminder label, in characters (it shows on a notification).
const maxMedicineLabelLength = 40;

/// A dose marked taken more than this many minutes after its planned time is shown as
/// "later than planned". A display rule about her own times, not a clinical one.
const doseLaterAfterMinutes = 60;

/// How many days back the history on a medicine's page shows.
const doseHistoryDays = 14;

/// The words that make a medicine a contraceptive in femio's eyes, on top of the
/// assistant's birth-control phrases. Matched as whole words on her title and fields.
const _contraceptiveMedicineWords = [
  'the pill',
  'mini pill',
  'minipill',
  'combined pill',
  'contraceptive pill',
  'contraceptif',
  'contraceptive',
  'pilule',
  'anticonceptiva',
  'anticonceptivas',
  'pildora anticonceptiva',
  'حبوب منع الحمل',
  'حبوب منع',
  'مانع حمل',
];

/// What she wants for one medicine: the times she takes it, whether the phone reminds her,
/// the words on that reminder, and when she expects to refill it.
class MedicinePlan {
  const MedicinePlan({
    required this.entryId,
    this.times = const [],
    this.remind = false,
    this.label = '',
    this.refillOn,
  });

  /// The [RecordEntry.id] of the medicine.
  final String entryId;

  /// Minutes after local midnight, sorted, no repeats, at most [maxMedicineTimes]. Empty
  /// means she takes it when needed: she can still mark a dose, and nothing reminds her.
  final List<int> times;

  /// Whether the phone reminds her at [times] (and the day before [refillOn]).
  final bool remind;

  /// Her own words for the notification; empty means the neutral "Open the app".
  final String label;

  /// ISO day she expects to refill it, or null.
  final String? refillOn;

  /// A copy with the given changes; [refillOn] is cleared with [clearRefill].
  MedicinePlan copyWith({List<int>? times, bool? remind, String? label, String? refillOn, bool clearRefill = false}) =>
      MedicinePlan(
        entryId: entryId,
        times: times == null ? this.times : cleanTimes(times),
        remind: remind ?? this.remind,
        label: label == null ? this.label : cleanLabel(label),
        refillOn: clearRefill ? null : (refillOn ?? this.refillOn),
      );

  Map<String, Object?> toJson() => {
    'entry': entryId,
    if (times.isNotEmpty) 'times': times,
    if (remind) 'remind': true,
    if (label.isNotEmpty) 'label': label,
    if (refillOn != null) 'refillOn': refillOn,
  };

  /// Reads one plan. Bad times and an invalid refill day are dropped, not fatal.
  static MedicinePlan fromJson(Map<String, Object?> j) {
    final id = j['entry'];
    if (id is! String) throw const FormatException('medicine plan: entry is required');
    final refill = j['refillOn'];
    return MedicinePlan(
      entryId: id,
      times: cleanTimes([
        for (final t in (j['times'] as List?) ?? const [])
          if (t is num) t.toInt(),
      ]),
      remind: j['remind'] as bool? ?? false,
      label: cleanLabel(j['label'] as String? ?? ''),
      refillOn: refill is String && isValidISODate(refill) ? refill : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is MedicinePlan &&
      other.entryId == entryId &&
      _sameInts(other.times, times) &&
      other.remind == remind &&
      other.label == label &&
      other.refillOn == refillOn;

  @override
  int get hashCode => Object.hash(entryId, Object.hashAll(times), remind, label, refillOn);
}

/// What she marked for one dose.
enum DoseStatus { taken, skipped }

/// One dose she marked: which medicine, which day, which planned time (null for a dose
/// taken when needed), taken or skipped, and the moment she says it happened.
class DoseMark {
  const DoseMark({required this.entryId, required this.day, this.slot, required this.status, required this.at});

  final String entryId;

  /// ISO day the dose belongs to.
  final String day;

  /// The planned time it answers, in minutes after midnight; null when taken as needed.
  final int? slot;
  final DoseStatus status;

  /// ISO local date-time she took it (or marked it skipped).
  final String at;

  /// Whether a taken dose came more than [doseLaterAfterMinutes] after its planned time.
  bool get later {
    if (status != DoseStatus.taken || slot == null) return false;
    final when = DateTime.tryParse(at);
    if (when == null) return false;
    final d = fromISO(day);
    // Her local wall clock on that day: fromISO is a UTC midnight, the mark is local time.
    final planned = DateTime(d.year, d.month, d.day, slot! ~/ 60, slot! % 60);
    return when.difference(planned).inMinutes > doseLaterAfterMinutes;
  }

  Map<String, Object?> toJson() => {
    'entry': entryId,
    'day': day,
    if (slot != null) 'slot': slot,
    'status': status.name,
    'at': at,
  };

  static DoseMark fromJson(Map<String, Object?> j) {
    final day = j['day'];
    if (j['entry'] is! String || day is! String || !isValidISODate(day) || j['at'] is! String) {
      throw const FormatException('dose mark: entry, day and at are required');
    }
    return DoseMark(
      entryId: j['entry'] as String,
      day: day,
      slot: (j['slot'] as num?)?.toInt(),
      status: DoseStatus.values.asNameMap()[j['status']] ?? DoseStatus.taken,
      at: j['at'] as String,
    );
  }
}

/// One planned time today and what she marked for it, if anything.
typedef DoseSlot = ({int minutes, DoseMark? mark});

/// [times] sorted, inside the clock, without repeats, at most [maxMedicineTimes].
List<int> cleanTimes(Iterable<int> times) => ({
  for (final t in times)
    if (t >= 0 && t < 24 * 60) t,
}.toList()..sort()).take(maxMedicineTimes).toList();

/// [label] trimmed and cut to [maxMedicineLabelLength] characters.
String cleanLabel(String label) {
  final s = label.trim();
  return s.length <= maxMedicineLabelLength ? s : s.substring(0, maxMedicineLabelLength).trim();
}

/// Whether [entry] reads as a contraceptive: then femio keeps no schedule, marks or
/// reminders for it (rule 1). Checks her title and every field she wrote.
bool scheduleBlocked(RecordEntry entry) {
  final text = [entry.title, ...entry.fields.values].join(' ');
  if (mentionsBirthControl(text)) return true;
  final w = words(text);
  return _contraceptiveMedicineWords.any((p) => findPhrase(w, words(p)) >= 0);
}

/// Whether [entry] is taken on [day]: on or after its start (when written) and on or before
/// its end (when written).
bool takenOn(RecordEntry entry, String day) {
  final start = entry.fields[RecordField.startedOn];
  final end = entry.fields[RecordField.endedOn];
  if (start != null && isValidISODate(start) && day.compareTo(start) < 0) return false;
  if (end != null && isValidISODate(end) && day.compareTo(end) > 0) return false;
  return true;
}

/// Whether [entry] has ended before [today] (written end day already past).
bool finished(RecordEntry entry, String today) {
  final end = entry.fields[RecordField.endedOn];
  return end != null && isValidISODate(end) && end.compareTo(today) < 0;
}

/// Her medicines split into current (not finished, newest first) and finished.
({List<RecordEntry> current, List<RecordEntry> finished}) medicinesByStatus(
  Iterable<RecordEntry> record,
  String today,
) {
  final all = ofKind(record, RecordKind.medicine);
  return (
    current: [
      for (final e in all)
        if (!finished(e, today)) e,
    ],
    finished: [
      for (final e in all)
        if (finished(e, today)) e,
    ],
  );
}

/// The plan for [entryId] among [plans], or an empty one.
MedicinePlan planFor(Iterable<MedicinePlan> plans, String entryId) {
  for (final p in plans) {
    if (p.entryId == entryId) return p;
  }
  return MedicinePlan(entryId: entryId);
}

/// Today's planned times for [plan] on [day], each with her mark if she made one.
List<DoseSlot> slotsOn(MedicinePlan plan, Iterable<DoseMark> doses, String day) => [
  for (final t in plan.times) (minutes: t, mark: _markFor(doses, plan.entryId, day, t)),
];

/// Doses she took as needed (no planned time) on [day], oldest first.
List<DoseMark> asNeededOn(Iterable<DoseMark> doses, String entryId, String day) => [
  for (final d in doses)
    if (d.entryId == entryId && d.day == day && d.slot == null) d,
]..sort((a, b) => a.at.compareTo(b.at));

/// Her marks for [entryId] over the [doseHistoryDays] days ending [today], newest first.
List<DoseMark> history(Iterable<DoseMark> doses, String entryId, String today) {
  final from = addDays(today, -(doseHistoryDays - 1));
  return [
    for (final d in doses)
      if (d.entryId == entryId && d.day.compareTo(from) >= 0 && d.day.compareTo(today) <= 0) d,
  ]..sort((a, b) => b.at.compareTo(a.at));
}

/// [doses] with the mark for ([entryId], [day], [slot]) replaced by [mark], or removed when
/// [mark] is null. A dose taken as needed (slot null) is always added, never replaced.
List<DoseMark> withMark(
  List<DoseMark> doses, {
  required String entryId,
  required String day,
  int? slot,
  DoseMark? mark,
}) {
  if (slot == null) return [...doses, ?mark];
  return [
    for (final d in doses)
      if (!(d.entryId == entryId && d.day == day && d.slot == slot)) d,
    ?mark,
  ];
}

DoseMark? _markFor(Iterable<DoseMark> doses, String entryId, String day, int slot) {
  for (final d in doses) {
    if (d.entryId == entryId && d.day == day && d.slot == slot) return d;
  }
  return null;
}

bool _sameInts(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
