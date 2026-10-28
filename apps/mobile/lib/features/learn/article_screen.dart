// One guide: title, the honest review line, the body, the sources, the disclaimer.
//
// Why it exists: the same words as the website's article page, in the app, with the
// same honesty about review (a name only where a clinician reviewed) and the same
// closing line (wellness, never diagnosis).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/library.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../widgets/lexical_view.dart';
import '../../widgets/notice_card.dart';

/// Reads [article]. Links are not opened by the app (it has no network and asks for
/// none); a long press on a source copies its address for her browser.
class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key, required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).languageCode;
    final foreign = article.locale != locale;
    final body = ListView(
      padding: const EdgeInsets.fromLTRB(space5, space3, space5, space8),
      children: [
        if (foreign) ...[
          NoticeCard(tone: NoticeTone.quiet, heading: l.learnEnglishOnly, body: l.learnEnglishOnlyBody),
          const SizedBox(height: space4),
        ],
        Semantics(header: true, child: Text(article.title, style: t.headlineMedium)),
        const SizedBox(height: space2),
        Text(
          article.reviewer != null ? l.learnReviewedOn(article.reviewer!, article.lastReviewed ?? '') : l.learnReviewPending,
          style: t.labelMedium?.copyWith(color: p.textSubtle),
        ),
        const SizedBox(height: space4),
        LexicalView(root: article.body, redFlagHeading: l.learnSeekCareNow),
        const SizedBox(height: space4),
        if (article.sources.isNotEmpty) ...[
          Text(l.learnSources, style: t.titleMedium),
          const SizedBox(height: space2),
          for (final s in article.sources)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(Icons.menu_book_outlined, color: p.textSubtle),
              title: Text(s.title, style: t.bodyMedium),
              subtitle: s.url == null ? null : Text(s.url!, style: t.labelMedium?.copyWith(color: p.textSubtle), maxLines: 1, overflow: TextOverflow.ellipsis),
              onLongPress: s.url == null
                  ? null
                  : () {
                      Clipboard.setData(ClipboardData(text: s.url!));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.learnLinkCopied)));
                    },
            ),
          const SizedBox(height: space4),
        ],
        Text(l.wellnessDisclaimer, style: t.bodySmall?.copyWith(color: p.textMuted)),
      ],
    );
    return Scaffold(
      appBar: AppBar(title: Text(l.navLearn)),
      body: foreign ? Directionality(textDirection: TextDirection.ltr, child: body) : body,
    );
  }
}
