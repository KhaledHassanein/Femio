// Pregnancy warning signs as their own screen (MR-29): the sourced sentence, the same
// seven symptoms as a list she can scan, where the list comes from, and the guide.
//
// Why it exists: a card on Today is read once and scrolls away; a woman who is worried
// needs the list on one screen she can reach again, with the fallback line and the
// sources behind it. The sentence is the website's reviewed one (ARB, kept in step by
// the vocabulary sync guard); the list and the sources come from
// lib/domain/red_flags.dart, never from this file. The app opens nothing: a long press
// on a source copies its address for her browser, as the guides do.

import '../../data/safety_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/library.dart';
import '../../domain/red_flags.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import '../learn/article_screen.dart';

/// The warning-signs screen, reached from the red-flag card on Today.
///
/// [library] is optional: when given, the foot of the screen links to the
/// pregnancy-warning-signs guide in her language (English when not translated).
class RedFlagsScreen extends StatelessWidget {
  const RedFlagsScreen({super.key, this.library});
  final Library? library;

  @override
  Widget build(BuildContext context) {
    SafetySession.mark(); // no rating request this session (R12.2)
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(l.pregRedFlagsHeading)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(space5, space3, space5, space8),
        children: [
          NoticeCard(tone: NoticeTone.urgent, heading: l.pregRedFlagsHeading, body: l.pregRedFlagsBody),
          const SizedBox(height: space5),
          Semantics(header: true, child: Text(l.redFlagsListHeading, style: t.titleMedium)),
          const SizedBox(height: space2),
          for (final symptom in RedFlagSymptom.values) _Bullet(text: _label(l, symptom)),
          const SizedBox(height: space5),
          Semantics(header: true, child: Text(l.learnSources, style: t.titleMedium)),
          const SizedBox(height: space2),
          for (final source in pregnancyRedFlagSources) _SourceRow(source: source),
          if (library != null) ...[
            const SizedBox(height: space5),
            _GuideLink(library: library!),
          ],
        ],
      ),
    );
  }

  /// The label of one symptom: the ARB files hold the words, this maps the enum.
  static String _label(L10n l, RedFlagSymptom symptom) => switch (symptom) {
        RedFlagSymptom.headache => l.redFlagHeadache,
        RedFlagSymptom.vision => l.redFlagVision,
        RedFlagSymptom.dizziness => l.redFlagDizziness,
        RedFlagSymptom.fever => l.redFlagFever,
        RedFlagSymptom.chestPain => l.redFlagChestPain,
        RedFlagSymptom.nausea => l.redFlagNausea,
        RedFlagSymptom.bellyPain => l.redFlagBellyPain,
        RedFlagSymptom.fluid => l.redFlagFluid,
        RedFlagSymptom.limb => l.redFlagLimb,
        RedFlagSymptom.tiredness => l.redFlagTiredness,
        RedFlagSymptom.harmThoughts => l.redFlagHarmThoughts,
        RedFlagSymptom.upperAbdomen => l.redFlagUpperAbdomen,
        RedFlagSymptom.swelling => l.redFlagSwelling,
        RedFlagSymptom.breathing => l.redFlagBreathing,
        RedFlagSymptom.bleeding => l.redFlagBleeding,
        RedFlagSymptom.movements => l.redFlagMovements,
      };
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(top: space2, end: space3),
            child: Container(width: 8, height: 8, decoration: BoxDecoration(color: p.dangerText, shape: BoxShape.circle)),
          ),
          Expanded(child: Text(text, style: t.bodyLarge)),
        ],
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.source});
  final RedFlagSource source;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: space2),
      child: Material(
        color: p.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd), side: BorderSide(color: p.border)),
        child: InkWell(
          borderRadius: BorderRadius.circular(radiusMd),
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: source.url));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.learnLinkCopied)));
          },
          child: Padding(
            padding: const EdgeInsets.all(space3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${source.name} · ${source.title}', style: t.bodyMedium),
                const SizedBox(height: spaceHalf),
                Text(source.host, style: t.bodySmall?.copyWith(color: p.textSubtle)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A row that opens the warning-signs guide in Learn, shown only once the library has
/// loaded and the guide exists.
class _GuideLink extends StatelessWidget {
  const _GuideLink({required this.library});
  final Library library;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final locale = Localizations.localeOf(context).languageCode;
    return FutureBuilder<List<Article>>(
      future: library.articles(locale),
      builder: (context, snapshot) {
        final article = snapshot.data?.where((a) => a.slug == redFlagsGuideSlug).firstOrNull;
        if (article == null) return const SizedBox.shrink();
        return Material(
          color: p.primarySoft,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
            title: Text(l.redFlagsReadGuide),
            subtitle: Text(article.title),
            trailing: Icon(Icons.chevron_right_rounded, textDirection: Directionality.of(context)),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ArticleScreen(article: article))),
          ),
        );
      },
    );
  }
}
