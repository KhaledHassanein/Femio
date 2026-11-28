// Words and icons for the health record's kinds, sources and fields (R11.1).
//
// Why it exists: the list, the editor and later the visit pack all name a kind or a field
// the same way; one place keeps the four languages in step.

import 'package:flutter/material.dart';

import '../../domain/bidi_text.dart';
import '../../domain/health_record.dart';
import '../../domain/record_charts.dart' show bloodPressureUnit;
import '../../l10n/app_localizations.dart';

/// The name of [k] in her language.
String recordKindLabel(L10n l, RecordKind k) => switch (k) {
      RecordKind.visit => l.recKindVisit,
      RecordKind.lab => l.recKindLab,
      RecordKind.bloodPressure => l.chartKindBloodPressure,
      RecordKind.glucose => l.chartKindGlucose,
      RecordKind.imaging => l.recKindImaging,
      RecordKind.medicine => l.recKindMedicine,
      RecordKind.condition => l.recKindCondition,
      RecordKind.allergy => l.recKindAllergy,
      RecordKind.procedure => l.recKindProcedure,
      RecordKind.pregnancy => l.recKindPregnancy,
      RecordKind.document => l.recKindDocument,
      RecordKind.note => l.recKindNote,
    };

/// The icon drawn beside entries of kind [k].
IconData recordKindIcon(RecordKind k) => switch (k) {
      RecordKind.visit => Icons.event_note_outlined,
      RecordKind.lab => Icons.science_outlined,
      RecordKind.bloodPressure => Icons.favorite_border_rounded,
      RecordKind.glucose => Icons.water_drop_outlined,
      RecordKind.imaging => Icons.monitor_heart_outlined,
      RecordKind.medicine => Icons.medication_outlined,
      RecordKind.condition => Icons.history_edu_outlined,
      RecordKind.allergy => Icons.warning_amber_rounded,
      RecordKind.procedure => Icons.healing_outlined,
      RecordKind.pregnancy => Icons.pregnant_woman_rounded,
      RecordKind.document => Icons.description_outlined,
      RecordKind.note => Icons.sticky_note_2_outlined,
    };

/// Where an entry came from, in her language.
String recordSourceLabel(L10n l, RecordSource s) => switch (s) {
      RecordSource.typed => l.recSourceTyped,
      RecordSource.scanned => l.recSourceScanned,
      RecordSource.askFemio => l.recSourceAsk,
      RecordSource.sayIt => l.recSourceSayIt,
      RecordSource.imported => l.recSourceImported,
    };

/// The label of field [name] in the editor.
String recordFieldLabel(L10n l, String name) => switch (name) {
      RecordField.value => l.recFieldValue,
      RecordField.unit => l.recFieldUnit,
      RecordField.printedRange => l.recFieldPrintedRange,
      RecordField.dose => l.recFieldDose,
      RecordField.frequency => l.recFieldFrequency,
      RecordField.startedOn => l.recFieldStartedOn,
      RecordField.endedOn => l.recFieldEndedOn,
      RecordField.prescriber => l.recFieldPrescriber,
      RecordField.place => l.recFieldPlace,
      RecordField.systolic => l.chartFieldSystolic,
      RecordField.diastolic => l.chartFieldDiastolic,
      RecordField.pulse => l.chartFieldPulse,
      RecordField.context => l.chartFieldContext,
      _ => l.recFieldDetails,
    };

/// The fields the editor offers for [k], beyond the title and the day it happened.
List<String> recordFieldsFor(RecordKind k) => switch (k) {
      RecordKind.lab => const [RecordField.value, RecordField.unit, RecordField.printedRange, RecordField.details],
      RecordKind.bloodPressure => const [
          RecordField.systolic,
          RecordField.diastolic,
          RecordField.pulse,
          RecordField.details,
        ],
      RecordKind.glucose => const [RecordField.value, RecordField.unit, RecordField.context, RecordField.details],
      RecordKind.medicine => const [
          RecordField.dose,
          RecordField.frequency,
          RecordField.startedOn,
          RecordField.endedOn,
          RecordField.prescriber,
          RecordField.details,
        ],
      RecordKind.visit || RecordKind.imaging || RecordKind.procedure => const [RecordField.place, RecordField.details],
      _ => const [RecordField.details],
    };

/// Fields stored as ISO days and picked on a calendar, never typed.
const recordDateFields = {RecordField.startedOn, RecordField.endedOn};

/// The words for a glucose reading's [RecordField.context] value, in her language.
String glucoseContextLabel(L10n l, String context) => switch (context) {
      'fasting' => l.chartContextFasting,
      'afterMeal' => l.chartContextAfterMeal,
      _ => l.chartContextOther,
    };

/// One line under the title: the value and unit, or the dose and how often, as written.
/// Each piece is isolated so "0.4 - 4.0" or "400 mcg" never turns around in Arabic. Pass [l]
/// to include a glucose reading's context ("Fasting") in her language.
String recordSummary(RecordEntry e, {L10n? l}) {
  String f(String k) => e.fields[k] ?? '';
  final parts = switch (e.kind) {
    RecordKind.lab => [
        [f(RecordField.value), f(RecordField.unit)].where((s) => s.isNotEmpty).join(' '),
        if (f(RecordField.printedRange).isNotEmpty) '(${f(RecordField.printedRange)})',
      ],
    RecordKind.bloodPressure => [
        if (f(RecordField.systolic).isNotEmpty && f(RecordField.diastolic).isNotEmpty)
          '${f(RecordField.systolic)}/${f(RecordField.diastolic)} $bloodPressureUnit',
        if (f(RecordField.pulse).isNotEmpty) '${f(RecordField.pulse)} bpm',
      ],
    RecordKind.glucose => [
        [f(RecordField.value), f(RecordField.unit)].where((s) => s.isNotEmpty).join(' '),
        if (l != null && f(RecordField.context).isNotEmpty) glucoseContextLabel(l, f(RecordField.context)),
      ],
    RecordKind.medicine => [f(RecordField.dose), f(RecordField.frequency)],
    _ => [f(RecordField.place)],
  };
  return [for (final s in parts) if (s.isNotEmpty) isolateText(s)].join(' · ');
}
