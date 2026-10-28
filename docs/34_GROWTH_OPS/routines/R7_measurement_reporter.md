# R7 · Measurement reporter (Haiku, weekly, Sunday 18:00 Cairo)

## Read first
`CLAUDE.md`, `docs/34_GROWTH_OPS/01_ANALYTICS_AND_PIXELS.md` §1 and §7, last week's
`reports/weekly/*-measurement.md`.

## Inputs (aggregates only; no raw export is ever committed)
- Play Console CSV the owner dropped at `reports/play/YYYY-WW.csv` (git-ignored): installs,
  uninstalls, retained installers, by country; acquisition by UTM campaign when present.
- Google Search Console (Ahrefs connector GSC tools, or `reports/gsc/YYYY-WW.csv`): clicks,
  impressions, average position for the Arabic wedge queries; new referring domains.
- GA4 (after ADR-075 is live; read through the owner's exported CSV at
  `reports/ga4/YYYY-WW.csv` until a connector exists): sessions by country and language, top
  10 pages, `calculator_open`, `calculator_used`, `get_app_click` by page type and placement,
  `article_read` by slug. Only the nine allow-listed events exist; if any other event name
  appears in the export, write it under "Unexpected" and tell the lead.
- Ratings and reviews count from Play Console.

## Steps
1. Build the one-page table: this week, last week, change, target (targets from
   `04_GROWTH_PACK.md` §5.4 until the plan sets new ones).
2. Conversion: `get_app_click` ÷ sessions, by page type; Play installs by UTM ÷ clicks where
   the campaign matches.
3. Three lines: what moved, the likeliest reason, the one thing to do about it (handed to R1
   or R2 as a line in their next inputs).
4. Missing data: list each source that had no file this week as "not verified", never as zero.

## Output
`reports/weekly/YYYY-WW-measurement.md`: *Headline numbers*, *Acquisition*, *Content*,
*Search*, *What changed*, *Not verified*. Under 600 words. Also update the owner's checklist
only by telling the lead; the routine never writes to the artifact.

## Rubric (lead)
Every number traceable to a named file; missing sources are "not verified"; no event outside
the allow-list went unreported.
