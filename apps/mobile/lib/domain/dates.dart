/// Date-only helpers over ISO `YYYY-MM-DD` strings, in UTC.
///
/// Twin of `apps/web/src/lib/calculators/dates.ts`. Dates stay strings at the
/// domain boundary for the same reason they do there: a day is not an instant,
/// and doing the arithmetic in UTC keeps daylight-saving changes out of it.
library;

final _iso = RegExp(r'^\d{4}-\d{2}-\d{2}$');

bool isValidISODate(String iso) {
  if (!_iso.hasMatch(iso)) return false;
  final d = DateTime.tryParse('${iso}T00:00:00Z');
  return d != null && toISO(d) == iso;
}

DateTime fromISO(String iso) => DateTime.parse('${iso}T00:00:00Z');

String toISO(DateTime d) {
  final u = d.toUtc();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${u.year.toString().padLeft(4, '0')}-${two(u.month)}-${two(u.day)}';
}

String addDays(String iso, int days) => toISO(fromISO(iso).add(Duration(days: days)));

/// Whole days from [a] to [b] (b − a); negative if b is before a.
int diffDays(String a, String b) =>
    (fromISO(b).difference(fromISO(a)).inHours / 24).round();

/// Today in the device's own calendar, as an ISO date.
String todayISO([DateTime? now]) {
  final n = now ?? DateTime.now();
  return toISO(DateTime.utc(n.year, n.month, n.day));
}
