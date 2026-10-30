/**
 * Country-specific help numbers for the /help-now page: sixteen countries, every number
 * read on an official page (a government portal, the national health service, or the
 * operator's own site) on the date in `COUNTRY_NUMBERS_CHECKED`. The Arabic-speaking
 * countries come first, then the countries of the other three UI languages. No number
 * comes from a social-media page (owner's note, 2026-10-30, R6.16).
 *
 * The rules from docs/compliance/CRISIS_RESOURCES.md still hold, and the page enforces them:
 *  - numbers appear only once the reader picks a country, never as a global default;
 *  - the global guidance (crisis.json, the guarded wording) is always shown first;
 *  - emergency services and support lines are drawn apart, emergency first;
 *  - the labels name the operator and promise nothing (no cost, hours, language,
 *    confidentiality or dispatch);
 *  - re-check every number every 12 months (`COUNTRY_NUMBERS_CHECKED` + 1 year);
 *  - a country with no verified official page is not listed; the page points to the
 *    Find a Helpline directory instead.
 *
 * This file is data only, so the numbers can be audited in one place. The service
 * names live in the `helpNow.numbers.<id>` message keys and the country names in
 * `helpNow.countries.<id>` (all four languages).
 *
 * NOT SHIPPED (no official page found on 2026-10-30): Saudi 911 and 999; Egypt
 * 08008880700, 105 and 15335; Qatar 16003; Bahrain 80008006; Algeria, Tunisia and Iraq.
 */

/** Date every number below was last read at its source (ISO 8601). */
export const COUNTRY_NUMBERS_CHECKED = "2026-10-30";

export const COUNTRY_IDS = [
  "egypt",
  "saudi",
  "uae",
  "qatar",
  "kuwait",
  "bahrain",
  "oman",
  "jordan",
  "lebanon",
  "morocco",
  "uk",
  "france",
  "spain",
  "usa",
  "canada",
  "mexico",
] as const;
export type CountryId = (typeof COUNTRY_IDS)[number];

/** `emergency` = ambulance / police / unified emergency number. `support` = every other line. */
export type NumberKind = "emergency" | "support";

export type CountryNumber = {
  /** Message key suffix: `helpNow.numbers.<id>` holds the service name. */
  id: string;
  /** Digits only, as dialled inside the country. */
  number: string;
  kind: NumberKind;
  /** The page the number was read on. */
  sourceUrl: string;
};

export const COUNTRY_NUMBERS: Record<CountryId, readonly CountryNumber[]> = {
  egypt: [
    {
      id: "eg-ambulance",
      number: "123",
      kind: "emergency",
      sourceUrl: "https://eao.gov.eg/faq",
    },
    {
      id: "eg-mental-health",
      number: "16328",
      kind: "support",
      sourceUrl: "https://www.mohp.gov.eg/NewsDetails.aspx?subject_id=5901",
    },
    {
      id: "eg-ncw",
      number: "15115",
      kind: "support",
      sourceUrl:
        "https://ncw.gov.eg/Page/385/%D9%85%D9%83%D8%AA%D8%A8-%D8%B4%D9%83%D8%A7%D9%88%D9%89-%D8%A7%D9%84%D9%85%D8%B1%D8%A3%D8%A9",
    },
  ],
  saudi: [
    {
      id: "sa-srca",
      number: "997",
      kind: "emergency",
      sourceUrl: "https://www.srca.gov.sa/contact-us/",
    },
    {
      id: "sa-moh",
      number: "937",
      kind: "support",
      sourceUrl: "https://www.moh.gov.sa/ministry/about/pages/contactus.aspx",
    },
    {
      id: "sa-moh-mental",
      number: "920033360",
      kind: "support",
      // The page attributes it to the Ministry's call centre.
      sourceUrl: "https://www.moh.gov.sa/ministry/information-and-services/pages/psychiatry.aspx",
    },
    {
      id: "sa-hrsd",
      number: "1919",
      kind: "support",
      sourceUrl:
        "https://www.hrsd.gov.sa/ministry-services/services/%D8%A7%D9%84%D8%A5%D8%A8%D9%84%D8%A7%D8%BA-%D8%B9%D9%86-%D8%A7%D9%84%D8%B9%D9%86%D9%81-%D8%A7%D9%84%D8%A3%D8%B3%D8%B1%D9%8A",
    },
  ],
  uae: [
    {
      id: "ae-ambulance",
      number: "998",
      kind: "emergency",
      sourceUrl:
        "https://u.ae/en/information-and-services/justice-safety-and-the-law/Safety/handling-emergencies",
    },
  ],
  qatar: [
    {
      id: "qa-emergency",
      number: "999",
      kind: "emergency",
      sourceUrl: "https://hamad.qa/EN/Emergency/Pages/Life-ThreateningMedicalEmergency.aspx",
    },
    {
      id: "qa-mental",
      number: "16000",
      kind: "support",
      // Option 4 of the 16000 menu; the label says so.
      sourceUrl:
        "https://www.hamad.qa/EN/news/2025/April/Pages/National-Mental-Health-Helpline-Celebrates-Milestone-in-Providing-Specialized-Support-Across-Qatar.aspx",
    },
  ],
  kuwait: [
    {
      id: "kw-emergency",
      number: "112",
      kind: "emergency",
      sourceUrl: "https://www.moi.gov.kw/main/eservices/civildefence?culture=en",
    },
  ],
  bahrain: [
    {
      id: "bh-emergency",
      number: "999",
      kind: "emergency",
      sourceUrl: "https://www.bahrain.bh/wps/portal/en/BNP/DirectoryOfEmergencyHotlineNumbers",
    },
  ],
  oman: [
    {
      id: "om-emergency",
      number: "9999",
      kind: "emergency",
      sourceUrl: "https://gov.om/en/emergency-numbers1",
    },
    {
      id: "om-dv",
      number: "80077788",
      kind: "support",
      sourceUrl: "https://gov.om/en/emergency-numbers1",
    },
  ],
  jordan: [
    {
      id: "jo-emergency",
      number: "911",
      kind: "emergency",
      sourceUrl: "https://jordan.gov.jo/EN/List/Contact_Us_2",
    },
    {
      id: "jo-ambulance",
      number: "193",
      kind: "emergency",
      sourceUrl: "https://jordan.gov.jo/EN/List/Contact_Us_2",
    },
    {
      id: "jo-family",
      number: "065815826",
      kind: "support",
      sourceUrl: "https://jordan.gov.jo/EN/List/Contact_Us_2",
    },
  ],
  lebanon: [
    {
      id: "lb-redcross",
      number: "140",
      kind: "emergency",
      // The operator's own page; no government page lists it.
      sourceUrl: "https://www.redcross.org.lb/ems-article/",
    },
    {
      id: "lb-lifeline",
      number: "1564",
      kind: "support",
      sourceUrl: "https://www.moph.gov.lb/en/Pages/0/75325/1564-the-lifeline",
    },
  ],
  morocco: [
    {
      id: "ma-samu",
      number: "15",
      kind: "emergency",
      sourceUrl: "https://www.sante.gov.ma/urgences/Pages/default.aspx",
    },
    {
      id: "ma-police",
      number: "19",
      kind: "emergency",
      sourceUrl: "https://www.sante.gov.ma/urgences/Pages/default.aspx",
    },
  ],
  uk: [
    {
      id: "gb-999",
      number: "999",
      kind: "emergency",
      sourceUrl:
        "https://www.nhs.uk/nhs-services/urgent-and-emergency-care-services/when-to-call-999/",
    },
    {
      id: "gb-111",
      number: "111",
      kind: "support",
      sourceUrl:
        "https://www.nhs.uk/nhs-services/mental-health-services/where-to-get-urgent-help-for-mental-health/",
    },
    {
      id: "gb-refuge",
      number: "08082000247",
      kind: "support",
      sourceUrl: "https://www.gov.uk/guidance/domestic-abuse-how-to-get-help",
    },
  ],
  france: [
    {
      id: "fr-samu",
      number: "15",
      kind: "emergency",
      sourceUrl:
        "https://www.masecurite.interieur.gouv.fr/fr/fiches-pratiques/famille-et-aides-aux-victimes/numeros-utiles-nationaux",
    },
    {
      id: "fr-3114",
      number: "3114",
      kind: "support",
      sourceUrl: "https://3114.fr/",
    },
    {
      id: "fr-3919",
      number: "3919",
      kind: "support",
      sourceUrl: "https://arretonslesviolences.gouv.fr/contact",
    },
  ],
  spain: [
    {
      id: "es-112",
      number: "112",
      kind: "emergency",
      sourceUrl: "https://violenciagenero.igualdad.gob.es/informacion-3/recursos/telefono016/",
    },
    {
      id: "es-024",
      number: "024",
      kind: "support",
      sourceUrl: "https://www.sanidad.gob.es/linea024/materiales-de-campanna/home.htm",
    },
    {
      id: "es-016",
      number: "016",
      kind: "support",
      sourceUrl: "https://violenciagenero.igualdad.gob.es/informacion-3/recursos/telefono016/",
    },
  ],
  usa: [
    {
      id: "us-911",
      number: "911",
      kind: "emergency",
      sourceUrl: "https://www.usa.gov/report-crime",
    },
    {
      id: "us-988",
      number: "988",
      kind: "support",
      sourceUrl: "https://www.usa.gov/mental-health",
    },
    {
      id: "us-ndvh",
      number: "18007997233",
      kind: "support",
      sourceUrl: "https://womenshealth.gov/relationships-and-safety/get-help",
    },
  ],
  canada: [
    {
      id: "ca-911",
      number: "911",
      kind: "emergency",
      sourceUrl:
        "https://www.canada.ca/en/public-health/services/mental-health-services/mental-health-get-help.html",
    },
    {
      id: "ca-988",
      number: "988",
      kind: "support",
      sourceUrl:
        "https://www.canada.ca/en/public-health/services/mental-health-services/mental-health-get-help.html",
    },
  ],
  mexico: [
    {
      id: "mx-911",
      number: "911",
      kind: "emergency",
      sourceUrl: "https://www.gob.mx/911",
    },
    {
      id: "mx-vida",
      number: "8009112000",
      kind: "support",
      sourceUrl: "https://www.gob.mx/conasama/articulos/linea-de-la-vida-800-911-2000",
    },
  ],
};
