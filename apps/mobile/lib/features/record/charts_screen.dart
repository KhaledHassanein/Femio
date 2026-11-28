// "Charts": a chart for everything she has logged at least twice (R11.5).
//
// Why it exists: her record holds blood pressure, glucose and lab results. Two or more
// readings of the same thing, in the same unit, become a chart here, with the dates under
// it and the readings listed. femio draws her numbers and nothing else (rules 1 and 3): the
// x-axis is the day each reading happened, units stay as she entered them, the only band is
// the range printed on her own lab report, and there are no verdict words or colour for
// "good" and "bad". The geometry lives in `domain/record_charts.dart`; this file only lays
// it out. Weight already charts on its own screen, so it is linked rather than redrawn.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/bidi_text.dart';
import '../../domain/dates.dart';
import '../../domain/record_charts.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import '../../widgets/readings_chart.dart';
import '../pregnancy/weight_screen.dart';
import 'record_editor.dart';
import 'record_labels.dart';

/// Opens the Charts list.
void openCharts(BuildContext context, FemioController controller, String today) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ChartsScreen(controller: controller, today: today)),
    );

/// Every series with at least two readings, then a link to the weight chart when she has one.
class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key, required this.controller, required this.today});
  final FemioController controller;
  final String today;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final profile = controller.profile!;
        final series = buildChartSeries(profile.record);
        final weights = profile.weights.length;
        return Scaffold(
          appBar: AppBar(title: Text(l.chartTitle)),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(space5, space2, space5, space8),
            children: [
              Text(l.chartIntro, style: t.bodyMedium),
              const SizedBox(height: space4),
              if (series.isEmpty && weights < chartMinReadings)
                NoticeCard(tone: NoticeTone.quiet, heading: l.chartEmptyHeading, body: l.chartEmptyBody)
              else ...[
                for (final s in series) ...[
                  _SeriesCard(series: s, controller: controller, today: today),
                  const SizedBox(height: space4),
                ],
                if (weights >= chartMinReadings)
                  _LinkCard(
                    icon: Icons.monitor_weight_outlined,
                    title: l.weightHeading,
                    subtitle: l.chartReadingsCount(weights),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => WeightScreen(controller: controller, today: today)),
                    ),
                  ),
              ],
              const SizedBox(height: space4),
              Text(l.chartNote, style: t.bodySmall),
            ],
          ),
        );
      },
    );
  }
}

/// The title of [s] in her language: blood pressure and glucose are named by the app, a lab
/// by her own words. The unit is part of the title so two units are never mistaken for one.
String _seriesTitle(L10n l, ChartSeries s) => switch (s.kind) {
      ChartKind.bloodPressure => '${l.chartKindBloodPressure} · ${s.unit}',
      ChartKind.glucose => '${l.chartKindGlucose} · ${isolateText(s.unit)}',
      ChartKind.lab => s.unit.isEmpty ? isolateText(s.title) : '${isolateText(s.title)} · ${isolateText(s.unit)}',
    };

class _SeriesCard extends StatelessWidget {
  const _SeriesCard({required this.series, required this.controller, required this.today});
  final ChartSeries series;
  final FemioController controller;
  final String today;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    String day(String iso) => DateFormat.yMMMd(locale).format(fromISO(iso));
    final s = series;
    final first = s.readings.first.day;
    final last = s.readings.last.day;
    final title = _seriesTitle(l, s);
    final textDir = Directionality.of(context);
    final newestFirst = s.readings.reversed.toList();
    return Container(
      padding: const EdgeInsets.all(space4h),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusLg),
        border: Border.all(color: p.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: t.titleMedium),
        const SizedBox(height: space2h),
        ReadingsChart(
          ys: s.ys,
          xs: s.xs,
          ys2: s.kind == ChartKind.bloodPressure ? s.ys2 : null,
          band: s.bandY,
          low: s.axisLow,
          high: s.axisHigh,
          unit: '',
          decimals: s.axisDecimals,
          semanticsLabel: l.chartSemantics(title, s.readings.length, day(first), day(last)),
        ),
        const SizedBox(height: space1h),
        // The date axis runs oldest to newest, left to right, like the numbers beside it.
        Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.only(left: readingsChartAxisInset, right: space2),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(day(first), style: t.bodySmall, textDirection: textDir),
              if (first != last) Text(day(last), style: t.bodySmall, textDirection: textDir),
            ]),
          ),
        ),
        const SizedBox(height: space2),
        if (s.kind == ChartKind.bloodPressure) Text(l.chartBpLegend, style: t.bodySmall),
        if (s.band != null) Text(l.chartBandNote, style: t.bodySmall),
        const SizedBox(height: space2),
        for (final r in newestFirst)
          InkWell(
            borderRadius: BorderRadius.circular(radiusSm),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => RecordEditor(
                controller: controller,
                today: today,
                initialKind: r.entry.kind,
                existing: r.entry,
              ),
            )),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: space1h),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: chartDateColumn, child: Text(day(r.day), style: t.bodySmall)),
                Expanded(child: Text(recordSummary(r.entry, l: l), style: t.bodyMedium)),
              ]),
            ),
          ),
      ]),
    );
  }
}

/// Width of the date beside each reading, enough for "Nov 28, 2026".
const double chartDateColumn = 112;

class _LinkCard extends StatelessWidget {
  const _LinkCard({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Material(
      color: p.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg), side: BorderSide(color: p.border)),
      child: InkWell(
        borderRadius: BorderRadius.circular(radiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(space4h),
          child: Row(children: [
            Icon(icon, color: p.primary),
            const SizedBox(width: space3),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: t.titleMedium),
                Text(subtitle, style: t.bodySmall),
              ]),
            ),
            Icon(Icons.chevron_right_rounded, color: p.textSubtle),
          ]),
        ),
      ),
    );
  }
}
