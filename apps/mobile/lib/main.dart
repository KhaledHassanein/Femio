// Program entry point.
//
// Why it exists: Flutter needs one place that loads her saved record before the first
// frame, so the app never flashes the onboarding screen at a woman who already has data.
// The record is sealed with a key in the Android Keystore; the PIN hash lives beside it.
//
// Start-up must never crash or leave a white screen: a release build has no debugger and
// she cannot report a stack trace. So every part that touches the phone (Keystore, record
// file, notifications, ads) is wrapped; a failure becomes a calm screen (see
// features/recovery) or a feature that quietly does not start, never an exception here.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'app.dart';
import 'data/key_vault.dart';
import 'data/reminder_scheduler.dart';
import 'data/store.dart';
import 'features/ads/ads_runtime.dart';

/// Starts the app: loads her record from the phone first, then draws the first frame.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  installErrorGuards();
  configureFormatting();
  runApp(await buildFemioApp());
}

/// Builds the app root with its parts and loads her record. Never throws.
///
/// Every argument is for tests; the app passes none. [vault] and [store] default to the
/// Keystore and the sealed file, [reminders] to the notification plugin and [adsRuntime]
/// to Google's ads on Android. A part that cannot even be created is replaced by its
/// do-nothing version, so the worst case is an app without reminders or ads.
Future<FemioApp> buildFemioApp({
  KeyVault? vault,
  FemioStore? store,
  ReminderScheduler? reminders,
  AdsRuntime Function()? adsRuntime,
}) async {
  final keyVault = vault ?? SecureKeyVault();
  final controller = FemioController(
    store ?? EncryptedFileStore(vault: keyVault),
    vault: keyVault,
    reminders: reminders ?? _orElse<ReminderScheduler>(LocalNotificationScheduler.new, const NoReminderScheduler()),
  );
  await controller.load();
  return FemioApp(
    controller: controller,
    adsRuntime: _orElse<AdsRuntime>(adsRuntime ?? platformAdsRuntime, const NoAdsRuntime()),
  );
}

/// Runs [make]; if it throws, returns [fallback] instead.
T _orElse<T>(T Function() make, T fallback) {
  try {
    return make();
  } catch (error) {
    debugPrint('A start-up part could not be created: $error');
    return fallback;
  }
}

/// Keeps a stray asynchronous error (a plugin call nobody awaited, a failed save from a
/// button) from ending the app. Flutter's own error reporting stays on.
void installErrorGuards() {
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Uncaught error: $error');
    return true;
  };
}

/// Arabic uses the same digits as English (ADR-069, owner direction). intl defaults
/// Arabic to Arabic-Indic digits, so it is pinned here rather than left to a default.
void configureFormatting() => DateFormat.useNativeDigitsByDefaultFor('ar', false);
