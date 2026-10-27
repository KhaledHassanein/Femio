/**
 * The four blanks the owner fills before the legal pages go live.
 *
 * The privacy policy and terms (docs/33_REBUILD_V3/03_LEGAL_PACK.md §2-3) name the
 * company, the privacy mailbox and the effective date. None of those is known yet,
 * so the pages show the bracketed marker, highlighted, rather than a guess. They are
 * ICU arguments in the message catalogs ({entity}, {email}, {date}), so replacing a
 * marker is one edit here, not eight edits across four languages.
 *
 * To publish: set the real values below (legal form and registration number in
 * `entity`, a mailbox that exists in `email`, ISO-style date in `date`), and
 * `PLACEHOLDER_PATTERN` will stop finding anything to highlight.
 */
export const LEGAL_VALUES = {
  /** KM Digital Labs, Cairo, Egypt, with legal form and registration number. */
  entity: "[ENTITY]",
  /** A privacy mailbox on femioapp.com that really exists. */
  email: "[EMAIL]",
  /** Effective date of the current version (default in the pack: 2026-11-30). */
  date: "[DATE]",
  /** Final address of the privacy policy. Not printed in the text today. */
  url: "[URL]",
  /** Policy and terms version. */
  version: "1",
} as const;

/** Matches any of the unfilled markers, so the page can highlight them. */
export const PLACEHOLDER_PATTERN = /(\[(?:ENTITY|EMAIL|DATE|URL)\])/;
