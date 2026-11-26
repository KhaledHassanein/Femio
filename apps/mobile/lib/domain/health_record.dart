// Her health record: typed entries with two times, a source and an edit trail (ADR-082).
//
// Why it exists: the owner wants femio to keep her own medical file "like a professional
// record" (PROGRESS R11). Every later R11 item (documents, scan, charts, medicines, the
// visit pack) reads and writes this one list. femio stores, dates and draws what she
// enters; it never interprets (rule 1): no "normal" or "abnormal", no range except the
// one printed on her own report, no dose advice.

import 'dates.dart';

/// What an entry is. The order is the order of the sections on the "My record" screen.
enum RecordKind {
  visit,
  lab,
  imaging,
  medicine,
  condition,
  allergy,
  procedure,
  pregnancy,
  document,
  note,
}

/// Where an entry came from. Everything but [typed] started as a draft she confirmed.
enum RecordSource { typed, scanned, askFemio, sayIt, imported }

/// The named fields an entry may carry, as she or the report wrote them. Free text on
/// purpose: a lab's units and printed range are kept exactly, never converted or judged.
abstract final class RecordField {
  static const value = 'value';
  static const unit = 'unit';

  /// The reference range exactly as printed on her own report.
  static const printedRange = 'printedRange';
  static const dose = 'dose';
  static const frequency = 'frequency';
  static const startedOn = 'startedOn';
  static const endedOn = 'endedOn';
  static const prescriber = 'prescriber';
  static const place = 'place';
  static const details = 'details';

  /// Every field the app knows, in the order forms and exports show them.
  static const all = [value, unit, printedRange, dose, frequency, startedOn, endedOn, prescriber, place, details];
}

/// One change to an entry: when, and which fields changed. Old values are not kept in
/// the trail: the entry itself is the record, the trail only says it was edited.
class RecordEdit {
  const RecordEdit(this.at, this.fields);

  /// ISO date-time of the edit.
  final String at;

  /// The names of the fields that changed (`title`, `happenedOn`, or a [RecordField]).
  final List<String> fields;

  Map<String, Object?> toJson() => {'at': at, 'fields': fields};
  static RecordEdit fromJson(Map<String, Object?> j) =>
      RecordEdit(j['at'] as String, List<String>.from((j['fields'] as List?) ?? const []));
}

/// One entry in her record.
class RecordEntry {
  const RecordEntry({
    required this.id,
    required this.kind,
    required this.title,
    required this.happenedOn,
    required this.addedOn,
    this.source = RecordSource.typed,
    this.fields = const {},
    this.attachmentIds = const [],
    this.edits = const [],
  });

  /// Random and opaque; never derived from her words.
  final String id;
  final RecordKind kind;

  /// Her own words ("TSH", "Dr Salma, 12-week scan").
  final String title;

  /// ISO day it happened: the date printed on the report or the day of the visit.
  /// Required, never guessed (ADR-082).
  final String happenedOn;

  /// ISO date-time it entered femio.
  final String addedOn;
  final RecordSource source;

  /// [RecordField] name to her text. Empty strings are not stored.
  final Map<String, String> fields;

  /// Ids of sealed attachment files linked to this entry (R11.2).
  final List<String> attachmentIds;
  final List<RecordEdit> edits;

  bool get edited => edits.isNotEmpty;

  /// A new entry as she typed it, blank fields dropped and no edit trail.
  static RecordEntry create({
    required String id,
    required RecordKind kind,
    required String title,
    required String happenedOn,
    required String addedOn,
    RecordSource source = RecordSource.typed,
    Map<String, String> fields = const {},
    List<String> attachmentIds = const [],
  }) =>
      RecordEntry(
        id: id,
        kind: kind,
        title: title.trim(),
        happenedOn: happenedOn,
        addedOn: addedOn,
        source: source,
        fields: _clean(fields),
        attachmentIds: attachmentIds,
      );

  /// A copy with her changes applied and, when anything changed, one [RecordEdit] stamped
  /// [at] naming what changed. Returns this entry unchanged when nothing did.
  RecordEntry edit({
    required String at,
    String? title,
    String? happenedOn,
    Map<String, String>? fields,
    List<String>? attachmentIds,
  }) {
    final nextFields = fields == null ? this.fields : _clean(fields);
    final changed = <String>[
      if (title != null && title != this.title) 'title',
      if (happenedOn != null && happenedOn != this.happenedOn) 'happenedOn',
      for (final k in {...this.fields.keys, ...nextFields.keys})
        if (this.fields[k] != nextFields[k]) k,
      if (attachmentIds != null && !_sameList(attachmentIds, this.attachmentIds)) 'attachments',
    ];
    if (changed.isEmpty) return this;
    return RecordEntry(
      id: id,
      kind: kind,
      title: title ?? this.title,
      happenedOn: happenedOn ?? this.happenedOn,
      addedOn: addedOn,
      source: source,
      fields: nextFields,
      attachmentIds: attachmentIds ?? this.attachmentIds,
      edits: [...edits, RecordEdit(at, changed)],
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'kind': kind.name,
        'title': title,
        'happenedOn': happenedOn,
        'addedOn': addedOn,
        'source': source.name,
        if (fields.isNotEmpty) 'fields': fields,
        if (attachmentIds.isNotEmpty) 'attachments': attachmentIds,
        if (edits.isNotEmpty) 'edits': [for (final e in edits) e.toJson()],
      };

  /// Reads one entry. Throws [FormatException] on a missing id, title or valid
  /// happened-on day, so a damaged entry is caught by the loader instead of shown wrong.
  static RecordEntry fromJson(Map<String, Object?> j) {
    final happenedOn = j['happenedOn'];
    if (j['id'] is! String || j['title'] is! String || happenedOn is! String || !isValidISODate(happenedOn)) {
      throw const FormatException('record entry: id, title and happenedOn are required');
    }
    return RecordEntry(
      id: j['id'] as String,
      kind: RecordKind.values.asNameMap()[j['kind']] ?? RecordKind.note,
      title: j['title'] as String,
      happenedOn: happenedOn,
      addedOn: j['addedOn'] as String? ?? happenedOn,
      source: RecordSource.values.asNameMap()[j['source']] ?? RecordSource.typed,
      fields: _clean(Map<String, String>.from((j['fields'] as Map?) ?? const {})),
      attachmentIds: List<String>.from((j['attachments'] as List?) ?? const []),
      edits: [for (final e in (j['edits'] as List?) ?? const []) RecordEdit.fromJson(Map<String, Object?>.from(e as Map))],
    );
  }
}

/// The timeline: newest happened-on first; on the same day, the one added later first.
List<RecordEntry> timeline(Iterable<RecordEntry> entries) => [...entries]..sort((a, b) {
    final byDay = b.happenedOn.compareTo(a.happenedOn);
    return byDay != 0 ? byDay : b.addedOn.compareTo(a.addedOn);
  });

/// Entries of one [kind], in timeline order.
List<RecordEntry> ofKind(Iterable<RecordEntry> entries, RecordKind kind) =>
    timeline(entries.where((e) => e.kind == kind));

Map<String, String> _clean(Map<String, String> fields) => {
      for (final e in fields.entries)
        if (e.value.trim().isNotEmpty) e.key: e.value.trim(),
    };

bool _sameList(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
