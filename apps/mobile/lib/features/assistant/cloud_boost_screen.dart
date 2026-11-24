// The Cloud boost consent screen (ADR-079, ADR-080): the only way Cloud boost is turned on.
//
// Why it exists: on a phone without Gemini Nano, a redacted general question or four coarse
// bands about her may use Google's cloud model. The bands are health information, so the law in
// her market asks for explicit, specific, informed consent that she can withdraw and that femio
// can prove (GDPR Arts. 7 and 9; Washington MHMDA; Saudi PDPL; Egypt Law 151/2020). So this screen:
//   - shows her own band values, the same ones the code would send;
//   - says who receives them, where, for how long, and what is never sent;
//   - asks for each purpose with its own unticked box (no bundling, nothing pre-ticked);
//   - turns on only after "I agree", and stores a dated receipt with the consent-text version;
//   - shows that receipt afterwards, and turns off in one tap, recording the withdrawal.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app.dart';
import '../../domain/assistant/cloud_consent.dart';
import '../../domain/assistant/pseudonymised_profile.dart';
import '../../domain/dates.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import 'answer_card.dart';
import 'assistant_scope.dart';

/// Where the privacy notice lives, per language (the website's legal page).
String privacyNoticeUrl(String lang) => 'https://femioapp.com/$lang/privacy';

/// Shows what Cloud boost may send, asks for consent per purpose, and keeps the receipt.
class CloudBoostScreen extends StatefulWidget {
  const CloudBoostScreen({super.key, required this.controller, this.today, this.now});
  final FemioController controller;

  /// Fixes the date in tests; the app reads the clock.
  final String? today;

  /// Fixes the receipt time in tests (ISO 8601 UTC); the app reads the clock.
  final String Function()? now;

  @override
  State<CloudBoostScreen> createState() => _CloudBoostScreenState();
}

class _CloudBoostScreenState extends State<CloudBoostScreen> {
  // Nothing is pre-ticked: consent is her act, not a default.
  final Set<CloudPurpose> _chosen = {};

  String _now() => widget.now?.call() ?? DateTime.now().toUtc().toIso8601String();

  Future<void> _record(CloudConsent next, {required bool close}) async {
    final settings = widget.controller.profile?.settings;
    if (settings == null) return;
    await widget.controller.setSettings(settings.copyWith(cloud: next));
    if (close && mounted) Navigator.of(context).pop();
  }

  void _toggle(CloudPurpose p, bool? on) => setState(() => on == true ? _chosen.add(p) : _chosen.remove(p));

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) => _build(context),
      );

  Widget _build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final lang = Localizations.localeOf(context).languageCode;
    final profile = widget.controller.profile;
    final consent = profile?.settings.cloud ?? const CloudConsent();
    final on = consent.any;
    final bands = profile == null ? null : pseudonymise(profile, widget.today ?? todayISO());

    return Scaffold(
      appBar: AppBar(title: Text(l.boostTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(space5, space3, space5, space8),
          children: [
            Text(l.boostIntro, style: t.bodyMedium),
            const SizedBox(height: space5),
            if (on) ...[
              NoticeCard(
                tone: NoticeTone.quiet,
                heading: l.boostReceiptHeading,
                body: l.boostReceipt(
                  _formatReceipt(consent.grantedAt!, Localizations.localeOf(context).toString()),
                  [
                    for (final p in CloudPurpose.values)
                      if (consent.allows(p)) _purposeName(l, p),
                  ].join(' · '),
                ),
              ),
              const SizedBox(height: space3),
              OutlinedButton(
                onPressed: () => _record(consent.withdraw(_now()), close: false),
                child: Text(l.boostTurnOff),
              ),
              const SizedBox(height: space2),
              Text(l.boostWithdrawEffect, style: t.bodySmall),
              const SizedBox(height: space5),
            ],
            _Heading(l.boostSendsHeading),
            _PurposeTile(
              value: on ? consent.allows(CloudPurpose.questions) : _chosen.contains(CloudPurpose.questions),
              enabled: !on,
              title: l.boostAgreeQuestions,
              onChanged: (v) => _toggle(CloudPurpose.questions, v),
            ),
            _PurposeTile(
              value: on ? consent.allows(CloudPurpose.tips) : _chosen.contains(CloudPurpose.tips),
              enabled: !on,
              title: l.boostAgreeTips,
              onChanged: (v) => _toggle(CloudPurpose.tips, v),
            ),
            if (bands != null) _BandsTable(bands: bands),
            const SizedBox(height: space5),
            _Heading(l.boostWhoHeading),
            Text(l.boostWho, style: t.bodyMedium),
            const SizedBox(height: space4),
            _Heading(l.boostKeptHeading),
            Text(l.boostKept, style: t.bodyMedium),
            const SizedBox(height: space4),
            _Heading(l.boostNeverHeading),
            PrivacyRow(text: l.boostNever),
            const SizedBox(height: space2),
            Text(l.boostAlsoSeen, style: t.bodySmall),
            const SizedBox(height: space4),
            _Heading(l.boostChoiceHeading),
            Text(l.boostChoice, style: t.bodyMedium),
            const SizedBox(height: space2),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () => AssistantScope.of(context).openSource(privacyNoticeUrl(lang)),
                icon: const Icon(Icons.open_in_new_rounded),
                label: Text(l.boostReadNotice),
              ),
            ),
            if (!on) ...[
              const SizedBox(height: space4),
              Text(l.boostExplicit, style: t.bodySmall),
              const SizedBox(height: space3),
              FilledButton(
                onPressed: profile == null || _chosen.isEmpty
                    ? null
                    : () => _record(consent.grant(Set.of(_chosen), _now()), close: true),
                child: Text(l.boostAgree),
              ),
              const SizedBox(height: space2),
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.boostNotNow)),
            ],
          ],
        ),
      ),
    );
  }

  String _purposeName(L10n l, CloudPurpose p) => switch (p) {
        CloudPurpose.questions => l.boostPurposeQuestions,
        CloudPurpose.tips => l.boostPurposeTips,
      };

  /// The receipt time in her language and her phone's time zone, with Western digits.
  String _formatReceipt(String iso, String locale) {
    final at = DateTime.tryParse(iso)?.toLocal();
    if (at == null) return iso;
    return DateFormat.yMMMd(locale).add_Hm().format(at);
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: space2),
        child: Semantics(header: true, child: Text(text, style: Theme.of(context).textTheme.titleMedium)),
      );
}

/// One purpose with its own box, never ticked for her.
class _PurposeTile extends StatelessWidget {
  const _PurposeTile({required this.value, required this.enabled, required this.title, required this.onChanged});
  final bool value;
  final bool enabled;
  final String title;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) => CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        value: value,
        onChanged: enabled ? onChanged : null,
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
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
        bands.categories.isEmpty ? l.boostNone : bands.categories.map((c) => l.boostCategory(c.name)).join(' · '),
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
