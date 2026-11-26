// "Signs by cycle day": her bleeding, waking temperature, ovulation tests and discharge for one
// cycle, one column per day, side by side (R8.8).
//
// Why it exists: she reads these signs together, by cycle day, and across cycles. The days
// come from `domain/cycle_sign_days.dart`; this screen only draws them. It never marks a
// temperature shift, an ovulation day or a fertile verdict (MR-16, MR-17, rule 1): the
// temperature row is her dots, and the MR-16 strip sentence shows whenever a test is drawn.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../data/profile.dart';
import '../../domain/bidi_text.dart';
import '../../domain/cycle_sign_days.dart';
import '../../domain/dates.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/log_labels.g.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';

/// Width of one day's column.
const signColumnWidth = 34.0;

/// Height of the temperature row.
const signTempHeight = 120.0;

/// Height of the bleeding, test and discharge rows.
const signRowHeight = 32.0;

/// Width of the row labels at the start.
const signLabelWidth = 48.0;

/// Opens the screen on the cycle that holds [day] (default: the latest cycle).
void openSignsByDay(BuildContext context, Profile profile, String today, {String? day}) => Navigator.of(context).push(
  MaterialPageRoute<void>(builder: (_) => SignsByDayScreen(profile: profile, today: today, day: day)),
);

/// The screen. [profile] is read only; [today] is her ISO day.
class SignsByDayScreen extends StatefulWidget {
  const SignsByDayScreen({super.key, required this.profile, required this.today, this.day});
  final Profile profile;
  final String today;
  final String? day;

  @override
  State<SignsByDayScreen> createState() => _SignsByDayScreenState();
}

class _SignsByDayScreenState extends State<SignsByDayScreen> {
  late final List<SignCycle> _cycles = signCycles(widget.profile, widget.today);
  late int _index = _initialIndex();
  String? _selected;

  int _initialIndex() {
    final held = widget.day == null ? null : cycleHolding(_cycles, widget.day!);
    return held == null ? _cycles.length - 1 : _cycles.indexOf(held);
  }

  void _go(int by) => setState(() {
        _index += by;
        _selected = null;
      });

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_cycles.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l.signsDaysTitle)),
        body: Padding(padding: const EdgeInsets.all(space5), child: Text(l.signsDaysNoCycle, style: t.bodyLarge)),
      );
    }
    final data = signDays(widget.profile, _cycles[_index]);
    final cycle = data.cycle;
    final start = DateFormat.yMMMd(locale).format(fromISO(cycle.start));
    final selected = data.days.where((d) => d.day == (_selected ?? _lastSign(data))).firstOrNull;
    return Scaffold(
      appBar: AppBar(title: Text(l.signsDaysTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(space5, space2, space5, space10),
        children: [
          Row(children: [
            IconButton(
              tooltip: l.signsDaysEarlier,
              onPressed: _index > 0 ? () => _go(-1) : null,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Expanded(
              child: Text(
                cycle.complete ? l.signsDaysPast(start, l.patDays(cycle.days)) : l.signsDaysCurrent(start),
                style: t.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              tooltip: l.signsDaysLater,
              onPressed: _index < _cycles.length - 1 ? () => _go(1) : null,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ]),
          const SizedBox(height: space3),
          if (!data.hasSigns)
            Text(l.signsDaysEmpty, style: t.bodyMedium)
          else ...[
            _Grid(data: data, selected: selected?.day, onTap: (d) => setState(() => _selected = d)),
            const SizedBox(height: space2),
            Text(l.signsDaysHint, style: t.bodySmall),
            const SizedBox(height: space4),
            if (selected != null) _DayDetail(day: selected, unit: data.chart?.unit),
            const SizedBox(height: space4),
            if (data.temperatures > 0 && data.chart == null) ...[
              Text(l.bbtChartNeedData, style: t.bodySmall),
              const SizedBox(height: space2),
            ],
            Text(l.signsDaysFill, style: t.bodySmall),
            const SizedBox(height: space2),
            if (data.hasOpk) ...[
              Text(l.signsStripLine, style: t.bodySmall),
              const SizedBox(height: space2),
            ],
            if (data.chart != null) ...[
              Text(l.bbtChartNote, style: t.bodySmall),
              const SizedBox(height: space2),
            ],
          ],
          Text(l.signsNote, style: t.bodySmall),
        ],
      ),
    );
  }

  /// The last day of the cycle she logged a sign on, so the detail opens on something.
  String? _lastSign(SignCycleDays data) => data.days.lastWhere((d) => d.hasSign, orElse: () => data.days.last).day;
}

/// The day columns, scrolled to the selected day, with the row labels pinned at the start.
class _Grid extends StatefulWidget {
  const _Grid({required this.data, required this.selected, required this.onTap});
  final SignCycleDays data;
  final String? selected;
  final ValueChanged<String> onTap;

  @override
  State<_Grid> createState() => _GridState();
}

class _GridState extends State<_Grid> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reveal());
  }

  @override
  void didUpdateWidget(_Grid old) {
    super.didUpdateWidget(old);
    if (old.data.cycle.start != widget.data.cycle.start) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _reveal());
    }
  }

  void _reveal() {
    if (!_scroll.hasClients) return;
    final i = widget.data.days.indexWhere((d) => d.day == widget.selected);
    final view = _scroll.position.viewportDimension;
    final target = ((i < 0 ? 0 : i) + 1) * signColumnWidth - view + signColumnWidth * 2;
    _scroll.jumpTo(target.clamp(0.0, _scroll.position.maxScrollExtent));
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final chart = widget.data.chart;
    String temp(double v) => isolateText(v.toStringAsFixed(1));
    Widget label(IconData icon, String text, double height) => SizedBox(
          height: height,
          child: Semantics(
            label: text,
            child: Center(child: Icon(icon, size: 20, color: p.textSubtle)),
          ),
        );
    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusMd),
        border: Border.all(color: p.border),
      ),
      padding: const EdgeInsets.symmetric(vertical: space2),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          width: signLabelWidth,
          child: Column(children: [
            SizedBox(
              height: signRowHeight,
              child: Center(child: Text('#', style: t.labelSmall, semanticsLabel: l.signsDaysCycleDay)),
            ),
            label(Icons.water_drop_rounded, l.signsDaysBleeding, signRowHeight),
            SizedBox(
              height: signTempHeight,
              child: Semantics(
                label: l.sectionTemperature,
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(chart == null ? '' : temp(chart.high), style: t.labelSmall),
                  Icon(Icons.thermostat_rounded, size: 20, color: p.textSubtle),
                  Text(chart == null ? '' : temp(chart.low), style: t.labelSmall),
                ]),
              ),
            ),
            label(Icons.science_outlined, l.sectionOvulationTest, signRowHeight),
            label(Icons.opacity_rounded, l.sectionDischarge, signRowHeight),
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scroll,
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (final d in widget.data.days)
                _DayColumn(day: d, selected: d.day == widget.selected, onTap: () => widget.onTap(d.day)),
            ]),
          ),
        ),
      ]),
    );
  }
}

/// One day: its number, then a mark per sign. Tapping selects it.
class _DayColumn extends StatelessWidget {
  const _DayColumn({required this.day, required this.selected, required this.onTap});
  final SignDay day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    Widget mark(Color color, double fill, {bool round = true}) => Center(
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: round ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: round ? null : BorderRadius.circular(radiusXs),
              border: Border.all(color: color, width: 1.5),
              color: Color.lerp(p.surface, color, fill),
            ),
          ),
        );
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: signColumnWidth,
          color: selected ? p.primarySoft : null,
          child: Column(children: [
            SizedBox(
              height: signRowHeight,
              child: Center(child: Text('${day.cycleDay}', style: t.labelSmall)),
            ),
            SizedBox(height: signRowHeight, child: day.bleeding ? mark(p.logPeriod, 1) : null),
            SizedBox(
              height: signTempHeight,
              child: CustomPaint(painter: _TempPainter(y: day.bbtY, dot: p.chart1, grid: p.chartGrid)),
            ),
            SizedBox(height: signRowHeight, child: day.opk == null ? null : mark(p.accent, opkFill(day.opk!), round: false)),
            SizedBox(
              height: signRowHeight,
              child: day.discharge.isEmpty ? null : mark(p.logDischarge, dischargeFill(day.discharge)),
            ),
          ]),
        ),
      ),
    );
  }
}

/// A day's temperature dot at its height in the cycle's scale, over a faint middle line.
class _TempPainter extends CustomPainter {
  const _TempPainter({required this.y, required this.dot, required this.grid});
  final double? y;
  final Color dot;
  final Color grid;

  static const _inset = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), Paint()..color = grid);
    final v = y;
    if (v == null) return;
    final h = size.height - _inset * 2;
    canvas.drawCircle(Offset(size.width / 2, _inset + h * (1 - v)), 5, Paint()..color = dot);
  }

  @override
  bool shouldRepaint(_TempPainter old) => old.y != y || old.dot != dot || old.grid != grid;
}

/// What she logged on the selected day, in words.
class _DayDetail extends StatelessWidget {
  const _DayDetail({required this.day, required this.unit});
  final SignDay day;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final u = switch (unit) { 'c' => ' °C', 'f' => ' °F', _ => '' };
    Widget line(String label, String value) => Padding(
          padding: const EdgeInsets.only(top: space1h),
          child: Text('$label: $value', style: t.bodyMedium),
        );
    return Container(
      padding: const EdgeInsets.all(space4),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusMd),
        border: Border.all(color: p.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.signsDaysDay(day.cycleDay, DateFormat.yMMMd(locale).format(fromISO(day.day))), style: t.titleSmall),
        if (day.isEmpty)
          Padding(padding: const EdgeInsets.only(top: space1h), child: Text(l.signsDaysNothing, style: t.bodyMedium)),
        if (day.bleeding) line(l.signsDaysBleeding, day.flow == null ? l.signsDaysLogged : flowLabel(l, day.flow!)),
        if (day.bbt != null) line(l.sectionTemperature, isolateText('${day.bbt!.toStringAsFixed(2)}$u')),
        if (day.opk != null) line(l.sectionOvulationTest, opkLabel(l, day.opk!)),
        if (day.discharge.isNotEmpty) line(l.sectionDischarge, day.discharge.map((k) => logLabel(l, k)).join(l.listSeparator)),
      ]),
    );
  }
}

