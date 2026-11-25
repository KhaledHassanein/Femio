/// Everything Femio v1 knows about her, which never leaves the phone (D7, ADR-070).
///
/// Deliberately small: what the five onboarding answers produce plus the period
/// starts she logs. Bands and years rather than exact dates where nothing needs more
/// precision (data minimisation), and every answer may be absent because every
/// question after the goal can be skipped.
library;

import '../domain/appointments.dart';
import '../domain/assistant/cloud_consent.dart';
import '../domain/contractions.dart';
import '../domain/movements.dart';
import '../domain/weight.dart';

enum Goal { period, ttc, pregnant, menopause }

/// The record's schema version, written as `v`. Bump it when a field changes
/// meaning; [migrateRecord] carries older files forward.
const schemaVersion = 2;

/// Brings a record written by an older build up to [schemaVersion]. Unknown
/// future versions are returned untouched so [Profile.fromJson] can refuse them
/// loudly rather than guess. v1 → v2 added `settings`; its absence is the
/// default, so nothing to rewrite.
Map<String, Object?> migrateRecord(Map<String, Object?> json) {
  final v = (json['v'] as num?)?.toInt() ?? 1;
  if (v < 2) return {...json, 'v': 2};
  return json;
}

/// Minutes after local midnight for the daily log reminder until she picks a time: 20:00.
const defaultLogReminderMinutes = 20 * 60;

/// Her preferences, kept with the record so a backup carries them.
///
/// The reminder fields are absent in records written before R4.4, and absent means off,
/// so the schema version stays 2.
class AppSettings {
  const AppSettings({
    this.showHijri = false,
    this.storageNoticeSeen = false,
    this.logReminder = false,
    this.logReminderMinutes = defaultLogReminderMinutes,
    this.periodReminder = false,
    this.cloud = const CloudConsent(),
    this.usageDays = 0,
    this.lastUsageDay,
    this.reviewAskedBuild,
    this.assistantOn = true,
    this.assistantIntroSeen = false,
  });

  /// Show Hijri dates beside Gregorian ones (on by default in Arabic, see
  /// [AppSettings.defaultsFor]).
  final bool showHijri;

  /// The one-time "your records stay on this phone" notice has been dismissed.
  final bool storageNoticeSeen;

  /// A daily nudge to log, at [logReminderMinutes]. Off until she turns it on (an offer,
  /// never a score).
  final bool logReminder;

  /// When the daily nudge fires, in minutes after local midnight (0 to 1439).
  final int logReminderMinutes;

  /// One notification the day before her predicted period window opens. Off by default.
  final bool periodReminder;

  /// Cloud boost consent with its receipts (ADR-079, ADR-080): which purposes she agreed to,
  /// when, and on which consent text. Nothing is allowed by default; only the consent screen
  /// grants, and an older consent text or a restored backup allows nothing.
  final CloudConsent cloud;

  /// How many different days she has opened femio (R12.2). Absent in older records: 0.
  final int usageDays;

  /// The last ISO day counted in [usageDays].
  final String? lastUsageDay;

  /// The app build that last asked Google Play for a rating; null when never (R12.2).
  final int? reviewAskedBuild;

  /// Her master switch for every AI use (ADR-081 kill switch 3). On by default; off means
  /// rules and guides only, with no model call on the phone or in the cloud.
  final bool assistantOn;

  /// The first-use sheet (what runs on the phone, Cloud boost as an option) has been shown
  /// (R8.3). Absent in older records: false, so she sees it once.
  final bool assistantIntroSeen;

  /// Whether Cloud boost is on for any purpose.
  bool get cloudBoost => cloud.any;

  /// Defaults for a new record in [locale].
  static AppSettings defaultsFor(String locale) => AppSettings(showHijri: locale == 'ar');

  AppSettings copyWith({
    bool? showHijri,
    bool? storageNoticeSeen,
    bool? logReminder,
    int? logReminderMinutes,
    bool? periodReminder,
    CloudConsent? cloud,
    int? usageDays,
    String? lastUsageDay,
    int? reviewAskedBuild,
    bool? assistantOn,
    bool? assistantIntroSeen,
  }) =>
      AppSettings(
        showHijri: showHijri ?? this.showHijri,
        storageNoticeSeen: storageNoticeSeen ?? this.storageNoticeSeen,
        logReminder: logReminder ?? this.logReminder,
        logReminderMinutes: logReminderMinutes ?? this.logReminderMinutes,
        periodReminder: periodReminder ?? this.periodReminder,
        cloud: cloud ?? this.cloud,
        usageDays: usageDays ?? this.usageDays,
        lastUsageDay: lastUsageDay ?? this.lastUsageDay,
        reviewAskedBuild: reviewAskedBuild ?? this.reviewAskedBuild,
        assistantOn: assistantOn ?? this.assistantOn,
        assistantIntroSeen: assistantIntroSeen ?? this.assistantIntroSeen,
      );

  Map<String, Object?> toJson() => {
        'showHijri': showHijri,
        'storageNoticeSeen': storageNoticeSeen,
        'logReminder': logReminder,
        'logReminderMinutes': logReminderMinutes,
        'periodReminder': periodReminder,
        'cloudConsent': cloud.toJson(),
        'usageDays': usageDays,
        'lastUsageDay': lastUsageDay,
        'reviewAskedBuild': reviewAskedBuild,
        'assistantOn': assistantOn,
        'assistantIntroSeen': assistantIntroSeen,
      };

  static AppSettings fromJson(Map<String, Object?>? j) {
    final minutes = (j?['logReminderMinutes'] as num?)?.toInt();
    return AppSettings(
      showHijri: j?['showHijri'] as bool? ?? false,
      storageNoticeSeen: j?['storageNoticeSeen'] as bool? ?? false,
      logReminder: j?['logReminder'] as bool? ?? false,
      // A time outside the clock (a damaged or hand-edited backup) falls back to the default.
      logReminderMinutes: minutes != null && minutes >= 0 && minutes < 24 * 60 ? minutes : defaultLogReminderMinutes,
      periodReminder: j?['periodReminder'] as bool? ?? false,
      // Only a receipt on today's consent text counts; the bare `cloudBoost: true` of the
      // hackathon build carried no receipt, so it reads as no consent and she is asked again.
      cloud: CloudConsent.fromJson(j?['cloudConsent']),
      usageDays: ((j?['usageDays'] as num?)?.toInt() ?? 0).clamp(0, 1 << 20),
      lastUsageDay: j?['lastUsageDay'] as String?,
      reviewAskedBuild: (j?['reviewAskedBuild'] as num?)?.toInt(),
      assistantOn: j?['assistantOn'] as bool? ?? true,
      assistantIntroSeen: j?['assistantIntroSeen'] as bool? ?? false,
    );
  }
}

enum TryingFor { justStarted, under6, sixTo12, over12 }

/// One day's log. Terms are keys from the shared vocabulary (`log_vocabulary.g.dart`).
class DayLog {
  const DayLog({this.flow, this.terms = const [], this.opk, this.bbt});

  /// `spotting`, `light`, `medium`, `heavy`, or null for no bleeding logged.
  final String? flow;
  final List<String> terms;

  /// What her ovulation-test stick said (`opkResults`), verbatim.
  final String? opk;

  /// Waking temperature, in the unit she typed (°C or °F, guessed from magnitude).
  final double? bbt;

  bool get isEmpty => flow == null && terms.isEmpty && opk == null && bbt == null;

  DayLog copyWith({
    Object? flow = _keep,
    List<String>? terms,
    Object? opk = _keep,
    Object? bbt = _keep,
  }) =>
      DayLog(
        flow: identical(flow, _keep) ? this.flow : flow as String?,
        terms: terms ?? this.terms,
        opk: identical(opk, _keep) ? this.opk : opk as String?,
        bbt: identical(bbt, _keep) ? this.bbt : bbt as double?,
      );

  /// Spotting is logged but is not a period: it never starts a cycle.
  bool get isBleed => flow != null && flow != 'spotting';

  Map<String, Object?> toJson() => {'flow': flow, 'terms': terms, 'opk': opk, 'bbt': bbt};
  static DayLog fromJson(Map<String, Object?> j) => DayLog(
        flow: j['flow'] as String?,
        terms: List<String>.from((j['terms'] as List?) ?? const []),
        opk: j['opk'] as String?,
        bbt: (j['bbt'] as num?)?.toDouble(),
      );
}

const _keep = Object();

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
    this.contractions = const [],
    this.movements = const [],
    this.weights = const [],
    this.appointments = const [],
    this.settings = const AppSettings(),
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

  /// Contraction times, as she recorded them (the timer sorts them).
  final List<Contraction> contractions;

  /// Movement-log sessions, oldest first. The last may still be open.
  final List<MovementSession> movements;

  /// Weight readings as she typed them.
  final List<WeightEntry> weights;

  /// Appointments: when, with whom, what to ask. Never a result.
  final List<Appointment> appointments;

  /// Her preferences (Hijri display, dismissed notices).
  final AppSettings settings;
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
    List<Contraction>? contractions,
    List<MovementSession>? movements,
    List<WeightEntry>? weights,
    List<Appointment>? appointments,
    AppSettings? settings,
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
        contractions: contractions ?? this.contractions,
        movements: movements ?? this.movements,
        weights: weights ?? this.weights,
        appointments: appointments ?? this.appointments,
        settings: settings ?? this.settings,
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
        'v': schemaVersion,
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
        'contractions': [for (final c in contractions) c.toJson()],
        'movements': [for (final m in movements) m.toJson()],
        'weights': [for (final w in weights) w.toJson()],
        'appointments': [for (final a in appointments) a.toJson()],
        'settings': settings.toJson(),
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
        contractions: [
          for (final c in (j['contractions'] as List?) ?? const [])
            Contraction.fromJson(Map<String, Object?>.from(c as Map)),
        ],
        movements: [
          for (final m in (j['movements'] as List?) ?? const [])
            MovementSession.fromJson(Map<String, Object?>.from(m as Map)),
        ],
        weights: [
          for (final w in (j['weights'] as List?) ?? const []) WeightEntry.fromJson(Map<String, Object?>.from(w as Map)),
        ],
        appointments: [
          for (final a in (j['appointments'] as List?) ?? const [])
            Appointment.fromJson(Map<String, Object?>.from(a as Map)),
        ],
        settings: AppSettings.fromJson(j['settings'] == null ? null : Map<String, Object?>.from(j['settings'] as Map)),
      );
}
