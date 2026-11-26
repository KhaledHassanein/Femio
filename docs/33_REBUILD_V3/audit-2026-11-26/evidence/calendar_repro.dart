// Audit evidence (2026-11-26), not part of the app: reproduces the owner's report
// "the calendar shows only the past period, no future range, no fertile window".
// Run from apps/mobile:
//   dart --packages=.dart_tool/package_config.json ../../docs/33_REBUILD_V3/audit-2026-11-26/evidence/calendar_repro.dart
import 'package:femio/data/profile.dart';
import 'package:femio/domain/day_marks.dart';

void show(String name, Profile p, String today) {
  final m = dayMarks(p, today: today, from: '2026-10-01', to: '2027-01-31');
  final future = m.entries.where((e) => e.key.compareTo(today) > 0);
  final predicted = future.where((e) => e.value.predicted).length;
  final fertile = m.values.where((v) => v.fertile).length;
  print('$name: predicted future days=$predicted, fertile days=$fertile');
}

void main() {
  const today = '2026-11-26';
  // A: onboarding, stated regular 28, one start (fixed by R8.10c).
  show('A stated 28, one start', const Profile(goal: Goal.period, locale: 'en', periodStarts: ['2026-11-01'], periodLength: 5, cycleLength: 28), today);
  // B: same woman logs her next period: one observed cycle.
  show('B stated 28, two starts', const Profile(goal: Goal.period, locale: 'en', periodStarts: ['2026-10-29', '2026-11-25'], periodLength: 5, cycleLength: 28), today);
  // B2: TTC, same.
  show('B2 TTC stated 28, two starts', const Profile(goal: Goal.ttc, locale: 'en', periodStarts: ['2026-10-29', '2026-11-25'], periodLength: 5, cycleLength: 28), today);
  // C: said "not sure" (cycleLength null), one start.
  show('C not sure, one start', const Profile(goal: Goal.period, locale: 'en', periodStarts: ['2026-11-20'], periodLength: 5), today);
  // D: three starts, regular.
  show('D three starts', const Profile(goal: Goal.period, locale: 'en', periodStarts: ['2026-10-02', '2026-10-30', '2026-11-25'], periodLength: 5, cycleLength: 28), today);
}
