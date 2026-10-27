// The boxed notice used for red flags, cautions and quiet information.
//
// Why it exists: "contact someone now" must look the same on every screen and always sit
// above the tool it belongs to, so the three tones are one widget.

import 'package:flutter/material.dart';

import '../theme/femio_theme.dart';
import '../theme/radii.dart';
import '../theme/spacing.dart';

/// How loud a [NoticeCard] is: [urgent] for "contact someone now", [caution] for
/// "worth raising with a clinician", [quiet] for plain information.
enum NoticeTone { urgent, caution, quiet }

/// A boxed notice: the urgent tone is for "contact someone now" and is always drawn
/// above the tool it belongs to, never behind a threshold.
///
/// [heading] and [body] are already-localised text; [icon] overrides the tone's default.
class NoticeCard extends StatelessWidget {
  const NoticeCard({super.key, required this.tone, required this.heading, required this.body, this.icon});
  final NoticeTone tone;
  final String heading;
  final String body;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final (bg, border, fg) = switch (tone) {
      NoticeTone.urgent => (p.dangerSoft, p.dangerBorder, p.dangerText),
      NoticeTone.caution => (p.warningSoft, p.warning, p.warningText),
      NoticeTone.quiet => (p.surface, p.border, p.text),
    };
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.all(space4h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radiusLg),
          border: Border.all(color: border),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon ?? (tone == NoticeTone.quiet ? Icons.info_outline_rounded : Icons.call_rounded), color: fg),
          const SizedBox(width: space3),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(heading, style: t.titleMedium?.copyWith(color: fg)),
              const SizedBox(height: space1h),
              Text(body, style: t.bodyMedium?.copyWith(color: fg)),
            ]),
          ),
        ]),
      ),
    );
  }
}
