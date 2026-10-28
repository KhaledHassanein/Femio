// The title row of a tab, with the Help now button at its end.
//
// Why it exists: Help now must be one tap away from every tab, never only from
// Today (docs/compliance/CRISIS_RESOURCES.md; R4.8). Calendar, Log and Learn share
// this row so the button sits in the same place with the same tooltip on each.

import 'package:flutter/material.dart';

import '../features/help/help_now_screen.dart';
import '../l10n/app_localizations.dart';
import '../theme/femio_theme.dart';

/// A tab's heading plus the Help now launcher. [trailing] goes between them.
class TabHeader extends StatelessWidget {
  const TabHeader({super.key, required this.title, this.trailing = const []});
  final String title;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Semantics(header: true, child: Text(title, style: t.headlineMedium)),
        ),
        ...trailing,
        HelpNowButton(color: p.dangerText),
      ],
    );
  }
}

/// The red support icon that opens Help now. Today's brand row uses it too.
class HelpNowButton extends StatelessWidget {
  const HelpNowButton({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: L10n.of(context).helpNowLauncher,
    icon: Icon(Icons.support_outlined, color: color),
    onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const HelpNowScreen())),
  );
}
