/// Carries out a reminder plan on the phone: shows notifications at the planned times.
///
/// Why it exists: the plan itself is a pure function (`domain/reminders.dart`); this file
/// is the only place that touches the notification plugin, so the rest of the app and the
/// tests never need it. Everything stays on the phone: the plugin schedules through
/// Android's alarm manager and makes no network request.
///
/// Notification text is private by design: the title is the wordmark and the body is a
/// plain "Open the app". Nothing names a period, fertility, a window or a date, so a
/// glance at her lock screen reveals nothing. The scheduling is inexact (no exact-alarm
/// permission): a reminder may arrive a few minutes late, never early.
library;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../domain/reminders.dart';

/// The words on a reminder and on its Android channel, already in her language.
class ReminderTexts {
  const ReminderTexts({
    required this.title,
    required this.body,
    required this.channelName,
    required this.channelDescription,
  });
  final String title;
  final String body;
  final String channelName;
  final String channelDescription;

  @override
  bool operator ==(Object other) =>
      other is ReminderTexts &&
      other.title == title &&
      other.body == body &&
      other.channelName == channelName &&
      other.channelDescription == channelDescription;

  @override
  int get hashCode => Object.hash(title, body, channelName, channelDescription);
}

/// What the controller needs from the notification system. Swappable so tests use a
/// recording fake and never the plugin.
abstract interface class ReminderScheduler {
  /// Asks the phone for permission to show notifications (Android 13+ shows a system
  /// prompt; older versions allow them already). True when reminders can be shown.
  Future<bool> requestPermission();

  /// Replaces every pending reminder with [plan]. An empty plan cancels them all.
  Future<void> replaceAll(List<PlannedReminder> plan, ReminderTexts texts);

  /// Cancels every pending reminder and removes any already shown.
  Future<void> cancelAll();
}

/// Does nothing. The default for tests and for platforms without notifications.
class NoReminderScheduler implements ReminderScheduler {
  const NoReminderScheduler();
  @override
  Future<bool> requestPermission() async => false;
  @override
  Future<void> replaceAll(List<PlannedReminder> plan, ReminderTexts texts) async {}
  @override
  Future<void> cancelAll() async {}
}

/// The Android implementation, over `flutter_local_notifications`.
class LocalNotificationScheduler implements ReminderScheduler {
  LocalNotificationScheduler([FlutterLocalNotificationsPlugin? plugin]) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _ready;

  /// The channel id is permanent: Android keeps the user's per-channel choices by id.
  static const _channelId = 'femio_reminders';

  /// Drawable in `android/app/src/main/res/drawable`, kept from shrinking by raw/keep.xml.
  static const _smallIcon = 'ic_stat_femio';

  Future<void> _init() => _ready ??= _plugin
      .initialize(settings: const InitializationSettings(android: AndroidInitializationSettings(_smallIcon)))
      .then((_) {});

  @override
  Future<bool> requestPermission() async {
    await _init();
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return false;
    // Below Android 13 the request is a no-op that returns true.
    return await android.requestNotificationsPermission() ?? false;
  }

  @override
  Future<void> replaceAll(List<PlannedReminder> plan, ReminderTexts texts) async {
    await _init();
    await _plugin.cancelAll();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        texts.channelName,
        channelDescription: texts.channelDescription,
        // Hidden on a secured lock screen as well, on top of the neutral wording.
        visibility: NotificationVisibility.private,
      ),
    );
    for (var i = 0; i < plan.length; i++) {
      await _plugin.zonedSchedule(
        id: i,
        title: texts.title,
        body: texts.body,
        // The planned moment is the phone's own wall clock; expressing it as the same
        // instant in UTC needs no time-zone database and cannot drift across daylight
        // saving, because every reminder is a single future instant (no repeat).
        scheduledDate: tz.TZDateTime.from(plan[i].at, tz.UTC),
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    await _init();
    await _plugin.cancelAll();
  }
}
