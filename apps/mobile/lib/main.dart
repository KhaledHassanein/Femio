import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'app.dart';
import 'data/store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureFormatting();
  final controller = FemioController(FileStore());
  await controller.load();
  runApp(FemioApp(controller: controller));
}

/// Arabic uses the same digits as English (ADR-069, owner direction). intl defaults
/// Arabic to Arabic-Indic digits, so it is pinned here rather than left to a default.
void configureFormatting() => DateFormat.useNativeDigitsByDefaultFor('ar', false);
