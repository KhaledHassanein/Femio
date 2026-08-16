# Handover — newborn basics, the seed set (B7 approved, P2.13c)

**Status: ready to hand to a separate chat/agent.** Owner decision 2026-08-16: option (b),
**"basic not extensive, supporting the mother, a seed to be scalable later."**

This file is two things: the plan (§1–§4, for us) and **the prompt to paste into the other
chat (§5, verbatim)**. The last instruction in that prompt tells the other agent to finish by
writing a handover prompt back to *this* project, so the consolidation step has what it needs.

---

## 1. What changed, and why it needed a decision

`CLAUDE.md` defines Femio as *"one account for a woman's whole health life"*, and **E2 §E names
full baby tracking as explicitly out of scope** — diapers, sleep, growth curves — in the very
persona that would host newborn content. So this is not a gap being filled; it is the product
definition widening by one step, which is why it was B7 rather than a queue item.

**The approved shape is narrow on purpose.** Not a baby app, not a milestone tracker, not a
growth chart. What is approved is *the mother's newborn questions* — the ones that keep her
awake and that she cannot get answered at 3 a.m. — answered plainly, with the boundary to a
paediatrician or health visitor stated clearly and early.

## 2. The compliance change this brings, and it is real

Everything Femio publishes today is about **an adult woman's own body**. The medical-review
chain (doc 15 §8, the owner's byline) is built on that. Newborn content is advice about **a
second person who is not the account holder**, and a newborn's red flags are different, sharper
and more time-critical than an adult's — a fever in a baby under three months is an emergency
in a way an adult's is not.

Three rules follow, and they are non-negotiable in the prompt:

1. **Every newborn article states, in its own words and in the first screen, that Femio's
   guidance is for the mother and that anything about the baby's health goes to a
   paediatrician, health visitor or emergency service.**
2. **Every newborn article carries a red-flag box**, no exceptions, and the newborn red-flag
   set is its own — not an adaptation of an adult one.
3. **No assessment of a baby, ever.** No "is this normal for your baby", no weight or feed
   adequacy verdict, no sleep or growth judgement, no developmental screening. Femio can
   describe what is usual in a population and can say when to seek care. It cannot say
   anything about *her* baby.

## 3. Scope — eight articles, and what each is for

Deliberately eight rather than thirty. Enough to answer the questions the postpartum experience
already raises, small enough to review in one sitting, and structured so a second wave slots in
without renaming anything.

| # | Working title | Why it is in the seed set |
|---|---|---|
| 1 | **Your newborn in the first two weeks** | The pillar. What is usual — feeding frequency, sleep in short blocks, weight dip and recovery, nappies, cord, skin, jaundice — with every "is this normal" routed to a clinician. |
| 2 | **Feeding your newborn: how often, and how you tell it is going in** | The single most-asked question, and the mother's side of it already exists in `breastfeeding-first-two-weeks`. This is the baby's side: nappies, stool colour, weight checks, cues. **No adequacy verdict.** |
| 3 | **Newborn warning signs** | The one article that must be perfect. Fever under three months, breathing, feeding refusal, floppiness, colour, dehydration, a baby who is hard to wake. Emergency framing throughout. |
| 4 | **Newborn crying, and what helps** | Includes the abusive-head-trauma safety message — that it is safe to put a baby down somewhere safe and step away — which is the highest-value sentence in this set. |
| 5 | **Safer sleep for your baby** | Guidance differs by country, so this describes *what the guidance covers* and points to local advice rather than issuing rules. Cite the sources named in §5. |
| 6 | **Nappies, skin and the cord stump** | The practical article. Low-stakes, high-search, and it takes pressure off the warning-signs page. |
| 7 | **Bottles and formula: preparing and feeding safely** | Preparation and hygiene are the parts that are genuinely safety-critical. No brand names, no volumes as instructions. |
| 8 | **Your baby's first checks and vaccinations** | What is usually offered and when, framed as "in most countries" with the reader pointed at her own schedule. **No schedule presented as Femio's recommendation.** |

**Explicitly not in this wave:** milestones, sleep training, weaning, teething, growth charts,
anything month-by-month. Those are the "scalable later" half, and each is a decision about how
far the product moves rather than a drafting task.

## 4. How it lands back in the app

`lib/experience/reading.ts` maps registry **topics** to article slugs, and every unmapped topic
is listed in `NO_ARTICLE_YET` with a test asserting the two cover the registry. When these land,
the E2 topics `is-baby-getting-enough` and `mastitis-and-blocked-ducts` get homes, and new
newborn topics are added to E1/E2's `content.foreground`. Nothing in the app needs to change
before the content exists — the reading card fills itself in as each article is published.

---

## 5. THE PROMPT — paste everything below this line into the other chat

> You are drafting the **newborn-basics seed set** for **Femio**, a women's-health platform
> (`femioapp.com`). Eight articles, English, Markdown, one file each. This prompt is complete:
> everything you need is here, and where it is not, you must ask rather than invent.
>
> ### 0. Read this first
>
> Femio is a **wellness, education and tracking** product. It never diagnoses, treats, prevents
> disease, or acts as contraception — the moment content claims to, the product falls into
> medical-device regulation, which is an existential problem rather than an editing nit.
>
> Two failure modes matter more than anything you could get right:
> 1. **A confident sentence with no citation.** If you cannot source a claim to a Tier-1 body,
>    **cut it.** Do not soften it, do not write "studies suggest". Cutting is always allowed.
> 2. **Assessing a baby.** This set is the first content Femio has ever published about a
>    person who is not the account holder. You may describe what is usual in a population and
>    when to seek care. You may **never** write anything that reads as a judgement of *her*
>    baby — no "your baby is getting enough", no growth or sleep verdict, no developmental
>    screening, no "this is normal" applied to an individual.
>
> ### 1. The eight articles
>
> Draft all eight. Slugs are fixed — do not rename them.
>
> | # | Title (adjust wording, keep the intent) | Slug |
> |---|---|---|
> | 1 | Your newborn in the first two weeks | `newborn-first-two-weeks` |
> | 2 | Feeding your newborn: how often, and how you know it is going in | `feeding-your-newborn` |
> | 3 | Newborn warning signs | `newborn-warning-signs` |
> | 4 | Newborn crying, and what helps | `newborn-crying` |
> | 5 | Safer sleep for your baby | `safer-sleep-for-your-baby` |
> | 6 | Nappies, skin and the cord stump | `newborn-nappies-skin-and-cord` |
> | 7 | Bottles and formula: preparing and feeding safely | `bottle-and-formula-feeding` |
> | 8 | Your baby's first checks and vaccinations | `newborn-checks-and-vaccinations` |
>
> ### 2. Sourcing (non-negotiable)
>
> - **Tier 1:** WHO, NICE/NHS, CDC, AAP (American Academy of Pediatrics), ACOG, RCPCH,
>   NIH/NICHD, Cochrane, national health services. **Tier 2:** major peer-reviewed journals,
>   respected specialty bodies.
> - **Minimum two independent sources per article, at least one Tier 1.** Record each with
>   title, URL and tier in the front matter, and **check the URL resolves to the document you
>   mean** — a URL that 404s fails the automated check and the draft comes back.
> - **Never cite** blogs, content farms, Wikipedia, competitor apps, news write-ups of studies,
>   or another AI's output. **Every statistic needs a citation next to it.**
> - Where guidance differs between countries — safer sleep and vaccination schedules especially
>   — **say so plainly and cite both.** Faking consensus is worse than describing the split.
>
> ### 3. Forbidden language
>
> Never write, about **Femio or its content**: diagnose / diagnosis, treat / cure / therapy (as
> something Femio offers), prevent / prevention (of disease), contraception / birth control (as
> a Femio function). Describing clinical care in the world is fine — *"a clinician may
> suggest…"*, *"NICE's guidance recommends…"* — as long as the actor is a clinician or a
> guideline body, never Femio and never her tracking data.
>
> Also banned: **any dose, volume or regimen** (no millilitres of formula as an instruction, no
> paracetamol doses, no "how much"); **any triage** ("this is probably nothing", "this is
> serious"); **any prognosis about an individual**; **any phone number anywhere** — Femio's
> crisis and emergency routing is deliberately global ("contact your local emergency services
> or go to your nearest emergency department") because a wrong or stale number is a safety
> failure across the many countries Femio serves.
>
> Avoid the decorative phrase "medically reviewed" / "medical information" — Femio says
> "clinician reviewed" and "health information". But **keep the boundary sentences verbatim**:
> "not medical advice", "seek urgent medical care". Reducing medical *framing* while keeping
> the medical *boundary* is the whole posture.
>
> ### 4. The page contract
>
> 1. **One H1** — the question in a mother's words.
> 2. **Answer-first opening: 2–4 sentences**, immediately after the H1, no heading between
>    them. Someone who reads only this must leave better informed. **State the boundary here**
>    — that this is health information for learning, and that anything about her baby's health
>    goes to a paediatrician, health visitor or emergency service.
> 3. **Body sections** (H2/H3), short paragraphs of 2–4 sentences.
> 4. **A required H2 reading exactly `## When to see a doctor`** — the string is checked
>    mechanically, so do not reword it.
> 5. **A red-flag box on every article in this set.** Format: a blockquote beginning
>    `**Seek care now:**`, listing the specific signs. The newborn set is its own — a fever in
>    a baby under three months, laboured or fast breathing, grunting, blue or very pale colour,
>    floppiness, difficulty waking, refusing feeds, far fewer wet nappies, a bulging or sunken
>    soft spot, a rash that does not fade under pressure, a fit.
> 6. **3–6 internal links**, all listed in an `internal_links` front-matter array, and every
>    Femio link in the prose must also appear in that array.
> 7. **Reading level grade 6–8.** Short sentences. Define every clinical term in plain words on
>    first use — "jaundice (yellow skin or eyes)".
> 8. **Length 700–1,200 words**, except article 1 (the pillar) at 1,200–1,800. Never pad.
>
> ### 5. Internal links you may use
>
> Only these routes exist. Linking to anything else fails the check.
>
> `/en/learn` · `/en/conditions` · `/en/glossary` · `/en/faq` · `/en/about` ·
> `/en/editorial-policy` · `/en/medical-review` · `/en/authors` · `/en/help-now` ·
> `/en/calculators` and its five tools (`due-date`, `fertile-window`, `gestational-age`, `bmi`,
> `cycle-length`)
>
> Plus these **existing articles**, by `/en/learn/<slug>` — link generously to them, since this
> set exists to sit alongside them:
> `postpartum-recovery-first-six-weeks` · `postpartum-warning-signs` · `bleeding-after-birth` ·
> `postpartum-wound-healing` · `afterpains-after-birth` · `pelvic-floor-after-birth` ·
> `mood-after-birth` · `sleep-and-exhaustion-after-birth` · `breastfeeding-first-two-weeks` ·
> `when-breastfeeding-is-not-working` · `periods-after-birth` · `contraception-after-birth` ·
> `six-week-postnatal-check` · `sex-after-birth` · `pregnancy-basics` ·
> `pregnancy-warning-signs`
>
> And the other seven slugs in this set.
>
> ### 6. Safety routing
>
> Anything touching self-harm, harming the baby, abuse or domestic violence **must** link to
> `/en/help-now` and must contain **no phone number of any kind**. Article 4 (crying) must carry
> the message that it is safe to put a baby down somewhere safe and step away when a carer feels
> overwhelmed, and must route to `/en/help-now`. Never sensationalise, never imply she is
> dangerous, never reassure in place of routing.
>
> ### 7. Front matter — exact schema, do not rename or omit keys
>
> Copy this shape exactly. Values are **double-quoted strings**; only `null`, `true` and `false`
> are bare. No single quotes, no block scalars, no tabs, no embedded double quotes.
>
> ```yaml
> ---
> title: "Your Newborn in the First Two Weeks"
> slug: "newborn-first-two-weeks"
> locale: "en"
> status: "draft"
> content_type: "newborn cluster"
> search_intent: "newborn care expectations"
> primary_query: "newborn first two weeks"
> secondary_topics:
>   - "what newborns do"
>   - "newborn sleep and feeding patterns"
> excerpt: "One or two plain sentences describing the page."
> meta_title: "…"            # 30–60 characters, unique across the whole set
> meta_description: "…"      # 120–160 characters, unique across the whole set
> canonical_url: "https://femioapp.com/en/learn/newborn-first-two-weeks"
> robots_while_draft: "noindex,nofollow"
> robots_when_published: "index,follow,max-image-preview:large"
> open_graph_title: "…"
> open_graph_description: "…"
> open_graph_image: "PENDING"
> open_graph_image_alt: "…"
> written_by: "PENDING"
> medically_reviewed_by: "PENDING"
> date_published: null
> date_modified: null
> last_reviewed: null
> next_review_due: null
> reading_level_ok: true
> reading_level_method: "Approximate Flesch-Kincaid grade 7.0, checked 2026-08-16"
> disclaimer_type: "emergency"
> structured_data_required:
>   - "Article"
>   - "MedicalWebPage"
>   - "BreadcrumbList"
>   - "FAQPage"
> sources:
>   - title: "NHS: Your baby's health and development reviews"
>     url: "https://www.nhs.uk/…"
>     tier: "1"
>   - title: "…"
>     url: "https://…"
>     tier: "1"
> internal_links:
>   - "/en/learn/newborn-warning-signs"
>   - "/en/learn/breastfeeding-first-two-weeks"
>   - "/en/help-now"
> ---
> ```
>
> **The four mechanical failures that come back most often**, in order: `meta_title` outside
> 30–60 characters; `meta_description` outside 120–160; an opening paragraph that is one
> sentence or six rather than 2–4; and a link in the prose that is not listed in
> `internal_links`. Count them before you hand over.
>
> `disclaimer_type` is one of `general` | `screening` | `emergency` | `none`. For this set it is
> `emergency` on every article, because every one of them can be the page she is reading when
> something is actually wrong.
>
> ### 8. What you must not do
>
> - Do not publish, or set any status other than `draft`. Publication is a clinician's decision
>   behind a review gate.
> - **Do not invent** authors, reviewers, credentials, dates, statistics, sources or URLs.
> - Do not copy text from any source. Summarise in your own words and cite.
> - Do not write Arabic, French or Spanish versions. Translation is a separate reviewed process.
> - Do not produce anything month-by-month, milestone-based, or growth-charted. That is
>   deliberately out of this wave.
>
> ### 9. Deliverable, and how to hand it back
>
> Produce the eight Markdown files, plus a short **batch note** saying: what you wrote, **what
> you deliberately cut for lack of a source**, where guidance differed between countries and how
> you handled it, and anything you think a clinician must decide.
>
> **Then, as your final output, write a handover prompt addressed back to the Femio project
> agent.** It must contain: the file list with slugs; every source you used with its tier; the
> exact points you want re-checked; anything you could not source and left out; and any place
> you were unsure whether a sentence crossed the "no assessment of a baby" line. Write it to be
> pasted whole into a fresh chat, and assume the receiving agent has this file but not your
> conversation.

---

## 6. What happens on this side when it comes back

1. Files land in `docs/content/articles/`. Run `pnpm content-lint` and `pnpm content-lint:urls`
   — both must be clean before anything else.
2. Read every red-flag box against the newborn set in §5 of the prompt, and read every sentence
   about the baby for the assessment line.
3. Add the new topics to the Track E `content.foreground` lists and map them in
   `lib/experience/reading.ts`; `reading.test.ts` will fail until every topic is accounted for.
4. `pnpm content-import -- --apply` writes them as drafts. **The owner approves each in the CMS**
   — nothing is public otherwise, and the reading card fills itself in as he publishes.
5. Raise the review-posture question with him once, in `BLOCKERS.md`: doc 15 §8's reviewer
   statement is written for adult content, and eight pages about infants may want its own line.
