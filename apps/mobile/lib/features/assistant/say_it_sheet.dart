// "Say it in your words": a sentence becomes log entries, on the phone (ADR-078, R7.3).
//
// Why it exists: tapping through forty chips is the reason people stop logging. She types (or
// dictates with her keyboard) one sentence in any of the four languages; femio's phrase rules
// read it, Gemini Nano adds what the rules missed when the phone has it, and she confirms the
// chips before anything is saved. Her sentence itself is never stored or sent.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/profile.dart';
import '../../domain/assistant/log_phrases.dart';
import '../../domain/assistant/prompts.dart';
import '../../domain/assistant/safety.dart';
import '../../domain/dates.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/log_labels.g.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/type_sizes.dart';
import 'assistant_scope.dart';
import 'safety_notice.dart';

/// Opens the sheet for the day [date] in [controller]'s record.
Future<void> showSayItSheet(BuildContext context, {required FemioController controller, required String date}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SayItSheet(controller: controller, date: date),
    );

/// The sheet's content. Public for widget tests and screenshots.
class SayItSheet extends StatefulWidget {
  const SayItSheet({super.key, required this.controller, required this.date});
  final FemioController controller;
  final String date;

  @override
  State<SayItSheet> createState() => _SayItSheetState();
}

class _SayItSheetState extends State<SayItSheet> {
  final _text = TextEditingController();
  bool _busy = false;
  bool _usedModel = false;
  SafetySignal _signal = SafetySignal.none;
  LogDraft? _draft;
  final Set<String> _unticked = {};

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _read() async {
    final note = _text.text.trim();
    if (note.isEmpty) return;
    final profile = widget.controller.profile;
    setState(() {
      _busy = true;
      _signal = profile == null ? safetySignal(note, pregnant: false) : safetySignalFor(note, profile, todayISO());
      _draft = null;
      _unticked.clear();
      _usedModel = false;
    });
    var draft = draftFromNote(note);
    final bridge = AssistantScope.of(context);
    final status = await bridge.status();
    if (status.canRunPrivate) {
      final reply = await bridge.runPrivate(extractionPrompt(note));
      if (reply != null) {
        final s = parseExtraction(reply);
        final merged = mergeDrafts(draft, modelTerms: s.terms, modelFlow: s.flow, modelOpk: s.opk);
        _usedModel = merged.terms.length != draft.terms.length || merged.flow != draft.flow || merged.opk != draft.opk;
        draft = merged;
      }
    }
    if (!mounted) return;
    setState(() {
      _busy = false;
      _draft = draft;
    });
  }

  Future<void> _add() async {
    final d = _draft!;
    final profile = widget.controller.profile!;
    final log = profile.logs[widget.date] ?? const DayLog();
    final keep = [
      for (final t in d.terms)
        if (!_unticked.contains(t)) t,
    ];
    final flow = d.flow != null && !_unticked.contains('flow:${d.flow}') ? d.flow : log.flow;
    final opk = d.opk != null && !_unticked.contains('opk:${d.opk}') ? d.opk : log.opk;
    await widget.controller.setDayLog(
      widget.date,
      log.copyWith(terms: {...log.terms, ...keep}.toList(), flow: flow, opk: opk),
    );
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final added = L10n.of(context).sayItAdded;
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(added)));
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final d = _draft;

    Widget chip(String id, String label) => FilterChip(
      label: Text(label),
      selected: !_unticked.contains(id),
      onSelected: (on) => setState(() => on ? _unticked.remove(id) : _unticked.add(id)),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(space5, 0, space5, MediaQuery.viewInsetsOf(context).bottom + space5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(header: true, child: Text(l.sayItTitle, style: t.titleLarge)),
            const SizedBox(height: space3),
            TextField(
              controller: _text,
              minLines: 2,
              maxLines: 4,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _read(),
              decoration: InputDecoration(hintText: l.sayItHint, border: const OutlineInputBorder()),
            ),
            const SizedBox(height: space3),
            FilledButton.icon(
              onPressed: _busy ? null : _read,
              icon: _busy
                  ? const SizedBox.square(dimension: iconSizeInline, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.auto_awesome_rounded),
              label: Text(l.sayItAction),
            ),
            if (_signal != SafetySignal.none) ...[const SizedBox(height: space4), SafetyNotice(signal: _signal)],
            if (d != null && d.isEmpty) ...[const SizedBox(height: space4), Text(l.sayItNothing, style: t.bodyMedium)],
            if (d != null && !d.isEmpty) ...[
              const SizedBox(height: space4),
              Text(l.sayItFound, style: t.bodyMedium),
              const SizedBox(height: space2),
              Wrap(
                spacing: space2,
                runSpacing: space2,
                children: [
                  if (d.flow != null) chip('flow:${d.flow}', flowLabel(l, d.flow!)),
                  for (final term in d.terms) chip(term, logLabel(l, term)),
                  if (d.opk != null) chip('opk:${d.opk}', opkLabel(l, d.opk!)),
                ],
              ),
              const SizedBox(height: space3),
              FilledButton(onPressed: _add, child: Text(l.sayItAdd)),
            ],
            const SizedBox(height: space4),
            Row(
              children: [
                Icon(Icons.lock_outline_rounded, size: iconSizeInline, color: p.textSubtle),
                const SizedBox(width: space1h),
                Expanded(
                  child: Text(
                    _usedModel ? '${l.assistantPrivateNote} ${l.assistantModelNote}' : l.assistantPrivateNote,
                    style: t.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
