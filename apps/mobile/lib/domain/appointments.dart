/// Appointments: the arithmetic, on its own. Twin of
/// `apps/web/src/lib/appointments/index.ts`, bound to it by `fixtures/domain/appointments.json`.
///
/// When, with whom, what kind, what to ask, and when a result is due back. **Never the
/// result**: the moment an app stores "scan: normal" it is keeping a clinical finding,
/// and the next feature that reads it is interpreting one. A results-due date that has
/// passed means only "it may be worth asking".
library;

import 'dates.dart';

class Appointment {
  const Appointment({
    required this.id,
    this.clinician,
    this.type,
    this.datetime,
    this.prep = const [],
    this.resultsDue,
  });
  final String id;

  /// Free text, her words.
  final String? clinician;
  final String? type;

  /// ISO timestamp; null when she noted one without a date yet.
  final String? datetime;

  /// The questions she wants to ask.
  final List<String> prep;

  /// ISO date she was told to expect a result by. Never a result.
  final String? resultsDue;

  Map<String, Object?> toJson() => {
        'id': id,
        'clinician': clinician,
        'type': type,
        'datetime': datetime,
        'prep': prep,
        'resultsDue': resultsDue,
      };
  static Appointment fromJson(Map<String, Object?> j) => Appointment(
        id: j['id'] as String,
        clinician: j['clinician'] as String?,
        type: j['type'] as String?,
        datetime: j['datetime'] as String?,
        prep: List<String>.from((j['prep'] as List?) ?? const []),
        resultsDue: j['resultsDue'] as String?,
      );
}

String _day(String iso) => iso.substring(0, 10);

/// Ahead (soonest first, undated leading) and behind (most recent first). Today's
/// counts as ahead.
({List<Appointment> upcoming, List<Appointment> past}) splitAppointments(
  Iterable<Appointment> appointments,
  String today,
) {
  final upcoming = <Appointment>[];
  final past = <Appointment>[];
  for (final a in appointments) {
    if (a.datetime == null || _day(a.datetime!).compareTo(today) >= 0) {
      upcoming.add(a);
    } else {
      past.add(a);
    }
  }
  upcoming.sort((a, b) => (a.datetime ?? '').compareTo(b.datetime ?? ''));
  past.sort((a, b) => (b.datetime ?? '').compareTo(a.datetime ?? ''));
  return (upcoming: upcoming, past: past);
}

/// The dated one coming up soonest.
Appointment? nextAppointment(Iterable<Appointment> appointments, String today) {
  for (final a in splitAppointments(appointments, today).upcoming) {
    if (a.datetime != null) return a;
  }
  return null;
}

/// Whole days until it happens; negative once past; null when undated.
int? daysUntil(Appointment a, String today) => a.datetime == null ? null : diffDays(today, _day(a.datetime!));

/// Results she expected by a date now passed: "it may be worth asking", nothing more.
List<Appointment> awaitingResults(Iterable<Appointment> appointments, String today) => [
      for (final a in appointments)
        if (a.resultsDue != null && diffDays(a.resultsDue!, today) > 0) a,
    ]..sort((a, b) => a.resultsDue!.compareTo(b.resultsDue!));

/// Prep questions, one per line; blanks dropped, order and duplicates kept.
List<String> parsePrep(String text) =>
    [for (final line in text.split('\n')) if (line.trim().isNotEmpty) line.trim()];
