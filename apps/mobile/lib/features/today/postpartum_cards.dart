// The after-birth Today cards (R8.19): this week's recovery guide, a mood check-in, "my period
// came back", the after-birth warning signs, and "I had my baby" on the pregnancy Today.
//
// Why it exists: after birth, Today should follow her weeks, not a cycle. Every medical word
// here comes from the reviewed guides or the register (MR-50 warning signs, MR-60 the healing
// bleed): the cards choose and lay out, they never assess. A mood chip writes to her log only
// when she taps it.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/library.dart';
import '../../data/profile.dart';
import '../../domain/dates.dart';
import '../../domain/log_vocabulary.g.dart';
import '../../domain/postpartum.dart';
import '../help/help_now_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/log_labels.g.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import '../learn/article_screen.dart';
import '../log/widgets/log_chip.dart';
import '../onboarding/widgets.dart' show DateCard;

/// Opens the guide [slug] from [library] in her language, if it is there.
Future<void> openGuide(BuildContext context, Library library, String slug) async {
  final locale = Localizations.localeOf(context).languageCode;
  final list = await library.articles(locale);
  final article = list.where((a) => a.slug == slug).firstOrNull;
  if (article == null || !context.mounted) return;
  await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ArticleScreen(article: article)));
}

/// The after-birth part of Today, between the hero and the log buttons.
class PostpartumToday extends StatelessWidget {
  const PostpartumToday({super.key, required this.controller, required this.library, required this.today});
  final FemioController controller;
  final Library library;
  final String today;

  @override
  Widget build(BuildContext context) {
    final profile = controller.profile!;
    final weeks = weeksSinceBirth(profile.birthDate!, today);
    final guide = recoveryGuideFor(weeks);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (guide != null) ...[
        const SizedBox(height: space4),
        _GuideCard(key: ValueKey(guide), library: library, slug: guide),
      ],
      const SizedBox(height: space4),
      _MoodCard(controller: controller, library: library, today: today),
      const SizedBox(height: space4),
      _PeriodBackCard(controller: controller, today: today),
    ]);
  }
}

/// The after-birth warning signs (MR-50), at the bottom of Today like the other notices.
class PostpartumWarningCard extends StatelessWidget {
  const PostpartumWarningCard({super.key, required this.library});
  final Library library;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      NoticeCard(tone: NoticeTone.urgent, heading: l.safetyPostpartumHeading, body: l.safetyPostpartumBody),
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: TextButton(onPressed: () => openGuide(context, library, postpartumWarningGuide), child: Text(l.ppWarnMore)),
      ),
    ]);
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(space4h),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusLg),
        border: Border.all(color: p.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

/// This week's reviewed guide: its title and summary, and a link to read it.
class _GuideCard extends StatefulWidget {
  const _GuideCard({super.key, required this.library, required this.slug});
  final Library library;
  final String slug;

  @override
  State<_GuideCard> createState() => _GuideCardState();
}

class _GuideCardState extends State<_GuideCard> {
  Future<List<Article>>? _articles;
  String? _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).languageCode;
    if (locale != _locale) {
      _locale = locale;
      _articles = widget.library.articles(locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return FutureBuilder<List<Article>>(
      future: _articles,
      builder: (context, snap) {
        final article = snap.data?.where((a) => a.slug == widget.slug).firstOrNull;
        if (article == null) return const SizedBox.shrink();
        return _Card(children: [
          Text(l.ppGuideEyebrow, style: t.labelLarge?.copyWith(color: p.primary)),
          const SizedBox(height: space1h),
          Text(article.title, style: t.titleMedium),
          const SizedBox(height: space1h),
          Text(article.excerpt, style: t.bodyMedium),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ArticleScreen(article: article))),
              icon: const Icon(Icons.menu_book_outlined, size: 18),
              label: Text(l.ppRead),
            ),
          ),
        ]);
      },
    );
  }
}

/// "How are you feeling today?": the log's mood words as chips for today, and the
/// two-weeks note from the reviewed mood guide.
class _MoodCard extends StatelessWidget {
  const _MoodCard({required this.controller, required this.library, required this.today});
  final FemioController controller;
  final Library library;
  final String today;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final log = controller.profile!.logs[today] ?? const DayLog();
    Future<void> toggle(String key) {
      final terms = [for (final k in log.terms) if (k != key) k, if (!log.terms.contains(key)) key];
      return controller.setDayLog(today, log.copyWith(terms: terms));
    }

    return _Card(children: [
      Text(l.ppMoodTitle, style: t.titleMedium),
      const SizedBox(height: space2),
      Wrap(spacing: space2, runSpacing: space2, children: [
        for (final term in logTerms)
          if (term.dimension == LogDimension.mood)
            LogChip(
              label: logLabel(l, term.key),
              selected: log.terms.contains(term.key),
              tint: p.logMoodAlt,
              ink: p.logMood,
              onTap: () => toggle(term.key),
            ),
      ]),
      const SizedBox(height: space3),
      Text(l.ppMoodNote, style: t.bodySmall),
      // CLIN-11 / MR-50: the mood check-in names the one sign that needs help now.
      const SizedBox(height: space2),
      Text(l.ppMoodCrisis, style: t.bodySmall?.copyWith(color: context.palette.dangerText)),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const HelpNowScreen())),
          child: Text(l.helpNowLauncher),
        ),
      ),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton(onPressed: () => openGuide(context, library, postpartumMoodGuide), child: Text(l.ppMoodGuide)),
      ),
    ]);
  }
}

/// "Has your period come back?": she says when, and what femio helps with now.
class _PeriodBackCard extends StatelessWidget {
  const _PeriodBackCard({required this.controller, required this.today});
  final FemioController controller;
  final String today;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    return _Card(children: [
      Text(l.ppPeriodBack, style: t.titleMedium),
      const SizedBox(height: space1h),
      Text(l.ppPeriodBackBody, style: t.bodyMedium),
      const SizedBox(height: space2),
      OutlinedButton.icon(
        onPressed: () => showPeriodBackSheet(context, controller, today),
        icon: const Icon(Icons.water_drop_outlined),
        label: Text(l.ppPeriodBackAction),
      ),
    ]);
  }
}

/// The sheet: a calendar from the birth to today, then the two goals.
Future<void> showPeriodBackSheet(BuildContext context, FemioController controller, String today) {
  final birth = controller.profile!.birthDate!;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _PickDaySheet(
      title: L10n.of(context).ppPeriodBackPick,
      first: birth,
      today: today,
      actions: (day) => [
        Text(L10n.of(context).ppNextGoal, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: space2),
        for (final goal in const [Goal.period, Goal.ttc])
          Padding(
            padding: const EdgeInsets.only(bottom: space2),
            child: FilledButton(
              onPressed: day == null
                  ? null
                  : () async {
                      await controller.periodCameBack(day, goal);
                      if (context.mounted) Navigator.of(context).pop();
                    },
              child: Text(goal == Goal.period ? L10n.of(context).goalPeriod : L10n.of(context).goalTtc),
            ),
          ),
      ],
    ),
  );
}

/// "I had my baby" on the pregnancy Today: a calendar for the birth day, then save.
class HadBabyButton extends StatelessWidget {
  const HadBabyButton({super.key, required this.controller, required this.today});
  final FemioController controller;
  final String today;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton.icon(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => _PickDaySheet(
            title: l.birthDateTitle,
            note: l.ppHadBabyNote,
            first: addDays(today, -recordBirthMaxDaysAgo),
            today: today,
            actions: (day) => [
              FilledButton(
                onPressed: day == null
                    ? null
                    : () async {
                        await controller.recordBirth(day);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                child: Text(MaterialLocalizations.of(context).saveButtonLabel),
              ),
            ],
          ),
        ),
        icon: const Icon(Icons.child_friendly_outlined, size: 18),
        label: Text(l.ppHadBaby),
      ),
    );
  }
}

/// A sheet with a tap-a-day calendar from [first] to [today] and [actions] for the day picked.
class _PickDaySheet extends StatefulWidget {
  const _PickDaySheet({required this.title, required this.first, required this.today, required this.actions, this.note});
  final String title;
  final String? note;
  final String first;
  final String today;
  final List<Widget> Function(String? day) actions;

  @override
  State<_PickDaySheet> createState() => _PickDaySheetState();
}

class _PickDaySheetState extends State<_PickDaySheet> {
  String? _day;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(space5, 0, space5, space5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(widget.title, style: t.titleLarge),
          if (widget.note != null) ...[
            const SizedBox(height: space1h),
            Text(widget.note!, style: t.bodyMedium),
          ],
          const SizedBox(height: space3),
          DateCard(
            first: fromISO(widget.first),
            last: fromISO(widget.today),
            selected: _day == null ? null : fromISO(_day!),
            onChanged: (d) => setState(() => _day = toISO(d)),
          ),
          const SizedBox(height: space4),
          ...widget.actions(_day),
        ]),
      ),
    );
  }
}
