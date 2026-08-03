# Femio — authoring brief for the content assistant (P1.9)

Audience: an AI assistant (Codex/GPT) commissioned to draft Femio's first 60 English
health articles and their SEO. Written to be pasted whole as the working prompt.

Status: active brief · Owner: Khaled · Reviewer of the output: Claude Code, then a
qualified clinician in the CMS · Ties to `docs/15` (editorial policy), `docs/16`
(library IA), `docs/13` (legal), `docs/content/CMS_SEO_PUBLISHING_RECOMMENDATIONS.md`

---

## 0. Read this first, and take it literally

You are drafting **YMYL health content for women** that will be read by people making
real decisions about their bodies. Two failure modes matter more than anything else you
could get right:

1. **Saying something that isn't true, or isn't sourced.** A confident sentence with no
   citation behind it is the worst thing you can produce here. If you cannot source a
   claim to a Tier-1/2 body, **cut the claim** — do not soften it, do not hedge it, do
   not write "studies suggest". Cutting is always allowed and never a failure.
2. **Writing a sentence that turns Femio into a medical device.** Femio is a wellness,
   education and tracking product. The moment content claims to diagnose, treat, prevent
   or cure — or to act as contraception — the product falls into FDA SaMD / EU MDR scope,
   which is an existential regulatory problem, not an editing nit. §2 tells you exactly
   which words are forbidden and what to write instead.

Everything else in this brief serves those two rules.

---

## 1. What Femio is (context you need to write well)

Femio is a web-first women's-health platform: **one account for a woman's whole health
life** — puberty → cycles → conditions → trying to conceive/IVF → pregnancy → postpartum
→ perimenopause → menopause. It is live at `femioapp.com`, in English, Arabic, French and
Spanish, with Arabic right-to-left as a first-class experience.

It has two halves:
- a **public content library** (what you are writing) — free, no login, the SEO engine;
- a **private tracker** (cycle logging, symptoms, honest predictions, doctor-visit
  summary) that a reader can enter from the library.

Its differentiator is **trustworthiness**, in a category with a reputational wound (the
Flo FTC settlement, the Premom action, the Glow breach). Referenced content and verifiable
privacy are the product, not the marketing. Write like that is true, because it is.

**Positioning — read this twice (owner direction, 2026-08-03).** Femio is a **health**
product, not a **medical** one. That is a deliberate choice, and it cuts two ways in your
writing:

- **Sound like a trusted health guide, not a clinic.** Prefer "health", "wellbeing",
  "your body", "care", "clinician" over "medical", "medicine", "clinical", "patient".
  Don't write "medical information", write "health information". Don't call the reader a
  patient — she is a person reading about her own body.
- **But never soften the boundary.** The disclaimers keep the word *medical* on purpose:
  "not medical advice", "not a substitute for your clinician", "seek urgent medical care".
  Those sentences are what keep Femio outside medical-device regulation, and they must
  stay exact. Reducing medical *framing* while keeping the medical *boundary* is the whole
  point — one is decoration, the other is protection.
- **Make the boundary visible early.** Every article states, in its own words and within
  the first screen, that this is health information for learning and planning and not a
  substitute for the reader's own clinician. Do not bury it at the bottom.
- Describing clinical care remains fine and necessary (§2). "A clinician may suggest…" is
  health writing; "we recommend…" is not.

**Tone:** warm, plain, judgment-free, specific. Never coy about anatomy. Never
patronising. Never breathless. A reader in pain at 2am should find the answer in the first
two sentences, and a reader browsing should find it worth reading.

---

## 2. Forbidden language (hard rule — automated checks enforce this)

Never write, in any form, about what **Femio or its content** does:

| Never | Write instead |
|---|---|
| diagnose, diagnosis, diagnostic | "screening", "a doctor can confirm", "signs that are worth discussing" |
| treat, treatment, cure, therapy (as something we offer) | "care options your clinician may discuss", "what treatment can involve" *(describing clinical care is fine — see below)* |
| prevent, prevents, prevention (of disease) | "may lower the chance of", "what the guidance recommends" |
| contraception, contraceptive, birth control (as a Femio function) | "these dates are not a reliable way to avoid pregnancy" |

**The distinction that matters:** you may *describe* clinical care that exists in the
world — "clinicians may prescribe combined hormonal contraception for heavy bleeding" is
reporting a guideline and is fine. What you may never do is imply **Femio** diagnoses,
treats, prevents or acts as contraception. When in doubt, attribute the action to a
clinician or a guideline body, never to Femio or to the reader's tracking data.

Additional bans:
- **No dosages, no drug regimens, no "how much to take".** Name a drug class if a
  guideline does; never instruct.
- **No triage.** Never tell someone their symptom is or isn't serious. Point to the
  red-flag box and to care.
- **No prognosis or probability about an individual.** Population statistics with a
  citation are fine; "you probably have…" never is.
- **No fertile-window framing as birth control**, ever. The approved sentence is: *"These
  dates support conception planning and awareness. They are estimates, not a reliable way
  to avoid pregnancy."*

---

## 3. Sourcing rules (non-negotiable)

- **Tier 1:** WHO, NICE/NHS, CDC, ACOG, RCOG, ESHRE, NIH/NICHD, Cochrane, UpToDate-grade
  society guidelines. **Tier 2:** major peer-reviewed journals, national health services,
  respected specialty bodies.
- **Minimum two independent sources per article**, at least one Tier 1.
- **Never cite:** blogs, competitor apps, content farms, Wikipedia, news write-ups of
  studies, or another AI's output.
- **Every statistic needs a citation next to it.** No "around 1 in 10" without a source.
  If the number varies between sources, say so and cite both, or cut it.
- **Prefer the guideline over the primary study** for clinical statements.
- Record each source with **title, URL and tier** in the front matter. Check the URL
  actually resolves to the document you mean.
- **Date-sensitive guidance:** note the guideline year in the text where it matters
  ("NICE's 2024 guidance recommends…").

If a topic's evidence is genuinely contested, write that plainly — "guidance differs
between the UK and the US on X" with both cited is excellent content. Faking consensus is
not.

---

## 4. The page contract (every article follows this shape)

1. **H1** — the question or topic in the reader's words, not a clinical label.
2. **Answer-first opening (2–4 sentences).** The direct answer, immediately. No throat-clearing,
   no "Introduction". Someone who reads only this must leave better informed.
3. **Body sections (H2/H3)** — one primary intent per article, developed in a logical
   order. Short paragraphs (2–4 sentences). Lists where lists genuinely help.
4. **"When to see a doctor"** — a required H2 on every health article. Specific, not
   vague: what to look for, and how urgently.
5. **Red-flag box** — required wherever a symptom can indicate an emergency. Format as a
   blockquote beginning `**Seek care now:**` and list the specific signs. Femio renders
   this as a distinct danger-styled box.
6. **Related Femio links** — 3–6 internal links (see §7).
7. **Sources** — listed in front matter; the CMS renders them.

**Reading level: grade 6–8** (approximately Flesch–Kincaid ≤ 8). Short sentences. Define
every clinical term on first use, in-line, in plain words. Say "womb (uterus)" the first
time, then use either. State the reading level and how you checked it in the front matter.

**Length:** pillar pages 1,200–1,800 words; cluster articles 700–1,200. Longer only if the
topic genuinely needs it. Never pad — padding is visible and it dilutes the answer.

---

## 5. Deliverable format

One Markdown file per article at `docs/content/articles/<slug>.md`, using **exactly** the
front-matter schema already established in `docs/content/articles/meet-femio.md`. Read that
file before you start; it is the reference implementation.

Required front matter (do not rename keys, do not omit):

```yaml
title, slug, locale, status: "draft", content_type, search_intent,
primary_query, secondary_topics[], excerpt, meta_title, meta_description,
canonical_url, robots_while_draft, robots_when_published,
open_graph_title, open_graph_description, open_graph_image, open_graph_image_alt,
written_by, medically_reviewed_by, date_published, date_modified,
last_reviewed, next_review_due, reading_level_ok, reading_level_method,
disclaimer_type, structured_data_required[], sources[]   # title, url, tier
internal_links[]                                          # the Femio paths you link to
```

Rules for the metadata fields:
- `slug` — lowercase, hyphenated, stable, English words, no dates, no stop-word padding.
- `meta_title` ~30–60 characters, `meta_description` ~120–160, both **unique across the
  whole set** and written for a human, not a crawler.
- `canonical_url` = `https://femioapp.com/en/{learn|conditions}/{slug}` per §6.
- `written_by` / `medically_reviewed_by` — write `PENDING` unless Khaled has given you a
  real name. **Never invent an author, a clinician, credentials, or a review date.**
- `date_published`, `last_reviewed`, `next_review_due` — leave `null`; the CMS sets them at
  publication. `disclaimer_type` is one of `general` | `screening` | `emergency` | `none`.
- `status: "draft"` always. You are not publishing.

---

## 6. Which 60 articles, and where each lives

URL shape decides the type:
- **Condition pillar** → `/en/conditions/{slug}` — the main page for a named condition.
- **Article / cluster** → `/en/learn/{slug}` — a facet of a pillar, or a standalone topic.

Author **Wave A pillars first**, then their clusters, then start Wave B. Wave A (from
`docs/16` §8) is the spine: cycle basics and tracking, PCOS, endometriosis, PMS/PMDD, heavy
periods, painful periods, trying to conceive + fertile window, uncomplicated pregnancy,
perimenopause, menopause. Wave B follows: fibroids, adenomyosis, irregular or absent
cycles, gestational diabetes, pre-eclampsia, thyroid across life stages, postpartum
recovery and mood, genitourinary syndrome of menopause.

For each pillar, write 3–5 clusters covering the facets a reader actually searches:
symptoms · getting a diagnosis (framed as "how it's assessed") · what care can involve ·
living with it day to day · its effect on fertility or on a life stage · how to track it.

**Deliver in batches of 10**, pillar-first, so review can start early. Before writing each
batch, list the 10 titles + slugs + intents and get them confirmed — this prevents two
articles competing for the same query (keyword cannibalisation), which is the most common
way a content set like this underperforms.

---

## 7. SEO rules

- **One primary intent per page.** If an article answers two questions, it is two articles.
- **No keyword stuffing.** Write the phrase naturally; the primary query should appear in
  the H1, the opening, and one H2 if it fits without distortion. Nowhere else on purpose.
- **Internal links** — every article links to 3–6 of these, and only to routes that exist:
  `/en/learn` · `/en/conditions` · `/en/calculators` and its five tools
  (`due-date`, `fertile-window`, `gestational-age`, `bmi`, `cycle-length`) · `/en/glossary`
  · `/en/faq` · `/en/about` · `/en/editorial-policy` · `/en/medical-review` · `/en/authors`
  · plus other articles in this set by their slug. Never link to a page you have not
  written or confirmed. List every internal link in `internal_links` so it can be checked.
- **Pillar ↔ cluster discipline:** every cluster links up to its pillar; every pillar links
  down to its clusters and across to 3–5 sibling conditions; every condition links to the
  matching Femio tool, and tool-adjacent articles link back to the tool.
- **Structured data** is generated by the site, not by you — but declare in front matter
  which types apply (`Article`, `MedicalWebPage`, `BreadcrumbList`, `FAQPage` where the
  article genuinely contains Q&A).
- **Titles** must not make medical claims ("Cure your PCOS" is both wrong and illegal
  here). No clickbait, no ALL CAPS, no emoji.
- Do **not** write Arabic, French or Spanish versions unless asked. Translation is a
  separate human-reviewed process; metadata is written natively per locale, never
  literally translated.

---

## 8. Safety routing (read carefully)

- Anything touching **self-harm, suicidal thoughts, abuse or domestic violence** must link
  to `/en/help-now` and must **not** contain a phone number of any kind. Femio's crisis
  route is deliberately global ("contact your local emergency services or go to your
  nearest emergency department") because a wrong or stale number is a safety failure.
- **Never** present a screening questionnaire as a diagnosis. Screeners are "a starting
  point to discuss with your clinician".
- **Pregnancy red flags** (bleeding, severe headache, vision changes, reduced fetal
  movement, severe abdominal pain) always get a red-flag box, no exceptions.
- Content about eating, body image, or pregnancy loss must be written with particular care:
  no numbers that invite comparison (weights, calorie targets, BMI thresholds as goals),
  no "should" language about bodies.

---

## 9. What you must not do

- **Do not modify any file outside `docs/content/articles/`.** No code, no config, no
  existing docs. If you think something in the repo needs changing, write it in your
  batch notes instead.
- **Do not publish anything, or set any status other than `draft`.** Publication runs
  through the CMS's medical-review gate and is a clinician's decision.
- **Do not invent** authors, reviewers, credentials, dates, statistics, sources, or URLs.
- **Do not copy text** from any source. Summarise in your own words and cite. Quotations
  only where a guideline's exact wording matters, marked and attributed.
- **Do not use another AI's output as a source.**

---

## 10. Definition of done (self-check before you hand over a batch)

For every article:

- [ ] Answers its one question in the first 2–4 sentences.
- [ ] Grade 6–8 reading level; every clinical term defined on first use.
- [ ] "When to see a doctor" section present and specific.
- [ ] Red-flag box present wherever a symptom can be an emergency.
- [ ] ≥2 sources, ≥1 Tier 1, each with a working URL, cited at the claim.
- [ ] Zero forbidden words per §2; the fertile-window sentence used verbatim if relevant.
- [ ] Health framing, not clinical framing (§1) — and the boundary stated within the first
      screen, in the article's own words.
- [ ] No statistic without a citation; no invented anything.
- [ ] Front matter complete, keys unchanged, `status: draft`, author/reviewer `PENDING`.
- [ ] `meta_title` and `meta_description` unique across the whole set.
- [ ] 3–6 internal links, all to routes that exist, all listed in `internal_links`.
- [ ] Slug unique, stable, and matching `canonical_url`.

Hand over each batch with a short note: what you wrote, what you deliberately cut for lack
of a source, and anything you flagged as needing Khaled's or a clinician's decision.

---

## 11. How your work will be checked

Claude Code will review each batch against this brief, specifically: forbidden-language
scan, source presence and tier, front-matter completeness and key parity, slug and metadata
uniqueness, internal links resolving to real routes, reading level, and structural
compliance. Anything failing comes back with the specific line. After that, a qualified
clinician reviews the medicine itself in the CMS, and only a reviewer can approve
publication — the software enforces it, so nothing you produce can go live un-reviewed.

Write as though a careful clinician and a sceptical regulator will both read every line.
Both eventually will.
