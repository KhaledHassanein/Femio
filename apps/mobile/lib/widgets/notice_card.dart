import 'package:flutter/material.dart';

import '../theme/femio_theme.dart';

enum NoticeTone { urgent, caution, quiet }

/// A boxed notice: the urgent tone is for "contact someone now" and is always drawn
/// above the tool it belongs to, never behind a threshold.
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon ?? (tone == NoticeTone.quiet ? Icons.info_outline_rounded : Icons.call_rounded), color: fg),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(heading, style: t.titleMedium?.copyWith(color: fg)),
              const SizedBox(height: 6),
              Text(body, style: t.bodyMedium?.copyWith(color: fg)),
            ]),
          ),
        ]),
      ),
    );
  }
}
