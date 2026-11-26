// ADR-082 / R11.0: the health record's entries, timeline, edit trail and JSON.
import 'package:femio/domain/health_record.dart';
import 'package:flutter_test/flutter_test.dart';

RecordEntry _lab({String id = 'a', String day = '2026-11-02', String added = '2026-11-20T09:00:00'}) => RecordEntry(
      id: id,
      kind: RecordKind.lab,
      title: 'TSH',
      happenedOn: day,
      addedOn: added,
      fields: const {RecordField.value: '3.1', RecordField.unit: 'mIU/L', RecordField.printedRange: '0.4 - 4.0'},
    );

void main() {
  test('an entry survives JSON exactly, units and printed range as written', () {
    final e = _lab();
    final back = RecordEntry.fromJson(e.toJson());
    expect(back.toJson(), e.toJson());
    expect(back.fields[RecordField.printedRange], '0.4 - 4.0');
    expect(back.source, RecordSource.typed);
  });

  test('a missing or invalid happened-on day is refused, never guessed', () {
    final j = _lab().toJson()..remove('happenedOn');
    expect(() => RecordEntry.fromJson(j), throwsFormatException);
    final bad = _lab().toJson()..['happenedOn'] = '2026-13-40';
    expect(() => RecordEntry.fromJson(bad), throwsFormatException);
  });

  test('the timeline is newest happened-on first, then latest added', () {
    final list = timeline([
      _lab(id: 'old', day: '2026-01-05'),
      _lab(id: 'new-early', day: '2026-11-02', added: '2026-11-20T09:00:00'),
      _lab(id: 'new-late', day: '2026-11-02', added: '2026-11-21T09:00:00'),
    ]);
    expect([for (final e in list) e.id], ['new-late', 'new-early', 'old']);
  });

  test('an edit records when and which fields changed; no change, no trail', () {
    final e = _lab();
    expect(identical(e.edit(at: '2026-11-26T10:00:00', title: 'TSH'), e), isTrue);
    final edited = e.edit(
      at: '2026-11-26T10:00:00',
      fields: {...e.fields, RecordField.value: '3.2'},
    );
    expect(edited.edited, isTrue);
    expect(edited.edits.single.fields, [RecordField.value]);
    expect(edited.addedOn, e.addedOn, reason: 'added-on never moves');
    expect(edited.fields[RecordField.value], '3.2');
  });

  test('blank fields are not stored', () {
    final e = _lab().edit(at: '2026-11-26T10:00:00', fields: {RecordField.value: '3.1', RecordField.unit: '  '});
    expect(e.fields.containsKey(RecordField.unit), isFalse);
  });
}
