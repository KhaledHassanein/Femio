# Handover — the teen set, ten articles (B8 approved, P2.13)

**Status: ready to hand to a separate chat/agent.** Owner approved the ten titles unchanged on
2026-08-16 with no cuts.

Plan in §1–§3; **the prompt to paste into the other chat is §4, verbatim.** Its last instruction
tells that agent to finish by writing a handover prompt back to this project.

---

## 1. Why this set is not "period articles for younger readers"

Track A has had a mode since R2.5c and **two modules with no article behind them** —
`teen.body` and `teen.readiness` sit in `UNIMPLEMENTED`, so the gap is counted. But the harder
part is what the A-track specs forbid, and it is specific:

- **A2 §D: no condition is named as a possibility.** PCOS should generally not be raised within
  two to three years of menarche because irregular cycles are developmentally expected that
  early, and putting the word in front of a thirteen-year-old — even as a "could this be?" —
  plants a label a clinician would not. `pcos` is deliberately absent from the teen triage for
  the same reason; the content must not reintroduce it.
- **A2 §B is the question the set exists to answer:** *"it said Tuesday and it didn't — is the
  app broken or am I broken?"* One of the ten is written specifically for that.
- **A1 is not cycling yet.** She has not had a first period, so nothing may predict one. A1
  contributes no window in the registry for exactly this reason (ADR-041/042), and the content
  must match the product: no "your period is due", no countdown.
- **Teen mode gates ads, social and data — never knowledge** (product rule 2). Nothing in this
  set may read as withheld, and every article stays reachable from the library.

## 2. The ten, with fixed slugs

| # | Title | Slug | Registry topic it answers |
|---|---|---|---|
| 1 | What's changing in my body | `whats-changing-in-my-body` | `whats-changing` (A1) |
| 2 | What is a period? | `what-is-a-period` | `what-is-a-period` (A1) |
| 3 | Getting ready for your first period | `getting-ready-for-your-first-period` | `first-period-plan` (A1) |
| 4 | Period myths, checked | `period-myths-checked` | `myth-busting` (A1) |
| 5 | Is my period normal? | `is-my-period-normal` | `youre-normal` (A2) |
| 6 | Period products, and how to choose | `choosing-period-products` | `using-period-products` (A2) |
| 7 | Period pain: what helps, and when it is too much | `period-pain-in-teens` | — (new) |
| 8 | A period at school | `period-at-school` | `school-day` (A2) |
| 9 | Tracking your cycle without stress | `tracking-your-cycle-as-a-teen` | `tracking-without-stress` (A2) |
| 10 | When to tell an adult, and when to see a doctor | `when-to-tell-an-adult` | — (new) |

A2's tenth topic, `menstrual-cycle-basics`, already maps to the existing adult article of the
same name; article 2 is the version written for someone who has not had a period yet, which is
why both exist.

## 3. How it lands back

`lib/experience/reading.ts` maps topics → slugs and lists every unmapped topic in
`NO_ARTICLE_YET`, asserted by `reading.test.ts`. All eight A-track topics above are on that list
today and come off it when these land. Two new slugs (7 and 10) want new topics added to A2's
`content.foreground`. Then `pnpm content-import -- --apply`, and the reading card fills in as the
owner publishes each in the CMS.

---

## 4. THE PROMPT — paste everything below this line into the other chat

> You are drafting the **teen set** for **Femio**, a women's-health platform (`femioapp.com`).
> **Ten articles, English, Markdown, one file each.** Readers are roughly **9 to 17** — some have
> never had a period, some have had them for years. This prompt is complete; where it is not, ask
> rather than invent.
>
> ### 0. The four things this set gets wrong if you are not careful
>
> **1. Never name a condition as a possibility.** Do not write "this could be PCOS", "signs of
> endometriosis", or any equivalent — not even hedged, not even in an FAQ. Irregular cycles in
> the first two to three years after a first period are **developmentally expected**, and
> clinical guidance is explicit that a diagnosis should generally not be made in that window.
> Putting the word in front of a thirteen-year-old plants a label a clinician would not. You may
> say *"if X is happening, that is worth showing to a doctor"* — the symptom and the route, never
> the name of the thing it might be.
>
> **2. Never predict a first period.** Articles 1–4 are for readers who have not started yet.
> Nothing may say when hers will come. Ranges for the population are fine and sourced; a
> prediction for her is not.
>
> **3. Nothing is withheld, and nothing reads as withheld.** Every article is written plainly and
> completely for the age it serves. Never write "ask your mum" *instead of* an answer — answer,
> and then say a trusted adult or a doctor can help with the next step.
>
> **4. No numbers that invite comparison about bodies.** No weights, no BMI, no calorie targets,
> no "average" breast development stage presented as a target. Puberty ranges are wide; say so.
>
> Femio is a **wellness, education and tracking** product. It never diagnoses, treats or prevents.
> A confident sentence with no citation is the worst thing you can produce here — if you cannot
> source a claim to a Tier-1 body, **cut it**.
>
> ### 1. The ten files
>
> Slugs are fixed. Do not rename them.
>
> | # | Title (adjust wording, keep the intent) | Slug |
> |---|---|---|
> | 1 | What's changing in my body | `whats-changing-in-my-body` |
> | 2 | What is a period? | `what-is-a-period` |
> | 3 | Getting ready for your first period | `getting-ready-for-your-first-period` |
> | 4 | Period myths, checked | `period-myths-checked` |
> | 5 | Is my period normal? | `is-my-period-normal` |
> | 6 | Period products, and how to choose | `choosing-period-products` |
> | 7 | Period pain: what helps, and when it is too much | `period-pain-in-teens` |
> | 8 | A period at school | `period-at-school` |
> | 9 | Tracking your cycle without stress | `tracking-your-cycle-as-a-teen` |
> | 10 | When to tell an adult, and when to see a doctor | `when-to-tell-an-adult` |
>
> **What each is for**, briefly. **1** — puberty in the order it usually happens, with wide
> ranges, written for someone who has noticed something changing. **2** — what a period actually
> is, for someone who has not had one; anatomy named plainly, never coyly. **3** — the practical
> plan: what to carry, where to keep it, who to tell, what to do if it starts at school. **4** —
> myths checked against sources: swimming, washing, exercise, "how much blood is that really",
> whether it hurts to use a tampon. **5** — **the most important one**: the first two to three
> years are irregular by design, and this article answers the reader who is asking *"the app said
> Tuesday and it didn't — is the app broken or am I broken?"* **6** — pads, tampons, cups, period
> underwear, described honestly with no recommendation and no brand. **7** — what helps with
> cramps, and the line at which pain that stops her going to school is worth a doctor. **8** —
> leaks, PE, asking to leave a lesson, what to keep in a bag. **9** — why an app shows a wide
> window at her age and why that is honest rather than broken. **10** — when to tell a trusted
> adult, and the specific things worth seeing a doctor about, including **no periods by around 15,
> or none within about three years of breasts starting to develop**, and **no signs of puberty by
> around 13** — framed as *"let's ask a doctor together"*, never as alarm.
>
> ### 2. Voice
>
> **Reading level grade 5–7** — lower than the rest of Femio's library. Short sentences. Second
> person. Warm, matter-of-fact, never coy about anatomy and never babyish. Name body parts
> correctly and define them once in plain words: "vulva (the outside parts)", "uterus (womb)".
>
> No jokes about periods being gross. No "you're a woman now". No emoji. Do not assume she has a
> supportive adult at home, money for products, or a private bathroom — write so it is useful
> either way.
>
> ### 3. Sourcing
>
> - **Tier 1:** WHO, NICE/NHS, CDC, ACOG, RCOG, NIH/NICHD, AAP, national health services.
>   **Tier 2:** major peer-reviewed journals, respected specialty bodies.
> - **Two independent sources minimum per file, at least one Tier 1**, recorded with title, URL
>   and tier in the front matter. **Check every URL resolves** — a 404 fails the automated check.
> - **Never cite** blogs, content farms, Wikipedia, competitor apps, period-product brands, or
>   another AI's output. **Every statistic needs a citation next to it.**
> - Where guidance differs between countries — tampon and cup advice for young teens especially —
>   say so and cite both rather than picking one.
>
> ### 4. Forbidden language
>
> Never write, about **Femio or its content**: diagnose / diagnosis, treat / cure / therapy (as
> something Femio offers), prevent / prevention (of disease), contraception / birth control (as a
> Femio function). Describing clinical care is fine when the actor is a clinician or a guideline
> body. Also banned: **any dose** (you may say a doctor or pharmacist can advise on pain relief;
> never an amount), **any triage**, **any prognosis about an individual**, and **any phone number
> anywhere** — Femio's routing is deliberately global because a wrong or stale number across many
> countries is itself a safety failure.
>
> ### 5. Safety and safeguarding
>
> Anything touching self-harm, abuse, or someone making her uncomfortable **must** link to
> `/en/help-now` and carry no phone number. Article 10 must include, plainly: if something is
> happening to her body that someone else is causing, or she does not feel safe telling anyone at
> home, there are adults outside the home — a school nurse, a teacher, a doctor — whose job this
> is. Say it once, calmly, without dramatising.
>
> Set `disclaimer_type: "emergency"` and include a red-flag box on articles **5, 7 and 10**
> (bleeding through protection every hour or two, fainting, pain that stops her functioning,
> severe pain with a tampon in, or feeling unsafe). Elsewhere use `"general"`.
>
> ### 6. The page contract
>
> 1. **One H1**, in her words.
> 2. **Answer-first opening, 2–4 sentences**, immediately after the H1, no heading between them.
>    State within it that this is health information for learning and that a doctor or a trusted
>    adult can help with anything worrying.
> 3. Body sections (H2/H3), paragraphs of 2–4 sentences.
> 4. **A required H2 reading exactly `## When to see a doctor`** — checked mechanically, do not
>    reword. In this set, phrase what follows as "you or a trusted adult can…".
> 5. Red-flag box where required (§5): a blockquote beginning `**Seek care now:**`.
> 6. **3–6 internal links**, all listed in `internal_links`; every Femio link in the prose must
>    also be in that array.
> 7. **500–900 words.** These are short by design.
>
> ### 7. Internal links available
>
> `/en/learn` · `/en/conditions` · `/en/glossary` · `/en/faq` · `/en/about` ·
> `/en/editorial-policy` · `/en/medical-review` · `/en/authors` · `/en/help-now` ·
> `/en/calculators` and its five tools (`due-date`, `fertile-window`, `gestational-age`, `bmi`,
> `cycle-length`)
>
> Existing articles by `/en/learn/<slug>`: `menstrual-cycle-basics` · `how-to-track-menstrual-cycle`
> · `painful-periods` · `heavy-periods` · `period-pain-care-options` ·
> `heavy-periods-iron-deficiency-anaemia` — link to these where a reader wants more depth, and say
> plainly that they are written for adults. Plus the other nine slugs in this set.
>
> **Do not link to** `/en/conditions/pcos` or any condition page from this set. §0.1.
>
> ### 8. Front matter — exact schema, do not rename or omit keys
>
> Double-quoted strings; only `null`, `true`, `false` bare. No single quotes, block scalars, tabs,
> or embedded double quotes.
>
> ```yaml
> ---
> title: "Is My Period Normal?"
> slug: "is-my-period-normal"
> locale: "en"
> status: "draft"
> content_type: "teen cluster"
> search_intent: "teen cycle reassurance"
> primary_query: "is my period normal teenager"
> secondary_topics:
>   - "irregular periods in teens"
>   - "how long periods take to settle"
> excerpt: "One or two plain sentences describing the page."
> meta_title: "…"            # 30–60 characters, unique across the whole set
> meta_description: "…"      # 120–160 characters, unique across the whole set
> canonical_url: "https://femioapp.com/en/learn/is-my-period-normal"
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
> reading_level_method: "Approximate Flesch-Kincaid grade 6.0, checked 2026-08-16"
> disclaimer_type: "emergency"
> structured_data_required:
>   - "Article"
>   - "MedicalWebPage"
>   - "BreadcrumbList"
>   - "FAQPage"
> sources:
>   - title: "NHS: Periods and puberty"
>     url: "https://www.nhs.uk/…"
>     tier: "1"
>   - title: "…"
>     url: "https://…"
>     tier: "1"
> internal_links:
>   - "/en/learn/what-is-a-period"
>   - "/en/learn/tracking-your-cycle-as-a-teen"
>   - "/en/learn/when-to-tell-an-adult"
> ---
> ```
>
> **The four mechanical failures that come back most often:** `meta_title` outside 30–60
> characters; `meta_description` outside 120–160; an opening paragraph that is one sentence or six
> rather than 2–4; a prose link not listed in `internal_links`. Count them before handing over.
>
> ### 9. What you must not do
>
> - Do not publish, or set any status other than `draft`.
> - **Do not invent** authors, reviewers, credentials, dates, statistics, sources or URLs.
> - Do not copy text from any source; summarise and cite.
> - Do not write Arabic, French or Spanish versions.
> - Do not name a condition as a possibility, anywhere, in any file (§0.1).
>
> ### 10. Deliverable, and how to hand it back
>
> The ten Markdown files, plus a short note: what you wrote, **what you cut for lack of a
> source**, where guidance differed between countries, and anything a clinician must decide.
>
> **Then, as your final output, write a handover prompt addressed back to the Femio project
> agent.** It must contain: the file list with slugs; every source used, with tier; every place
> you came close to naming a condition and how you phrased it instead; anything you left out; and
> the sentences you are least sure about for a young reader. Write it to be pasted whole into a
> fresh chat, and assume the receiving agent has this file but not your conversation.

---

## 5. What happens on this side when it comes back

1. `pnpm content-lint` and `pnpm content-lint:urls` — clean first.
2. **Read every file for §0.1.** A condition named as a possibility is the one failure that is
   invisible to the guard and expensive in this audience.
3. Check nothing predicts a first period, and that articles 1–4 work for a reader who has not
   started.
4. Map the eight A-track topics in `lib/experience/reading.ts`; add topics for slugs 7 and 10 to
   A2's `content.foreground`. `reading.test.ts` fails until every topic is accounted for.
5. Import as drafts. **The owner approves each in the CMS** — publication is his gate (ADR-032),
   and the teen dashboard's reading card fills itself in as he publishes.
