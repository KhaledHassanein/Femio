// Saves her logs as a spreadsheet (CSV) file wherever she chooses (R9.10).
//
// Why it exists: the sealed backup is for restoring femio; this file is for reading in a
// spreadsheet or showing a clinician. It uses the same save dialog as the backup
// (Storage Access Framework: she picks the place, the app sees only that file), so
// nothing is written anywhere she did not choose and nothing is sent by the app. Unlike
// the backup it is plain text, which the Settings row says in one sentence.

import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../data/profile.dart';
import '../../domain/csv_export.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/log_labels.g.dart';

/// The spreadsheet's words in the app language [l].
CsvLabels csvLabelsFor(L10n l) => CsvLabels(
      date: l.csvColumnDate,
      flowColumn: l.sectionPeriod,
      moodColumn: l.sectionMood,
      symptomsColumn: l.sectionSymptoms,
      dischargeColumn: l.sectionDischarge,
      otherColumn: l.csvColumnOther,
      opkColumn: l.sectionOvulationTest,
      temperatureColumn: l.sectionTemperature,
      noteColumn: l.logNoteSection,
      flow: (k) => flowLabel(l, k),
      term: (k) => logLabel(l, k),
      opk: (k) => opkLabel(l, k),
    );

/// Builds the CSV from [profile] and lets her save it. Says so when there is nothing to
/// export, and confirms after the file is saved; does nothing if she cancels.
Future<void> exportCsvFlow(BuildContext context, Profile profile) async {
  final l = L10n.of(context);
  final messenger = ScaffoldMessenger.of(context);
  if (!hasLogsToExport(profile)) {
    messenger.showSnackBar(SnackBar(content: Text(l.csvNothingToExport)));
    return;
  }
  final bytes = Uint8List.fromList(utf8.encode(logsToCsv(profile, csvLabelsFor(l))));
  final saved = await FilePicker.saveFile(
    dialogTitle: l.exportCsv,
    fileName: csvFileName(DateTime.now()),
    bytes: bytes,
  );
  if (saved != null) messenger.showSnackBar(SnackBar(content: Text(l.csvSaved)));
}
