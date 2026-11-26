import 'package:femio/data/profile.dart';
import 'package:femio/domain/cycle_prediction.dart';
import 'package:femio/domain/day_marks.dart';
import 'package:femio/domain/fertility.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const base = Profile(
    goal: Goal.ttc,
    locale: 'en',
    periodStarts: ['2026-10-01'],
    cycleLength: 28,
  );

  test('logged bleeding, spotting and symptoms are facts; the window is an estimate', () {
    final p = base
        .withDayLog('2026-10-02', const DayLog(flow: 'medium'))
        .withDayLog(
          '2026-10-12',
          const DayLog(flow: 'spotting', terms: ['cramps']),
        );
    final m = dayMarks(
      p,
      today: '2026-10-14',
      from: '2026-10-01',
      to: '2026-11-30',
    );
    expect(m['2026-10-02']!.bleed, isTrue);
    expect(m['2026-10-12']!.spotting, isTrue);
    expect(m['2026-10-12']!.logged, isTrue);
    expect(
      m['2026-10-12']!.bleed,
      isFalse,
      reason: 'spotting never counts as a period',
    );
    // Stated 28 days from 1 Oct → 29 Oct ± 4; ovulation 14 days before.
    expect(m['2026-10-25']!.predicted, isTrue);
    expect(m['2026-11-02']!.predicted, isTrue);
    expect(m['2026-10-15']!.ovulation, isTrue);
  });

  // MR-57 (owner 2026-11-26): this cycle's window stays visible after it passes;
  // a past range for a period that has not come is not drawn (no "late" counter).
  test("this cycle's window stays after it passes; past period ranges do not", () {
    final m = dayMarks(
      base,
      today: '2026-10-20',
      from: '2026-10-01',
      to: '2026-10-31',
    );
    expect(m['2026-10-15']!.ovulation, isTrue);
    expect(m['2026-10-10']!.fertile, isTrue);
    expect(m['2026-10-27']!.predicted, isTrue);
    final late = dayMarks(base, today: '2026-11-03', from: '2026-10-20', to: '2026-11-10');
    expect(late['2026-10-28']?.predicted ?? false, isFalse);
  });

  test('a window from a cycle before her last period is not drawn', () {
    final p = base.withDayLog('2026-10-29', const DayLog(flow: 'heavy'));
    final m = dayMarks(p, today: '2026-11-02', from: '2026-10-01', to: '2026-10-31');
    expect(m['2026-10-15']?.ovulation ?? false, isFalse);
  });

  // Owner 2026-11-26: a new user saw only one marked day. She gave a start, a period
  // length and a regular cycle length, so her month should show all of it.
  test('a new user sees her period days, this window, and three periods ahead', () {
    const p = Profile(
      goal: Goal.ttc,
      locale: 'en',
      periodStarts: ['2026-11-05'],
      periodLength: 5,
      cycleLength: 28,
    );
    final m = dayMarks(p, today: '2026-11-26', from: '2026-11-01', to: '2027-02-28');
    for (final d in ['2026-11-05', '2026-11-07', '2026-11-09']) {
      expect(m[d]!.bleed, isTrue, reason: d);
    }
    expect(m['2026-11-10']?.bleed ?? false, isFalse);
    // 3 Dec ± 4; ovulation 14 days before, window the six days ending on it.
    expect(m['2026-11-19']!.ovulation, isTrue);
    expect(m['2026-11-14']!.fertile, isTrue);
    expect(m['2026-12-03']!.predicted, isTrue);
    final ovulation = [for (final e in m.entries) if (e.value.ovulation) e.key]..sort();
    expect(ovulation, ['2026-11-19', '2026-12-17', '2027-01-14']);
    expect(m['2027-01-28']!.possible, isTrue, reason: 'the third period is low confidence');
  });

  test('period days still ahead are expected, and a logged flow keeps its word', () {
    final p = const Profile(
      goal: Goal.period,
      locale: 'en',
      periodStarts: ['2026-11-24'],
      periodLength: 5,
      cycleLength: 28,
    ).withDayLog('2026-11-25', const DayLog(flow: 'spotting'));
    final m = dayMarks(p, today: '2026-11-26', from: '2026-11-20', to: '2026-11-30');
    expect(m['2026-11-25']!.bleed, isFalse);
    expect(m['2026-11-25']!.spotting, isTrue);
    expect(m['2026-11-26']!.bleed, isTrue);
    expect(m['2026-11-28']!.bleed, isFalse);
    expect(m['2026-11-28']!.predicted, isTrue);
  });

  test('logging a bleed adds it to the prediction; clearing it removes it', () {
    final logged = base.withDayLog('2026-10-29', const DayLog(flow: 'heavy'));
    expect(logged.periodStarts, ['2026-10-01', '2026-10-29']);
    final cleared = logged.withDayLog('2026-10-29', const DayLog());
    expect(cleared.periodStarts, ['2026-10-01']);
    expect(cleared.logs.containsKey('2026-10-29'), isFalse);
  });

  test('the record survives a save and load', () {
    final p = base.withDayLog(
      '2026-10-03',
      const DayLog(flow: 'light', terms: ['headache', 'calm']),
    );
    final back = Profile.fromJson(p.toJson());
    expect(back.logs['2026-10-03']!.terms, ['headache', 'calm']);
    expect(back.periodStarts, p.periodStarts);
  });

  // R8.10 / MR-51: after steady cycles the next three periods are drawn as widening
  // ranges; the low-confidence one is "possible" (dashed). R8.9: ovulation sits in the window.
  test('steady cycles show the next three periods, the last as possible', () {
    const p = Profile(
      goal: Goal.ttc,
      locale: 'en',
      periodStarts: [
        '2026-01-01',
        '2026-01-29',
        '2026-02-26',
        '2026-03-26',
        '2026-04-23',
        '2026-05-21',
        '2026-06-18',
      ],
    );
    final m = dayMarks(
      p,
      today: '2026-06-20',
      from: '2026-06-20',
      to: '2026-09-30',
    );
    for (final d in [
      '2026-07-14',
      '2026-07-18',
      '2026-08-10',
      '2026-08-16',
      '2026-09-06',
      '2026-09-14',
    ]) {
      expect(m[d]?.predicted ?? false, isTrue, reason: d);
    }
    expect(m['2026-07-16']!.possible, isFalse, reason: 'high confidence');
    expect(m['2026-08-13']!.possible, isFalse, reason: 'medium confidence');
    expect(m['2026-09-10']!.possible, isTrue, reason: 'low confidence');
    expect(m['2026-09-15']?.predicted ?? false, isFalse);
    final ovulation = m.entries
        .where((e) => e.value.ovulation)
        .map((e) => e.key)
        .toList();
    // MR-57: a window before each of the three periods.
    expect(ovulation, ['2026-07-02', '2026-07-30', '2026-08-27']);
    expect(
      m['2026-07-02']!.fertile,
      isTrue,
      reason: 'the ovulation day is inside the fertile window',
    );
  });

  test('irregular cycles show only the next period', () {
    const p = Profile(
      goal: Goal.period,
      locale: 'en',
      periodStarts: ['2026-03-01', '2026-03-27', '2026-05-04', '2026-06-02'],
    );
    final m = dayMarks(
      p,
      today: '2026-06-05',
      from: '2026-06-05',
      to: '2026-10-31',
    );
    expect(m['2026-07-03']!.predicted, isTrue);
    expect(
      m.entries.where(
        (e) => e.value.predicted && e.key.compareTo('2026-07-20') > 0,
      ),
      isEmpty,
    );
  });

  test('Today headlines the next window once this one has passed', () {
    const p = Profile(goal: Goal.ttc, locale: 'en', periodStarts: ['2026-11-05'], cycleLength: 28);
    final prediction = predictNextPeriod(p.periodStarts, p.cycleLength)!;
    expect(currentOrNextFertileWindow(p, prediction, '2026-11-16')!.ovulation, '2026-11-19');
    expect(currentOrNextFertileWindow(p, prediction, '2026-11-26')!.ovulation, '2026-12-17');
  });

  test('a day with only a note is logged; a blank note is not', () {
    final p = base
        .withDayLog('2026-10-05', const DayLog(note: 'new tablets today'))
        .withDayLog('2026-10-06', const DayLog(note: '   '));
    final m = dayMarks(p, today: '2026-10-14', from: '2026-10-01', to: '2026-10-31');
    expect(m['2026-10-05']!.logged, isTrue);
    expect(m['2026-10-06']?.logged ?? false, isFalse);
  });
}
