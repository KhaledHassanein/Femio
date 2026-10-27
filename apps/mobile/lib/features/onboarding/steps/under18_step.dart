// The notice shown when the birth year says she is under 18.
//
// Why it exists: Femio's v1 audience is adults; a kind explanation with a way back is
// better than a silent dead end. It does not store anything.

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets.dart';

/// The under-18 notice. [onBack] returns to the birth-year question (both the arrow
/// and the button do the same). It has no failure cases.
class Under18Step extends StatelessWidget {
  const Under18Step({super.key, required this.progress, required this.onBack});
  final double progress;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return StepScaffold(
      progress: progress,
      title: l.under18Title,
      onBack: onBack,
      primaryLabel: l.back,
      onPrimary: onBack,
      child: Text(l.under18Body, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
