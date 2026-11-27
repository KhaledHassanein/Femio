# Study report 07: the content library

Area: the content library. This covers the Learn articles, the five condition pillars, the empty FAQ and glossary placeholders, the code that loads, renders, searches and orders them, the Markdown drafts behind them, and the editorial docs and handover files. Status: study only. Nothing in the repo was changed except the two output files named in the brief.

Labels used in this report: **Checked** means I measured it or read the file. **From the docs** means a repo doc says so and I did not test it. **Hypothesis** means my reading. **Not verified** means I did not check. "Snapshot" means the JSON copy of the content committed in `apps/web/src/content/snapshot/`. "Slug" means the short name in a web address (for example `pcos-signs`). "Lexical" is the rich-text format Payload CMS stores article bodies in. "Flesch-Kincaid" (FK) is a reading-level score; a grade of 8 is roughly the level of a 13 or 14 year old, and doc 15 sets 8 as the ceiling. "Citation" means an entry in an article's `sources` list. "Red-flag box" means the "Seek care now" block that the policy asks for near any emergency-capable symptom.

## 1. Purpose in one paragraph

The content library is the health writing that brings people to Femio: about 100 English Learn articles, five condition pages, and the plan for Arabic, French and Spanish versions. It exists so that every health claim is cited, reviewed by a named clinician and readable at about grade 8, which is the bar set in `docs/15_EDITORIAL_MEDICAL_REVIEW_POLICY.md`. The site reads it from a committed snapshot, not from a live database at run time. The current direction in `CLAUDE.md` is to publish content from the repo rather than from the CMS (decision D3). The wedge is Arabic-first trying-to-conceive (TTC), through pregnancy, with PCOS depth. This study asks how much of that is ready.

## 2. Inventory

Each file in the content area is listed. The 107-file drafts folder is listed as one folder row because it holds more than 60 files. Line counts are from `wc -l`. The snapshot JSON files are one line each because they are minified, so their size in bytes is given instead.

| Path | Lines | One-line purpose | Status |
|---|---|---|---|
| `apps/web/src/content/snapshot/articles.json` | 1 (1.59 MB) | 100 English articles in Lexical JSON, pulled from the CMS on 2026-10-07 | live |
| `apps/web/src/content/snapshot/conditions.json` | 1 (132 KB) | 5 English condition pillars (endometriosis, heavy periods, painful periods, PCOS, PMS/PMDD) | live |
| `apps/web/src/content/snapshot/faqs.json` | 1 (35 B) | FAQ list, empty in all four locales | live (empty) |
| `apps/web/src/content/snapshot/glossary.json` | 1 (35 B) | Glossary, empty in all four locales | live (empty) |
| `apps/web/src/content/snapshot/people.json` | 1 (1.3 KB) | One person record: Dr. Khaled M., roles author and medical reviewer | live |
| `apps/web/src/content/snapshot/meta.json` | 36 | When the snapshot was taken (2026-10-07) and the per-locale counts | live |
| `apps/web/src/lib/content/topics.ts` | 175 | Learn hub rows, the slug-to-row map, the "start here" list and the question chips | live |
| `apps/web/src/lib/content/topics.test.ts` | 59 | Tests for the row map (5 test cases, counted, not read) | live |
| `apps/web/src/lib/content/unpublished-sections.ts` | 30 | Lists `/glossary` and `/faq` as not yet promoted in the header, footer and sitemap | live |
| `apps/web/src/lib/content/unpublished-sections.test.ts` | 45 | Tests for that list (3 test cases, counted) | live |
| `apps/web/src/lib/cms/client.ts` | 206 | Loads content from the snapshot with English fallback (`inLocale`). Despite the folder name, it makes no network call | live |
| `apps/web/src/lib/cms/lexical.tsx` | 109 | Turns Lexical JSON into React elements (paragraph, heading, list, link, quote, inline bold and italic) | live |
| `apps/web/src/lib/cms/lexical.test.ts` | 28 | Tests for the renderer (2 cases, counted) | live |
| `apps/web/src/lib/cms/faq.ts` | 66 | Pulls question-and-answer pairs out of an article body for FAQ schema | live |
| `apps/web/src/lib/cms/faq.test.ts` | not measured | Tests for `faq.ts` (present by listing, not read) | live |
| `apps/web/src/lib/cms/select.test.ts` | not measured | Tests for a helper in the same folder (present by listing, not read) | unknown |
| `apps/web/src/lib/cms/format.ts` | 12 | Small text helper (`lede`) | unknown (not read) |
| `apps/web/src/components/cms/content-article.tsx` | 228 | Article page template: byline, last-reviewed date, disclaimer alert, sources, FAQ schema | live |
| `apps/web/src/components/learn/learn-hub.tsx` | 184 | The Learn hub page: rows, start-here list, question chips | live |
| `apps/web/src/components/learn/topic-art.tsx` | 36 | Row artwork keyed by topic (only its imports were read) | unknown |
| `apps/web/src/components/cms/content-hub.tsx` | not measured | Hub list used by the conditions index page | unknown (not read) |
| `apps/web/src/app/[locale]/(public)/conditions/page.tsx` | not measured | Conditions index page; calls `listContent` | live |
| `apps/web/src/lib/search/library.ts` | 92 | Builds the search corpus from the snapshot | live |
| `apps/web/src/lib/search/library.test.ts` | 62 | Tests for the search corpus (5 cases, counted) | live |
| `apps/web/src/lib/experience/reading.ts` | 318 | Maps life-stage topics to articles; `weekArticleSlug` clamps weeks to 4 to 40 | live |
| `apps/web/src/lib/experience/reading.test.ts` | 205 | Tests for that mapping (17 cases, counted) | live |
| `apps/web/src/app/api/reading/route.ts` | 56 | Reading-list API for the dashboard. Its comment describes a CMS call the code no longer makes | live |
| `apps/web/src/app/api/reading/route.test.ts` | not measured | Tests for that route (present by listing, not read) | live |
| `apps/web/messages/en.json` | not counted | UI strings, including the three "reviewed by a clinician" claims (keys `learn.subtitle`, `conditions.subtitle`, `tools.learn.note`) | live |
| `scripts/content/snapshot-cms.mjs` | 95 | Pulls published documents from the CMS and writes the snapshot. Its function list was read, not its body | live |
| `scripts/content-lint.mjs` | 565 | Offline content guard over `docs/content/articles/*.md` (`pnpm content-lint`) | live |
| `scripts/content-lint.test.mjs` | 575 | Tests for the guard (not run) | live |
| `scripts/content-import.test.mjs` | 254 | Tests for the import path (not run) | unknown |
| `package.json` (script `content-lint`) | not counted | Wires the guard into `pnpm gate` | live |
| `apps/cms/` (folder) | not measured | Payload CMS app and its import and publish scripts (`import-articles.mjs`, `import-translations.mjs`, `publish-reviewed.mjs` and others). Not read in depth | unknown |
| `docs/content/articles/` (folder, 107 `.md` files) | 107 files | Markdown drafts with YAML front matter: 106 English (105 unique slugs plus a second Ramadan file) and 1 Arabic (`ramadan-fasting-pregnancy.ar.md`) | live (source drafts, all `status: draft`) |
| `docs/content/people/khaled-m.json` | 14 | Bio source for the one person record | unknown (not read) |
| `docs/content/GLOSSARY_TERMS.md` | 131 | 111 medical terms with preferred Arabic, French and Spanish renderings | live (draft, not reviewed) |
| `docs/content/CODEX_AUTHORING_BRIEF.md` | 293 | Authoring rules: page contract, forbidden language, sourcing, reading level | live (its name refers to Codex, which the global notes say retired on 27 Oct 2026) |
| `docs/content/CMS_SEO_PUBLISHING_RECOMMENDATIONS.md` | 151 | Publishing and SEO recommendations (headings only) | unknown |
| `docs/content/HANDOVER_TRANSLATION.md` | 211 | Prompt for the AR, FR and ES translation run | dead (spent; the run stopped) |
| `docs/content/HANDOVER_TRANSLATION_RETURN.md` | 49 | Outcome: no AR, FR or ES article drafts kept | dead (record) |
| `docs/content/HANDOVER_WEEK_BY_WEEK.md` | 291 | Prompt for pregnancy weeks 4 to 40 | dead (spent) |
| `docs/content/HANDOVER_WEEK_BY_WEEK_RETURN.md` | 238 | Record: 37 week drafts written, sources listed, which weeks a clinician should read first | dead (record) |
| `docs/content/HANDOVER_TEEN_CONTENT.md` | 285 | Prompt for the teen set of ten (headings only) | dead |
| `docs/content/HANDOVER_NEWBORN_BASICS.md` | 293 | Prompt for the newborn set of eight (headings only) | dead |
| `docs/content/HANDOVER_NEWBORN_BASICS_RETURN.md` | 200 | Record for the newborn set (headings only) | dead |
| `docs/15_EDITORIAL_MEDICAL_REVIEW_POLICY.md` | 68 | Review workflow, sourcing tiers, reading-level ceiling (grade 8), page contract, disclaimers | live |
| `docs/archive/2026-11/16_CONDITION_LIBRARY_IA.md` | 113 | Information architecture: 8 browse categories, URL plan, cross-links, launch waves | live (slug rule partly superseded by ADR-045) |
| `docs/04_MEDICAL_DATA_SOURCES.md` | 49 | Source catalogue in three tiers | live |
| `docs/11_NEEDS_SOURCE_CHECKLIST.md` | 638 | 452 open `[ ]` items to verify, none ticked | live (open) |
| `docs/archive/2026-11/30_REVAMP/delegated/2026-10-08-competitor-benchmark.md` | 326 | Lead-reviewed benchmark; source of the content-gap list | live |
| `docs/archive/2026-11/30_REVAMP/delegated/2026-10-08-app-strings-qa.md` | 185 | QA of the app's AR, FR and ES UI strings (130 keys each) | live (applied) |
| `docs/archive/2026-11/30_REVAMP/delegated/2026-10-08-fr-register.md` | 59 | Proposal to change French "tu" to "vous" outside teen copy (99 of 101 applied) | live (applied) |
| `docs/archive/2026-11/30_REVAMP/delegated/2026-10-08-fr-register.json` | 405 | Machine-readable version of the French proposal | live (applied) |

I did not run any test suite in this study. The one command I ran was the offline `node scripts/content-lint.mjs`, which printed "Content guard: 107 draft(s) conform to the authoring brief" (Checked).

### 2.1 Measured content (Checked, from the snapshot unless noted)

**Counts per locale.** Articles: EN 100, AR 0, FR 0, ES 0. Conditions: EN 5, AR 0, FR 0, ES 0. FAQs: 0 in every locale. Glossary: 0 in every locale. People: EN 1. So no article has a full translation, and every non-English route falls back to English. The fallback is built in: `inLocale` in `apps/web/src/lib/cms/client.ts` (lines 107 to 116) returns the English document when a locale has no version. `messages/en.json` key `englishOnly` (line 850) tells the reader "This guide is not translated yet, so it is shown in English."

**Schema.** An article has 13 fields: `id`, `title`, `slug`, `excerpt`, `body`, `disclaimerType`, `sources`, `lastReviewed`, `updatedAt`, `firstPublishedAt`, `seo`, `authors`, `medicalReviewerProfile`. A condition is the same, except `summary` replaces `excerpt`. `seo` holds `seoTitle`, `metaDescription`, `canonicalOverride`, `noIndex`, `socialTitle`, `socialDescription` and `socialImage`. Each `sources` item holds `title`, `url` and `tier`. Each `authors` item holds `slug`, `name`, `credentials` and `jobTitle`. The person record holds `id`, `name`, `slug`, `roles`, `credentials`, `jobTitle`, `affiliation`, `bio`, `updatedAt` and `sameAs`.

**There is no category, stage or tag field.** The Learn-hub rows come from a hand-written slug list in `topics.ts`. The 37 pregnancy-week articles are grouped by a pattern in the slug (`pregnancy-week-N`).

**Word counts (body text, headings included).** Articles: min 586, median 795, max 1,443 (the max is `meet-femio`); total 82,846 words. Weeks: 586 to 792, median 654. Conditions: 1,156 to 1,343.

**Named reviewer.** 25 of 100 articles name a medical reviewer. The only reviewer named is "Dr. Khaled M." (`medicalReviewerProfile`, slug `khaled-m`). He is also the author on all 25 of those articles. All five conditions name the same person as reviewer. Twenty-six articles have an `authors` entry; the 26th without a reviewer is `meet-femio`.

**Citations per article.** Min 0 (`meet-femio`), median 3, max 6. Total 290 across the 100 articles and 302 across all 105 records. 19 articles have fewer than three citations. Doc 15 sets the minimum at two, so one article fails it (`meet-femio`).

**Citation domains (all 14 found).** nhs.uk 126, acog.org 70, nice.org.uk 28, who.int 28, cdc.gov 11, nichd.nih.gov 8, healthychildren.org 5, rcog.org.uk 4, fda.gov 3, eshre.eu 2, integration.asrm.org 2, womenshealth.gov 1, aap.org 1, thyroid.org 1. All URLs are https. No source URL repeats inside one article. No blog or competitor-app domain is cited.

**Citation tiers do not match doc 15.** Doc 15, section 4, names ACOG, RCOG, NICE, ASRM and ESHRE as Tier 2. The snapshot tags 113 citations from those five as tier "1". Only 4 citations carry tier "2", all from healthychildren.org, which doc 15 does not list. The tier field is not doing the job doc 15 gives it.

**Red-flag boxes.** A red-flag box is a blockquote that starts "Seek care now:". 77 of 100 articles have one (78 boxes in total; one article has two). The other 23 do not. Four of the five conditions have one; `pcos` does not. All 37 week articles have one. Every quote node in the 105 bodies is a red-flag box (82 quotes, and the red-flag count matches the quote count for articles, 78 each). The `disclaimerType` is `emergency` for 71 articles (which shows a red danger alert at the top of the page), `general` for 28 and `screening` for 1.

**Reading level.** Nothing in code measures it. `readingLevelOk` is a true-or-false flag that the author types into the Markdown front matter (`fm.reading_level_ok`). The CMS import copies it across (`apps/cms/scripts/import-articles.mjs`, line 211). `scripts/content-lint.mjs` does not measure reading level (checked by search). So the grade-8 ceiling in doc 15 is self-declared. I estimated it myself with two rough methods (section 2.3). They disagree by about 1.5 grades, so I cannot confirm that any article is at or under grade 8.

**Slugs.** 105 unique slugs (100 articles and 5 conditions), all lower-case kebab-case, no collisions between the two sets.

**Images.** No image node appears in any article body (Checked: no `upload` nodes in the Lexical trees). None of the 107 Markdown drafts contains an image (Checked by search for `![`). `open_graph_image` is "PENDING" in all 107 drafts. So the site has no article images at all.

**Internal and external links.** The 105 records contain 551 links: 426 internal and 125 external. The 100 articles alone have 401 internal and 110 external. Every internal link to `/learn/...` or `/conditions/...` resolves to a slug in the snapshot (0 dangling). The other internal prefixes (`calculators` 12, `help-now` 12, `glossary` 6, `medical-review` 8) were counted, not resolved. All links are `linkType: custom`.

**Headings and lists.** H2 per article: median 7, max 12; `meet-femio` has none. Across the 105 records there are 837 H2 and 314 H3 headings, and 127 lists (105 bullet, 2 numbered).

**Last-updated dates.** Articles: `lastReviewed` from 2026-08-03 to 2026-08-19; `updatedAt` from 2026-08-04 to 2026-08-19. Conditions: `lastReviewed` 2026-08-04 for all five. `firstPublishedAt` is set on one article (`when-to-take-pregnancy-test`) and null on 99. In the Markdown drafts, `date_published`, `date_modified` and `last_reviewed` are all null.

**SEO fields.** Every article has an excerpt. `meet-femio` has no SEO title and no meta description. Meta descriptions otherwise run to about 156 characters at most (median about 140). Titles are all 60 characters or fewer.

**Publish status.** The snapshot has no status field, so "published" cannot be read from it. `CLAUDE.md` says "100 published" (From the docs). Not verified.

### 2.2 The five condition pillars (Checked)

| Slug | Words | Citations | Red-flag box | Named reviewer |
|---|---|---|---|---|
| `endometriosis` | 1,343 | 2 | yes | yes |
| `heavy-periods` | 1,156 | 3 | yes | yes |
| `painful-periods` | 1,178 | 2 | yes | yes |
| `pcos` | 1,206 | 2 | no | yes |
| `pms-pmdd` | 1,261 | 3 | yes | yes |

All five have `lastReviewed` 2026-08-04.

### 2.3 Reading level, 10 samples (Hypothesis: rough estimates, not a validated FK tool)

No readability library is installed on this machine, so I wrote two simple estimators in my scratch folder. Method A counts sentences from all the text, with a syllable rule that drops silent endings. Method B counts only paragraph text, splits sentences at each block, and counts vowel groups without the silent-ending rule. Method B runs high and Method A runs low. Neither is the gate. The owner needs a validated FK run before anyone says an article passes.

| Slug | FK method A | FK method B |
|---|---|---|
| `endometriosis` | 8.4 | 9.4 |
| `heavy-periods` | 7.8 | 8.9 |
| `painful-periods` | 7.7 | 8.9 |
| `pcos` | 8.1 | 9.9 |
| `pms-pmdd` | 7.3 | 8.8 |
| `afterpains-after-birth` | 6.8 | 8.3 |
| `trying-to-conceive-guide` | 8.4 | 9.6 |
| `pcos-signs` | 6.8 | 8.4 |
| `pregnancy-week-24` | 9.0 | 10.7 |
| `fertile-window-explained` | 8.0 | 9.8 |

Across all 100 articles, Method A gives a median of 8.0, with 46 articles above 8. Method B gives a median of 9.6 (range 6.9 to 11.7), with 85 articles above 8. All 37 weeks are above 8 by Method B, and 34 of 37 by Method A. The Markdown front matter of `afterpains-after-birth` claims "grade 6.5, checked 2026-08-16". My two estimates say 6.8 and 8.3, so the claim is plausible but not confirmed.

### 2.4 Groups (Checked)

Groups are the Learn-hub rows in `topics.ts`. "Named reviewer" counts articles that name a reviewer in the snapshot.

| Row (topic from `topics.ts`) | Articles | Named reviewer | Red-flag box | Words (min / median / max) | Citations (min / median / max) |
|---|---|---|---|---|---|
| Trying to conceive | 11 | 7 | 5 | 810 / 875 / 1204 | 2 / 3 / 3 |
| Pregnancy week by week | 37 | 0 | 37 | 586 / 654 / 792 | 3 / 3 / 3 |
| Pregnancy | 4 | 4 | 4 | 712 / 824 / 1189 | 2 / 2 / 3 |
| After birth | 14 | 0 | 8 | 814 / 892 / 1095 | 2 / 3 / 3 |
| Newborn | 8 | 0 | 8 | 990 / 1089 / 1403 | 3 / 4 / 6 |
| Cycles and periods | 8 | 6 | 6 | 737 / 828.5 / 1212 | 2 / 3 / 3 |
| Conditions | 4 | 4 | 2 | 779 / 831.5 / 897 | 2 / 2.5 / 3 |
| Teens | 8 | 0 | 2 | 669 / 756.5 / 798 | 2 / 3 / 3 |
| Menopause | 5 | 4 | 5 | 748 / 1059 / 1199 | 2 / 3 / 4 |
| No row (hidden on hub) | 1 | 0 | 0 | 1443 / 1443 / 1443 | 0 / 0 / 0 |

### 2.5 The 100 articles

Every article is English only; no AR, FR or ES version exists in the snapshot. "FK A" and "FK B" are the two rough estimates from section 2.3, not validated scores. "Red-flag box" is yes when a "Seek care now" blockquote is present. Rows are in Learn-hub order.

| # | Article (slug) | Row | Locales | Named reviewer | Words | Citations | Red-flag box | FK est. A | FK est. B |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Age and Fertility: What the Numbers Do and Do Not Say (`age-and-fertility`) | Trying to conceive | EN only | no | 940 | 3 | no | 8.7 | 10.9 |
| 2 | Can Endometriosis Affect Fertility? (`endometriosis-and-fertility`) | Trying to conceive | EN only | yes | 875 | 3 | yes | 7.3 | 8.8 |
| 3 | What Is the Fertile Window? (`fertile-window-explained`) | Trying to conceive | EN only | yes | 1092 | 2 | no | 8 | 9.8 |
| 4 | Fertility Tests: What an Assessment Usually Involves (`fertility-tests-what-to-expect`) | Trying to conceive | EN only | no | 1018 | 3 | no | 7.2 | 8.8 |
| 5 | Trying to Conceive With Irregular Cycles (`irregular-cycles-and-timing`) | Trying to conceive | EN only | no | 977 | 3 | no | 8.7 | 10.4 |
| 6 | Can PCOS Affect Fertility? (`pcos-and-fertility`) | Trying to conceive | EN only | yes | 825 | 3 | yes | 7.4 | 9 |
| 7 | What Happens at a Preconception Appointment? (`preconception-appointment`) | Trying to conceive | EN only | yes | 857 | 2 | yes | 7.4 | 9.3 |
| 8 | Thyroid Conditions and Trying to Conceive (`thyroid-and-conceiving`) | Trying to conceive | EN only | no | 865 | 3 | no | 8.9 | 11.1 |
| 9 | Trying to Conceive: Where Should You Start? (`trying-to-conceive-guide`) | Trying to conceive | EN only | yes | 1204 | 3 | no | 8.4 | 9.6 |
| 10 | When Should You Seek Fertility Help? (`when-to-seek-fertility-help`) | Trying to conceive | EN only | yes | 810 | 2 | yes | 7.3 | 8.9 |
| 11 | When Should You Take a Pregnancy Test? (`when-to-take-pregnancy-test`) | Trying to conceive | EN only | yes | 834 | 2 | yes | 6.8 | 9.3 |
| 12 | Week 4 of Pregnancy: What to Expect (`pregnancy-week-4`) | Pregnancy week by week | EN only | no | 792 | 3 | yes | 8.9 | 10.8 |
| 13 | Week 5 of Pregnancy: What to Expect (`pregnancy-week-5`) | Pregnancy week by week | EN only | no | 716 | 3 | yes | 8 | 9.8 |
| 14 | Week 6 of Pregnancy: What to Expect (`pregnancy-week-6`) | Pregnancy week by week | EN only | no | 713 | 3 | yes | 8.2 | 10.3 |
| 15 | Week 7 of Pregnancy: What to Expect (`pregnancy-week-7`) | Pregnancy week by week | EN only | no | 696 | 3 | yes | 8.3 | 10 |
| 16 | Week 8 of Pregnancy: What to Expect (`pregnancy-week-8`) | Pregnancy week by week | EN only | no | 683 | 3 | yes | 8.6 | 10.4 |
| 17 | Week 9 of Pregnancy: What to Expect (`pregnancy-week-9`) | Pregnancy week by week | EN only | no | 635 | 3 | yes | 8.4 | 10 |
| 18 | Week 10 of Pregnancy: What to Expect (`pregnancy-week-10`) | Pregnancy week by week | EN only | no | 654 | 3 | yes | 8.8 | 10.5 |
| 19 | Week 11 of Pregnancy: What to Expect (`pregnancy-week-11`) | Pregnancy week by week | EN only | no | 685 | 3 | yes | 8 | 10.1 |
| 20 | Week 12 of Pregnancy: What to Expect (`pregnancy-week-12`) | Pregnancy week by week | EN only | no | 677 | 3 | yes | 8.4 | 10.5 |
| 21 | Week 13 of Pregnancy: What to Expect (`pregnancy-week-13`) | Pregnancy week by week | EN only | no | 661 | 3 | yes | 8.7 | 10.6 |
| 22 | Week 14 of Pregnancy: What to Expect (`pregnancy-week-14`) | Pregnancy week by week | EN only | no | 651 | 3 | yes | 8.5 | 10.2 |
| 23 | Week 15 of Pregnancy: What to Expect (`pregnancy-week-15`) | Pregnancy week by week | EN only | no | 637 | 3 | yes | 8.6 | 10.4 |
| 24 | Week 16 of Pregnancy: What to Expect (`pregnancy-week-16`) | Pregnancy week by week | EN only | no | 657 | 3 | yes | 8.7 | 10.9 |
| 25 | Week 17 of Pregnancy: What to Expect (`pregnancy-week-17`) | Pregnancy week by week | EN only | no | 626 | 3 | yes | 9.1 | 10.6 |
| 26 | Week 18 of Pregnancy: What to Expect (`pregnancy-week-18`) | Pregnancy week by week | EN only | no | 625 | 3 | yes | 8.6 | 10.1 |
| 27 | Week 19 of Pregnancy: What to Expect (`pregnancy-week-19`) | Pregnancy week by week | EN only | no | 603 | 3 | yes | 9.7 | 11.7 |
| 28 | Week 20 of Pregnancy: What to Expect (`pregnancy-week-20`) | Pregnancy week by week | EN only | no | 634 | 3 | yes | 9.1 | 11 |
| 29 | Week 21 of Pregnancy: What to Expect (`pregnancy-week-21`) | Pregnancy week by week | EN only | no | 586 | 3 | yes | 8.1 | 10.3 |
| 30 | Week 22 of Pregnancy: What to Expect (`pregnancy-week-22`) | Pregnancy week by week | EN only | no | 614 | 3 | yes | 8 | 10 |
| 31 | Week 23 of Pregnancy: What to Expect (`pregnancy-week-23`) | Pregnancy week by week | EN only | no | 608 | 3 | yes | 8.1 | 9.8 |
| 32 | Week 24 of Pregnancy: What to Expect (`pregnancy-week-24`) | Pregnancy week by week | EN only | no | 678 | 3 | yes | 9 | 10.7 |
| 33 | Week 25 of Pregnancy: What to Expect (`pregnancy-week-25`) | Pregnancy week by week | EN only | no | 652 | 3 | yes | 8.6 | 10.5 |
| 34 | Week 26 of Pregnancy: What to Expect (`pregnancy-week-26`) | Pregnancy week by week | EN only | no | 611 | 3 | yes | 8.6 | 10.2 |
| 35 | Week 27 of Pregnancy: What to Expect (`pregnancy-week-27`) | Pregnancy week by week | EN only | no | 652 | 3 | yes | 8.6 | 10.5 |
| 36 | Week 28 of Pregnancy: What to Expect (`pregnancy-week-28`) | Pregnancy week by week | EN only | no | 684 | 3 | yes | 8.7 | 10.6 |
| 37 | Week 29 of Pregnancy: What to Expect (`pregnancy-week-29`) | Pregnancy week by week | EN only | no | 661 | 3 | yes | 8.5 | 10.4 |
| 38 | Week 30 of Pregnancy: What to Expect (`pregnancy-week-30`) | Pregnancy week by week | EN only | no | 635 | 3 | yes | 8.6 | 10.3 |
| 39 | Week 31 of Pregnancy: What to Expect (`pregnancy-week-31`) | Pregnancy week by week | EN only | no | 682 | 3 | yes | 8.9 | 11.1 |
| 40 | Week 32 of Pregnancy: What to Expect (`pregnancy-week-32`) | Pregnancy week by week | EN only | no | 672 | 3 | yes | 8.5 | 10.5 |
| 41 | Week 33 of Pregnancy: What to Expect (`pregnancy-week-33`) | Pregnancy week by week | EN only | no | 654 | 3 | yes | 9.8 | 11.7 |
| 42 | Week 34 of Pregnancy: What to Expect (`pregnancy-week-34`) | Pregnancy week by week | EN only | no | 624 | 3 | yes | 8.6 | 10.4 |
| 43 | Week 35 of Pregnancy: What to Expect (`pregnancy-week-35`) | Pregnancy week by week | EN only | no | 669 | 3 | yes | 8.1 | 10.1 |
| 44 | Week 36 of Pregnancy: What to Expect (`pregnancy-week-36`) | Pregnancy week by week | EN only | no | 632 | 3 | yes | 9.2 | 11.2 |
| 45 | Week 37 of Pregnancy: What to Expect (`pregnancy-week-37`) | Pregnancy week by week | EN only | no | 680 | 3 | yes | 8.3 | 9.9 |
| 46 | Week 38 of Pregnancy: What to Expect (`pregnancy-week-38`) | Pregnancy week by week | EN only | no | 636 | 3 | yes | 9.6 | 11.6 |
| 47 | Week 39 of Pregnancy: What to Expect (`pregnancy-week-39`) | Pregnancy week by week | EN only | no | 717 | 3 | yes | 8.7 | 11 |
| 48 | Week 40 of Pregnancy: What to Expect (`pregnancy-week-40`) | Pregnancy week by week | EN only | no | 698 | 3 | yes | 9.1 | 11.2 |
| 49 | What Are Common Early Pregnancy Changes? (`early-pregnancy-changes`) | Pregnancy | EN only | yes | 712 | 2 | yes | 6.9 | 9.3 |
| 50 | What Happens at Your First Pregnancy Appointment? (`first-pregnancy-appointment`) | Pregnancy | EN only | yes | 785 | 2 | yes | 7.4 | 9.1 |
| 51 | What Can You Expect During a Typical Pregnancy? (`pregnancy-basics`) | Pregnancy | EN only | yes | 1189 | 3 | yes | 8.2 | 9.6 |
| 52 | Which Pregnancy Warning Signs Need Urgent Care? (`pregnancy-warning-signs`) | Pregnancy | EN only | yes | 863 | 2 | yes | 7.4 | 9.1 |
| 53 | Afterpains: Cramps in the Days After Birth (`afterpains-after-birth`) | After birth | EN only | no | 847 | 2 | yes | 6.8 | 8.3 |
| 54 | Bleeding After Birth: What Is Normal and What Is Not (`bleeding-after-birth`) | After birth | EN only | no | 852 | 3 | yes | 6.4 | 7.6 |
| 55 | Breastfeeding: The First Two Weeks (`breastfeeding-first-two-weeks`) | After birth | EN only | no | 1028 | 3 | yes | 6.9 | 8.2 |
| 56 | Contraception After Birth: What to Know (`contraception-after-birth`) | After birth | EN only | no | 878 | 3 | no | 8.2 | 9.4 |
| 57 | Your Mood After Birth: Baby Blues, Depression and Anxiety (`mood-after-birth`) | After birth | EN only | no | 1095 | 3 | yes | 7.3 | 8.4 |
| 58 | Your Pelvic Floor After Birth (`pelvic-floor-after-birth`) | After birth | EN only | no | 891 | 3 | no | 7.6 | 8.7 |
| 59 | When Your Periods Come Back After Birth (`periods-after-birth`) | After birth | EN only | no | 816 | 3 | no | 7.9 | 9.1 |
| 60 | Your Body in the First Six Weeks After Birth (`postpartum-recovery-first-six-weeks`) | After birth | EN only | no | 974 | 3 | yes | 7.3 | 8.5 |
| 61 | Postpartum Warning Signs That Need Urgent Care (`postpartum-warning-signs`) | After birth | EN only | no | 986 | 3 | yes | 7.8 | 9 |
| 62 | Healing After Stitches or a Caesarean (`postpartum-wound-healing`) | After birth | EN only | no | 893 | 3 | yes | 6 | 7.5 |
| 63 | Sex After Birth: What to Expect (`sex-after-birth`) | After birth | EN only | no | 814 | 3 | no | 6.8 | 8.3 |
| 64 | Your Six-Week Check After Birth (`six-week-postnatal-check`) | After birth | EN only | no | 854 | 3 | no | 7.1 | 8.3 |
| 65 | Sleep and Exhaustion After Birth (`sleep-and-exhaustion-after-birth`) | After birth | EN only | no | 946 | 3 | no | 6.9 | 8.1 |
| 66 | When Breastfeeding Is Not Working (`when-breastfeeding-is-not-working`) | After birth | EN only | no | 992 | 3 | yes | 7.9 | 9.7 |
| 67 | Bottles and Formula: Preparing and Feeding Safely (`bottle-and-formula-feeding`) | Newborn | EN only | no | 1091 | 4 | yes | 9.4 | 11.1 |
| 68 | Feeding Your Newborn: How Often, and How You Know It Is Going In (`feeding-your-newborn`) | Newborn | EN only | no | 990 | 4 | yes | 8.2 | 9.7 |
| 69 | Your Baby's First Checks and Vaccinations (`newborn-checks-and-vaccinations`) | Newborn | EN only | no | 1031 | 6 | yes | 9.4 | 11.1 |
| 70 | Newborn Crying, and What Helps (`newborn-crying`) | Newborn | EN only | no | 1085 | 3 | yes | 7.9 | 9.5 |
| 71 | Your Newborn in the First Two Weeks (`newborn-first-two-weeks`) | Newborn | EN only | no | 1403 | 4 | yes | 7.7 | 9.1 |
| 72 | Nappies, Skin and the Cord Stump (`newborn-nappies-skin-and-cord`) | Newborn | EN only | no | 1087 | 5 | yes | 8.4 | 9.9 |
| 73 | Newborn Warning Signs That Need Urgent Care (`newborn-warning-signs`) | Newborn | EN only | no | 1126 | 4 | yes | 7.4 | 8.5 |
| 74 | Safer Sleep for Your Baby (`safer-sleep-for-your-baby`) | Newborn | EN only | no | 1107 | 4 | yes | 8.6 | 10.5 |
| 75 | Can Heavy Periods Cause Iron-Deficiency Anaemia? (`heavy-periods-iron-deficiency-anaemia`) | Cycles and periods | EN only | yes | 909 | 3 | yes | 7 | 8.2 |
| 76 | How Are Painful Periods Assessed? (`how-painful-periods-are-assessed`) | Cycles and periods | EN only | yes | 813 | 2 | no | 7.2 | 8.5 |
| 77 | How Should You Track Your Menstrual Cycle? (`how-to-track-menstrual-cycle`) | Cycles and periods | EN only | yes | 956 | 3 | yes | 6.4 | 7.5 |
| 78 | Is my period normal? (`is-my-period-normal`) | Cycles and periods | EN only | no | 756 | 3 | yes | 7.6 | 7.7 |
| 79 | How Does the Menstrual Cycle Work? (`menstrual-cycle-basics`) | Cycles and periods | EN only | yes | 1212 | 3 | yes | 7.3 | 9.1 |
| 80 | Period myths, checked (`period-myths-checked`) | Cycles and periods | EN only | no | 737 | 3 | no | 7.2 | 7.5 |
| 81 | What Care Options Can Help With Period Pain? (`period-pain-care-options`) | Cycles and periods | EN only | yes | 823 | 2 | yes | 7 | 8.5 |
| 82 | How Should You Track PMS and PMDD Symptoms? (`track-pms-pmdd-symptoms`) | Cycles and periods | EN only | yes | 834 | 2 | yes | 6.8 | 8 |
| 83 | What Are the Common Signs of Endometriosis? (`endometriosis-signs`) | Conditions | EN only | yes | 779 | 2 | yes | 7.2 | 8.4 |
| 84 | How Is Endometriosis Assessed? (`how-endometriosis-is-assessed`) | Conditions | EN only | yes | 807 | 3 | no | 7.2 | 8.1 |
| 85 | How Do Clinicians Assess PCOS? (`how-pcos-is-assessed`) | Conditions | EN only | yes | 897 | 3 | no | 7.4 | 9.1 |
| 86 | What Are the Common Signs of PCOS? (`pcos-signs`) | Conditions | EN only | yes | 856 | 2 | yes | 6.8 | 8.4 |
| 87 | Period products, and how to choose (`choosing-period-products`) | Teens | EN only | no | 779 | 3 | no | 7 | 7.7 |
| 88 | Getting ready for your first period (`getting-ready-for-your-first-period`) | Teens | EN only | no | 726 | 2 | no | 7 | 7.3 |
| 89 | A period at school (`period-at-school`) | Teens | EN only | no | 798 | 2 | no | 7 | 7.6 |
| 90 | Period pain: what helps, and when it is too much (`period-pain-in-teens`) | Teens | EN only | no | 755 | 3 | yes | 7.4 | 7.3 |
| 91 | Tracking your cycle without stress (`tracking-your-cycle-as-a-teen`) | Teens | EN only | no | 758 | 2 | no | 6.7 | 6.9 |
| 92 | What is a period? (`what-is-a-period`) | Teens | EN only | no | 669 | 3 | no | 6.3 | 7.1 |
| 93 | What's changing in my body (`whats-changing-in-my-body`) | Teens | EN only | no | 672 | 3 | no | 7.2 | 7.7 |
| 94 | When to tell an adult, and when to see a doctor (`when-to-tell-an-adult`) | Teens | EN only | no | 766 | 3 | yes | 7.6 | 7.4 |
| 95 | What Menopause Care Options Can a Clinician Discuss? (`menopause-care-options`) | Menopause | EN only | yes | 885 | 2 | yes | 7.2 | 9.1 |
| 96 | What Is Menopause and What Can Change? (`menopause-explained`) | Menopause | EN only | yes | 1199 | 4 | yes | 7.8 | 9.4 |
| 97 | What Is Perimenopause and What Can Change? (`perimenopause-explained`) | Menopause | EN only | yes | 1188 | 3 | yes | 8.2 | 9.8 |
| 98 | Bleeding After Menopause: Why It Always Needs Checking (`postmenopausal-bleeding`) | Menopause | EN only | no | 1059 | 3 | yes | 7.9 | 10 |
| 99 | How Should You Track Perimenopause Symptoms? (`track-perimenopause-symptoms`) | Menopause | EN only | yes | 748 | 2 | yes | 6.4 | 8.1 |
| 100 | Meet Femio: Your Women's Health Tracking Companion (`meet-femio`) | No row (hidden on hub) | EN only | no | 1443 | 0 | no | 8 | 7.9 |

### 2.6 The wedge's PCOS depth and the term check (Checked by search across the 105 records)

Where the terms appear: PCOS or polycystic in 11 records; insulin resistance in 2; metformin in 1 (the `pcos` pillar); inositol, letrozole, clomiphene, hirsutism and "PMOS" in none; acne in 4; ovulation in 23; "ovulation test" in 2; basal body temperature in 1; gestational diabetes in 2; IVF in 2; miscarriage in 1; ectopic in 1; hyperemesis in none; Ramadan or fasting in none; male factor in none; "pre-eclampsia" in 7; folic acid in 4; vitamin D in none.

The four PCOS-specific English pieces are the `pcos` pillar (1,206 words, 2 citations, reviewed), `pcos-signs` (856 words, 2 citations, reviewed), `how-pcos-is-assessed` (897 words, 3 citations, reviewed) and `pcos-and-fertility` (825 words, 3 citations, reviewed). There is no article on PCOS lifestyle, insulin resistance, treatment options a clinician may discuss, or hirsutism and acne. The benchmark (`docs/archive/2026-11/30_REVAMP/delegated/2026-10-08-competitor-benchmark.md`, section 5.2) lists the same gaps. My term check agrees with it on every term except metformin, which the benchmark puts at 0 and I found once, in the `pcos` pillar.

## 3. Key modules and responsibilities

1. **`apps/web/src/lib/cms/client.ts`.** Input: the five snapshot JSON files. Output: `listContent(collection, locale)`, `getContentBySlug`, `listPeople`, `getPersonBySlug`, and per-locale lists with English fallback. Callers (by import): the conditions index page and the reading-list API use the functions; the article template and the Learn hub import only its types. The file makes no network call (Checked: no `fetch` or HTTP call in it).
2. **`apps/web/src/lib/content/topics.ts`.** Input: slugs. Output: `topicOf(slug)`, `rankOf(slug)`, `groupByTopic(items)`, `START_HERE`, `QUESTIONS`. Caller: `learn-hub.tsx` (line 8 imports it), and `topic-art.tsx` for the type. It is pure data. Its header says a test fails when a published article has no topic.
3. **`apps/web/src/lib/content/unpublished-sections.ts`.** Input: a route path. Output: `isUnpublishedSection(href)`, true for `/glossary` and `/faq`. Callers (by import): `sitemap.ts`, `site-header.tsx` and `site-footer.tsx`. This keeps two empty sections out of the navigation.
4. **`apps/web/src/lib/cms/lexical.tsx`.** Input: a Lexical root. Output: React elements. Caller: `content-article.tsx` (imports `RichText`). It handles paragraph, heading, list and list item, link, quote and inline formats. Unknown nodes fall back to their children.
5. **`apps/web/src/components/cms/content-article.tsx`.** Input: an article document and its locale. Output: the article page with byline, reviewer badge, last-reviewed date, disclaimer alert, sources list and FAQ schema.
6. **`apps/web/src/components/learn/learn-hub.tsx`.** Input: articles and the locale. Output: the Learn hub. It drops `meet-femio` (line 33), groups by topic, and takes its labels from the `learnHub` namespace.
7. **`apps/web/src/lib/cms/faq.ts`.** Input: a Lexical body. Output: question and answer pairs for FAQ schema. Has its own test file.
8. **`apps/web/src/lib/search/library.ts`.** Input: the snapshot (its header comment says the library ships inside the build). Output: a search corpus. Has 5 tests in `library.test.ts`.
9. **`apps/web/src/lib/experience/reading.ts`.** Input: a life-stage topic and a gestational week. Output: article slugs. `weekArticleSlug(week)` returns `pregnancy-week-N`, clamped to week 40, and returns nothing below week 4. It has no imports (Checked).
10. **`apps/web/src/app/api/reading/route.ts`.** Input: a request for a reading list. Output: JSON from `listContent` with `LIST_FIELDS` (no body text). Its comment says the CMS answers it; the code reads the snapshot.
11. **`scripts/content/snapshot-cms.mjs`.** Input: the CMS API. Output: the five snapshot JSON files. It is run by hand, and the result is committed. The steps are described in the comment at `client.ts` lines 17 to 18. The script body was not read, so its behaviour is From the docs.
12. **`scripts/content-lint.mjs`.** Input: `docs/content/articles/*.md`. Output: a pass or a list of findings. It checks front matter, the "PENDING" rule for author and reviewer (line 254), source count (at least two), presence of a Tier-1 source, https URLs and banned source hosts. It does not judge medicine, and it does not measure reading level.
13. **`apps/cms/scripts/import-articles.mjs`.** Input: the Markdown drafts. Output: CMS draft records, including `readingLevelOk` (line 211). Not read in depth.

## 4. Data flow

**Where data enters.** Two routes. (a) The Markdown drafts in `docs/content/articles/` (107 files), written by hand or by an agent and checked by `content-lint`. (b) The CMS (Payload, in `apps/cms/`, deployed at `femio-cms.vercel.app`), where an editor writes and a reviewer approves through the review gate. Route (a) is the direction in `CLAUDE.md` (D3: content published from the repo). Route (b) is where today's 25 reviewer names live.

**Where it is stored.** In the CMS database (which database it is, is not verified here), and in the committed snapshot JSON in `apps/web/src/content/snapshot/`. The Markdown drafts are stored in git.

**Where it leaves.** The snapshot is imported at build time into the web app: the article pages, the Learn hub, the conditions index, the search corpus, the reading-list API and the sitemap. At run time the content code makes no call to the CMS (Checked: `client.ts` imports only JSON). The article bodies link out to the 14 source domains (nhs.uk, acog.org and the rest). `content-lint --check-urls` can resolve those links over the network, but only when run by hand (From the docs: the header of `content-lint.mjs`).

**External services touched by this area.** Vercel, which hosts the web app and the CMS (From the docs). The CMS API at `femio-cms.vercel.app`, only when `snapshot-cms.mjs` runs (From the docs). The 14 source sites, as outbound links only. No Supabase, Sentry, PostHog or ad SDK is called by the content code (Checked from the import lines of `client.ts`, `lexical.tsx`, `learn-hub.tsx` and `content-article.tsx`). Not verified: `learn-hub.tsx` imports a page-view component, and I did not read it.

**The rich-text format, exactly.** The article body is a Lexical JSON tree (Payload's editor format). The root looks like `{"root": {"type": "root", "direction": "ltr", "format": "", "indent": 0, "version": 1, "children": [...]}}`. The node types found in the 105 bodies, with counts:

| Node | Count | Shape |
|---|---|---|
| `paragraph` | 2,418 | `children` (text and link nodes), `textFormat`, `textStyle`, `direction` |
| `text` | 5,687 | `text`; `format` is a bit mask (1 bold, 2 italic, 4 strikethrough, 8 underline, 16 code); also `style`, `detail`, `mode` |
| `heading` | 1,151 | `tag` is `h2` (837) or `h3` (314); `children` |
| `link` | 551 | `fields: {url, newTab, linkType: "custom"}`; `children`. Internal links look like `/en/learn/<slug>` or `/en/conditions/<slug>` |
| `list` | 127 | `tag` is `ul` (124) or `ol` (3); `listType` is `bullet` (105) or `number` (2); `start`; `children` of `listitem` |
| `listitem` | 802 | `value`; `children` |
| `quote` | 82 | `children`. All 82 are red-flag boxes: their text starts "Seek care now:" |
| `linebreak` | 65 | no children |

The Markdown source uses the same content in plain form: `## ` for H2, `### ` for H3, `- ` for bullets, `1. ` for numbers, `> ` for a quote (the red-flag box is `> **Seek care now:** ...`), `[text](url)` for links and `**bold**` for bold. Hypothesis: the CMS import script does the Markdown-to-Lexical conversion; I did not read it.

**What the app and the site need to render this.** The site already has a renderer (`lexical.tsx`) for this node set. The Flutter app does not. The node set is small (eight block types and five inline formats), so a Dart mapper would be a few hundred lines. Hypothesis: the simpler route is for the repo build to emit one neutral JSON file (or the Markdown itself), which both the site and the app read, so neither needs Payload's format. That is a design call for the owner.

## 5. Dependencies

**What this area imports from elsewhere in the repo.** `topics.ts` has no imports. `client.ts` imports the five snapshot JSON files and the routing config (`@/i18n/routing`). `learn-hub.tsx` imports the client types, the `lede` helper, the topic module, the topic artwork, the navigation link component and a page-view component. `content-article.tsx` imports `RichText` from `lexical.tsx`, the FAQ extractor, the site config, the JSON-LD component and the UI alert and badge. `reading.ts` imports nothing (Checked).

**What imports this area.** `topics.ts` is imported by `learn-hub.tsx` and by `topic-art.tsx` (for the type). `unpublished-sections.ts` is imported by `sitemap.ts`, `site-header.tsx` and `site-footer.tsx`. `client.ts` functions are imported by the conditions index page and the reading-list API; its types are imported by the article template and the Learn hub. The Markdown folder is read by `scripts/content-lint.mjs` and by the CMS import script.

**Cross-area links.** The search corpus reads the snapshot, so search results change when the snapshot changes. `reading.ts` is the bridge to the pregnancy dashboard: `weekArticleSlug` decides which week article the dashboard shows (From the docs: `HANDOVER_WEEK_BY_WEEK_RETURN.md`, Part 7; the function itself was read).

## 6. Strings and i18n

- **Article bodies are English only.** There are no AR, FR or ES article bodies. The English text sits in the snapshot as data, not in a message catalogue.
- **UI strings are keyed.** `content-article.tsx` uses translation keys for "sources", for the disclaimer (by type) and for the last-reviewed line. `learn-hub.tsx` uses the `learnHub` namespace (`questions.*`, `topics.*`, `guides`). A search of the content components for hard-coded English text found none. This was a heuristic search, not a full audit.
- **English fallback.** A non-English route shows the English article with the note "This guide is not translated yet, so it is shown in English." (`messages/en.json`, key `englishOnly`, line 850). The search page has a matching note (`englishFallback`, line 1732).
- **A false claim in the UI copy.** `messages/en.json` says guides are "reviewed by a clinician" in three places: key `learn.subtitle` (line 856), key `conditions.subtitle` (line 871) and key `tools.learn.note` (line 2142). Only 25 of 100 articles name a reviewer, so the claim is false as written for 75 articles. The benchmark (section 0) says the homepage claim was corrected on 2026-10-08. These three keys were not.
- **Glossary terms.** `docs/content/GLOSSARY_TERMS.md` has 111 preferred renderings in Arabic, French and Spanish. They are a draft and not reviewed (From the docs: the return handover says so). Nothing in the app reads them yet.
- **App UI strings.** The Android ARB files have 130 keys each in EN, AR, FR and ES (From the docs: `app-strings-qa.md`, "Scope and counts"). That is UI text, not article text.

## 7. Tests

**Test files in this area (counted, not run).** `topics.test.ts` has 5 cases; `unpublished-sections.test.ts` 3; `lexical.test.ts` 2; `library.test.ts` 5; `reading.test.ts` 17. That is 32 cases across five files. `faq.test.ts`, `select.test.ts` and `api/reading/route.test.ts` exist (not counted). `scripts/content-lint.test.mjs` (575 lines) and `scripts/content-import.test.mjs` (254 lines) were not counted and not run. I did not run any test suite in this study, so their results are Not verified.

**What the tests cover (From the file names and counts).** The row map and ordering, the unpublished list, the renderer, the search corpus and the week mapping. The offline `content-lint` run did pass in this study ("107 draft(s) conform to the authoring brief"). That is a real result, Checked.

**What is untested.** (1) The snapshot itself. Nothing checks it against doc 15: two citations minimum, a named reviewer for published pages, a reading-level flag. `content-lint` checks the Markdown drafts, not the snapshot the site reads, so the article with zero citations and the 75 unreviewed articles pass silently. (2) Reading level is never measured. (3) The tier field is never checked against the tier list in doc 15. (4) The three claim strings in `en.json` are not tested. (5) I found no test that names `scripts/content/snapshot-cms.mjs` (not verified beyond the file name).

## 8. Smells, risks and dead code

1. **False reviewer claim in UI copy.** `messages/en.json` keys `learn.subtitle` (line 856), `conditions.subtitle` (line 871) and `tools.learn.note` (line 2142) say "reviewed by a clinician". Only 25 of 100 articles have a named reviewer (Checked). This is a trust and legal risk for a health site; fix before launch.
2. **Stale count in a comment.** `apps/web/src/lib/content/unpublished-sections.ts` line 12 refers to "the 100 reviewed articles". Checked: 25 are reviewed.
3. **Stale comment in the reading API.** `apps/web/src/app/api/reading/route.ts` lines 10 to 17 describe a cross-origin CMS call that the code no longer makes. It reads the snapshot (Checked).
4. **The red-flag box is not styled as a box.** `apps/web/src/lib/cms/lexical.tsx` lines 64 to 68 render every quote as a plain blockquote with a left border. The page contract (`CODEX_AUTHORING_BRIEF.md` section 4, item 5) asks for "a distinct danger-styled box". Only the top disclaimer alert uses the danger colour (`content-article.tsx`, line 140). Checked.
5. **Reading level is self-declared.** The flag `readingLevelOk` is typed by the author (`apps/cms/scripts/import-articles.mjs`, line 211), and no code measures it. My two estimates differ by about 1.5 grades, and 34 of 37 week drafts are above 8 by the lower estimate. This needs a validated FK run before launch.
6. **Citation tiers do not follow doc 15.** ACOG, NICE, RCOG, ESHRE and ASRM are tagged tier "1" in the snapshot (113 citations). Doc 15 lists them as Tier 2. Tier 2 is effectively unused (Checked).
7. **Two sources of truth that disagree.** The 107 Markdown drafts say `status: draft` and "PENDING" for author and reviewer. The snapshot says 25 are reviewed. `content-lint` requires "PENDING" until a real name is assigned (`scripts/content-lint.mjs`, line 254). So the 25 named reviewers exist only in the CMS. If the repo becomes the source (D3), those assignments must be carried over, or they are lost.
8. **Ramadan article in two places.** `ramadan-fasting-pregnancy` is in the Markdown folder (English and Arabic) and in the `pregnancy` row of `topics.ts`, but not in the snapshot. The Arabic file has an "Editor notes (remove before publishing)" section starting at line 168.
9. **A handover contradicted by a later file.** `docs/content/HANDOVER_TRANSLATION_RETURN.md` says the working output holds 0 Arabic files. The Arabic Ramadan draft was added later (git commit `f486149`, "Ramadan draft"; Checked by `git log`).
10. **`meet-femio` sits inside the articles collection.** It has no sources, no SEO title or meta description, no H2 headings and no "when to see a doctor" section. The Learn hub drops it (`learn-hub.tsx` line 33), so the `more` row never shows. It reads like a product page, not an article.
11. **Nineteen articles have only two citations.** Two is the doc 15 minimum, so this is allowed, but thin.
12. **Empty placeholders.** `faqs.json` and `glossary.json` are empty, and their routes are hidden by `unpublished-sections.ts`. Doc 15 treats FAQs and glossary terms as content, so these are missing rather than dead.
13. **Dead code.** `CmsUnavailableError` (`client.ts` line 126) is never thrown; its own comment says nothing throws it. `cmsEnabled()` (line 118) is true whenever English articles exist, so it is effectively always on. Both are harmless, and both can go when the CMS does.
14. **Unresolved importer defect.** `HANDOVER_TRANSLATION_RETURN.md` says `apps/cms/scripts/import-translations.mjs` hard-codes the articles collection, so condition translations would land in the wrong place. From the docs; not verified in code.
15. **Gaps for the wedge.** No Arabic version of any article (section 2.5). No week 1 to 3 or 41 to 42 entries (by design, per the handover). The PCOS depth gaps in section 2.6.
16. **The author is also the reviewer.** Dr. Khaled M. is the author and the named reviewer on all 25 reviewed articles and on all five conditions. Doc 15 section 7 requires a "medical_reviewer" role, and section 10 asks reviewers to disclose conflicts. Whether self-review meets the policy is a question for the owner (section 10). It is not a finding of breach.
17. **Codex in the name.** `CODEX_AUTHORING_BRIEF.md` is named for a tool that the global notes say was retired on 27 Oct 2026, which is today. The rules in the brief are still referenced by `content-lint`, so the file is live. Its name is out of date.

## 9. Keep, rebuild or delete (per module), and the launch verdict

**Per module** (one line each, with the reason):
- `apps/web/src/content/snapshot/*.json`: **keep** as the build-time data the site reads; **rebuild** their source once the Markdown folder carries the reviewer data, since the snapshot is a derived file. Reason: no runtime database is wanted.
- `apps/web/src/lib/content/topics.ts`: **keep**. It sets the wedge's shape (TTC, pregnancy, weeks, then the rest), it is pure data, and it has tests. Update the rows when the wedge changes.
- `apps/web/src/lib/content/unpublished-sections.ts`: **keep** until glossary or FAQ has real entries; then remove the list entry, not the file. Fix the comment at line 12.
- `apps/web/src/lib/cms/client.ts`: **rebuild** as a content loader with no CMS vocabulary once the CMS is retired. Reason: the name says CMS, but the code reads JSON. Delete `CmsUnavailableError` and `cmsEnabled` with it.
- `apps/web/src/lib/cms/lexical.tsx`: **keep** while the snapshot is Lexical. **Add** a danger style for quotes that start "Seek care now:", which the renderer does not do today. Rebuild as a neutral renderer if the format changes.
- `apps/web/src/components/cms/content-article.tsx`: **keep**. The reviewer byline and the disclaimer logic are right. Move the reading-level and source-count checks into a build-time guard rather than page logic.
- `apps/web/src/components/learn/learn-hub.tsx`: **keep**. It uses the topic rows and the translation keys correctly.
- `apps/web/src/lib/search/library.ts`: **keep**. It rebuilds from the snapshot, so it follows whatever the snapshot holds.
- `apps/web/src/lib/experience/reading.ts`: **keep**. Pure mapping with 17 tests; the week clamp is the right behaviour.
- `apps/web/src/app/api/reading/route.ts`: **keep** the route; **fix** its comment.
- `scripts/content/snapshot-cms.mjs`: **rebuild** as a generator from the repo to the snapshot once the CMS is retired. A generator from Markdown needs no network.
- `scripts/content-lint.mjs`: **keep and extend**. Add a two-citation check and a tier-list check against doc 15 that run on the snapshot as well as the drafts, and a real reading-level check using a validated FK implementation. Reason: today it is the only automated guard, and it does not measure the two rules that matter most.
- `apps/cms/` (the whole CMS app): **unknown**. `CLAUDE.md` says Payload is retired (D3), but the snapshot still comes from it. Decide the retirement date first (section 10).
- `docs/content/articles/*.md`: **keep**. These are the best asset. Carry the 25 reviewer assignments into them, with the reviewer's name, before the repo becomes the source.
- `docs/content/GLOSSARY_TERMS.md`: **keep** as the translation reference. It has not been reviewed.
- `docs/content/CODEX_AUTHORING_BRIEF.md`: **keep** the rules; **rename** the file to drop the retired tool's name.
- `docs/content/HANDOVER_*.md` (prompts and returns): **keep as an archive**. They are the only record of what each run produced. Do not delete.
- `docs/15` and `docs/04`: **keep**. Either fix the tier list in doc 15 to match the snapshot, or fix the snapshot to match doc 15; the two disagree today.
- `docs/archive/2026-11/16_CONDITION_LIBRARY_IA.md`: **keep**. Its launch waves are a checklist the snapshot can now be measured against.
- `docs/11_NEEDS_SOURCE_CHECKLIST.md`: **keep** as the open list. Its 452 open items (by track: A 26, B 75, C 141, D 84, E 61, F 29, cross-cutting 20, X 16; counted by heading) are the main reviewer workload, and none is ticked.
- `docs/30_REVAMP/delegated/*`: **keep** as evidence. The benchmark's content-gap list is the best guide to what to write next.

**Launch verdict for the wedge** (Arabic-first TTC, through pregnancy, with PCOS depth):

- **Arabic: not ready.** Zero Arabic articles, zero Arabic conditions, and zero Arabic FAQs or glossary entries in the snapshot. The one Arabic file is a draft with editor notes, and it is not in the snapshot. The translation run produced nothing that passed its safety gate (`HANDOVER_TRANSLATION_RETURN.md`). The 315 requested drafts (105 slugs in each of three languages) do not exist.
- **English TTC (11 articles): nearly ready.** Seven name a reviewer. Six pass all three mechanical checks (reviewer, two or more citations, and FK method A at or below 8): `endometriosis-and-fertility`, `fertile-window-explained`, `pcos-and-fertility`, `preconception-appointment`, `when-to-seek-fertility-help`, `when-to-take-pregnancy-test`. Four have no reviewer: `age-and-fertility`, `irregular-cycles-and-timing`, `thyroid-and-conceiving` and `fertility-tests-what-to-expect`. `trying-to-conceive-guide` is reviewed but fails the reading-level estimate (8.4).
- **English pregnancy (4 in the snapshot): nearly ready.** All four are reviewed. Three pass the mechanical checks (`early-pregnancy-changes`, `first-pregnancy-appointment`, `pregnancy-warning-signs`). `pregnancy-basics` is reviewed but fails the reading-level estimate (8.2). The Ramadan article is missing from the snapshot.
- **Week by week (37, English): not ready.** None is reviewed. The handover's first-read list is weeks 24, 40, 28, 25, 35, 4, 11, 12 and 18 (From the docs). Reading level is the open issue: 34 of 37 are above 8 by the lower estimate.
- **PCOS depth: not ready.** Four English pieces, all reviewed, and none covers lifestyle, insulin resistance, treatment options a clinician may discuss, or hirsutism and acne. The benchmark ranks these as the wedge's depth gap (its P0-5 and section 5.2).
- **Across all 100 articles, the mechanical gate is met by 13** (listed in the table). Eleven of those 13 are TTC, pregnancy or PCOS pieces; two are endometriosis. "Mechanical" means the three checks above. It does not mean a clinician has checked the content.

**What is missing, in order:** (1) a validated reading-level run on all wedge articles; (2) a named reviewer for the four unreviewed TTC articles and for the 37 weeks; (3) the PCOS lifestyle and treatment-options article set (benchmark section 5.2, items 2 to 4); (4) Arabic versions of the wedge's top set, with a per-locale reviewer (none exists yet); (5) the UI claim fix in `en.json`.

**The rich-text format**, for the app and the site, is in section 4. It is a Lexical JSON tree with eight block types and five inline formats.

## 10. Open questions

1. **Who are the 25 reviewers?** Only one name appears, Dr. Khaled M., who is also the author on each of those 25 articles. Has an independent clinician reviewed any article? Not verified from here.
2. **Is the 25-reviewer set real approval?** The snapshot has no status field. Do the 25 have an approved review in the CMS, and is `lastReviewed` the review date or the import date?
3. **Which source is the truth from now on?** The Markdown drafts (D3) or the CMS? If the Markdown, the reviewer names have to move into the drafts first, and `content-lint` will need a rule that accepts named reviewers.
4. **Tier list.** Should ACOG, NICE, RCOG, ESHRE and ASRM be Tier 2 (doc 15), or Tier 1 (as the snapshot has them)? Tier 2 is almost unused in the snapshot.
5. **Reading-level gate.** Which FK implementation is the gate, and who sets `readingLevelOk` after a run? Right now the author types it.
6. **Self-review.** Doc 15 asks for a qualified clinician, and its roles separate author from reviewer. Is the owner as both author and reviewer on 25 articles and 5 conditions acceptable for launch, or does an independent reviewer need to sign off first?
7. **Arabic medical reviewer.** Who is it, and when? The benchmark (P0-1) says it is needed before Arabic content can rank or be trusted (From the docs; the owner runbook `docs/runbooks/OWNER_ACTIONS.md` was not read in this study).
8. **PCOS scope.** Should the treatment-option and lifestyle articles be written in English first and then in Arabic, as the benchmark suggests?
9. **`meet-femio`.** Is it an article or a product page? Should it leave the articles collection?
10. **The Ramadan draft.** Is the Arabic version meant to be used as it stands (it still has editor notes)? Who approves the religious framing (the benchmark says no fiqh rulings, From the docs)?
11. **The "reviewed by a clinician" strings.** Fix the three keys in `en.json` now, or after the reviewer count changes?
12. **The week-by-week set.** The handover's first-read list (weeks 24, 40, 28, 25, 35, 4, 11, 12, 18) is a suggested order. Does the owner want all 37 reviewed before launch, or only the first nine?

## Not verified

- No test suite was run. The results of the 32 counted test cases and of the two `content-lint` and import test files are not verified.
- The reading level of every article is estimated by me, not measured by a validated tool.
- Whether any article is published (the snapshot has no status field).
- Whether the CMS at `femio-cms.vercel.app` still matches the snapshot (the snapshot is dated 2026-10-07).
- The contents of `scripts/content/snapshot-cms.mjs`, `apps/cms/scripts/*.mjs`, `format.ts`, `content-hub.tsx`, `topic-art.tsx` beyond its imports, and `docs/content/people/khaled-m.json`. Their existence and line counts were checked; their behaviour was not.
- The page-view component that these content components import, and whether it sends any data.
- The clinical accuracy of the glossary renderings and of any article (clinician review is outside this study).
