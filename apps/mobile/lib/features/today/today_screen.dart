// The Today tab: her first prediction, the moment onboarding ends, and one action.
//
// Why it exists: it is the screen she sees every day, so it stays short. Which hero to
// draw is decided in today_hero.dart, the pregnancy list in pregnancy_tools.dart; this
// file only lays out the page and handles the quick "log period today" action.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../data/library.dart';
import '../../data/profile.dart';
import '../../domain/dates.dart';
import '../../domain/pregnancy.dart';
import '../../domain/pregnancy_calendar.dart' show firstGuideWeek, lastGuideWeek;
import '../../domain/absent_period.dart';
import '../../domain/pregnancy_end.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/type_sizes.dart';
import '../../widgets/bloom.dart';
import '../../widgets/notice_card.dart';
import '../assistant/ai_status_chip.dart';
import '../assistant/assistant_pill.dart' show AssistantDoor, openAssistantDoor;
import '../help/help_now_screen.dart';
import '../help/red_flags_screen.dart';
import '../pregnancy/this_week_card.dart';
import 'stage_cards.dart';
import '../settings/settings_screen.dart';
import '../../widgets/tab_header.dart';
import '../record/medicines_screen.dart';
import '../../domain/assistant/safety.dart' show postpartumWarningDays;
import '../../domain/perimenopause.dart';
import 'postpartum_cards.dart';
import 'pregnancy_tools.dart';
import 'tips_card.dart';
import '../calendar/forecast_gap.dart' show showCycleLengthSheet;
import 'today_hero.dart';

/// Today, v0: her first prediction, the moment onboarding ends (spec §3 step 5), and
/// one action. Every number is a range with a confidence (rule 3); nothing counts days
/// late; fertile days are awareness, never contraception (rule 1).
///
/// [controller] holds her record and must already be loaded (its profile is non-null).
/// [today] fixes the date in tests. [onLog] opens today's log (the Log tab).
class TodayScreen extends StatelessWidget {
  const TodayScreen({
    super.key,
    required this.controller,
    this.today,
    this.onLog,
    this.library,
  });
  final FemioController controller;

  /// The guides, for the link at the foot of the warning-signs screen. Optional so
  /// tests of Today need no assets.
  final Library? library;
  final String? today;

  /// Opens today's log (the Log tab).
  final VoidCallback? onLog;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => _build(context),
  );

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
          padding: const EdgeInsets.fromLTRB(space5, space3, space5, fabClearance),
          children: [
            Row(
              children: [
                const Bloom(size: 28),
                const SizedBox(width: space2),
                Text(
                  'femio',
                  textDirection: TextDirection.ltr,
                  style: t.headlineSmall?.copyWith(color: p.primary),
                ),
                const Spacer(),
                HelpNowButton(color: p.dangerText),
                IconButton(
                  tooltip: l.settingsTitle,
                  icon: Icon(Icons.settings_outlined, color: p.textMuted),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SettingsScreen(controller: controller),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: space1),
            Semantics(
              header: true,
              child: Text(l.todayTitle, style: t.headlineMedium),
            ),
            // Owner 2026-11-27: the stage femio follows is always visible, and one tap changes it.
            StageRow(controller: controller, today: now),
            // R14.6: where the AI runs, and the one-sentence log, in the first screen.
            const SizedBox(height: space2),
            AiStatusChip(controller: controller),
            if (profile.settings.assistantOn && canLog) ...[
              const SizedBox(height: space3),
              SayItBar(
                onTap: () => openAssistantDoor(context, AssistantDoor.sayIt,
                    controller: controller, today: now, library: library),
              ),
            ],
            const SizedBox(height: space4),
            if (!profile.settings.storageNoticeSeen) ...[
              // Shown once, instead of a consent step: there is nothing to consent to
              // because nothing leaves the phone (03_LEGAL_PACK §5, §7 row 21).
              NoticeCard(
                tone: NoticeTone.quiet,
                heading: l.firstRunStorageTitle,
                body: l.firstRunStorageNotice,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => controller.setSettings(
                    profile.settings.copyWith(storageNoticeSeen: true),
                  ),
                  child: Text(l.dismiss),
                ),
              ),
              const SizedBox(height: space2),
            ],
            TodayHero(
              profile: profile,
              today: now,
              range: range,
              date: date,
              onAddLength: () => showCycleLengthSheet(context, controller),
            ),
            if (profile.goal == Goal.ttc) PregnantNowButton(controller: controller),
            // MR-35: after a pregnancy ended, what femio changed and when to get help.
            if (showAfterLoss(profile, now)) ...[
              const SizedBox(height: space3),
              const AfterLossCard(),
            ],
            // MR-10 (CLIN-9): a long gap gets a calm next step, never a count.
            if (periodAbsentFor(profile, now)) ...[
              const SizedBox(height: space3),
              NoticeCard(tone: NoticeTone.caution, heading: l.absentTitle, body: '${l.absentBody}\n\n${l.absentSource}'),
            ],
            if (profile.goal == Goal.pregnant && profile.birthDate == null) ...[
              const SizedBox(height: space3),
              Text(l.pregEstimateNote, style: t.bodySmall),
              const SizedBox(height: space4),
              PregnancyTools(
                controller: controller,
                today: now,
                progress: profile.edd == null
                    ? null
                    : pregnancyProgress(profile.edd!, now),
              ),
              // R8.6/R9.1: this week's reviewed guide, one section at a time, and a daily line.
              if (profile.edd != null)
                if (pregnancyProgress(profile.edd!, now) case final progress?
                    when progress.weeks >= firstGuideWeek && progress.weeks <= lastGuideWeek) ...[
                  const SizedBox(height: space4),
                  ThisWeekCard(
                    key: ValueKey('week-${progress.weeks}'),
                    library: library ?? Library(),
                    week: progress.weeks,
                    totalDays: progress.totalDays,
                  ),
                ],
              // R8.19: the way into the after-birth stage.
              const SizedBox(height: space2),
              HadBabyButton(controller: controller, today: now),
              PregnancyEndedButton(controller: controller, today: now),
            ],
            // R8.20, MR-61: bleeding after a year without periods always needs a doctor.
            if (bleedAfterYear(profile, now) != null) ...[
              const SizedBox(height: space4),
              NoticeCard(
                tone: NoticeTone.caution,
                heading: l.menoBleedHeading,
                body: l.menoBleedBody,
                icon: Icons.medical_services_outlined,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => openGuide(context, library ?? Library(), postmenopausalBleedingGuide),
                  child: Text(l.menoBleedMore),
                ),
              ),
            ],
            // R8.19: the after-birth stage follows her weeks since the birth.
            if (profile.isPostpartum) PostpartumToday(controller: controller, library: library ?? Library(), today: now),
            if (canLog) ...[
              const SizedBox(height: space4),
              FilledButton.icon(
                onPressed: () async {
                  final existing = profile.logs[now];
                  // copyWith keeps the rest of the day (temperature, test, note).
                  await controller.setDayLog(now, (existing ?? const DayLog()).copyWith(flow: 'medium'));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(l.loggedToday)));
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
                l.loggedTodayCount(
                  (profile.logs[now]?.terms.length ?? 0) +
                      (profile.logs[now]?.flow != null ? 1 : 0),
                ),
                style: t.bodySmall,
              ),
            ),
            // ADR-078, R14.6: the assistant's doors, through the same first-use sheet as "+".
            // Both work with the AI off (rules and guides answer, product rule 7).
            const SizedBox(height: space4),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => openAssistantDoor(context, AssistantDoor.ask,
                        controller: controller, today: now, library: library),
                    icon: const Icon(Icons.auto_stories_rounded),
                    label: Text(l.askTitle),
                  ),
                ),
                const SizedBox(width: space2),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => openAssistantDoor(context, AssistantDoor.visit,
                        controller: controller, today: now, library: library),
                    icon: const Icon(Icons.assignment_outlined),
                    label: Text(l.visitButton),
                  ),
                ),
              ],
            ),
            // R11.6: the doses still to mark today, only when she set times on a medicine.
            MedicinesTodayCard(controller: controller, today: now),
            const SizedBox(height: space4),
            TipsCard(controller: controller, today: now),
            const SizedBox(height: space7),
            // R8.2 (owner 2026-11-24): the two notices sit at the bottom, under the dashboard,
            // the log and the tips. Help now also stays in the header on every tab (MR-38).
            if (profile.goal == Goal.pregnant && profile.birthDate == null) ...[
              const SizedBox(height: space4),
              NoticeCard(
                tone: NoticeTone.urgent,
                heading: l.pregRedFlagsHeading,
                body: l.pregRedFlagsBody,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => RedFlagsScreen(library: library),
                    ),
                  ),
                  child: Text(l.pregRedFlagsMore),
                ),
              ),
            ] else ...[
              // MR-50: in the year after a recorded birth, the after-birth warning signs.
              if (profile.birthDate != null && diffDays(profile.birthDate!, now) <= postpartumWarningDays)
                PostpartumWarningCard(library: library ?? Library())
              else
                NoticeCard(
                  tone: NoticeTone.urgent,
                  heading: l.pregRedFlagsHeading,
                  body: l.todayUrgentBody,
                ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const HelpNowScreen(),
                    ),
                  ),
                  child: Text(l.helpNowLauncher),
                ),
              ),
            ],
            const SizedBox(height: space4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: iconSizeInline,
                  color: p.textSubtle,
                ),
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
