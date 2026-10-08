/// Everything Femio v1 knows about her, which never leaves the phone (D7, ADR-070).
///
/// Deliberately small: what the five onboarding answers produce plus the period
/// starts she logs. Bands and years rather than exact dates where nothing needs more
/// precision (data minimisation), and every answer may be absent because every
/// question after the goal can be skipped.
library;

enum Goal { period, ttc, pregnant, menopause }

enum TryingFor { justStarted, under6, sixTo12, over12 }

/// One day's log. Terms are keys from the shared vocabulary (`log_vocabulary.g.dart`).
class DayLog {
  const DayLog({this.flow, this.terms = const []});

  /// `spotting`, `light`, `medium`, `heavy`, or null for no bleeding logged.
  final String? flow;
  final List<String> terms;

  bool get isEmpty => flow == null && terms.isEmpty;

  /// Spotting is logged but is not a period: it never starts a cycle.
  bool get isBleed => flow != null && flow != 'spotting';

  Map<String, Object?> toJson() => {'flow': flow, 'terms': terms};
  static DayLog fromJson(Map<String, Object?> j) =>
      DayLog(flow: j['flow'] as String?, terms: List<String>.from((j['terms'] as List?) ?? const []));
}

class Profile {
  const Profile({
    required this.goal,
    required this.locale,
    this.birthYear,
    this.periodStarts = const [],
    this.periodLength,
    this.cycleLength,
    this.irregular = false,
    this.tryingFor,
    this.edd,
    this.birthDate,
    this.lastPeriodOverYear = false,
    this.logs = const {},
  });

  final Goal goal;
  final String locale;
  final int? birthYear;

  /// Every day of bleeding she has recorded, oldest first: her onboarding answer plus
  /// any day logged with a flow other than spotting. The prediction collapses
  /// consecutive days into one period (`bleedStarts`), so whole periods can be logged.
  final List<String> periodStarts;

  /// Day logs by ISO date.
  final Map<String, DayLog> logs;
  final int? periodLength;

  /// Her stated usual cycle length. Null when she said "not sure" or "irregular".
  final int? cycleLength;
  final bool irregular;
  final TryingFor? tryingFor;

  /// Estimated due date, however she gave it (due date, LMP, conception, transfer).
  final String? edd;

  /// Set when she has had her baby; the app is then in its after-birth stage.
  final String? birthDate;

  /// Menopause only: her last period was over a year ago and she does not know when.
  final bool lastPeriodOverYear;

  Profile copyWith({
    List<String>? periodStarts,
    String? locale,
    Map<String, DayLog>? logs,
  }) =>
      Profile(
        goal: goal,
        locale: locale ?? this.locale,
        birthYear: birthYear,
        periodStarts: periodStarts ?? this.periodStarts,
        periodLength: periodLength,
        cycleLength: cycleLength,
        irregular: irregular,
        tryingFor: tryingFor,
        edd: edd,
        birthDate: birthDate,
        lastPeriodOverYear: lastPeriodOverYear,
        logs: logs ?? this.logs,
      );

  /// Set or clear one day's log, keeping [periodStarts] in step with its flow.
  Profile withDayLog(String date, DayLog log) {
    final nextLogs = {...logs};
    if (log.isEmpty) {
      nextLogs.remove(date);
    } else {
      nextLogs[date] = log;
    }
    final bleeds = {...periodStarts};
    if (log.isBleed) {
      bleeds.add(date);
    } else {
      bleeds.remove(date);
    }
    return copyWith(logs: nextLogs, periodStarts: bleeds.toList()..sort());
  }

  Map<String, Object?> toJson() => {
        'v': 1,
        'goal': goal.name,
        'locale': locale,
        'birthYear': birthYear,
        'periodStarts': periodStarts,
        'periodLength': periodLength,
        'cycleLength': cycleLength,
        'irregular': irregular,
        'tryingFor': tryingFor?.name,
        'edd': edd,
        'birthDate': birthDate,
        'lastPeriodOverYear': lastPeriodOverYear,
        'logs': {for (final e in logs.entries) e.key: e.value.toJson()},
      };

  static Profile fromJson(Map<String, Object?> j) => Profile(
        goal: Goal.values.byName(j['goal'] as String),
        locale: j['locale'] as String? ?? 'en',
        birthYear: j['birthYear'] as int?,
        periodStarts: List<String>.from((j['periodStarts'] as List?) ?? const []),
        periodLength: j['periodLength'] as int?,
        cycleLength: j['cycleLength'] as int?,
        irregular: j['irregular'] as bool? ?? false,
        tryingFor: j['tryingFor'] == null ? null : TryingFor.values.byName(j['tryingFor'] as String),
        edd: j['edd'] as String?,
        birthDate: j['birthDate'] as String?,
        lastPeriodOverYear: j['lastPeriodOverYear'] as bool? ?? false,
        logs: {
          for (final e in ((j['logs'] as Map?) ?? const {}).entries)
            e.key as String: DayLog.fromJson(Map<String, Object?>.from(e.value as Map)),
        },
      );
}
