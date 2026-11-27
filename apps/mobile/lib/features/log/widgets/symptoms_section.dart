// The Log screen's symptoms, folded to a few with "Other" and "Show all" (owner 2026-11-27).
//
// Why it exists: thirty chips is a wall. Folded, she sees the symptoms she ticked today and
// the ones she logs most ([quickSymptoms]), then "Other", which opens a short field for a
// symptom in her own words, then "Show all symptoms". Every symptom stays one tap away
// (product rule 2). The "Other" words run the same safety rules as the day's note.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/profile.dart';
import '../../../domain/log_vocabulary.g.dart';
import '../../../domain/quick_symptoms.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/log_labels.g.dart';
import '../../../theme/femio_theme.dart';
import '../../../theme/spacing.dart';
import 'log_chip.dart';

/// Longest "Other" symptom text, in characters: a few words, not a note.
const otherSymptomMaxLength = 80;

/// How long she must stop typing before the "Other" words are saved.
const otherSymptomSaveDelay = Duration(milliseconds: 700);

/// The symptom chips for one day. [onToggle] flips a vocabulary key; [onOther] saves her
/// own words (null when cleared). The caller keys the widget by day.
class SymptomsSection extends StatefulWidget {
  const SymptomsSection({
    super.key,
    required this.logs,
    required this.day,
    required this.onToggle,
    required this.onOther,
    this.below,
  });

  final Map<String, DayLog> logs;
  final DayLog day;
  final ValueChanged<String> onToggle;
  final ValueChanged<String?> onOther;

  /// Shown under the "Other" field, for example a safety notice about her words.
  final Widget? below;

  @override
  State<SymptomsSection> createState() => _SymptomsSectionState();
}

class _SymptomsSectionState extends State<SymptomsSection> {
  bool _all = false;
  late bool _otherOpen = widget.day.hasOtherSymptoms;
  late final _other = TextEditingController(text: widget.day.otherSymptoms ?? '');
  Timer? _timer;
  bool _dirty = false;

  @override
  void dispose() {
    _timer?.cancel();
    if (_dirty) {
      final text = _value();
      final save = widget.onOther;
      Future.microtask(() => save(text));
    }
    _other.dispose();
    super.dispose();
  }

  String? _value() {
    final t = _other.text.trim();
    return t.isEmpty ? null : t;
  }

  void _changed(String _) {
    _dirty = true;
    _timer?.cancel();
    _timer = Timer(otherSymptomSaveDelay, _flush);
  }

  void _flush() {
    _timer?.cancel();
    if (!_dirty) return;
    _dirty = false;
    widget.onOther(_value());
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final symptoms = [for (final t in logTerms) if (t.dimension == LogDimension.symptom) t];
    final shown = _all
        ? symptoms
        : [for (final k in quickSymptoms(widget.logs, widget.day)) symptoms.firstWhere((t) => t.key == k)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(spacing: space2, runSpacing: space2, children: [
          for (final term in shown)
            LogChip(
              label: logLabel(l, term.key),
              selected: widget.day.terms.contains(term.key),
              // Elevated terms stay quiet on a shared screen (vocabulary.ts).
              tint: term.elevated ? p.surfaceSunken : p.logSymptomAlt,
              ink: term.elevated ? p.text : p.logSymptom,
              onTap: () => widget.onToggle(term.key),
            ),
          LogChip(
            label: l.symptomOther,
            selected: _otherOpen || widget.day.hasOtherSymptoms,
            tint: p.logSymptomAlt,
            ink: p.logSymptom,
            icon: Icons.edit_outlined,
            onTap: () => setState(() => _otherOpen = !_otherOpen || widget.day.hasOtherSymptoms),
          ),
        ]),
        if (_otherOpen || widget.day.hasOtherSymptoms) ...[
          const SizedBox(height: space2),
          Focus(
            onFocusChange: (has) {
              if (!has) _flush();
            },
            child: TextField(
              controller: _other,
              autofocus: !widget.day.hasOtherSymptoms,
              maxLength: otherSymptomMaxLength,
              textInputAction: TextInputAction.done,
              onChanged: _changed,
              onSubmitted: (_) => _flush(),
              decoration: InputDecoration(
                hintText: l.symptomOtherHint,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
            ),
          ),
        ],
        ?widget.below,
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => setState(() => _all = !_all),
            icon: Icon(_all ? Icons.expand_less_rounded : Icons.expand_more_rounded),
            label: Text(_all ? l.symptomsShowFewer : l.symptomsShowAll),
          ),
        ),
      ],
    );
  }
}
