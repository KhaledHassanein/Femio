// The list of pregnancy tools under the Today hero: movements, contractions,
// appointments and weight.
//
// Why it exists: every tool is always reachable (product rule 2: personalise emphasis,
// never restrict). Only the order changes, so the contraction timer comes first late in
// pregnancy when it is the one she needs.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../domain/appointments.dart';
import '../../domain/pregnancy.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/radii.dart';
import '../pregnancy/appointments_screen.dart';
import '../pregnancy/contraction_timer_screen.dart';
import '../pregnancy/movement_log_screen.dart';
import '../pregnancy/weight_screen.dart';
import '../../domain/pregnancy_tools.dart';
import '../../widgets/preview_lines.dart';

/// The pregnancy tools, all always listed (rule 2). The order comes from
/// `domain/pregnancy_tools.dart` (contraction timer first from week 36, MR-31).
///
/// [today] is an ISO day. [progress] is null while the due date is unknown, in which
/// case the default order is used.
class PregnancyTools extends StatelessWidget {
  const PregnancyTools({super.key, required this.controller, required this.today, required this.progress});
  final FemioController controller;
  final String today;
  final PregnancyProgress? progress;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    Widget tile(IconData icon, String title, String body, Widget Function() screen) => Padding(
      padding: const EdgeInsets.only(bottom: space2h),
      child: Material(
        color: p.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(color: p.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(radiusLg),
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen())),
          child: Padding(
            padding: const EdgeInsets.all(space4h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(space2h),
                  decoration: BoxDecoration(color: p.primarySoft, shape: BoxShape.circle),
                  child: Icon(icon, color: p.primarySoftText),
                ),
                const SizedBox(width: space3h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: t.titleMedium),
                      const SizedBox(height: space1),
                      PreviewText(body, style: t.bodySmall, lines: 2),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: p.textSubtle),
              ],
            ),
          ),
        ),
      ),
    );
    final movements = tile(
      Icons.touch_app_outlined,
      l.movementsHeading,
      l.movementsIntro,
      () => MovementLogScreen(controller: controller),
    );
    final contractions = tile(
      Icons.timer_outlined,
      l.contractionsHeading,
      l.contractionsIntro,
      () => ContractionTimerScreen(controller: controller),
    );
    final next = nextAppointment(controller.profile!.appointments, today);
    final appointments = tile(
      Icons.event_note_outlined,
      l.apptTitle,
      next == null
          ? l.apptEmptyBody
          : '${next.type ?? l.apptUntitled} · ${switch (daysUntil(next, today)) {
              0 => l.apptToday,
              final d? when d > 0 => l.apptInDays(d),
              _ => l.apptNoDate,
            }}',
      () => AppointmentsScreen(controller: controller, today: today),
    );
    final weight = tile(
      Icons.monitor_weight_outlined,
      l.weightHeading,
      l.weightIntro,
      () => WeightScreen(controller: controller, today: today),
    );
    // The order is a medical rule with a fixture (MR-31); this widget only draws it.
    final byId = {'movements': movements, 'contractions': contractions, 'appointments': appointments, 'weight': weight};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(header: true, child: Text(l.pregnancyToolsTitle, style: t.titleLarge)),
        const SizedBox(height: space2h),
        for (final id in pregnancyToolOrder(progress?.weeks)) byId[id]!,
      ],
    );
  }
}
