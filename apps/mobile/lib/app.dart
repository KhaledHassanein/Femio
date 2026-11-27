// The app root: the one shared controller (her record, language and lock) and the MaterialApp.
//
// Why it exists: v1 has few enough screens that one ChangeNotifier is simpler than a state
// library. This file decides which of the worlds she sees: loading, the lock screen,
// onboarding, a quarantined record, or the home shell, and wires in the theme,
// languages and localisation delegates.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/ai_ledger_store.dart';
import 'data/app_lock.dart';
import 'data/assistant_channel.dart';
import 'data/attachment_store.dart';
import 'data/backup.dart';
import 'data/document_source.dart';
import 'data/home_widget_bridge.dart';
import 'data/key_vault.dart';
import 'data/play_store.dart';
import 'data/profile.dart';
import 'data/record_documents.dart';
import 'domain/health_record.dart';
import 'domain/medicines.dart';
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
import 'domain/home_widget.dart';
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
  /// services (none in tests); [ledger] keeps the AI ledger (memory in tests);
  /// [homeWidget] feeds the home-screen widget (none in tests); [files] holds the sealed
  /// bytes of her documents (memory in tests); [deviceFiles] is the phone's picker, camera,
  /// PDF renderer and share sheet (a fake in tests).
  FemioController(
    this.store, {
    KeyVault? vault,
    String? initialLocale,
    NotificationPort? reminders,
    HomeWidgetBridge? homeWidget,
    DateTime Function()? clock,
    this.playStore = const NoPlayStore(),
    AiLedgerStore? ledger,
    AttachmentStore? files,
    this.deviceFiles = const SystemDocumentSource(),
  })  : _lock = AppLock(vault ?? MemoryKeyVault()),
        _ledgerStore = ledger ?? MemoryLedgerStore(),
        _locale = initialLocale,
        _reminders = reminders ?? const NoNotificationPort(),
        _homeWidget = homeWidget ?? const NoHomeWidgetBridge(),
        _clock = clock ?? DateTime.now {
    documents = RecordDocuments(files ?? MemoryAttachmentStore(), read: () => profile, save: save, clock: _clock);
  }

  /// Where her record is saved. Swappable, so tests use memory and the app uses a file.
  final FemioStore store;

  /// Her attached documents and photos (R11.2): descriptions in the record, sealed bytes beside it.
  late final RecordDocuments documents;

  /// The phone's own ways in and out for documents (R11.2).
  final DocumentSource deviceFiles;

  /// Google Play's rating dialog and in-app updates (R12.2, R12.3).
  final PlayStore playStore;
  final AppLock _lock;
  final AiLedgerStore _ledgerStore;
  final NotificationPort _reminders;
  final HomeWidgetBridge _homeWidget;
  final DateTime Function() _clock;

  /// What was last handed to the scheduler, so an unchanged plan is not rescheduled on
  /// every save. Null forces the next sync (app start, after a failure).
  ({List<PlannedReminder> plan, ReminderTexts texts})? _scheduled;

  /// What the widget was last given, so an unchanged text is not sent again. Null forces a send.
  HomeWidgetContent? _widgetSent;

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

  /// Her choice to protect the screen without a PIN (SEC-1); the PIN protects it anyway.
  bool screenHidden = false;

  /// True when the last save could not be written to the phone. The record in memory is
  /// kept and the screen says so; the file on the phone still holds the last good save,
  /// because each write goes to a temporary file first.
  bool saveFailed = false;

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
    screenHidden = await _lock.screenHidden;
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
    await _syncHomeWidget();
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
  /// A write that fails (a full phone, a storage error) sets [saveFailed] instead of
  /// throwing, so no screen loses what she typed; [retrySave] tries again.
  Future<void> save(Profile p) async {
    profile = p;
    state = RecordState.ready;
    try {
      await store.save(p);
      saveFailed = false;
    } catch (_) {
      saveFailed = true;
    }
    await _syncReminders();
    await _syncHomeWidget();
    notifyListeners();
  }

  /// Saves the record in memory again after a failed write.
  Future<void> retrySave() async {
    if (profile case final p?) await save(p);
  }

  /// Writes one day's log (flow and terms) and saves. [date] is an ISO day. Requires
  /// a loaded [profile].
  Future<void> setDayLog(String date, DayLog log) async {
    await save(profile!.withDayLog(date, log));
    await _maybeAskForReview();
  }

  /// Records the birth on [day] (R8.19): the pregnancy record stays, the app moves to its
  /// after-birth stage.
  Future<void> recordBirth(String day) => save(profile!.copyWith(birthDate: day));

  /// Her period came back on [day] (R8.19, MR-60): she picks what femio helps with now
  /// ([goal], period or trying to conceive) and [day] becomes the first period her ranges
  /// read. The birth date stays, so bleeding before it never counts.
  Future<void> periodCameBack(String day, Goal goal) async {
    final p = profile!.copyWith(goal: goal);
    await save(p.withDayLog(day, (p.logs[day] ?? const DayLog()).copyWith(flow: 'medium')));
  }

  /// Her pregnancy ended on [day] without a birth (MR-35): see [Profile.endPregnancy].
  Future<void> endPregnancy(String day, Goal next) => save(profile!.endPregnancy(day, next));

  /// She is, or is no longer, breastfeeding: a layer over her stage, nothing is removed.
  Future<void> setBreastfeeding(bool on) => save(profile!.copyWith(breastfeeding: on));

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

  /// Adds [entry] to her health record, or replaces the entry with the same id (ADR-082).
  Future<void> saveRecordEntry(RecordEntry entry) => save(profile!.copyWith(record: [
        for (final e in profile!.record)
          if (e.id != entry.id) e,
        entry,
      ]));

  /// Removes the entry with [id] from her health record, with its medicine plan and dose
  /// marks if it was a medicine; nothing happens if there is none.
  Future<void> deleteRecordEntry(String id) => save(profile!.copyWith(
        record: [for (final e in profile!.record) if (e.id != id) e],
        medicinePlans: [for (final m in profile!.medicinePlans) if (m.entryId != id) m],
        doses: [for (final d in profile!.doses) if (d.entryId != id) d],
      ));

  /// Saves her times, reminder, label and refill day for one medicine (R11.6), replacing the
  /// plan for the same entry. Reminders are rescheduled by [save].
  Future<void> setMedicinePlan(MedicinePlan plan) => save(profile!.copyWith(medicinePlans: [
        for (final m in profile!.medicinePlans)
          if (m.entryId != plan.entryId) m,
        plan,
      ]));

  /// Marks one dose of medicine [entryId] on [day]: [slot] is its planned time in minutes,
  /// or null for a dose taken as needed. [status] null clears the mark of a planned time.
  /// [at] is when she says it happened (now by default). A contraceptive is never marked.
  Future<void> markDose({required String entryId, required String day, int? slot, DoseStatus? status, DateTime? at}) async {
    final p = profile!;
    final entry = p.record.where((e) => e.id == entryId).firstOrNull;
    if (entry == null || scheduleBlocked(entry)) return;
    final when = (at ?? _clock()).toIso8601String().substring(0, 19);
    final mark = status == null ? null : DoseMark(entryId: entryId, day: day, slot: slot, status: status, at: when);
    await save(p.copyWith(doses: withMark(p.doses, entryId: entryId, day: day, slot: slot, mark: mark)));
  }

  /// Removes one dose she took as needed (a mark with no planned time).
  Future<void> removeDose(DoseMark mark) => save(profile!.copyWith(doses: [
        for (final d in profile!.doses)
          if (!(d.entryId == mark.entryId && d.day == mark.day && d.slot == mark.slot && d.at == mark.at)) d,
      ]));

  /// Whether she still has to see the notification consent screen before any reminder can
  /// be switched on (R12.1). False without a record.
  bool get needsNotificationConsent => profile != null && !profile!.settings.hasNotificationConsent;

  /// Turns reminders on or off, or moves the daily time, then saves and reschedules.
  /// A null argument leaves that setting alone. Turning one ON needs consent first
  /// ([grantNotificationConsent]) and then the phone's notification permission; when either
  /// is missing, nothing changes and this returns false so Settings can say why. Turning
  /// one off or moving the time never asks. Requires a loaded [profile].
  Future<bool> updateReminders({bool? log, bool? period, bool? appointment, bool? medicine, int? logMinutes}) async {
    final s = profile!.settings;
    final turningOn = (log == true && !s.logReminder) ||
        (period == true && !s.periodReminder) ||
        (appointment == true && !s.appointmentReminder) ||
        (medicine == true && !s.medicineReminder);
    if (turningOn) {
      if (!s.hasNotificationConsent) return false;
      if (!await _reminders.requestPermission()) return false;
    }
    await setSettings(s.copyWith(
      logReminder: log,
      periodReminder: period,
      appointmentReminder: appointment,
      medicineReminder: medicine,
      logReminderMinutes: logMinutes,
    ));
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
      medicineReminder: choice.medicine,
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

  /// Pushes the home-screen widget's two display strings (R9.11): neutral unless she turned
  /// details on. Runs on app start, on every save (so turning the switch off writes the
  /// neutral words back at once) and when the app returns to the front. A failure is
  /// swallowed: the widget is a convenience and must never cost her a saved record.
  Future<void> _syncHomeWidget() async {
    try {
      final p = profile;
      final code = supportedLanguages.contains(p?.locale ?? _locale) ? (p?.locale ?? _locale)! : 'en';
      final l = lookupL10n(Locale(code));
      final content = homeWidgetContent(
        p,
        todayISO(_clock()),
        homeWidgetTexts(l, code),
        showDetails: p?.settings.widgetDetails ?? false,
      );
      if (content == _widgetSent) return;
      await _homeWidget.update(content);
      _widgetSent = content;
    } catch (error) {
      _widgetSent = null;
      debugPrint('The home-screen widget could not be updated: $error');
    }
  }

  /// Deletes her record and the lock from the phone and returns to onboarding.
  /// Settings confirms first; this method does not ask. Pending reminders go too.
  Future<void> deleteEverything() async {
    await documents.clear();
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
    await _syncHomeWidget();
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

  /// Protects the screen from screenshots and the recent-apps picture without a PIN, or
  /// stops doing so (SEC-1). A device choice: it is not part of her record or backups.
  Future<void> setScreenHidden(bool on) async {
    await _lock.hideScreen(on);
    screenHidden = on;
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
      unawaited(_syncHomeWidget());
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

  /// Her record and her documents as one passphrase-sealed file. Requires a loaded [profile].
  /// Throws [BackupTooLargeError] when her documents are over the backup limit.
  Future<Uint8List> exportBackup(String passphrase) async =>
      encodeBackup(profile!, passphrase, documents: await documents.forBackup());

  /// Replaces her record with the one in a backup file. Throws [BackupError]
  /// for a foreign file or a wrong passphrase; the current record is untouched then.
  Future<void> importBackup(List<int> bytes, String passphrase) async {
    final restored = await decodeBackupWithDocuments(bytes, passphrase);
    // The file opened: only now do her current documents give way to the backup's.
    await documents.clear();
    await documents.restore(restored.documents);
    await save(restored.profile);
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
  /// The lock's own navigator, so Help now opens above the lock without unlocking.
  final _lockNavigator = GlobalKey<NavigatorState>();

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

  /// While locked, the system back belongs to the lock: it closes Help now if open, else
  /// sends the app to the background. It never pops the routes hidden under the lock.
  /// (This observer is registered before MaterialApp's, so it is asked first.)
  @override
  Future<bool> didPopRoute() async {
    if (!widget.controller.locked) return false;
    final lock = _lockNavigator.currentState;
    if (lock != null && lock.canPop()) {
      lock.pop();
    } else {
      await SystemNavigator.pop();
    }
    return true;
  }

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
                  // Its own Navigator (and so its own Overlay, which the PIN field needs): the app's
                  // Navigator is beneath us. Help now opens on it, above the lock, without the PIN.
                  // The system back is handled in [didPopRoute]. The app's Navigator owns
                  // MaterialApp's hero controller; a second one may not share it.
                  HeroControllerScope.none(
                    child: Navigator(
                      key: _lockNavigator,
                      onGenerateRoute: (_) => MaterialPageRoute<void>(builder: (_) => LockScreen(controller: controller)),
                    ),
                  ),
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
