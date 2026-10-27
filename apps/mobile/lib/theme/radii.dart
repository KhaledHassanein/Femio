// Corner radii for cards, tiles, fields and bars.
//
// Why it exists: the same "card" corner was typed as 20, 24 or 28 in different places.
// The six scale names mirror `--radius-*` in assets/brand/tokens/femio.tokens.css, so a
// card on the phone and a card on the website round the same way.

/// 6px. `--radius-xs`.
const double radiusXs = 6;

/// 10px. `--radius-sm`.
const double radiusSm = 10;

/// 16px. `--radius-md`: fields and small tiles.
const double radiusMd = 16;

/// 24px. `--radius-lg`: the standard card.
const double radiusLg = 24;

/// 32px. `--radius-xl`.
const double radiusXl = 32;

/// A full capsule. `--radius-pill` (999px): any radius at least half the height draws
/// the same shape, so progress bars, chips and the date strip share one name.
const double radiusPill = 999;

// Off-scale corners the existing screens use. Named so they are visible and can be
// folded into the scale in one design pass; changing them here would change pixels.

/// 18px: the small note card under a hero.
const double radiusNote = 18;

/// 20px: a tappable option tile.
const double radiusOption = 20;

/// 28px: the aurora hero card on Today.
const double radiusHero = 28;

/// 9px: the pill-shaped meter drawn on the hero (half its 18px height).
const double radiusMeter = 9;

/// 4px: one segment of the pregnancy bar.
const double radiusSegment = 4;
