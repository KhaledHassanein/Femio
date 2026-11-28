// How an Ask femio answer is shown: the words, where they were made, and every source
// (ADR-079).
//
// Why it exists: an answer without its sources is a guess. This card always says whether
// Gemini Nano wrote the summary on her phone, the cloud model wrote it (Cloud boost), or she is
// reading the sources word for word; it numbers the passages the way the summary cites them,
// and shows each publisher, page title and date, with a tap to open the page.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../domain/assistant/prompts.dart';
import '../../domain/assistant/source_registry.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../theme/type_sizes.dart';
import 'assistant_scope.dart';
import 'report_answer_sheet.dart';

/// Where the answer's words came from.
enum AnswerOrigin { onPhone, cloud, verbatim }

/// The answer and its numbered sources.
class AnswerCard extends StatelessWidget {
  const AnswerCard({super.key, required this.answer, required this.summary, required this.origin});
  final RegistryAnswer answer;

  /// The model's cited summary; null shows the passages word for word.
  final CitedAnswer? summary;
  final AnswerOrigin origin;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final english = Localizations.localeOf(context).languageCode != 'en';
    final s = summary;
    final label = switch (origin) {
      AnswerOrigin.onPhone => l.askAnswerOnPhone,
      AnswerOrigin.cloud => l.askAnswerCloud,
      AnswerOrigin.verbatim => l.askVerbatimLabel,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: space4),
        Container(
          padding: const EdgeInsets.all(space4),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(radiusMd),
            border: Border.all(color: p.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    origin == AnswerOrigin.cloud ? Icons.cloud_done_outlined : Icons.verified_rounded,
                    size: iconSizeInline,
                    color: p.successText,
                  ),
                  const SizedBox(width: space1h),
                  Expanded(child: Text(label, style: t.labelMedium)),
                ],
              ),
              const SizedBox(height: space2),
              if (s != null) ...[
                SelectableText(s.text, style: t.bodyLarge),
                if (s.translated) ...[
                  const SizedBox(height: space2),
                  Text(l.askAnswerTranslated, style: t.bodySmall),
                ],
              ] else ...[
                for (var i = 0; i < answer.passages.length; i++) ...[
                  Text('[${i + 1}] ${answer.passages[i].publisher}', style: t.labelMedium),
                  const SizedBox(height: space1),
                  SelectableText(
                    answer.passages[i].text,
                    style: t.bodyMedium,
                    textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(height: space3),
                ],
                if (english) Text(l.askEnglishNote, style: t.bodySmall),
              ],
              const SizedBox(height: space3),
              Text(l.askClinicianLine, style: t.bodySmall),
              // R14.18 (Play AI-Generated Content policy): every answer the AI wrote can be flagged.
              if (s != null)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: () => showReportAnswerSheet(context, answer: s.text, origin: label),
                    icon: const Icon(Icons.outlined_flag_rounded, size: iconSizeInline),
                    label: Text(l.reportAnswer),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: space4),
        Semantics(header: true, child: Text(l.askSourcesTitle, style: t.titleMedium)),
        for (var i = 0; i < answer.passages.length; i++)
          _SourceTile(
            entry: answer.passages[i],
            number: i + 1,
            cited: s == null || s.cited.contains(i + 1),
          ),
      ],
    );
  }
}

/// "Read more" links to sources femio does not copy (WHO, NHS, ACOG, RCOG, NICE).
class LinksBlock extends StatelessWidget {
  const LinksBlock({super.key, required this.links});
  final List<SourceEntry> links;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: space5),
        Semantics(header: true, child: Text(l.askReadMore, style: t.titleMedium)),
        for (final e in links) _SourceTile(entry: e, number: null, cited: true),
      ],
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({required this.entry, required this.number, required this.cited});
  final SourceEntry entry;
  final int? number;
  final bool cited;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final reviewed = entry.reviewed;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final meta = reviewed == null
        ? l.askSourceCopied(entry.publisher, sourceDate(entry.retrieved, locale))
        : l.askSourceReviewed(entry.publisher, sourceDate(reviewed, locale));
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: number == null
          ? Icon(Icons.open_in_new_rounded, color: p.primary)
          : CircleAvatar(
              radius: sourceBadgeDiameter / 2,
              backgroundColor: cited ? p.primary : p.border,
              child: Text(
                '$number',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: cited ? p.onPrimary : p.textSubtle),
              ),
            ),
      title: Text(entry.title, textDirection: TextDirection.ltr),
      subtitle: Text(meta),
      onTap: () => AssistantScope.of(context).openSource(entry.url),
    );
  }
}

/// A registry date (yyyy-mm-dd or yyyy-mm) in [locale]'s own format; anything else as given.
String sourceDate(String iso, String locale) {
  final day = RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(iso);
  final month = RegExp(r'^\d{4}-\d{2}$').hasMatch(iso);
  final parsed = DateTime.tryParse(month ? '$iso-01' : iso);
  if (parsed == null || !(day || month)) return iso;
  return (day ? DateFormat.yMMMd(locale) : DateFormat.yMMM(locale)).format(parsed);
}

/// A lock icon and one line of privacy wording.
class PrivacyRow extends StatelessWidget {
  const PrivacyRow({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      children: [
        Icon(Icons.lock_outline_rounded, size: iconSizeInline, color: p.textSubtle),
        const SizedBox(width: space1h),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
      ],
    );
  }
}
