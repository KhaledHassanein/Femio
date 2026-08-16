# Handover — pregnancy week by week, weeks 4–40 (B9 answered, P2.2.2)

**Status: ready to hand to a separate chat/agent.** Owner decision 2026-08-16: option **(b),
forty week entries**, and *"no need for me to review [the title list] — create a prompt for a
chat to get the data and consolidate it with references."* Requested content, verbatim in
substance: **the mother, her body, tips for her this week, and the fetus — with the fun that
pregnancy apps have** (size comparisons, development news).

This file is the plan (§1–§3) and **the prompt to paste into the other chat (§4, verbatim)**.
The last instruction in that prompt tells the other agent to finish by writing a handover prompt
back to this project.

---

## 1. What is being asked for, and the one line it must not cross

Every pregnancy app on the market ships this, and it is the most-used surface any of them has.
Femio has foregrounded a `week-by-week` topic since R2.1 and rendered nothing behind it.

The owner asked for the fun explicitly, and the fun is not the risk. **The risk is one specific
sentence: any size or development detail that reads as a measurement of *her* baby.** "At 20
weeks a baby is often around the length of a banana" is a population illustration. "Your baby is
the size of a banana" is a statement about an individual pregnancy, and once it is on the page a
woman whose scan measured small has been handed a verdict by a phone. The prompt below makes
that distinction load-bearing rather than stylistic, because it is the difference between a
charming feature and a claim.

Everything else is ordinary: sourced, plain, grade 6–8, no doses, red-flag box wherever a
symptom can be an emergency.

## 2. Shape

**Weeks 4–40, one article each, 37 files.** Weeks 1–3 are deliberately absent: dating counts
from the last period, so "week 1" is before conception and an entry for it teaches the wrong
thing. Week 40+ is folded into the week-40 entry, which covers going past the due date — the
term band already draws 37–42 weeks (ADR-053) and the content should agree with it.

Each entry answers four things in the same order, every time, so the set reads as one thing
rather than 37:

1. **Your body this week** — what is usually happening to her, physically.
2. **What you may notice** — symptoms, named plainly, with the ones that need care split out.
3. **Your baby this week** — development, with the size illustration, population-framed.
4. **This week's tip** — one practical, specific, doable thing. Not "stay hydrated".

Plus care context where it is real: the weeks that usually carry a scan, a screening offer, a
vaccination, or a decision to prepare for.

## 3. How it lands back in the app

`lib/experience/reading.ts` maps registry topics to slugs and `NO_ARTICLE_YET` lists what has no
article; `week-by-week` is on that list today. When these land, D1's `week-by-week` topic maps
to the entry for her current gestational age — which is the first time the reading card becomes
*week-aware* rather than static, and the reason the slugs below are strictly predictable
(`pregnancy-week-14`, computable from `pregnancyProgress`).

---

## 4. THE PROMPT — paste everything below this line into the other chat

> You are drafting the **pregnancy week-by-week set** for **Femio**, a women's-health platform
> (`femioapp.com`). **37 articles, weeks 4 to 40, one Markdown file each**, English. This prompt
> is complete; where it is not, ask rather than invent.
>
> ### 0. The two things that matter more than anything else
>
> **1. A confident sentence with no citation is the worst thing you can produce.** If you cannot
> source a claim to a Tier-1 body, cut it. Do not soften it, do not write "studies suggest".
>
> **2. Nothing may read as a measurement of *her* baby.** This is the rule the whole set turns
> on. You are writing the fun that pregnancy apps have — size comparisons, development news —
> and it is welcome. But it must always be **population-framed and hedged**:
>
> - ✅ "Around this week, babies are often about the length of a lemon."
> - ✅ "Most babies weigh roughly … by now, and the range is wide."
> - ❌ "Your baby is the size of a lemon."
> - ❌ "Your baby now weighs …"
> - ❌ Anything a woman whose scan measured small or large could read as a verdict.
>
> Femio is a **wellness, education and tracking** product. It never diagnoses, treats or
> prevents. A size comparison is an illustration; the moment it becomes a statement about an
> individual pregnancy it is a measurement, and Femio does not make measurements.
>
> ### 1. The files
>
> One file per week, weeks 4–40. Slugs are fixed and must be exact — the app computes them from
> gestational age:
>
> `pregnancy-week-4` … `pregnancy-week-40` (`pregnancy-week-4`, `pregnancy-week-5`, … no
> zero-padding, no ranges, no "weeks-4-5").
>
> Titles: **"Week N of Pregnancy: What to Expect"** or a close variant. Keep "Week N" first.
>
> **Deliver in batches by trimester** so review can start early: weeks 4–13, then 14–27, then
> 28–40.
>
> ### 2. The shape of every entry — same four sections, same order
>
> After the H1 and a 2–4 sentence answer-first opening:
>
> 1. `## Your body this week` — what is usually happening to her. Hers, not the baby's.
> 2. `## What you may notice` — common symptoms this week in plain words, and which ones need
>    care today rather than at the next appointment.
> 3. `## Your baby this week` — development, and the size illustration. Population-framed, per
>    §0.2. Give the illustration a source for the underlying measurement, or leave the number
>    out and keep only the comparison.
> 4. `## This week's tip` — **one** specific, doable thing. "Book your next appointment before
>    you leave this one" is a tip; "eat well and rest" is filler. No supplements by dose, ever.
> 5. `## When to see a doctor` — **this exact heading string**, it is checked mechanically.
>
> Then, where the week genuinely has one, a `## What care usually happens around now` section —
> the dating scan, the anomaly scan, screening offers, glucose testing, vaccinations, anti-D,
> growth monitoring, birth preparation. Attribute to a guideline body and say that schedules
> differ between countries. **Do not invent a schedule and do not present one as Femio's.**
>
> ### 3. Red flags
>
> **Every entry from week 4 onward carries a red-flag box.** Format: a blockquote beginning
> `**Seek care now:**`. Set `disclaimer_type: "emergency"` on every file.
>
> The pregnancy red-flag set: heavy bleeding, severe abdominal pain, severe headache with vision
> changes, sudden swelling of face or hands, fever, fluid leaking, chest pain, trouble breathing,
> fainting, seizure, and — **from the week movement is established onwards** — any reduction from
> her baby's usual movement pattern. Never give a movement count as a threshold; the rule is
> *change from her own usual*, and it is checked by contacting maternity services, never by an
> app.
>
> **No phone numbers, anywhere, in any file.** Femio's routing is deliberately global — "contact
> your local emergency services or go to your nearest emergency department" — because a wrong or
> stale number across the many countries Femio serves is itself a safety failure. Anything
> touching self-harm or abuse links to `/en/help-now` and carries no number.
>
> ### 4. Sourcing
>
> - **Tier 1:** WHO, NICE/NHS, CDC, ACOG, RCOG, NIH/NICHD, Cochrane, national health services.
>   **Tier 2:** major peer-reviewed journals, respected specialty bodies.
> - **Two independent sources minimum per file, at least one Tier 1**, recorded with title, URL
>   and tier in the front matter. **Check every URL resolves** — a 404 fails the automated
>   check and the batch comes back.
> - Reusing a source across many weeks is fine and expected. Fetal-development detail should
>   lean on NICHD/NHS/ACOG development pages rather than app blogs, which is where most
>   week-by-week content on the internet actually comes from. **Never cite** blogs, content
>   farms, Wikipedia, competitor apps, or another AI's output.
> - **Every statistic needs a citation next to it.** If sources disagree on a figure, say so and
>   cite both, or cut it.
>
> ### 5. Forbidden language
>
> Never write, about **Femio or its content**: diagnose / diagnosis, treat / cure / therapy (as
> something Femio offers), prevent / prevention (of disease), contraception / birth control (as
> a Femio function). Describing clinical care is fine when the actor is a clinician or a
> guideline body — *"NICE's guidance recommends…"* — never Femio and never her tracking data.
>
> Also banned: **any dose or regimen** (name a supplement class if a guideline does, never an
> amount); **any triage** ("this is probably nothing"); **any prognosis about an individual**;
> **any due-date certainty** — Femio's whole posture is that a due date is an estimate and term
> is a five-week range (37–42 weeks), so never write anything that treats the due date as a
> finish line. Avoid "medically reviewed" / "medical information" as decoration; keep boundary
> phrases such as "not medical advice" and "seek urgent medical care" verbatim.
>
> ### 6. Reading level, length, uniqueness
>
> Grade 6–8. Short sentences, clinical terms defined in plain words on first use. **600–900
> words per entry** — these are short by design, and 37 padded pages is worse than 37 tight
> ones.
>
> **Uniqueness is the hard part of a set this size**, and it is checked mechanically across all
> 37 files *and* against Femio's existing articles: `meta_title` (30–60 characters),
> `meta_description` (120–160 characters), `slug` and `primary_query` must each be unique.
> `primary_query` is naturally distinct — "14 weeks pregnant", "15 weeks pregnant" — but the
> descriptions will collide unless you write each one about that week specifically. Do not
> template them.
>
> ### 7. Internal links
>
> 3–6 per file, all listed in `internal_links`, and every Femio link in the prose must also be
> in that array. Only these routes exist:
>
> `/en/learn` · `/en/conditions` · `/en/glossary` · `/en/faq` · `/en/about` ·
> `/en/editorial-policy` · `/en/medical-review` · `/en/authors` · `/en/help-now` ·
> `/en/calculators` and its five tools (`due-date`, `fertile-window`, `gestational-age`, `bmi`,
> `cycle-length`)
>
> Existing articles, by `/en/learn/<slug>`: `pregnancy-basics` · `pregnancy-warning-signs` ·
> `early-pregnancy-changes` · `first-pregnancy-appointment` · `when-to-take-pregnancy-test` ·
> `preconception-appointment` · `postpartum-recovery-first-six-weeks` · `postpartum-warning-signs`
> · `breastfeeding-first-two-weeks` · `mood-after-birth`
>
> Plus the adjacent weeks in this set — **every entry should link to the week before and the
> week after**, which is what makes 37 pages a set rather than a pile. Link every entry to
> `/en/learn/pregnancy-warning-signs` and to `/en/calculators/gestational-age`.
>
> ### 8. Front matter — exact schema, do not rename or omit keys
>
> Double-quoted strings; only `null`, `true`, `false` bare. No single quotes, block scalars,
> tabs, or embedded double quotes.
>
> ```yaml
> ---
> title: "Week 14 of Pregnancy: What to Expect"
> slug: "pregnancy-week-14"
> locale: "en"
> status: "draft"
> content_type: "pregnancy week"
> search_intent: "week-by-week pregnancy expectations"
> primary_query: "14 weeks pregnant"
> secondary_topics:
>   - "second trimester start"
>   - "14 week symptoms"
> excerpt: "One or two plain sentences about this week."
> meta_title: "…"            # 30–60 chars, unique across all 37 and the existing set
> meta_description: "…"      # 120–160 chars, unique, written about this week specifically
> canonical_url: "https://femioapp.com/en/learn/pregnancy-week-14"
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
>   - title: "NHS: You and your baby at 14 weeks pregnant"
>     url: "https://www.nhs.uk/…"
>     tier: "1"
>   - title: "…"
>     url: "https://…"
>     tier: "1"
> internal_links:
>   - "/en/learn/pregnancy-week-13"
>   - "/en/learn/pregnancy-week-15"
>   - "/en/learn/pregnancy-warning-signs"
>   - "/en/calculators/gestational-age"
> ---
> ```
>
> **The failures that come back most often**, in order: `meta_title` outside 30–60 characters;
> `meta_description` outside 120–160; templated descriptions that collide across weeks; an
> opening paragraph that is one sentence or six rather than 2–4; and a link in the prose that is
> not listed in `internal_links`. Check all five before handing over each batch.
>
> ### 9. What you must not do
>
> - Do not publish or set any status other than `draft`.
> - **Do not invent** authors, reviewers, credentials, dates, statistics, sources or URLs.
> - Do not copy text from any source; summarise and cite.
> - Do not write Arabic, French or Spanish versions.
> - Do not produce a fetal weight or length as a statement about the reader's baby (§0.2).
> - Do not treat the due date as a deadline, and do not imply a baby is "late" before 42 weeks.
>
> ### 10. Deliverable, and how to hand it back
>
> Three batches (4–13, 14–27, 28–40). With each batch, a short note: what you wrote, **what you
> cut for lack of a source**, where guidance differed between countries and how you handled it,
> and which weeks you think a clinician must read first.
>
> **Then, as your final output, write a handover prompt addressed back to the Femio project
> agent.** It must contain: the file list with slugs; every source used, with tier; the size
> comparisons you chose and the source behind each measurement; every place you were unsure
> whether a sentence crossed the "measurement of her baby" line; and anything you left out.
> Write it to be pasted whole into a fresh chat, and assume the receiving agent has this file
> but not your conversation.

---

## 5. What happens on this side when it comes back

1. `pnpm content-lint` and `pnpm content-lint:urls` — clean before anything else. With 37 files
   the uniqueness and metadata-length rules will do most of the work.
2. Read the "Your baby this week" section of **every** file against §0.2. That is the review
   this set actually needs; the rest is mechanical.
3. Check the week-40 entry agrees with ADR-053 — term is 37–42 weeks and the band never fills
   toward the EDD.
4. Map `week-by-week` in `lib/experience/reading.ts` to the entry for her current gestational
   age, which is the first week-aware thing the reading card does. `pregnancyProgress` already
   computes the number.
5. `pnpm content-import -- --apply` writes them as drafts; **the owner approves in the CMS**, and
   the reading card fills in as he publishes. He has said he does not need to approve the title
   list, but publication is still his gate — that is ADR-032 and it does not move.
