// The pregnancy red-flag list (MR-29): the sourced symptoms and where they come from.
//
// Why it exists: the sentence she reads is the website's reviewed one (ARB key
// `pregRedFlagsBody`, copied from `calculators.rules.redFlag` by
// scripts/mobile/sync-log-vocabulary.mjs, which fails the gate if the two drift). The
// list form and the sources live here so that no screen inlines them (ADR-070).
// Bleeding and a change in the baby's movements joined the list on 2026-10-30 (R4.14)
// once the register named their NHS pages (MR-29, owner's go-ahead).

/// The seven symptoms of the sourced list, in the order the sentence names them. The
/// screen looks each one's label up in the ARB files.
enum RedFlagSymptom { headache, vision, upperAbdomen, swelling, breathing, bleeding, movements }

/// Where the list comes from. [title] is the document's own (English) title; [host]
/// is shown so she can find the page herself, since the app opens nothing.
class RedFlagSource {
  const RedFlagSource({required this.name, required this.title, required this.host, required this.url});
  final String name;
  final String title;
  final String host;
  final String url;
}

/// The four sources named in the medical rules register for MR-29
/// (docs/compliance/PREGNANCY_BP_SAFETY.md lists them with their access dates).
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
  RedFlagSource(
    name: 'NHS',
    title: 'Vaginal bleeding in pregnancy',
    host: 'nhs.uk',
    url: 'https://www.nhs.uk/pregnancy/common-symptoms/vaginal-bleeding/',
  ),
  RedFlagSource(
    name: 'NHS',
    title: "Your baby's movements",
    host: 'nhs.uk',
    url: 'https://www.nhs.uk/pregnancy/keeping-well/your-babys-movements/',
  ),
];

/// The guide in Learn that carries the same list with its sources, for the link at
/// the foot of the screen.
const redFlagsGuideSlug = 'pregnancy-warning-signs';
