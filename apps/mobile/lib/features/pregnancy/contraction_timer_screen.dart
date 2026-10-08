import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/contractions.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../widgets/notice_card.dart';

/// Contraction timer: start, stop, and the two numbers she reads out on the phone.
///
/// The maternity-unit route sits above everything, whatever the times say: the timer
/// never decides when it is "time to go" (`domain/contractions.dart`, rule 1).
class ContractionTimerScreen extends StatefulWidget {
  const ContractionTimerScreen({super.key, required this.controller, this.clock = DateTime.now});
  final FemioController controller;

  /// Injected for screenshot tests; the app reads the real clock.
  final DateTime Function() clock;

  @override
  State<ContractionTimerScreen> createState() => _ContractionTimerScreenState();
}

class _ContractionTimerScreenState extends State<ContractionTimerScreen> with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker((_) {
    final s = _elapsed();
    if (s != _shownSeconds) setState(() => _shownSeconds = s);
  });
  int? _shownSeconds;

  String _now() => widget.clock().toUtc().toIso8601String();

  List<TimedContraction> get _timed => timeContractions(widget.controller.profile!.contractions);

  int? _elapsed() {
    final running = inProgress(_timed);
    if (running == null) return null;
    final s = widget.clock().toUtc().difference(DateTime.parse(running.contraction.startedAt)).inSeconds;
    return s < 0 ? 0 : s;
  }

  void _syncTicker() {
    final running = inProgress(_timed) != null;
    if (running && !_ticker.isActive) _ticker.start();
    if (!running && _ticker.isActive) _ticker.stop();
  }

  @override
  void initState() {
    super.initState();
    _shownSeconds = _elapsed();
    _syncTicker();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    final profile = widget.controller.profile!;
    final running = inProgress(_timed);
    final now = _now();
    final next = running == null
        ? [...profile.contractions, Contraction('c${widget.clock().microsecondsSinceEpoch}', now, null)]
        : [
            for (final c in profile.contractions)
              if (c.id == running.contraction.id) c.end(now) else c,
          ];
    await widget.controller.save(profile.copyWith(contractions: next));
    setState(() => _shownSeconds = _elapsed());
    _syncTicker();
  }

  Future<void> _clear() async {
    final l = L10n.of(context);
    await widget.controller.save(widget.controller.profile!.copyWith(contractions: const []));
    _syncTicker();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.contractionsCleared)));
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final timed = _timed;
    final running = inProgress(timed) != null;
    final summary = summarize(timed);
    final locale = Localizations.localeOf(context).toLanguageTag();
    String clockTime(String iso) => DateFormat.Hm(locale).format(DateTime.parse(iso).toLocal());

    return Scaffold(
      appBar: AppBar(
        title: Text(l.contractionsHeading),
        actions: [
          if (timed.isNotEmpty && !running)
            IconButton(tooltip: l.contractionsClear, onPressed: _clear, icon: const Icon(Icons.delete_outline_rounded)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          NoticeCard(tone: NoticeTone.urgent, heading: l.contractionsContactHeading, body: l.contractionsContactBody),
          const SizedBox(height: 16),
          Text(l.contractionsIntro, style: t.bodyMedium),
          const SizedBox(height: 24),
          Center(
            child: Semantics(
              button: true,
              label: running ? l.contractionsStop : l.contractionsStart,
              excludeSemantics: true,
              child: SizedBox.square(
                dimension: 200,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: running ? p.accentSolid : p.primarySolid,
                    foregroundColor: running ? p.onAccentSolid : p.onPrimarySolid,
                  ),
                  onPressed: _toggle,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    if (running) ...[
                      Text(
                        formatDuration(_shownSeconds ?? 0),
                        textDirection: TextDirection.ltr,
                        style: t.displaySmall?.copyWith(color: p.onAccentSolid, fontFeatures: const [FontFeature.tabularFigures()]),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        running ? l.contractionsStop : l.contractionsStart,
                        textAlign: TextAlign.center,
                        style: t.titleMedium?.copyWith(color: running ? p.onAccentSolid : p.onPrimarySolid),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
          if (running) ...[
            const SizedBox(height: 8),
            Center(child: Text(l.contractionsRunning, style: t.bodySmall)),
          ],
          if (summary.counted > 0) ...[
            const SizedBox(height: 28),
            Text(l.contractionsSummaryHeading(summary.counted), style: t.titleMedium),
            const SizedBox(height: 8),
            if (summary.averageDurationSeconds != null)
              Text(l.contractionsSummaryDuration(formatDuration(summary.averageDurationSeconds!)), style: t.bodyLarge),
            if (summary.averageIntervalSeconds != null)
              Text(l.contractionsSummaryInterval(formatDuration(summary.averageIntervalSeconds!)), style: t.bodyLarge),
            const SizedBox(height: 8),
            Text(l.contractionsSummaryNote, style: t.bodySmall),
            const SizedBox(height: 16),
            for (final c in timed.reversed.take(12))
              _Row(
                time: clockTime(c.contraction.startedAt),
                length: c.durationSeconds == null ? '—' : formatDuration(c.durationSeconds!),
                apart: c.intervalSeconds == null ? '—' : formatDuration(c.intervalSeconds!),
                lengthLabel: l.contractionLength,
                apartLabel: l.contractionApart,
              ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.time,
    required this.length,
    required this.apart,
    required this.lengthLabel,
    required this.apartLabel,
  });
  final String time;
  final String length;
  final String apart;
  final String lengthLabel;
  final String apartLabel;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    Widget cell(String label, String value) => Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: t.bodySmall),
            Text(value, textDirection: TextDirection.ltr, style: t.titleMedium),
          ]),
        );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: p.border))),
      child: Row(children: [
        SizedBox(width: 72, child: Text(time, textDirection: TextDirection.ltr, style: t.titleMedium)),
        cell(lengthLabel, length),
        cell(apartLabel, apart),
      ]),
    );
  }
}
