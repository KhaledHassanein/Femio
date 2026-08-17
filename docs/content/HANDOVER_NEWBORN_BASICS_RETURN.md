# Return handover — newborn basics seed set (drafted 2026-08-17)

Written against `docs/content/HANDOVER_NEWBORN_BASICS.md` §5. Eight drafts are in
`docs/content/articles/`. `pnpm content-lint` and `pnpm content-lint:urls` are both clean.

---

## Part 1 — Batch note

### What was written

Eight English drafts, `status: "draft"`, `disclaimer_type: "emergency"`, every byline and date
left `PENDING` / `null`.

| Slug | Words | Sources | Internal links |
|---|---|---|---|
| `newborn-first-two-weeks` (pillar) | ~1,430 | 4 | 6 |
| `feeding-your-newborn` | ~1,020 | 4 | 5 |
| `newborn-warning-signs` | ~1,160 | 4 | 5 |
| `newborn-crying` | ~1,105 | 3 | 5 |
| `safer-sleep-for-your-baby` | ~1,125 | 4 | 5 |
| `newborn-nappies-skin-and-cord` | ~1,115 | 5 | 4 |
| `bottle-and-formula-feeding` | ~1,115 | 4 | 4 |
| `newborn-checks-and-vaccinations` | ~1,055 | 6 | 4 |

Every article carries the same red-flag box, worded from the newborn set in the prompt §4.5, with
one addition on `newborn-crying` (a weak, high-pitched or continuous cry that is not the baby's
usual cry — NHS lists it, and it is the cry article). The box always closes with "Femio cannot
assess a baby". Emergency routing is global and number-free everywhere: "contact your local
emergency services or go to your nearest emergency department".

The boundary sentence sits in the answer-first opening of all eight, naming a midwife, health
visitor, paediatrician or emergency service as the place an individual baby's question goes.

### What was deliberately cut for lack of a source

- **Any "how many wet nappies per day" number.** The commonly circulated day-by-day counts could
  not be traced to a Tier-1 document. The articles describe a clear drop from the baby's own
  pattern, plus the NHS threshold of no wet nappy in 12 hours as urgent, and route the judgement
  to a clinician.
- **Newborn sleep totals** ("newborns sleep 16–17 hours"). No Tier-1 citation found that states
  it in a form worth quoting, and it invites a sleep verdict. Replaced with "short blocks, day
  and night, and adds up differently for every baby".
- **A crying-hours figure** (the "peaks at ~2–3 hours a day at 6 weeks" style claim). NHS and CDC
  describe the *shape* of the curve without a number, so only the shape is stated.
- **Cord separation timing as a range** ("5–15 days"). AAP's checkable statement is that a stump
  still attached at three weeks needs a check, so that is what is written.
- **SIDS incidence statistics.** AAP's parent page carries a US figure, but a single-country
  number in a four-locale product reads as a global one. Cut; the risk-reduction advice stands
  without it. Same reasoning for the CDC abusive-head-trauma mortality statistics — the safety
  behaviour is the message, not the death rate.
- **Colic prevalence and any colic remedy** (drops, probiotics, formula changes). No Tier-1
  support that survives the no-regimen rule.
- **Jaundice prevalence** ("around 6 in 10 newborns"). The NHS page describes the pattern rather
  than the rate in the section consulted, so only the pattern and the escalation routes are used.

### Where guidance differs between countries, and how it was handled

Three genuine splits, each stated plainly with both sides cited:

1. **Bed sharing** (`safer-sleep-for-your-baby`). AAP does not recommend bed sharing at all and
   advises room sharing without it. NHS also names a separate cot as safest, then publishes
   "co-sleeping more safely" advice because families do it anyway. The article gives the shared
   core first (back, firm flat clear surface, room sharing, never a sofa or armchair, the
   absolute contraindications both bodies agree on), then names the split and tells her to follow
   the guidance published where she lives and to tell her health visitor how the baby actually
   sleeps.
2. **Formula water temperature** (`bottle-and-formula-feeding`). NHS applies the ≥70°C water
   method to every feed for every baby. CDC says following label instructions with safe tap water
   is usually fine, and reserves boiled water for babies under two months, babies born before 37
   weeks, immunocompromised babies, emergencies, and unsafe water. Both are stated, both cited,
   with "follow the advice published where you live".
3. **Vaccination and screening schedules** (`newborn-checks-and-vaccinations`). WHO's summary
   tables as the base; NHS first routine vaccines at eight weeks with BCG and hepatitis B for
   babies at higher risk; CDC's US schedule starting at birth with a hepatitis B dose. Newborn
   blood-spot panels differ too (UK national panel vs per-state US programmes). No schedule is
   presented as Femio's recommendation.

A fourth, smaller one: **cord care**. WHO's postnatal-care recommendations describe clean dry
cord care as standard and chlorhexidine application in settings where newborn deaths at home are
common. Named, because Femio serves countries on both sides of that line.

### What a clinician must decide

1. **The 38°C threshold.** `newborn-warning-signs` states it in the opening paragraph and every
   red-flag box carries it. It is the single most valuable fact in the set and the most exposed —
   NICE NG143 and NHS both support it, but it is a number in the mouth of a wellness product.
   Keep, soften to "a fever", or keep with different framing is a reviewer's call.
2. **Temperatures, times and water temperature in the formula article** (≥70°C water, CDC's
   two-hour / one-hour / 24-hour storage limits). These are hygiene and safety parameters, not
   doses, and were read as outside the no-dose rule — but they are numbers attached to feeding, so
   they should be looked at with that rule in hand.
3. **The "put the baby down and step away" passage** in `newborn-crying`. Written from NHS and
   CDC wording, including "never shake a baby" and a ten-minute time limit, and routed to
   `/en/help-now`. It is the highest-value passage in the set and the one most sensitive to tone;
   please read it as a whole.
4. **Vitamin K** (`newborn-checks-and-vaccinations`). Cited to NICE NG194, which recommends
   offering it. Written as "offered … to protect against vitamin K deficiency bleeding" to keep
   the actor a guideline body. Confirm the framing is right for a global audience where the route
   of administration differs.
5. **Reviewer posture.** These eight pages are about a second person who is not the account
   holder. Doc 15 §8's reviewer statement is written for adult content. Raised in the source
   handover §6.5; repeated here because it should be settled before publication, not after.

---

## Part 2 — Handover prompt, to paste whole into a fresh chat

> You are picking up **Femio** (`e:\Femio`, women's-health platform) after the newborn-basics
> work of 2026-08-17. Read `CLAUDE.md`, then `docs/STATE.md`, then `docs/07_MASTER_TODO.md`.
> Assume you have this file and none of that session's conversation. Two commits carry the work:
> `38af656` (the eight drafts) and `13a5a30` (the wiring). The full gate is green on both —
> typecheck, 570 tests, eslint, twelve lints, and `content-lint --check-urls`.
>
> ### What was done, and why each piece is where it is
>
> **1. Eight newborn articles were drafted and imported** (P2.13c, from B7's approval). They live
> in `docs/content/articles/`: `newborn-first-two-weeks` (the pillar, ~1,430 words),
> `feeding-your-newborn`, `newborn-warning-signs`, `newborn-crying`, `safer-sleep-for-your-baby`,
> `newborn-nappies-skin-and-cord`, `bottle-and-formula-feeding`, `newborn-checks-and-vaccinations`.
> `pnpm content-import -- --apply` created all eight in the CMS as drafts. **Nothing is public and
> nothing may be published from code** — that is the owner's gate in `/admin` (ADR-032).
>
> This is the first content Femio has published about **a person who is not the account holder**,
> so three rules are load-bearing and were applied to every page: the boundary to a paediatrician,
> health visitor or emergency service stated in the answer-first opening; a red-flag box drawn from
> the *newborn* set rather than an adult one, closing with "Femio cannot assess a baby"; and **no
> assessment of a baby, ever** — no adequacy, growth, sleep or development verdict about hers.
> Emergency routing is global and number-free everywhere: "contact your local emergency services or
> go to your nearest emergency department".
>
> Sourcing is recorded in Part 1 of this file with every URL and tier. Three points worth carrying
> forward: **NHS moved its baby content** from `/conditions/baby/…` to `/baby/…`, so older NHS
> links in the repo resolve only through a redirect; **three Tier-1 hosts reject automated
> requests** and would fail `content-lint:urls` — `publications.aap.org` (403), NICE CKS (403),
> Cochrane (412) — so their ground is covered by NHS and AAP pages instead; and **where national
> guidance genuinely disagrees, both sides are stated and cited** rather than averaged into a fake
> consensus (bed sharing, formula water temperature, vaccination and screening schedules).
>
> **2. Three of the eight are wired into the experience engine, and five deliberately are not.**
> This is the part to understand before touching Track E.
>
> `ARTICLE_FOR_TOPIC` in `apps/web/src/lib/experience/reading.ts` maps registry *topics* to article
> slugs, and `reading.test.ts` asserts that every foregrounded topic is either mapped or listed in
> `NO_ARTICLE_YET` — **and, in the other direction, that nothing is mapped which no persona
> foregrounds.** So a slug can only appear there if some persona asks for its topic.
>
> The obvious persona is **E1**, the postpartum recovery spine — a woman weeks after birth is
> exactly who these pages were written for. **It is the one place they cannot go.**
> `content.foreground` merges purely additively up the `extends` chain (`build.ts`, `foreground =
> unique([...foreground, ...record.content.foreground])`), there is no subtraction anywhere in the
> engine, and **E6 (pregnancy loss) extends E1**. A topic added to the spine therefore appears on
> the reading card of a woman after a loss. "Your newborn in the first two weeks" in front of her is
> the worst thing this track could do, and E6 §A says so in those words.
>
> So three topics are on **E2** instead, whose resolver gate is a stated live birth
> (`pregnancyOutcome === "completed"`, no prior loss) that E6 can never satisfy:
> `is-baby-getting-enough` → `feeding-your-newborn` (it had been in `NO_ARTICLE_YET` since R2.5f
> with a note saying a standalone page was a scope decision; B7 made that decision),
> `newborn-warning-signs`, and `bottle-and-formula-feeding`. E2's card now fills with four real
> pages. **A test enforces the rule** — "puts no newborn content in front of a loss, through the
> whole extends chain" resolves E6 the way the engine does rather than reading E6's own list, and it
> was watched failing by putting a newborn topic on E1 first. If you add one, it fails. That is the
> point; do not weaken it.
>
> The remaining five — the pillar, crying, safer sleep, nappies and cord, checks and vaccinations —
> reach her from `/learn` and from each other's prose, and from no dashboard.
>
> ### What is open, and what you may not decide alone
>
> Both are in `docs/runbooks/BLOCKERS.md` under **B7**, and neither blocks other work:
>
> 1. **The infant reviewer statement.** Doc 15 §8's reviewer statement is written for content about
>    an adult woman's own body. Eight pages about infants may want their own line. Owner's call.
> 2. **Whether the five unshelved articles get a persona shelf**, which needs one of: **(a)**
>    subtraction in the engine, letting an `emotionalLayer` remove inherited topics — the first
>    exception to "additive layers", which is product rule 5, so it is an ADR; or **(b)** a
>    live-birth-gated newborn persona beside E2, no engine change, one more record to maintain.
>    **(b) is the standing recommendation.** Do not implement either without the owner's answer.
>
> Also still owner-side: publishing each draft in `/admin`, page by page. The reading cards fill
> themselves in as he publishes — no deploy, no code change.
>
> ### Sentences a clinician should re-read, and why
>
> Listed in Part 1 §"What a clinician must decide" and §"Sentences to read for the no-assessment
> line". The short version: the `38C` threshold in every red-flag box; the water temperature and
> storage times in `bottle-and-formula-feeding`, which were read as hygiene parameters rather than
> doses; the "put the baby down and step away" passage in `newborn-crying`, which is the
> highest-value passage in the set; and four sentences that come closest to reassuring her about her
> own baby rather than describing a population.
>
> ### What to do next
>
> `git branch --list "wip/*"` (expect nothing), then take the top open item in
> `docs/07_MASTER_TODO.md` → **▶ NOW**. P2.13c stays `[~]` until the owner publishes and answers
> the two B7 questions; nothing about it needs you. The one content set still out with another
> agent is week-by-week (`docs/content/HANDOVER_WEEK_BY_WEEK.md`, B9 → weeks 4–40).
>
> Run the full gate before every push, and never end a turn with a dirty tree.
