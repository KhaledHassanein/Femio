// "Say it in your words": a note becomes log drafts, one per day, on the phone (ADR-078, R7.3, R10.7).
//
// Why it exists: tapping through forty chips is the reason people stop logging. She types (or
// dictates with her keyboard) a note in any of the four languages, perhaps naming several days
// ("yesterday cramps, today spotting"); femio's phrase rules read it day by day, Gemini Nano
// adds what the rules missed when the phone has it, and she confirms every day's chips before
// anything is saved, in one counted save. Her note itself is never stored or sent.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/assistant_gateway.dart' show RanOn;
import '../../data/profile.dart';
import '../../domain/assistant/log_phrases.dart';
import '../../domain/assistant/safety.dart';
import '../../domain/assistant/say_it_days.dart';
import '../../domain/dates.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/type_sizes.dart';
import 'assistant_scope.dart';
import 'mic_button.dart';
import 'safety_notice.dart';
import 'say_it_day_card.dart';
import 'stage_hints.dart';

/// Opens the sheet for the day [date] in [controller]'s record.
Future<void> showSayItSheet(BuildContext context, {required FemioController controller, required String date}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SayItSheet(controller: controller, date: date),
    );

/// The sheet's content. [date] is the day she has selected: words with no day word go there.
/// [today] is for tests; it defaults to the phone's date. Public for widget tests and screenshots.
class SayItSheet extends StatefulWidget {
  const SayItSheet({super.key, required this.controller, required this.date, this.today});
  final FemioController controller;
  final String date;
  final String? today;

  @override
  State<SayItSheet> createState() => _SayItSheetState();
}

/// One day's draft while she is checking it.
class _DayDraft {
  _DayDraft(this.date, this.draft);
  final String date;
  final LogDraft draft;
  final Set<String> unticked = {};
}

class _SayItSheetState extends State<SayItSheet> {
  final _text = TextEditingController();
  bool _busy = false;
  bool _usedModel = false;

  /// Gemini Nano read her words on this phone, even if it added nothing (UX-6).
  bool _ranModel = false;
  bool _read = false;
  SafetySignal _signal = SafetySignal.none;
  Set<SayItRefusal> _refused = const {};
  final List<_DayDraft> _days = [];

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _readNote() async {
    final note = _text.text.trim();
    if (note.isEmpty) return;
    final gateway = AssistantScope.gatewayOf(context);
    final reading = readSayItNote(
      note,
      profile: widget.controller.profile,
      today: widget.today ?? todayISO(),
      selectedDate: widget.date,
    );
    setState(() {
      _busy = true;
      _signal = reading.signal;
      _refused = reading.refused;
      _days.clear();
      _read = false;
      _usedModel = false;
      _ranModel = false;
    });
    final drafts = <_DayDraft>[];
    var usedModel = false;
    var ranModel = false;
    for (final day in reading.days) {
      var draft = day.draft;
      // The model reads only this day's own words, and only ever adds to the rules' draft.
      final result = await gateway.readNote(day.text);
      final s = result.value;
      if (result.ranOn == RanOn.phone) ranModel = true;
      if (s != null) {
        final merged = mergeDrafts(draft, modelTerms: s.terms, modelFlow: s.flow, modelOpk: s.opk);
        if (merged.terms.length != draft.terms.length || merged.flow != draft.flow || merged.opk != draft.opk) {
          usedModel = true;
        }
        draft = merged;
      }
      if (!draft.isEmpty) drafts.add(_DayDraft(day.date, draft));
    }
    if (!mounted) return;
    setState(() {
      _busy = false;
      _read = true;
      _usedModel = usedModel;
      _ranModel = ranModel;
      _days.addAll(drafts);
    });
  }

  /// What a save would write: each day's ticked chips only.
  List<(String, LogDraft)> get _kept => [
    for (final d in _days)
      if (entryCount(draftWithout(d.draft, d.unticked)) > 0) (d.date, draftWithout(d.draft, d.unticked)),
  ];

  /// Merges every kept day into her record in one save; nothing already there is removed.
  Future<void> _save() async {
    var profile = widget.controller.profile!;
    for (final (date, kept) in _kept) {
      profile = profile.withDayLog(date, mergeIntoDayLog(profile.logs[date] ?? const DayLog(), kept));
    }
    await widget.controller.save(profile);
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
    final kept = _kept;
    final entries = kept.fold<int>(0, (n, e) => n + entryCount(e.$2));
    final showHijri = widget.controller.profile?.settings.showHijri ?? false;

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
              onSubmitted: (_) => _readNote(),
              decoration: InputDecoration(
                hintText: sayItHintFor(l, hintStage(widget.controller.profile)),
                border: const OutlineInputBorder(),
                suffixIcon: MicButton(controller: _text),
              ),
            ),
            const SizedBox(height: space2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.mic_none_rounded, size: iconSizeInline, color: p.textSubtle),
                const SizedBox(width: space1h),
                Expanded(child: Text(l.sayItDictationHint, style: t.bodySmall?.copyWith(color: p.textSubtle))),
              ],
            ),
            const SizedBox(height: space3),
            FilledButton.icon(
              onPressed: _busy ? null : _readNote,
              icon: _busy
                  ? const SizedBox.square(dimension: iconSizeInline, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.auto_awesome_rounded),
              label: Text(l.sayItAction),
            ),
            if (_signal != SafetySignal.none) ...[const SizedBox(height: space4), SafetyNotice(signal: _signal)],
            if (_refused.contains(SayItRefusal.future)) ...[
              const SizedBox(height: space3),
              Text(l.sayItFuture, style: t.bodyMedium),
            ],
            if (_refused.contains(SayItRefusal.tooOld)) ...[
              const SizedBox(height: space3),
              Text(l.sayItTooOld(sayItMaxDaysBack), style: t.bodyMedium),
            ],
            if (_read && _days.isEmpty && _refused.isEmpty) ...[
              const SizedBox(height: space4),
              Text(l.sayItNothing, style: t.bodyMedium),
            ],
            if (_days.isNotEmpty) ...[
              const SizedBox(height: space4),
              Text(_days.length == 1 ? l.sayItFound : l.sayItFoundDays, style: t.bodyMedium),
              const SizedBox(height: space2),
              for (final d in _days) ...[
                SayItDayCard(
                  key: ValueKey(d.date),
                  date: d.date,
                  draft: d.draft,
                  unticked: d.unticked,
                  showHijri: showHijri,
                  onToggle: (id) => setState(() => d.unticked.contains(id) ? d.unticked.remove(id) : d.unticked.add(id)),
                  onRemove: () => setState(() => _days.remove(d)),
                ),
                const SizedBox(height: space2),
              ],
              const SizedBox(height: space1),
              FilledButton(
                onPressed: entries == 0 ? null : _save,
                child: Text(l.sayItSaveCount(entries, kept.length)),
              ),
            ],
            const SizedBox(height: space4),
            Row(
              children: [
                Icon(Icons.lock_outline_rounded, size: iconSizeInline, color: p.textSubtle),
                const SizedBox(width: space1h),
                Expanded(
                  child: Text(
                    _usedModel
                        ? '${l.assistantPrivateNote} ${l.assistantModelNote}'
                        : _ranModel
                            ? '${l.assistantPrivateNote} ${l.sayItCheckedNano}'
                            : l.assistantPrivateNote,
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
