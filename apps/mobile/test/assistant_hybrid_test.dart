// Tests for the hybrid assistant's privacy and safety rules (ADR-079): the cited-answer parser,
// the pseudonymised bands, the catalogue triggers, the cloud prompt and the new red flags.

import 'package:femio/data/profile.dart';
import 'package:femio/domain/assistant/cloud_prompt.dart';
import 'package:femio/domain/assistant/personal_triggers.dart';
import 'package:femio/domain/assistant/prompts.dart';
import 'package:femio/domain/assistant/pseudonymised_profile.dart';
import 'package:femio/domain/assistant/safety.dart';
import 'package:femio/domain/assistant/tip_catalogue.g.dart';
import 'package:femio/domain/assistant/visit_summary.dart';
import 'package:flutter_test/flutter_test.dart';

const _today = '2026-11-24';

Profile _profile(
  Goal goal, {
  Map<String, DayLog> logs = const {},
  String? birthDate,
  String? edd,
  int? birthYear,
  TryingFor? tryingFor,
  bool irregular = false,
}) => Profile(
  goal: goal,
  locale: 'en',
  logs: logs,
  birthDate: birthDate,
  edd: edd,
  birthYear: birthYear,
  tryingFor: tryingFor,
  irregular: irregular,
);

Map<String, DayLog> _daily(String term, int days) => {
  for (var i = 0; i < days; i++)
    '2026-11-${(24 - i).toString().padLeft(2, '0')}': DayLog(terms: [term]),
};

void main() {
  group('cited answers', () {
    test('the prompt numbers passages and forbids outside knowledge, diagnosis and contraception', () {
      final p = answerPrompt('what helps cramps?', [
        (publisher: 'CDC', text: 'Heat may help.'),
      ], 'ar');
      expect(p, contains('[1] (CDC) Heat may help.'));
      expect(p, contains('Add nothing from your own knowledge'));
      expect(p, contains('Never diagnose'));
      expect(p, contains('avoiding pregnancy'));
      expect(p, contains('Arabic'));
    });
    test('an answer that cites a real passage is kept', () {
      final a = parseAnswer(
        'Heat on the belly may help [1]. So can rest [2].',
        2,
      );
      expect(a!.cited, {1, 2});
    });
    test('no citation, a missing passage or NOT_COVERED is rejected', () {
      expect(parseAnswer('Heat helps.', 2), isNull);
      expect(parseAnswer('Heat helps [3].', 2), isNull);
      expect(parseAnswer(notCoveredReply, 2), isNull);
    });
  });

  group('pseudonymised profile', () {
    test('carries only four coarse bands, no dates or term names', () {
      final b = pseudonymise(
        _profile(
          Goal.period,
          logs: {
            ..._daily('cramps', 3),
            '2026-11-01': const DayLog(terms: ['libido']),
          },
        ),
        _today,
      );
      expect(b.features.keys, [
        'life stage',
        'cycle regularity',
        'symptom kinds logged in the last month',
        'logging streak',
      ]);
      final text = b.features.values.join(' ');
      expect(text, contains('pain'));
      expect(text, isNot(contains('cramps')));
      expect(text, isNot(contains('libido')));
      expect(text, isNot(contains('2026')));
    });
    test('one stray day does not count', () {
      expect(
        pseudonymise(
          _profile(Goal.period, logs: _daily('acne', 1)),
          _today,
        ).categories,
        isEmpty,
      );
    });
    test('after the birth the stage is postpartum', () {
      expect(
        pseudonymise(
          _profile(Goal.pregnant, birthDate: '2026-10-01'),
          _today,
        ).stage,
        StageBand.postpartum,
      );
    });
  });

  group('catalogue triggers', () {
    test('every catalogue id has English text', () {
      for (final i in tipCatalogue) {
        expect(tipEnglish[i.id], isNotNull, reason: i.id);
      }
      for (final i in visitQuestionCatalogue) {
        expect(catalogueQuestionEnglish[i.id], isNotNull, reason: i.id);
      }
    });
    test('a year of trying fits the see-a-clinician tip', () {
      final c = triggerContext(
        _profile(Goal.ttc, tryingFor: TryingFor.over12),
        _today,
      );
      expect(fitting(tipCatalogue, c).map((i) => i.id), contains('ttcOneYear'));
    });
    test('the 35-plus tip needs a known age', () {
      final unknown = triggerContext(
        _profile(Goal.ttc, tryingFor: TryingFor.sixTo12),
        _today,
      );
      expect(
        fitting(tipCatalogue, unknown).map((i) => i.id),
        isNot(contains('ttcAgeSixMonths')),
      );
      final older = triggerContext(
        _profile(Goal.ttc, tryingFor: TryingFor.sixTo12, birthYear: 1988),
        _today,
      );
      expect(
        fitting(tipCatalogue, older).map((i) => i.id),
        contains('ttcAgeSixMonths'),
      );
    });
    test('pregnancy-week tips need the right week', () {
      final c = triggerContext(
        _profile(Goal.pregnant, edd: '2027-02-15'),
        _today,
      );
      final ids = fitting(tipCatalogue, c).map((i) => i.id);
      expect(ids, contains('movementsChangeCallNow'));
      expect(ids, isNot(contains('rhBloodGroup')));
    });
    test('the most specific tips come first', () {
      final c = triggerContext(
        _profile(Goal.period, logs: _daily('cramps', 6)),
        _today,
      );
      final fits = fitting(tipCatalogue, c);
      expect(fits.first.trigger.specificity, greaterThan(0));
    });
  });

  group('cloud prompt', () {
    test('tips offer the whole life stage, never only what fits her', () {
      final bands = pseudonymise(
        _profile(Goal.ttc, tryingFor: TryingFor.over12),
        _today,
      );
      final text = CloudPrompt.tips(bands, 3).text;
      for (final i in forStage(tipCatalogue, StageBand.ttc)) {
        expect(text, contains('- ${i.id}:'));
      }
      expect(text, isNot(contains('movementsChangeCallNow')));
      expect(text, isNot(contains('2026')));
    });
  });

  group('visit summary with the catalogue', () {
    test('no period questions in pregnancy, even with low mood', () {
      final s = visitSummary(
        _profile(Goal.pregnant, edd: '2027-02-15', logs: _daily('sad', 4)),
        _today,
      );
      expect(s.questionIds, isNot(contains('moodCycle')));
      expect(s.questionIds, contains('pregnancyLowMoodSupport'));
    });
    test('after birth, pregnancy questions give way to recovery ones', () {
      final s = visitSummary(
        _profile(Goal.pregnant, birthDate: '2026-10-20'),
        _today,
      );
      expect(s.questionIds, isNot(contains('pregnancyMovements')));
      expect(s.questionIds, contains('postnatalCheckTalk'));
      expect(s.questionIds.last, 'anythingElse');
    });
    test('every suggested id has English text for the model', () {
      final s = visitSummary(
        _profile(Goal.menopause, logs: _daily('hotFlashes', 6)),
        _today,
      );
      for (final id in s.questionIds) {
        expect(questionEnglish(id), isNotNull, reason: id);
      }
    });
  });

  group('new red flags', () {
    test('heavy bleeding with dizziness shows the ACOG emergency card', () {
      expect(
        safetySignal('heavy bleeding and I feel dizzy', pregnant: false),
        SafetySignal.heavyBleeding,
      );
      expect(
        safetySignal('نزيف جامد وحاسه بدوخه', pregnant: false),
        SafetySignal.heavyBleeding,
      );
      expect(
        safetySignal('sangrado abundante y mareada', pregnant: false),
        SafetySignal.heavyBleeding,
      );
    });
    test('heavy bleeding alone is not the emergency card outside the year after birth', () {
      expect(
        safetySignal('heavy bleeding this month', pregnant: false),
        SafetySignal.none,
      );
    });
    test('after birth, Hear Her signs open help for a year', () {
      final p = _profile(Goal.pregnant, birthDate: '2026-09-01');
      expect(
        safetySignalFor('I have a fever', p, _today),
        SafetySignal.postpartumWarning,
      );
      expect(
        safetySignalFor('soaking a pad an hour', p, _today),
        SafetySignal.postpartumWarning,
      );
      final later = _profile(Goal.pregnant, birthDate: '2025-06-01');
      expect(
        safetySignalFor('I have a fever', later, _today),
        SafetySignal.none,
      );
    });
    test('asking how long bleeding after birth lasts is not a warning; heavy bleeding still is', () {
      final p = _profile(Goal.pregnant, birthDate: '2026-09-01');
      for (final q in ['النزيف بعد الولادة بيستمر قد ايه؟', 'النزيف بعد الولادة طبيعي؟', 'hemorragia despues del parto cuanto dura']) {
        expect(safetySignalFor(q, p, _today), SafetySignal.none, reason: q);
      }
      for (final q in [
        'عندي نزيف بعد الولادة',
        'نزيف جامد بعد الولادة بيستمر قد ايه',
        'بغير الفوطة كل ساعة',
        'I am soaking a pad every hour, how long will this last?',
      ]) {
        expect(safetySignalFor(q, p, _today), SafetySignal.postpartumWarning, reason: q);
      }
    });
    test('blood type is not bleeding in pregnancy; blood still is', () {
      for (final q in ['يعني ايه فصيلة الدم سالب في الحمل؟', 'What does a negative blood type mean in pregnancy?', 'tipo de sangre negativo embarazo']) {
        expect(safetySignal(q, pregnant: true), SafetySignal.none, reason: q);
      }
      for (final q in ['نزل مني دم', 'blood when I wipe', 'blood test showed low iron and I see blood']) {
        expect(safetySignal(q, pregnant: true), SafetySignal.pregnancyWarning, reason: q);
      }
    });
    test('thoughts of harming the baby are a crisis', () {
      expect(
        safetySignal('I am scared I might hurt my baby', pregnant: false),
        SafetySignal.crisis,
      );
    });
  });
}
