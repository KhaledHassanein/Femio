// One tappable choice on the Log screen: a flow level, a mood, a symptom, a test result.
//
// Why it exists: the Log screen has about forty of these, all behaving the same way
// (tap to select, tap again to clear). One widget keeps their size, selected look and
// screen-reader meaning identical.

import 'package:flutter/material.dart';

import '../../../theme/femio_theme.dart';
import '../../../theme/spacing.dart';
import '../../../theme/type_sizes.dart';

/// A pill-shaped toggle.
///
/// [selected] draws it filled with [tint] and outlined in [ink], with a leading [icon]
/// (a check when none is given); unselected it is a plain outlined pill. [onTap] runs on
/// every tap. Its minimum height is 48px, the Android touch-target floor.
class LogChip extends StatelessWidget {
  const LogChip({
    super.key,
    required this.label,
    required this.selected,
    required this.tint,
    required this.ink,
    required this.onTap,
    this.icon,
  });
  final String label;
  final bool selected;
  final Color tint;
  final Color ink;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? tint : p.surface,
        shape: StadiumBorder(
          side: BorderSide(color: selected ? ink : p.border, width: selected ? 1.5 : 1),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: space3h, vertical: space2h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selected) ...[
                    Icon(icon ?? Icons.check_rounded, size: iconSizeInline, color: ink),
                    const SizedBox(width: space1h),
                  ],
                  // Flexible, so a long label wraps inside the chip at a large text size.
                  Flexible(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: selected ? ink : p.text,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: fontSizeChip,
                      ),
                    ),
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
