import 'dart:convert';
import 'dart:io';

import 'package:femio/domain/appointments.dart';
import 'package:femio/domain/bbt.dart';
import 'package:femio/domain/contractions.dart';
import 'package:femio/domain/movements.dart';
import 'package:femio/domain/cycle_prediction.dart';
import 'package:femio/domain/pregnancy.dart';
import 'package:femio/domain/weight.dart';
import 'package:flutter_test/flutter_test.dart';

/// The golden fixtures (`fixtures/domain/`, docs/24 §4), run against the Dart twins.
///
/// The website's suite (`apps/web/src/lib/golden-fixtures.test.ts`) loads the same
/// JSON files. Two clients disagreeing about how pregnant she is, or when her period
/// is due, is a safety problem rather than a tidiness one, so the expected values
/// are written once and both languages must reproduce them exactly.
///
/// Every fixture file is either run here or listed in [notYetPorted] with the
/// reason; a new file that is in neither fails, so nothing is silently skipped.
const dir = '../../fixtures/domain';

final runners = <String, Object? Function(Map<String, dynamic>)>{
  'cycle-prediction': (i) => predictNextPeriod(
        List<String>.from(i['starts'] as List),
        i['statedCycleLength'] as int?,
      )?.toJson(),
  'bbt-chart': (i) {
    double r4(double n) => (n * 10000).round() / 10000;
    final chart = bbtChart([
      for (final e in i['entries'] as List)
        BbtEntry(e['id'] as String, e['loggedAt'] as String, (e['bbt'] as num).toDouble()),
    ], i['cycleStart'] as String?);
    if (chart == null) return null;
    return {
      'unit': chart.unit,
      'low': r4(chart.low),
      'high': r4(chart.high),
      'points': [
        for (final p in chart.points)
          {'entryId': p.entryId, 'loggedAt': p.loggedAt, 'cycleDay': p.cycleDay, 'bbt': p.bbt, 'y': r4(p.y)},
      ],
    };
  },
  'contractions': (i) {
    final timed = timeContractions([
      for (final c in i['contractions'] as List) Contraction.fromJson(Map<String, Object?>.from(c as Map)),
    ]);
    return {
      'timed': [
        for (final t in timed)
          {'id': t.contraction.id, 'durationSeconds': t.durationSeconds, 'intervalSeconds': t.intervalSeconds},
      ],
      'summary': summarize(timed).toJson(),
      'inProgress': inProgress(timed)?.contraction.id,
    };
  },
  'movement-pattern': (i) {
    double r4(double n) => (n * 10000).round() / 10000;
    final r = comparePattern([
      for (final s in i['sessions'] as List) MovementSession.fromJson(Map<String, Object?>.from(s as Map)),
    ]);
    return switch (r) {
      InsufficientPattern() => {'status': 'insufficient', 'sessions': r.sessions},
      ComparablePattern() => {
          'status': 'comparable',
          'sessions': r.sessions,
          'typicalMinutesPerMovement': r4(r.typical),
          'latestMinutesPerMovement': r4(r.latest),
          'ratio': r4(r.ratio),
          'slower': r.slower,
        },
    };
  },
  'weight-chart': (i) {
    double r4(double n) => (n * 10000).round() / 10000;
    final c = weightChart([
      for (final e in i['entries'] as List) WeightEntry.fromJson(Map<String, Object?>.from(e as Map)),
    ]);
    if (c == null) return null;
    return {
      'unit': c.unit,
      'low': r4(c.low),
      'high': r4(c.high),
      'changeSinceFirst': c.changeSinceFirst,
      'points': [
        for (final p in c.points)
          {'entryId': p.entryId, 'measuredOn': p.measuredOn, 'value': p.value, 'unit': p.unit, 'y': r4(p.y)},
      ],
    };
  },
  'appointments': (i) {
    final today = i['today'] as String;
    final list = [
      for (final a in i['appointments'] as List) Appointment.fromJson(Map<String, Object?>.from(a as Map)),
    ];
    final s = splitAppointments(list, today);
    return {
      'upcoming': [for (final a in s.upcoming) a.id],
      'past': [for (final a in s.past) a.id],
      'next': nextAppointment(list, today)?.id,
      'awaiting': [for (final a in awaitingResults(list, today)) a.id],
      'daysUntil': {for (final a in list) a.id: daysUntil(a, today)},
    };
  },
  'edd-from': (i) {
    final date = i['date'] as String;
    return switch (i['method']) {
      'lmp' => eddFromLmp(date),
      'conception' => eddFromConception(date),
      'transfer3' => eddFromTransfer(date, embryoDays: 3),
      _ => eddFromTransfer(date, embryoDays: 5),
    };
  },
  'gestational-age': (i) =>
      pregnancyProgress(i['edd'] as String, i['today'] as String)?.toJson(),
};

/// Persona and experience-config logic drives the web app's adaptive screens. The
/// Android v1 (`docs/30_REVAMP/04_ANDROID_APP_SPEC.md`) ports it when Today does.
const notYetPorted = <String>{};

void main() {
  final files = Directory(dir)
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .map((f) => f.uri.pathSegments.last.replaceAll('.json', ''))
      .toList()
    ..sort();

  test('every fixture file is either run or explicitly deferred', () {
    for (final name in files) {
      expect(runners.containsKey(name) || notYetPorted.contains(name), isTrue,
          reason: '$name.json has no Dart runner and is not listed as deferred');
    }
  });

  for (final entry in runners.entries) {
    final json = jsonDecode(File('$dir/${entry.key}.json').readAsStringSync()) as Map;
    final cases = json['cases'] as List;
    group(entry.key, () {
      for (var i = 0; i < cases.length; i++) {
        final c = cases[i] as Map<String, dynamic>;
        test('case $i', () {
          expect(entry.value(c['input'] as Map<String, dynamic>), c['expected']);
        });
      }
    });
  }
}
