/// Everything Femio v1 knows about her, which never leaves the phone (D7, ADR-070).
///
/// Deliberately small: what the five onboarding answers produce plus the period
/// starts she logs. Bands and years rather than exact dates where nothing needs more
/// precision (data minimisation), and every answer may be absent because every
/// question after the goal can be skipped.
library;

enum Goal { period, ttc, pregnant, menopause }

enum TryingFor { justStarted, under6, sixTo12, over12 }

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
  });

  final Goal goal;
  final String locale;
  final int? birthYear;

  /// ISO dates of the first day of each period she has logged, oldest first.
  final List<String> periodStarts;
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
      );

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
      );
}
