// Her consent to Cloud boost, and the receipt that proves it (ADR-079, ADR-080).
//
// Why it exists: the four coarse bands about her are health information, so sending them to
// Google needs explicit consent for that one purpose (GDPR Art. 9(2)(a); Washington's My Health
// My Data Act asks for consent to share separately from consent to collect; Saudi Arabia's PDPL
// and Egypt's Law 151/2020 ask for explicit consent for health data). Explicit consent must be
// specific, so each purpose is its own choice, and the controller must be able to show it was
// given (GDPR Art. 7(1)). femio has no server, so the proof is a receipt kept in her own record:
// what she agreed to, when, to which version of the consent text, and in which language that
// text was shown. She can read it in Settings, and it travels inside her own encrypted backup
// file as proof; a restored backup never grants anything, because restoring adds a withdrawal
// ([afterRestore]) and she agrees again on the new phone (ADR-080 §3).
//
// A consent is valid only for the text she saw: when the consent text changes, bump
// [cloudConsentVersion] and every older consent stops counting until she agrees again.
//
// Since version 3 the same log records every choice made in the one AI wizard: the AI on
// this phone on or off, and Cloud boost per purpose, with the statements she ticked. Each
// receipt is sealed: it carries a SHA-256 of its own content and of the receipt before it,
// so a receipt that was edited, removed from the middle or reordered no longer checks out
// ([CloudConsent.sealIntact]). The seal shows tampering; it is not a signature, because the
// phone that writes it is hers.

import 'dart:convert';

import 'package:cryptography/dart.dart';

/// The version of the consent screen's wording. Bump it whenever what is sent, who receives
/// it, or what the screen says about it changes; older consents then lapse.
///
/// History: 1 (2026-11-24) said a question is sent with "numbers, dates, names and contacts"
/// removed, which the redaction never did for names or spelled-out dates. 2 (2026-11-27) says
/// what the code does: numbers, e-mail addresses and links are removed, and she sees and edits
/// the exact text before anything is sent. 3 (2026-11-27) is the one AI wizard: the same
/// facts, plus the statements she ticks (wellness not diagnosis, privacy notice read) and the
/// AI on this phone recorded in the same receipt.
const cloudConsentVersion = 3;

/// How many receipts are kept; older ones drop off (her record stays small). The first kept
/// receipt still names the seal of the one before it, so the chain stays checkable.
const cloudConsentLogLimit = 50;

/// The statements the wizard asks her to tick, by stable id (the receipt stores the ids; the
/// words are in the app's string catalogue under the same version).
abstract final class AiAck {
  /// femio's AI gives wellness information from trusted sources, not a diagnosis.
  static const wellness = 'wellness-information';

  /// She has read the privacy notice.
  static const notice = 'privacy-notice-read';

  /// She understands what Cloud boost sends, to whom, and that she can withdraw.
  static const cloud = 'cloud-boost-understood';
}

/// The two things Cloud boost may send, each agreed to separately.
enum CloudPurpose {
  /// A general question she approves each time, with the public source passages.
  questions,

  /// Her four coarse bands, to put her tips in order.
  tips,
}

/// One entry in the consent log: she agreed to [purposes] (an empty set records a withdrawal)
/// at [at], an ISO 8601 UTC timestamp, on consent text [version], shown in [lang].
class CloudConsentEvent {
  const CloudConsentEvent({
    required this.purposes,
    required this.at,
    required this.version,
    this.lang,
    this.ai,
    this.acks = const [],
    this.prev,
    this.seal,
  });

  final Set<CloudPurpose> purposes;
  final String at;
  final int version;

  /// The UI language code ("en", "ar", "fr", "es") the consent text was shown in, so the
  /// receipt names the exact wording she read. Null on receipts written before the field
  /// existed, and on a withdrawal recorded where no screen language was at hand.
  final String? lang;

  /// Her AI on this phone after this choice: true on, false off; null on receipts written
  /// before the one wizard (they recorded Cloud boost only).
  final bool? ai;

  /// The [AiAck] ids of the statements she ticked for this choice, in a fixed order.
  final List<String> acks;

  /// The seal of the receipt before this one; null for the first sealed receipt.
  final String? prev;

  /// SHA-256 (hex) of [prev] and this receipt's content; null on receipts written before
  /// seals existed.
  final String? seal;

  /// True when this entry records turning Cloud boost off.
  bool get isWithdrawal => purposes.isEmpty;

  /// The content the seal covers: everything except the seal itself.
  Map<String, Object?> _content() => {
        'purposes': [for (final p in CloudPurpose.values) if (purposes.contains(p)) p.name],
        'at': at,
        'version': version,
        if (lang != null) 'lang': lang,
        if (ai != null) 'ai': ai,
        if (acks.isNotEmpty) 'acks': acks,
        if (prev != null) 'prev': prev,
      };

  /// The seal this receipt should carry: SHA-256 over its content as canonical JSON.
  String computeSeal() => _sha256Hex(jsonEncode(_content()));

  /// A copy carrying [prev] and the matching seal.
  CloudConsentEvent sealedAfter(String? prev) {
    final unsealed = CloudConsentEvent(
      purposes: purposes,
      at: at,
      version: version,
      lang: lang,
      ai: ai,
      acks: acks,
      prev: prev,
    );
    return CloudConsentEvent(
      purposes: purposes,
      at: at,
      version: version,
      lang: lang,
      ai: ai,
      acks: acks,
      prev: prev,
      seal: unsealed.computeSeal(),
    );
  }

  Map<String, Object?> toJson() => {..._content(), if (seal != null) 'seal': seal};

  /// Reads one entry; returns null for a damaged one rather than guessing. A missing or
  /// malformed `lang` is read as unknown (null), never as a reason to drop the receipt: the
  /// field is additive, so receipts written before it existed still parse.
  static CloudConsentEvent? fromJson(Object? j) {
    if (j is! Map) return null;
    final at = j['at'];
    final version = j['version'];
    final names = j['purposes'];
    final lang = j['lang'];
    final ai = j['ai'];
    final acks = j['acks'];
    final prev = j['prev'];
    final seal = j['seal'];
    if (at is! String || version is! num || names is! List) return null;
    final purposes = <CloudPurpose>{
      for (final p in CloudPurpose.values)
        if (names.contains(p.name)) p,
    };
    return CloudConsentEvent(
      purposes: purposes,
      at: at,
      version: version.toInt(),
      lang: lang is String && lang.isNotEmpty ? lang : null,
      ai: ai is bool ? ai : null,
      acks: acks is List ? List.unmodifiable(acks.whereType<String>()) : const [],
      prev: prev is String ? prev : null,
      seal: seal is String ? seal : null,
    );
  }
}

String _sha256Hex(String text) {
  final bytes = const DartSha256().hashSync(utf8.encode(text)).bytes;
  return [for (final b in bytes) b.toRadixString(16).padLeft(2, '0')].join();
}

/// Her current Cloud boost consent: the latest log entry decides.
///
/// Immutable; [grant] and [withdraw] return a new value with one more receipt.
class CloudConsent {
  const CloudConsent({this.log = const []});

  /// Every choice she made, oldest first, at most [cloudConsentLogLimit].
  final List<CloudConsentEvent> log;

  /// The choice in force, or null when she has never chosen.
  CloudConsentEvent? get current => log.isEmpty ? null : log.last;

  /// Whether she has a valid consent for [purpose]: given on today's consent text and not
  /// withdrawn since.
  bool allows(CloudPurpose purpose) {
    final c = current;
    return c != null && c.version == cloudConsentVersion && c.purposes.contains(purpose);
  }

  /// Whether any purpose is allowed (the Settings switch shows On).
  bool get any => CloudPurpose.values.any(allows);

  /// When the consent in force was given, or null when none is in force.
  String? get grantedAt => any ? current!.at : null;

  /// Records that she agreed to [purposes] at [at] (ISO 8601 UTC), on today's consent text
  /// shown in UI language [lang] (for example "ar"). An empty set is a withdrawal.
  CloudConsent grant(Set<CloudPurpose> purposes, String at, {String? lang}) => _append(
        CloudConsentEvent(
          purposes: Set.unmodifiable(purposes),
          at: at,
          version: cloudConsentVersion,
          lang: lang,
        ),
      );

  /// Records that she turned Cloud boost off at [at], from a screen in UI language [lang].
  CloudConsent withdraw(String at, {String? lang}) => grant(const {}, at, lang: lang);

  /// Records one choice from the AI wizard: her AI on this phone [ai], Cloud boost for
  /// [purposes] (empty: off), the statements she ticked [acks], at [at] (ISO 8601 UTC), on
  /// today's consent text shown in [lang].
  CloudConsent choose({
    required bool ai,
    required Set<CloudPurpose> purposes,
    required String at,
    String? lang,
    List<String> acks = const [],
  }) =>
      _append(
        CloudConsentEvent(
          purposes: Set.unmodifiable(purposes),
          at: at,
          version: cloudConsentVersion,
          lang: lang,
          ai: ai,
          acks: List.unmodifiable(acks),
        ),
      );

  /// True when every sealed receipt still matches its content and follows the one before it.
  /// Receipts written before seals existed are skipped; a sealed one after an unsealed one
  /// starts the chain. False means a receipt was edited, removed or reordered.
  bool get sealIntact {
    String? before;
    var sealedSeen = false;
    for (final e in log) {
      if (e.seal == null) {
        if (sealedSeen) return false; // an unsealed receipt after sealed ones was not written by femio
        continue;
      }
      if (e.seal != e.computeSeal()) return false;
      if (sealedSeen && e.prev != before) return false;
      sealedSeen = true;
      before = e.seal;
    }
    return true;
  }

  /// The same log with nothing in force: used when a backup is restored onto a phone, so
  /// consent given on one phone is asked for again on the next.
  CloudConsent afterRestore(String at) => any ? withdraw(at) : this;

  CloudConsent _append(CloudConsentEvent unsealed) {
    final e = unsealed.sealedAfter(log.isEmpty ? null : log.last.seal);
    final next = [...log, e];
    final start = next.length > cloudConsentLogLimit ? next.length - cloudConsentLogLimit : 0;
    return CloudConsent(log: List.unmodifiable(next.sublist(start)));
  }

  Object? toJson() => [for (final e in log) e.toJson()];

  /// Reads the log; damaged entries are dropped, so a damaged log can only ever mean "no
  /// consent", never a consent she did not give.
  static CloudConsent fromJson(Object? j) {
    if (j is! List) return const CloudConsent();
    final events = [for (final e in j) CloudConsentEvent.fromJson(e)].whereType<CloudConsentEvent>().toList();
    final start = events.length > cloudConsentLogLimit ? events.length - cloudConsentLogLimit : 0;
    return CloudConsent(log: List.unmodifiable(events.sublist(start)));
  }
}
