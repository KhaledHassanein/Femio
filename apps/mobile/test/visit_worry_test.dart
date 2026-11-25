// The visit companion reads her worry with the rules first, then suggests reviewed questions
// that fit her worry and her stage, and saves only into her visit list (R10.2).
//
// Why it exists: a question list must never answer a danger sign, never suggest a question
// written for another life stage, and never lose or reorder what she wrote. Every case uses a
// synthetic record.

import 'dart:ui';

import 'package:femio/data/profile.dart';
import 'package:femio/domain/appointments.dart';
import 'package:femio/domain/assistant/safety.dart';
import 'package:femio/domain/assistant/tip_catalogue.g.dart';
import 'package:femio/domain/assistant/topic_lexicon.dart';
import 'package:femio/domain/assistant/visit_summary.dart';
import 'package:femio/domain/assistant/visit_worry.dart';
import 'package:femio/features/assistant/visit_pack.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

const _today = '2026-06-20';

Profile _p(Goal goal, {List<Appointment> appointments = const []}) => Profile(
      goal: goal,
      locale: 'en',
      periodStarts: const ['2026-05-01', '2026-05-29'],
      edd: goal == Goal.pregnant ? '2026-10-01' : null,
      appointments: appointments,
    );

void main() {
  group('the question-topic table', () {
    final topicIds = {for (final t in topics) t.id};
    final questionIds = {...visitQuestionEnglish.keys, ...catalogueQuestionEnglish.keys}..remove('anythingElse');

    test('every question in both banks has topics, and every topic exists', () {
      expect(questionTopics.keys.toSet(), questionIds);
      for (final MapEntry(key: id, value: ts) in questionTopics.entries) {
        expect(ts, isNotEmpty, reason: id);
        expect(topicIds.containsAll(ts), isTrue, reason: '$id: ${ts.difference(topicIds)}');
        expect(ts.where(isBroadTopic), isEmpty, reason: '$id uses a broad topic');
      }
    });

    test('every question is written for at least one stage', () {
      for (final id in questionIds) {
        expect(questionStages(id), isNotEmpty, reason: id);
      }
    });
  });

  group('matchWorry', () {
    test('period pain in English and Arabic finds the pain questions', () {
      for (final worry in ['My period pain is getting worse', 'عندي مغص شديد مع الدورة']) {
        final m = matchWorry(worry, _p(Goal.period), _today);
        expect(m.signal, SafetySignal.none);
        expect(m.questionIds.first, 'painCauseChecks', reason: worry);
        expect(m.questionIds, isNot(contains('painfulPeriods')), reason: 'superseded by the narrower question');
      }
    });

    test('a question written for another stage is never suggested', () {
      final m = matchWorry('I have bad cramps every month', _p(Goal.ttc), _today);
      expect(m.questionIds, contains('painfulPeriods'));
      expect(m.questionIds, isNot(contains('painCauseChecks')), reason: 'the catalogue item is for the period stage');
    });

    test('more shared topics rank first, and never more than the cap', () {
      final m = matchWorry('heavy periods and I am always tired', _p(Goal.period), _today);
      expect(m.questionIds.first, 'heavyAndTiredBloodTest');
      expect(m.questionIds.length, lessThanOrEqualTo(maxWorryQuestions));
    });

    test('the safety rules run first: a danger sign suggests nothing', () {
      final crisis = matchWorry('I want to die', _p(Goal.period), _today);
      expect(crisis.signal, SafetySignal.crisis);
      expect(crisis.questionIds, isEmpty);
      final pregnant = matchWorry('the baby moving less since yesterday', _p(Goal.pregnant), _today);
      expect(pregnant.signal, SafetySignal.pregnancyWarning);
      expect(pregnant.questionIds, isEmpty);
      final contraception = matchWorry('which birth control is best', _p(Goal.period), _today);
      expect(contraception.signal, SafetySignal.birthControl);
      expect(contraception.questionIds, isEmpty);
    });

    test('a worry with no known topic keeps her words and suggests nothing', () {
      final m = matchWorry('my knee clicks on the stairs', _p(Goal.period), _today);
      expect(m.questionIds, isEmpty);
      expect(m.ownWords, 'my knee clicks on the stairs');
    });

    test('her words are capped', () {
      final m = matchWorry('a' * (maxWorryLength + 40), _p(Goal.period), _today);
      expect(m.ownWords.length, maxWorryLength);
    });
  });

  test('the example in every language finds a question', () async {
    for (final lang in ['en', 'ar', 'fr', 'es']) {
      final l = await L10n.delegate.load(Locale(lang));
      final example = l.visitWorryHint.split(RegExp('[:：]')).last;
      expect(matchWorry(example, _p(Goal.period), _today).questionIds, isNotEmpty, reason: '$lang: $example');
    }
  });

  group('her visit list', () {
    test('with no visit ahead, a new undated one holds the lines', () {
      const past = Appointment(id: 'old', datetime: '2026-05-02T10:00', prep: ['kept']);
      final p = withVisitPrep(_p(Goal.period, appointments: [past]), ['Q1', 'mine'], _today, newId: 'new');
      expect(p.appointments.map((a) => a.id), ['old', 'new']);
      expect(p.appointments.last.datetime, isNull);
      expect(p.appointments.last.prep, ['Q1', 'mine']);
      expect(p.appointments.first.prep, ['kept'], reason: 'a past visit is never touched');
    });

    test('the next visit ahead gets the lines, after hers, without repeats', () {
      const next = Appointment(id: 'n', clinician: 'Dr S', datetime: '2026-07-01T09:30', prep: ['Q1']);
      final p = withVisitPrep(_p(Goal.period, appointments: [next]), ['Q1', ' Q2 ', ''], _today, newId: 'x');
      expect(p.appointments.single.prep, ['Q1', 'Q2']);
      expect(p.appointments.single.clinician, 'Dr S');
    });

    test('removing a line removes only that line', () {
      const next = Appointment(id: 'n', datetime: '2026-07-01T09:30', prep: ['a', 'b', 'c']);
      final p = withoutVisitPrep(_p(Goal.period, appointments: [next]), 'n', 'b');
      expect(p.appointments.single.prep, ['a', 'c']);
    });
  });

  group('the pack in two languages', () {
    late L10n ar, en;
    setUpAll(() async {
      await initializeDateFormatting();
      ar = await L10n.delegate.load(const Locale('ar'));
      en = await L10n.delegate.load(const Locale('en'));
    });

    test('a saved question is read back as the question; her words stay hers', () {
      final lines = visitLinesFromPrep(ar, [visitQuestionText(ar, 'painCauseChecks'), 'مغص من سنتين']);
      expect(lines.first.id, 'painCauseChecks');
      expect(lines.last.words, 'مغص من سنتين');
      expect(lines.first.text(en), visitQuestionText(en, 'painCauseChecks'));
      expect(lines.last.text(en), en.visitInMyWords('مغص من سنتين'));
    });

    test('the clinic copy follows hers, in the clinic language, with nothing listed twice', () {
      final summary = visitSummary(_p(Goal.ttc), _today);
      const mine = [VisitLine.question('folicAcid'), VisitLine.words('مغص')];
      final text = visitPackBoth(ar,
          myLocale: 'ar',
          clinic: en,
          clinicLocale: 'en',
          today: _today,
          summary: summary,
          lines: mine,
          suggested: summary.questionIds);
      expect(text.indexOf(ar.visitTitle), lessThan(text.indexOf(en.visitTitle)));
      expect(text, contains(en.visitInMyWords('مغص')));
      expect(RegExp(RegExp.escape(en.visitQ_folicAcid)).allMatches(text).length, 1, reason: 'listed once, under hers');
      expect(suggestedNotListed(summary.questionIds, mine), isNot(contains('folicAcid')));
    });
  });
}
