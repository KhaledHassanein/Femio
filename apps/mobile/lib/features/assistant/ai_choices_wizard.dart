// The one wizard for femio's AI and Cloud boost (owner 2026-11-27; ADR-080 amendment).
//
// Why it exists: the AI on this phone and Cloud boost used to be two switches, and only
// Cloud boost asked for consent. The owner asked for one path for both, on and off: choose,
// read what it means, tick the required statements, confirm in a dialog, and keep a dated,
// sealed receipt she (or anyone she shows it to) can check later. So:
//   1. Choose: no AI, AI on this phone only, or AI on this phone plus Cloud boost.
//   2. Read: what that choice means; for Cloud boost, her own four bands, who receives what,
//      where, for how long, what is never sent, and the privacy notice.
//   3. Confirm: unticked statements (wellness not diagnosis, notice read, and for Cloud boost
//      each purpose on its own plus "I understand"); turning AI off needs no box, because
//      withdrawing must be as easy as agreeing (GDPR Art. 7(3)).
// Then a confirmation dialog, and one receipt in [CloudConsent] via [CloudConsent.choose].

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/assistant_channel.dart';
import '../../domain/assistant/cloud_consent.dart';
import '../../domain/assistant/pseudonymised_profile.dart';
import '../../domain/dates.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import 'answer_card.dart';
import 'assistant_scope.dart';

/// Where the privacy notice lives, per language (the website's legal page).
String privacyNoticeUrl(String lang) => 'https://femioapp.com/$lang/privacy';

/// The three choices the wizard offers.
enum AiMode { off, phone, cloud }

/// Her current mode, read from her settings.
AiMode currentAiMode({required bool assistantOn, required CloudConsent cloud}) =>
    !assistantOn ? AiMode.off : (cloud.any ? AiMode.cloud : AiMode.phone);

/// The purposes in force, named in her language and joined with " · ".
String purposeNames(L10n l, Iterable<CloudPurpose> purposes) => [
      for (final p in CloudPurpose.values)
        if (purposes.contains(p))
          switch (p) {
            CloudPurpose.questions => l.boostPurposeQuestions,
            CloudPurpose.tips => l.boostPurposeTips,
          },
    ].join(' · ');

/// Opens the wizard. [start] preselects a mode (for example Cloud boost from the first-use
/// sheet); she can still change it. Returns true when a choice was saved.
Future<bool> openAiChoicesWizard(BuildContext context, FemioController controller, {AiMode? start}) async {
  // A "saved" message from a previous change would sit over the wizard's buttons.
  ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
  final saved = await Navigator.of(context).push<bool>(
    MaterialPageRoute(builder: (_) => AiChoicesWizard(controller: controller, start: start)),
  );
  return saved ?? false;
}

/// Choose, read, confirm; then one sealed receipt.
class AiChoicesWizard extends StatefulWidget {
  const AiChoicesWizard({super.key, required this.controller, this.start, this.today, this.now});
  final FemioController controller;
  final AiMode? start;

  /// Fixes the date in tests; the app reads the clock.
  final String? today;

  /// Fixes the receipt time in tests (ISO 8601 UTC); the app reads the clock.
  final String Function()? now;

  @override
  State<AiChoicesWizard> createState() => _AiChoicesWizardState();
}

class _AiChoicesWizardState extends State<AiChoicesWizard> {
  int _step = 0;
  late AiMode _mode;

  /// The mode she has now: stepping down from it is a withdrawal and asks for no ticks.
  late final AiMode _from;
  AssistantStatus? _status;

  // Nothing is pre-ticked: every statement and purpose is her act, not a default.
  final Set<CloudPurpose> _purposes = {};
  final Set<String> _acks = {};

  @override
  void initState() {
    super.initState();
    final s = widget.controller.profile?.settings;
    _from = currentAiMode(assistantOn: s?.assistantOn ?? true, cloud: s?.cloud ?? const CloudConsent());
    _mode = widget.start ?? _from;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_status == null) {
      AssistantScope.of(context).status().then((s) {
        if (mounted) setState(() => _status = s);
      });
    }
  }

  bool get _cloudBuilt => _status?.canRunHybrid ?? false;

  /// The statements this mode needs ticked before she can confirm. Using less of the AI
  /// (off, or on-phone after Cloud boost) needs none: withdrawing is as easy as agreeing
  /// (GDPR Art. 7(3), ADR-085). Cloud boost always asks, since its purposes may change.
  List<String> get _requiredAcks => switch (_mode) {
        AiMode.off => const [],
        AiMode.phone => _from == AiMode.off ? const [AiAck.wellness, AiAck.notice] : const [],
        AiMode.cloud => const [AiAck.wellness, AiAck.notice, AiAck.cloud],
      };

  bool get _ready =>
      _requiredAcks.every(_acks.contains) && (_mode != AiMode.cloud || (_purposes.isNotEmpty && _cloudBuilt));

  String _now() => widget.now?.call() ?? DateTime.now().toUtc().toIso8601String();

  Future<void> _confirm() async {
    final l = L10n.of(context);
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.aiConfirmDialogTitle),
        content: Text(l.aiConfirmDialogBody(_mode.name, purposeNames(l, _purposes))),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l.aiConfirmDialogNo)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l.aiConfirmDialogYes)),
        ],
      ),
    );
    if (sure != true || !mounted) return;
    final settings = widget.controller.profile?.settings;
    if (settings == null) return;
    final lang = Localizations.localeOf(context).languageCode;
    final acks = [for (final a in _requiredAcks) if (_acks.contains(a)) a];
    final next = settings.cloud.choose(
      ai: _mode != AiMode.off,
      purposes: _mode == AiMode.cloud ? Set.of(_purposes) : const {},
      at: _now(),
      lang: lang,
      acks: acks,
    );
    await widget.controller.setSettings(settings.copyWith(assistantOn: _mode != AiMode.off, cloud: next));
    if (!mounted) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(l.aiChoiceSaved)));
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final p = context.palette;
    final pages = [_choose, _read, _confirmPage];
    return Scaffold(
      appBar: AppBar(title: Text(l.aiChoicesTitle)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(space5, space2, space5, space2),
              child: Text(l.aiWizardStep(_step + 1), style: t.labelMedium?.copyWith(color: p.textMuted)),
            ),
            Expanded(
              // Clipped so text scrolled up never draws over the step label.
              child: ClipRect(
                child: ListView(
                  key: ValueKey(_step),
                  padding: const EdgeInsets.fromLTRB(space5, space3, space5, space5),
                  children: pages[_step](context),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(space5, 0, space5, space4),
              child: Row(
                children: [
                  if (_step > 0) ...[
                    TextButton(onPressed: () => setState(() => _step -= 1), child: Text(l.aiWizardBack)),
                    const SizedBox(width: space3),
                  ],
                  // The theme's filled buttons are full width, so the primary one takes the rest.
                  Expanded(
                    child: _step < 2
                        ? FilledButton(
                            onPressed: _mode == AiMode.cloud && !_cloudBuilt ? null : () => setState(() => _step += 1),
                            child: Text(l.aiWizardNext),
                          )
                        : FilledButton(onPressed: _ready ? _confirm : null, child: Text(l.aiWizardSave)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _choose(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    Widget option(AiMode mode, String title, String sub, {bool enabled = true}) => RadioListTile<AiMode>(
          contentPadding: EdgeInsets.zero,
          value: mode,
          enabled: enabled,
          title: Text(title),
          subtitle: Text(sub),
        );
    return [
      Text(l.aiWizardChooseHeading, style: t.titleLarge),
      const SizedBox(height: space3),
      RadioGroup<AiMode>(
        groupValue: _mode,
        onChanged: (m) {
          if (m != null) setState(() => _mode = m);
        },
        child: Column(
          children: [
            option(AiMode.off, l.aiModeOff, l.aiModeOffSub),
            option(AiMode.phone, l.aiModePhone, l.aiModePhoneSub),
            option(
              AiMode.cloud,
              l.aiModeCloud,
              _status == null || _cloudBuilt ? l.aiModeCloudSub : l.assistantCloudNotBuilt,
              enabled: _status == null || _cloudBuilt,
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _read(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final lang = Localizations.localeOf(context).languageCode;
    final profile = widget.controller.profile;
    final bands = profile == null ? null : pseudonymise(profile, widget.today ?? todayISO());
    return [
      Text(l.aiWizardReadHeading, style: t.titleLarge),
      const SizedBox(height: space3),
      if (_mode == AiMode.off) Text(l.aiWizardOffBody, style: t.bodyMedium),
      if (_mode != AiMode.off) Text(l.aiWizardPhoneBody, style: t.bodyMedium),
      if (_mode == AiMode.cloud) ...[
        const SizedBox(height: space5),
        Text(l.boostIntro, style: t.bodyMedium),
        const SizedBox(height: space4),
        _Heading(l.boostSendsHeading),
        Text(l.boostAgreeQuestions, style: t.bodyMedium),
        const SizedBox(height: space2),
        Text(l.boostAgreeTips, style: t.bodyMedium),
        if (bands != null) _BandsTable(bands: bands),
        const SizedBox(height: space4),
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
      ],
      const SizedBox(height: space3),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          onPressed: () => AssistantScope.of(context).openSource(privacyNoticeUrl(lang)),
          icon: const Icon(Icons.open_in_new_rounded),
          label: Text(l.boostReadNotice),
        ),
      ),
    ];
  }

  List<Widget> _confirmPage(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final lang = Localizations.localeOf(context).languageCode;
    Widget box(bool value, String text, ValueChanged<bool> onChanged) => CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: value,
          onChanged: (v) => setState(() => onChanged(v ?? false)),
          title: Text(text, style: t.bodyMedium),
        );
    void ack(String id, bool on) => on ? _acks.add(id) : _acks.remove(id);
    void purpose(CloudPurpose p, bool on) => on ? _purposes.add(p) : _purposes.remove(p);
    return [
      Text(l.aiWizardConfirmHeading, style: t.titleLarge),
      const SizedBox(height: space3),
      if (_mode == AiMode.off) Text(l.aiWizardOffConfirm, style: t.bodyMedium),
      if (_mode == AiMode.phone && _requiredAcks.isEmpty) Text(l.aiWizardLessConfirm, style: t.bodyMedium),
      if (_requiredAcks.isNotEmpty) ...[
        box(_acks.contains(AiAck.wellness), l.aiAckWellness, (v) => ack(AiAck.wellness, v)),
        box(_acks.contains(AiAck.notice), l.aiAckNotice, (v) => ack(AiAck.notice, v)),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => AssistantScope.of(context).openSource(privacyNoticeUrl(lang)),
            icon: const Icon(Icons.open_in_new_rounded),
            label: Text(l.boostReadNotice),
          ),
        ),
      ],
      if (_mode == AiMode.cloud) ...[
        const SizedBox(height: space3),
        _Heading(l.boostSendsHeading),
        box(_purposes.contains(CloudPurpose.questions), l.boostAgreeQuestions, (v) => purpose(CloudPurpose.questions, v)),
        box(_purposes.contains(CloudPurpose.tips), l.boostAgreeTips, (v) => purpose(CloudPurpose.tips, v)),
        box(_acks.contains(AiAck.cloud), l.aiAckCloud, (v) => ack(AiAck.cloud, v)),
        const SizedBox(height: space2),
        Text(l.boostExplicit, style: t.bodySmall),
      ],
    ];
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
      margin: const EdgeInsetsDirectional.only(top: space2),
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
