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

/// The Hijri day under a Gregorian day, and the Hijri month line under the month title.
const double fontSizeHijriDay = 12;

/// The circle that holds a day number on the calendar.
const double calendarDayDiameter = 36;

/// Calendar row height when the Hijri day is shown: number 36 + Hijri 12 + breathing room.
const double calendarRowHeightWithHijri = 52;

/// Diameter of the numbered source badge beside an Ask femio answer.
const double sourceBadgeDiameter = 28;

/// The "+" circle in the navigation bar (R8.29): larger than a tab icon, inside the bar's height.
const double addButtonSize = 44;
