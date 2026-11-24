// The card an assistant screen shows when the safety rules fire (ADR-078 §4).
//
// Why it exists: "Say it in your words" and "Ask femio" must react the same way to a danger
// sign or a birth-control question, with reviewed words and a way to help, before any model
// runs. One widget keeps the two screens from drifting apart.

import 'package:flutter/material.dart';

import '../../data/library.dart';
import '../../domain/assistant/safety.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import '../help/help_now_screen.dart';
import '../help/red_flags_screen.dart';

/// Shows the response to [signal]; renders nothing for [SafetySignal.none].
class SafetyNotice extends StatelessWidget {
  const SafetyNotice({super.key, required this.signal, this.library});
  final SafetySignal signal;

  /// For the guide link at the foot of the warning-signs screen.
  final Library? library;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    void open(Widget screen) => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
    Widget withAction(NoticeCard card, String label, VoidCallback onTap) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        card,
        const SizedBox(height: space2),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FilledButton(onPressed: onTap, child: Text(label)),
        ),
      ],
    );
    return switch (signal) {
      SafetySignal.none => const SizedBox.shrink(),
      SafetySignal.crisis => withAction(
        NoticeCard(tone: NoticeTone.urgent, heading: l.safetyCrisisHeading, body: l.safetyCrisisBody),
        l.helpNowLauncher,
        () => open(const HelpNowScreen()),
      ),
      SafetySignal.urgent => withAction(
        NoticeCard(tone: NoticeTone.urgent, heading: l.safetyUrgentHeading, body: l.safetyUrgentBody),
        l.helpNowLauncher,
        () => open(const HelpNowScreen()),
      ),
      SafetySignal.pregnancyWarning => withAction(
        NoticeCard(tone: NoticeTone.urgent, heading: l.pregRedFlagsHeading, body: l.pregRedFlagsBody),
        l.pregRedFlagsMore,
        () => open(RedFlagsScreen(library: library)),
      ),
      SafetySignal.birthControl => NoticeCard(
        tone: NoticeTone.caution,
        heading: l.askTitle,
        body: l.safetyBirthControl,
      ),
    };
  }
}
