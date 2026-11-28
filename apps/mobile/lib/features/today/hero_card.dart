// The building blocks every Today hero is made of: the aurora card, a line of text on
// it, and the quiet note card below it.
//
// Why it exists: the period, pregnancy and menopause heroes must look like one family.
// Putting the card here means each hero file only says what it says, not how it is drawn.

import 'package:flutter/material.dart';

import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/radii.dart';
import '../../theme/type_sizes.dart';

/// Formats an ISO day (`2026-10-08`) as a short date in her language.
typedef IsoDateFormatter = String Function(String iso);

/// Formats two ISO days as one range ("Oct 8 – Oct 12") in her language.
typedef IsoRangeFormatter = String Function(String fromIso, String toIso);

/// The text colour on the aurora, white in both themes (the gradient is always dark).
const _onHero = Colors.white;

/// The aurora card: a small caps [eyebrow], a large [headline] and optional [extra]
/// widgets below (lines, meters).
class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.eyebrow, required this.headline, this.extra = const []});
  final String eyebrow;
  final String headline;
  final List<Widget> extra;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(space5h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radiusHero),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [p.auroraGround, p.primarySolid, p.accentSolid],
          stops: const [0, 0.6, 1],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eyebrow.toUpperCase(), style: t.labelMedium?.copyWith(color: _onHero.withValues(alpha: 0.85))),
          const SizedBox(height: space2),
          Text(headline, style: t.displaySmall?.copyWith(color: _onHero, fontSize: fontSizeHeroHeadline)),
          ...extra,
        ],
      ),
    );
  }
}

/// A white pill on the aurora card that opens more about what the card shows (her week's
/// guide). It looks like a button on purpose: owner 2026-11-28, the week must read as tappable.
class HeroAction extends StatelessWidget {
  const HeroAction({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(top: space4),
      child: Material(
        color: _onHero,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: space4, vertical: space2h),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.auto_stories_outlined, size: iconSizeInline, color: p.primarySolid),
              const SizedBox(width: space2),
              Flexible(child: Text(label, style: t.labelLarge?.copyWith(color: p.primarySolid))),
              const SizedBox(width: space1),
              Icon(Icons.chevron_right_rounded, size: iconSizeInline, color: p.primarySolid, textDirection: Directionality.of(context)),
            ]),
          ),
        ),
      ),
    );
  }
}

/// One supporting line of text on the aurora card.
class HeroLine extends StatelessWidget {
  const HeroLine(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: space2),
      child: Text(text, style: t.bodyMedium?.copyWith(color: _onHero.withValues(alpha: 0.92))),
    );
  }
}

/// A boxed note under the hero (awareness, "see a clinician"), on the normal surface.
class HeroNote extends StatelessWidget {
  const HeroNote(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: space3),
      padding: const EdgeInsets.all(space3h),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusNote),
        border: Border.all(color: p.border),
      ),
      child: Text(text, style: t.bodySmall),
    );
  }
}
