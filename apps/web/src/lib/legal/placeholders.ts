/**
 * The four values the legal pages print: company, privacy mailbox, effective date, URL.
 *
 * The privacy policy and terms (docs/33_REBUILD_V3/03_LEGAL_PACK.md §2-3) take them as
 * ICU arguments ({entity}, {email}, {date}), so a change is one edit here, not eight
 * edits across four languages. Filled 2026-10-29 from the owner's dashboard notes:
 * the mailbox is info@femioapp.com for every contact on the site, and version 1 took
 * effect the day the notice went live. The catalogue text already appends
 * ", Cairo, Egypt" after {entity}, so `entity` is the trading name alone; the legal
 * form and registration number are still an open owner action (OWNER_ACTIONS.md).
 *
 * If a value is ever unknown again, put the bracketed marker back ("[EMAIL]") and
 * `PLACEHOLDER_PATTERN` highlights it on the page instead of printing a guess.
 */
export const LEGAL_VALUES = {
  /** Trading name; the catalogue adds ", Cairo, Egypt". Legal form and registration number: owner action. */
  entity: "KM Digital Labs",
  /** The one contact mailbox for the whole site (owner, 2026-10-29). Not yet verified to receive mail. */
  email: "info@femioapp.com",
  /** Effective date of the current version: the day the notice went live. */
  date: "2026-10-29",
  /** Address of the privacy policy. Not printed in the text today. */
  url: "https://femioapp.com/privacy",
  /** Policy and terms version. */
  version: "1",
} as const;

/** Matches any of the unfilled markers, so the page can highlight them. */
export const PLACEHOLDER_PATTERN = /(\[(?:ENTITY|EMAIL|DATE|URL)\])/;
