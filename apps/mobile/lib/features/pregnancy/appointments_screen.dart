import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../app.dart';
import '../../domain/appointments.dart';
import '../../domain/dates.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../widgets/notice_card.dart';

/// Appointments: when, with whom, and the questions she meant to ask, which is the
/// part people forget in the room. Never the result (`domain/appointments.dart`).
class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key, required this.controller, required this.today});
  final FemioController controller;
  final String today;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final all = controller.profile!.appointments;
        final split = splitAppointments(all, today);
        final awaiting = awaitingResults(all, today);
        void open([Appointment? a]) => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => _Editor(controller: controller, today: today, existing: a),
            ));
        return Scaffold(
          appBar: AppBar(title: Text(l.apptTitle)),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: open,
            icon: const Icon(Icons.add_rounded),
            label: Text(l.apptAdd),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
            children: [
              if (all.isEmpty)
                NoticeCard(tone: NoticeTone.quiet, heading: l.apptEmptyHeading, body: l.apptEmptyBody),
              if (awaiting.isNotEmpty) ...[
                NoticeCard(
                  tone: NoticeTone.quiet,
                  icon: Icons.mark_email_unread_outlined,
                  heading: l.apptAwaitingHeading,
                  body: l.apptAwaitingBody(awaiting.length),
                ),
                const SizedBox(height: 16),
              ],
              if (split.upcoming.isNotEmpty) ...[
                Text(l.apptUpcoming, style: t.titleLarge),
                const SizedBox(height: 8),
                for (final a in split.upcoming) _Card(a: a, today: today, onTap: () => open(a)),
              ],
              if (split.past.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(l.apptPast, style: t.titleLarge),
                const SizedBox(height: 8),
                for (final a in split.past) _Card(a: a, today: today, onTap: () => open(a)),
              ],
              const SizedBox(height: 16),
              Text(l.apptNoResultsNote, style: t.bodySmall),
            ],
          ),
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.a, required this.today, required this.onTap});
  final Appointment a;
  final String today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final days = daysUntil(a, today);
    final when = a.datetime == null
        ? l.apptNoDate
        : DateFormat.MMMEd(locale).add_Hm().format(DateTime.parse(a.datetime!));
    final soon = switch (days) {
      0 => l.apptToday,
      final d? when d > 0 => l.apptInDays(d),
      _ => null,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: p.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: p.border)),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(a.type?.isNotEmpty == true ? a.type! : l.apptUntitled, style: t.titleMedium)),
                if (soon != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: p.primarySoft, borderRadius: BorderRadius.circular(99)),
                    child: Text(soon, style: t.labelMedium?.copyWith(color: p.primarySoftText)),
                  ),
              ]),
              const SizedBox(height: 4),
              Text([when, if (a.clinician?.isNotEmpty == true) a.clinician!].join(' · '), style: t.bodySmall),
              if (a.prep.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(l.apptPrepCount(a.prep.length), style: t.bodySmall?.copyWith(color: p.primary)),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}

class _Editor extends StatefulWidget {
  const _Editor({required this.controller, required this.today, this.existing});
  final FemioController controller;
  final String today;
  final Appointment? existing;

  @override
  State<_Editor> createState() => _EditorState();
}

class _EditorState extends State<_Editor> {
  late final _type = TextEditingController(text: widget.existing?.type ?? '');
  late final _clinician = TextEditingController(text: widget.existing?.clinician ?? '');
  late final _prep = TextEditingController(text: widget.existing?.prep.join('\n') ?? '');

  /// Local wall-clock time without a zone (`2026-10-12T09:30`): the day she sees is
  /// the day it is stored under, whatever her timezone does later.
  late String? _datetime = widget.existing?.datetime;
  late String? _resultsDue = widget.existing?.resultsDue;

  @override
  void dispose() {
    _type.dispose();
    _clinician.dispose();
    _prep.dispose();
    super.dispose();
  }

  String? _clean(String s) => s.trim().isEmpty ? null : s.trim();

  Future<void> _pickWhen() async {
    final now = DateTime.parse(_datetime ?? '${widget.today}T09:00');
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 730)),
      lastDate: now.add(const Duration(days: 730)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(now));
    final h = (time ?? TimeOfDay.fromDateTime(now)).hour.toString().padLeft(2, '0');
    final m = (time ?? TimeOfDay.fromDateTime(now)).minute.toString().padLeft(2, '0');
    setState(() => _datetime = '${toISO(date)}T$h:$m');
  }

  Future<void> _pickResultsDue() async {
    final base = fromISO(_resultsDue ?? widget.today);
    final date = await showDatePicker(
      context: context,
      initialDate: base,
      firstDate: base.subtract(const Duration(days: 365)),
      lastDate: base.add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _resultsDue = toISO(date));
  }

  Future<void> _save() async {
    final profile = widget.controller.profile!;
    final a = Appointment(
      id: widget.existing?.id ?? 'a${DateTime.now().microsecondsSinceEpoch}',
      type: _clean(_type.text),
      clinician: _clean(_clinician.text),
      datetime: _datetime,
      prep: parsePrep(_prep.text),
      resultsDue: _resultsDue,
    );
    await widget.controller.save(profile.copyWith(appointments: [
      for (final x in profile.appointments)
        if (x.id != a.id) x,
      a,
    ]));
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final profile = widget.controller.profile!;
    await widget.controller.save(profile.copyWith(appointments: [
      for (final x in profile.appointments)
        if (x.id != widget.existing!.id) x,
    ]));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    InputDecoration deco(String label, [String? hint]) => InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: p.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        );
    Widget pickerRow(String label, String? value, VoidCallback onTap, {VoidCallback? onClear}) => Material(
          color: p.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: p.border)),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(label, style: t.bodySmall),
                    Text(value ?? '—', style: t.titleMedium),
                  ]),
                ),
                if (onClear != null && value != null)
                  IconButton(onPressed: onClear, icon: const Icon(Icons.close_rounded), tooltip: l.apptDelete)
                else
                  Icon(Icons.event_outlined, color: p.textSubtle),
              ]),
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? l.apptAdd : l.apptEdit),
        actions: [
          if (widget.existing != null)
            IconButton(tooltip: l.apptDelete, onPressed: _delete, icon: const Icon(Icons.delete_outline_rounded)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          TextField(controller: _type, decoration: deco(l.apptFormType, l.apptFormTypePlaceholder)),
          const SizedBox(height: 12),
          TextField(controller: _clinician, decoration: deco(l.apptFormClinician)),
          const SizedBox(height: 12),
          pickerRow(
            l.apptFormWhen,
            _datetime == null ? null : DateFormat.yMMMEd(locale).add_Hm().format(DateTime.parse(_datetime!)),
            _pickWhen,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _prep,
            minLines: 3,
            maxLines: 8,
            decoration: deco(l.apptFormPrep, l.apptFormPrepPlaceholder),
          ),
          const SizedBox(height: 12),
          pickerRow(
            l.apptFormResultsDue,
            _resultsDue == null ? null : DateFormat.yMMMd(locale).format(fromISO(_resultsDue!)),
            _pickResultsDue,
            onClear: () => setState(() => _resultsDue = null),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 12, top: 6),
            child: Text(l.apptFormResultsDueHint, style: t.bodySmall),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: Text(l.apptSave)),
          const SizedBox(height: 8),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.apptCancel)),
        ],
      ),
    );
  }
}
