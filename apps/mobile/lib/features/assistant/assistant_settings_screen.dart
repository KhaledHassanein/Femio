// Settings > Assistant: what the AI can do on this phone, and how her data is handled (ADR-078).
//
// Why it exists: on-device AI depends on the phone (Gemini Nano through Android AICore), and
// Cloud boost (ADR-079) depends on the build and on her choice. She should see both plainly,
// download Nano when her phone offers it, and change the AI or Cloud boost only through the one
// wizard (owner 2026-11-27), which keeps a sealed receipt of every choice. While Cloud boost is
// on she can check it really reaches Google and, if not, read why (the reason comes from the
// native call). She reads in one paragraph what stays on the phone and what may leave it.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/assistant_channel.dart';
import '../../domain/assistant/cloud_consent.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import 'ai_choices_record_screen.dart';
import 'ai_choices_wizard.dart';
import 'ai_ledger_screen.dart';
import 'ai_sees_screen.dart';
import 'assistant_scope.dart';
import 'translation_tile.dart';

/// The assistant's status page.
class AssistantSettingsScreen extends StatefulWidget {
  const AssistantSettingsScreen({super.key, required this.controller});
  final FemioController controller;

  @override
  State<AssistantSettingsScreen> createState() =>
      _AssistantSettingsScreenState();
}

class _AssistantSettingsScreenState extends State<AssistantSettingsScreen> {
  AssistantStatus? _status;
  bool _downloading = false;
  bool _checking = false;
  CloudCheck? _check;

  Future<void> _runCheck(CloudConsent consent) async {
    setState(() {
      _checking = true;
      _check = null;
    });
    final result = await AssistantScope.gatewayOf(context).checkCloud(consent);
    if (!mounted) return;
    setState(() {
      _checking = false;
      _check = result;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_status == null) _refresh();
  }

  Future<void> _refresh() async {
    final s = await AssistantScope.of(context).status();
    if (mounted) setState(() => _status = s);
  }

  Future<void> _download() async {
    setState(() => _downloading = true);
    await AssistantScope.of(context).downloadModel();
    if (!mounted) return;
    setState(() => _downloading = false);
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final s = _status;
    final onDevice = _downloading ? OnDeviceModel.downloading : s?.onDevice;

    return Scaffold(
      appBar: AppBar(title: Text(l.assistantSettingsTitle)),
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                space5,
                space3,
                space5,
                space8,
              ),
              children: [
                ListenableBuilder(
                  listenable: widget.controller,
                  builder: (context, _) {
                    final settings = widget.controller.profile?.settings;
                    final consent = settings?.cloud ?? const CloudConsent();
                    final mode = currentAiMode(assistantOn: settings?.assistantOn ?? true, cloud: consent);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.auto_awesome_rounded, color: p.primary),
                      title: Text(l.aiChoicesTitle),
                      subtitle: Text(switch (mode) {
                        AiMode.off => l.aiChoicesSubOff,
                        AiMode.phone => l.aiChoicesSubPhone,
                        AiMode.cloud => l.aiChoicesSubCloud(
                            purposeNames(l, [for (final c in CloudPurpose.values) if (consent.allows(c)) c])),
                      }),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: settings == null ? null : () => openAiChoicesWizard(context, widget.controller),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.phone_android_rounded, color: p.primary),
                  title: Text(l.assistantOnDeviceTitle),
                  subtitle: Text(switch (onDevice!) {
                    OnDeviceModel.available => l.assistantOnDeviceAvailable,
                    OnDeviceModel.downloadable =>
                      l.assistantOnDeviceDownloadable,
                    OnDeviceModel.downloading => l.assistantOnDeviceDownloading,
                    OnDeviceModel.unavailable => l.assistantOnDeviceUnavailable,
                  }),
                  trailing: onDevice == OnDeviceModel.downloadable
                      ? FilledButton(
                          onPressed: _download,
                          child: Text(l.assistantDownload),
                        )
                      : null,
                ),
                // Owner 2026-11-28: a phone without Gemini Nano is offered Cloud boost here, one tap
                // from the AI choices, unless it is already on.
                if (onDevice == OnDeviceModel.unavailable &&
                    !(widget.controller.profile?.settings.cloud.allows(CloudPurpose.questions) ?? false))
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: OutlinedButton.icon(
                      onPressed: () => openAiChoicesWizard(context, widget.controller, start: AiMode.cloud),
                      icon: const Icon(Icons.cloud_outlined),
                      label: Text(l.assistantUseBoost),
                    ),
                  ),
                TranslationTile(nanoPossible: onDevice != OnDeviceModel.unavailable),
                ListenableBuilder(
                  listenable: widget.controller,
                  builder: (context, _) {
                    final settings = widget.controller.profile?.settings;
                    final consent = settings?.cloud ?? const CloudConsent();
                    final on = settings?.cloudBoost ?? false;
                    final check = _check;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.cloud_outlined, color: p.primary),
                          title: Text(l.assistantCloudTitle),
                          subtitle: Text(
                            !s.canRunHybrid ? l.assistantCloudNotBuilt : (on ? l.assistantCloudOn : l.assistantCloudOff),
                          ),
                        ),
                        // The check exists only on the real Android bridge, and only while
                        // Cloud boost for questions is on (it sends one fixed sentence).
                        if (on &&
                            consent.allows(CloudPurpose.questions) &&
                            AssistantScope.of(context) is CloudChecker) ...[
                          Text(l.cloudCheckNote, style: t.bodySmall),
                          const SizedBox(height: space2),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: OutlinedButton.icon(
                              onPressed: _checking ? null : () => _runCheck(consent),
                              icon: const Icon(Icons.network_check_rounded),
                              label: Text(_checking ? l.cloudCheckRunning : l.cloudCheckButton),
                            ),
                          ),
                          if (check != null) ...[
                            const SizedBox(height: space2),
                            Text(
                              check.ok
                                  ? l.cloudCheckOk(((check.ms ?? 0) / 1000).toStringAsFixed(1))
                                  : l.cloudCheckFailed(check.reason ?? 'other'),
                              style: t.bodyMedium?.copyWith(color: check.ok ? p.primary : p.dangerText),
                            ),
                            if (!check.ok)
                              Text(l.cloudCheckCode(check.reason ?? 'other'), style: t.labelSmall?.copyWith(color: p.textMuted)),
                          ],
                          const SizedBox(height: space2),
                        ],
                      ],
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.verified_outlined, color: p.primary),
                  title: Text(l.aiRecordTitle),
                  subtitle: Text(l.aiRecordSub),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => AiChoicesRecordScreen(controller: widget.controller),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.visibility_outlined, color: p.primary),
                  title: Text(l.aiSeesTitle),
                  subtitle: Text(l.aiSeesSub),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => AiSeesScreen(controller: widget.controller),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.receipt_long_outlined, color: p.primary),
                  title: Text(l.aiLedgerTitle),
                  subtitle: Text(l.aiLedgerSub),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => AiLedgerScreen(controller: widget.controller),
                    ),
                  ),
                ),
                const SizedBox(height: space4),
                Text(l.assistantHowItWorks, style: t.bodyMedium),
              ],
            ),
    );
  }
}
