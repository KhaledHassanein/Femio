// The example text inside Say it and Ask femio, chosen for her life stage (R8.4, owner O6).
//
// Why it exists: one example for everyone ("bad cramps, light bleeding") reads wrong in
// pregnancy or menopause and teaches her the box is not for her. Each stage gets an example
// she would actually type. Every Say it example is one the phrase rules can log, and every Ask
// example finds a passage without tripping a safety rule; `test/stage_hints_test.dart` checks
// both in all four languages. With no profile yet, the period examples show.

import '../../data/profile.dart';
import '../../domain/assistant/pseudonymised_profile.dart' show StageBand, stageBandOf;
import '../../l10n/app_localizations.dart';

/// Her stage, or the period stage before she has a profile.
StageBand hintStage(Profile? profile) => profile == null ? StageBand.period : stageBandOf(profile);

/// The Say it example for [stage].
String sayItHintFor(L10n l, StageBand stage) => switch (stage) {
      StageBand.period => l.sayItHint,
      StageBand.ttc => l.sayItHintTtc,
      StageBand.pregnant => l.sayItHintPregnant,
      StageBand.postpartum => l.sayItHintPostpartum,
      StageBand.menopause => l.sayItHintMenopause,
    };

/// The Ask femio example for [stage].
String askHintFor(L10n l, StageBand stage) => switch (stage) {
      StageBand.period => l.askHint,
      StageBand.ttc => l.askHintTtc,
      StageBand.pregnant => l.askHintPregnant,
      StageBand.postpartum => l.askHintPostpartum,
      StageBand.menopause => l.askHintMenopause,
    };
