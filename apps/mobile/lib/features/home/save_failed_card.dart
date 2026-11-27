// The card that says her last change was not saved on this phone.
//
// Why it exists: a save that fails silently (a full phone, a storage error) would let her
// believe a log is kept when it is not. The record in memory stays; the card says so,
// says her earlier records are safe (each write goes to a temporary file first) and
// offers to try again.

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';

/// Shown above the tabs while [FemioController.saveFailed]. [onRetry] saves again.
class SaveFailedCard extends StatelessWidget {
  const SaveFailedCard({super.key, required this.onRetry});
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(space4, space2, space4, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Semantics(
          liveRegion: true,
          child: NoticeCard(
            tone: NoticeTone.caution,
            icon: Icons.sd_card_alert_outlined,
            heading: l.saveFailedTitle,
            body: l.saveFailedBody,
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(foregroundColor: p.warningText),
            child: Text(l.saveFailedRetry),
          ),
        ),
      ]),
    );
  }
}
