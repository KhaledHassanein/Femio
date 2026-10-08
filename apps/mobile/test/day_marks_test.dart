import 'package:femio/data/profile.dart';
import 'package:femio/domain/day_marks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const base = Profile(goal: Goal.ttc, locale: 'en', periodStarts: ['2026-10-01'], cycleLength: 28);

  test('logged bleeding, spotting and symptoms are facts; the window is an estimate', () {
    final p = base
        .withDayLog('2026-10-02', const DayLog(flow: 'medium'))
        .withDayLog('2026-10-12', const DayLog(flow: 'spotting', terms: ['cramps']));
    final m = dayMarks(p, today: '2026-10-14', from: '2026-10-01', to: '2026-11-30');
    expect(m['2026-10-02']!.bleed, isTrue);
    expect(m['2026-10-12']!.spotting, isTrue);
    expect(m['2026-10-12']!.logged, isTrue);
    expect(m['2026-10-12']!.bleed, isFalse, reason: 'spotting never counts as a period');
    // Stated 28 days from 1 Oct → 29 Oct ± 4; ovulation 14 days before.
    expect(m['2026-10-25']!.predicted, isTrue);
    expect(m['2026-11-02']!.predicted, isTrue);
    expect(m['2026-10-15']!.ovulation, isTrue);
  });

  test('no estimate is drawn on a day already lived', () {
    final m = dayMarks(base, today: '2026-10-20', from: '2026-10-01', to: '2026-10-31');
    expect(m['2026-10-15']?.ovulation ?? false, isFalse);
    expect(m['2026-10-27']!.predicted, isTrue);
  });

  test('logging a bleed adds it to the prediction; clearing it removes it', () {
    final logged = base.withDayLog('2026-10-29', const DayLog(flow: 'heavy'));
    expect(logged.periodStarts, ['2026-10-01', '2026-10-29']);
    final cleared = logged.withDayLog('2026-10-29', const DayLog());
    expect(cleared.periodStarts, ['2026-10-01']);
    expect(cleared.logs.containsKey('2026-10-29'), isFalse);
  });

  test('the record survives a save and load', () {
    final p = base.withDayLog('2026-10-03', const DayLog(flow: 'light', terms: ['headache', 'calm']));
    final back = Profile.fromJson(p.toJson());
    expect(back.logs['2026-10-03']!.terms, ['headache', 'calm']);
    expect(back.periodStarts, p.periodStarts);
  });
}
