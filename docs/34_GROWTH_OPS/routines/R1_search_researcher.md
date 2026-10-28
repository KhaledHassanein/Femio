# R1 · Search researcher (Sonnet, weekly, Monday 07:00 Cairo)

## Read first
`CLAUDE.md`, `docs/STATE.md`, the wedge sentence (`README.md` here), then
`docs/33_REBUILD_V3/04_GROWTH_PACK.md` §2 (keyword maps, dialect rules) and the previous
week's `reports/weekly/*-search.md` if it exists.

## Inputs
- Google Search Console for `femioapp.com`: queries, pages, countries, positions, last 28
  days. Read through the Ahrefs connector's GSC tools when connected; otherwise read the
  CSV the owner dropped at `reports/gsc/YYYY-WW.csv` (git-ignored). If neither exists,
  write the report with the section "Search Console: no data this week" and continue with
  the other inputs.
- The Arabic and English keyword maps (§2.2, §2.5).
- For each of the 10 wedge queries in §2.2 marked `core`, the top 3 ranking pages
  (fetch and read; never copy text).

## Steps
1. Rank-opportunity list: queries where femio holds position 5–20. For each: the ranking
   page, impressions, and one concrete change (a missing FAQ question, a title rewrite within
   60 characters, an internal link from a stronger page). Ten rows, best first.
2. Gaps: Arabic questions women ask (from Search Console impressions with no femio page, from
   the forum and group threads named in §5.1, from Play reviews of peer apps) that no femio
   page answers. Five rows, each with its evidence link and the content type it needs
   (article, question page, glossary entry, calculator FAQ).
3. Refreshes: the three published guides with the oldest `last_reviewed` or the largest
   position drop week over week.
4. Outside the wedge: anything found that is not TTC → pregnancy, PCOS, Egypt or Saudi
   Arabia goes under this heading, one line each, no recommendation.

## Output
`reports/weekly/YYYY-WW-search.md` with exactly these sections: *Summary (3 lines)*,
*Rank opportunities (10)*, *Gaps (5)*, *Refreshes (3)*, *Outside the wedge*, *Sources*.
Tables, not prose. No raw exports are committed.

## Rubric (what the lead checks before R2 uses it)
- Every number has a source (Search Console, a named page, a dated thread).
- No volume figure without a source; `[NEEDS SOURCE]` is acceptable, a guess is not.
- Every gap sits inside the wedge or under "Outside the wedge".
- The file is under 1,500 words.
