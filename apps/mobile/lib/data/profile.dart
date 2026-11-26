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
import '../domain/health_record.dart';
import '../domain/medicines.dart';
import '../domain/record_attachment.dart';
import '../domain/movements.dart';
import '../domain/weight.dart';

enum Goal { period, ttc, pregnant, menopause }

/// The record's schema version, written as `v`. Bump it when a field changes
/// meaning; [migrateRecord] carries older files forward.
const schemaVersion = 3;

/// Brings a record written by an older build up to [schemaVersion]. Unknown
/// future versions are returned untouched so [Profile.fromJson] can refuse them
/// loudly rather than guess. v1 → v2 added `settings`; v2 → v3 added `record`, her
/// health record (ADR-082). Both are absent-means-empty, so only the version moves.
Map<String, Object?> migrateRecord(Map<String, Object?> json) {
  final v = (json['v'] as num?)?.toInt() ?? 1;
  if (v < schemaVersion) return {...json, 'v': schemaVersion};
  return json;
}

/// Minutes after local midnight for the daily log reminder until she picks a time: 20:00.
const defaultLogReminderMinutes = 20 * 60;

/// Stands in for the date of a notification consent given before R12.1 had a consent
/// screen: a record with a reminder switch already on was switched on after the phone's own
/// permission prompt (R4.4), but no date was kept. Not a date; it only means "consented".
const legacyNotificationConsent = 'before-r12';

/// Her preferences, kept with the record so a backup carries them.
///
/// The reminder fields are absent in records written before R4.4, and absent means off,
/// so the schema version stays 2. The same holds for R12.1's appointment reminder and
/// consent date: absent means off and not yet consented.
class AppSettings {
  const AppSettings({
    this.showHijri = false,
    this.storageNoticeSeen = false,
    this.logReminder = false,
    this.logReminderMinutes = defaultLogReminderMinutes,
    this.periodReminder = false,
    this.appointmentReminder = false,
    this.medicineReminder = false,
    this.notificationConsentAt,
    this.widgetDetails = false,
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

  /// One notification the day before each saved appointment that has a date. Off by default.
  final bool appointmentReminder;

  /// Reminders for the medicines she set to remind her (R11.6). Off by default; each
  /// medicine also has its own switch ([MedicinePlan.remind]).
  final bool medicineReminder;

  /// When she said yes on the notification consent screen (ISO timestamp, local phone time),
  /// or [legacyNotificationConsent] for a record that predates the screen. Null means she
  /// has not consented, and nothing is ever scheduled (`planReminders`).
  final String? notificationConsentAt;

  /// Whether she has consented to notifications (R12.1).
  bool get hasNotificationConsent => notificationConsentAt != null;

  /// The home-screen widget shows the pregnancy week or the next-period range (R9.11).
  /// Off, or absent from an older file, means the widget stays neutral: the wordmark and
  /// "Open femio", no health word.
  final bool widgetDetails;

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
    bool? appointmentReminder,
    bool? medicineReminder,
    String? notificationConsentAt,
    bool? widgetDetails,
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
        appointmentReminder: appointmentReminder ?? this.appointmentReminder,
        medicineReminder: medicineReminder ?? this.medicineReminder,
        notificationConsentAt: notificationConsentAt ?? this.notificationConsentAt,
        widgetDetails: widgetDetails ?? this.widgetDetails,
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
        'appointmentReminder': appointmentReminder,
        'medicineReminder': medicineReminder,
        'notificationConsentAt': notificationConsentAt,
        'widgetDetails': widgetDetails,
        'cloudConsent': cloud.toJson(),
        'usageDays': usageDays,
        'lastUsageDay': lastUsageDay,
        'reviewAskedBuild': reviewAskedBuild,
        'assistantOn': assistantOn,
        'assistantIntroSeen': assistantIntroSeen,
      };

  static AppSettings fromJson(Map<String, Object?>? j) {
    final minutes = (j?['logReminderMinutes'] as num?)?.toInt();
    final logOn = j?['logReminder'] as bool? ?? false;
    final periodOn = j?['periodReminder'] as bool? ?? false;
    final consent = j?['notificationConsentAt'];
    return AppSettings(
      showHijri: j?['showHijri'] as bool? ?? false,
      storageNoticeSeen: j?['storageNoticeSeen'] as bool? ?? false,
      logReminder: logOn,
      // A time outside the clock (a damaged or hand-edited backup) falls back to the default.
      logReminderMinutes: minutes != null && minutes >= 0 && minutes < 24 * 60 ? minutes : defaultLogReminderMinutes,
      periodReminder: periodOn,
      appointmentReminder: j?['appointmentReminder'] as bool? ?? false,
      medicineReminder: j?['medicineReminder'] as bool? ?? false,
      // A record written before R12.1 with a switch already on keeps working: she turned it
      // on after the phone's own permission prompt. With no switch on, she is asked.
      notificationConsentAt: consent is String && consent.isNotEmpty ? consent : (logOn || periodOn ? legacyNotificationConsent : null),
      widgetDetails: j?['widgetDetails'] as bool? ?? false,
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
  const DayLog({this.flow, this.terms = const [], this.opk, this.bbt, this.note});

  /// `spotting`, `light`, `medium`, `heavy`, or null for no bleeding logged.
  final String? flow;
  final List<String> terms;

  /// What her ovulation-test stick said (`opkResults`), verbatim.
  final String? opk;

  /// Waking temperature, in the unit she typed (°C or °F, guessed from magnitude).
  final double? bbt;

  /// Her own words about the day (R9.8). Optional and absent in older records, so the
  /// schema version does not change. Stored with the sealed record and so in the backup.
  final String? note;

  /// A note holding only spaces or line breaks is no note.
  bool get hasNote => note != null && note!.trim().isNotEmpty;

  bool get isEmpty => flow == null && terms.isEmpty && opk == null && bbt == null && !hasNote;

  DayLog copyWith({
    Object? flow = _keep,
    List<String>? terms,
    Object? opk = _keep,
    Object? bbt = _keep,
    Object? note = _keep,
  }) =>
      DayLog(
        flow: identical(flow, _keep) ? this.flow : flow as String?,
        terms: terms ?? this.terms,
        opk: identical(opk, _keep) ? this.opk : opk as String?,
        bbt: identical(bbt, _keep) ? this.bbt : bbt as double?,
        note: identical(note, _keep) ? this.note : note as String?,
      );

  /// Spotting is logged but is not a period: it never starts a cycle.
  bool get isBleed => flow != null && flow != 'spotting';

  Map<String, Object?> toJson() => {
        'flow': flow,
        'terms': terms,
        'opk': opk,
        'bbt': bbt,
        if (note != null) 'note': note,
      };
  static DayLog fromJson(Map<String, Object?> j) => DayLog(
        flow: j['flow'] as String?,
        terms: List<String>.from((j['terms'] as List?) ?? const []),
        opk: j['opk'] as String?,
        bbt: (j['bbt'] as num?)?.toDouble(),
        note: j['note'] as String?,
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
    this.record = const [],
    this.attachments = const [],
    this.medicinePlans = const [],
    this.doses = const [],
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

  /// Her health record (ADR-082): visits, results, medicines, documents, in any order;
  /// [timeline] sorts them.
  final List<RecordEntry> record;

  /// What describes each document or photo she attached (R11.2); the bytes are sealed in
  /// their own files, named by [RecordAttachment.id]. Entries link to them by id.
  final List<RecordAttachment> attachments;

  /// Her times, reminder and refill day for each medicine entry (R11.6), by entry id.
  final List<MedicinePlan> medicinePlans;

  /// Every dose she marked taken or skipped (R11.6), in the order she marked them.
  final List<DoseMark> doses;

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
    List<RecordEntry>? record,
    List<RecordAttachment>? attachments,
    List<MedicinePlan>? medicinePlans,
    List<DoseMark>? doses,
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
        record: record ?? this.record,
        attachments: attachments ?? this.attachments,
        medicinePlans: medicinePlans ?? this.medicinePlans,
        doses: doses ?? this.doses,
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
        if (record.isNotEmpty) 'record': [for (final e in record) e.toJson()],
        if (attachments.isNotEmpty) 'attachments': [for (final a in attachments) a.toJson()],
        if (medicinePlans.isNotEmpty) 'medicinePlans': [for (final m in medicinePlans) m.toJson()],
        if (doses.isNotEmpty) 'doses': [for (final d in doses) d.toJson()],
        'settings': settings.toJson(),
      };

  /// Reads a record. Throws [FormatException] for a file written by a newer femio, so it
  /// is kept aside rather than read without the parts this build does not know and then
  /// saved over (ADR-082).
  static Profile fromJson(Map<String, Object?> j) {
    final v = (j['v'] as num?)?.toInt() ?? 1;
    if (v > schemaVersion) throw FormatException('record schema v$v is newer than this build (v$schemaVersion)');
    return _fromJson(j);
  }

  static Profile _fromJson(Map<String, Object?> j) => Profile(
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
        record: [
          for (final e in (j['record'] as List?) ?? const []) RecordEntry.fromJson(Map<String, Object?>.from(e as Map)),
        ],
        attachments: [
          for (final a in (j['attachments'] as List?) ?? const []) RecordAttachment.fromJson(Map<String, Object?>.from(a as Map)),
        ],
        medicinePlans: [
          for (final m in (j['medicinePlans'] as List?) ?? const []) MedicinePlan.fromJson(Map<String, Object?>.from(m as Map)),
        ],
        doses: [
          for (final d in (j['doses'] as List?) ?? const []) DoseMark.fromJson(Map<String, Object?>.from(d as Map)),
        ],
        settings: AppSettings.fromJson(j['settings'] == null ? null : Map<String, Object?>.from(j['settings'] as Map)),
      );
}
