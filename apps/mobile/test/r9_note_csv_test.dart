// R9.8 (day note) and R9.10 (CSV export): the note survives the record and the backup,
// and the spreadsheet is well-formed, ordered and keeps Arabic intact.
import 'dart:convert';

import 'package:femio/data/backup.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/domain/csv_export.dart';
import 'package:flutter_test/flutter_test.dart';

const _labels = CsvLabels(
  date: 'Date',
  flowColumn: 'Period',
  moodColumn: 'Mood',
  symptomsColumn: 'Symptoms',
  dischargeColumn: 'Discharge',
  otherColumn: 'Other',
  opkColumn: 'Ovulation test',
  temperatureColumn: 'Waking temperature',
  noteColumn: 'Note',
  flow: _flow,
  term: _term,
  opk: _opk,
);
String _flow(String k) => 'F:$k';
String _term(String k) => 'T:$k';
String _opk(String k) => 'O:$k';

const _noteWithEverything = 'Said "hi", then\nleft';

Profile _profile(Map<String, DayLog> logs) => Profile(goal: Goal.ttc, locale: 'en', logs: logs);

void main() {
  group('DayLog note', () {
    test('is optional, omitted from JSON when null, and read back', () {
      expect(const DayLog(flow: 'light').toJson().containsKey('note'), isFalse);
      final back = DayLog.fromJson(const DayLog(note: 'hello').toJson());
      expect(back.note, 'hello');
      // An older record has no `note` key at all.
      expect(DayLog.fromJson(const {'flow': 'light', 'terms': <String>[]}).note, isNull);
    });

    test('a blank note is no note: the day is empty and is not stored', () {
      expect(const DayLog(note: '  \n').isEmpty, isTrue);
      expect(const DayLog(note: 'x').isEmpty, isFalse);
      final p = _profile(const {}).withDayLog('2026-11-01', const DayLog(note: ' '));
      expect(p.logs, isEmpty);
    });

    test('copyWith keeps the note unless told otherwise, and can clear it', () {
      const log = DayLog(flow: 'light', note: 'kept');
      expect(log.copyWith(flow: 'heavy').note, 'kept');
      expect(log.copyWith(note: null).note, isNull);
    });

    test('Say it keeps an existing note (it merges with copyWith)', () {
      const existing = DayLog(terms: ['cramps'], note: 'my note');
      final merged = existing.copyWith(terms: ['cramps', 'headache'], flow: 'light', opk: 'peak');
      expect(merged.note, 'my note');
    });

    test('survives Profile JSON and the sealed backup', () async {
      final p = _profile({
        '2026-11-01': const DayLog(note: 'عاودني الصداع مساءً'),
        '2026-11-02': const DayLog(flow: 'light', note: _noteWithEverything),
      });
      expect(Profile.fromJson(p.toJson()).logs['2026-11-02']!.note, _noteWithEverything);
      final bytes = await encodeBackup(p, 'ward al nil');
      final restored = await decodeBackup(bytes, 'ward al nil');
      expect(restored.logs['2026-11-01']!.note, 'عاودني الصداع مساءً');
      expect(restored.logs['2026-11-02']!.note, _noteWithEverything);
    });
  });

  group('logsToCsv', () {
    test('starts with a BOM and a header row, ends each record with CRLF', () {
      final csv = logsToCsv(_profile(const {}), _labels);
      expect(csv.startsWith(csvBom), isTrue);
      expect(csv, '${csvBom}Date,Period,Mood,Symptoms,Discharge,Other,Ovulation test,Waking temperature,Note\r\n');
    });

    test('one row per logged day, oldest first, sorted into columns', () {
      final csv = logsToCsv(
        _profile({
          '2026-11-03': const DayLog(opk: 'peak', bbt: 36.6),
          '2026-11-01': const DayLog(flow: 'heavy', terms: ['happy', 'cramps', 'headache', 'intercourse']),
          '2026-11-02': const DayLog(),
        }),
        _labels,
      );
      final lines = const LineSplitter().convert(csv.substring(1));
      expect(lines.length, 3, reason: 'header + two logged days; the empty day has no row');
      expect(lines[1], '2026-11-01,F:heavy,T:happy,T:cramps; T:headache,,T:intercourse,,,');
      expect(lines[2], '2026-11-03,,,,,,O:peak,36.6,');
    });

    test('quotes commas, quotes and line breaks (RFC 4180)', () {
      final csv = logsToCsv(_profile({'2026-11-01': const DayLog(note: _noteWithEverything)}), _labels);
      expect(csv, endsWith(',"Said ""hi"", then\nleft"\r\n'));
      expect(csvField('plain'), 'plain');
      expect(csvField('a,b'), '"a,b"');
    });

    test('Arabic labels and notes survive the UTF-8 bytes', () {
      final arabic = CsvLabels(
        date: 'التاريخ',
        flowColumn: 'الدورة',
        moodColumn: 'المزاج',
        symptomsColumn: 'الأعراض',
        dischargeColumn: 'الإفرازات',
        otherColumn: 'أخرى',
        opkColumn: 'اختبار التبويض',
        temperatureColumn: 'حرارة الاستيقاظ',
        noteColumn: 'ملاحظة',
        flow: (_) => 'خفيف',
        term: (_) => 'صداع',
        opk: (_) => 'إيجابي',
      );
      final csv = logsToCsv(_profile({'2026-11-01': const DayLog(flow: 'light', terms: ['headache'], note: 'ملاحظتي, اليوم')}), arabic);
      final bytes = utf8.encode(csv);
      expect(bytes.take(3), [0xEF, 0xBB, 0xBF]);
      final decoded = utf8.decode(bytes);
      expect(decoded, contains('التاريخ,الدورة'));
      expect(decoded, contains('"ملاحظتي, اليوم"'));
    });

    test('an unknown term key is kept under Other, and hasLogsToExport reflects content', () {
      final p = _profile({'2026-11-01': const DayLog(terms: ['someFutureTerm'])});
      expect(logsToCsv(p, _labels), contains('2026-11-01,,,,,T:someFutureTerm,,,'));
      expect(hasLogsToExport(p), isTrue);
      expect(hasLogsToExport(_profile(const {})), isFalse);
    });

    test('the file name is date-stamped with no personal detail', () {
      expect(csvFileName(DateTime(2026, 11, 3)), 'femio-logs-2026-11-03.csv');
    });
  });
}
