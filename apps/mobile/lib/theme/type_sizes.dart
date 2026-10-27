// Font and icon sizes that screens set directly, outside the text theme.
//
// Why it exists: most text takes its size from the theme (femio_theme.dart); these are
// the few places a screen overrides it, kept as named values so each override can be
// found and reviewed against docs/12 (body text at least 16px).

/// The "femio" wordmark on the welcome screen.
const double fontSizeWordmark = 48;

/// The headline inside the Today hero card.
const double fontSizeHeroHeadline = 32;

/// Language pill label on the welcome screen. A label, not body text.
const double fontSizeLanguagePill = 15;

/// Chip label on the Log screen. A label, not body text.
const double fontSizeChip = 14;

/// Small inline icons that sit beside a caption (the lock, the check in a chip).
const double iconSizeInline = 16;

/// The minus and plus icons of a number stepper.
const double iconSizeStepper = 28;
