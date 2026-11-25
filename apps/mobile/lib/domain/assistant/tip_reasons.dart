// "Why am I seeing this?": the facts from her own record that made a tip fit (R10.3, U12).
//
// Why it exists: a personal tip she cannot question reads like surveillance. Each reason here
// is one condition of the tip's trigger (`personal_triggers.dart`), with her own value beside
// it, read from the same context that chose the tip. Nothing is inferred; a condition the
// trigger does not have is not listed.

import '../../data/profile.dart' show TryingFor;
import 'personal_triggers.dart';
import 'pseudonymised_profile.dart' show StageBand;

/// One fact behind a tip.
sealed class TipReason {
  const TipReason();
}

/// Her life stage.
class StageReason extends TipReason {
  const StageReason(this.stage);
  final StageBand stage;
}

/// She logged [term] on [days] days in the last [windowDays] days.
class TermReason extends TipReason {
  const TermReason(this.term, this.days, this.windowDays);
  final String term;
  final int days;
  final int windowDays;
}

/// She is in completed week [week] of pregnancy.
class PregnancyWeekReason extends TipReason {
  const PregnancyWeekReason(this.week);
  final int week;
}

/// [weeks] completed weeks since the birth.
class PostpartumWeekReason extends TipReason {
  const PostpartumWeekReason(this.weeks);
  final int weeks;
}

/// How long she has been trying to conceive, as she said.
class TryingForReason extends TipReason {
  const TryingForReason(this.tryingFor);
  final TryingFor tryingFor;
}

/// Her cycles are (or are not) marked irregular.
class IrregularReason extends TipReason {
  const IrregularReason(this.irregular);
  final bool irregular;
}

/// She is at least [from] years old this calendar year.
class AgeReason extends TipReason {
  const AgeReason(this.from);
  final int from;
}

/// The reasons [trigger] fits [c], in the trigger's own order: stage first. Call it only for
/// an item that [matches]; for one that does not, the values would not explain anything.
List<TipReason> tipReasons(PersonalTrigger trigger, TriggerContext c) => [
      StageReason(c.stage),
      if (trigger.term case final t?) TermReason(t.key, c.daysLogged(t.key, t.windowDays), t.windowDays),
      if (trigger.pregnancyWeeks != null && c.pregnancyWeek != null) PregnancyWeekReason(c.pregnancyWeek!),
      if (trigger.postpartumWeeks != null && c.postpartumWeek != null) PostpartumWeekReason(c.postpartumWeek!),
      if (trigger.tryingFor != null && c.tryingFor != null) TryingForReason(c.tryingFor!),
      if (trigger.irregular case final irregular?) IrregularReason(irregular),
      if (trigger.ageFrom case final from?) AgeReason(from),
    ];
