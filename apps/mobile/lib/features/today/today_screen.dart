import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../data/profile.dart';
import '../../domain/appointments.dart';
import '../../domain/bbt.dart';
import '../../domain/cycle_prediction.dart';
import '../../domain/dates.dart';
import '../../domain/fertility.dart';
import '../../domain/pregnancy.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../widgets/bbt_chart.dart';
import '../../widgets/bloom.dart';
import '../../widgets/notice_card.dart';
import '../pregnancy/appointments_screen.dart';
import '../pregnancy/contraction_timer_screen.dart';
import '../pregnancy/movement_log_screen.dart';
import '../pregnancy/weight_screen.dart';

/// Today, v0: her first prediction, the moment onboarding ends (spec §3 step 5), and
/// one action. Every number is a range with a confidence (rule 3); nothing counts days
/// late; fertile days are awareness, never contraception (rule 1).
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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Row(
              children: [
                const Bloom(size: 28),
                const SizedBox(width: 8),
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
            const SizedBox(height: 4),
            Semantics(header: true, child: Text(l.todayTitle, style: t.headlineMedium)),
            const SizedBox(height: 16),
            _Hero(profile: profile, today: now, range: range, date: date),
            if (profile.goal == Goal.pregnant && profile.birthDate == null) ...[
              const SizedBox(height: 12),
              Text(l.pregEstimateNote, style: t.bodySmall),
              const SizedBox(height: 16),
              NoticeCard(tone: NoticeTone.urgent, heading: l.pregRedFlagsHeading, body: l.pregRedFlagsBody),
              const SizedBox(height: 20),
              _PregnancyTools(controller: controller, today: now, progress: profile.edd == null ? null : pregnancyProgress(profile.edd!, now)),
            ],
            if (canLog) ...[
              const SizedBox(height: 16),
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
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: onLog,
              icon: const Icon(Icons.edit_note_rounded),
              label: Text(l.logSymptomsButton),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                l.loggedTodayCount((profile.logs[now]?.terms.length ?? 0) + (profile.logs[now]?.flow != null ? 1 : 0)),
                style: t.bodySmall,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline_rounded, size: 16, color: p.textSubtle),
                const SizedBox(width: 6),
                Text(l.privacyLine, style: t.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.profile, required this.today, required this.range, required this.date});
  final Profile profile;
  final String today;
  final String Function(String, String) range;
  final String Function(String) date;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final onHero = Colors.white;

    Widget card({required String eyebrow, required String headline, List<Widget> extra = const []}) =>
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [p.auroraGround, p.primarySolid, p.accentSolid],
              stops: const [0, 0.6, 1],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eyebrow.toUpperCase(), style: t.labelMedium?.copyWith(color: onHero.withValues(alpha: 0.85))),
              const SizedBox(height: 8),
              Text(headline, style: t.displaySmall?.copyWith(color: onHero, fontSize: 32)),
              ...extra,
            ],
          ),
        );
    Widget line(String text) => Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(text, style: t.bodyMedium?.copyWith(color: onHero.withValues(alpha: 0.92))),
        );
    Widget note(String text) => Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: p.border)),
          child: Text(text, style: t.bodySmall),
        );

    String confidence(Confidence c) => switch (c) {
          Confidence.low => l.confidenceLow,
          Confidence.medium => l.confidenceMedium,
          Confidence.high => l.confidenceHigh,
        };

    switch (profile.goal) {
      case Goal.period:
      case Goal.ttc:
        final prediction = predictNextPeriod(profile.periodStarts, profile.cycleLength);
        if (prediction == null) {
          return Column(children: [
            card(eyebrow: l.predictionPeriodTitle, headline: l.noPredictionTitle, extra: [line(l.noPredictionBody)]),
            if (profile.irregular) note(l.irregularNote),
          ]);
        }
        final period = range(prediction.windowStart, prediction.windowEnd);
        final extra = <Widget>[
          line(confidence(prediction.confidence)),
          if (prediction.basis == 'stated') line(l.basisStated),
          const SizedBox(height: 18),
          _CycleBand(lastStart: profile.periodStarts.last, prediction: prediction, today: today),
        ];
        if (profile.goal == Goal.period) {
          return card(eyebrow: l.predictionPeriodTitle, headline: period, extra: extra);
        }
        final fertile = fertileWindowBefore(prediction.predictedStart);
        final age = profile.birthYear == null ? null : fromISO(today).year - profile.birthYear!;
        final longTrying = profile.tryingFor == TryingFor.over12 ||
            (profile.tryingFor == TryingFor.sixTo12 && (age ?? 0) >= 35);
        return Column(children: [
          card(
            eyebrow: l.predictionFertileTitle,
            headline: range(fertile.windowStart, fertile.windowEnd),
            extra: [
              line(l.predictionOvulation(date(fertile.ovulation))),
              line(l.predictionNextPeriod(period)),
              ...extra,
            ],
          ),
          note(l.awarenessNote),
          if (longTrying) note(l.seeClinicianTtc),
          const SizedBox(height: 12),
          _TestTiming(prediction: prediction, date: date),
          const SizedBox(height: 12),
          BbtChartCard(chart: _cycleBbt(profile)),
        ]);

      case Goal.pregnant:
        if (profile.birthDate != null) {
          final weeks = diffDays(profile.birthDate!, today) ~/ 7;
          return card(eyebrow: l.goalPregnant, headline: l.postpartumWeeks(weeks < 0 ? 0 : weeks));
        }
        final progress = profile.edd == null ? null : pregnancyProgress(profile.edd!, today);
        if (progress == null) {
          return card(eyebrow: l.goalPregnant, headline: l.dueDateTitle);
        }
        return card(
          eyebrow: l.trimesterLabel(progress.trimester),
          headline: l.pregnancyWeek(progress.weeks, progress.days),
          extra: [
            line(l.dueDateLabel(date(profile.edd!))),
            line(progress.overdue
                ? l.pregOverdue(-progress.daysUntilDue)
                : l.pregDaysToGo(progress.daysUntilDue)),
            line(l.pregTermFrom(date(progress.termStart))),
            const SizedBox(height: 18),
            _PregnancyBar(totalDays: progress.totalDays),
          ],
        );

      case Goal.menopause:
        if (profile.periodStarts.isEmpty) {
          return card(eyebrow: l.goalMenopause, headline: l.menoMonths(profile.lastPeriodOverYear ? 12 : 0),
              extra: [line(l.menoUnknown)]);
        }
        final months = diffDays(profile.periodStarts.last, today) ~/ 30;
        return card(eyebrow: l.goalMenopause, headline: l.menoMonths(months), extra: [line(l.menoUnknown)]);
    }
  }
}

/// From her last period to the predicted window, with today marked. The window is
/// drawn soft (rule 3): a band, never a ring and never a single tick.
class _CycleBand extends StatelessWidget {
  const _CycleBand({required this.lastStart, required this.prediction, required this.today});
  final String lastStart;
  final CyclePrediction prediction;
  final String today;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final span = diffDays(lastStart, prediction.windowEnd).clamp(1, 120);
    double at(String iso) => (diffDays(lastStart, iso) / span).clamp(0.0, 1.0);
    return ExcludeSemantics(
      child: LayoutBuilder(builder: (context, c) {
        final w = c.maxWidth;
        final rtl = Directionality.of(context) == TextDirection.rtl;
        double x(double f) => rtl ? w * (1 - f) : w * f;
        final a = x(at(prediction.windowStart));
        final b = x(at(prediction.windowEnd));
        return SizedBox(
          height: 18,
          child: Stack(children: [
            Positioned.fill(
              top: 6,
              bottom: 6,
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), borderRadius: BorderRadius.circular(9)),
              ),
            ),
            Positioned(
              left: a < b ? a : b,
              width: (a - b).abs().clamp(8, w),
              top: 4,
              bottom: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  gradient: LinearGradient(colors: [
                    p.predictionBand.withValues(alpha: 0.35),
                    p.predictionBand,
                    p.predictionBand.withValues(alpha: 0.35),
                  ]),
                ),
              ),
            ),
            Positioned(
              left: x(at(today)) - 9,
              top: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: p.primarySolid, width: 3),
                ),
              ),
            ),
          ]),
        );
      }),
    );
  }
}

class _PregnancyBar extends StatelessWidget {
  const _PregnancyBar({required this.totalDays});
  final int totalDays;

  @override
  Widget build(BuildContext context) {
    final f = (totalDays / gestationDays).clamp(0.0, 1.0);
    return ExcludeSemantics(
      child: LayoutBuilder(builder: (context, c) {
        final w = c.maxWidth;
        final rtl = Directionality.of(context) == TextDirection.rtl;
        Widget seg(int flex, double alpha) => Expanded(
              flex: flex,
              child: Container(
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: alpha), borderRadius: BorderRadius.circular(4)),
              ),
            );
        return SizedBox(
          height: 18,
          child: Stack(alignment: Alignment.centerLeft, children: [
            Row(children: [seg(14, 0.55), seg(14, 0.4), seg(12, 0.28)]),
            Positioned(
              left: (rtl ? 1 - f : f) * w - 9,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          ]),
        );
      }),
    );
  }
}

/// Temperatures since her last period started: the current cycle's chart.
BbtChart? _cycleBbt(Profile profile) {
  final starts = bleedStarts(profile.periodStarts);
  final since = starts.isEmpty ? null : starts.last;
  return bbtChart([
    for (final e in profile.logs.entries)
      if (e.value.bbt != null && (since == null || e.key.compareTo(since) >= 0))
        BbtEntry(e.key, e.key, e.value.bbt!),
  ], since);
}

/// NHS timing (`calculators/index.ts` `pregnancyTestFromPeriod`): most tests work from the
/// first day of a missed period. With a range, the end of the window is the honest
/// "missed" day: testing earlier is what produces false negatives.
class _TestTiming extends StatelessWidget {
  const _TestTiming({required this.prediction, required this.date});
  final CyclePrediction prediction;
  final String Function(String) date;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: p.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.science_outlined, color: p.primary),
          const SizedBox(width: 8),
          Text(l.testTimingTitle, style: t.titleMedium),
        ]),
        const SizedBox(height: 8),
        Text(
          prediction.irregular ? l.testTimingGeneral : l.testTimingBody(date(prediction.windowEnd)),
          style: t.bodyMedium,
        ),
        const SizedBox(height: 6),
        Text(l.testTimingSource, style: t.bodySmall),
      ]),
    );
  }
}

/// The pregnancy tools, both always listed (rule 2). From 36 weeks the contraction
/// timer comes first: emphasis changes, access does not.
class _PregnancyTools extends StatelessWidget {
  const _PregnancyTools({required this.controller, required this.today, required this.progress});
  final FemioController controller;
  final String today;
  final PregnancyProgress? progress;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    Widget tile(IconData icon, String title, String body, Widget Function() screen) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: p.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: p.border),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen())),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: p.primarySoft, shape: BoxShape.circle),
                    child: Icon(icon, color: p.primarySoftText),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(title, style: t.titleMedium),
                      const SizedBox(height: 4),
                      Text(body, style: t.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ]),
                  ),
                  Icon(Icons.chevron_right_rounded, color: p.textSubtle),
                ]),
              ),
            ),
          ),
        );
    final movements = tile(Icons.touch_app_outlined, l.movementsHeading, l.movementsIntro,
        () => MovementLogScreen(controller: controller));
    final contractions = tile(Icons.timer_outlined, l.contractionsHeading, l.contractionsIntro,
        () => ContractionTimerScreen(controller: controller));
    final next = nextAppointment(controller.profile!.appointments, today);
    final appointments = tile(
      Icons.event_note_outlined,
      l.apptTitle,
      next == null ? l.apptEmptyBody : '${next.type ?? l.apptUntitled} · ${switch (daysUntil(next, today)) {
          0 => l.apptToday,
          final d? when d > 0 => l.apptInDays(d),
          _ => l.apptNoDate,
        }}',
      () => AppointmentsScreen(controller: controller, today: today),
    );
    final weight = tile(Icons.monitor_weight_outlined, l.weightHeading, l.weightIntro,
        () => WeightScreen(controller: controller, today: today));
    final late = (progress?.weeks ?? 0) >= 36;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Semantics(header: true, child: Text(l.pregnancyToolsTitle, style: t.titleLarge)),
      const SizedBox(height: 10),
      ...late ? [contractions, movements] : [movements, contractions],
      appointments,
      weight,
    ]);
  }
}
