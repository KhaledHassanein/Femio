// A table of what she logged, month by month: one row per term, one column per month, the
// number of days in each cell (R8.20).
//
// Why it exists: in perimenopause the useful view is how often each symptom came, month by
// month; the same table is on Patterns and in the visit summary. Counts only, no colour that
// grades a month.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../domain/perimenopause.dart';
import '../l10n/app_localizations.dart';
import '../l10n/log_labels.g.dart';
import '../theme/femio_theme.dart';
import '../theme/radii.dart';
import '../theme/spacing.dart';

/// Width of one month's column.
const monthColumnWidth = 40.0;

/// The month name for a `yyyy-mm` key, short, in [locale].
String monthShort(String month, String locale) => DateFormat.MMM(locale).format(DateTime.utc(
      int.parse(month.substring(0, 4)),
      int.parse(month.substring(5, 7)),
    ));

/// The table: the term on the start side, then one fixed-width column per month.
class MonthlyTermsTable extends StatelessWidget {
  const MonthlyTermsTable({super.key, required this.data});
  final MonthlyTerms data;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    Widget cell(String text, TextStyle? style) => SizedBox(
          width: monthColumnWidth,
          child: Text(text, style: style, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.fade, softWrap: false),
        );
    Widget row(String label, List<String> cells, TextStyle? style, {bool header = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: space1h),
          child: Row(children: [
            Expanded(child: Text(label, style: style)),
            for (final c in cells) cell(c, header ? t.labelSmall : style),
          ]),
        );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: space3, vertical: space2),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusMd),
        border: Border.all(color: p.border),
      ),
      child: Column(children: [
        row('', [for (final m in data.months) monthShort(m, locale)], t.labelSmall, header: true),
        for (final r in data.rows) row(logLabel(l, r.term), [for (final d in r.days) d == 0 ? '–' : '$d'], t.bodyMedium),
      ]),
    );
  }
}
