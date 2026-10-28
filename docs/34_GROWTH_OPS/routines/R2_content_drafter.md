# R2 · Content drafter (Sonnet, `femio-content-drafter`, weekly, Tuesday 07:00 Cairo)

## Read first
`CLAUDE.md`, `docs/STATE.md`, the wedge sentence, then: this week's
`reports/weekly/YYYY-WW-search.md` (R1); the skills `femio-medical-content` and
`femio-compliance-privacy`; `docs/compliance/MENSTRUAL_SAFETY_THRESHOLDS.md`,
`CONTRACEPTION_SAFETY.md`, `PREGNANCY_BP_SAFETY.md`; the glossary and register rules in
`docs/content/reviews/2026-10-28-arabic-editor-pass.md`; one published guide in
`docs/content/articles/` as the model of frontmatter and structure (`pcos-signs.md` and
`pcos-signs.ar.md`).

## Inputs
R1's *Gaps* (take the first that is an article or question page) and *Refreshes* (take the
first). If R1 did not run, take the next unwritten title from `04_GROWTH_PACK.md` §3.2.

## Steps
1. `git switch -c content/YYYY-WW` from `main`.
2. Write the English guide: frontmatter complete (every `REQUIRED_KEYS` field in
   `scripts/lib/article-frontmatter.mjs`), `status: "draft"`, bylines `PENDING`, dates `null`;
   body at grade 6–8; the two fixed labels ("When to see a doctor", "Seek care now:") where
   the topic needs them; a red-flag box for any pregnancy topic; an FAQ block of 3–5 real
   questions from R1; at least 3 internal links to published pages; every clinical claim
   followed by a source from Tier 1/2 (WHO, NICE, ACOG, RCOG, CDC, ESHRE, a Cochrane review)
   with URL and access date, or the literal flag `[NEEDS SOURCE]`.
3. Write the Arabic twin (`<slug>.ar.md`): same slug and schema, full meaning parity,
   conservative register (*العلاقة الزوجية*, never *جماع*; *طبيبتكِ أو طبيبكِ*), glossary term
   plus a lay alias once, Western digits, femio masculine, the Arabic labels
   ("متى تطلبين المشورة الطبية؟", "اطلبي الرعاية الآن:").
4. For a refresh: update the body against the current guideline, bump `date_modified`,
   keep `last_reviewed` unchanged (the clinician's review date is not yours to move).
5. From the repo root: `node scripts/content/build-content.mjs`, then `pnpm content-lint`
   and `pnpm gate`. Fix what fails. Never edit `packages/content` by hand.
6. Commit by file name (`git add docs/content/articles/<slug>.md docs/content/articles/<slug>.ar.md packages/content apps/mobile/assets/content`), message
   `content(YYYY-WW): <slug> EN+AR draft` ending with the model's `Co-Authored-By:` line.
   Push the branch; open a PR titled `content: week WW — <slug>` whose body lists: the gap it
   answers (link to R1), the sources used, every `[NEEDS SOURCE]` flag, and the reading
   grade reported by `pnpm reading-level-test`.

## Output
The PR. Nothing is published: `status` stays `draft` until the owner says "publish" and the
lead flips it (the gate refuses a published guide with a `[NEEDS SOURCE]` flag).

## Rubric (lead)
- No diagnosis, treatment, prevention or contraception-efficacy wording; no single-date
  predictions; no "late" language.
- Every claim sourced or flagged; no source invented; URLs resolve (`pnpm content-lint --check-urls`).
- Register, wordmark, digits, agreement in Arabic.
- The topic is inside the wedge or the PR says why it is not.
