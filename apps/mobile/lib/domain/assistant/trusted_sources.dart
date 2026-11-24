// Which web sources an "Ask femio" answer may stand on (ADR-078 §3, owner 2026-11-24:
// "I need the AI to get from trusted sources").
//
// Why it exists: the cloud model searches Google, and Google returns whatever ranks. Femio's
// editorial policy already names the sources it trusts (docs/15_EDITORIAL_MEDICAL_REVIEW_POLICY.md
// §4 and docs/04_MEDICAL_DATA_SOURCES.md, Tier 1 and Tier 2). An answer is shown only when at
// least one of its grounding sources is on this list; the others are still listed, as Google
// requires, but marked as not from a trusted source. National health ministries of the launch
// markets are added as Tier 1 (government health bodies, like CDC and NHS).

/// Registrable domains of Tier 1 and Tier 2 sources. A host matches when it equals one of
/// these or ends with "." plus one of these (so `www.nhs.uk` and `nichd.nih.gov` match).
const trustedDomains = <String>[
  // Tier 1: public health bodies (04_MEDICAL_DATA_SOURCES.md)
  'who.int', 'nhs.uk', 'cdc.gov', 'nih.gov', 'medlineplus.gov', 'womenshealth.gov', 'fda.gov', 'clinicaltrials.gov',
  // Tier 1: health ministries of the launch markets and of the app's other languages
  'moh.gov.sa', 'mohp.gov.eg', 'sante.gouv.fr', 'ameli.fr', 'has-sante.fr', 'sanidad.gob.es',
  // Tier 2: professional societies and guideline bodies
  'acog.org', 'rcog.org.uk', 'nice.org.uk', 'menopause.org', 'asrm.org', 'reproductivefacts.org', 'eshre.eu',
  'figo.org', 'fsrh.org', 'endometriosis-uk.org', 'endometriosis.ca', 'iapmd.org', 'monash.edu', 'sart.org',
];

/// True when [hostOrTitle] names a trusted host. Accepts a bare host ("www.nhs.uk"), a URL,
/// or a grounding title, which Google often sets to the site's domain.
bool isTrustedHost(String hostOrTitle) {
  final host = _hostOf(hostOrTitle);
  if (host == null) return false;
  return trustedDomains.any((d) => host == d || host.endsWith('.$d'));
}

String? _hostOf(String value) {
  final v = value.trim().toLowerCase();
  if (v.isEmpty) return null;
  final uri = Uri.tryParse(v.contains('://') ? v : 'https://$v');
  final host = uri?.host ?? '';
  return host.contains('.') ? host : null;
}

/// One web source behind a grounded answer, as the cloud model returned it.
class WebSource {
  const WebSource({required this.title, required this.uri});

  /// The page or site title Google gave (often the domain).
  final String title;

  /// The link Google gave (may be a Google redirect to the page).
  final String uri;

  /// Trusted when either the title or the link names a trusted host.
  bool get trusted => isTrustedHost(title) || isTrustedHost(uri);
}

/// True when an answer may be shown: at least one source is trusted.
bool hasTrustedSource(List<WebSource> sources) => sources.any((s) => s.trusted);
