// The visit summary: a page to show her doctor, from her own log (ADR-078, R7.3).
//
// Why it exists: the personas' most repeated wish is "something clear to show my doctor".
// Every line is counted by `domain/assistant/visit_summary.dart`; the questions come from the
// reviewed bank. Where the phone has Gemini Nano it reorders the rule-picked questions for her,
// on the phone; it can never add one. Nothing leaves the phone unless she copies the text.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../data/profile.dart';
import '../../domain/assistant/visit_summary.dart';
import '../../domain/dates.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/log_labels.g.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../theme/type_sizes.dart';
import 'assistant_scope.dart';
import 'catalogue_text.g.dart';

/// The reviewed wording of question [id] in her language.
String visitQuestionText(L10n l, String id) => switch (id) {
  'cycleSpread' => l.visitQ_cycleSpread,
  'ttcTests' => l.visitQ_ttcTests,
  'ovulation' => l.visitQ_ovulation,
  'folicAcid' => l.visitQ_folicAcid,
  'painfulPeriods' => l.visitQ_painfulPeriods,
  'heavyPeriods' => l.visitQ_heavyPeriods,
  'moodCycle' => l.visitQ_moodCycle,
  'skinHair' => l.visitQ_skinHair,
  'tiredness' => l.visitQ_tiredness,
  'menopause' => l.visitQ_menopause,
  'pregnancyNext' => l.visitQ_pregnancyNext,
  'pregnancyMovements' => l.visitQ_pregnancyMovements,
  _ => catalogueQuestionText(l, id) ?? l.visitQ_anythingElse,
};

String _tryingLabel(L10n l, TryingFor f) => switch (f) {
  TryingFor.justStarted => l.tryingJustStarted,
  TryingFor.under6 => l.tryingUnder6,
  TryingFor.sixTo12 => l.trying6to12,
  TryingFor.over12 => l.tryingOver12,
};

/// The screen. [today] fixes the date in tests.
class VisitSummaryScreen extends StatefulWidget {
  const VisitSummaryScreen({super.key, required this.controller, this.today});
  final FemioController controller;
  final String? today;

  @override
  State<VisitSummaryScreen> createState() => _VisitSummaryScreenState();
}

class _VisitSummaryScreenState extends State<VisitSummaryScreen> {
  late final VisitSummary _summary = visitSummary(
    widget.controller.profile!,
    widget.today ?? todayISO(),
  );
  late List<String> _questions = _summary.questionIds;
  bool _ordered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_ordered) _orderOnDevice();
  }

  Future<void> _orderOnDevice() async {
    _ordered = true;
    final order = (await AssistantScope.gatewayOf(context).orderVisitQuestions(_summary)).value;
    if (order == null || !mounted) return;
    setState(() => _questions = reorderQuestions(_summary.questionIds, order));
  }

  /// The facts as lines, used both on screen and in the copied text.
  List<String> _facts(L10n l, String locale) {
    final s = _summary;
    return [
      s.cyclesObserved == 0
          ? l.visitCycles(0, 0, 0)
          : l.visitCycles(s.cyclesObserved, s.longestCycle!, s.shortestCycle!),
      if (s.lastPeriodStart != null)
        l.visitLastPeriod(
          DateFormat.yMMMd(locale).format(fromISO(s.lastPeriodStart!)),
        ),
      if (s.irregular) l.visitIrregular,
      if (s.tryingFor != null)
        '${l.visitTryingFor}: ${_tryingLabel(l, s.tryingFor!)}',
      if (s.heavyDays > 0) '${l.visitHeavyDays}: ${s.heavyDays}',
      if (s.positiveOvulationTests > 0)
        '${l.visitOpkPositive}: ${s.positiveOvulationTests}',
      if (s.temperatureDays > 0)
        '${l.visitTemperatureDays}: ${s.temperatureDays}',
    ];
  }

  String _asText(L10n l, String locale) => [
    'femio · ${l.visitTitle}',
    ..._facts(l, locale),
    if (_summary.topTerms.isNotEmpty) ...[
      '',
      l.visitTopTerms,
      for (final term in _summary.topTerms)
        '- ${logLabel(l, term.key)}: ${l.visitDays(term.days)}',
    ],
    '',
    l.visitQuestionsTitle,
    for (final (i, id) in _questions.indexed)
      '${i + 1}. ${visitQuestionText(l, id)}',
  ].join('\n');

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();

    Widget card(List<Widget> children) => Container(
      padding: const EdgeInsets.all(space4),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusMd),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.visitTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(space5, space3, space5, space8),
          children: [
            Text(l.visitIntro, style: t.bodyMedium),
            const SizedBox(height: space4),
            card([
              for (final f in _facts(l, locale))
                Padding(
                  padding: const EdgeInsets.only(bottom: space2),
                  child: Text(f, style: t.bodyLarge),
                ),
            ]),
            if (_summary.topTerms.isNotEmpty) ...[
              const SizedBox(height: space4),
              Semantics(
                header: true,
                child: Text(l.visitTopTerms, style: t.titleMedium),
              ),
              const SizedBox(height: space2),
              card([
                for (final term in _summary.topTerms)
                  Padding(
                    padding: const EdgeInsets.only(bottom: space2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            logLabel(l, term.key),
                            style: t.bodyLarge,
                          ),
                        ),
                        Text(l.visitDays(term.days), style: t.bodyMedium),
                      ],
                    ),
                  ),
              ]),
            ],
            const SizedBox(height: space4),
            Semantics(
              header: true,
              child: Text(l.visitQuestionsTitle, style: t.titleMedium),
            ),
            const SizedBox(height: space2),
            card([
              for (final (i, id) in _questions.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: space3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${i + 1}.',
                        style: t.titleSmall?.copyWith(color: p.primary),
                      ),
                      const SizedBox(width: space2),
                      Expanded(
                        child: Text(
                          visitQuestionText(l, id),
                          style: t.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
            ]),
            const SizedBox(height: space5),
            FilledButton.icon(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: _asText(l, locale)),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(l.visitCopied)));
                }
              },
              icon: const Icon(Icons.copy_rounded),
              label: Text(l.visitCopy),
            ),
            const SizedBox(height: space4),
            Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: iconSizeInline,
                  color: p.textSubtle,
                ),
                const SizedBox(width: space1h),
                Expanded(
                  child: Text(l.assistantPrivateNote, style: t.bodySmall),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
