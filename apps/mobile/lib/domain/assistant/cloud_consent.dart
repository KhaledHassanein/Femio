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
// file.
//
// A consent is valid only for the text she saw: when the consent text changes, bump
// [cloudConsentVersion] and every older consent stops counting until she agrees again.

/// The version of the consent screen's wording. Bump it whenever what is sent, who receives
/// it, or what the screen says about it changes; older consents then lapse.
///
/// History: 1 (2026-11-24) said a question is sent with "numbers, dates, names and contacts"
/// removed, which the redaction never did for names or spelled-out dates. 2 (2026-11-27) says
/// what the code does: numbers, e-mail addresses and links are removed, and she sees and edits
/// the exact text before anything is sent.
const cloudConsentVersion = 2;

/// How many receipts are kept; older ones drop off (her record stays small).
const cloudConsentLogLimit = 20;

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
  const CloudConsentEvent({required this.purposes, required this.at, required this.version, this.lang});

  final Set<CloudPurpose> purposes;
  final String at;
  final int version;

  /// The UI language code ("en", "ar", "fr", "es") the consent text was shown in, so the
  /// receipt names the exact wording she read. Null on receipts written before the field
  /// existed, and on a withdrawal recorded where no screen language was at hand.
  final String? lang;

  /// True when this entry records turning Cloud boost off.
  bool get isWithdrawal => purposes.isEmpty;

  Map<String, Object?> toJson() => {
        'purposes': [for (final p in CloudPurpose.values) if (purposes.contains(p)) p.name],
        'at': at,
        'version': version,
        if (lang != null) 'lang': lang,
      };

  /// Reads one entry; returns null for a damaged one rather than guessing. A missing or
  /// malformed `lang` is read as unknown (null), never as a reason to drop the receipt: the
  /// field is additive, so receipts written before it existed still parse.
  static CloudConsentEvent? fromJson(Object? j) {
    if (j is! Map) return null;
    final at = j['at'];
    final version = j['version'];
    final names = j['purposes'];
    final lang = j['lang'];
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
    );
  }
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

  /// The same log with nothing in force: used when a backup is restored onto a phone, so
  /// consent given on one phone is asked for again on the next.
  CloudConsent afterRestore(String at) => any ? withdraw(at) : this;

  CloudConsent _append(CloudConsentEvent e) {
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
