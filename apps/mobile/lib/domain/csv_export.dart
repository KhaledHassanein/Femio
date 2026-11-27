// Her own logs as a spreadsheet (CSV), built from the record (R9.10).
//
// Why it exists: a clinician, a spreadsheet or her own curiosity may want the logs in
// rows. This is a pure function (no files, no UI): the screen hands it her record and
// the labels in her app language, and gets text back. The labels come in as data, so
// this file needs no localisation code and the same function serves every language
// (a header and a term name in her language read better to her than stable keys).

import '../data/profile.dart';
import 'log_vocabulary.g.dart';

/// UTF-8 byte-order mark. Excel opens a CSV as the local ANSI code page unless it
/// sees this, which turns Arabic into question marks.
const csvBom = '﻿';

/// RFC 4180 ends every record with CRLF.
const csvLineBreak = '\r\n';

/// Between several terms in one cell ("Cramps; Headache").
const csvTermSeparator = '; ';

/// The words the spreadsheet uses, in her language. Built by the caller from the app's
/// localised strings.
class CsvLabels {
  const CsvLabels({
    required this.date,
    required this.flowColumn,
    required this.moodColumn,
    required this.symptomsColumn,
    required this.dischargeColumn,
    required this.otherColumn,
    required this.opkColumn,
    required this.temperatureColumn,
    required this.noteColumn,
    required this.flow,
    required this.term,
    required this.opk,
  });

  final String date;
  final String flowColumn;
  final String moodColumn;
  final String symptomsColumn;
  final String dischargeColumn;
  final String otherColumn;
  final String opkColumn;
  final String temperatureColumn;
  final String noteColumn;

  /// Flow level key (`light`) to its name.
  final String Function(String key) flow;

  /// Log term key (`cramps`) to its name.
  final String Function(String key) term;

  /// Ovulation-test result key (`peak`) to its name.
  final String Function(String key) opk;

  /// The header row, in column order.
  List<String> get headers => [
        date,
        flowColumn,
        moodColumn,
        symptomsColumn,
        dischargeColumn,
        otherColumn,
        opkColumn,
        temperatureColumn,
        noteColumn,
      ];
}

/// One CSV field, quoted when it holds a comma, a quote or a line break (RFC 4180).
String csvField(String value) {
  final needsQuotes = value.contains(',') || value.contains('"') || value.contains('\n') || value.contains('\r');
  return needsQuotes ? '"${value.replaceAll('"', '""')}"' : value;
}

/// Whether [profile] has any logged day to export.
bool hasLogsToExport(Profile profile) => profile.logs.values.any((l) => !l.isEmpty);

/// The CSV text for [profile]: a BOM, a header row, then one row per logged day, oldest
/// first. Dates stay ISO (`2026-11-02`) so they sort and parse anywhere; term names use
/// [labels]. Weights and appointments are not included. An empty record yields the
/// header row alone.
String logsToCsv(Profile profile, CsvLabels labels) {
  final dimensionOf = {for (final t in logTerms) t.key: t.dimension};
  final dates = profile.logs.keys.where((d) => !profile.logs[d]!.isEmpty).toList()..sort();

  String names(DayLog log, bool Function(LogDimension? d) wanted) =>
      log.terms.where((k) => wanted(dimensionOf[k])).map(labels.term).join(csvTermSeparator);

  List<String> row(String date) {
    final log = profile.logs[date]!;
    return [
      date,
      log.flow == null ? '' : labels.flow(log.flow!),
      names(log, (d) => d == LogDimension.mood),
      // Her own "Other" words follow the ticked symptoms in the same column.
      [
        if (names(log, (d) => d == LogDimension.symptom) case final n when n.isNotEmpty) n,
        if (log.hasOtherSymptoms) log.otherSymptoms!.trim(),
      ].join(csvTermSeparator),
      names(log, (d) => d == LogDimension.discharge),
      // Intercourse terms and any key this build does not know land here, never lost.
      names(log, (d) => d != LogDimension.mood && d != LogDimension.symptom && d != LogDimension.discharge),
      log.opk == null ? '' : labels.opk(log.opk!),
      log.bbt?.toString() ?? '',
      log.hasNote ? log.note!.trim() : '',
    ];
  }

  final rows = [labels.headers, for (final d in dates) row(d)];
  return csvBom + rows.map((r) => r.map(csvField).join(',')).join(csvLineBreak) + csvLineBreak;
}

/// A file name for the export: date-stamped, no personal detail.
String csvFileName(DateTime now) =>
    'femio-logs-${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.csv';
