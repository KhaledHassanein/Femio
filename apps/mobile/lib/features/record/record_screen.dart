// "My record": her own health file as a timeline, filtered by kind (R11.1, ADR-082).
//
// Why it exists: the owner wants femio to keep her medical file "like a professional
// record" on her phone. Each row shows when it happened, when it was added, where it came
// from and whether it was edited. femio shows entries as written and never judges them
// (rule 1); the editor lives in record_editor.dart.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/dates.dart';
import '../../domain/health_record.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import 'documents_section.dart';
import 'record_editor.dart';
import 'record_labels.dart';

/// The record, newest first. [today] is the ISO day new entries default to.
class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key, required this.controller, required this.today});
  final FemioController controller;
  final String today;

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  /// The kind she filtered to, or null for all.
  RecordKind? _kind;

  void _open([RecordEntry? entry]) => Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => RecordEditor(
          controller: widget.controller,
          today: widget.today,
          existing: entry,
          initialKind: entry?.kind ?? _kind ?? RecordKind.visit,
        ),
      ));

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final all = widget.controller.profile!.record;
        final shown = _kind == null ? timeline(all) : ofKind(all, _kind!);
        final present = {for (final e in all) e.kind};
        return Scaffold(
          appBar: AppBar(title: Text(l.recTitle), actions: [
            IconButton(
              tooltip: l.recDocsLibrary,
              icon: const Icon(Icons.folder_outlined),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => DocumentsLibraryScreen(controller: widget.controller),
              )),
            ),
          ]),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _open,
            icon: const Icon(Icons.add_rounded),
            label: Text(l.recAdd),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(space5, space2, space5, recordListBottomClearance),
            children: [
              Text(l.recIntro, style: t.bodyMedium),
              const SizedBox(height: space3),
              if (all.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    _Filter(label: l.recAll, selected: _kind == null, onTap: () => setState(() => _kind = null)),
                    for (final k in RecordKind.values)
                      if (present.contains(k))
                        _Filter(
                          label: recordKindLabel(l, k),
                          selected: _kind == k,
                          onTap: () => setState(() => _kind = k),
                        ),
                  ]),
                ),
              const SizedBox(height: space3),
              if (all.isEmpty)
                NoticeCard(tone: NoticeTone.quiet, heading: l.recEmptyHeading, body: l.recEmptyBody)
              else
                for (final e in shown) _Row(entry: e, onTap: () => _open(e)),
              const SizedBox(height: space4),
              Text(l.recNoVerdictNote, style: t.bodySmall),
            ],
          ),
        );
      },
    );
  }
}

/// Space under the last row so the floating button never covers it.
const double recordListBottomClearance = 96;

class _Filter extends StatelessWidget {
  const _Filter({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(end: space2),
        child: ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap()),
      );
}

class _Row extends StatelessWidget {
  const _Row({required this.entry, required this.onTap});
  final RecordEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final happened = DateFormat.yMMMd(locale).format(fromISO(entry.happenedOn));
    final added = DateFormat.yMMMd(locale).format(DateTime.parse(entry.addedOn));
    final summary = recordSummary(entry);
    return Padding(
      padding: const EdgeInsets.only(bottom: space2h),
      child: Material(
        color: p.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusOption), side: BorderSide(color: p.border)),
        child: InkWell(
          borderRadius: BorderRadius.circular(radiusOption),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(space4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(recordKindIcon(entry.kind), color: p.primary),
              const SizedBox(width: space3),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(entry.title, style: t.titleMedium),
                  if (summary.isNotEmpty) Text(summary, style: t.bodyMedium),
                  const SizedBox(height: space1),
                  Text('${recordKindLabel(l, entry.kind)} · $happened', style: t.bodySmall),
                  Text(
                    [
                      l.recRowAdded(added),
                      recordSourceLabel(l, entry.source),
                      if (entry.edited) l.recEdited,
                      if (entry.attachmentIds.isNotEmpty) l.recDocsCount(entry.attachmentIds.length),
                    ].join(' · '),
                    style: t.bodySmall?.copyWith(color: p.textSubtle),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
