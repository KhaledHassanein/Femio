// The AI ledger: a list, kept only on her phone, of every time femio used a model (R10.3, U34).
//
// Why it exists: "what did the AI do with my data?" deserves an answer she can check, not a
// promise. Each entry says which use ran, when, and where (on the phone or in Google's cloud).
// For a Cloud boost call it keeps the exact text that left the phone, as her receipt. Nothing
// from a phone-only call is stored: her own words stay where they were. The list is not part
// of her record, so it is never in a backup, and "delete everything" removes it.

import 'uses.dart';

/// The most entries kept; the oldest go first.
const maxLedgerEntries = 200;

/// One model call.
class LedgerEntry {
  const LedgerEntry({required this.at, required this.use, required this.cloud, required this.answered, this.sent});

  /// When the call was made, an ISO 8601 UTC timestamp.
  final String at;
  final AssistantUse use;

  /// True when the request may have left the phone (Cloud boost); false for Gemini Nano.
  final bool cloud;

  /// False when no usable reply came back in time and femio kept its rules answer.
  final bool answered;

  /// For a cloud call: exactly what was sent. Always null for a phone call.
  final String? sent;

  Map<String, Object?> toJson() => {'at': at, 'use': use.name, 'cloud': cloud, 'answered': answered, 'sent': sent};

  /// Reads one entry; null for an entry this build cannot read (an unknown use, a bad field).
  static LedgerEntry? fromJson(Object? j) {
    if (j is! Map) return null;
    final use = AssistantUse.values.where((u) => u.name == j['use']).firstOrNull;
    final at = j['at'];
    if (use == null || at is! String) return null;
    final cloud = j['cloud'] == true;
    return LedgerEntry(
      at: at,
      use: use,
      cloud: cloud,
      answered: j['answered'] == true,
      sent: cloud && j['sent'] is String ? j['sent'] as String : null,
    );
  }
}

/// [ledger] with [entry] first, capped at [maxLedgerEntries]. A phone entry never keeps text.
List<LedgerEntry> addToLedger(List<LedgerEntry> ledger, LedgerEntry entry) => [
      entry.cloud || entry.sent == null
          ? entry
          : LedgerEntry(at: entry.at, use: entry.use, cloud: false, answered: entry.answered),
      ...ledger,
    ].take(maxLedgerEntries).toList();
