// Unit tests for "Say it, several days in one note" (R10.7): the day split, the refusals,
// the 7-day cap, the merge that never deletes, and safety running first.
//
// Every phrase is synthetic. "Today" is Wednesday 2026-11-25 throughout, so Monday is
// 2026-11-23, Tuesday 2026-11-24 and Friday 2026-11-20.

import 'package:femio/data/profile.dart';
import 'package:femio/domain/assistant/log_phrases.dart';
import 'package:femio/domain/assistant/safety.dart';
import 'package:femio/domain/assistant/say_it_days.dart';
import 'package:flutter_test/flutter_test.dart';

const _today = '2026-11-25';

/// Date to the chips the rules found, written as term keys plus `flow:` / `opk:` entries.
Map<String, Set<String>> _read(String note, {String? selected}) {
  final r = readSayItNote(note, today: _today, selectedDate: selected);
  return {
    for (final d in r.daysWithEntries)
      d.date: {...d.draft.terms, if (d.draft.flow != null) 'flow:${d.draft.flow}', if (d.draft.opk != null) 'opk:${d.draft.opk}'},
  };
}

void main() {
  group('English', () {
    test('day words lead their symptoms', () {
      expect(_read('yesterday cramps and headache, today spotting'), {
        '2026-11-24': {'cramps', 'headache'},
        '2026-11-25': {'spotting', 'flow:spotting'},
      });
    });

    test('day words trail their symptoms', () {
      expect(_read('cramps yesterday and spotting today'), {
        '2026-11-24': {'cramps'},
        '2026-11-25': {'spotting', 'flow:spotting'},
      });
    });

    test('the day before yesterday is not read as yesterday', () {
      expect(_read('day before yesterday I was so tired, yesterday cramps'), {
        '2026-11-23': {'fatigue'},
        '2026-11-24': {'cramps'},
      });
    });

    test('"3 days ago" and "a day ago"', () {
      expect(_read('3 days ago headache, today cramps'), {
        '2026-11-22': {'headache'},
        '2026-11-25': {'cramps'},
      });
      expect(_read('a day ago headache'), {'2026-11-24': {'headache'}});
    });

    test('weekday names reach the most recent such day, today included', () {
      expect(_read('on Monday cramps, on Tuesday headache'), {
        '2026-11-23': {'cramps'},
        '2026-11-24': {'headache'},
      });
      expect(_read('Wednesday cramps'), {'2026-11-25': {'cramps'}});
      expect(_read('Thursday cramps'), {'2026-11-19': {'cramps'}});
    });

    test('an explicit date inside the last 7 days', () {
      expect(_read('20/11 cramps, 21.11 headache'), {
        '2026-11-20': {'cramps'},
        '2026-11-21': {'headache'},
      });
      expect(_read('on 2026-11-22 spotting'), {'2026-11-22': {'spotting', 'flow:spotting'}});
    });

    test('a yearless date outside the window is not a day word, and pain scores are not dates', () {
      expect(_read('20/6 cramps'), {_today: {'cramps'}});
      expect(_read('cramps 7/10'), {_today: {'cramps'}});
    });

    test('a phrase that holds the day word still matches', () {
      expect(_read('period today'), {_today: {'flow:medium'}});
    });

    test('negation stays inside its day', () {
      expect(_read('no cramps yesterday, headache today'), {
        '2026-11-25': {'headache'},
      });
    });

    test('the same day named twice is one day', () {
      expect(_read('today cramps. Later, today headache'), {
        _today: {'cramps', 'headache'},
      });
    });
  });

  group('no day word', () {
    test('belongs to the selected day, today by default', () {
      expect(_read('cramps and headache'), {_today: {'cramps', 'headache'}});
      expect(_read('cramps and headache', selected: '2026-11-22'), {
        '2026-11-22': {'cramps', 'headache'},
      });
    });

    test('a sentence without a day word keeps the selected day even after a dated one', () {
      expect(_read('Yesterday cramps. So tired.', selected: '2026-11-21'), {
        '2026-11-24': {'cramps'},
        '2026-11-21': {'fatigue'},
      });
    });

    test('text with nothing to log gives no days with entries', () {
      final r = readSayItNote('hello there', today: _today);
      expect(r.daysWithEntries, isEmpty);
      expect(readSayItNote('   ', today: _today).days, isEmpty);
    });
  });

  group('refusals and the cap', () {
    test('a future day is refused, not logged', () {
      final r = readSayItNote('tomorrow cramps', today: _today);
      expect(r.days, isEmpty);
      expect(r.refused, {SayItRefusal.future});
      expect(readSayItNote('mañana cólicos', today: _today).refused, {SayItRefusal.future});
      expect(readSayItNote('on 2026-11-27 cramps', today: _today).refused, {SayItRefusal.future});
      expect(readSayItNote('26/11 cramps', today: _today).refused, {SayItRefusal.future});
    });

    test('a refused day does not take the other days down with it', () {
      final r = readSayItNote('today cramps, tomorrow headache', today: _today);
      expect(r.daysWithEntries.map((d) => d.date), [_today]);
      expect(r.refused, {SayItRefusal.future});
    });

    test('7 days back is allowed, 8 is refused', () {
      expect(_read('7 days ago cramps'), {'2026-11-18': {'cramps'}});
      final r = readSayItNote('8 days ago cramps', today: _today);
      expect(r.days, isEmpty);
      expect(r.refused, {SayItRefusal.tooOld});
      expect(readSayItNote('on 2026-11-10 cramps', today: _today).refused, {SayItRefusal.tooOld});
    });

    test('"morning" Spanish is not tomorrow', () {
      expect(_read('esta mañana cansada'), {_today: {'fatigue'}});
      expect(_read('por la mañana cansada'), {_today: {'fatigue'}});
    });

    test('a selected day in the future is refused too', () {
      final r = readSayItNote('cramps', today: _today, selectedDate: '2026-11-26');
      expect(r.days, isEmpty);
      expect(r.refused, {SayItRefusal.future});
    });
  });

  group('Egyptian Arabic', () {
    test('امبارح ... والنهارده ...', () {
      expect(_read('امبارح مغص وصداع والنهارده تنقيط'), {
        '2026-11-24': {'cramps', 'headache'},
        '2026-11-25': {'spotting', 'flow:spotting'},
      });
    });

    test('أول امبارح is the day before yesterday', () {
      expect(_read('اول امبارح تعبانة وامبارح مغص'), {
        '2026-11-23': {'fatigue'},
        '2026-11-24': {'cramps'},
      });
    });

    test('قبل 3 ايام and a weekday name', () {
      expect(_read('قبل 3 ايام صداع'), {'2026-11-22': {'headache'}});
      expect(_read('يوم الاتنين مغص'), {'2026-11-23': {'cramps'}});
    });

    test('Arabic-Indic digits in a date', () {
      expect(_read('٢٠/١١ مغص'), {'2026-11-20': {'cramps'}});
    });

    test('بكره is refused', () {
      expect(readSayItNote('بكره مغص', today: _today).refused, {SayItRefusal.future});
    });
  });

  group('Gulf Arabic and MSA', () {
    test('أمس ... واليوم ...', () {
      expect(_read('أمس مغص واليوم نزول خفيف'), {
        '2026-11-24': {'cramps'},
        '2026-11-25': {'flow:light'},
      });
    });

    test('البارحة and قبل يومين', () {
      expect(_read('البارحة صداع وقبل يومين تعب'), {
        '2026-11-24': {'headache'},
        '2026-11-23': {'fatigue'},
      });
    });

    test('غداً is refused', () {
      expect(readSayItNote('غداً مغص', today: _today).refused, {SayItRefusal.future});
    });

    test('"من يومين" (for two days) is not read as 2 days ago', () {
      expect(_read('عندي مغص من يومين'), {_today: {'cramps'}});
    });
  });

  group('French', () {
    test('hier ... aujourd\'hui ...', () {
      expect(_read("hier crampes et mal de tete, aujourd'hui saignements legers"), {
        '2026-11-24': {'cramps', 'headache'},
        '2026-11-25': {'spotting', 'flow:spotting'},
      });
    });

    test('avant-hier, il y a 2 jours and a weekday', () {
      expect(_read('avant-hier fatiguée'), {'2026-11-23': {'fatigue'}});
      expect(_read('il y a 2 jours migraine'), {'2026-11-23': {'headache'}});
      expect(_read('lundi crampes'), {'2026-11-23': {'cramps'}});
    });

    test('demain is refused', () {
      expect(readSayItNote('demain crampes', today: _today).refused, {SayItRefusal.future});
    });
  });

  group('Spanish', () {
    test('ayer ... hoy ...', () {
      expect(_read('ayer dolor de cabeza y hoy cólicos'), {
        '2026-11-24': {'headache'},
        '2026-11-25': {'cramps'},
      });
    });

    test('anteayer, hace 2 días and a weekday', () {
      expect(_read('anteayer cansada'), {'2026-11-23': {'fatigue'}});
      expect(_read('hace 2 días jaqueca'), {'2026-11-23': {'headache'}});
      expect(_read('el lunes cólicos'), {'2026-11-23': {'cramps'}});
    });
  });

  group('safety first', () {
    test('a danger sign anywhere in the note is found before and whatever the split does', () {
      final r = readSayItNote('yesterday cramps, today chest pain', today: _today);
      expect(r.signal, SafetySignal.urgent);
      expect(r.daysWithEntries.map((d) => d.date), ['2026-11-24']);
    });

    test('a danger sign in a refused day still raises the notice', () {
      final r = readSayItNote('tomorrow chest pain', today: _today);
      expect(r.signal, SafetySignal.urgent);
      expect(r.days, isEmpty);
    });

    test('a calm note raises nothing', () {
      expect(readSayItNote('yesterday cramps', today: _today).signal, SafetySignal.none);
    });
  });

  group('saving', () {
    test('merging keeps everything already on the day', () {
      const before = DayLog(flow: 'medium', terms: ['cramps', 'fatigue'], bbt: 36.6);
      const draft = LogDraft(terms: ['cramps', 'headache']);
      final after = mergeIntoDayLog(before, draft);
      expect(after.terms, containsAll(['cramps', 'fatigue', 'headache']));
      expect(after.terms.where((t) => t == 'cramps'), hasLength(1));
      expect(after.flow, 'medium');
      expect(after.bbt, 36.6);
    });

    test('a flow named in the note is added, an unnamed one is kept', () {
      expect(mergeIntoDayLog(const DayLog(), const LogDraft(flow: 'light')).flow, 'light');
      expect(mergeIntoDayLog(const DayLog(flow: 'heavy', opk: 'negative'), const LogDraft(terms: ['cramps'])).flow, 'heavy');
    });

    test('unticked chips are left out and the count matches what is saved', () {
      const draft = LogDraft(terms: ['cramps', 'headache'], flow: 'spotting', opk: 'positive');
      expect(entryCount(draft), 4);
      final kept = draftWithout(draft, {'headache', 'flow:spotting'});
      expect(kept.terms, ['cramps']);
      expect(kept.flow, isNull);
      expect(kept.opk, 'positive');
      expect(entryCount(kept), 2);
    });

    test('the days come back oldest first, so the cards read in time order', () {
      final r = readSayItNote('today cramps, 3 days ago headache, yesterday tired', today: _today);
      expect(r.days.map((d) => d.date), ['2026-11-22', '2026-11-24', '2026-11-25']);
    });
  });
}
