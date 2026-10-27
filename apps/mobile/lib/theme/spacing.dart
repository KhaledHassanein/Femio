// Spacing scale for padding, gaps and spacers.
//
// Why it exists: screens used to carry bare numbers (`SizedBox(height: 12)`), so the
// same gap could drift between screens and a design pass meant hunting literals. Every
// name mirrors `--space-*` in assets/brand/tokens/femio.tokens.css (a 4px grid), so
// the app and the website describe the same rhythm in the same words.

/// 4px. `--space-1`.
const double space1 = 4;

/// 8px. `--space-2`.
const double space2 = 8;

/// 12px. `--space-3`.
const double space3 = 12;

/// 16px. `--space-4`.
const double space4 = 16;

/// 20px. `--space-5`.
const double space5 = 20;

/// 24px. `--space-6`.
const double space6 = 24;

/// 32px. `--space-8`.
const double space8 = 32;

/// 40px. `--space-10`.
const double space10 = 40;

/// 48px. `--space-12`. Also the minimum comfortable touch target.
const double space12 = 48;

// Off-grid steps. The screens were drawn with these before the scale existed; they are
// named, not rounded, so that moving to the grid is one deliberate visual change in a
// design pass rather than a side effect of a refactor. "h" reads as "half a step".

/// 2px, a hairline gap between a title and its caption.
const double spaceHalf = 2;

/// 6px.
const double space1h = 6;

/// 10px.
const double space2h = 10;

/// 14px.
const double space3h = 14;

/// 18px.
const double space4h = 18;

/// 22px.
const double space5h = 22;

/// 28px.
const double space7 = 28;
