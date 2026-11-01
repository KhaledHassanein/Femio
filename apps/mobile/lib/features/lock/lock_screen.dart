// The lock screen: a PIN before her record is shown.
//
// Why it exists: a borrowed or unattended phone must not show her cycle. The PIN is
// checked against a salted hash in the key vault (data/app_lock.dart); a forgotten
// PIN has no recovery, and the screen says so rather than hiding it. Help now stays
// one tap away without the PIN (MR-38: always reachable, never gated); it shows the
// crisis wording and numbers only, nothing from her record.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/app_lock.dart';
import '../../l10n/app_localizations.dart';
import '../help/help_now_screen.dart';
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
              Semantics(
                header: true,
                child: Text(l.lockTitle, style: t.headlineMedium, textAlign: TextAlign.center),
              ),
              const SizedBox(height: space2),
              Text(
                l.lockHint,
                style: t.bodyMedium?.copyWith(color: p.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: space6),
              PinField(
                key: ValueKey(_wrong),
                label: l.enterPin,
                minLength: minPinLength,
                maxLength: maxPinLength,
                enabled: !_busy,
                onSubmit: _submit,
              ),
              if (_wrong) ...[
                const SizedBox(height: space3),
                // A live region: a wrong PIN is announced as soon as it appears.
                Semantics(
                  liveRegion: true,
                  child: Text(
                    l.wrongPin,
                    style: t.bodyMedium?.copyWith(color: p.dangerText),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: space4),
              // Opens Help now on the lock screen's own navigator: the controller stays
              // locked, and no record data is read.
              Center(
                child: TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: p.dangerText),
                  onPressed: () =>
                      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const HelpNowScreen())),
                  icon: const Icon(Icons.support_outlined),
                  label: Text(l.helpNowLauncher),
                ),
              ),
              const SizedBox(height: space6),
              Text(
                l.forgotPin,
                style: t.bodySmall?.copyWith(color: p.textSubtle),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
