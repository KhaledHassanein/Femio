// Renders a guide's rich text (the website's Lexical JSON) as Flutter widgets.
//
// Why it exists: the guides are authored once; this is the app's twin of the
// website's `lexical.tsx`. It draws the same eight node types the authoring brief
// allows (paragraph, heading, list, list item, quote, link, text, line break) and
// turns a quote that opens with the "seek care now" words into the red-flag card,
// exactly as the website does. Anything else is drawn as plain text rather than
// dropped, so a new node type can never silently remove a warning.

import 'package:flutter/material.dart';

import '../theme/femio_theme.dart';
import '../theme/spacing.dart';
import 'notice_card.dart';

/// Opening words of a red-flag box, per language, mirroring `apps/web/src/lib/cms/red-flag.ts`.
const redFlagPrefixes = ['Seek care now', 'اطلبي الرعاية الآن', 'Consultez sans attendre', 'Busca atención ahora'];

/// Lexical text-format bits.
const _bold = 1;
const _italic = 2;

/// Draws the tree under [root] (`{"root": {...}}` or the root node itself).
class LexicalView extends StatelessWidget {
  const LexicalView({super.key, required this.root, required this.redFlagHeading});
  final Map<String, Object?> root;

  /// The heading shown on a red-flag card ("Seek care now").
  final String redFlagHeading;

  @override
  Widget build(BuildContext context) {
    final node = (root['root'] as Map?) ?? root;
    final children = _children(Map<String, Object?>.from(node));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (final c in children) _block(context, c)],
    );
  }

  List<Map<String, Object?>> _children(Map<String, Object?> node) =>
      [for (final c in (node['children'] as List?) ?? const []) Map<String, Object?>.from(c as Map)];

  Widget _block(BuildContext context, Map<String, Object?> node) {
    final t = Theme.of(context).textTheme;
    final p = context.palette;
    switch (node['type']) {
      case 'paragraph':
        return Padding(
          padding: const EdgeInsets.only(bottom: space3),
          child: Text.rich(_inline(context, node, t.bodyLarge!)),
        );
      case 'heading':
        final style = node['tag'] == 'h3' ? t.titleMedium : t.titleLarge;
        return Padding(
          padding: const EdgeInsets.only(top: space4, bottom: space2),
          child: Semantics(header: true, child: Text.rich(_inline(context, node, style!))),
        );
      case 'list':
        final ordered = node['tag'] == 'ol' || node['listType'] == 'number';
        final items = _children(node);
        return Padding(
          padding: const EdgeInsets.only(bottom: space3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < items.length; i += 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: space1h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: space6, child: Text(ordered ? '${i + 1}.' : '•', style: t.bodyLarge?.copyWith(color: p.primary))),
                      Expanded(child: Text.rich(_inline(context, items[i], t.bodyLarge!))),
                    ],
                  ),
                ),
            ],
          ),
        );
      case 'quote':
        final text = _plainText(node);
        if (_isRedFlag(text)) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: space3),
            child: NoticeCard(tone: NoticeTone.urgent, heading: redFlagHeading, body: _afterColon(text)),
          );
        }
        return Container(
          margin: const EdgeInsets.only(bottom: space3),
          padding: const EdgeInsetsDirectional.only(start: space4),
          decoration: BoxDecoration(border: BorderDirectional(start: BorderSide(color: p.primary, width: 3))),
          child: Text.rich(_inline(context, node, t.bodyLarge!.copyWith(color: p.textMuted))),
        );
      default:
        return Text(_plainText(node), style: t.bodyLarge);
    }
  }

  /// Inline runs: text with bold/italic, links drawn underlined (opened by the screen).
  TextSpan _inline(BuildContext context, Map<String, Object?> node, TextStyle base) {
    final p = context.palette;
    final spans = <InlineSpan>[];
    for (final c in _children(node)) {
      switch (c['type']) {
        case 'text':
          final format = (c['format'] as num?)?.toInt() ?? 0;
          spans.add(TextSpan(
            text: c['text'] as String? ?? '',
            style: base.copyWith(
              fontWeight: format & _bold != 0 ? FontWeight.w600 : null,
              fontStyle: format & _italic != 0 ? FontStyle.italic : null,
            ),
          ));
        case 'linebreak':
          spans.add(const TextSpan(text: '\n'));
        case 'link':
          spans.add(TextSpan(
            children: [_inline(context, c, base)],
            style: base.copyWith(color: p.primary, decoration: TextDecoration.underline),
          ));
        default:
          spans.add(TextSpan(text: _plainText(c), style: base));
      }
    }
    return TextSpan(children: spans, style: base);
  }

  static String _plainText(Map<String, Object?> node) {
    if (node['type'] == 'text') return node['text'] as String? ?? '';
    if (node['type'] == 'linebreak') return '\n';
    final buf = StringBuffer();
    for (final c in (node['children'] as List?) ?? const []) {
      buf.write(_plainText(Map<String, Object?>.from(c as Map)));
    }
    return buf.toString();
  }

  static bool _isRedFlag(String text) {
    final head = text.trimLeft();
    return redFlagPrefixes.any((prefix) => head.startsWith(prefix) && RegExp('^${RegExp.escape(prefix)}\\s*[:：]').hasMatch(head));
  }

  /// The box's text without its opening words.
  static String _afterColon(String text) {
    final i = text.indexOf(RegExp('[:：]'));
    return i == -1 ? text.trim() : text.substring(i + 1).trim();
  }
}
