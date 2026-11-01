// A calm banner for "femio could not save your last change".
//
// Why it exists: when the phone refuses a write (storage full, Keystore trouble) the app
// keeps what she typed in memory so she can carry on, but she must be told it is not yet
// on the phone. Silence would let her believe it is safe. The banner says what is true
// (her earlier records are intact) and what helps (try again, save a backup file), and
// goes away on its own at the next successful save or when she dismisses it.

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';

/// The banner drawn over the top of the app while a save has failed.
class SaveFailedBanner extends StatelessWidget {
  const SaveFailedBanner({super.key, required this.onDismiss});

  /// Called when she taps "Got it".
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(space3),
        child: Semantics(
          liveRegion: true,
          container: true,
          child: Material(
            color: p.warningSoft,
            elevation: 2,
            borderRadius: BorderRadius.circular(radiusLg),
            child: Container(
              padding: const EdgeInsets.all(space4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radiusLg),
                border: Border.all(color: p.warning),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l.saveFailedBanner, style: t.bodyMedium?.copyWith(color: p.warningText)),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(onPressed: onDismiss, child: Text(l.dismiss)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
