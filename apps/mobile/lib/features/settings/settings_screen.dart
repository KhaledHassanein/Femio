// Settings: language, Hijri dates, the app lock, backup, and deleting everything.
//
// Why it exists: the app promised "change this any time" with nowhere to do it
// (study report 04). Everything here is about her phone and her record; nothing
// here talks to a server, because there is none.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/app_lock.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../lock/pin_field.dart';
import 'backup_actions.dart';
import 'delete_dialog.dart';

/// The language names, in their own language, so each reader finds hers.
const _languageNames = {'ar': 'العربية', 'en': 'English', 'fr': 'Français', 'es': 'Español'};

/// The Settings screen, reached from the header gear.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});
  final FemioController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: controller, builder: (context, _) => _build(context));

  Widget _build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final profile = controller.profile;
    final settings = profile?.settings;
    final current = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: space2),
        children: [
          _Section(title: l.settingsLanguage),
          RadioGroup<String>(
            groupValue: current,
            onChanged: (v) {
              if (v == null) return;
              controller.setLanguage(v);
              if (profile != null) controller.save(profile.copyWith(locale: v));
            },
            child: Column(
              children: [
                for (final code in supportedLanguages)
                  RadioListTile<String>(
                    value: code,
                    title: Text(_languageNames[code]!, textDirection: code == 'ar' ? TextDirection.rtl : TextDirection.ltr),
                  ),
              ],
            ),
          ),
          if (settings != null) ...[
            _Section(title: l.settingsDates),
            SwitchListTile(
              value: settings.showHijri,
              title: Text(l.settingsHijri),
              subtitle: Text(l.settingsHijriNote),
              onChanged: (v) => controller.setSettings(settings.copyWith(showHijri: v)),
            ),
          ],
          _Section(title: l.settingsPrivacy),
          SwitchListTile(
            value: controller.lockEnabled,
            title: Text(l.settingsLock),
            subtitle: Text(l.settingsLockNote),
            onChanged: (on) => on ? _setPin(context) : _removePin(context),
          ),
          if (controller.lockEnabled)
            ListTile(leading: const Icon(Icons.pin_outlined), title: Text(l.changePin), onTap: () => _changePin(context)),
          if (profile != null) ...[
            _Section(title: l.backupSection),
            ListTile(
              leading: const Icon(Icons.save_alt_rounded),
              title: Text(l.exportBackup),
              subtitle: Text(l.backupHonesty, style: t.bodySmall?.copyWith(color: p.textMuted)),
              onTap: () => exportBackupFlow(context, controller),
            ),
            ListTile(leading: const Icon(Icons.restore_rounded), title: Text(l.importBackup), onTap: () => importBackupFlow(context, controller)),
          ],
          _Section(title: l.aboutSection),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: space4),
            child: Text(l.wellnessDisclaimer, style: t.bodySmall?.copyWith(color: p.textMuted)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(space4, space2, space4, space2),
            child: Text(l.privacyLine, style: t.bodySmall?.copyWith(color: p.textMuted)),
          ),
          const SizedBox(height: space4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: space4),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: p.dangerText),
              onPressed: () => confirmDeleteEverything(context, controller),
              icon: const Icon(Icons.delete_outline_rounded),
              label: Text(l.deleteEverything),
            ),
          ),
          const SizedBox(height: space8),
        ],
      ),
    );
  }

  Future<String?> _askPin(BuildContext context, String title, {bool confirm = false}) async {
    final l = L10n.of(context);
    String? first;
    String? error;
    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(first == null ? title : l.enterPinAgain),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (error != null) Padding(padding: const EdgeInsets.only(bottom: space2), child: Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
              PinField(
                key: ValueKey('$first$error'),
                label: l.enterPin,
                minLength: minPinLength,
                maxLength: maxPinLength,
                onSubmit: (pin) {
                  if (!confirm) return Navigator.of(context).pop(pin);
                  if (first == null) return setState(() => first = pin);
                  if (first == pin) return Navigator.of(context).pop(pin);
                  setState(() {
                    first = null;
                    error = l.pinMismatch;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setPin(BuildContext context) async {
    final l = L10n.of(context);
    final pin = await _askPin(context, l.setPin, confirm: true);
    if (pin != null) await controller.setPin(pin);
  }

  Future<void> _changePin(BuildContext context) async {
    final l = L10n.of(context);
    if (!await _checkCurrent(context)) return;
    if (!context.mounted) return;
    final pin = await _askPin(context, l.setPin, confirm: true);
    if (pin != null) await controller.setPin(pin);
  }

  Future<void> _removePin(BuildContext context) async {
    if (!await _checkCurrent(context)) return;
    await controller.removePin();
  }

  Future<bool> _checkCurrent(BuildContext context) async {
    final l = L10n.of(context);
    final current = await _askPin(context, l.enterCurrentPin);
    if (current == null) return false;
    final ok = await controller.verifyPin(current);
    if (!ok && context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.wrongPin)));
    return ok;
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(space4, space4, space4, space1),
        child: Text(title, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: context.palette.textMuted)),
      );
}
