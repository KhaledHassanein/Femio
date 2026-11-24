// Tests for the assistant's domain core (ADR-078, R7.1): the rules that run with or without a
// model, so each one is proved here on plain inputs in the four languages.

import 'package:femio/data/profile.dart';
import 'package:femio/domain/assistant/guide_search.dart';
import 'package:femio/domain/assistant/log_phrases.dart';
import 'package:femio/domain/assistant/prompts.dart';
import 'package:femio/domain/assistant/redaction.dart';
import 'package:femio/domain/assistant/safety.dart';
import 'package:femio/domain/assistant/text_normal.dart';
import 'package:femio/domain/assistant/visit_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('text normalisation', () {
    test('folds Arabic letter forms, marks and digits', () {
      expect(normalise('الدَّورةُ أتت ٣ أيام'), 'الدوره اتت 3 ايام');
    });
    test('folds Latin accents and punctuation', () {
      expect(normalise('Fatiguée, épuisée!'), 'fatiguee epuisee');
    });
    test('matches a phrase through an Arabic prefix', () {
      expect(findPhrase(words('عندي المغص'), words('مغص')), 1);
    });
  });

  group('say it in your words', () {
    test('English note becomes log terms and flow', () {
      final d = draftFromNote('Heavy period today, bad cramps and so tired');
      expect(d.flow, 'heavy');
      expect(d.terms, containsAll(['cramps', 'fatigue']));
    });
    test('Egyptian Arabic note', () {
      final d = draftFromNote('عندي مغص جامد وصداع وتعبانه');
      expect(d.terms, containsAll(['cramps', 'headache', 'fatigue']));
    });
    test('French and Spanish notes', () {
      expect(
        draftFromNote("J'ai des crampes et des nausées").terms,
        containsAll(['cramps', 'nausea']),
      );
      expect(
        draftFromNote('Tengo dolor de cabeza y estoy cansada').terms,
        containsAll(['headache', 'fatigue']),
      );
    });
    test('a negated symptom is not logged', () {
      expect(draftFromNote('no cramps today, just a headache').terms, [
        'headache',
      ]);
    });
    test('ovulation test', () {
      expect(
        draftFromNote('positive ovulation test this morning').opk,
        'positive',
      );
    });
    test('the model can only add known values; the rules win on flow', () {
      final merged = mergeDrafts(
        draftFromNote('heavy flow'),
        modelTerms: ['bloating', 'madeUpKey'],
        modelFlow: 'light',
        modelOpk: 'weird',
      );
      expect(merged.flow, 'heavy');
      expect(merged.terms, ['bloating']);
      expect(merged.opk, isNull);
    });
  });

  group('safety rules', () {
    test('crisis wins over everything', () {
      expect(
        safetySignal('I want to die and I have chest pain', pregnant: false),
        SafetySignal.crisis,
      );
    });
    test('urgent signs in four languages', () {
      for (final t in [
        'chest pain since morning',
        'مش قادره اتنفس',
        'je n’arrive pas à respirer',
        'no puedo respirar',
      ]) {
        expect(
          safetySignal(t, pregnant: false),
          SafetySignal.urgent,
          reason: t,
        );
      }
    });
    test('bleeding is a warning only in pregnancy', () {
      expect(
        safetySignal('some bleeding today', pregnant: true),
        SafetySignal.pregnancyWarning,
      );
      expect(
        safetySignal('some bleeding today', pregnant: false),
        SafetySignal.none,
      );
      expect(
        safetySignal('البيبي مش بيتحرك من امبارح', pregnant: true),
        SafetySignal.pregnancyWarning,
      );
    });
    test('birth-control questions get the fixed answer', () {
      for (final t in [
        'what are the safe days?',
        'ازاي اعرف الايام الامنة',
        'pilule du lendemain',
        'días seguros',
        // Missed before the coverage pass of 2026-11-24 ("I avoid", not "avoiding").
        'ازاي اتجنب الحمل بطريقة طبيعية؟',
        'ازاي امنع الحمل؟',
      ]) {
        expect(
          safetySignal(t, pregnant: false),
          SafetySignal.birthControl,
          reason: t,
        );
      }
    });
    test('an ordinary question passes', () {
      expect(
        safetySignal('what helps with period cramps?', pregnant: false),
        SafetySignal.none,
      );
    });
  });

  group('cloud redaction', () {
    test('a question about her stays on the phone', () {
      for (final t in [
        'my period is late',
        'عندي تكيس',
        'je suis fatiguée',
        'tengo dolor',
      ]) {
        expect(toCloudSafe(t), isNull, reason: t);
      }
    });
    test('"my" does not match "myth"', () {
      expect(isAboutHer('Is it a myth that pineapple helps?'), isFalse);
    });
    test('a general question is cleaned of digits, links and contacts', () {
      final safe = toCloudSafe(
        'What is PCOS at 25? see www.example.com or a@b.com',
      );
      expect(safe, isNotNull);
      expect(safe!.value, isNot(contains('25')));
      expect(safe.value, isNot(contains('example')));
      expect(safe.value, isNot(contains('@')));
    });
    test('long questions are cut', () {
      final safe = toCloudSafe(List.filled(100, 'folic acid').join(' '));
      expect(safe!.value.length, lessThanOrEqualTo(maxCloudQuestionChars));
    });
  });

  group('prompts and parsers', () {
    test('extraction prompt never offers intercourse keys', () {
      expect(extractionPrompt('note'), isNot(contains('intercourse')));
    });
    test('a bad model reply adds nothing', () {
      expect(parseExtraction('sorry, I cannot').terms, isEmpty);
      expect(
        parseExtraction('```json\n{"terms":["cramps"],"flow":"heavy"}\n```')
            .terms,
        ['cramps'],
      );
    });
    test('question ids are filtered to the allowed list', () {
      expect(
        parseQuestionIds(
          '{"ids":["folicAcid","hack","folicAcid","ovulation"]}',
          ['folicAcid', 'ovulation'],
          5,
        ),
        ['folicAcid', 'ovulation'],
      );
    });
  });

  group('related guides', () {
    const guides = [
      GuideText(
        slug: 'pcos',
        title: 'PCOS explained',
        excerpt: 'Polycystic ovary syndrome',
        paragraphs: ['PCOS affects cycles.'],
      ),
      GuideText(
        slug: 'folic',
        title: 'Folic acid before pregnancy',
        excerpt: 'Why folic acid',
        paragraphs: ['Take folic acid.'],
      ),
    ];
    test('finds the guide whose title matches', () {
      final hits = searchGuides('what is pcos', guides);
      expect(hits.first.guide.slug, 'pcos');
    });
    test('no overlap, no hits', () {
      expect(searchGuides('weather tomorrow', guides), isEmpty);
    });
  });

  group('visit summary', () {
    Profile ttc({
      List<String> starts = const [],
      Map<String, DayLog> logs = const {},
      TryingFor? tryingFor,
    }) => Profile(
      goal: Goal.ttc,
      locale: 'en',
      birthYear: 1990,
      periodStarts: starts,
      logs: logs,
      tryingFor: tryingFor,
    );

    test('counts cycles and logged terms from her own record', () {
      final s = visitSummary(
        ttc(
          starts: ['2026-08-01', '2026-08-29', '2026-09-28', '2026-10-27'],
          logs: {
            '2026-10-27': const DayLog(flow: 'heavy', terms: ['cramps']),
            '2026-10-28': const DayLog(
              flow: 'heavy',
              terms: ['cramps', 'fatigue'],
            ),
            '2026-10-29': const DayLog(terms: ['cramps', 'libidoUp']),
            '2026-11-10': const DayLog(opk: 'positive'),
          },
        ),
        '2026-11-24',
      );
      expect(s.cyclesObserved, 3);
      expect(s.shortestCycle, 28);
      expect(s.longestCycle, 30);
      expect(s.topTerms.first.key, 'cramps');
      expect(s.topTerms.first.days, 3);
      expect(
        s.topTerms.map((t) => t.key),
        isNot(contains('libidoUp')),
        reason: 'private terms stay off the summary',
      );
      expect(s.heavyDays, 2);
      expect(s.positiveOvulationTests, 1);
      expect(
        s.questionIds,
        containsAll(['folicAcid', 'painfulPeriods', 'heavyPeriods']),
      );
      expect(s.questionIds.length, lessThanOrEqualTo(maxVisitQuestions));
      expect(s.questionIds.last, 'anythingElse');
    });

    test('after twelve months of trying, suggests asking about checks', () {
      final s = visitSummary(ttc(tryingFor: TryingFor.over12), '2026-11-24');
      // The catalogue's sourced check question replaces the rule bank's general one.
      expect(s.questionIds.first, anyOf('ttcTests', 'checksForCouple', 'ttcOverThirtyFiveSooner'));
    });

    test('a model may reorder the rule picks but never add one', () {
      expect(
        reorderQuestions(['a', 'b', 'c', 'anythingElse'], ['c', 'x', 'a']),
        ['c', 'a', 'b', 'anythingElse'],
      );
    });

    test('facts for the model carry no dates', () {
      final s = visitSummary(
        ttc(starts: ['2026-09-01', '2026-09-29']),
        '2026-11-24',
      );
      expect(s.factsInEnglish(), isNot(contains('2026')));
    });
  });
}
