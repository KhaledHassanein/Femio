// The Today tab: her first prediction, the moment onboarding ends, and one action.
//
// Why it exists: it is the screen she sees every day, so it stays short. Which hero to
// draw is decided in today_hero.dart, the pregnancy list in pregnancy_tools.dart; this
// file only lays out the page and handles the quick "log period today" action.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../data/profile.dart';
import '../../domain/dates.dart';
import '../../domain/pregnancy.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/type_sizes.dart';
import '../../widgets/bloom.dart';
import '../../widgets/notice_card.dart';
import 'pregnancy_tools.dart';
import 'today_hero.dart';

/// Today, v0: her first prediction, the moment onboarding ends (spec §3 step 5), and
/// one action. Every number is a range with a confidence (rule 3); nothing counts days
/// late; fertile days are awareness, never contraception (rule 1).
///
/// [controller] holds her record and must already be loaded (its profile is non-null).
/// [today] fixes the date in tests. [onLog] opens today's log (the Log tab).
class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key, required this.controller, this.today, this.onLog});
  final FemioController controller;
  final String? today;

  /// Opens today's log (the Log tab).
  final VoidCallback? onLog;

  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: controller, builder: (context, _) => _build(context));

  Widget _build(BuildContext context) {
    final profile = controller.profile!;
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final now = today ?? todayISO();
    final locale = Localizations.localeOf(context).toLanguageTag();
    String date(String iso) => DateFormat.MMMd(locale).format(fromISO(iso));
    String range(String a, String b) => l.rangeValue(date(a), date(b));

    final canLog = profile.goal != Goal.pregnant;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(space5, space3, space5, space8),
          children: [
            Row(
              children: [
                const Bloom(size: 28),
                const SizedBox(width: space2),
                Text('femio',
                    textDirection: TextDirection.ltr,
                    style: t.headlineSmall?.copyWith(color: p.primary)),
                const Spacer(),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_horiz_rounded, color: p.textMuted),
                  onSelected: (_) => controller.reset(),
                  itemBuilder: (_) => [PopupMenuItem(value: 'reset', child: Text(l.startOver))],
                ),
              ],
            ),
            const SizedBox(height: space1),
            Semantics(header: true, child: Text(l.todayTitle, style: t.headlineMedium)),
            const SizedBox(height: space4),
            TodayHero(profile: profile, today: now, range: range, date: date),
            if (profile.goal == Goal.pregnant && profile.birthDate == null) ...[
              const SizedBox(height: space3),
              Text(l.pregEstimateNote, style: t.bodySmall),
              const SizedBox(height: space4),
              NoticeCard(tone: NoticeTone.urgent, heading: l.pregRedFlagsHeading, body: l.pregRedFlagsBody),
              const SizedBox(height: space5),
              PregnancyTools(
                controller: controller,
                today: now,
                progress: profile.edd == null ? null : pregnancyProgress(profile.edd!, now),
              ),
            ],
            if (canLog) ...[
              const SizedBox(height: space4),
              FilledButton.icon(
                onPressed: () async {
                  final existing = profile.logs[now];
                  await controller.setDayLog(now, DayLog(flow: 'medium', terms: existing?.terms ?? const []));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.loggedToday)));
                  }
                },
                icon: const Icon(Icons.water_drop_rounded),
                label: Text(l.logPeriodToday),
              ),
            ],
            const SizedBox(height: space2h),
            OutlinedButton.icon(
              onPressed: onLog,
              icon: const Icon(Icons.edit_note_rounded),
              label: Text(l.logSymptomsButton),
            ),
            const SizedBox(height: space2),
            Center(
              child: Text(
                l.loggedTodayCount((profile.logs[now]?.terms.length ?? 0) + (profile.logs[now]?.flow != null ? 1 : 0)),
                style: t.bodySmall,
              ),
            ),
            const SizedBox(height: space7),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline_rounded, size: iconSizeInline, color: p.textSubtle),
                const SizedBox(width: space1h),
                Text(l.privacyLine, style: t.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
