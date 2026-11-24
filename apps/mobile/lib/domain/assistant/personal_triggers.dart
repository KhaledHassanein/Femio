// When a reviewed tip or visit question fits her, decided on the phone (ADR-079).
//
// Why it exists: personal tips and the persona visit questions are reviewed sentences, each with
// a source; what makes them personal is choosing the right ones. These triggers read only her
// own record, on the device, and the sentence she reads always comes from the reviewed catalogue
// in her language, never from a model ("the model reads; femio speaks"). A model may only put
// the chosen ids in order.

import '../../data/profile.dart';
import '../dates.dart';
import '../pregnancy.dart';
import 'pseudonymised_profile.dart' show StageBand;

/// A term logged on at least [minDays] days within the last [windowDays] days.
class TermRule {
  const TermRule(this.key, this.minDays, this.windowDays);
  final String key;
  final int minDays;
  final int windowDays;
}

/// Every condition present must hold. [stages] is required; the rest are optional.
class PersonalTrigger {
  const PersonalTrigger({
    required this.stages,
    this.term,
    this.pregnancyWeeks,
    this.postpartumWeeks,
    this.tryingFor,
    this.irregular,
    this.ageFrom,
  });

  final Set<StageBand> stages;
  final TermRule? term;

  /// Inclusive range of completed pregnancy weeks.
  final (int, int)? pregnancyWeeks;

  /// Inclusive range of completed weeks since the baby's birth.
  final (int, int)? postpartumWeeks;
  final Set<TryingFor>? tryingFor;
  final bool? irregular;

  /// Her age this calendar year is at least this.
  final int? ageFrom;

  /// How specific the trigger is: one point per condition beyond the stage, and two for a
  /// logged term, because what she logged says most about what she needs now. Higher first.
  int get specificity =>
      (term == null ? 0 : 2) + [pregnancyWeeks, postpartumWeeks, tryingFor, irregular, ageFrom].nonNulls.length;
}

/// A reviewed catalogue item: an id (its sentence lives in the ARB files), when it fits, and
/// the page that supports it.
class PersonalItem {
  const PersonalItem(this.id, this.trigger, {required this.publisher, required this.url});
  final String id;
  final PersonalTrigger trigger;
  final String publisher;
  final String url;
}

/// What the triggers read, computed once from her record.
class TriggerContext {
  const TriggerContext({
    required this.stage,
    required this.today,
    required this.logs,
    this.pregnancyWeek,
    this.postpartumWeek,
    this.tryingFor,
    required this.irregular,
    this.age,
  });

  final StageBand stage;
  final String today;
  final Map<String, DayLog> logs;
  final int? pregnancyWeek;
  final int? postpartumWeek;
  final TryingFor? tryingFor;
  final bool irregular;
  final int? age;

  /// Days within the last [window] days (today included) on which [key] was logged.
  int daysLogged(String key, int window) {
    final from = addDays(today, -window);
    return logs.entries.where((e) => e.key.compareTo(from) > 0 && e.key.compareTo(today) <= 0 && e.value.terms.contains(key)).length;
  }
}

/// Reads her record into a [TriggerContext] as of [today] (yyyy-mm-dd). Never fails.
TriggerContext triggerContext(Profile profile, String today) {
  final birth = profile.birthDate;
  final stage = switch (profile.goal) {
    Goal.period => StageBand.period,
    Goal.ttc => StageBand.ttc,
    Goal.pregnant => birth == null ? StageBand.pregnant : StageBand.postpartum,
    Goal.menopause => StageBand.menopause,
  };
  final edd = profile.edd;
  return TriggerContext(
    stage: stage,
    today: today,
    logs: profile.logs,
    pregnancyWeek: stage == StageBand.pregnant && edd != null ? pregnancyProgress(edd, today)?.weeks : null,
    postpartumWeek: stage == StageBand.postpartum && isValidISODate(birth!) ? diffDays(birth, today) ~/ 7 : null,
    tryingFor: profile.tryingFor,
    irregular: profile.irregular,
    age: profile.birthYear == null ? null : int.parse(today.substring(0, 4)) - profile.birthYear!,
  );
}

bool _inRange(int? v, (int, int)? r) => r == null || (v != null && v >= r.$1 && v <= r.$2);

/// True when every condition of [t] holds for [c]. An unknown value (no due date, no birth
/// year) fails a condition that needs it, so nothing is guessed.
bool matches(PersonalTrigger t, TriggerContext c) {
  if (!t.stages.contains(c.stage)) return false;
  final term = t.term;
  if (term != null && c.daysLogged(term.key, term.windowDays) < term.minDays) return false;
  if (!_inRange(c.pregnancyWeek, t.pregnancyWeeks)) return false;
  if (!_inRange(c.postpartumWeek, t.postpartumWeeks)) return false;
  if (t.tryingFor != null && !t.tryingFor!.contains(c.tryingFor)) return false;
  if (t.irregular != null && t.irregular != c.irregular) return false;
  if (t.ageFrom != null && (c.age == null || c.age! < t.ageFrom!)) return false;
  return true;
}

/// The items of [catalogue] that fit [c], most specific first, catalogue order on a tie.
List<PersonalItem> fitting(List<PersonalItem> catalogue, TriggerContext c) {
  final hits = [
    for (var i = 0; i < catalogue.length; i++)
      if (matches(catalogue[i].trigger, c)) (i, catalogue[i]),
  ]..sort((a, b) {
      final s = b.$2.trigger.specificity.compareTo(a.$2.trigger.specificity);
      return s != 0 ? s : a.$1.compareTo(b.$1);
    });
  return [for (final (_, item) in hits) item];
}

/// The items for a whole life stage, ignoring every personal condition: the only list a cloud
/// model may see, because which items fit her would itself say something about her.
List<PersonalItem> forStage(List<PersonalItem> catalogue, StageBand stage) =>
    [for (final item in catalogue) if (item.trigger.stages.contains(stage)) item];
