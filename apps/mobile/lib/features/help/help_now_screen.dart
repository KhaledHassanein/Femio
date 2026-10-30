// Help now: the approved crisis wording, then the numbers for a country she picks
// (sixteen countries, the website's list; R6.17).
//
// Why it exists: the website has always carried this page; the app did not (study
// report 10). The sentences are the reviewed ones from the website's crisis.json,
// copied verbatim into the ARB files and checked by scripts/crisis-compliance.mjs.
// Rules (docs/compliance/CRISIS_RESOURCES.md): the global guidance first and always;
// a number only after she picks a country; emergency lines drawn apart from support
// lines; each number with the page it was read on; no promises about cost, hours
// or confidentiality. Never gated behind anything. The country chips wrap rather than
// scroll so that every listed country is visible at once; a country with no verified
// official page is not listed (the directory on the website covers it).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/crisis_numbers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import 'help_now_labels.dart';

/// The Help now screen, reached from every tab's header.
class HelpNowScreen extends StatefulWidget {
  const HelpNowScreen({super.key});

  @override
  State<HelpNowScreen> createState() => _HelpNowScreenState();
}

class _HelpNowScreenState extends State<HelpNowScreen> {
  String? _country;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final numbers = _country == null ? const <CrisisNumber>[] : crisisNumbers[_country]!;
    return Scaffold(
      appBar: AppBar(title: Text(l.helpNowDialogTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(space5, space3, space5, space8),
        children: [
          NoticeCard(tone: NoticeTone.urgent, heading: l.helpNowImmediateHeading, body: '${l.helpNowImmediateLead} ${l.helpNowStayWithSomeone}'),
          const SizedBox(height: space4),
          Text(l.helpNowCountryPrompt, style: t.titleMedium),
          const SizedBox(height: space2),
          Wrap(
            spacing: space2,
            runSpacing: space1,
            children: [
              for (final slug in crisisCountries)
                ChoiceChip(
                  label: Text(helpNowCountryName(l, slug)),
                  selected: _country == slug,
                  onSelected: (_) => setState(() => _country = slug),
                ),
            ],
          ),
          if (numbers.isNotEmpty) ...[
            const SizedBox(height: space4),
            _NumberGroup(title: l.helpNowEmergency, numbers: numbers.where((n) => n.kind == NumberKind.emergency).toList()),
            if (numbers.any((n) => n.kind == NumberKind.support)) ...[
              const SizedBox(height: space3),
              _NumberGroup(title: l.helpNowSupport, numbers: numbers.where((n) => n.kind == NumberKind.support).toList()),
            ],
          ],
          const SizedBox(height: space6),
          Text(l.helpNowWorriedHeading, style: t.titleMedium),
          const SizedBox(height: space1),
          Text(l.helpNowWorriedBody, style: t.bodyMedium?.copyWith(color: p.textMuted)),
        ],
      ),
    );
  }
}

/// A labelled list of numbers. A tap copies the number (the app opens no other app);
/// the source line names where it was read.
class _NumberGroup extends StatelessWidget {
  const _NumberGroup({required this.title, required this.numbers});
  final String title;
  final List<CrisisNumber> numbers;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: t.labelLarge?.copyWith(color: p.textMuted)),
        const SizedBox(height: space1),
        for (final n in numbers)
          Container(
            margin: const EdgeInsets.only(bottom: space2),
            padding: const EdgeInsets.all(space3),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(radiusMd), border: Border.all(color: p.border)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(helpNowNumberLabel(l, n.id), style: t.bodyMedium),
                      Text('${l.helpNowSource}: ${Uri.parse(n.sourceUrl).host}', style: t.labelMedium?.copyWith(color: p.textSubtle)),
                    ],
                  ),
                ),
                const SizedBox(width: space2),
                FilledButton.tonal(
                  // The theme's buttons fill their row; this one sits beside the label.
                  style: FilledButton.styleFrom(minimumSize: const Size(72, 44)),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: n.number));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(n.number)));
                  },
                  child: Text(n.number, textDirection: TextDirection.ltr),
                ),
              ],
            ),
          ),
      ],
    );
  }

}
