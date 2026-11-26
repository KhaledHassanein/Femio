// "What can leave this phone": every path by which anything reaches the internet (R8.21).
//
// Why it exists: product rule 4 says every privacy sentence must match what the code sends.
// This screen lists each network path the app has, in plain words, with Cloud boost's live
// state read from her consent record. A path added to the code must be added here and to the
// privacy notice in the same change.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../domain/assistant/cloud_consent.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../assistant/assistant_scope.dart';
import '../assistant/cloud_boost_screen.dart' show privacyNoticeUrl;

/// The list of network paths, reached from Settings › Privacy. [controller] supplies her
/// Cloud boost consent so the first row says whether it is on.
class LeavingPhoneScreen extends StatelessWidget {
  const LeavingPhoneScreen({super.key, required this.controller});
  final FemioController controller;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final consent = controller.profile?.settings.cloud ?? const CloudConsent();
    final on = [
      if (consent.allows(CloudPurpose.questions)) l.boostPurposeQuestions,
      if (consent.allows(CloudPurpose.tips)) l.boostPurposeTips,
    ];
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l.leaveTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(space5, space3, space5, space8),
        children: [
          Text(l.leaveIntro, style: t.bodyLarge),
          const SizedBox(height: space4),
          _Path(
            icon: Icons.cloud_outlined,
            heading: l.boostTitle,
            status: on.isEmpty ? l.leaveBoostOff : l.leaveBoostOn(on.join(', ')),
            body: l.leaveBoostBody,
          ),
          _Path(icon: Icons.memory_rounded, heading: l.leaveModelHeading, body: l.leaveModelBody),
          _Path(icon: Icons.shop_outlined, heading: l.leavePlayHeading, body: l.leavePlayBody),
          _Path(icon: Icons.save_alt_rounded, heading: l.leaveBackupHeading, body: l.leaveBackupBody),
          _Path(icon: Icons.ios_share_rounded, heading: l.leaveShareHeading, body: l.leaveShareBody),
          _Path(icon: Icons.open_in_new_rounded, heading: l.leaveLinksHeading, body: l.leaveLinksBody),
          const SizedBox(height: space2),
          Text(l.leaveNever, style: t.bodyMedium),
          const SizedBox(height: space3),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => AssistantScope.of(context).openSource(privacyNoticeUrl(lang)),
              icon: const Icon(Icons.open_in_new_rounded),
              label: Text(l.boostReadNotice),
            ),
          ),
        ],
      ),
    );
  }
}

/// One network path: what it is, and, for Cloud boost, whether it is on.
class _Path extends StatelessWidget {
  const _Path({required this.icon, required this.heading, required this.body, this.status});
  final IconData icon;
  final String heading;
  final String body;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: space3),
        padding: const EdgeInsets.all(space4),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(radiusLg),
          border: Border.all(color: p.border),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: p.text),
          const SizedBox(width: space3),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(heading, style: t.titleMedium),
              if (status != null) ...[
                const SizedBox(height: space1),
                Text(status!, style: t.labelLarge?.copyWith(color: p.textMuted)),
              ],
              const SizedBox(height: space1),
              Text(body, style: t.bodyMedium),
            ]),
          ),
        ]),
      ),
    );
  }
}
