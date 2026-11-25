// The due-date tool: "when is my baby due?" from whatever she knows (R13.1).
//
// Why it exists: onboarding asks for one date once and saves it; this screen lets her
// try any method (last period with her cycle length, conception, an IVF transfer, a
// dating scan) without saving anything, the way the website's calculator does. The
// arithmetic is `dueDateFrom` (MR-23, MR-24, MR-53); this file only draws it.

import 'package:flutter/material.dart';

import '../../domain/dates.dart';
import '../../domain/due_date.dart';
import '../../domain/pregnancy.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import '../onboarding/widgets.dart';
import 'tool_widgets.dart';

/// How far back a starting date can be: past 300 days no pregnancy is still running.
const _lookbackDays = 300;

/// The way she knows the date, as the chips show it (IVF splits by embryo age below).
enum _Way { lmp, conception, transfer, scan }

/// Which embryo age an IVF transfer used.
enum _Embryo { day3, day5 }

/// The due-date tool. [today] is injectable for tests; it defaults to the device day.
class DueDateToolScreen extends StatefulWidget {
  const DueDateToolScreen({super.key, this.today});
  final String? today;

  @override
  State<DueDateToolScreen> createState() => _DueDateToolScreenState();
}

class _DueDateToolScreenState extends State<DueDateToolScreen> {
  late final String _today = widget.today ?? todayISO();
  _Way _way = _Way.lmp;
  _Embryo _embryo = _Embryo.day5;
  String? _date;
  int _cycle = dueTypicalCycle;
  int _scanWeeks = scanDefaultWeeks;
  int _scanDays = 0;

  DueDateMethod get _method => switch (_way) {
        _Way.lmp => DueDateMethod.lmp,
        _Way.conception => DueDateMethod.conception,
        _Way.transfer => _embryo == _Embryo.day3 ? DueDateMethod.transfer3 : DueDateMethod.transfer5,
        _Way.scan => DueDateMethod.scan,
      };

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final p = context.palette;
    final prompt = switch (_way) {
      _Way.lmp => l.toolPromptLmp,
      _Way.conception => l.toolPromptConception,
      _Way.transfer => l.toolPromptTransfer,
      _Way.scan => l.toolPromptScan,
    };
    final result = _date == null
        ? null
        : dueDateFrom(_method, _date!, cycleLength: _cycle, scanWeeks: _scanWeeks, scanDays: _scanDays);
    final progress = result == null ? null : pregnancyProgress(result.edd, _today);

    return Scaffold(
      appBar: AppBar(title: Text(l.toolDueTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(space5, space2, space5, space8),
        children: [
          Text(l.toolNothingSaved, style: t.bodySmall?.copyWith(color: p.textMuted)),
          const SizedBox(height: space4),
          ToolChoice<_Way>(
            label: l.toolDueMethodLabel,
            options: {
              _Way.lmp: l.toolDueMethodLmp,
              _Way.conception: l.toolDueMethodConception,
              _Way.transfer: l.toolDueMethodTransfer,
              _Way.scan: l.toolDueMethodScan,
            },
            value: _way,
            onChanged: (w) => setState(() {
              _way = w;
              _date = null;
            }),
          ),
          if (_way == _Way.transfer) ...[
            const SizedBox(height: space4),
            ToolChoice<_Embryo>(
              label: l.toolEmbryoLabel,
              options: {_Embryo.day3: l.toolEmbryo3, _Embryo.day5: l.toolEmbryo5},
              value: _embryo,
              onChanged: (e) => setState(() => _embryo = e),
            ),
          ],
          const SizedBox(height: space5),
          Text(prompt, style: t.titleSmall),
          const SizedBox(height: space2),
          DateCard(
            key: ValueKey(_way),
            first: fromISO(addDays(_today, -_lookbackDays)),
            last: fromISO(_today),
            selected: _date == null ? null : fromISO(_date!),
            onChanged: (d) => setState(() => _date = toISO(d)),
          ),
          const SizedBox(height: space3),
          if (_way == _Way.lmp)
            ToolStepper(
              label: l.toolCycleLabel,
              valueLabel: l.toolDays(_cycle),
              value: _cycle,
              min: dueMinCycle,
              max: dueMaxCycle,
              onChanged: (v) => setState(() => _cycle = v),
            ),
          if (_way == _Way.scan) ...[
            ToolStepper(
              label: l.toolScanWeeksLabel,
              valueLabel: l.toolWeeks(_scanWeeks),
              value: _scanWeeks,
              min: scanMinWeeks,
              max: scanMaxWeeks,
              onChanged: (v) => setState(() => _scanWeeks = v),
            ),
            const SizedBox(height: space2),
            ToolStepper(
              label: l.toolScanDaysLabel,
              valueLabel: l.toolDays(_scanDays),
              value: _scanDays,
              min: 0,
              max: scanMaxExtraDays,
              onChanged: (v) => setState(() => _scanDays = v),
            ),
          ],
          if (result != null) ...[
            const SizedBox(height: space5),
            ToolResult(
              headline: l.dueDateLabel(toolDate(context, result.edd)),
              lines: [
                l.toolTermWindow(toolDate(context, result.termStart), toolDate(context, result.termEnd)),
                if (progress != null) l.pregnancyWeek(progress.weeks, progress.days),
              ],
              children: [HijriLine(iso: result.edd)],
            ),
            ToolNote(l.toolEstimateNote),
            ToolNote(_way == _Way.scan ? l.toolScanNote : l.toolClinicianAdjust),
            const SizedBox(height: space4),
            NoticeCard(tone: NoticeTone.urgent, heading: l.pregRedFlagsHeading, body: l.pregRedFlagsBody),
          ],
        ],
      ),
    );
  }
}
