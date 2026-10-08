/// Fetal movement pattern log. Twin of `apps/web/src/lib/pregnancy/movements.ts`,
/// bound to it by `fixtures/domain/movement-pattern.json`.
///
/// There is deliberately no target, no count-to-ten and no "this session was fine":
/// a pass mark reads as reassurance to someone whose baby is moving less than usual,
/// and false reassurance here delays care (rule 1, ADR-049). What this does is
/// arithmetic against *her own* history: minutes per movement, and how the latest
/// session sits against the median of her earlier ones. It surfaces a change; it
/// never interprets one.
library;

class MovementSession {
  const MovementSession(this.id, this.startedAt, this.endedAt, this.movementCount);
  final String id;
  final String startedAt;
  final String? endedAt;
  final int? movementCount;

  Map<String, Object?> toJson() =>
      {'id': id, 'startedAt': startedAt, 'endedAt': endedAt, 'movementCount': movementCount};
  static MovementSession fromJson(Map<String, Object?> j) => MovementSession(
        j['id'] as String,
        j['startedAt'] as String,
        j['endedAt'] as String?,
        j['movementCount'] as int?,
      );
}

/// Completed sessions needed before a comparison is shown at all.
const minSessionsForPattern = 3;

/// Flag at 1.5x her own median gap: a threshold for prompting her to call, biased to
/// prompt too often rather than too rarely. The call route is shown regardless.
const slowerRatio = 1.5;

/// Minutes per movement, or null when it cannot be computed honestly.
double? minutesPerMovement(MovementSession s) {
  if (s.endedAt == null) return null;
  final ms = DateTime.parse(s.endedAt!).difference(DateTime.parse(s.startedAt)).inMilliseconds;
  if (ms <= 0) return null;
  final count = s.movementCount;
  if (count == null || count <= 0) return null;
  return ms / 60000 / count;
}

sealed class PatternComparison {
  const PatternComparison(this.sessions);
  final int sessions;
}

class InsufficientPattern extends PatternComparison {
  const InsufficientPattern(super.sessions);
}

class ComparablePattern extends PatternComparison {
  const ComparablePattern(super.sessions, this.typical, this.latest, this.ratio);
  final double typical;
  final double latest;

  /// Latest over typical; above 1 means movements were further apart.
  final double ratio;

  /// A change worth her noticing, never a verdict.
  bool get slower => ratio >= slowerRatio;
}

double _median(List<double> values) {
  final sorted = [...values]..sort();
  final mid = sorted.length ~/ 2;
  return sorted.length.isOdd ? sorted[mid] : (sorted[mid - 1] + sorted[mid]) / 2;
}

/// The latest session against the median of the earlier ones. [sessions] newest first.
/// Median, not mean: one long session (she put the phone down) would otherwise make
/// every later one look fast and hide exactly the signal this exists for.
PatternComparison comparePattern(List<MovementSession> sessions) {
  final rates = sessions.map(minutesPerMovement).whereType<double>().toList();
  if (rates.length < minSessionsForPattern) return InsufficientPattern(rates.length);
  final typical = _median(rates.sublist(1));
  if (typical == 0) return InsufficientPattern(rates.length);
  return ComparablePattern(rates.length, typical, rates.first, rates.first / typical);
}
