// The folded symptom list (owner 2026-11-27): today's ticks first, then her most-logged,
// then the vocabulary order; and "Other" words are kept with the day.

import 'package:femio/data/profile.dart';
import 'package:femio/domain/csv_export.dart';
import 'package:femio/domain/quick_symptoms.dart';
import 'package:femio/features/log/widgets/symptoms_section.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('with nothing logged, the first five of the vocabulary', () {
    expect(quickSymptoms(const {}, const DayLog()), ['cramps', 'headache', 'bloating', 'breastTenderness', 'backache']);
  });

  test("today's ticks come first and are never hidden, then her most-logged", () {
    final logs = {
      '2026-11-01': const DayLog(terms: ['fatigue', 'acne']),
      '2026-11-02': const DayLog(terms: ['fatigue', 'happy']),
      '2026-11-03': const DayLog(terms: ['acne', 'fatigue']),
    };
    final today = const DayLog(terms: ['dizziness', 'nausea']);
    expect(quickSymptoms(logs, today), ['nausea', 'dizziness', 'fatigue', 'acne', 'cramps']);
  });

  test('more than five ticked today: all of them show', () {
    final today = const DayLog(terms: ['cramps', 'headache', 'bloating', 'acne', 'fatigue', 'nausea']);
    expect(quickSymptoms(const {}, today), hasLength(6));
  });

  test('"Other" words survive a round trip, count as logged, and reach the CSV', () {
    const day = DayLog(terms: ['cramps'], otherSymptoms: 'jaw pain');
    final back = DayLog.fromJson(day.toJson());
    expect(back.otherSymptoms, 'jaw pain');
    expect(const DayLog(otherSymptoms: 'jaw pain').isEmpty, isFalse);
    expect(const DayLog(otherSymptoms: '  ').isEmpty, isTrue);
    expect(DayLog.fromJson(const {'flow': null, 'terms': []}).otherSymptoms, isNull);
    String same(String k) => k;
    final labels = CsvLabels(
      date: 'Date',
      flowColumn: 'Period',
      moodColumn: 'Mood',
      symptomsColumn: 'Symptoms',
      dischargeColumn: 'Discharge',
      otherColumn: 'Other',
      opkColumn: 'Ovulation test',
      temperatureColumn: 'Waking temperature',
      noteColumn: 'Note',
      flow: same,
      term: same,
      opk: same,
    );
    final csv = logsToCsv(const Profile(goal: Goal.period, locale: 'en', logs: {'2026-11-03': day}), labels);
    expect(csv, contains('cramps; jaw pain'));
  });

  testWidgets('"Other" opens a field; her words are saved after a pause; "Show all" unfolds', (tester) async {
    final l = await L10n.delegate.load(const Locale('en'));
    final saved = <String?>[];
    await tester.pumpWidget(MaterialApp(
      theme: FemioTheme.light(),
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: SymptomsSection(logs: const {}, day: const DayLog(), onToggle: (_) {}, onOther: saved.add),
        ),
      ),
    ));
    expect(find.text(l.logAcne), findsNothing);
    await tester.tap(find.text(l.symptomOther));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'jaw pain');
    await tester.pump(otherSymptomSaveDelay + const Duration(milliseconds: 50));
    expect(saved, ['jaw pain']);
    await tester.tap(find.text(l.symptomsShowAll));
    await tester.pumpAndSettle();
    expect(find.text(l.logAcne), findsOneWidget);
  });
}
