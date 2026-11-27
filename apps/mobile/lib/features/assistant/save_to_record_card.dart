// "Save this to your record?": the calm prompt under an Ask femio answer (owner 2026-11-27).
//
// Why it exists: a question and its answer are often worth keeping for a visit, and the
// symptoms she named belong in today's log. Nothing is written until she ticks something and
// taps Save (product rule 7). The log terms come from her own question only, through the same
// phrase rules as "Say it"; the answer text is never parsed. It uses no model, so it works
// with the AI off. When the rules find no terms, only the visit note is offered.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../domain/assistant/ask_save.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/log_labels.g.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';

/// The prompt. [question] is her question as she typed it; [answerText] is the answer femio
/// showed (a summary or the first passage), or null when its sources did not cover it. [today]
/// is the ISO date whose log gets the terms. Hides itself after Save or Not now.
class SaveToRecordCard extends StatefulWidget {
  const SaveToRecordCard({
    super.key,
    required this.controller,
    required this.question,
    required this.answerText,
    required this.today,
  });
  final FemioController controller;
  final String question;
  final String? answerText;
  final String today;

  @override
  State<SaveToRecordCard> createState() => _SaveToRecordCardState();
}

class _SaveToRecordCardState extends State<SaveToRecordCard> {
  late final List<String> _terms = termsFromQuestion(widget.question);
  final Set<String> _unticked = {};
  late bool _addTerms = _terms.isNotEmpty;
  bool _keepNote = false;
  bool _saving = false;
  bool _closed = false;

  List<String> get _kept => [
    for (final t in _terms)
      if (!_unticked.contains(t)) t,
  ];

  /// What Save would write, given the ticks: used to enable the button.
  bool get _hasWork => (_addTerms && _kept.isNotEmpty) || _keepNote;

  Future<void> _save(L10n l) async {
    if (_saving || !_hasWork) return;
    setState(() => _saving = true);
    final answer = answerExcerpt(widget.answerText ?? '');
    final question = widget.question.trim();
    final line = !_keepNote
        ? null
        : (answer.isEmpty
              ? l.askSaveNoteLineNoAnswer(question)
              : l.askSaveNoteLine(question, answer));
    final c = widget.controller;
    await c.save(
      withAskSaved(
        c.profile!,
        widget.today,
        terms: _addTerms ? _kept : const [],
        noteLine: line,
        newId: 'a${DateTime.now().microsecondsSinceEpoch}',
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.askSaveDone)));
    setState(() => _closed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_closed ||
        widget.controller.profile == null ||
        widget.question.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: space4),
      child: Container(
        padding: const EdgeInsets.all(space4),
        decoration: BoxDecoration(
          color: p.surfaceSunken,
          borderRadius: BorderRadius.circular(radiusMd),
          border: Border.all(color: p.border),
        ),
        // Its own see-through Material, so the tick tiles' ink shows above the card colour.
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(l.askSaveTitle, style: t.titleMedium),
              ),
              const SizedBox(height: space1),
              Text(
                l.askSaveIntro,
                style: t.bodySmall?.copyWith(color: p.textMuted),
              ),
              if (_terms.isNotEmpty) ...[
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _addTerms,
                  onChanged: (v) => setState(() => _addTerms = v ?? false),
                  title: Text(l.askSaveTerms),
                ),
                if (_addTerms)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: space2,
                      bottom: space2,
                    ),
                    child: Wrap(
                      spacing: space2,
                      runSpacing: space2,
                      children: [
                        for (final term in _terms)
                          FilterChip(
                            label: Text(logLabel(l, term)),
                            selected: !_unticked.contains(term),
                            onSelected: (_) => setState(
                              () => _unticked.contains(term)
                                  ? _unticked.remove(term)
                                  : _unticked.add(term),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _keepNote,
                onChanged: (v) => setState(() => _keepNote = v ?? false),
                title: Text(l.askSaveNote),
                subtitle: Text(l.askSaveNoteSub),
              ),
              const SizedBox(height: space2),
              FilledButton(
                onPressed: _hasWork && !_saving ? () => _save(l) : null,
                child: Text(l.askSaveAction),
              ),
              const SizedBox(height: space1),
              TextButton(
                onPressed: () => setState(() => _closed = true),
                child: Text(l.askSaveNotNow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
