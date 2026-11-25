// A bottom sheet of plain sentences under a title, with an optional action (R9.6, R10.3).
//
// Why it exists: the explainers ("Why this range?", "Explain this day", "Why this tip") all show
// a few fixed, translated sentences. One sheet keeps them looking and reading the same.

import 'package:flutter/material.dart';

import '../theme/femio_theme.dart';
import '../theme/spacing.dart';

/// Opens a sheet with [title], one paragraph per line of [lines], and [action] at the end.
Future<void> showLinesSheet(BuildContext context, String title, List<String> lines, {Widget? action}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      final t = Theme.of(context).textTheme;
      final p = context.palette;
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.8),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(space5, 0, space5, space5),
            children: [
              Semantics(header: true, child: Text(title, style: t.titleLarge)),
              const SizedBox(height: space3),
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: space3),
                  child: Text(line, style: t.bodyMedium?.copyWith(color: p.text)),
                ),
              if (action != null) Align(alignment: AlignmentDirectional.centerStart, child: action),
            ],
          ),
        ),
      );
    },
  );
}

