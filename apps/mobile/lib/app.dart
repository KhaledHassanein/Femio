// The app root: the one shared controller (her record, language and lock) and the MaterialApp.
//
// Why it exists: v1 has few enough screens that one ChangeNotifier is simpler than a state
// library. This file decides which of the worlds she sees: loading, the lock screen,
// onboarding, a quarantined record, or the home shell, and wires in the theme,
// languages and localisation delegates.

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/ai_ledger_store.dart';
import 'data/app_lock.dart';
import 'data/assistant_channel.dart';
import 'data/backup.dart';
import 'data/key_vault.dart';
import 'data/play_store.dart';
import 'data/profile.dart';
import 'data/notification_port.dart';
import 'data/reminder_scheduler.dart';
import 'data/safety_session.dart';
import 'data/store.dart';
import 'features/assistant/assistant_scope.dart';
import 'features/home/home_shell.dart';
import 'domain/assistant/ai_ledger.dart';
import 'domain/dates.dart';
import 'domain/store_prompts.dart';
import 'features/lock/lock_screen.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'domain/notification_kinds.dart';
import 'domain/reminders.dart';
import 'features/settings/corrupt_record_screen.dart';
import 'l10n/app_localizations.dart';
import 'theme/femio_theme.dart';

/// The languages Femio speaks, as ISO 639-1 codes. Arabic is first-class, not a
/// translation afterthought (product rule 6).
const supportedLanguages = ['ar', 'en', 'fr', 'es'];

/// What the controller knows about the record on disk.
enum RecordState { loading, ready, corrupt }

/// Holds her record, the chosen language and the lock state. One object, listened
/// to by the app, because v1 has a handful of screens and a state library would be weight.
class FemioController extends ChangeNotifier {
  /// [store] is where her record lives; [vault] holds the lock PIN (a memory vault
  /// in tests); [initialLocale] is the language to start in before she has chosen one;
  /// [reminders] shows her reminders (none in tests); [clock] reads "now" for the
  /// reminder plan (fixed in tests); [playStore] is Google Play's rating and update
  /// services (none in tests); [ledger] keeps the AI ledger (memory in tests).
  FemioController(
    this.store, {
    KeyVault? vault,
    String? initialLocale,
    NotificationPort? reminders,
    DateTime Function()? clock,
    this.playStore = const NoPlayStore(),
    AiLedgerStore? ledger,
  })  : _lock = AppLock(vault ?? MemoryKeyVault()),
        _ledgerStore = ledger ?? MemoryLedgerStore(),
        _locale = initialLocale,
        _reminders = reminders ?? const NoNotificationPort(),
        _clock = clock ?? DateTime.now;

  /// Where her record is saved. Swappable, so tests use memory and the app uses a file.
  final FemioStore store;

  /// Google Play's rating dialog and in-app updates (R12.2, R12.3).
  final PlayStore playStore;
  final AppLock _lock;
  final AiLedgerStore _ledgerStore;
  final NotificationPort _reminders;
  final DateTime Function() _clock;

  /// What was last handed to the scheduler, so an unchanged plan is not rescheduled on
  /// every save. Null forces the next sync (app start, after a failure).
  ({List<PlannedReminder> plan, ReminderTexts texts})? _scheduled;

  /// Her record, or null before she finishes onboarding (or after she starts over).
  Profile? profile;

  /// Every model call, newest first (R10.3). Kept beside her record, never inside it.
  List<LedgerEntry> aiLedger = const [];

  /// Whether the record loaded, is still loading, or was quarantined.
  RecordState state = RecordState.loading;

  /// Where a quarantined record was moved, for the recovery screen.
  String? quarantinedPath;

  /// True while the lock screen must be shown.
  bool locked = false;

  /// True when a PIN is set.
  bool lockEnabled = false;

  /// Convenience for the old call sites: true once [load] has finished.
  bool get loaded => state != RecordState.loading;

  String? _locale;
  DateTime? _backgroundedAt;

  /// The language she picked, else the phone's if Femio speaks it, else English.
  Locale locale(Locale? device) {
    final code = profile?.locale ?? _locale ?? device?.languageCode;
    return Locale(supportedLanguages.contains(code) ? code! : 'en');
  }

  /// Reads her saved record and the lock state, then tells listeners. A record
  /// that cannot be read is quarantined by the store and reported, never replaced.
  Future<void> load() async {
    lockEnabled = await _lock.isEnabled;
    locked = lockEnabled;
    switch (await store.load()) {
      case Loaded(:final profile):
        this.profile = profile;
        state = RecordState.ready;
      case Empty():
        profile = null;
        state = RecordState.ready;
      case Corrupt(:final quarantinedPath):
        profile = null;
        this.quarantinedPath = quarantinedPath;
        state = RecordState.corrupt;
    }
    aiLedger = await _ledgerStore.load();
    await _syncReminders(force: true);
    notifyListeners();
    await _countUsageDay();
  }

  /// Switches the app to [code] at once. Only codes in [supportedLanguages] take
  /// effect; it is saved with the profile the next time the profile is saved.
  void setLanguage(String code) {
    _locale = code;
    if (profile != null) profile = profile!.copyWith(locale: code);
    notifyListeners();
  }

  /// Adds one model call to the AI ledger and saves it. Called by the assistant gateway.
  Future<void> recordAiCall(LedgerEntry entry) async {
    aiLedger = addToLedger(aiLedger, entry);
    notifyListeners();
    await _ledgerStore.save(aiLedger);
  }

  /// Empties the AI ledger (her choice in Settings, or "delete everything").
  Future<void> clearAiLedger() async {
    aiLedger = const [];
    await _ledgerStore.clear();
    notifyListeners();
  }

  /// Replaces her record with [p], saves it to the [store] and tells listeners.
  Future<void> save(Profile p) async {
    profile = p;
    state = RecordState.ready;
    await store.save(p);
    await _syncReminders();
    notifyListeners();
  }

  /// Writes one day's log (flow and terms) and saves. [date] is an ISO day. Requires
  /// a loaded [profile].
  Future<void> setDayLog(String date, DayLog log) async {
    await save(profile!.withDayLog(date, log));
    await _maybeAskForReview();
  }

  /// Counts today as a day of use (R12.2); saves only when the day is new.
  Future<void> _countUsageDay() async {
    final p = profile;
    if (p == null) return;
    final today = todayISO(_clock());
    if (p.settings.lastUsageDay == today) return;
    final next = countUsageDay(p.settings.usageDays, p.settings.lastUsageDay, today);
    await save(p.copyWith(settings: p.settings.copyWith(usageDays: next.days, lastUsageDay: next.lastDay)));
  }

  /// After a saved log, the one calm moment for the rating request: at most once per
  /// build, after six days of use, never in a session that showed a safety screen. The
  /// build is recorded before Play is asked, so a failing dialog never asks twice.
  Future<void> _maybeAskForReview() async {
    final s = profile!.settings;
    if (!shouldAskForReview(usageDays: s.usageDays, askedForBuild: s.reviewAskedBuild, safetyShownThisSession: SafetySession.shown)) {
      return;
    }
    await setSettings(s.copyWith(reviewAskedBuild: appBuild));
    await playStore.requestReview();
  }

  /// Updates her preferences and saves.
  Future<void> setSettings(AppSettings settings) => save(profile!.copyWith(settings: settings));

  /// Whether she still has to see the notification consent screen before any reminder can
  /// be switched on (R12.1). False without a record.
  bool get needsNotificationConsent => profile != null && !profile!.settings.hasNotificationConsent;

  /// Turns reminders on or off, or moves the daily time, then saves and reschedules.
  /// A null argument leaves that setting alone. Turning one ON needs consent first
  /// ([grantNotificationConsent]) and then the phone's notification permission; when either
  /// is missing, nothing changes and this returns false so Settings can say why. Turning
  /// one off or moving the time never asks. Requires a loaded [profile].
  Future<bool> updateReminders({bool? log, bool? period, bool? appointment, int? logMinutes}) async {
    final s = profile!.settings;
    final turningOn = (log == true && !s.logReminder) || (period == true && !s.periodReminder) || (appointment == true && !s.appointmentReminder);
    if (turningOn) {
      if (!s.hasNotificationConsent) return false;
      if (!await _reminders.requestPermission()) return false;
    }
    await setSettings(s.copyWith(logReminder: log, periodReminder: period, appointmentReminder: appointment, logReminderMinutes: logMinutes));
    return true;
  }

  /// The consent screen's "Allow": asks the phone for notification permission and, only if
  /// she gives it, records the date and her per-kind [choice] and schedules. Refusal or an
  /// empty choice saves nothing and schedules nothing (the screen explains). Requires a
  /// loaded [profile].
  Future<NotificationConsentResult> grantNotificationConsent(NotificationChoice choice) async {
    if (!choice.any) return NotificationConsentResult.nothingChosen;
    if (!await _reminders.requestPermission()) return NotificationConsentResult.permissionDenied;
    final s = profile!.settings;
    await setSettings(s.copyWith(
      notificationConsentAt: _clock().toIso8601String(),
      logReminder: choice.log,
      periodReminder: choice.period,
      appointmentReminder: choice.appointment,
    ));
    return NotificationConsentResult.granted;
  }

  /// Makes the scheduler match [planReminders] for the current record. A failure in the
  /// notification system must never cost her a saved record, so it is swallowed here
  /// and retried at the next save or app start.
  Future<void> _syncReminders({bool force = false}) async {
    final p = profile;
    try {
      if (p == null) {
        if (force) await _reminders.cancelAll();
        _scheduled = null;
        return;
      }
      final plan = planReminders(p, now: _clock());
      final texts = _reminderTexts(p.locale);
      final last = _scheduled;
      if (!force && last != null && last.texts == texts && _samePlan(last.plan, plan)) return;
      if (plan.isEmpty) {
        await _reminders.cancelAll();
      } else {
        await _reminders.replaceAll(plan, texts);
      }
      _scheduled = (plan: plan, texts: texts);
    } catch (error) {
      _scheduled = null;
      debugPrint('Reminders could not be scheduled: $error');
    }
  }

  static bool _samePlan(List<PlannedReminder> a, List<PlannedReminder> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// The reminder wording in her language; English when the code is unknown.
  static ReminderTexts _reminderTexts(String code) {
    final l = lookupL10n(Locale(supportedLanguages.contains(code) ? code : 'en'));
    return ReminderTexts(
      title: l.reminderTitle,
      body: l.reminderBody,
      channelName: l.reminderChannelName,
      channelDescription: l.reminderChannelDescription,
    );
  }

  /// Deletes her record and the lock from the phone and returns to onboarding.
  /// Settings confirms first; this method does not ask. Pending reminders go too.
  Future<void> deleteEverything() async {
    await store.clear();
    await clearAiLedger();
    await _lock.clear();
    try {
      await _reminders.cancelAll();
    } catch (error) {
      debugPrint('Reminders could not be cancelled: $error');
    }
    _scheduled = null;
    profile = null;
    quarantinedPath = null;
    state = RecordState.ready;
    lockEnabled = false;
    locked = false;
    notifyListeners();
  }

  // ---- app lock -----------------------------------------------------------------

  /// Sets or replaces the PIN. Throws [ArgumentError] for a PIN that is not 4 to 8 digits.
  Future<void> setPin(String pin) async {
    await _lock.setPin(pin);
    lockEnabled = true;
    notifyListeners();
  }

  /// True when [pin] is right. Settings uses it before changing or removing the PIN.
  Future<bool> verifyPin(String pin) => _lock.verify(pin);

  /// Removes the PIN; the caller has already verified it.
  Future<void> removePin() async {
    await _lock.clear();
    lockEnabled = false;
    locked = false;
    notifyListeners();
  }

  /// Tries to unlock with [pin]; returns false and stays locked when it is wrong.
  Future<bool> unlock(String pin) async {
    if (!await _lock.verify(pin)) return false;
    locked = false;
    notifyListeners();
    return true;
  }

  /// Called by the app on lifecycle changes: the record locks again after
  /// [relockAfter] in the background, and the reminders are topped up on return.
  void onLifecycle(AppLifecycleState lifecycle) {
    // The reminder plan covers a rolling month; each return to the app tops it up.
    if (lifecycle == AppLifecycleState.resumed && profile != null) {
      unawaited(_syncReminders());
      unawaited(_countUsageDay());
    }
    if (!lockEnabled) return;
    if (lifecycle == AppLifecycleState.paused || lifecycle == AppLifecycleState.hidden) {
      _backgroundedAt ??= DateTime.now();
    } else if (lifecycle == AppLifecycleState.resumed) {
      final away = _backgroundedAt;
      _backgroundedAt = null;
      if (away != null && DateTime.now().difference(away) >= relockAfter && !locked) {
        locked = true;
        notifyListeners();
      }
    }
  }

  // ---- backup -------------------------------------------------------------------

  /// Her record as a passphrase-sealed file. Requires a loaded [profile].
  Future<Uint8List> exportBackup(String passphrase) => encodeBackup(profile!, passphrase);

  /// Replaces her record with the one in a backup file. Throws [BackupError]
  /// for a foreign file or a wrong passphrase; the current record is untouched then.
  Future<void> importBackup(List<int> bytes, String passphrase) async {
    final restored = await decodeBackup(bytes, passphrase);
    await save(restored);
  }
}

/// The whole app: theme, languages and the choice between the lock screen,
/// onboarding, the recovery screen and the home shell. [controller] is the shared
/// state; [today] fixes the date in tests.
class FemioApp extends StatefulWidget {
  const FemioApp({
    super.key,
    required this.controller,
    this.today,
    this.assistant = const OfflineAssistant(),
  });
  final FemioController controller;

  /// The assistant bridge (ADR-078). Offline by default, so tests never touch a model;
  /// main.dart passes the method-channel bridge.
  final AssistantBridge assistant;

  /// Fixed "today" for screenshot tests; the real app reads the clock.
  final String? today;

  @override
  State<FemioApp> createState() => _FemioAppState();
}

class _FemioAppState extends State<FemioApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) => widget.controller.onLifecycle(state);

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final device = WidgetsBinding.instance.platformDispatcher.locale;
        return MaterialApp(
          title: 'femio',
          debugShowCheckedModeBanner: false,
          theme: FemioTheme.light(),
          darkTheme: FemioTheme.dark(),
          locale: controller.locale(device),
          supportedLocales: [for (final c in supportedLanguages) Locale(c)],
          localizationsDelegates: const [
            L10n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // The lock covers EVERY route, including a Settings page left open when the
          // phone went to sleep; swapping `home` alone would leave pushed routes on top.
          builder: (context, child) => AssistantScope(
              bridge: widget.assistant,
              enabled: () => controller.profile?.settings.assistantOn ?? true,
              record: controller.recordAiCall,
              child: Stack(
              children: [
                // Kept mounted under the lock so she returns exactly where she was;
                // excluded from focus and the accessibility tree while locked.
                ExcludeFocus(excluding: controller.locked, child: ExcludeSemantics(excluding: controller.locked, child: child!)),
                if (controller.locked)
                  // Its own Overlay: the text field needs one and the Navigator's is beneath us.
                  Overlay(initialEntries: [OverlayEntry(builder: (_) => LockScreen(controller: controller))]),
              ],
            ),
          ),
          home: switch (controller) {
            FemioController(state: RecordState.loading) => const SizedBox.shrink(),
            FemioController(state: RecordState.corrupt) => CorruptRecordScreen(controller: controller),
            FemioController(profile: null) => OnboardingFlow(controller: controller, today: widget.today),
            _ => HomeShell(controller: controller, today: widget.today),
          },
        );
      },
    );
  }
}
