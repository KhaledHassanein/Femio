/// The menopause stage while periods still come and after they stop (R8.20). Pure: no clock.
///
/// Why it exists: in perimenopause cycles change but still come, so a wide next-period range
/// stays useful; once a year has passed without a period, any bleeding needs a doctor. The
/// rules are in the register (MR-61):
/// - menopause is identified after 12 months without a period (NICE NG23), so ranges are
///   offered only while her last period started less than [menopauseNoPeriodDays] ago;
/// - bleeding of any amount (spotting included) that starts [menopauseNoPeriodDays] or more
///   after the bleed before it, or after she said her last period was over a year ago,
///   raises a caution to see a doctor (ACOG; NICE NG12 via the reviewed guides);
/// - symptom counts are days per calendar month, counts only.
library;

import '../data/profile.dart';
import 'cycle_prediction.dart' show bleedStarts;
import 'dates.dart';

/// The reviewed guide on bleeding after menopause.
const postmenopausalBleedingGuide = 'postmenopausal-bleeding';

/// A year without a period: the point menopause is identified (NICE NG23).
const menopauseNoPeriodDays = 365;

/// How many calendar months the monthly counts show, the current one included.
const monthlyPatternMonths = 6;

/// The most terms the monthly table lists.
const monthlyPatternTerms = 8;

/// Days counted as one month when telling her how long since her last period.
const daysPerMonth = 30;

/// Whole months since her last logged period, or null when she has logged none.
int? monthsSinceLastPeriod(Profile profile, String today) {
  final starts = bleedStarts(profile.cycleStarts);
  return starts.isEmpty ? null : diffDays(starts.last, today) ~/ daysPerMonth;
}

/// Whether the menopause stage still shows a next-period range: her last period started
/// less than a year before [today].
bool menopauseShowsRanges(Profile profile, String today) {
  if (profile.goal != Goal.menopause) return false;
  final starts = bleedStarts(profile.cycleStarts);
  return starts.isNotEmpty && diffDays(starts.last, today) < menopauseNoPeriodDays;
}

/// Every day she logged any bleeding, spotting included, plus her period days, sorted.
List<String> _anyBleedDays(Profile profile) => {
      ...profile.periodStarts,
      for (final e in profile.logs.entries)
        if (e.value.flow != null) e.key,
    }.toList()
  ..sort();

/// The first day of the latest bleed that came after a year or more without one, if it is
/// within the last [menopauseNoPeriodDays] before [today]; null otherwise. Only for the
/// menopause goal.
String? bleedAfterYear(Profile profile, String today) {
  if (profile.goal != Goal.menopause) return null;
  final starts = bleedStarts(_anyBleedDays(profile)).where((d) => d.compareTo(today) <= 0).toList();
  if (starts.isEmpty) return null;
  final last = starts.last;
  final yearGap = starts.length >= 2
      ? diffDays(starts[starts.length - 2], last) >= menopauseNoPeriodDays
      : profile.lastPeriodOverYear;
  if (!yearGap) return null;
  return diffDays(last, today) < menopauseNoPeriodDays ? last : null;
}

/// Days each term was logged in each calendar month: [months] oldest first (`yyyy-mm`), and
/// one row per term with a count per month, most days in total first.
class MonthlyTerms {
  const MonthlyTerms(this.months, this.rows);
  final List<String> months;
  final List<({String term, List<int> days})> rows;
  bool get isEmpty => rows.isEmpty;
}

/// The last [count] calendar months up to [today]'s month.
MonthlyTerms monthlyTermDays(Profile profile, String today, {int count = monthlyPatternMonths}) {
  final t = fromISO(today);
  final months = [
    for (var i = count - 1; i >= 0; i--) toISO(DateTime.utc(t.year, t.month - i)).substring(0, 7),
  ];
  final table = <String, List<int>>{};
  for (final e in profile.logs.entries) {
    if (e.key.compareTo(today) > 0) continue;
    final m = months.indexOf(e.key.substring(0, 7));
    if (m < 0) continue;
    for (final term in e.value.terms.toSet()) {
      (table[term] ??= List.filled(count, 0))[m]++;
    }
  }
  int total(List<int> d) => d.fold(0, (a, b) => a + b);
  final rows = [for (final e in table.entries) (term: e.key, days: e.value)]
    ..sort((a, b) {
      final byTotal = total(b.days).compareTo(total(a.days));
      return byTotal != 0 ? byTotal : a.term.compareTo(b.term);
    });
  return MonthlyTerms(months, rows.take(monthlyPatternTerms).toList());
}
