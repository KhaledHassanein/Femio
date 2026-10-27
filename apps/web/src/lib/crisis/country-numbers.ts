/**
 * Country-specific help numbers for the /help-now page (Egypt and Saudi Arabia).
 *
 * Source: docs/33_REBUILD_V3/03_LEGAL_PACK.md §6, read on 2026-10-27 by the legal
 * session. Each number carries the page it was read on. The rules from
 * docs/compliance/CRISIS_RESOURCES.md still hold, and the page enforces them:
 *  - numbers appear only once the reader picks a country, never as a global default;
 *  - the global guidance (crisis.json, the guarded wording) is always shown first;
 *  - emergency services and support lines are drawn apart;
 *  - the labels name the operator and promise nothing (no cost, hours, language,
 *    confidentiality or dispatch);
 *  - re-check every number every 12 months (`COUNTRY_NUMBERS_CHECKED` + 1 year).
 *
 * This file is data only, so the numbers can be audited in one place. The service
 * names live in the `helpNow.numbers.<id>` message keys (all four languages).
 *
 * NOT SHIPPED until someone reads an official page (pack §6, "Not shipped"): Saudi 911
 * and 999; Egypt 08008880700, 105 and 15335.
 */

/** Date every number below was last read at its source (ISO 8601). */
export const COUNTRY_NUMBERS_CHECKED = "2026-10-27";

export const COUNTRY_IDS = ["egypt", "saudi"] as const;
export type CountryId = (typeof COUNTRY_IDS)[number];

/** `emergency` = ambulance / emergency services. `support` = every other line. */
export type NumberKind = "emergency" | "support";

export type CountryNumber = {
  /** Message key suffix: `helpNow.numbers.<id>` holds the service name. */
  id: string;
  /** Digits only, as dialled. */
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
      // The Organization's own page (official channel). A government web page was not retrieved.
      sourceUrl: "https://www.facebook.com/EAO.Ambulance.Organization/",
    },
    {
      id: "eg-mental-health",
      number: "16328",
      kind: "support",
      // The Secretariat's page. Its own platform shows the hotline only as an image.
      sourceUrl: "https://www.facebook.com/GSMHATMOHEGYPt/",
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
};
