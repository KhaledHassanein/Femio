// When femio may ask for a Play rating, and how it offers an update (R12.2, R12.3).
//
// Why it exists: both prompts interrupt her, so the rules for when they may appear live in
// one pure file with tests, not in a screen. Google Play shows the actual dialogs; femio
// only decides whether to ask, and sends nothing of her own.

/// The build number in pubspec.yaml (`version: x.y.z+build`). A test keeps them equal, so
/// "once per version" really means once per release.
const appBuild = 1;

/// She must have opened femio on this many different days before the one rating request
/// (owner 2026-11-25).
const reviewAfterDistinctDays = 6;

/// Google Play update priority runs 0 to 5, set by us when a release is uploaded. From this
/// value up, the update is offered full screen instead of as a quiet banner.
const highUpdatePriority = 4;

/// Counts [today] as a day of use. Returns the new count and last day; the count rises only
/// when [today] differs from [lastDay], so opening femio ten times in one day counts once.
({int days, String lastDay}) countUsageDay(int days, String? lastDay, String today) =>
    lastDay == today ? (days: days, lastDay: today) : (days: days + 1, lastDay: today);

/// Whether this calm moment may ask Google Play for a rating.
///
/// [usageDays] is the count of distinct days she opened femio; [askedForBuild] is the build
/// that last asked (null when never); [safetyShownThisSession] is true when a warning sign,
/// Help now or an assistant safety notice appeared since femio was opened. The caller only
/// calls this after a saved log, so a loss or a goal change never triggers it.
bool shouldAskForReview({
  required int usageDays,
  required int? askedForBuild,
  required bool safetyShownThisSession,
  int build = appBuild,
}) =>
    usageDays >= reviewAfterDistinctDays && askedForBuild != build && !safetyShownThisSession;

/// How an available update is offered.
enum UpdatePrompt {
  /// No update, or Play allows no in-app flow.
  none,

  /// A quiet card with an "Update" button; she can ignore it.
  banner,

  /// Play's full-screen update, only for a release we marked high priority.
  immediate,
}

/// Picks the prompt from what Google Play reports. [priority] is the release's in-app
/// update priority (0 to 5); [immediateAllowed] and [flexibleAllowed] are Play's own flags.
UpdatePrompt updatePromptFor({
  required bool available,
  required int priority,
  required bool immediateAllowed,
  required bool flexibleAllowed,
}) {
  if (!available) return UpdatePrompt.none;
  if (priority >= highUpdatePriority && immediateAllowed) return UpdatePrompt.immediate;
  if (flexibleAllowed || immediateAllowed) return UpdatePrompt.banner;
  return UpdatePrompt.none;
}
