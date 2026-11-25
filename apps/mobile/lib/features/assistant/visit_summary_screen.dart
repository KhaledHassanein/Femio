// The visit summary: a page to show her doctor, from her own log (ADR-078, R7.3, R10.2, R8.27).
//
// Why it exists: the personas' most repeated wish is "something clear to show my doctor".
// Every line is counted by `domain/assistant/visit_summary.dart`; the questions come from the
// reviewed bank. She can add what she wants to raise (the worry card), keep it in her visit
// list (`Appointment.prep`), and send the page in her language plus one for the clinic through
// the system share sheet. Where the phone has Gemini Nano it reorders the rule-picked
// questions, on the phone; it can never add one. Nothing leaves the phone unless she shares
// or copies the text.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../data/share_channel.dart';
import '../../domain/assistant/visit_summary.dart';
import '../../domain/assistant/visit_worry.dart';
import '../../domain/dates.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/language_names.dart';
import '../../l10n/log_labels.g.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../theme/type_sizes.dart';
import 'assistant_scope.dart';
import 'visit_pack.dart';
import 'visit_worry_card.dart';

/// The screen. [today] fixes the date in tests; [initialWorry] starts the worry card from a
/// question "Ask femio" could not answer (R8.27).
class VisitSummaryScreen extends StatefulWidget {
  const VisitSummaryScreen({super.key, required this.controller, this.today, this.initialWorry});
  final FemioController controller;
  final String? today;
  final String? initialWorry;

  @override
  State<VisitSummaryScreen> createState() => _VisitSummaryScreenState();
}

class _VisitSummaryScreenState extends State<VisitSummaryScreen> {
  late final String _today = widget.today ?? todayISO();
  late final VisitSummary _summary = visitSummary(widget.controller.profile!, _today);
  late List<String> _questions = _summary.questionIds;
  bool _ordered = false;

  /// The second language for the clinic, or null for her language only.
  String? _clinic;

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

  Future<void> _add(List<String> lines, L10n l, String locale) async {
    final c = widget.controller;
    final target = visitAppointment(c.profile!, _today);
    await c.save(withVisitPrep(c.profile!, lines, _today, newId: 'a${DateTime.now().microsecondsSinceEpoch}'));
    if (!mounted) return;
    setState(() {});
    final when = target?.datetime;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(when == null
          ? l.visitWorryAddedNext
          : l.visitWorryAddedTo(DateFormat.yMMMd(locale).format(fromISO(when.substring(0, 10))))),
    ));
  }

  Future<void> _remove(String appointmentId, String line) async {
    final c = widget.controller;
    await c.save(withoutVisitPrep(c.profile!, appointmentId, line));
    if (mounted) setState(() {});
  }

  String _packText(L10n l, String locale, List<VisitLine> lines) => visitPackBoth(
        l,
        myLocale: locale,
        clinic: _clinic == null ? null : lookupL10n(Locale(_clinic!)),
        clinicLocale: _clinic,
        today: _today,
        summary: _summary,
        lines: lines,
        suggested: _questions,
      );

  Future<void> _share(L10n l, String text) async {
    if (await shareText(text, subject: 'femio · ${l.visitTitle}')) return;
    await _copy(l, text);
  }

  Future<void> _copy(L10n l, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.visitCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final profile = widget.controller.profile!;
    final visit = visitAppointment(profile, _today);
    final prep = visit?.prep ?? const <String>[];
    final mine = visitLinesFromPrep(l, prep);
    final others = suggestedNotListed(_questions, mine);
    final myLang = Localizations.localeOf(context).languageCode;

    Widget card(List<Widget> children) => Container(
          padding: const EdgeInsets.all(space4),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(radiusMd),
            border: Border.all(color: p.border),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
        );
    Widget heading(String text) => Padding(
          padding: const EdgeInsets.only(top: space4, bottom: space2),
          child: Semantics(header: true, child: Text(text, style: t.titleMedium)),
        );
    Widget numbered(int i, String text, {Widget? trailing}) => Padding(
          padding: const EdgeInsets.only(bottom: space3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${i + 1}.', style: t.titleSmall?.copyWith(color: p.primary)),
              const SizedBox(width: space2),
              Expanded(child: Text(text, style: t.bodyLarge)),
              ?trailing,
            ],
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
              VisitWorryCard(
                profile: profile,
                today: _today,
                initialWorry: widget.initialWorry,
                onAdd: (lines) => _add(lines, l, locale),
              ),
            ]),
            heading(l.visitMadeOn(DateFormat.yMMMd(locale).format(fromISO(_today)))),
            card([
              for (final f in visitFactLines(l, _summary, locale))
                Padding(padding: const EdgeInsets.only(bottom: space2), child: Text(f, style: t.bodyLarge)),
            ]),
            if (_summary.topTerms.isNotEmpty) ...[
              heading(l.visitTopTerms),
              card([
                for (final term in _summary.topTerms)
                  Padding(
                    padding: const EdgeInsets.only(bottom: space2),
                    child: Row(children: [
                      Expanded(child: Text(logLabel(l, term.key), style: t.bodyLarge)),
                      Text(l.visitDays(term.days), style: t.bodyMedium),
                    ]),
                  ),
              ]),
            ],
            if (mine.isNotEmpty) ...[
              heading(l.visitYourQuestions),
              card([
                for (final (i, line) in mine.indexed)
                  numbered(
                    i,
                    line.text(l),
                    trailing: IconButton(
                      tooltip: l.visitRemoveQuestion,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => _remove(visit!.id, prep[i]),
                    ),
                  ),
              ]),
            ],
            if (others.isNotEmpty) ...[
              heading(l.visitQuestionsTitle),
              card([for (final (i, id) in others.indexed) numbered(i, visitQuestionText(l, id))]),
            ],
            heading(l.visitSecondLanguage),
            Wrap(
              spacing: space2,
              runSpacing: space2,
              children: [
                ChoiceChip(
                  label: Text(l.visitNoSecondLanguage),
                  selected: _clinic == null,
                  onSelected: (_) => setState(() => _clinic = null),
                ),
                for (final code in nativeLanguageNames.keys)
                  if (code != myLang)
                    ChoiceChip(
                      label: Text(nativeLanguageNames[code]!),
                      selected: _clinic == code,
                      onSelected: (_) => setState(() => _clinic = code),
                    ),
              ],
            ),
            const SizedBox(height: space5),
            FilledButton.icon(
              onPressed: () => _share(l, _packText(l, locale, mine)),
              icon: const Icon(Icons.share_rounded),
              label: Text(l.visitShare),
            ),
            const SizedBox(height: space2),
            OutlinedButton.icon(
              onPressed: () => _copy(l, _packText(l, locale, mine)),
              icon: const Icon(Icons.copy_rounded),
              label: Text(l.visitCopy),
            ),
            const SizedBox(height: space4),
            Row(
              children: [
                Icon(Icons.lock_outline_rounded, size: iconSizeInline, color: p.textSubtle),
                const SizedBox(width: space1h),
                Expanded(child: Text(l.assistantPrivateNote, style: t.bodySmall)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
