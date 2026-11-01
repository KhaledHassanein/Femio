// A short preview of a longer text: cut with an ellipsis at normal text size, never cut
// once she has enlarged her text.
//
// Why it exists: a two-line preview with an ellipsis is fine at normal text size, but for
// a reader who has enlarged her text the ellipsis hides the very words she enlarged it to
// read (WCAG 1.4.4 resize text, 1.4.12 text spacing). One widget keeps that rule in one
// place instead of a bare `maxLines: 2` on each screen.

import 'package:flutter/material.dart';

/// Above this scale the text is no longer cut: she has asked for bigger text.
const double _previewScaleLimit = 1.1;

/// [text] limited to [lines] lines (with an ellipsis) at the default text size, and shown
/// in full once she has enlarged her text.
class PreviewText extends StatelessWidget {
  const PreviewText(this.text, {super.key, required this.lines, this.style, this.textDirection});
  final String text;
  final int lines;
  final TextStyle? style;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    final enlarged = MediaQuery.textScalerOf(context).scale(10) > 10 * _previewScaleLimit;
    return Text(
      text,
      style: style,
      textDirection: textDirection,
      maxLines: enlarged ? null : lines,
      overflow: enlarged ? TextOverflow.visible : TextOverflow.ellipsis,
    );
  }
}
