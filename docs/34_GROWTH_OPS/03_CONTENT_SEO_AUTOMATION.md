# 03 · Content, SEO and social automation after launch

**Status: design, not gated by ADR-075.** This is the "team of agents" the owner asked for:
research, writing, SEO, more pages, templates, posts and graphics, product ideas, every week,
with the owner spending about 45 minutes reviewing. It runs on Claude Code scheduled routines
(the `/schedule` skill: a session on a timer, in the cloud, that opens pull requests). n8n is
the alternative (§7) for steps that need a webhook or a posting API.

## 1 · The pipeline in one picture

```
 Monday            Tuesday               on PR                 Wednesday            Sunday
 R1 Researcher ──► R2 Drafter ──► PR ──► R3 SEO editor ──┐    R5 Social ──► files   R7 Reporter
 (Search Console,  (1–2 articles      R4 Translator QA ──┤    (3 posts ×2 langs,    (one page)
  keyword maps,     EN+AR, cited)                         │     Canva designs)
  competitors)                                            ▼
                                              Lead reviews, runs `pnpm gate`,
                                              asks Khaled: publish / fix / hold
                                                          │
                                                 merge to main ──► Vercel deploys
                                                                   app content JSON rebuilt
 First Friday of the month: R6 Ideation analyst ──► reports/monthly/YYYY-MM-ideas.md
```

Nothing publishes without the merge. The merge needs Khaled's word. That is the whole
safety model, and it is the same one the v3 build used.

## 2 · Each routine, specified

Every routine is a Markdown prompt file in `docs/34_GROWTH_OPS/routines/`; the schedule
points at the file, so changing a routine is a commit. Each file has the same five parts:
*Read first* (the wedge, the rules, the skill), *Inputs*, *Steps*, *Output path and format*,
*Rubric* (what the lead checks). The routine files are task G1 and are written by a session
once the owner's accounts exist (R1 and R7 need Search Console and the Play CSV).

### R1 · Search researcher (Sonnet, weekly)
- Reads: `04_GROWTH_PACK.md` §2 keyword maps; Search Console for femioapp.com (through the Ahrefs connector's GSC tools or a CSV the owner exports); the competitor pages that rank for the Arabic wedge queries (fetch, read, do not copy).
- Produces `reports/weekly/YYYY-WW-search.md`: (a) 10 queries at positions 5–20 with the page that ranks and one change that would move it; (b) 5 gaps: Arabic questions women ask that no femio page answers, each with evidence (a forum thread, a Play review, a Search Console impression); (c) 3 pages to refresh (oldest `last_reviewed`, or lost positions).
- Rubric: every gap is inside the wedge (TTC → pregnancy, PCOS, Egypt + Saudi) or explicitly flagged as outside it; no volume number without a source.

### R2 · Content drafter (Sonnet, `femio-content-drafter`, weekly)
- Reads: R1's gaps; `femio-medical-content` and `femio-compliance-privacy` skills; `docs/compliance/*` thresholds; the glossary and register rules in `docs/content/reviews/2026-10-28-arabic-editor-pass.md`.
- Produces a branch `content/YYYY-WW` with 1–2 articles (EN and AR each, frontmatter complete, FAQ block, ≥ 3 internal links, sources Tier 1/2 with URLs and access dates, `[NEEDS SOURCE]` where a claim lacks one) or one refresh; runs `node scripts/content/build-content.mjs` and `pnpm gate`; opens a PR with a 5-line summary and the list of `[NEEDS SOURCE]` flags.
- Rubric (lead): no diagnosis, treatment or contraception-efficacy wording (`MENSTRUAL_SAFETY_THRESHOLDS.md`, `CONTRACEPTION_SAFETY.md`); conservative register in Arabic; Latin wordmark; red-flag box where the topic needs it; reading level grade 6–8.

### R3 · SEO editor (Haiku, on every content PR)
- Checks: title ≤ 60 chars and description 120–155 chars in both languages; one H1; FAQ questions match real queries from R1; JSON-LD validates (the content build already emits it; the check runs the validator); hreflang pair present; internal links resolve; images have alt text; the slug is ASCII and matches the EN slug for the AR file.
- Produces a PR comment table: pass/fail per check with the fix. Never edits the file.

### R4 · Translator / register QA (Haiku, `femio-translator`, on every content PR)
- Compares EN and AR: meaning parity line by line; glossary term + lay alias once; `العلاقة الزوجية` not `جماع`; `طبيبتكِ أو طبيبكِ`; Western digits; femio masculine; agreement.
- Produces a table of proposed edits; the lead applies the accepted rows.

### R5 · Social producer (Sonnet + Canva connector, weekly)
- Reads: the week's merged article or the calendar entry in `04_GROWTH_PACK.md` §5.3; the copy rules in §5 below; the Dusk Bloom tokens; the Canva brand template (G3).
- Produces `social/YYYY-WW/`: for each of 3 posts, `post-N.md` (hook line, 3–5 lines, one link with `utm_campaign=social-YYYY-WW-N`, 3–6 hashtags per market, alt text, the WhatsApp Channel version ≤ 300 chars) in AR and EN, plus the Canva design links (square and story) with the text placed. Variants per platform: Instagram/TikTok caption, Snapchat Spotlight caption, X thread (Saudi), Facebook group answer (Egypt; written as Dr Khaled answering a question, link to the article).
- Rubric: no medical advice in a caption; one claim per post and it exists in the article; no faces; Latin wordmark; the hashtag list contains no sexual-wellness terms.

### R6 · Ideation analyst (Sonnet, `femio-competitor-analyst`, monthly)
- Reads: competitor release notes and store "What's new"; Play reviews of femio and of the peers (Egypt and Saudi storefronts); the one-question feedback answers (the owner pastes the month's export into `reports/feedback/YYYY-MM.md`, health details removed); r/TTC, r/PCOS, عالم حواء threads.
- Produces `reports/monthly/YYYY-MM-ideas.md`: 10 ideas ranked by evidence × fit, each with the rule it touches (1–6), a cost class (S/M/L), and which tier (free/Plus) it belongs to; 3 "stop doing" observations.
- Rubric: an idea that needs a server, an account or health data leaving the phone is listed under "rejected by rule 4", never promoted.

### R7 · Measurement reporter (Haiku, weekly)
- Reads: Search Console; GA4 (after ADR-075); the Play Console CSV the owner drops into `reports/play/YYYY-WW.csv` (the file is git-ignored; only the summary is committed).
- Produces `reports/weekly/YYYY-WW-measurement.md` as specified in `01_ANALYTICS_AND_PIXELS.md` §7.

### Lead · Supervisor (the owner's own Claude Code session)
On "review this week": lists open PRs and new report files, reads R3/R4 comments, runs the gate,
writes one paragraph per PR, asks one question each, merges on "publish", tells the owner which
three posts to publish today and pastes their text. Never delegates the merge.

## 3 · Growing the site beyond articles (the "more pages" ask)

| Page type | Source of truth | Who makes it | Cadence |
|---|---|---|---|
| Articles (100 → 150 by Ramadan 2027) | `docs/content/articles/` | R2 | 1–2 a week |
| Condition hubs (5 → 8: add thyroid & fertility, endometriosis in Arabic, postpartum) | hub frontmatter + the article graph | R2 + lead | one a month |
| Glossary (Arabic medical terms with lay aliases, one page each, strong for search) | `docs/content/glossary/*.md` (new) → content build | R2, from the editor-pass glossary | 10 a week for 8 weeks |
| Questions pages ("هل … ؟" one question, one sourced answer, the calculator link) | `docs/content/questions/*.md` (new) | R2 from R1's gaps | 3 a week |
| Calculators | `apps/web/src/lib` (domain rules, golden fixtures) | lead only; a new calculator is a product decision | — |
| Templates and downloads (printable cycle sheet, doctor-visit question list, Ramadan planner), PDF | `docs/content/downloads/` built by a script, linked from articles | R2 drafts, lead builds | one a month |
| Store listing refresh (ASO) | `docs/store/play-listing.{en,ar}.md` | R1 (keywords) + lead | monthly |

New content types need one content-build change each (a frontmatter schema and a template);
the lead does it the first time the type is used.

## 4 · SEO maintenance that runs itself

- Search Console verified (owner, guide part C); sitemap submitted once; the content build already regenerates it.
- R1 watches positions; R3 blocks regressions on every PR.
- Quarterly: a Lighthouse run on the four reference pages (`testing-results/<date>-lighthouse/`), compared with the last.
- Backlinks: no outreach automation. The clinic QR cards, the Facebook-group answers and the forum answers are the link sources; R1 lists new referring domains from Search Console.
- Hreflang, canonical, JSON-LD: generated; `e2e/home.spec.ts` and the content-build lint keep them.

## 5 · Copy rules for social and online identity

- The wordmark is always the Latin lowercase **femio**, also in Arabic text.
- One post, one question, one answer, one link. The answer is a sentence from a reviewed article; the link is to that article or calculator, never to the Play page directly (the page hands off).
- Register: conservative; intercourse is *العلاقة الزوجية*; no sexual-wellness content; no imagery of people; Dusk Bloom palette; no rings, no single date, no "late" counter.
- Never reply to an individual's medical question with anything but "talk to your doctor" + the article link (growth pack §5.1).
- Hashtags: 3–6, per market, from a list kept in `social/HASHTAGS.md` (Egyptian and Saudi Arabic variants; English for Reddit titles only, Reddit takes no hashtags).
- Every link carries `utm_source`, `utm_medium=social`, `utm_campaign=<platform>-YYYY-WW-N`.
- Posting is by hand until 20 posts have gone out and the accounts are stable; then §7.

## 6 · Templates (built once, reused by R5)

| Template | Size | Layers | Where |
|---|---|---|---|
| Square post | 1080×1080 | plum field, headline AR/EN, one-line answer, wordmark, calculator or article pictogram | Canva brand template `femio / square` |
| Story / Reel cover | 1080×1920 | the same, vertical, safe zones for UI | `femio / story` |
| Link preview (OG) | 1200×630 | already generated per article by the site | — |
| WhatsApp Channel card | 1080×1350 | large Arabic headline, QR to the page | `femio / channel` |
| Clinic QR card | A6 print | bilingual, QR, "سجلاتكِ لا تغادر هاتفكِ" | `femio / clinic-a6` |
| Chart card (for "graphs") | 1080×1080 | a simple sourced figure (e.g. cycle-length range), Dusk Bloom chart tokens, source line | `femio / figure` |

The owner creates the Canva account (guide part F); a session builds the templates through
the Canva connector and saves their ids in `social/TEMPLATES.md`.

## 7 · n8n: when and how

Use n8n only for the two things a routine cannot do: react to an external event, and post to
a platform's API. Candidate workflows, in order of value:

1. **Weekly digest to the owner** (Sunday 20:00 Cairo): read `reports/weekly/*` from GitHub, send one email with the three numbers and the list of PRs waiting. Nodes: Cron → GitHub → Gmail. (The Claude routine can also email through the Gmail connector; n8n is only needed if the owner wants it independent of Claude.)
2. **Post scheduling**: when a file in `social/YYYY-WW/` is marked `approved: true` in its frontmatter (the owner flips it in GitHub's web editor), publish to Facebook Page and Instagram through the Meta Graph API, to X through its API; WhatsApp Channels have no posting API (hand). Nodes: GitHub trigger → Switch → Meta/X nodes. Needs: Meta app review for `pages_manage_posts` and `instagram_content_publish` (owner, guide part E), X API tier (free tier allows posting, limits apply).
3. **Review alerts**: new Play review → Telegram or email to the owner with a suggested reply drafted by a Claude call. Nodes: Google Play Developer Reporting API (needs a service account; owner creates it) → HTTP (Claude API) → Gmail.

Cost: n8n Cloud Starter about €20 a month, or self-hosted free on a small VPS (Hetzner CX22
about €4) which the owner would maintain; or the free tier with limits. Start with none; add
workflow 2 when posting by hand has become the bottleneck.

## 8 · Guardrails that cannot be skipped

| Guardrail | Enforced by |
|---|---|
| No merge without the owner's "publish" | the lead; branch protection on `main` (owner, GitHub settings, guide part A) |
| No `[NEEDS SOURCE]` in a published article | content-build lint (to add in G1): fails the gate when the flag is in a file with `status: published` |
| No health data in any report | routines read aggregates only; the Play CSV and feedback exports are git-ignored; R7 commits summary tables |
| Wedge discipline | each routine's *Read first* opens with the wedge sentence; the lead rejects off-wedge PRs |
| Cost | routines run at most once per schedule; a failed routine does not retry; the lead's weekly review is one session |
| Register and wordmark | the existing gate guards (wordmark-lint, crisis-lint) run on every PR |

## 9 · Build list (ledger R6.3–R6.6 in `PROGRESS.md`)

- G1 routines as files + the `[NEEDS SOURCE]` publish lint
- G2 report folders + README
- G3 Canva templates (after the owner's Canva account)
- G4 `social/HASHTAGS.md`, `social/TEMPLATES.md`, the copy rules above referenced from the routine files
- G5 the feedback form link wired (Settings + help page)
- First dry run of R1 and R7 against real Search Console data before the soft launch
