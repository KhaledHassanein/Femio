// The mic on Ask femio and Say it: tap, speak, and the words land in the text field
// (owner 2026-11-27, ADR-086).
//
// Why it exists: speaking is quicker than typing a symptom or a question. The words come from
// Android's on-device recognizer through [SpeechPort]; nothing is recorded or sent. When the
// phone cannot do it, she is told why in one line, and when the microphone is refused for
// good, the line carries an "Open settings" button, since Android will not ask again.

import 'package:flutter/material.dart';

import '../../data/speech_channel.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';

/// A mic icon button that fills [controller] with what she says.
class MicButton extends StatefulWidget {
  const MicButton({super.key, required this.controller, this.port = const MethodChannelSpeech(), this.enabled = true});

  final TextEditingController controller;
  final SpeechPort port;
  final bool enabled;

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> {
  bool _listening = false;

  /// [base] with [words] after it, one space between, and the cursor at the end.
  void _put(String base, String words) {
    final text = base.isEmpty ? words : '$base $words';
    widget.controller.value = TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }

  Future<void> _tap() async {
    if (_listening) {
      await widget.port.stop();
      return;
    }
    final l = L10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final base = widget.controller.text.trimRight();
    setState(() => _listening = true);
    final outcome = await widget.port.listen(locale, (partial) {
      if (mounted) _put(base, partial);
    });
    if (!mounted) return;
    setState(() => _listening = false);
    final words = outcome.text?.trim() ?? '';
    if (words.isNotEmpty) {
      _put(base, words);
      return;
    }
    // No words: take back any running guess, so only what she typed stays.
    widget.controller.value = TextEditingValue(text: base, selection: TextSelection.collapsed(offset: base.length));
    final problem = outcome.problem ?? SpeechProblem.noSpeech;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(micProblemText(l, problem)),
        duration: const Duration(seconds: 8),
        action: switch (problem) {
          SpeechProblem.noPermissionSettings => SnackBarAction(label: l.notifOpenSettings, onPressed: widget.port.openAppSettings),
          // The phone lacks its offline pack for this language: Android can fetch it.
          SpeechProblem.language => SnackBarAction(
              label: l.micDownloadPack,
              onPressed: () async {
                final started = await widget.port.downloadPack(locale);
                if (started) messenger.showSnackBar(SnackBar(content: Text(l.micDownloadStarted)));
              },
            ),
          _ => null,
        },
      ));
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    return IconButton(
      onPressed: widget.enabled ? _tap : null,
      tooltip: _listening ? l.micStop : l.micStart,
      isSelected: _listening,
      icon: Icon(Icons.mic_none_rounded, color: p.textMuted),
      selectedIcon: Icon(Icons.stop_circle_outlined, color: p.primary),
    );
  }
}

/// Her words for why the mic gave nothing.
String micProblemText(L10n l, SpeechProblem problem) => switch (problem) {
      SpeechProblem.oldAndroid => l.micOldAndroid,
      SpeechProblem.notAvailable => l.micNotAvailable,
      SpeechProblem.noPermission => l.micNoPermission,
      SpeechProblem.noPermissionSettings => l.micNoPermissionSettings,
      SpeechProblem.language => l.micLanguage,
      SpeechProblem.noSpeech => l.micNoSpeech,
      SpeechProblem.busy => l.micBusy,
      SpeechProblem.other => l.micOther,
    };
