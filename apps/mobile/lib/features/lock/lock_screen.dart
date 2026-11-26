// The lock screen: a PIN before her record is shown.
//
// Why it exists: a borrowed or unattended phone must not show her cycle. The PIN is
// checked against a salted hash in the key vault (data/app_lock.dart); a forgotten
// PIN has no recovery, and the screen says so rather than hiding it. After repeated
// wrong PINs the field rests for a while and the screen says how long (SEC-2).

import 'dart:async';

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/app_lock.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../widgets/bloom.dart';
import 'pin_field.dart';

/// Asks for the PIN and unlocks the controller. Shown whenever [FemioController.locked].
class LockScreen extends StatefulWidget {
  const LockScreen({super.key, required this.controller});
  final FemioController controller;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  bool _wrong = false;
  bool _busy = false;
  // Redraws the countdown once a second while a wait runs; null otherwise.
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    AppLock.waitUntil.addListener(_onWait);
    _onWait();
  }

  @override
  void dispose() {
    AppLock.waitUntil.removeListener(_onWait);
    _tick?.cancel();
    super.dispose();
  }

  void _onWait() {
    _tick?.cancel();
    _tick = _waitLeft() > Duration.zero ? Timer.periodic(const Duration(seconds: 1), (_) => _onTick()) : null;
    if (mounted) setState(() {});
  }

  void _onTick() {
    if (_waitLeft() <= Duration.zero) {
      _tick?.cancel();
      _tick = null;
    }
    if (mounted) setState(() {});
  }

  Duration _waitLeft() {
    final until = AppLock.waitUntil.value;
    return until == null ? Duration.zero : until.difference(DateTime.now());
  }

  /// "Try again in N seconds" under a minute, whole minutes (rounded up) above it.
  String _waitText(L10n l, Duration left) {
    final seconds = (left.inMilliseconds / 1000).ceil();
    return seconds < 60 ? l.pinWaitSeconds(seconds) : l.pinWaitMinutes((seconds / 60).ceil());
  }

  Future<void> _submit(String pin) async {
    setState(() => _busy = true);
    final ok = await widget.controller.unlock(pin);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _wrong = !ok;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final left = _waitLeft();
    final waiting = left > Duration.zero;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: Bloom(size: 56)),
              const SizedBox(height: space4),
              Semantics(header: true, child: Text(l.lockTitle, style: t.headlineMedium, textAlign: TextAlign.center)),
              const SizedBox(height: space2),
              Text(l.lockHint, style: t.bodyMedium?.copyWith(color: p.textMuted), textAlign: TextAlign.center),
              const SizedBox(height: space6),
              PinField(
                key: ValueKey((_wrong, waiting)),
                label: l.enterPin,
                minLength: minPinLength,
                maxLength: maxPinLength,
                enabled: !_busy && !waiting,
                onSubmit: _submit,
              ),
              if (waiting) ...[
                const SizedBox(height: space3),
                // Not a live region: a countdown announced every second would drown a screen reader.
                Text(_waitText(l, left), style: t.bodyMedium?.copyWith(color: p.dangerText), textAlign: TextAlign.center),
              ] else if (_wrong) ...[
                const SizedBox(height: space3),
                Text(l.wrongPin, style: t.bodyMedium?.copyWith(color: p.dangerText), textAlign: TextAlign.center),
              ],
              const SizedBox(height: space8),
              Text(l.forgotPin, style: t.bodySmall?.copyWith(color: p.textSubtle), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
