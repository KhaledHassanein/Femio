/// One medicine over one calendar month: what she marked on each day, and a plain count
/// (R11.6, month view). Pure: no UI, no clock.
///
/// Why it exists: the medicine page showed only the last 14 days of marks. A month grid
/// lets her see her own month at a glance, and the count line says how many days she marked
/// every planned dose as taken. It is a fact about her marks, never a score, a streak or
/// praise, and never a hint about what to do next (rule 1).
///
/// A medicine that [scheduleBlocked] covers (birth control) has no planned doses, so every
/// day is [MonthDayStatus.notPlanned], exactly as marks and reminders are kept out today.
library;

import 'dates.dart';
import 'health_record.dart';
import 'medicines.dart';

/// What her marks say about one day of one medicine.
enum MonthDayStatus {
  /// Every planned dose that day is marked taken.
  taken,

  /// At least one dose is marked taken and at least one is not.
  partly,

  /// No dose is marked taken and at least one is marked not taken.
  notTaken,

  /// A dose was planned and nothing is marked.
  notMarked,

  /// No dose was planned (before it started, after it ended, taken when needed, or a
  /// medicine femio keeps no schedule for).
  notPlanned,

  /// A planned day that has not come yet.
  upcoming,
}

/// A calendar month: [month] is 1 to 12.
typedef YearMonth = ({int year, int month});

/// One day of the grid.
typedef MonthDay = ({String day, MonthDayStatus status});

/// A medicine's month: one [MonthDay] per day, and the two numbers behind the count line.
class MedicineMonth {
  const MedicineMonth({
    required this.year,
    required this.month,
    required this.days,
    required this.plannedDays,
    required this.takenDays,
    required this.asNeeded,
  });

  final int year;
  final int month;

  /// Every day of the month, first to last.
  final List<MonthDay> days;

  /// Days up to today on which at least one dose was planned. Today counts only once she has
  /// marked something, because the day is not over.
  final int plannedDays;

  /// Of those, the days on which every planned dose is marked taken. For a medicine taken
  /// when needed ([asNeeded]) it is the days she marked a dose, and [plannedDays] is 0.
  final int takenDays;

  /// Whether the medicine has no planned times (she takes it when needed).
  final bool asNeeded;
}

/// The month [year]-[month] of [entry], read from her [plan] and [doses] as of [today].
MedicineMonth medicineMonth({
  required RecordEntry entry,
  required MedicinePlan plan,
  required Iterable<DoseMark> doses,
  required int year,
  required int month,
  required String today,
}) {
  final blocked = scheduleBlocked(entry);
  final length = DateTime.utc(year, month + 1, 0).day;
  final mine = [
    for (final d in doses)
      if (d.entryId == entry.id) d,
  ];
  final days = <MonthDay>[];
  var planned = 0;
  var taken = 0;
  for (var n = 1; n <= length; n++) {
    final day = toISO(DateTime.utc(year, month, n));
    final status = blocked ? MonthDayStatus.notPlanned : _statusOn(entry, plan, mine, day, today);
    days.add((day: day, status: status));
    if (plan.times.isEmpty) {
      if (status == MonthDayStatus.taken) taken++;
      continue;
    }
    final counts = status == MonthDayStatus.taken ||
        status == MonthDayStatus.partly ||
        status == MonthDayStatus.notTaken ||
        (status == MonthDayStatus.notMarked && day != today);
    if (counts) planned++;
    if (status == MonthDayStatus.taken) taken++;
  }
  return MedicineMonth(
    year: year,
    month: month,
    days: days,
    plannedDays: planned,
    takenDays: taken,
    asNeeded: plan.times.isEmpty,
  );
}

/// The first and last month the arrows may reach: from the month her medicine started (its
/// written start day, else the day it was added, or her earliest mark if that is older) to
/// the month of [today].
({YearMonth first, YearMonth last}) medicineMonthBounds({
  required RecordEntry entry,
  required Iterable<DoseMark> doses,
  required String today,
}) {
  final start = entry.fields[RecordField.startedOn];
  var from = start != null && isValidISODate(start) ? start : entry.happenedOn;
  for (final d in doses) {
    if (d.entryId == entry.id && d.day.compareTo(from) < 0) from = d.day;
  }
  if (from.compareTo(today) > 0) from = today;
  YearMonth ym(String iso) {
    final d = fromISO(iso);
    return (year: d.year, month: d.month);
  }

  return (first: ym(from), last: ym(today));
}

/// [at] moved by [delta] months (negative goes back).
YearMonth addMonths(YearMonth at, int delta) {
  final index = at.year * 12 + (at.month - 1) + delta;
  return (year: index ~/ 12, month: index % 12 + 1);
}

/// Whether [a] is before [b].
bool monthBefore(YearMonth a, YearMonth b) => a.year * 12 + a.month < b.year * 12 + b.month;

MonthDayStatus _statusOn(
  RecordEntry entry,
  MedicinePlan plan,
  List<DoseMark> mine,
  String day,
  String today,
) {
  final marks = [
    for (final d in mine)
      if (d.day == day) d,
  ];
  if (plan.times.isEmpty) {
    return marks.any((m) => m.status == DoseStatus.taken) ? MonthDayStatus.taken : MonthDayStatus.notPlanned;
  }
  if (!takenOn(entry, day)) return MonthDayStatus.notPlanned;
  if (day.compareTo(today) > 0) return MonthDayStatus.upcoming;
  // A time she has since removed still counts for the day she marked it.
  final slots = {
    ...plan.times,
    for (final m in marks)
      if (m.slot != null) m.slot!,
  };
  var taken = 0;
  var skipped = 0;
  for (final s in slots) {
    final m = marks.where((x) => x.slot == s).lastOrNull;
    if (m == null) continue;
    if (m.status == DoseStatus.taken) {
      taken++;
    } else {
      skipped++;
    }
  }
  if (taken == slots.length) return MonthDayStatus.taken;
  if (taken > 0) return MonthDayStatus.partly;
  if (skipped > 0) return MonthDayStatus.notTaken;
  return MonthDayStatus.notMarked;
}
