// "What do you want to raise at this visit?": her worry in, reviewed questions out (R10.2).
//
// Why it exists: she knows what bothers her but not always how to ask it in a ten-minute
// visit. `domain/assistant/visit_worry.dart` runs the safety rules first, then finds reviewed
// questions that fit; this card shows them as choices and saves only what she ticks, after
// she taps "Add to your visit". Works with the AI off: no model is involved.

import 'package:flutter/material.dart';

import '../../data/library.dart';
import '../../data/profile.dart';
import '../../domain/assistant/safety.dart';
import '../../domain/assistant/visit_worry.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/spacing.dart';
import 'safety_notice.dart';
import 'visit_pack.dart' show visitQuestionText;

/// The worry box. [onAdd] saves the chosen lines (question text in her language and, if she
/// keeps them, her own words) to her visit list.
class VisitWorryCard extends StatefulWidget {
  const VisitWorryCard({
    super.key,
    required this.profile,
    required this.today,
    required this.onAdd,
    this.initialWorry,
    this.library,
  });
  final Profile profile;
  final String today;
  final Future<void> Function(List<String> lines) onAdd;

  /// A worry to start from, e.g. the question "Ask femio" could not answer (R8.27).
  final String? initialWorry;
  final Library? library;

  @override
  State<VisitWorryCard> createState() => _VisitWorryCardState();
}

class _VisitWorryCardState extends State<VisitWorryCard> {
  late final _worry = TextEditingController(text: widget.initialWorry ?? '');
  WorryMatch? _match;
  Set<String> _picked = {};
  bool _ownWords = true;

  @override
  void initState() {
    super.initState();
    if ((widget.initialWorry ?? '').trim().isNotEmpty) _find();
  }

  @override
  void dispose() {
    _worry.dispose();
    super.dispose();
  }

  void _find() {
    final m = matchWorry(_worry.text, widget.profile, widget.today);
    setState(() {
      _match = m.ownWords.isEmpty ? null : m;
      _picked = {...m.questionIds};
      _ownWords = true;
    });
  }

  List<String> _lines(L10n l) {
    final m = _match;
    if (m == null || m.signal != SafetySignal.none) return const [];
    return [
      for (final id in m.questionIds)
        if (_picked.contains(id)) visitQuestionText(l, id),
      if (_ownWords || m.questionIds.isEmpty) m.ownWords,
    ];
  }

  Future<void> _add(List<String> lines) async {
    await widget.onAdd(lines);
    if (!mounted) return;
    setState(() {
      _worry.clear();
      _match = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    final m = _match;
    final lines = _lines(l);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(header: true, child: Text(l.visitWorryTitle, style: t.titleMedium)),
        const SizedBox(height: space2),
        TextField(
          controller: _worry,
          minLines: 1,
          maxLines: 3,
          maxLength: maxWorryLength,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _find(),
          decoration: InputDecoration(hintText: l.visitWorryHint, border: const OutlineInputBorder()),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: FilledButton.tonalIcon(
            onPressed: _find,
            icon: const Icon(Icons.manage_search_rounded),
            label: Text(l.visitWorryFind),
          ),
        ),
        if (m != null && m.signal != SafetySignal.none) ...[
          const SizedBox(height: space3),
          SafetyNotice(signal: m.signal, library: widget.library),
        ],
        if (m != null && m.signal == SafetySignal.none) ...[
          const SizedBox(height: space3),
          if (m.questionIds.isEmpty)
            Text(l.visitWorryNone, style: t.bodyMedium)
          else ...[
            Text(l.visitWorrySuggested, style: t.titleSmall),
            // Transparent Material: the ticks' ink shows over the card's own background.
            for (final id in m.questionIds)
              _OnCard(CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _picked.contains(id),
                onChanged: (v) => setState(() => v == true ? _picked.add(id) : _picked.remove(id)),
                title: Text(visitQuestionText(l, id)),
              )),
            _OnCard(CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _ownWords,
              onChanged: (v) => setState(() => _ownWords = v ?? false),
              title: Text(l.visitWorryOwnWords),
              subtitle: Text(m.ownWords),
            )),
          ],
          const SizedBox(height: space2),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledButton.icon(
              onPressed: lines.isEmpty ? null : () => _add(lines),
              icon: const Icon(Icons.playlist_add_rounded),
              label: Text(l.visitWorryAdd),
            ),
          ),
        ],
      ],
    );
  }
}

/// A list tile on a decorated card: its own see-through Material, so the tap ink is visible.
class _OnCard extends StatelessWidget {
  const _OnCard(this.child);
  final Widget child;

  @override
  Widget build(BuildContext context) => Material(type: MaterialType.transparency, child: child);
}
