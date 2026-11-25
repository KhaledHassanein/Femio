// The quiet "new version" card above the tabs (R12.3).
//
// Why it exists: Google Play reports a newer femio; she gets one calm line and a button,
// never a nag. It can be dismissed for this session and returns at the next app start only
// while the update is still waiting.

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';

/// A one-line update offer. [onUpdate] starts Google Play's update; [onDismiss] hides the
/// card until the next app start.
class UpdateCard extends StatelessWidget {
  const UpdateCard({super.key, required this.onUpdate, required this.onDismiss});
  final VoidCallback onUpdate;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final close = MaterialLocalizations.of(context).closeButtonTooltip;
    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        margin: const EdgeInsetsDirectional.fromSTEB(space4, space2, space4, 0),
        padding: const EdgeInsetsDirectional.fromSTEB(space4, space1, space1, space1),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(radiusLg),
          border: Border.all(color: p.border),
        ),
        child: Row(children: [
          Icon(Icons.system_update_rounded, color: p.text),
          const SizedBox(width: space3),
          Expanded(child: Text(l.updateBannerBody, style: t.bodyMedium?.copyWith(color: p.text))),
          TextButton(onPressed: onUpdate, child: Text(l.updateBannerAction)),
          IconButton(onPressed: onDismiss, tooltip: close, icon: const Icon(Icons.close_rounded)),
        ]),
      ),
    );
  }
}
