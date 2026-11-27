/// The one door between femio and the phone's notification system.
///
/// Why it exists: the app asks for permission, schedules and cancels through this
/// interface only, so the controller and the tests never touch a plugin, and the way
/// notifications are delivered can change without the app logic changing. Today there is
/// one implementation: `LocalNotificationScheduler` (`reminder_scheduler.dart`), which
/// schedules on the phone through Android's alarm manager.
///
/// Remote push (Firebase Cloud Messaging) is deliberately NOT built. Push needs a device
/// token to be sent to a server so the server can address this phone, and ADR-080 says
/// nothing leaves the phone except what the privacy notice lists, with no network code of
/// the app's own. A push channel would need a future ADR first (what token, who holds it,
/// what the notice says, how she revokes it). Until then this seam is the only place such a
/// change would land, and no push dependency is in `pubspec.yaml`.
library;

import '../domain/reminders.dart';

/// The words on a notification and on its Android channel, already in her language.
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

/// What the app needs from a notification system. Swappable: tests use a recording fake.
abstract interface class NotificationPort {
  /// Asks the phone for permission to show notifications (Android 13+ shows a system
  /// prompt; older versions allow them already). True when notifications can be shown;
  /// false when she refused or the platform has none.
  Future<bool> requestPermission();

  /// Opens the phone's notification settings for femio, where she can allow them again
  /// after refusing (Android shows no second prompt, and none at all before Android 13).
  Future<void> openSettings();

  /// Replaces every pending notification with [plan]. An empty plan cancels them all.
  Future<void> replaceAll(List<PlannedReminder> plan, ReminderTexts texts);

  /// Cancels every pending notification and removes any already shown.
  Future<void> cancelAll();
}

/// Does nothing. The default for tests and for platforms without notifications.
class NoNotificationPort implements NotificationPort {
  const NoNotificationPort();
  @override
  Future<bool> requestPermission() async => false;
  @override
  Future<void> openSettings() async {}
  @override
  Future<void> replaceAll(
    List<PlannedReminder> plan,
    ReminderTexts texts,
  ) async {}
  @override
  Future<void> cancelAll() async {}
}
