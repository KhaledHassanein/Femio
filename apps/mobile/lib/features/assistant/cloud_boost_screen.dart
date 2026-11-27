// The Cloud boost screen: the one AI wizard, opened at "AI on this phone, plus Cloud boost".
//
// Why it exists: Cloud boost used to have its own consent screen. Since 2026-11-27 every AI
// and Cloud boost change goes through [AiChoicesWizard] (owner), which keeps a sealed receipt.
// This name stays so older entry points and screenshot tests keep working; it adds nothing.

import 'package:flutter/material.dart';

import '../../app.dart';
import 'ai_choices_wizard.dart';

export 'ai_choices_wizard.dart' show privacyNoticeUrl;

/// [AiChoicesWizard] starting at Cloud boost.
class CloudBoostScreen extends StatelessWidget {
  const CloudBoostScreen({super.key, required this.controller, this.today, this.now});
  final FemioController controller;

  /// Fixes the date in tests; the app reads the clock.
  final String? today;

  /// Fixes the receipt time in tests (ISO 8601 UTC); the app reads the clock.
  final String Function()? now;

  @override
  Widget build(BuildContext context) =>
      AiChoicesWizard(controller: controller, start: AiMode.cloud, today: today, now: now);
}
