/**
 * The four values the legal pages print: company, privacy mailbox, effective date, URL.
 *
 * The privacy policy and terms (docs/33_REBUILD_V3/03_LEGAL_PACK.md §2-3) take them as
 * ICU arguments ({entity}, {email}, {date}), so a change is one edit here, not eight
 * edits across four languages. Filled 2026-10-29 from the owner's dashboard notes:
 * the mailbox is info@femioapp.com for every contact on the site, and version 1 took
 * effect the day the notice went live. The catalogue text already appends
 * ", Cairo, Egypt" after {entity}, so `entity` is the trading name alone; the legal
 * form (sole proprietorship) is written into the catalogue text and the register number is `registration` below (owner, 2026-10-30).
 *
 * If a value is ever unknown again, put the bracketed marker back ("[EMAIL]") and
 * `PLACEHOLDER_PATTERN` highlights it on the page instead of printing a guess.
 */
export const LEGAL_VALUES = {
  /** Trading name; the catalogue adds ", Cairo, Egypt". The legal form (sole proprietorship) is named in the catalogue; the register number is below. */
  entity: "KM Digital Labs",
  /** Commercial register number of the sole proprietorship (owner, 2026-10-30). The catalogue names the legal form in words. */
  registration: "682-374-954",
  /** The one contact mailbox for the whole site (owner, 2026-10-29; the owner confirmed it receives mail, 2026-10-30). */
  email: "info@femioapp.com",
  /** Address of the privacy policy. Not printed in the text today. */
  url: "https://femioapp.com/privacy",
} as const;

/**
 * Edition of each legal page: its own effective date and version.
 *
 * The privacy policy was rewritten for ADR-080 (no app ads, no GA4/Meta, Cloud boost
 * consent) and the consumer health data policy is new, while the terms did not change,
 * so a shared date would misstate when the terms took effect. The owner sets the
 * privacy and health-data date to the day this version is deployed (OWNER_ACTIONS 31).
 *
 * 2026-11-27 (R14.2, R14.14): the privacy policy moved to version 3 and the health data
 * policy to version 2 after the audit's truth pass (redaction wording, the full health
 * record, birth-year purpose, lock-screen words, sharing and export, the NEXT_LOCALE
 * cookie). The dates still wait for the deploy day.
 *
 * 2026-11-27 (re-score PRIV-N2-1, PRIV-9): health data policy version 3 names Google's AI
 * usage data and reports about AI answers under "Who receives it"; both dates set to the
 * deploy day, 27 Nov (v3 privacy was deployed that morning).
 */
export const LEGAL_EDITIONS = {
  privacy: { date: "2026-11-27", version: "3" },
  terms: { date: "2026-10-29", version: "1" },
  healthData: { date: "2026-11-27", version: "3" },
} as const;

/** Matches any of the unfilled markers, so the page can highlight them. */
export const PLACEHOLDER_PATTERN = /(\[(?:ENTITY|EMAIL|DATE|URL)\])/;
