# 00 · Growth operations plan (post-launch content, SEO, measurement, revenue)

**Written 2026-10-28 for the owner's finalization brief.** This folder answers five questions
the owner asked at the end of the v3 build: should the old CMS come back to grow the Learn
section; how is the site fed after launch (research, articles, SEO, social posts, product
ideas) without a team; how is every visitor action measured with the least coding; how does
femio earn (ads and a premium tier); and what exactly must Khaled do by hand. The rule of
this folder: **a plan with a default, evidence beside it, and one small test the owner can
run.** Facts are cited; numbers that are not measured yet are marked *hypothesis*.

Files in this folder:

| File | What it holds |
|---|---|
| `00_GROWTH_OPS_PLAN.md` (this) | The decisions, the agent team, the calendar, the budget, the risks |
| `01_ANALYTICS_AND_PIXELS.md` | How visits are measured: Google Tag Manager, GA4, Meta Pixel, consent, the event list, what cannot be measured and why |
| `02_MONETIZATION.md` | Ads on the website, the premium tier in the app, prices, free vs premium, revenue hypotheses |
| `03_CONTENT_SEO_AUTOMATION.md` | The post-launch team of agents: roles, cadence, pipeline, guardrails, templates, n8n as the alternative |
| `04_OWNER_GUIDE_GROWTH_A_TO_Z.md` (+ `.html`) | Every manual step for Khaled, in order, with what to click and what to paste |
| `reports/` | Evidence: the competitor monetization benchmark and later audits |

The decision that gates the measurement and ads parts is **ADR-075** in `docs/DECISIONS.md`
(status *proposed*). Nothing in §3 or §4 is wired until the owner accepts it. The content and
SEO automation (§2) does not depend on it.

---

## 1 · The CMS question: deprecated, and here is what replaces it

**Decision (default taken): the Payload CMS stays deleted.** ADR-072 removed it with the
database; bringing it back for Learn and SEO would add a server, a login, a database, a
second copy of every article and a monthly bill, and it would still not write articles.

What the Markdown pipeline already does, which is everything a CMS would do for a
one-person publisher:

| Need | How it is met today |
|---|---|
| Write and edit an article in Arabic and English | One `.md` file per language in `docs/content/articles/`, frontmatter for title, description, sources, review date, internal links |
| Publish | Commit → Vercel builds `main` → live in about two minutes (the ignored-build rule watches `packages/content` since R2.9) |
| SEO fields | Frontmatter `title`, `description`, `keywords`, FAQ block → `<title>`, meta description, JSON-LD (Article + FAQPage), hreflang pairs, sitemap, all generated |
| Validation | `pnpm gate`: content-build lint (frontmatter schema, broken internal links, missing locale pairs), wordmark lint, crisis-resource lint, privacy tripwire |
| Preview | Vercel preview URL on every branch |
| Versioning and rollback | git |
| Who may publish | Only `main`; the owner's "publish" is a merge |
| Same content in the app | The same build writes `apps/mobile/assets/content/<locale>.json` |

What a CMS would have added that the pipeline lacks: a web form for a non-developer editor,
and image upload. Neither matters while the only editor is Khaled plus agents, and the
agents write Markdown better than they fill forms. **If a human editor ever joins**, the
cheapest bridge is a GitHub web editor link per article (edit in the browser, open a pull
request), not a CMS.

---

## 2 · After launch: a team of agents that feeds the site every week

The owner's ask: frequent research, content writing, SEO optimisation, more pages and
articles, templates, posts and graphics for the online identity, digital marketing and
social platforms, plus product and service ideas, kept running after launch, on a budget of
$0–50 a month, 1–3 hours of the owner's time a day.

**Decision (default taken): scheduled Claude Code routines (`/schedule`) that open pull
requests, reviewed by the lead session, approved by Khaled with one word.** n8n is the
alternative kept in `03_CONTENT_SEO_AUTOMATION.md` §7 for the day a step needs a webhook or
a third-party posting API. Why routines first: the whole toolchain (repo, gate, content
build, Markdown, Search Console reads via the Ahrefs connector, Canva for graphics) is
already reachable from a Claude Code session; a routine is a session on a timer; it costs
nothing beyond the Claude subscription; and every output lands as a reviewable diff, which
is the only safe way to publish medical content.

### 2.1 The roles (one routine each, cheapest capable model per `tiered-subagents`)

| # | Role | Model | Runs | Reads | Produces |
|---|---|---|---|---|---|
| R1 | **Search researcher** | Sonnet | Weekly, Monday | Search Console (queries, impressions, positions, by country), the keyword maps in `04_GROWTH_PACK.md` §2, competitors' new pages | `reports/weekly/YYYY-WW-search.md`: 10 queries we rank 5–20 for, 5 gaps, 3 pages to refresh |
| R2 | **Content drafter** (`femio-content-drafter`) | Sonnet | Weekly, Tuesday | R1's gaps, `femio-medical-content` skill, Tier-1/2 sources | A pull request with 1–2 new articles EN + AR (or one refresh), every claim cited or `[NEEDS SOURCE]`, FAQ block, internal links |
| R3 | **SEO editor** | Haiku | On every content PR | The PR, the on-page rules (`04_GROWTH_PACK.md` §3), Lighthouse | Title/description within limits, hreflang pair present, JSON-LD valid, internal links ≥3, a comment on the PR |
| R4 | **Translator / register QA** (`femio-translator`) | Haiku | On every content PR | EN and AR pair, the glossary, the conservative register rules | A table of proposed fixes; the lead applies them |
| R5 | **Social producer** | Sonnet + Canva | Weekly, Wednesday | The week's article or calculator, `04_GROWTH_PACK.md` §5.3 calendar, the Dusk Bloom tokens | 3 posts × 2 languages: caption, alt text, hashtags, a Canva design from the femio template (square + story), a WhatsApp Channel version; saved under `docs/34_GROWTH_OPS/social/YYYY-WW/` |
| R6 | **Ideation analyst** (`femio-competitor-analyst`) | Sonnet | Monthly, first Friday | Competitors' release notes and store listings, Play reviews of femio and peers, the one-question feedback form answers, Reddit/forum threads | `reports/monthly/YYYY-MM-ideas.md`: 10 ranked ideas with evidence, cost class, which rule they touch |
| R7 | **Measurement reporter** | Haiku | Weekly, Sunday | Play Console export (owner uploads a CSV), Search Console, GA4 (after ADR-075) | One page: installs, retention, top pages, top queries, conversion to Play click, what changed |
| Lead | **Supervisor** (the Claude Code session Khaled opens) | Opus/Fable | When PRs exist | Everything above | Reviews, runs the gate, asks Khaled one question per PR, merges on "publish" |

Nothing in this table publishes on its own. **Medical content, architecture, merges and
releases stay with the lead and the owner** (CLAUDE.md). The social posts are files until
Khaled posts them; automatic posting is a later n8n step, after the accounts exist and the
first 20 posts have been reviewed by hand.

### 2.2 The weekly loop, from the owner's chair

Monday: nothing. Tuesday: a PR titled "content: week 47, two Arabic articles" appears.
Wednesday: a folder with three posts appears. Any evening: Khaled opens Claude Code, says
**"review this week"**, reads the lead's one-paragraph summary per PR, answers *publish*, *fix
X*, or *hold*. Sunday: the measurement page. **Time: about 45 minutes a week.** The detailed
setup is in `03_CONTENT_SEO_AUTOMATION.md`; the owner's clicks are in
`04_OWNER_GUIDE_GROWTH_A_TO_Z.md` part G.

### 2.3 What ships before launch so this works on day one

- [ ] G1 · The routine prompts as files in `docs/34_GROWTH_OPS/routines/*.md` (so a routine is "run this file"), each with its rubric and its output path.
- [ ] G2 · `reports/weekly/` and `reports/monthly/` folders with a README that names the expected files.
- [ ] G3 · A Canva brand template (square 1080×1080, story 1080×1920, cover 1200×630) in Dusk Bloom, with the Latin wordmark, Arabic and English text layers. Owner creates the Canva account (part G); a session builds the template through the Canva connector.
- [ ] G4 · The social copy rules (register, no medical advice in captions, the one link, hashtags per market) in `03_CONTENT_SEO_AUTOMATION.md` §5.
- [ ] G5 · The one-question feedback form (`04_GROWTH_PACK.md` §5.4) created, its link in the app's Settings and on the site's help page.

---

## 3 · Measurement: what "every user action" means for femio

The owner's brief: every action measured as a Shopify store does with the Google pixel and
the Meta add-on, least coding, "I believe analytics and pixels have not been good so far".
The honest frame first, then the design (detail in `01_ANALYTICS_AND_PIXELS.md`):

- **A Shopify store knows who you are because you log in and buy.** femio's website has no
  login and sells nothing; the app has no network. So "every action" means: every *page*
  someone opens, which *language* and *country*, which *calculator they opened*, whether they
  *clicked "Get the app"*, and whether that click became an *install* (Play Console reads the
  UTM tag). It never means which date she tapped or what result she saw: those stay in her
  browser, and sending them would break the promise and Meta's own terms.
- **Why it "has not been good so far":** by design nothing was installed. There is no Google
  tag, no Meta pixel, no Search Console property verified yet (part B6 of the launch guide is
  optional and unticked). The data was never bad; it was absent.
- **The design (ADR-075):** one Google Tag Manager container on the website; GA4 and Meta
  Pixel inside it; Consent Mode v2 defaulted to denied; a certified consent banner; an event
  list of nine named events; Search Console verified; Play Console acquisition reports with
  UTM-tagged links; a weekly report by R7. Coding: one component in the site, one test, one
  tripwire rule change. Everything else is clicks in Google's and Meta's consoles, written
  step by step in the owner guide.

---

## 4 · Revenue: ads on the website, premium in the app

Detail, prices, the free/premium matrix and the hypotheses in `02_MONETIZATION.md`.

- **Ads:** Google AdSense on article and Learn pages only, two units per page (after the
  first section, at the end), none near the calculator, none on help-now and legal pages,
  none above the fold on mobile. Requires the consent banner, an AdSense application once
  the site has steady traffic (Google reviews content and traffic), and payment by wire
  transfer to an Egyptian bank (AdSense pays Egypt by wire or cheque; not verified against
  Google's own table this month, see `02` §1.4).
- **Premium:** Google Play Billing in the app, two plans, $0.99 a month and $9.99 a year
  (the owner's numbers, rounded to store convention), local prices in EGP and SAR. Premium
  adds exports, reports, longer views, themes and the in-depth series; it never removes an
  article or a tool (rule 2). The app shows no ads at any tier.
- **Order of work:** consent + measurement first (you cannot price what you cannot count),
  AdSense application at about 1,000 sessions a week (*hypothesis threshold*; Google
  publishes no number), premium in the app's second release after the first 100 women.

---

## 5 · Calendar

| When | What | Who |
|---|---|---|
| Now → 9 Nov 2026 | ADR-075 decision; owner accounts (GA4, GTM, Search Console, Meta Business, Canva, social handles); G1–G5 built; consent + GTM component built behind a flag | Owner (guide parts A–G), lead |
| 11–25 Nov | Closed test (R5.4). Routines R1, R7 start in dry-run (reports only) | Routines, owner uploads Play CSV weekly |
| Week of 30 Nov | Soft launch (R5.5). Flag on for measurement. R2–R5 start: one content PR and three posts a week | All |
| Dec 2026 | First measurement month. AdSense application when traffic justifies it | Owner applies; lead places units after approval |
| Jan 2027 | Ramadan set live by 11 Jan (`04_GROWTH_PACK.md` §5.2). Premium design review with the competitor report | Lead, owner |
| Feb–Mar 2027 | App release 2 with Play Billing premium; first revenue month | Lead, owner (Play payments profile) |

---

## 6 · Budget (monthly, after launch)

| Item | Cost | Note |
|---|---|---|
| Claude subscription (routines + lead) | already paid | the only recurring cost of the agent team |
| Vercel Hobby → Pro | $0 → $20 if ads or traffic require commercial terms | Hobby terms for a commercial site **[NEEDS CHECK]**, see `04_GROWTH_PACK.md` §5.4 |
| Google Tag Manager, GA4, Search Console, AdSense Privacy & messaging | $0 | |
| Meta Business Suite, Pixel | $0 | no paid ads in the plan |
| Canva | $0 Free, or Pro about $13 for brand kit + resize | start Free |
| Play developer account | $25 once | already in OWNER_ACTIONS row 1 |
| n8n cloud | $0 now; from about €20 if adopted later | self-host alternative on a free tier |
| **Total** | **$0–33 a month** | inside the $0–50 ceiling |

---

## 7 · Risks and what catches them

| Risk | Signal | Catch |
|---|---|---|
| An agent publishes an unsourced medical claim | `[NEEDS SOURCE]` in a merged file | content-build lint fails the gate on `[NEEDS SOURCE]` in a published article (to add, G1); the lead never merges without the owner's "publish" |
| The consent banner is misconfigured and tags fire before consent | GTM preview shows a tag firing on page load with `analytics_storage: denied` | the consent test in the site (`01` §6) and the GTM preview walk-through in the owner guide |
| A health parameter leaks into an event | an event carries a date, a number of days or a result | the event list is a closed allow-list in code; the test fails on any other parameter name |
| Meta restricts the domain (Core Setup) | Events Manager shows "Data sharing restrictions" | the design already assumes Core Setup: PageView plus standard events only |
| AdSense rejects or limits the site for "sensitive health" | application email | pages are education with sources and author; appeal with the clinical review trail; fall back to no ads, premium only |
| Ads hurt the site's speed | Lighthouse performance below 85 on an article | lazy-load units below the fold; budget column in `04_GROWTH_PACK.md` §6.5 |
| Premium gates a tool by mistake | a tool or article unreachable without paying | rule 2 test in the app: every route reachable with `isPremium=false` |
| Routines drift (write about topics outside the wedge) | R1's gap list names topics not in the keyword maps | each routine reads the wedge statement first; the lead rejects off-wedge PRs |
| Egypt PDPL licence (grace period ends about 1 Nov 2026) | — | `03_LEGAL_PACK.md` §6 (owner action; a website with aggregate analytics is still a controller) |

---

## 8 · Not verified (keep apart from the plan)

- AdSense payment methods for Egypt (wire/cheque) come from a secondary source dated 2026; confirm in AdSense → Payments when the account exists.
- Play's local price floors for EGP and SAR: read them in Play Console when creating the subscription; the public table is a dynamic page the research tools could not read.
- Whether AdSense "Privacy & messaging" also sets Consent Mode signals for a GA4 tag loaded through GTM on the same page: verify in GTM preview during setup (`04` part D step 9). If not, switch to a free certified CMP (CookieYes free tier or similar) **[NEEDS CHECK]** page limits.
- Vercel Hobby plan terms for a site that carries ads.
- The Play service fee for subscriptions: Google's help page 112622 is the source; the 2026 fee restructure reported by secondary sources is not confirmed here.
