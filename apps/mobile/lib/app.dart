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

import 'data/app_lock.dart';
import 'data/backup.dart';
import 'data/key_vault.dart';
import 'data/profile.dart';
import 'data/reminder_scheduler.dart';
import 'data/store.dart';
import 'features/ads/ads_runtime.dart';
import 'features/ads/ads_scope.dart';
import 'features/home/home_shell.dart';
import 'features/lock/lock_screen.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'features/recovery/recovery_screen.dart';
import 'features/recovery/save_failed_banner.dart';
import 'domain/reminders.dart';
import 'features/settings/corrupt_record_screen.dart';
import 'l10n/app_localizations.dart';
import 'theme/femio_theme.dart';

/// The languages Femio speaks, as ISO 639-1 codes. Arabic is first-class, not a
/// translation afterthought (product rule 6).
const supportedLanguages = ['ar', 'en', 'fr', 'es'];

/// What the controller knows about the record on disk. [unavailable] means the record
/// could not be opened right now (Keystore or storage failed) and has been left untouched.
enum RecordState { loading, ready, corrupt, unavailable }

/// How long start-up waits for the notification system before drawing the first frame.
/// Reminders are never worth a blank screen: if the plugin is slow, the app opens anyway.
const reminderStartupTimeout = Duration(seconds: 5);

/// Holds her record, the chosen language and the lock state. One object, listened
/// to by the app, because v1 has a handful of screens and a state library would be weight.
class FemioController extends ChangeNotifier {
  /// [store] is where her record lives; [vault] holds the lock PIN (a memory vault
  /// in tests); [initialLocale] is the language to start in before she has chosen one;
  /// [reminders] shows her reminders (none in tests); [clock] reads "now" for the
  /// reminder plan (fixed in tests).
  FemioController(
    this.store, {
    KeyVault? vault,
    String? initialLocale,
    ReminderScheduler? reminders,
    DateTime Function()? clock,
  }) : _lock = AppLock(vault ?? MemoryKeyVault()),
       _locale = initialLocale,
       _reminders = reminders ?? const NoReminderScheduler(),
       _clock = clock ?? DateTime.now;

  /// Where her record is saved. Swappable, so tests use memory and the app uses a file.
  final FemioStore store;
  final AppLock _lock;
  final ReminderScheduler _reminders;
  final DateTime Function() _clock;

  /// What was last handed to the scheduler, so an unchanged plan is not rescheduled on
  /// every save. Null forces the next sync (app start, after a failure).
  ({List<PlannedReminder> plan, ReminderTexts texts})? _scheduled;

  /// Her record, or null before she finishes onboarding (or after she starts over).
  Profile? profile;

  /// Whether the record loaded, is still loading, or was quarantined.
  RecordState state = RecordState.loading;

  /// Where a quarantined record was moved, for the recovery screen.
  String? quarantinedPath;

  /// True while the lock screen must be shown.
  bool locked = false;

  /// True when a PIN is set.
  bool lockEnabled = false;

  /// True when the last attempt to write her record to the phone failed. The app shows a
  /// calm banner until a save succeeds or she dismisses it; her earlier record is intact.
  bool saveFailed = false;

  /// True while femio Plus is active, which removes every advertisement (ADR-076). The
  /// billing integration (R6.9) will set it from the Play purchase; until Plus can be
  /// bought it stays false and is deliberately not persisted.
  bool plusActive = false;

  /// Convenience for the old call sites: true once [load] has finished.
  bool get loaded => state != RecordState.loading;

  String? _locale;
  DateTime? _backgroundedAt;
  bool _lockChecked = false;

  /// The language she picked, else the phone's if Femio speaks it, else English.
  Locale locale(Locale? device) {
    final code = profile?.locale ?? _locale ?? device?.languageCode;
    return Locale(supportedLanguages.contains(code) ? code! : 'en');
  }

  /// Reads her saved record and the lock state, then tells listeners. Never throws: a
  /// record that cannot be read is quarantined by the store ([RecordState.corrupt]) or
  /// left untouched ([RecordState.unavailable]) and reported, never replaced. Calling it
  /// again is the recovery screen's "try again".
  Future<void> load() async {
    LoadOutcome outcome;
    try {
      lockEnabled = await _lock.isEnabled;
      // She is locked on the first successful read only; a retry from the recovery
      // screen must not lock her out again after she has already entered the PIN.
      if (!_lockChecked) locked = lockEnabled;
      _lockChecked = true;
      outcome = await store.load();
    } catch (error) {
      // The key vault holds the PIN as well as the record key; if it throws, nothing
      // here can be opened. Say so calmly instead of crashing before the first frame.
      debugPrint('The record could not be opened: $error');
      outcome = const Unavailable(UnavailableReason.vault);
    }
    switch (outcome) {
      case Loaded(:final profile):
        this.profile = profile;
        quarantinedPath = null;
        state = RecordState.ready;
      case Empty():
        profile = null;
        quarantinedPath = null;
        state = RecordState.ready;
      case Corrupt(:final quarantinedPath):
        profile = null;
        this.quarantinedPath = quarantinedPath;
        state = RecordState.corrupt;
      case Unavailable():
        profile = null;
        state = RecordState.unavailable;
    }
    // An unopened record leaves her reminders as they are: cancelling them would be a
    // change we cannot justify. The wait is bounded so a stuck plugin cannot hold the app.
    if (state != RecordState.unavailable) {
      await _syncReminders(force: true).timeout(reminderStartupTimeout, onTimeout: () {});
    }
    notifyListeners();
  }

  /// "Start with an empty femio" from the recovery screen: sets the unopened record file
  /// aside (it stays on the phone, renamed) and opens onboarding. Returns false, with
  /// nothing changed, when the file could not be moved. The caller has already asked her.
  Future<bool> startFresh() async {
    try {
      await store.setAside();
    } catch (error) {
      debugPrint('The record file could not be set aside: $error');
      return false;
    }
    profile = null;
    quarantinedPath = null;
    saveFailed = false;
    state = RecordState.ready;
    notifyListeners();
    return true;
  }

  /// Hides the "could not save" banner (it returns if the next save fails too).
  void dismissSaveFailed() {
    saveFailed = false;
    notifyListeners();
  }

  /// Switches the app to [code] at once. Only codes in [supportedLanguages] take
  /// effect; it is saved with the profile the next time the profile is saved.
  void setLanguage(String code) {
    _locale = code;
    if (profile != null) profile = profile!.copyWith(locale: code);
    notifyListeners();
  }

  /// Replaces her record with [p], saves it to the [store] and tells listeners. If the
  /// phone cannot write the file, [saveFailed] is raised (the app shows a banner), the
  /// in-memory record stays so she can keep working, and the error is rethrown.
  Future<void> save(Profile p) async {
    profile = p;
    state = RecordState.ready;
    try {
      await store.save(p);
    } catch (_) {
      saveFailed = true;
      notifyListeners();
      rethrow;
    }
    saveFailed = false;
    await _syncReminders();
    notifyListeners();
  }

  /// Writes one day's log (flow and terms) and saves. [date] is an ISO day. Requires
  /// a loaded [profile].
  Future<void> setDayLog(String date, DayLog log) => save(profile!.withDayLog(date, log));

  /// Puts [date] back exactly as it was in [before], an earlier copy of the record that
  /// the caller kept (Undo after "My period started today"). Other days are untouched.
  Future<void> restoreDay(String date, Profile before) => save(profile!.restoringDay(date, before));

  /// Moves her to [goal] and saves. Product rule 5: a change of stage re-layers the
  /// experience over the SAME record, so logs, periods, readings and appointments are
  /// never touched, only `goal` (and, for pregnancy, the due date).
  ///
  /// Choosing [Goal.pregnant] needs a due date: pass [edd] (ISO day) or have one already
  /// on the record, else this throws [ArgumentError]. A new due date also ends the
  /// after-birth stage (clears `birthDate`), because she is pregnant again. Requires a
  /// loaded [profile].
  Future<void> setGoal(Goal goal, {String? edd}) {
    final current = profile!;
    if (goal != Goal.pregnant) return save(current.copyWith(goal: goal));
    final due = edd ?? current.edd;
    if (due == null) throw ArgumentError('A due date is needed to choose the pregnancy goal.');
    return save(current.copyWith(goal: goal, edd: due, birthDate: edd == null ? current.birthDate : null));
  }

  /// Replaces the due date and saves; nothing else on the record changes. Requires a
  /// loaded [profile].
  Future<void> setDueDate(String edd) => save(profile!.copyWith(edd: edd));

  /// Updates her preferences and saves.
  Future<void> setSettings(AppSettings settings) => save(profile!.copyWith(settings: settings));

  /// Turns reminders on or off, or moves the daily time, then saves and reschedules.
  /// A null argument leaves that setting alone. Turning one ON first asks the phone for
  /// notification permission; when she refuses, nothing changes and this returns false
  /// so Settings can say why. Requires a loaded [profile].
  Future<bool> updateReminders({bool? log, bool? period, int? logMinutes}) async {
    final s = profile!.settings;
    final turningOn = (log == true && !s.logReminder) || (period == true && !s.periodReminder);
    if (turningOn) {
      // A notification system that fails is the same as a refusal: nothing changes.
      try {
        if (!await _reminders.requestPermission()) return false;
      } catch (error) {
        debugPrint('Notification permission could not be requested: $error');
        return false;
      }
    }
    await setSettings(s.copyWith(logReminder: log, periodReminder: period, logReminderMinutes: logMinutes));
    return true;
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
  Future<bool> verifyPin(String pin) async {
    try {
      return await _lock.verify(pin);
    } catch (error) {
      debugPrint('The PIN could not be checked: $error');
      return false;
    }
  }

  /// Removes the PIN; the caller has already verified it.
  Future<void> removePin() async {
    await _lock.clear();
    lockEnabled = false;
    locked = false;
    notifyListeners();
  }

  /// Tries to unlock with [pin]; returns false and stays locked when it is wrong.
  Future<bool> unlock(String pin) async {
    if (!await verifyPin(pin)) return false;
    locked = false;
    notifyListeners();
    return true;
  }

  /// Called by the app on lifecycle changes: the record locks again after
  /// [relockAfter] in the background, and the reminders are topped up on return.
  void onLifecycle(AppLifecycleState lifecycle) {
    // The reminder plan covers a rolling month; each return to the app tops it up.
    if (lifecycle == AppLifecycleState.resumed && profile != null) unawaited(_syncReminders());
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
  /// The restored record is shown only after the phone has written it: if the write
  /// fails the error is rethrown and the state (for example the recovery screen) stays.
  Future<void> importBackup(List<int> bytes, String passphrase) async {
    final restored = await decodeBackup(bytes, passphrase);
    await store.save(restored);
    profile = restored;
    quarantinedPath = null;
    saveFailed = false;
    state = RecordState.ready;
    await _syncReminders();
    notifyListeners();
  }
}

/// The whole app: theme, languages and the choice between the lock screen,
/// onboarding, the recovery screens and the home shell. [controller] is the shared
/// state; [today] fixes the date in tests.
class FemioApp extends StatefulWidget {
  const FemioApp({super.key, required this.controller, this.today, this.adsRuntime = const NoAdsRuntime()});
  final FemioController controller;

  /// Where banners come from. The do-nothing runtime by default, so tests and every
  /// non-Android host never load an ads SDK; main.dart passes the platform's.
  final AdsRuntime adsRuntime;

  /// Fixed "today" for screenshot tests; the real app reads the clock.
  final String? today;

  @override
  State<FemioApp> createState() => _FemioAppState();
}

/// The lock screen on its own small navigator, drawn above the app's navigator.
///
/// Why: the lock must cover every route, but its "Need help now?" button has to open
/// Help now WITHOUT unlocking (MR-38). A route pushed on the app's navigator would sit
/// beneath the lock; pushed on this one it sits above it. The navigator also supplies
/// the Overlay the PIN field needs. Android's back button pops Help now first.
class _LockLayer extends StatefulWidget {
  const _LockLayer({required this.controller});
  final FemioController controller;

  @override
  State<_LockLayer> createState() => _LockLayerState();
}

class _LockLayerState extends State<_LockLayer> {
  final _navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) => NavigatorPopHandler(
    onPopWithResult: (_) => _navigator.currentState?.maybePop(),
    // The app's navigator already owns the HeroController; a second navigator must opt out.
    child: HeroControllerScope.none(
      child: Navigator(
        key: _navigator,
        onGenerateRoute: (_) => MaterialPageRoute<void>(builder: (_) => LockScreen(controller: widget.controller)),
      ),
    ),
  );
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
          builder: (context, child) => AdsScope(
            controller: controller,
            runtime: widget.adsRuntime,
            child: Stack(
              children: [
                // Kept mounted under the lock so she returns exactly where she was;
                // excluded from focus and the accessibility tree while locked.
                ExcludeFocus(
                  excluding: controller.locked,
                  child: ExcludeSemantics(excluding: controller.locked, child: child!),
                ),
                if (controller.saveFailed && !controller.locked)
                  Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: SaveFailedBanner(onDismiss: controller.dismissSaveFailed),
                  ),
                if (controller.locked) _LockLayer(controller: controller),
              ],
            ),
          ),
          home: switch (controller) {
            FemioController(state: RecordState.loading) => const SizedBox.shrink(),
            FemioController(state: RecordState.corrupt) => CorruptRecordScreen(controller: controller),
            FemioController(state: RecordState.unavailable) => RecoveryScreen(controller: controller),
            FemioController(profile: null) => OnboardingFlow(controller: controller, today: widget.today),
            _ => HomeShell(controller: controller, today: widget.today),
          },
        );
      },
    );
  }
}
