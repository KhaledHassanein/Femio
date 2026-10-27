// The baby-movement log: a tap for each movement and her own recent pattern.
//
// Why it exists: knowing her usual pattern is what lets her notice a change. It sets no
// target and never calls a count normal; the call-now notice always comes first.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/movements.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';

/// Movement log: she taps for each movement she feels and sees her own pattern.
///
/// No target and no "done" (`domain/movements.dart`): the "less than usual, call now"
/// notice is the first thing on the screen, before and during a session, and a change
/// from her own pattern is surfaced without being interpreted (rule 1, ADR-049).
class MovementLogScreen extends StatelessWidget {
  const MovementLogScreen({super.key, required this.controller, this.clock = DateTime.now});
  final FemioController controller;

  /// Injected for screenshot tests; the app reads the real clock.
  final DateTime Function() clock;

  String _now() => clock().toUtc().toIso8601String();

  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: controller, builder: (context, _) => _build(context));

  Widget _build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final profile = controller.profile!;
    final sessions = profile.movements;
    final open = sessions.isNotEmpty && sessions.last.endedAt == null ? sessions.last : null;
    final finished = [for (final s in sessions.reversed) if (s != open) s];
    final pattern = comparePattern(finished);
    final locale = Localizations.localeOf(context).toLanguageTag();
    String when(String iso) => DateFormat.MMMd(locale).add_Hm().format(DateTime.parse(iso).toLocal());

    Future<void> replaceOpen(MovementSession next) => controller.save(profile.copyWith(movements: [
          for (final s in sessions) if (s == open) next else s,
        ]));

    return Scaffold(
      appBar: AppBar(title: Text(l.movementsHeading)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(space5, space2, space5, space8),
        children: [
          NoticeCard(tone: NoticeTone.urgent, heading: l.movementsUrgentHeading, body: l.movementsUrgentBody),
          const SizedBox(height: space4),
          Text(l.movementsIntro, style: t.bodyMedium),
          const SizedBox(height: space6),
          if (open == null) ...[
            Text(l.movementsStartBody, style: t.bodyMedium),
            const SizedBox(height: space3),
            FilledButton.icon(
              onPressed: () => controller.save(profile.copyWith(movements: [
                ...sessions,
                MovementSession('m${clock().microsecondsSinceEpoch}', _now(), null, 0),
              ])),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(l.movementsStart),
            ),
          ] else ...[
            Center(
              child: SizedBox.square(
                dimension: 200,
                child: FilledButton(
                  style: FilledButton.styleFrom(shape: const CircleBorder(), backgroundColor: p.primarySolid),
                  onPressed: () => replaceOpen(
                    MovementSession(open.id, open.startedAt, null, (open.movementCount ?? 0) + 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(space5),
                    child: Text(l.movementsTap,
                        textAlign: TextAlign.center, style: t.titleMedium?.copyWith(color: p.onPrimarySolid)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: space3),
            Center(child: Text(l.movementsCounted(open.movementCount ?? 0), style: t.titleMedium)),
            const SizedBox(height: space4),
            OutlinedButton(
              onPressed: () => replaceOpen(MovementSession(open.id, open.startedAt, _now(), open.movementCount)),
              child: Text(l.movementsFinish),
            ),
            const SizedBox(height: space1h),
            Center(child: Text(l.movementsFinishNote, style: t.bodySmall, textAlign: TextAlign.center)),
          ],
          const SizedBox(height: space7),
          switch (pattern) {
            ComparablePattern(slower: true) => NoticeCard(
                tone: NoticeTone.caution,
                heading: l.movementsSlowerHeading,
                body: l.movementsSlowerBody,
              ),
            InsufficientPattern() => Text(l.movementsNeedMore('$minSessionsForPattern'), style: t.bodySmall),
            _ => const SizedBox.shrink(),
          },
          if (finished.isNotEmpty) ...[
            const SizedBox(height: space5),
            Text(l.movementsRecentHeading, style: t.titleMedium),
            const SizedBox(height: space2),
            for (final s in finished.take(10))
              Container(
                padding: const EdgeInsets.symmetric(vertical: space2h),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: p.border))),
                child: Row(children: [
                  Expanded(child: Text(when(s.startedAt), style: t.bodyMedium)),
                  Text(
                    switch (minutesPerMovement(s)) {
                      null => s.endedAt == null ? l.movementsUnfinished : l.movementsCounted(s.movementCount ?? 0),
                      final m => l.movementsSessionSummary(s.movementCount!, _minutes(m)),
                    },
                    style: t.bodyMedium,
                  ),
                ]),
              ),
          ],
        ],
      ),
    );
  }
}

/// One decimal under ten minutes, whole minutes above: precise enough to compare,
/// not so precise it reads as a measurement she should match.
String _minutes(double m) => m < 10 ? m.toStringAsFixed(1) : m.round().toString();
