// Program entry point.
//
// Why it exists: Flutter needs one place that loads her saved record before the first
// frame, so the app never flashes the onboarding screen at a woman who already has data.
// The record is sealed with a key in the Android Keystore; the PIN hash lives beside it.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'app.dart';
import 'data/key_vault.dart';
import 'data/store.dart';

/// Starts the app: loads her record from the phone first, then draws the first frame.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureFormatting();
  final vault = SecureKeyVault();
  final controller = FemioController(EncryptedFileStore(vault: vault), vault: vault);
  await controller.load();
  runApp(FemioApp(controller: controller));
}

/// Arabic uses the same digits as English (ADR-069, owner direction). intl defaults
/// Arabic to Arabic-Indic digits, so it is pinned here rather than left to a default.
void configureFormatting() => DateFormat.useNativeDigitsByDefaultFor('ar', false);
