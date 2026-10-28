// Country help numbers for the Help now screen (Egypt and Saudi Arabia).
//
// Why it exists: the register (MR-40 family, docs/compliance/CRISIS_RESOURCES.md)
// allows a phone number only for a country the reader picked, never as a global
// default, and only with the page it was read on. This is the Dart copy of
// `apps/web/src/lib/crisis/country-numbers.ts`; `scripts/crisis-compliance.mjs`
// fails the gate when the two drift or when a number is over a year old.

/// Ambulance or emergency services, or every other line.
enum NumberKind { emergency, support }

/// One number: the service is named by the ARB key `helpNowNumber_<id>`.
class CrisisNumber {
  const CrisisNumber({required this.id, required this.number, required this.kind, required this.sourceUrl});
  final String id;

  /// Digits only, as dialled.
  final String number;
  final NumberKind kind;

  /// The page the number was read on.
  final String sourceUrl;
}

/// Date every number below was last read at its source.
const crisisNumbersChecked = '2026-10-27';

/// Countries offered, in the order shown. Keys are ISO 3166 alpha-2 codes.
const crisisCountries = ['EG', 'SA'];

const crisisNumbers = <String, List<CrisisNumber>>{
  'EG': [
    CrisisNumber(id: 'eg_ambulance', number: '123', kind: NumberKind.emergency, sourceUrl: 'https://www.facebook.com/EAO.Ambulance.Organization/'),
    CrisisNumber(id: 'eg_mental_health', number: '16328', kind: NumberKind.support, sourceUrl: 'https://www.facebook.com/GSMHATMOHEGYPt/'),
    CrisisNumber(
      id: 'eg_ncw',
      number: '15115',
      kind: NumberKind.support,
      sourceUrl: 'https://ncw.gov.eg/Page/385/%D9%85%D9%83%D8%AA%D8%A8-%D8%B4%D9%83%D8%A7%D9%88%D9%89-%D8%A7%D9%84%D9%85%D8%B1%D8%A3%D8%A9',
    ),
  ],
  'SA': [
    CrisisNumber(id: 'sa_srca', number: '997', kind: NumberKind.emergency, sourceUrl: 'https://www.srca.gov.sa/contact-us/'),
    CrisisNumber(id: 'sa_moh', number: '937', kind: NumberKind.support, sourceUrl: 'https://www.moh.gov.sa/ministry/about/pages/contactus.aspx'),
    CrisisNumber(id: 'sa_moh_mental', number: '920033360', kind: NumberKind.support, sourceUrl: 'https://www.moh.gov.sa/ministry/information-and-services/pages/psychiatry.aspx'),
    CrisisNumber(id: 'sa_hrsd', number: '1919', kind: NumberKind.support, sourceUrl: 'https://www.hrsd.gov.sa/ministry-services/services/%D8%A7%D9%84%D8%A5%D8%A8%D9%84%D8%A7%D8%BA-%D8%B9%D9%86-%D8%A7%D9%84%D8%B9%D9%86%D9%81-%D8%A7%D9%84%D8%A3%D8%B3%D8%B1%D9%8A'),
  ],
};
