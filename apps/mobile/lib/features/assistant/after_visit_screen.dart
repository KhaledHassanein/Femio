// After a visit: she says or types what the doctor told her, and femio keeps it (R10.11,
// ADR-087).
//
// Why it exists: the moment after a visit is when details are lost: the new medicine's dose,
// the test to repeat, the next date. With Gemini Nano on the phone her words become a draft of
// medicines, results and the next visit that she checks line by line; without it (or if she
// prefers) her words are saved as a visit note, so the feature works with AI off (rule 7).
// On the phone her words never leave it. On a phone without Nano, femio offers cloud reading
// (ADR-089): her words go only with that consent and after she approved them on a preview.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/appointments.dart';
import '../../domain/assistant/record_draft.dart';
import '../../domain/bidi_text.dart';
import '../../domain/dates.dart';
import '../../domain/health_record.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/type_sizes.dart';
import '../record/draft_lines.dart';
import '../../data/assistant_gateway.dart' show AssistantResult, RanOn;
import '../../domain/assistant/approved_record.dart';
import 'assistant_scope.dart';
import 'cloud_reading.dart';
import 'input_actions.dart';

/// The time a next visit gets when she said only a day, matching the appointment editor's
/// default; she changes it under Appointments.
const afterVisitDefaultTime = '09:00';

/// The longest note kept from her words.
const maxAfterVisitWords = 2000;

/// The "After a visit" screen for [today] (ISO day).
class AfterVisitScreen extends StatefulWidget {
  const AfterVisitScreen({super.key, required this.controller, required this.today});
  final FemioController controller;
  final String today;

  @override
  State<AfterVisitScreen> createState() => _AfterVisitScreenState();
}

class _AfterVisitScreenState extends State<AfterVisitScreen> {
  final _words = TextEditingController();
  bool _reading = false;
  RecordDraft? _draft;
  bool _noAi = false;
  List<DraftLine> _lines = const [];
  final _kept = <int>{};
  bool _keepNext = true;
  bool _saving = false;

  /// No Gemini Nano here, but Cloud boost can be reached: cloud reading may be offered.
  bool _cloudPossible = false;

  /// Google's cloud AI read her words (ADR-089).
  bool _cloud = false;

  @override
  void dispose() {
    _words.dispose();
    super.dispose();
  }

  Future<void> _read() async {
    final words = _words.text.trim();
    if (words.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _reading = true);
    final gateway = AssistantScope.gatewayOf(context);
    final status = await gateway.status();
    var result = const AssistantResult<RecordDraft>.rules();
    if (status.canRunPrivate) {
      result = await gateway.readVisitWords(words, widget.today);
    } else if (status.canRunHybrid && mounted) {
      result = await _readInCloud(words);
    }
    if (!mounted) return;
    _show(result, cloudPossible: !status.canRunPrivate && status.canRunHybrid);
  }

  /// Asks her, then has the cloud read [words] (ADR-089); the rules answer when she declines.
  Future<AssistantResult<RecordDraft>> _readInCloud(String words) async {
    final approved = await approveCloudReading(
      context,
      widget.controller,
      reading: RecordReading.visitWords,
      parts: [words],
      today: widget.today,
    );
    final consent = widget.controller.profile?.settings.cloud;
    if (approved == null || consent == null || !mounted) return const AssistantResult.rules();
    return AssistantScope.gatewayOf(context).readVisitWordsInCloud(approved, consent);
  }

  /// The "Read it with Google's cloud AI" button under a rules-only result.
  Future<void> _retryInCloud() async {
    final words = _words.text.trim();
    if (words.isEmpty) return;
    setState(() => _reading = true);
    final result = await _readInCloud(words);
    if (!mounted) return;
    _show(result, cloudPossible: true);
  }

  void _show(AssistantResult<RecordDraft> result, {required bool cloudPossible}) {
    final draft = result.value;
    setState(() {
      _cloudPossible = cloudPossible;
      _cloud = result.ranOn == RanOn.cloud;
      _reading = false;
      _noAi = draft == null;
      _draft = draft ?? const RecordDraft();
      _lines = _draft!.lines;
      _kept
        ..clear()
        ..addAll(List.generate(_lines.length, (i) => i));
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final l = L10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final now = DateTime.now().toIso8601String();
    final id = 'r${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(1 << 16)}';
    final draft = _draft ?? const RecordDraft();
    final words = _words.text.trim();
    // The visit itself, with her own words kept as she said them.
    await widget.controller.saveRecordEntry(RecordEntry.create(
      id: '$id-visit',
      kind: RecordKind.visit,
      title: l.afterVisitEntryTitle,
      happenedOn: widget.today,
      addedOn: now,
      source: _noAi ? RecordSource.typed : RecordSource.afterVisit,
      fields: {
        RecordField.details: words.length > maxAfterVisitWords ? words.substring(0, maxAfterVisitWords) : words,
      },
    ));
    final entries = entriesFromDraft(
      [for (final i in _kept.toList()..sort()) _lines[i]],
      happenedOn: widget.today,
      addedOn: now,
      idPrefix: id,
      source: RecordSource.afterVisit,
    );
    for (final e in entries) {
      await widget.controller.saveRecordEntry(e);
    }
    final next = draft.nextVisit;
    if (next != null && _keepNext) {
      final profile = widget.controller.profile!;
      await widget.controller.save(profile.copyWith(appointments: [
        ...profile.appointments,
        Appointment(id: 'a$id', type: l.afterVisitNextType, datetime: '${next}T$afterVisitDefaultTime'),
      ]));
    }
    messenger.showSnackBar(SnackBar(content: Text(l.afterVisitSaved)));
    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final draft = _draft;
    return Scaffold(
      appBar: AppBar(title: Text(l.afterVisitTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(space5, space3, space5, space6),
        children: [
          Text(l.afterVisitHint, style: t.bodyMedium),
          const SizedBox(height: space3),
          TextField(
            controller: _words,
            minLines: 4,
            maxLines: 10,
            maxLength: maxAfterVisitWords,
            enabled: !_reading,
            onChanged: (_) {
              if (_draft != null) setState(() => _draft = null);
            },
            decoration: InputDecoration(
              hintText: l.afterVisitExample,
              suffixIcon: AssistantInputActions(text: _words, controller: widget.controller, today: widget.today, enabled: !_reading),
            ),
          ),
          if (draft == null)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.icon(
                onPressed: _reading ? null : _read,
                icon: _reading
                    ? const SizedBox.square(dimension: iconSizeInline, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.auto_awesome_rounded),
                label: Text(_reading ? l.afterVisitReading : l.afterVisitRead),
              ),
            )
          else ...[
            const SizedBox(height: space2),
            Text(
              _noAi ? l.afterVisitNoAi : (draft.isEmpty ? l.afterVisitNothing : l.afterVisitCheck),
              style: t.bodyMedium,
            ),
            if (_noAi && _cloudPossible) ...[
              const SizedBox(height: space2),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: OutlinedButton.icon(
                  onPressed: _reading ? null : _retryInCloud,
                  icon: const Icon(Icons.cloud_outlined),
                  label: Text(l.cloudReadButton),
                ),
              ),
            ],
            if (draft.note != null) ...[
              const SizedBox(height: space3),
              Text(l.afterVisitNoteHeading, style: t.titleSmall),
              Text(isolateText(draft.note!), style: t.bodyMedium),
            ],
            if (draft.nextVisit != null)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _keepNext,
                onChanged: (v) => setState(() => _keepNext = v ?? false),
                title: Text(l.afterVisitNext(DateFormat.yMMMEd(locale).format(fromISO(draft.nextVisit!)))),
                subtitle: Text(l.afterVisitNextNote),
              ),
            DraftLinesList(
              lines: _lines,
              kept: _kept,
              onToggle: (i) => setState(() => _kept.contains(i) ? _kept.remove(i) : _kept.add(i)),
              onEdit: (i, line) => setState(() => _lines = [..._lines]..[i] = line),
            ),
          ],
          const SizedBox(height: space4),
          Row(children: [
            Icon(Icons.lock_outline_rounded, size: iconSizeInline, color: p.textSubtle),
            const SizedBox(width: space1h),
            Expanded(child: Text(_cloud ? l.cloudReadDone : l.afterVisitPrivate, style: t.bodySmall)),
          ]),
        ],
      ),
      bottomNavigationBar: draft == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(space5, space2, space5, space3),
                child: FilledButton(onPressed: _saving ? null : _save, child: Text(l.recSave)),
              ),
            ),
    );
  }
}
