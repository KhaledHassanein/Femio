/// Contraction timing: the arithmetic, on its own. Twin of
/// `apps/web/src/lib/contractions/index.ts`, bound to it by
/// `fixtures/domain/contractions.json`.
///
/// Duration (how long one lasted) and interval (start of one to start of the next),
/// averaged over the latest few. Those are the two numbers a midwife asks for on the
/// phone, and having them ready is the whole feature.
///
/// **It does not decide whether this is labour.** No labour test, no stage, no 5-1-1
/// evaluation, no "getting closer": an app that told her "not yet" from a stopwatch
/// would be making a clinical call with the worst failure mode in the product
/// (rule 1). The screen puts the maternity-unit route above the numbers, always.
library;

class Contraction {
  const Contraction(this.id, this.startedAt, this.endedAt);

  final String id;

  /// ISO timestamps (UTC).
  final String startedAt;

  /// Null while one is in progress, or when she never stopped it.
  final String? endedAt;

  Contraction end(String at) => Contraction(id, startedAt, at);

  Map<String, Object?> toJson() => {'id': id, 'startedAt': startedAt, 'endedAt': endedAt};
  static Contraction fromJson(Map<String, Object?> j) =>
      Contraction(j['id'] as String, j['startedAt'] as String, j['endedAt'] as String?);
}

class TimedContraction {
  const TimedContraction(this.contraction, this.durationSeconds, this.intervalSeconds);
  final Contraction contraction;

  /// Null while it is still running.
  final int? durationSeconds;

  /// From the previous start; null for the first, where a zero would drag averages down.
  final int? intervalSeconds;
}

/// How many recent contractions the averages look at.
const recentWindow = 5;

int _seconds(String from, String to) {
  final ms = DateTime.parse(to).difference(DateTime.parse(from)).inMilliseconds;
  final s = (ms / 1000).round();
  return s < 0 ? 0 : s;
}

/// Oldest first, each with its duration and the gap since the previous start. Sorted
/// here, not trusted from storage: an interval depends on which one came before it.
List<TimedContraction> timeContractions(Iterable<Contraction> contractions) {
  final sorted = [...contractions]..sort((a, b) => a.startedAt.compareTo(b.startedAt));
  return [
    for (var i = 0; i < sorted.length; i++)
      TimedContraction(
        sorted[i],
        sorted[i].endedAt == null ? null : _seconds(sorted[i].startedAt, sorted[i].endedAt!),
        i == 0 ? null : _seconds(sorted[i - 1].startedAt, sorted[i].startedAt),
      ),
  ];
}

class ContractionSummary {
  const ContractionSummary(this.counted, this.averageDurationSeconds, this.averageIntervalSeconds);
  final int counted;
  final int? averageDurationSeconds;
  final int? averageIntervalSeconds;

  Map<String, Object?> toJson() => {
        'counted': counted,
        'averageDurationSeconds': averageDurationSeconds,
        'averageIntervalSeconds': averageIntervalSeconds,
      };
}

int? _mean(Iterable<int> values) {
  if (values.isEmpty) return null;
  // JS Math.round: halves round up, which Dart's round() matches for positives.
  return (values.reduce((a, b) => a + b) / values.length).round();
}

/// The two numbers she will be asked for, over the latest few rather than all night.
ContractionSummary summarize(List<TimedContraction> timed, {int window = recentWindow}) {
  final recent = timed.length > window ? timed.sublist(timed.length - window) : timed;
  return ContractionSummary(
    recent.length,
    _mean(recent.map((c) => c.durationSeconds).whereType<int>()),
    _mean(recent.map((c) => c.intervalSeconds).whereType<int>()),
  );
}

/// The one still running, if any. Only the last can be: an earlier unfinished one was
/// abandoned, and treating it as live would leave a timer counting up from hours ago.
TimedContraction? inProgress(List<TimedContraction> timed) =>
    timed.isNotEmpty && timed.last.contraction.endedAt == null ? timed.last : null;

/// `m:ss`, the shape a stopwatch reads in, whatever the language.
String formatDuration(int totalSeconds) =>
    '${totalSeconds ~/ 60}:${(totalSeconds % 60).toString().padLeft(2, '0')}';
