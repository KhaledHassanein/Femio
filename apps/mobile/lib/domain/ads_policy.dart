// Where an advertisement may appear in femio: the one rule, in one place.
//
// Why it exists: ADR-076 lets the app show ads on the guide screens only, and nowhere
// her own record, a crisis line or a warning sign is on screen. Keeping the rule as a
// pure function (no Flutter, no ads SDK) means a screen cannot "just add a banner":
// every placement asks this file, and the test lists every surface so a new screen
// that forgets to be classified fails to compile its `switch`.

/// Every screen family that could, in principle, carry an ad. Adding a screen to the
/// app means adding it here and deciding in [adsAllowed]; the exhaustive `switch`
/// there makes the compiler enforce it.
enum AdSurface {
  /// One guide, read in full.
  article,

  /// The Learn tab: the list of guides.
  learnIndex,

  /// Today, the front screen of the record.
  today,

  /// The log and every logging tool (cycle, symptoms, tools).
  log,

  /// The calendar and its predictions.
  calendar,

  /// Help now: crisis and emergency numbers.
  helpNow,

  /// The warning-signs screens (when to seek care).
  warningSigns,

  /// Settings, backup and privacy.
  settings,

  /// Onboarding, including the age gate.
  onboarding,

  /// The PIN lock screen.
  lock,
}

/// Whether an ad may be shown on [surface].
///
/// True only for [AdSurface.article] and [AdSurface.learnIndex], and only while femio
/// Plus is not active ([plusActive] false). Why these two: the guides are reference
/// reading with no personal data on screen. Ads never sit beside the calendar or the
/// log (her record), a crisis line, or the warning signs (a woman in distress must not
/// be shown a banner), mirroring docs/34_GROWTH_OPS/02_MONETIZATION.md section 1.1.
bool adsAllowed({required AdSurface surface, required bool plusActive}) {
  if (plusActive) return false;
  return switch (surface) {
    AdSurface.article || AdSurface.learnIndex => true,
    AdSurface.today ||
    AdSurface.log ||
    AdSurface.calendar ||
    AdSurface.helpNow ||
    AdSurface.warningSigns ||
    AdSurface.settings ||
    AdSurface.onboarding ||
    AdSurface.lock =>
      false,
  };
}
