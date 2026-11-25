// The calendar explainers say what the rules did, with her numbers (R9.6, R10.13).
//
// Why it exists: an explanation that disagrees with the calendar is worse than none. Each
// case builds a synthetic record, asks the explainer, and checks it against the same rule
// constants the prediction uses; the sentence tests check the words in English and Arabic.

import 'dart:ui';

import 'package:femio/data/profile.dart';
import 'package:femio/domain/cycle_prediction.dart';
import 'package:femio/domain/dates.dart';
import 'package:femio/domain/fertility.dart';
import 'package:femio/domain/prediction_explain.dart';
import 'package:femio/features/calendar/prediction_sheets.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Period starts every [lengths] days from 2026-01-05.
List<String> _starts(List<int> lengths) {
  var d = '2026-01-05';
  final out = [d];
  for (final n in lengths) {
    d = addDays(d, n);
    out.add(d);
  }
  return out;
}

Profile _p(Goal goal, List<String> starts, {int? cycleLength, bool irregular = false, Map<String, DayLog> logs = const {}}) =>
    Profile(goal: goal, locale: 'en', periodStarts: starts, cycleLength: cycleLength, irregular: irregular, logs: logs);

String _range(String a, String b) => '$a–$b';

void main() {
  group('explainRange', () {
    test('one logged period: starts from the stated length; three cycles to medium', () {
      final e = explainRange(_p(Goal.period, ['2026-01-05'], cycleLength: 28))!;
      expect(e.prediction.basis, 'stated');
      expect((e.nextLevel, e.cyclesToNextLevel), (Confidence.medium, mediumConfidenceCycles));
      expect(e.window, isNull, reason: 'period mode offers no window');
    });

    test('three steady cycles: medium, three more to high', () {
      final e = explainRange(_p(Goal.period, _starts([28, 28, 28])))!;
      expect(e.prediction.confidence, Confidence.medium);
      expect((e.nextLevel, e.cyclesToNextLevel), (Confidence.high, highConfidenceCycles - 3));
    });

    test('six steady cycles: high, nothing further to reach', () {
      final e = explainRange(_p(Goal.period, _starts([28, 29, 28, 27, 28, 29])))!;
      expect(e.prediction.confidence, Confidence.high);
      expect(e.nextLevel, isNull);
    });

    test('medium but varying more than the high limit: no step promised', () {
      final e = explainRange(_p(Goal.period, _starts([26, 32, 29])))!;
      expect(e.prediction.confidence, Confidence.medium);
      expect(e.prediction.evidence.spread, greaterThan(highConfidenceSpreadDays));
      expect(e.nextLevel, isNull);
    });

    test('irregular cycles in TTC: no step, no window, says why', () {
      final e = explainRange(_p(Goal.ttc, _starts([24, 38, 30])))!;
      expect(e.prediction.irregular, isTrue);
      expect(e.nextLevel, isNull);
      expect(e.window, WindowStatus.irregular);
    });

    test('one measured cycle in TTC: window withheld while learning', () {
      final e = explainRange(_p(Goal.ttc, _starts([28])))!;
      expect(e.window, WindowStatus.learning);
    });

    test('steady TTC cycles: the window is shown', () {
      expect(explainRange(_p(Goal.ttc, _starts([28, 28, 28])))!.window, WindowStatus.shown);
    });

    test('pregnancy and menopause draw no prediction to explain', () {
      expect(explainRange(_p(Goal.pregnant, _starts([28, 28]))), isNull);
      expect(explainRange(_p(Goal.menopause, _starts([28, 28]))), isNull);
    });
  });

  group('explainDay', () {
    final starts = _starts([28, 28, 28]); // last start 2026-03-30, next around 2026-04-27
    final ttc = _p(Goal.ttc, starts, logs: {'2026-04-02': const DayLog(terms: ['cramps'])});
    final next = predictNextPeriod(starts)!;

    test('a future day inside the next period range names that range', () {
      final e = explainDay(ttc, day: next.predictedStart, today: '2026-04-10');
      expect(e.future, isTrue);
      expect(e.periodIndex, 0);
      expect(e.period!.windowStart, next.windowStart);
      expect(e.hasEstimate, isTrue);
    });

    test('a day in the fertile window names the window the calendar draws', () {
      final w = fertileWindowFor(ttc, next)!;
      final e = explainDay(ttc, day: w.windowStart, today: '2026-04-01');
      expect(e.mark.fertile, isTrue);
      expect(e.fertile!.windowEnd, w.windowEnd);
    });

    test('a past day shows what she logged and no estimate', () {
      final e = explainDay(ttc, day: '2026-04-02', today: '2026-04-10');
      expect((e.future, e.mark.logged, e.hasEstimate), (false, true, false));
    });
  });

  group('predictionChange', () {
    test('logging a new period moves the next range', () {
      final before = _p(Goal.period, _starts([28, 28, 28]));
      final after = before.copyWith(periodStarts: [...before.periodStarts, '2026-04-30']);
      final c = predictionChange(before, after)!;
      expect(c.before, isNotNull);
      expect(c.after.windowStart.compareTo(c.before!.windowStart), greaterThan(0));
    });

    test('the first prediction has nothing before it', () {
      final before = _p(Goal.period, ['2026-01-05']);
      final after = before.copyWith(periodStarts: ['2026-01-05', '2026-02-02']);
      final c = predictionChange(before, after)!;
      expect(c.before, isNull);
    });

    test('a change that moves nothing says nothing', () {
      final p = _p(Goal.period, _starts([28, 28, 28]));
      expect(predictionChange(p, p.withDayLog('2026-04-03', const DayLog(terms: ['headache']))), isNull);
    });
  });

  for (final lang in ['en', 'ar']) {
    group('sentences ($lang)', () {
      late L10n l;
      setUpAll(() async => l = await L10n.delegate.load(Locale(lang)));

      test('why this range: measured, steadiness, the next step and the window', () {
        final lines = whyRangeLines(l, explainRange(_p(Goal.ttc, _starts([28, 28, 28])))!);
        expect(lines, [
          l.whyRangeCycles(3),
          l.whyRangeAverage(l.daysValue(28)),
          l.whyRangeSpreadNone(l.daysValue(2)),
          l.whyRangeNextHigh(3),
          l.whyRangeWindowShown,
        ]);
      });

      test('why this range: irregular quotes the rule limit and never says late', () {
        final lines = whyRangeLines(l, explainRange(_p(Goal.ttc, _starts([24, 38, 30])))!);
        expect(lines, contains(l.whyRangeIrregular(l.daysValue(irregularSpreadDays))));
        expect(lines, contains(l.whyRangeWindowIrregular));
      });

      test('explain this day: an estimate always carries the estimate note', () {
        final p = _p(Goal.period, _starts([28, 28, 28]));
        final next = predictNextPeriod(p.periodStarts)!;
        final lines = dayLines(l, explainDay(p, day: next.predictedStart, today: '2026-04-10'), _range);
        expect(lines.first, l.dayFactNextPeriod(_range(next.windowStart, next.windowEnd)));
        expect(lines.last, l.predictionNote);
        final empty = dayLines(l, explainDay(p, day: '2026-03-20', today: '2026-04-10'), _range);
        expect(empty, [l.dayFactNothingPast]);
      });

      test('a moved estimate is two ranges, never one date', () {
        final before = _p(Goal.period, _starts([28, 28, 28]));
        final after = before.copyWith(periodStarts: [...before.periodStarts, '2026-04-30']);
        final c = predictionChange(before, after)!;
        expect(
          predictionChangeText(l, c, _range),
          l.predictionMoved(_range(c.after.windowStart, c.after.windowEnd), _range(c.before!.windowStart, c.before!.windowEnd)),
        );
      });
    });
  }
}
