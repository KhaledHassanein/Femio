// Settings > Assistant: what the AI can do on this phone, and how her data is handled (ADR-078).
//
// Why it exists: on-device AI depends on the phone (Gemini Nano through Android AICore), and the
// cloud search depends on the build. She should see both plainly, download Nano when her phone
// offers it, and read in one paragraph what stays on the phone and what may leave it.

import 'package:flutter/material.dart';

import '../../data/assistant_channel.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import 'assistant_scope.dart';

/// The assistant's status page.
class AssistantSettingsScreen extends StatefulWidget {
  const AssistantSettingsScreen({super.key});

  @override
  State<AssistantSettingsScreen> createState() => _AssistantSettingsScreenState();
}

class _AssistantSettingsScreenState extends State<AssistantSettingsScreen> {
  AssistantStatus? _status;
  bool _downloading = false;

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
              padding: const EdgeInsets.fromLTRB(space5, space3, space5, space8),
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.phone_android_rounded, color: p.primary),
                  title: Text(l.assistantOnDeviceTitle),
                  subtitle: Text(switch (onDevice!) {
                    OnDeviceModel.available => l.assistantOnDeviceAvailable,
                    OnDeviceModel.downloadable => l.assistantOnDeviceDownloadable,
                    OnDeviceModel.downloading => l.assistantOnDeviceDownloading,
                    OnDeviceModel.unavailable => l.assistantOnDeviceUnavailable,
                  }),
                  trailing: onDevice == OnDeviceModel.downloadable
                      ? FilledButton(onPressed: _download, child: Text(l.assistantDownload))
                      : null,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.travel_explore_rounded, color: p.primary),
                  title: Text(l.assistantCloudTitle),
                  subtitle: Text(s.canAskCloud ? l.assistantCloudOn : l.assistantCloudOff),
                ),
                const SizedBox(height: space4),
                Text(l.assistantHowItWorks, style: t.bodyMedium),
              ],
            ),
    );
  }
}
