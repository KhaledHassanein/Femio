// Program entry point.
//
// Why it exists: Flutter needs one place that loads her saved record before the first
// frame, so the app never flashes the onboarding screen at a woman who already has data.
// The record is sealed with a key in the Android Keystore; the PIN hash lives beside it.

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;
import 'package:intl/intl.dart' show DateFormat;

import 'app.dart';
import 'data/ai_ledger_store.dart';
import 'data/assistant_channel.dart';
import 'data/translate_channel.dart';
import 'data/attachment_store.dart';
import 'data/home_widget_bridge.dart';
import 'data/key_vault.dart';
import 'data/play_store.dart';
import 'data/reminder_scheduler.dart';
import 'data/store.dart';

/// Starts the app: loads her record from the phone first, then draws the first frame.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureFormatting();
  // Month names for the home-screen widget's text, which is built before the first frame.
  // The data is bundled with intl; nothing is fetched.
  await initializeDateFormatting();
  final vault = SecureKeyVault();
  final controller = FemioController(EncryptedFileStore(vault: vault), vault: vault, reminders: LocalNotificationScheduler(), playStore: const GooglePlayStore(), ledger: EncryptedLedgerStore(vault: vault), homeWidget: const MethodChannelHomeWidget(), files: EncryptedAttachmentStore(vault: vault));
  await controller.load();
  runApp(FemioApp(
    controller: controller,
    assistant: const MethodChannelAssistant(),
    translator: const MethodChannelTranslator(),
  ));
}

/// Arabic uses the same digits as English (ADR-069, owner direction). intl defaults
/// Arabic to Arabic-Indic digits, so it is pinned here rather than left to a default.
void configureFormatting() => DateFormat.useNativeDigitsByDefaultFor('ar', false);
