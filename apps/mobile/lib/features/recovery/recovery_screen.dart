// The screen she sees when her record cannot be opened right now.
//
// Why it exists: the Android Keystore can fail or be reset (a lock-screen change on some
// phones, a restore, an update), and storage can fail. Crashing or showing a blank
// screen would look like data loss. This screen says plainly that nothing was deleted or
// changed, and offers only what is safe: try again, restore her own backup file, or
// start empty after a confirmation that says her old file stays on the phone.
// (A file that opened but was damaged goes to CorruptRecordScreen instead.)

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../settings/backup_actions.dart';

/// The recovery screen for [RecordState.unavailable].
class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key, required this.controller});
  final FemioController controller;

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

/// What the screen last learned, shown in a live region under the buttons.
enum _Message { none, stillClosed, failed }

class _RecoveryScreenState extends State<RecoveryScreen> {
  bool _busy = false;
  _Message _message = _Message.none;

  Future<void> _tryAgain() async {
    setState(() {
      _busy = true;
      _message = _Message.none;
    });
    await widget.controller.load();
    // When the record opened, the app swaps this screen away and we are no longer mounted.
    if (!mounted) return;
    setState(() {
      _busy = false;
      _message = _Message.stillClosed;
    });
  }

  Future<void> _restore() async {
    setState(() {
      _busy = true;
      _message = _Message.none;
    });
    try {
      await importBackupFlow(context, widget.controller);
      if (!mounted) return;
      setState(() => _busy = false);
    } catch (_) {
      // The file picker or the phone's storage failed. Nothing was changed.
      if (!mounted) return;
      setState(() {
        _busy = false;
        _message = _Message.failed;
      });
    }
  }

  Future<void> _startFresh() async {
    final l = L10n.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.recoveryFreshTitle),
        content: Text(l.recoveryFreshBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l.recoveryFreshCancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l.recoveryFreshConfirm)),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    final done = await widget.controller.startFresh();
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (!done) _message = _Message.failed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final message = switch (_message) {
      _Message.none => null,
      _Message.stillClosed => l.recoveryStillClosed,
      _Message.failed => l.recoveryActionFailed,
    };
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(space6),
          children: [
            Semantics(header: true, child: Text(l.recoveryTitle, style: t.headlineMedium)),
            const SizedBox(height: space3),
            Text(l.recoveryBody, style: t.bodyMedium?.copyWith(color: p.textMuted)),
            const SizedBox(height: space6),
            FilledButton.icon(
              onPressed: _busy ? null : _tryAgain,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l.recoveryTryAgain),
            ),
            if (message != null) ...[
              const SizedBox(height: space3),
              Semantics(liveRegion: true, child: Text(message, style: t.bodyMedium)),
            ],
            const SizedBox(height: space6),
            Text(l.recoveryRestoreNote, style: t.bodyMedium?.copyWith(color: p.textMuted)),
            const SizedBox(height: space3),
            OutlinedButton.icon(
              onPressed: _busy ? null : _restore,
              icon: const Icon(Icons.restore_rounded),
              label: Text(l.importBackup),
            ),
            const SizedBox(height: space3),
            TextButton(onPressed: _busy ? null : _startFresh, child: Text(l.recoveryStartFresh)),
          ],
        ),
      ),
    );
  }
}
