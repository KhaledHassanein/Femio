// The Cloud boost consent screen (ADR-079): the only way Cloud boost is turned on.
//
// Why it exists: on a phone without Gemini Nano, a redacted general question and a few coarse
// bands about her may use Google's cloud model. She must see exactly what that means before
// agreeing, so this screen shows her own [PseudonymisedProfile] values, the same ones the code
// would send, next to what is never sent. Turning it on is her tap here; turning it off is one
// tap here or on the Assistant settings switch.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../domain/assistant/pseudonymised_profile.dart';
import '../../domain/dates.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import 'answer_card.dart';

/// Shows what Cloud boost may send and lets her turn it on or off.
class CloudBoostScreen extends StatelessWidget {
  const CloudBoostScreen({super.key, required this.controller, this.today});
  final FemioController controller;

  /// Fixes the date in tests; the app reads the clock.
  final String? today;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => _build(context),
  );

  Widget _build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final profile = controller.profile;
    final settings = profile?.settings;
    final on = settings?.cloudBoost ?? false;
    final bands = profile == null
        ? null
        : pseudonymise(profile, today ?? todayISO());

    Future<void> set(bool value) async {
      if (settings == null) return;
      await controller.setSettings(settings.copyWith(cloudBoost: value));
      if (value && context.mounted) Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.boostTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(space5, space3, space5, space8),
          children: [
            Text(l.boostIntro, style: t.bodyMedium),
            const SizedBox(height: space5),
            Semantics(
              header: true,
              child: Text(l.boostSendsHeading, style: t.titleMedium),
            ),
            const SizedBox(height: space2),
            _Bullet(text: l.boostSendsQuestion),
            _Bullet(text: l.boostSendsBands),
            if (bands != null) _BandsTable(bands: bands),
            const SizedBox(height: space5),
            Semantics(
              header: true,
              child: Text(l.boostNeverHeading, style: t.titleMedium),
            ),
            const SizedBox(height: space2),
            PrivacyRow(text: l.boostNever),
            const SizedBox(height: space6),
            if (on) ...[
              NoticeCard(
                tone: NoticeTone.quiet,
                heading: l.assistantCloudTitle,
                body: l.assistantCloudOn,
              ),
              const SizedBox(height: space3),
              OutlinedButton(
                onPressed: () => set(false),
                child: Text(l.boostTurnOff),
              ),
            ] else ...[
              FilledButton(
                onPressed: settings == null ? null : () => set(true),
                child: Text(l.boostTurnOn),
              ),
              const SizedBox(height: space2),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.boostNotNow),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: space2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.arrow_right_rounded, color: context.palette.primary),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    ),
  );
}

/// Her own bands, in her language: the same four values [PseudonymisedProfile.features] sends.
class _BandsTable extends StatelessWidget {
  const _BandsTable({required this.bands});
  final PseudonymisedProfile bands;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final rows = [
      (l.boostStageLabel, l.boostStage(bands.stage.name)),
      (l.boostRegularityLabel, l.boostRegularity(bands.regularity.name)),
      (
        l.boostCategoriesLabel,
        bands.categories.isEmpty
            ? l.boostNone
            : bands.categories.map((c) => l.boostCategory(c.name)).join(' · '),
      ),
      (l.boostStreakLabel, l.boostStreak(bands.streak.name)),
    ];
    return Container(
      margin: const EdgeInsetsDirectional.only(start: space5, top: space1),
      padding: const EdgeInsets.all(space3),
      decoration: BoxDecoration(
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (label, value) in rows) ...[
            Text(label, style: t.labelMedium?.copyWith(color: p.textMuted)),
            Text(value, style: t.bodyMedium),
            const SizedBox(height: space2),
          ],
        ],
      ),
    );
  }
}
