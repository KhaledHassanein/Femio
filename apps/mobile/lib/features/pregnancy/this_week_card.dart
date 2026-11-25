// The pregnancy "This week" card and the week sheet (R8.6, R9.1).
//
// Why it exists: the week guides are reviewed, cited and translated; the card brings the
// current one to Today, one section at a time, with a daily line drawn from it. Every word
// on the card is the guide's own (rule 1); the card adds only the week number and the
// section names. The Calendar's week strip opens the same view for any week.

import 'package:flutter/material.dart';

import '../../data/library.dart';
import '../../data/week_guide.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../learn/article_screen.dart';

/// The section's name on the chip.
String weekSectionLabel(L10n l, WeekSection s) => switch (s) {
      WeekSection.baby => l.weekSecBaby,
      WeekSection.body => l.weekSecBody,
      WeekSection.notice => l.weekSecNotice,
      WeekSection.care => l.weekSecCare,
      WeekSection.tip => l.weekSecTip,
    };

/// Chip order on the card: the baby first, as every pregnancy app leads, then her body.
const _chipOrder = [WeekSection.baby, WeekSection.body, WeekSection.notice, WeekSection.care, WeekSection.tip];

/// The card for guide [week]. With [totalDays] (her day in the pregnancy) it adds the daily
/// line (R9.1); the week sheet leaves it out.
class ThisWeekCard extends StatefulWidget {
  const ThisWeekCard({super.key, required this.library, required this.week, this.totalDays, this.current = true});
  final Library library;
  final int week;
  final int? totalDays;

  /// Whether [week] is her week now ("This week") or one she opened from the calendar.
  final bool current;

  @override
  State<ThisWeekCard> createState() => _ThisWeekCardState();
}

class _ThisWeekCardState extends State<ThisWeekCard> {
  Future<WeekGuide?>? _guide;
  String? _locale;
  WeekSection _section = WeekSection.baby;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).languageCode;
    if (locale != _locale) {
      _locale = locale;
      _guide = loadWeekGuide(widget.library, locale, widget.week);
    }
  }

  @override
  void didUpdateWidget(ThisWeekCard old) {
    super.didUpdateWidget(old);
    if (old.week != widget.week) _guide = loadWeekGuide(widget.library, _locale!, widget.week);
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return FutureBuilder<WeekGuide?>(
      future: _guide,
      builder: (context, snap) {
        final g = snap.data;
        if (g == null) return const SizedBox.shrink();
        final line = widget.totalDays == null ? null : g.dailyLine(widget.totalDays!);
        final paragraphs = g.sections[_section] ?? const <String>[];
        return Semantics(
          container: true,
          child: Container(
            padding: const EdgeInsets.all(space4),
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(radiusLg),
              border: Border.all(color: p.border),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.current ? l.thisWeekTitle(g.week) : l.weekGuideTitle(g.week), style: t.titleMedium),
              if (line != null) ...[
                const SizedBox(height: space2),
                Container(
                  padding: const EdgeInsetsDirectional.only(start: space3),
                  decoration: BoxDecoration(
                    border: BorderDirectional(start: BorderSide(color: p.primary, width: 3)),
                  ),
                  child: Text(line, style: t.bodyLarge),
                ),
              ],
              const SizedBox(height: space3),
              Wrap(spacing: space2, runSpacing: space2, children: [
                for (final s in _chipOrder)
                  ChoiceChip(
                    label: Text(weekSectionLabel(l, s)),
                    selected: _section == s,
                    onSelected: (_) => setState(() => _section = s),
                  ),
              ]),
              const SizedBox(height: space3),
              for (final para in paragraphs) ...[
                Text(para, style: t.bodyMedium),
                const SizedBox(height: space2),
              ],
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => ArticleScreen(article: g.article)),
                  ),
                  child: Text(l.weekReadFull(g.week)),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

/// Opens [week]'s guide card in a sheet, from the Calendar's week strip.
Future<void> showWeekSheet(BuildContext context, {required Library library, required int week, bool current = false}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: .75,
        maxChildSize: .95,
        builder: (context, scroll) => SingleChildScrollView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(space5, 0, space5, space6),
          child: ThisWeekCard(library: library, week: week, current: current),
        ),
      ),
    );
