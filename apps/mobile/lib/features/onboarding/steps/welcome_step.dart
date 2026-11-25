// The first onboarding screen: the wordmark, one line of promise, the language choice
// and the start button.
//
// Why it exists: the language is picked before anything is read, so a woman whose phone
// is set to English can still begin in Arabic. It is its own file because it is the one
// step with a different look (the aurora), not a question on the shared step scaffold.

import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/femio_theme.dart';
import '../../../theme/spacing.dart';
import '../../../theme/type_sizes.dart';
import '../../../widgets/bloom.dart';
import '../../../l10n/language_names.dart';

/// Welcome screen on the aurora background.
///
/// [controller] receives the language she picks. [onStart] runs when she taps the start
/// button. It has no failure cases: language changes go straight to the controller.
class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key, required this.controller, required this.onStart});
  final FemioController controller;
  final VoidCallback onStart;

  /// Each language is named in itself, so she can find hers whatever the screen shows.

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final current = Localizations.localeOf(context).languageCode;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const AlignmentDirectional(0.6, -0.7).resolve(Directionality.of(context)),
            radius: 1.3,
            colors: [p.aurora1, p.aurora4, p.auroraGround],
            stops: const [0, 0.45, 1],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(space6, space6, space6, space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const Center(child: Bloom(size: 112)),
                const SizedBox(height: space5),
                // Always the English wordmark, in every language (product rule 6).
                Text('femio',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: t.displaySmall?.copyWith(color: Colors.white, fontSize: fontSizeWordmark)),
                const SizedBox(height: space4),
                Text(l.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: t.headlineSmall?.copyWith(color: Colors.white)),
                const SizedBox(height: space3),
                Text(l.welcomeBody,
                    textAlign: TextAlign.center,
                    style: t.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                const Spacer(),
                Semantics(
                  label: l.language,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: space2,
                    runSpacing: space2,
                    children: [
                      for (final code in supportedLanguages)
                        _LanguagePill(
                          label: nativeLanguageNames[code]!,
                          selected: current == code,
                          selectedText: p.auroraGround, // always on white, in both themes
                          onTap: () => controller.setLanguage(code),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: space6),
                FilledButton(
                  onPressed: onStart,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: p.primarySolid,
                  ),
                  child: Text(l.getStarted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A language choice on the aurora. Drawn here rather than with `ChoiceChip`, whose
/// Material 3 colours ignored the unselected background and rendered white on white.
class _LanguagePill extends StatelessWidget {
  const _LanguagePill({
    required this.label,
    required this.selected,
    required this.selectedText,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final Color selectedText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? Colors.white : Colors.white.withValues(alpha: 0.14),
        shape: StadiumBorder(side: BorderSide(color: Colors.white.withValues(alpha: selected ? 1 : 0.45))),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 64),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: space4h, vertical: space3),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? selectedText : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSizeLanguagePill,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
