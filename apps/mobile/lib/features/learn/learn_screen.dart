// The Learn tab: the reviewed guides, inside the app, without a network.
//
// Why it exists: the website's library is the product's medical voice; the app
// carries it so a woman in a clinic waiting room with no data can read it. The wedge
// comes first (trying to conceive, pregnancy, PCOS); everything stays reachable.

import 'package:flutter/material.dart';

import '../../data/library.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/tab_header.dart';
import '../../app.dart';
import '../assistant/ask_screen.dart';
import '../tools/tools_screen.dart';
import 'article_screen.dart';

/// The guide list with a search field. [library] is injectable for tests.
class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key, required this.library, this.controller});
  final Library library;

  /// Her record, for Ask femio's safety rules. Optional so tests of Learn need none.
  final FemioController? controller;

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Article>>(
          future: widget.library.articles(locale),
          builder: (context, snapshot) {
            final all = snapshot.data ?? const <Article>[];
            final q = _query.trim().toLowerCase();
            final shown = q.isEmpty
                ? all
                : all.where((a) => a.title.toLowerCase().contains(q) || a.excerpt.toLowerCase().contains(q)).toList();
            return ListView(
              padding: const EdgeInsets.fromLTRB(space5, space3, space5, space8),
              children: [
                TabHeader(title: l.learnTitle),
                const SizedBox(height: space1),
                Text(l.learnSub, style: t.bodyMedium?.copyWith(color: p.textMuted)),
                const SizedBox(height: space4),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded),
                    hintText: l.learnSearchHint,
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
                const SizedBox(height: space2),
                Wrap(
                  spacing: space2,
                  children: [
                    if (widget.controller != null)
                      // ADR-078: an answer from trusted sources when no guide fits.
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => AskScreen(controller: widget.controller!, library: widget.library),
                          ),
                        ),
                        icon: const Icon(Icons.travel_explore_rounded),
                        label: Text(l.askTitle),
                      ),
                    // R11.5: the calculators that save nothing, open to everyone.
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => ToolsScreen(library: widget.library)),
                      ),
                      icon: const Icon(Icons.calculate_outlined),
                      label: Text(l.toolsTitle),
                    ),
                  ],
                ),
                const SizedBox(height: space4),
                if (snapshot.connectionState != ConnectionState.done)
                  const Center(
                    child: Padding(padding: EdgeInsets.all(space6), child: CircularProgressIndicator()),
                  )
                else if (shown.isEmpty)
                  Text(l.learnNoResults, style: t.bodyMedium?.copyWith(color: p.textMuted))
                else
                  for (final a in shown) _ArticleTile(article: a, foreignLanguage: a.locale != locale),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ArticleTile extends StatelessWidget {
  const _ArticleTile({required this.article, required this.foreignLanguage});
  final Article article;

  /// True when the guide fell back to English for a non-English reader.
  final bool foreignLanguage;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: space3),
      child: Material(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusLg),
        child: InkWell(
          borderRadius: BorderRadius.circular(radiusLg),
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ArticleScreen(article: article))),
          child: Padding(
            padding: const EdgeInsets.all(space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.title, style: t.titleMedium, textDirection: foreignLanguage ? TextDirection.ltr : null),
                const SizedBox(height: space1),
                Text(
                  article.excerpt,
                  style: t.bodySmall?.copyWith(color: p.textMuted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textDirection: foreignLanguage ? TextDirection.ltr : null,
                ),
                const SizedBox(height: space2),
                Row(
                  children: [
                    Icon(
                      article.reviewer != null ? Icons.verified_outlined : Icons.pending_outlined,
                      size: 16,
                      color: p.textSubtle,
                    ),
                    const SizedBox(width: space1),
                    Expanded(
                      child: Text(
                        article.reviewer != null ? l.learnReviewedBy(article.reviewer!) : l.learnReviewPending,
                        style: t.labelMedium?.copyWith(color: p.textSubtle),
                      ),
                    ),
                    if (foreignLanguage) Text(l.learnEnglishOnly, style: t.labelMedium?.copyWith(color: p.textSubtle)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
