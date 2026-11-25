// The stage examples in Say it and Ask femio work as examples (R8.4).
//
// Why it exists: a placeholder is a promise. If she types the Say it example and nothing is
// logged, or asks the Ask example and gets "not covered" or a safety warning, the example
// teaches her the feature is broken. This test types every example, in every language, into
// the same rules the app runs.

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:femio/data/profile.dart';
import 'package:femio/domain/assistant/log_phrases.dart';
import 'package:femio/domain/assistant/pseudonymised_profile.dart';
import 'package:femio/domain/assistant/safety.dart';
import 'package:femio/domain/assistant/source_registry.dart';
import 'package:femio/features/assistant/stage_hints.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

final _registry = SourceRegistry.fromJson(
  jsonDecode(File('assets/trusted_sources/registry.json').readAsStringSync()) as Map<String, Object?>,
);

/// What each Say it example must log at least, by stage.
const _mustLog = <StageBand, Set<String>>{
  StageBand.period: {'cramps', 'fatigue'},
  StageBand.ttc: {'cramps', 'bloating'},
  StageBand.pregnant: {'nausea', 'backache', 'fatigue'},
  StageBand.postpartum: {'insomnia', 'backache'},
  StageBand.menopause: {'hotFlashes', 'nightSweats', 'insomnia'},
};

/// The goal to ask the registry with for each stage.
const _goal = <StageBand, Goal>{
  StageBand.period: Goal.period,
  StageBand.ttc: Goal.ttc,
  StageBand.pregnant: Goal.pregnant,
  StageBand.postpartum: Goal.pregnant,
  StageBand.menopause: Goal.menopause,
};

void main() {
  for (final lang in ['en', 'ar', 'fr', 'es']) {
    group('stage examples ($lang)', () {
      late L10n l;
      setUpAll(() async => l = await L10n.delegate.load(Locale(lang)));

      for (final stage in StageBand.values) {
        test('Say it example logs what it names (${stage.name})', () {
          final hint = sayItHintFor(l, stage);
          final draft = draftFromNote(hint);
          expect(draft.terms.toSet(), containsAll(_mustLog[stage]!), reason: '"$hint" logged ${draft.terms}');
          if (stage == StageBand.ttc) expect(draft.opk, 'positive', reason: hint);
        });

        test('Ask example finds a passage and trips no rule (${stage.name})', () {
          final hint = askHintFor(l, stage);
          final pregnant = stage == StageBand.pregnant;
          expect(
            safetySignal(hint, pregnant: pregnant, postpartum: stage == StageBand.postpartum),
            SafetySignal.none,
            reason: hint,
          );
          final answer = searchRegistry(hint, _registry, goal: _goal[stage]!.name, lang: lang);
          expect(answer.notCovered, isFalse, reason: '"$hint" found no passage');
        });
      }

      test('each stage has its own examples', () {
        expect({for (final s in StageBand.values) sayItHintFor(l, s)}, hasLength(StageBand.values.length));
        expect({for (final s in StageBand.values) askHintFor(l, s)}, hasLength(StageBand.values.length));
      });
    });
  }

  test('hint stage follows her record, and period before she has one', () {
    expect(hintStage(null), StageBand.period);
    const pregnant = Profile(goal: Goal.pregnant, locale: 'en', edd: '2027-02-10');
    expect(hintStage(pregnant), StageBand.pregnant);
    expect(hintStage(const Profile(goal: Goal.pregnant, locale: 'en', edd: '2027-02-10', birthDate: '2027-02-08')), StageBand.postpartum);
  });
}
