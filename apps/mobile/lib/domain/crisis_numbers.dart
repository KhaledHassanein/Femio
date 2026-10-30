// Country help numbers for the Help now screen: the same sixteen countries and 37
// numbers as the website, every one read on an official page (R6.16, R6.17).
//
// Why it exists: the register (MR-39/MR-40, docs/compliance/CRISIS_RESOURCES.md)
// allows a phone number only for a country the reader picked, never as a global
// default, and only with the page it was read on. This is the Dart twin of
// `apps/web/src/lib/crisis/country-numbers.ts`: same country slugs, in the same order,
// same ids (hyphens become underscores so they can be ARB keys), same numbers, kinds
// and source pages. `scripts/crisis-compliance.mjs` fails the gate when the two drift
// or when a number is over a year old. Edit the TypeScript file first, then this one.

/// Ambulance, police or a unified emergency number, or every other line.
enum NumberKind { emergency, support }

/// One number: the service is named by the ARB key `helpNowNumber_<id>`.
class CrisisNumber {
  const CrisisNumber({required this.id, required this.number, required this.kind, required this.sourceUrl});
  final String id;

  /// Digits only, as dialled inside the country.
  final String number;
  final NumberKind kind;

  /// The page the number was read on.
  final String sourceUrl;
}

/// Date every number below was last read at its source.
const crisisNumbersChecked = '2026-10-30';

/// Countries offered, in the order shown (Arabic-speaking first, then the countries of
/// the other three UI languages). The country name is the ARB key `helpNowCountry_<slug>`.
const crisisCountries = ['egypt', 'saudi', 'uae', 'qatar', 'kuwait', 'bahrain', 'oman', 'jordan', 'lebanon', 'morocco', 'uk', 'france', 'spain', 'usa', 'canada', 'mexico'];

const crisisNumbers = <String, List<CrisisNumber>>{
  'egypt': [
    CrisisNumber(id: 'eg_ambulance', number: '123', kind: NumberKind.emergency, sourceUrl: 'https://eao.gov.eg/faq'),
    CrisisNumber(id: 'eg_mental_health', number: '16328', kind: NumberKind.support, sourceUrl: 'https://www.mohp.gov.eg/NewsDetails.aspx?subject_id=5901'),
    CrisisNumber(id: 'eg_ncw', number: '15115', kind: NumberKind.support, sourceUrl: 'https://ncw.gov.eg/Page/385/%D9%85%D9%83%D8%AA%D8%A8-%D8%B4%D9%83%D8%A7%D9%88%D9%89-%D8%A7%D9%84%D9%85%D8%B1%D8%A3%D8%A9'),
  ],
  'saudi': [
    CrisisNumber(id: 'sa_srca', number: '997', kind: NumberKind.emergency, sourceUrl: 'https://www.srca.gov.sa/contact-us/'),
    CrisisNumber(id: 'sa_moh', number: '937', kind: NumberKind.support, sourceUrl: 'https://www.moh.gov.sa/ministry/about/pages/contactus.aspx'),
    CrisisNumber(id: 'sa_moh_mental', number: '920033360', kind: NumberKind.support, sourceUrl: 'https://www.moh.gov.sa/ministry/information-and-services/pages/psychiatry.aspx'),
    CrisisNumber(id: 'sa_hrsd', number: '1919', kind: NumberKind.support, sourceUrl: 'https://www.hrsd.gov.sa/ministry-services/services/%D8%A7%D9%84%D8%A5%D8%A8%D9%84%D8%A7%D8%BA-%D8%B9%D9%86-%D8%A7%D9%84%D8%B9%D9%86%D9%81-%D8%A7%D9%84%D8%A3%D8%B3%D8%B1%D9%8A'),
  ],
  'uae': [
    CrisisNumber(id: 'ae_ambulance', number: '998', kind: NumberKind.emergency, sourceUrl: 'https://u.ae/en/information-and-services/justice-safety-and-the-law/Safety/handling-emergencies'),
  ],
  'qatar': [
    CrisisNumber(id: 'qa_emergency', number: '999', kind: NumberKind.emergency, sourceUrl: 'https://hamad.qa/EN/Emergency/Pages/Life-ThreateningMedicalEmergency.aspx'),
    CrisisNumber(id: 'qa_mental', number: '16000', kind: NumberKind.support, sourceUrl: 'https://www.hamad.qa/EN/news/2025/April/Pages/National-Mental-Health-Helpline-Celebrates-Milestone-in-Providing-Specialized-Support-Across-Qatar.aspx'),
  ],
  'kuwait': [
    CrisisNumber(id: 'kw_emergency', number: '112', kind: NumberKind.emergency, sourceUrl: 'https://www.moi.gov.kw/main/eservices/civildefence?culture=en'),
  ],
  'bahrain': [
    CrisisNumber(id: 'bh_emergency', number: '999', kind: NumberKind.emergency, sourceUrl: 'https://www.bahrain.bh/wps/portal/en/BNP/DirectoryOfEmergencyHotlineNumbers'),
  ],
  'oman': [
    CrisisNumber(id: 'om_emergency', number: '9999', kind: NumberKind.emergency, sourceUrl: 'https://gov.om/en/emergency-numbers1'),
    CrisisNumber(id: 'om_dv', number: '80077788', kind: NumberKind.support, sourceUrl: 'https://gov.om/en/emergency-numbers1'),
  ],
  'jordan': [
    CrisisNumber(id: 'jo_emergency', number: '911', kind: NumberKind.emergency, sourceUrl: 'https://jordan.gov.jo/EN/List/Contact_Us_2'),
    CrisisNumber(id: 'jo_ambulance', number: '193', kind: NumberKind.emergency, sourceUrl: 'https://jordan.gov.jo/EN/List/Contact_Us_2'),
    CrisisNumber(id: 'jo_family', number: '065815826', kind: NumberKind.support, sourceUrl: 'https://jordan.gov.jo/EN/List/Contact_Us_2'),
  ],
  'lebanon': [
    CrisisNumber(id: 'lb_redcross', number: '140', kind: NumberKind.emergency, sourceUrl: 'https://www.redcross.org.lb/ems-article/'),
    CrisisNumber(id: 'lb_lifeline', number: '1564', kind: NumberKind.support, sourceUrl: 'https://www.moph.gov.lb/en/Pages/0/75325/1564-the-lifeline'),
  ],
  'morocco': [
    CrisisNumber(id: 'ma_samu', number: '15', kind: NumberKind.emergency, sourceUrl: 'https://www.sante.gov.ma/urgences/Pages/default.aspx'),
    CrisisNumber(id: 'ma_police', number: '19', kind: NumberKind.emergency, sourceUrl: 'https://www.sante.gov.ma/urgences/Pages/default.aspx'),
  ],
  'uk': [
    CrisisNumber(id: 'gb_999', number: '999', kind: NumberKind.emergency, sourceUrl: 'https://www.nhs.uk/nhs-services/urgent-and-emergency-care-services/when-to-call-999/'),
    CrisisNumber(id: 'gb_111', number: '111', kind: NumberKind.support, sourceUrl: 'https://www.nhs.uk/nhs-services/mental-health-services/where-to-get-urgent-help-for-mental-health/'),
    CrisisNumber(id: 'gb_refuge', number: '08082000247', kind: NumberKind.support, sourceUrl: 'https://www.gov.uk/guidance/domestic-abuse-how-to-get-help'),
  ],
  'france': [
    CrisisNumber(id: 'fr_samu', number: '15', kind: NumberKind.emergency, sourceUrl: 'https://www.masecurite.interieur.gouv.fr/fr/fiches-pratiques/famille-et-aides-aux-victimes/numeros-utiles-nationaux'),
    CrisisNumber(id: 'fr_3114', number: '3114', kind: NumberKind.support, sourceUrl: 'https://3114.fr/'),
    CrisisNumber(id: 'fr_3919', number: '3919', kind: NumberKind.support, sourceUrl: 'https://arretonslesviolences.gouv.fr/contact'),
  ],
  'spain': [
    CrisisNumber(id: 'es_112', number: '112', kind: NumberKind.emergency, sourceUrl: 'https://violenciagenero.igualdad.gob.es/informacion-3/recursos/telefono016/'),
    CrisisNumber(id: 'es_024', number: '024', kind: NumberKind.support, sourceUrl: 'https://www.sanidad.gob.es/linea024/materiales-de-campanna/home.htm'),
    CrisisNumber(id: 'es_016', number: '016', kind: NumberKind.support, sourceUrl: 'https://violenciagenero.igualdad.gob.es/informacion-3/recursos/telefono016/'),
  ],
  'usa': [
    CrisisNumber(id: 'us_911', number: '911', kind: NumberKind.emergency, sourceUrl: 'https://www.usa.gov/report-crime'),
    CrisisNumber(id: 'us_988', number: '988', kind: NumberKind.support, sourceUrl: 'https://www.usa.gov/mental-health'),
    CrisisNumber(id: 'us_ndvh', number: '18007997233', kind: NumberKind.support, sourceUrl: 'https://womenshealth.gov/relationships-and-safety/get-help'),
  ],
  'canada': [
    CrisisNumber(id: 'ca_911', number: '911', kind: NumberKind.emergency, sourceUrl: 'https://www.canada.ca/en/public-health/services/mental-health-services/mental-health-get-help.html'),
    CrisisNumber(id: 'ca_988', number: '988', kind: NumberKind.support, sourceUrl: 'https://www.canada.ca/en/public-health/services/mental-health-services/mental-health-get-help.html'),
  ],
  'mexico': [
    CrisisNumber(id: 'mx_911', number: '911', kind: NumberKind.emergency, sourceUrl: 'https://www.gob.mx/911'),
    CrisisNumber(id: 'mx_vida', number: '8009112000', kind: NumberKind.support, sourceUrl: 'https://www.gob.mx/conasama/articulos/linea-de-la-vida-800-911-2000'),
  ],
};
