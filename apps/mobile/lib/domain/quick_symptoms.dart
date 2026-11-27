// Which symptoms the Log screen shows before "Show all" (owner 2026-11-27).
//
// Why it exists: the full list has about thirty symptoms, a long scroll for the one she
// wants. Folded, the Log shows a few: those she ticked for this day first, then the ones she
// logs most, then the vocabulary's own order. Pure, so the order is tested without a screen.

import '../data/profile.dart';
import 'log_vocabulary.g.dart';

/// How many symptoms show while the list is folded; "Other" comes after them.
const quickSymptomCount = 5;

/// The symptom keys to show folded for [day]: every symptom ticked on [day] (so nothing she
/// chose is hidden), then her most-logged across [logs], then the vocabulary order, until
/// there are at least [count]. Ties keep the vocabulary order.
List<String> quickSymptoms(Map<String, DayLog> logs, DayLog day, {int count = quickSymptomCount}) {
  final all = [for (final t in logTerms) if (t.dimension == LogDimension.symptom) t.key];
  final uses = <String, int>{};
  for (final log in logs.values) {
    for (final k in log.terms) {
      uses[k] = (uses[k] ?? 0) + 1;
    }
  }
  final byUse = [...all.where((k) => (uses[k] ?? 0) > 0)]
    ..sort((a, b) {
      final d = uses[b]!.compareTo(uses[a]!);
      return d != 0 ? d : all.indexOf(a).compareTo(all.indexOf(b));
    });
  final out = <String>[for (final k in all) if (day.terms.contains(k)) k];
  for (final k in [...byUse, ...all]) {
    if (out.length >= count) break;
    if (!out.contains(k)) out.add(k);
  }
  return out;
}
