// "How femio's AI runs", in one line: the hybrid split made visible where she lands.
//
// Why it exists: the owner found the AI not prominent enough for an app built on hybrid AI
// (2026-11-26), and the audit found nothing on Today's first screen said whether the AI
// runs on the phone or in the cloud (R14.6, UX-2). This chip reads the bridge's status and
// her two switches and states it honestly: Gemini Nano on this phone, femio's rules when
// the phone has no Nano, AI off, and Cloud boost only when she switched it on. Read-only:
// tapping opens the assistant settings. It never calls the model (product rule 7).

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/assistant_channel.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import 'assistant_scope.dart';
import 'assistant_settings_screen.dart';

/// Where the AI runs right now, as the chip says it.
enum AiRunState { nano, rules, off }

/// The state the chip shows for [status] and her master switch [assistantOn].
AiRunState aiRunState(AssistantStatus status, {required bool assistantOn}) {
  if (!assistantOn) return AiRunState.off;
  return status.canRunPrivate ? AiRunState.nano : AiRunState.rules;
}

/// The chip's words: the state, plus "Cloud boost on" when [cloudBoost] and the AI is on.
String aiChipText(L10n l, AiRunState state, {required bool cloudBoost}) {
  final base = switch (state) {
    AiRunState.nano => l.aiChipNano,
    AiRunState.rules => l.aiChipRules,
    AiRunState.off => l.aiChipOff,
  };
  return cloudBoost && state != AiRunState.off ? '$base · ${l.aiChipCloud}' : base;
}

/// A small tappable chip with [aiChipText]; opens Settings → Assistant.
class AiStatusChip extends StatefulWidget {
  const AiStatusChip({super.key, required this.controller});
  final FemioController controller;

  @override
  State<AiStatusChip> createState() => _AiStatusChipState();
}

class _AiStatusChipState extends State<AiStatusChip> {
  AssistantStatus? _status;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refresh();
  }

  Future<void> _refresh() async {
    final s = await AssistantScope.of(context).status();
    if (mounted) setState(() => _status = s);
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final settings = widget.controller.profile?.settings;
    final state = aiRunState(_status ?? AssistantStatus.offline, assistantOn: settings?.assistantOn ?? true);
    final text = aiChipText(l, state, cloudBoost: settings?.cloudBoost ?? false);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Semantics(
        button: true,
        hint: l.aiChipHint,
        child: Material(
          color: state == AiRunState.off ? p.surfaceSunken : p.primarySoft,
          borderRadius: BorderRadius.circular(radiusPill),
          child: InkWell(
            borderRadius: BorderRadius.circular(radiusPill),
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => AssistantSettingsScreen(controller: widget.controller),
              ));
              if (mounted) await _refresh();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: space3, vertical: space1h),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                  state == AiRunState.off ? Icons.auto_awesome_outlined : Icons.auto_awesome_rounded,
                  size: 16,
                  color: state == AiRunState.off ? p.textMuted : p.primarySoftText,
                ),
                const SizedBox(width: space1h),
                Flexible(
                  child: Text(
                    text,
                    style: t.labelMedium?.copyWith(
                      color: state == AiRunState.off ? p.textMuted : p.primarySoftText,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// The one-line "say it" entry: tap to tell femio about the day in her own words. The
/// same bar opens the "+" sheet; on Today it sits above the fold (R14.6, proposal 5).
class SayItBar extends StatelessWidget {
  const SayItBar({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Material(
      color: p.surfaceSunken,
      borderRadius: BorderRadius.circular(radiusPill),
      child: InkWell(
        borderRadius: BorderRadius.circular(radiusPill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: space4, vertical: space3),
          child: Row(children: [
            Icon(Icons.auto_awesome_rounded, color: p.primary),
            const SizedBox(width: space3),
            Expanded(child: Text(l.addSayItPrompt, style: t.bodyMedium?.copyWith(color: p.textMuted))),
            Icon(Icons.mic_none_rounded, color: p.primary),
          ]),
        ),
      ),
    );
  }
}
