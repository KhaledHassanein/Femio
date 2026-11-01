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
  /** Effective date of the current version: the day the notice went live. */
  date: "2026-11-01",
  /** Address of the privacy policy. Not printed in the text today. */
  url: "https://femioapp.com/privacy",
  /** Policy and terms version. */
  version: "2",
} as const;

/** Matches any of the unfilled markers, so the page can highlight them. */
export const PLACEHOLDER_PATTERN = /(\[(?:ENTITY|EMAIL|DATE|URL)\])/;
