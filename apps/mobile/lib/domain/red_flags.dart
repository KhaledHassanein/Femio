// The pregnancy red-flag list (MR-29): the sourced symptoms and where they come from.
//
// Why it exists: the sentence she reads is the website's reviewed one (ARB key
// `pregRedFlagsBody`, copied from `calculators.rules.redFlag` by
// scripts/mobile/sync-log-vocabulary.mjs, which fails the gate if the two drift). The
// list form and the sources live here so that no screen inlines them (ADR-070).
// Bleeding and reduced movements are deliberately absent: the register has no source
// for them yet (MR-29, owner to confirm).

/// The five symptoms of the sourced list, in the order the sentence names them. The
/// screen looks each one's label up in the ARB files.
enum RedFlagSymptom { headache, vision, upperAbdomen, swelling, breathing }

/// Where the list comes from. [title] is the document's own (English) title; [host]
/// is shown so she can find the page herself, since the app opens nothing.
class RedFlagSource {
  const RedFlagSource({required this.name, required this.title, required this.host, required this.url});
  final String name;
  final String title;
  final String host;
  final String url;
}

/// The two sources named in the medical rules register for MR-29
/// (docs/compliance/PREGNANCY_BP_SAFETY.md lists both with their access dates).
const pregnancyRedFlagSources = <RedFlagSource>[
  RedFlagSource(
    name: 'ACOG',
    title: 'Preeclampsia and High Blood Pressure During Pregnancy',
    host: 'acog.org',
    url: 'https://www.acog.org/womens-health/faqs/preeclampsia-and-high-blood-pressure-during-pregnancy',
  ),
  RedFlagSource(
    name: 'CDC Hear Her',
    title: 'Urgent Maternal Warning Signs',
    host: 'cdc.gov',
    url: 'https://www.cdc.gov/hearher/maternal-warning-signs/index.html',
  ),
];

/// The guide in Learn that carries the same list with its sources, for the link at
/// the foot of the screen.
const redFlagsGuideSlug = 'pregnancy-warning-signs';
