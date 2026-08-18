# Return handover — pregnancy week-by-week, weeks 4–40 (drafted 2026-08-18)

Written against `docs/content/HANDOVER_WEEK_BY_WEEK.md` §10. **The set was drafted here, in
the project, rather than in the separate chat** — the prompt went out on 2026-08-16 and nothing
came back, which is the same call the owner made for the teen ten (P2.13) and the newborn eight
(P2.13c). 37 drafts are in `docs/content/articles/`. `pnpm content-lint` is clean over 101
drafts, every source URL was resolved **and its page title read**, and all 37 are imported into
the CMS as drafts.

---

## Part 1 — What was written

37 English drafts, `status: "draft"`, `disclaimer_type: "emergency"`, every byline `PENDING` and
every date `null`. Each carries **three sources** (all Tier 1) and **four or five internal
links**, and every one lands inside the 600–900 word band — 612 at the shortest (week 21), 823
at the longest (week 4).

Section order is the same in all 37, and it differs from the prompt in one place:

```
H1  ·  2–4 sentence opening
## Your body this week
## What you may notice
## Your baby this week
## What care usually happens around now      ← where the week genuinely has one
## This week's tip
## When to see a doctor                       ← exact string, checked mechanically
>   **Seek care now:** …
## Frequently asked questions                 ← two questions, justifying FAQPage
```

**The care section sits before the tip, not after the red-flag box.** §2 reads as if it comes
last; putting a paragraph about routine scans *after* an emergency box reads as an afterthought
appended to the wrong thing. If a reviewer disagrees this is a one-line move in every file.

Weeks that have a `## What care usually happens around now` section: 4, 5, 6 (nothing routine,
said so), 8, 10, 11, 12, 13, 14, 15, 16, 18, 19, 20, 21, 24, 25, 27, 28, 31, 32, 33, 34, 35, 36,
37, 38, 40. Every one attributes to a named body and says schedules differ between countries.
None presents a schedule as Femio's.

### The red-flag box

Identical set across all 37, from §3: heavy bleeding, severe or one-sided tummy pain, severe
headache with vision changes, sudden swelling of face or hands, fever, fluid leaking, chest pain,
trouble breathing, fainting, seizure. Three variations, each deliberate:

- **Weeks 4–12 add "pain in the tip of your shoulder"** and omit fluid leaking. Shoulder-tip pain
  is the early-pregnancy sign women are least likely to recognise, and leaking fluid is not a
  meaningful sign before the second trimester.
- **From week 23 the box adds the movement line**, worded as *"any reduction in your baby's usual
  pattern of movement"* and routed to the maternity service. **No count appears anywhere in the
  set** — the rule is a change from her own usual, and weeks 17, 23 and 24 say in prose that a
  fixed number is the wrong instrument, with RCOG cited.
- **From week 35 the box adds "pain just below the ribs"**, because that is the week the NHS
  itself raises it as a pre-eclampsia sign against a background of ordinary rib soreness.

Every box closes with **"Femio cannot assess a pregnancy."** No phone number appears in any file.

---

## Part 2 — Every source used, with tier

**70 unique URLs. All Tier 1.** Each was fetched and its `<h1>` read — not its status code. That
matters twice over here: NHS moved the entire week-by-week guide under `/best-start-in-life/`
(the old `/pregnancy/week-by-week/` paths 301 rather than 404), and **acog.org serves HTTP 200
with a "Page Not Found" body for a dead FAQ slug**, which `content-lint:urls` would pass happily.
Two ACOG URLs were dropped for exactly that reason (see Part 5).

**NHS week pages (37, one per entry, all Tier 1)** —
`https://www.nhs.uk/best-start-in-life/pregnancy/week-by-week-guide-to-pregnancy/{1st|2nd|3rd}-trimester/week-N/`.
Weeks 4–12 are `1st-trimester`, **13–27 are `2nd-trimester`** (note 13, not 14), 28–40 are
`3rd-trimester`.

**NHS topic pages (Tier 1)** — pregnancy symptoms · signs and symptoms that might mean you're
pregnant · antenatal care and appointments · screening tests in pregnancy · 12-week scan ·
20-week screening scan · your baby's movements · exercise in pregnancy · vaccinations in
pregnancy · pre-eclampsia · mental health in pregnancy · signs that labour has begun · inducing
labour.

**ACOG (Tier 1)** — Morning Sickness · Ultrasound Exams · Prenatal Genetic Screening Tests ·
Healthy Eating During Pregnancy · Preeclampsia and High Blood Pressure During Pregnancy ·
Exercise During Pregnancy · Skin Conditions During Pregnancy · Travel During Pregnancy · Preterm
Labor and Birth · The Rh Factor · Gestational Diabetes · Group B Strep and Pregnancy ·
Breastfeeding Your Baby · How to Tell When Labor Begins · Labor Induction · When Pregnancy Goes
Past Your Due Date.

**NICHD (Tier 1)** — About Pregnancy · What happens during prenatal visits?
**RCOG (Tier 1)** — Your baby's movements in pregnancy.
**CDC (Tier 1)** — About Vaccines and Pregnancy. *(CDC returns 403 to a plain `curl`; it answers
node's `fetch` with the lint's user agent, which is what `content-lint:urls` uses.)*

Nothing outside these was cited. No blogs, no Wikipedia, no competitor apps. Where the NHS pages
themselves link out to a charity — Tommy's, NCT, Twins Trust — that material was **not** used.

---

## Part 3 — The size comparisons, and the source behind each measurement

Every comparison and every figure comes from the **NHS week page for that week**, and every one
is written population-framed with the source named in the sentence. The measurement basis
**changes at week 20**, which the set says out loud in the week-20 entry, because otherwise the
number looks like a sudden growth spurt.

Weeks 4–19 are **crown to rump** ("head to bottom"); weeks 20–40 are **head to heel**.

| Wk | Figure | Comparison | Wk | Figure | Comparison |
|---|---|---|---|---|---|
| 4 | ~2mm | poppy seed | 23 | ~28.9cm | large mango |
| 5 | ~2mm | sesame seed | 24 | ~30cm | corn on the cob |
| 6 | ~6mm | pea | 25 | ~34.6cm | courgette |
| 7 | ~10mm | grape | 26 | ~35.6cm | cucumber |
| 8 | ~16mm | raspberry | 27 | ~36.6cm | head of cauliflower |
| 9 | ~22mm | strawberry | 28 | ~37.6cm | aubergine |
| 10 | ~30mm | apricot | 29 | ~38.6cm | butternut squash |
| 11 | ~41mm | fig | 30 | ~39.9cm | cabbage |
| 12 | 5.4cm | plum | 31 | ~41.1cm | coconut |
| 13 | ~7.4cm | peach | 32 | ~42.4cm | bunch of celery |
| 14 | ~8.5cm | kiwi fruit | 33 | ~43.7cm | pineapple |
| 15 | ~10.1cm | apple | 34 | ~45cm | cantaloupe melon |
| 16 | ~11.6cm | avocado | 35 | ~46.2cm | honeydew melon |
| 17 | ~12cm | pomegranate | 36 | ~47.4cm | romaine lettuce |
| 18 | ~14.2cm | bell pepper | 37 | ~48.6cm | leek |
| 19 | ~15.3cm | beef tomato | 38 | ~49.8cm | rhubarb |
| 20 | ~25.6cm | banana | 39 | ~50.7cm | small watermelon |
| 21 | ~26.7cm | carrot | 40 | ~51.2cm | pumpkin |
| 22 | ~27.8cm | sweet potato | | | |

**No weight figure appears in any entry.** The NHS week pages do not give per-week weights, and
every per-week weight table on the internet traces back to app blogs or to charts a clinician
uses to interpret a scan. A weight in a consumer article is the single number most likely to be
read as a verdict on a scan result, so the set has none — which also means the phrase *"most
babies weigh roughly…"*, blessed by §0.2, is never used.

---

## Part 4 — Where the "measurement of her baby" line was hardest

Five places. The rule applied in each: **the sentence's subject may never be her pregnancy.**

1. **The section heading is `## Your baby this week`** — mandated by §2, and it is the most
   possessive string in the set. Everything under it is written to pull the other way: the
   opening sentence of the section names the week and the source, never "your baby". If a
   reviewer wants the heading changed the whole set changes with it, so it is flagged rather
   than quietly altered.
2. **"Your baby is about the size of a plum" is the NHS's own wording** and it was not copied.
   Each entry reads *"around week 12, the NHS gives a measurement of 5.4cm from head to bottom —
   about the size of a plum"*, then adds a hedge in its own words. The hedge is varied across the
   37 rather than templated, and the variants are all versions of one claim: *these are averages
   across many pregnancies, and a scan measuring differently is a conversation with a clinician
   rather than a verdict.*
3. **Week 12's "5.4cm" is the only exact decimal presented without "around"**, because that is
   how the NHS states it. It is attributed in the same clause. The alternative — rounding it —
   would have been quietly rewriting a sourced figure.
4. **Week 24, viability.** The temptation is a sentence about what *her* baby could survive. It
   is written as a fact about care — *"from around this point a baby born early may survive with
   the support of a neonatal unit"* — and the FAQ says explicitly that it is a threshold in how
   care is provided, not a promise.
5. **Weeks 31, 32, 36 and 37, position.** "Your baby is breech" is a clinical finding somebody
   else made. Every mention is framed as a position on one day with time left, and week 31's FAQ
   answers "does that mean a caesarean?" with "not at 31 weeks".

One more that is not about the baby but is the same class of error: **the bump.** Weeks 12 and
24 both say plainly that bump size is a poor guide to anything and list what actually determines
it, because "my bump is smaller than hers" is the question this set would otherwise invite.

---

## Part 5 — What was cut, and what is not here

**Cut for lack of a usable source:**

- **All per-week fetal weights** (Part 3).
- **Two ACOG pages that look real and are not**: `/womens-health/faqs/nutrition-during-pregnancy`
  and `/womens-health/faqs/postterm-pregnancy` both return HTTP 200 with a "Page Not Found" body.
  Replaced with `healthy-eating-during-pregnancy` and `when-pregnancy-goes-past-your-due-date`,
  which resolve to the documents they name.
- **Amounts, of anything.** Folic acid and vitamin D are named as classes where a guideline names
  them; no dose appears in any file. The NHS week pages state doses; those sentences were not
  carried across.
- **The "1 in 20 babies arrive on their due date" figure** is used once, in week 33, attributed
  to the NHS week page it appears on. Other circulating percentages were dropped.

**Deliberately absent:**

- **Weeks 1–3.** Dating counts from the last period (`docs/content/HANDOVER_WEEK_BY_WEEK.md` §2).
- **Weeks 41 and 42 as entries.** Week 40 covers going past the due date, and `weekArticleSlug`
  holds week 40 for any week above it rather than falling off the end.
- **Arabic, French and Spanish.** English only, per §9.
- **Any mention of self-harm.** Week 37 links to `mood-after-birth` for what comes after a birth
  and stops there; nothing in the set is crisis-adjacent, so nothing routes to `/en/help-now`.
- **Twins beyond one sentence** in week 37, sourced and pointing at specialist care.

---

## Part 6 — Which weeks a clinician should read first

In order, and this is the list `MANUAL_TEST_PLAN.md` **T25** turns into a checklist:

1. **Week 24** — the viability sentence, and the first week the movement line enters the red-flag
   box. The two hardest paragraphs in the set are both on this page.
2. **Week 40** — that a due date is an estimate, that term is 37–42 weeks, and how the induction
   offer at 41 and 42 weeks is described without steering her either way.
3. **Week 28** — the busiest care week: repeat bloods, anti-D, glucose screening and RSV
   vaccination, three of which differ between the UK and the US. Check the hedging holds.
4. **Week 25 and week 35** — the two pre-eclampsia pages. Week 25 draws the line between ordinary
   evening swelling and the pattern to act on; week 35 draws it between ordinary rib soreness and
   pain below the ribs. Both are places where a reader could take the wrong half.
5. **Week 4** — the only entry with no previous week to link to, and the one most likely to be
   read by a woman who is frightened rather than curious.
6. **Weeks 11, 12 and 18** — the screening pages. Whether "a screening result is a chance, not an
   answer" survives review is the question.

---

## Part 7 — How it reaches the app

`lib/experience/reading.ts` no longer maps `week-by-week` to a slug, because there is no single
answer. It is listed in **`WEEK_AWARE_TOPICS`** and resolved by **`weekArticleSlug(week)`**, and
`articleSlugsFor(foreground, { gestationalWeek })` takes the week from `pregnancyProgress` — the
one function in this codebase that turns an EDD into weeks, so the reading card and the hero
above it can never disagree about how pregnant she is.

The pregnancy dashboard's reading slot now renders `ReadingList` over D1's own
`content.foreground` instead of three hardcoded links. **That was the last live instance of the
write-only shape `docs/23` §3.1 opened the workstream with**, one screen after P2.3c fixed it for
postpartum.

Two boundaries are held by tests, both watched failing before being trusted:

- **Nothing resolves below week 4.** Substituting the week-4 entry would be the invented-window
  defect ADR-041/042 fixed at three other life stages, in content form.
- **Week 40 stands past the due date**, because term runs to 42 weeks (ADR-053) and that entry is
  the one a woman at 41 weeks is looking for.

**Nothing is public.** All 37 are CMS drafts behind the review gate, and `/api/reading` asks the
CMS as an anonymous caller — so each appears on the dashboard the moment the owner approves it,
with no deploy.
