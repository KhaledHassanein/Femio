// The notification consent screen: shown before the first notification is ever scheduled.
//
// Why it exists (R12.1): a notification is the one thing femio does without her opening
// the app, so it starts only after she has read what it will be and chosen each kind. The
// screen says in plain words what she will receive, that the text is neutral (no health
// word on a lock screen), and that everything is scheduled on the phone and nothing is
// sent anywhere. "Allow" then asks the phone for the Android 13+ permission; a refusal is
// reported plainly, with how to turn it on later, and nothing is saved or scheduled.
// Which kinds exist and what is on lives in `domain/notification_kinds.dart`; the
// permission and the saving live in `FemioController.grantNotificationConsent`.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../domain/notification_kinds.dart';
import '../../data/profile.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';

/// Opens the consent screen and returns true when she allowed notifications. [initial] is
/// the kind she was switching on (pre-ticked); null ticks nothing.
Future<bool> showNotificationConsent(
  BuildContext context,
  FemioController controller, {
  NotificationKind? initial,
}) async {
  final granted = await Navigator.of(context).push<bool>(
    MaterialPageRoute<bool>(
      builder: (_) =>
          NotificationConsentScreen(controller: controller, initial: initial),
    ),
  );
  return granted ?? false;
}

/// The consent screen itself. Pops with true once consent is saved.
class NotificationConsentScreen extends StatefulWidget {
  const NotificationConsentScreen({
    super.key,
    required this.controller,
    this.initial,
  });
  final FemioController controller;
  final NotificationKind? initial;

  @override
  State<NotificationConsentScreen> createState() =>
      _NotificationConsentScreenState();
}

class _NotificationConsentScreenState extends State<NotificationConsentScreen> {
  late NotificationChoice _choice = widget.initial == null
      ? const NotificationChoice()
      : NotificationChoice.only(widget.initial!);
  bool _denied = false;
  bool _busy = false;

  Future<void> _allow() async {
    setState(() => _busy = true);
    final result = await widget.controller.grantNotificationConsent(_choice);
    if (!mounted) return;
    switch (result) {
      case NotificationConsentResult.granted:
        Navigator.of(context).pop(true);
      case NotificationConsentResult.permissionDenied:
        setState(() {
          _busy = false;
          _denied = true;
        });
      case NotificationConsentResult.nothingChosen:
        setState(() => _busy = false);
    }
  }

  /// Label and one-line note for [kind], from the catalogue.
  (String, String?) _words(L10n l, NotificationKind kind) => switch (kind) {
    NotificationKind.log => (l.reminderLog, l.reminderLogNote),
    NotificationKind.period => (l.reminderPeriod, l.reminderPeriodNote),
    NotificationKind.appointment => (
      l.reminderAppointment,
      l.reminderAppointmentNote,
    ),
    NotificationKind.medicine => (l.notifKindMedicine, null),
    NotificationKind.digest => (l.notifKindDigest, null),
  };

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final goal = widget.controller.profile?.goal;
    final showPeriod = goal == Goal.period || goal == Goal.ttc;

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsReminders)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  space4,
                  space2,
                  space4,
                  space4,
                ),
                children: [
                  Text(l.notifConsentTitle, style: t.headlineSmall),
                  const SizedBox(height: space3),
                  if (_denied) ...[
                    // First thing under the title, so a refusal is seen without scrolling.
                    _DeniedCard(
                      title: l.notifConsentDeniedTitle,
                      body: l.notifConsentDeniedBody,
                    ),
                    const SizedBox(height: space3),
                  ],
                  Text(l.notifConsentIntro, style: t.bodyLarge),
                  const SizedBox(height: space4),
                  _Fact(
                    icon: Icons.lock_outline_rounded,
                    text: l.notifConsentNeutral,
                  ),
                  const SizedBox(height: space2),
                  _Fact(
                    icon: Icons.smartphone_rounded,
                    text: l.notifConsentLocal,
                  ),
                  const SizedBox(height: space4),
                  // The kinds that work come first, so every real choice is above the fold.
                  for (final kind in [
                    ...NotificationKind.values.where((k) => k.available),
                    ...NotificationKind.values.where((k) => !k.available),
                  ])
                    if (kind != NotificationKind.period || showPeriod)
                      _kindRow(l, kind),
                ],
              ),
            ),
            // Pinned, so "Allow" and "Not now" are always in reach however long the text runs.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                space4,
                space2,
                space4,
                space2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!_choice.any)
                    Padding(
                      padding: const EdgeInsets.only(bottom: space2),
                      child: Text(
                        l.notifConsentPickOne,
                        style: t.bodySmall?.copyWith(color: p.textMuted),
                      ),
                    ),
                  FilledButton(
                    onPressed: _choice.any && !_busy ? _allow : null,
                    child: Text(l.notifConsentAllow),
                  ),
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () => Navigator.of(context).pop(false),
                    child: Text(l.notifConsentNotNow),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kindRow(L10n l, NotificationKind kind) {
    final (title, note) = _words(l, kind);
    final available = kind.available;
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: available && _choice.has(kind),
      title: Text(title),
      subtitle: Text(available ? note! : l.notifComingSoon),
      onChanged: available
          ? (on) => setState(() => _choice = _choice.toggled(kind, on))
          : null,
    );
  }
}

/// One reassurance line with its icon.
class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(space3),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusMd),
        border: Border.all(color: p.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: p.textMuted),
          const SizedBox(width: space3),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

/// The plain statement after the phone refused permission, with how to allow it later.
class _DeniedCard extends StatelessWidget {
  const _DeniedCard({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(space3),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(radiusMd),
          border: Border.all(color: p.borderStrong),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.notifications_off_outlined, color: p.textMuted),
            const SizedBox(width: space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: t.titleSmall),
                  const SizedBox(height: space1),
                  Text(body, style: t.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
