// One day's draft inside "Say it": the date, the chips femio found, and a way to drop the day.
//
// Why it exists: a note can name several days, and each day must stay a draft she can
// correct on its own (untick a chip, remove the whole day) before anything is written to her
// record. This card is only the picture of one draft; the sheet owns the state and the save.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../domain/assistant/log_phrases.dart';
import '../../domain/assistant/say_it_days.dart';
import '../../domain/dates.dart';
import '../../domain/hijri.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/log_labels.g.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';

/// The date line of a day card: the Gregorian date in her language, with the Hijri date
/// beside it when [showHijri] is on. Empty Hijri (a date the table does not cover) is left out.
String sayItDateLine(String iso, String locale, {required bool showHijri}) {
  final gregorian = DateFormat.MMMEd(locale).format(fromISO(iso));
  final hijri = showHijri ? hijriFullDate(iso, locale) : '';
  return hijri.isEmpty ? gregorian : '$gregorian · $hijri';
}

/// A bordered card for one day's [draft]; [unticked] holds the chip ids she switched off.
class SayItDayCard extends StatelessWidget {
  const SayItDayCard({
    super.key,
    required this.date,
    required this.draft,
    required this.unticked,
    required this.showHijri,
    required this.onToggle,
    required this.onRemove,
  });

  /// ISO `YYYY-MM-DD`.
  final String date;
  final LogDraft draft;
  final Set<String> unticked;
  final bool showHijri;

  /// Called with a chip id (a term key, `flow:<level>` or `opk:<result>`) when she taps it.
  final ValueChanged<String> onToggle;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();

    Widget chip(String id, String label) => FilterChip(
      label: Text(label),
      selected: !unticked.contains(id),
      onSelected: (_) => onToggle(id),
    );

    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(space4, space2, space2, space4),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(radiusLg),
          border: Border.all(color: p.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(sayItDateLine(date, locale, showHijri: showHijri), style: t.titleSmall),
                ),
                IconButton(
                  onPressed: onRemove,
                  tooltip: l.sayItRemoveDay,
                  icon: Icon(Icons.close_rounded, color: p.textSubtle),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: space2),
              child: Wrap(
                spacing: space2,
                runSpacing: space2,
                children: [
                  if (draft.flow != null) chip(flowChipId(draft.flow!), flowLabel(l, draft.flow!)),
                  for (final term in draft.terms) chip(term, logLabel(l, term)),
                  if (draft.opk != null) chip(opkChipId(draft.opk!), opkLabel(l, draft.opk!)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
