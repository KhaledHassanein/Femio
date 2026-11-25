// Remembers, for this run of the app only, that a safety screen was shown.
//
// Why it exists: the rating request (R12.2) must never follow a warning sign, Help now or an
// assistant safety notice in the same session. Those screens sit far from the controller, so
// they mark this flag instead of being handed the controller. It is never saved.

/// The session flag. Reset only by a new app start (or a test).
abstract final class SafetySession {
  static bool _shown = false;

  /// True once any safety screen or notice appeared since femio was opened.
  static bool get shown => _shown;

  /// Called by a safety screen or notice as it is drawn. Idempotent.
  static void mark() => _shown = true;

  /// Clears the flag; for tests.
  static void resetForTest() => _shown = false;
}
