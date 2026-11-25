// Today's "For you" card: reviewed tips that fit her, each with its source (ADR-079).
//
// Why it exists: the personas asked for advice that fits their stage and what they log, not a
// generic feed. Which tips fit is decided on the phone by the catalogue triggers. The sentence
// she reads is always the reviewed one in her language ("the model reads; femio speaks"). When
// more tips fit than the card shows, a model may put them in order:
//   - Gemini Nano on the phone (ONLY_ON_DEVICE), given her bands and the fitting tips; or
//   - with Cloud boost on and no Nano, the hybrid call, given only her PseudonymisedProfile and
//     every tip for her life stage (CloudPrompt.tips), never the subset that fits her.
// Without either, the most specific tips come first. No model can add a tip. Each tip has a
// "Why am I seeing this?" link that lists the facts from her record that made it fit (R10.3).

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/assistant_gateway.dart';
import '../../data/profile.dart';
import '../../domain/assistant/cloud_consent.dart';
import '../../domain/assistant/personal_triggers.dart';
import '../../domain/assistant/pseudonymised_profile.dart';
import '../../domain/assistant/tip_catalogue.g.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../theme/type_sizes.dart';
import '../assistant/assistant_scope.dart';
import '../assistant/catalogue_text.g.dart';
import 'tip_why_sheet.dart';

/// How many tips the card shows.
const tipsShown = 3;

/// The "For you" card; shows nothing when no tip fits.
class TipsCard extends StatefulWidget {
  const TipsCard({super.key, required this.controller, required this.today});
  final FemioController controller;

  /// yyyy-mm-dd.
  final String today;

  @override
  State<TipsCard> createState() => _TipsCardState();
}

class _TipsCardState extends State<TipsCard> {
  List<PersonalItem> _fits = const [];
  TriggerContext? _context;
  List<String>? _order;
  bool _cloudOrdered = false;
  String? _orderedFor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refresh();
  }

  @override
  void didUpdateWidget(TipsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _refresh();
  }

  /// Recomputes the fitting tips; asks a model for an order only when the set changed and more
  /// tips fit than are shown.
  void _refresh() {
    final profile = widget.controller.profile;
    if (profile == null) return;
    final facts = _context = triggerContext(profile, widget.today);
    _fits = fitting(tipCatalogue, facts);
    final key =
        '${widget.today}|${_fits.map((f) => f.id).join(',')}|${profile.settings.cloud.allows(CloudPurpose.tips)}';
    if (key == _orderedFor) return;
    _orderedFor = key;
    _order = null;
    _cloudOrdered = false;
    if (_fits.length > tipsShown) _orderWithModel(profile, key);
  }

  Future<void> _orderWithModel(Profile profile, String key) async {
    final result = await AssistantScope.gatewayOf(context).orderTips(
      pseudonymise(profile, widget.today),
      [for (final f in _fits) f.id],
      tipsShown,
      profile.settings.cloud,
    );
    final order = result.value ?? const <String>[];
    final cloud = result.ranOn == RanOn.cloud;
    if (!mounted || key != _orderedFor || order.isEmpty) return;
    setState(() {
      _order = order;
      _cloudOrdered = cloud;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_fits.isEmpty) return const SizedBox.shrink();
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final order = _order;
    final byId = {for (final f in _fits) f.id: f};
    final shown = order == null
        ? _fits.take(tipsShown).toList()
        : [
            for (final id in order) byId[id]!,
            ..._fits.where((f) => !order.contains(f.id)),
          ].take(tipsShown).toList();
    return Container(
      margin: const EdgeInsets.only(top: space4),
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
                Icons.auto_awesome_rounded,
                size: iconSizeInline,
                color: p.primary,
              ),
              const SizedBox(width: space1h),
              Semantics(
                header: true,
                child: Text(l.tipsTitle, style: t.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: space2),
          for (final tip in shown) ...[
            Text(tipText(l, tip.id) ?? '', style: t.bodyMedium),
            Wrap(
              spacing: space4,
              children: [
                _Link(
                  text: l.tipsSource(tip.publisher),
                  onTap: () => AssistantScope.of(context).openSource(tip.url),
                ),
                _Link(
                  text: l.tipWhyAction,
                  onTap: () => showTipWhySheet(context, tip, _context!, cloudOrdered: _cloudOrdered),
                ),
              ],
            ),
            const SizedBox(height: space2),
          ],
          Text(
            _cloudOrdered ? l.tipsOrderedCloud : l.tipsChosenOnPhone,
            style: t.bodySmall?.copyWith(color: p.textMuted),
          ),
        ],
      ),
    );
  }
}

/// A small underlined link under a tip.
class _Link extends StatelessWidget {
  const _Link({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: space1h),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: p.primary, decoration: TextDecoration.underline),
        ),
      ),
    );
  }
}
