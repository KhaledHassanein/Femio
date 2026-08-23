# 29.04 — Content and the Learn surface

The widest measurable gap after charts, and the one with the highest leverage.

**Where we stand.** 105 articles authored in `docs/content/articles/`, 31 live, all
`locale: "en"`. Payload CMS with eight collections. Citations enforced, clinician
bylines, an editorial policy page, a medical-review page, a conditions library, a
glossary — and **no way to search any of it**.

**Where Flo stands.** Contentful. Its premium carousel claims **1,000+ articles,
videos and courses**. Its in-app articles carry numbered citation markers and a
References section in full scholarly format with DOIs — correction C-4, and the thing
I had wrongly claimed was ours alone. What Flo has no equivalent of: a named
reviewing clinician, a review date, an editorial policy.

---

## 1. The strategy, stated plainly

We will not beat 1,000 articles on volume. Attempting it dilutes the one thing that
is defensible.

**Compete on four axes instead:**

| Axis | What it means | Who else has it |
|---|---|---|
| **Attribution** | A named clinician, their credentials, and the date they reviewed it, on every article | Nobody |
| **Currency** | A visible review date and a re-review cadence; content that is out of date says so | Nobody |
| **Language** | Four languages, RTL-native, with review state *per locale* | Nobody |
| **Fit** | The right article surfaced for her persona, condition and life stage | Flo, partially |

An article that says *"Reviewed by Dr X, obstetrician, 14 March 2026"* against Flo's
title-and-reference-list is a stronger claim than one more article.

---

## 2. Locale becomes a first-class dimension

**The problem.** `content_i` exists but review state is modelled per content item.
An Arabic translation reviewed by nobody is not a reviewed article, and shipping it
under the English article's byline would be a false attribution — a compliance
problem, not a content one.

**The model.**

```
content            (id, slug, content_type, status, …)
content_locale     (content_id, locale, title, body, excerpt,
                    status, translated_by, translated_at,
                    reviewed_by, reviewed_at, review_due,
                    primary key (content_id, locale))
content_citation   (content_id, locale, ordinal, citation_text, doi, url, tier)
```

Rules that follow:

- **A locale is publishable only when its own row is reviewed.** English published
  and Arabic draft is a normal, expected state.
- **`reviewed_by` references a `People` record**, so the byline is a person, not a
  string.
- **`review_due` drives the re-review queue.** An article past its due date shows its
  date and a note; it does not silently pretend to be current.
- **Citations are per locale** because a translated article may cite a
  locale-appropriate source alongside the original.
- **`tier`** records Tier-1/Tier-2 provenance, which `content-lint` already enforces
  at authoring time.

## 3. The Arabic pass — TD-08, the highest-leverage item

Not a translation project. Per **D4**, the differentiator is content *authored for*
these markets:

- The conditions library reflecting regional prevalence rather than a Western default.
- Ramadan fasting with cycle, pregnancy and medication timing — a question millions
  ask annually and no competitor answers.
- Sexual and reproductive health framed conservatively and clinically per **OD-5** —
  present, accurate, and in a register that does not make the app unopenable on a
  shared device.
- A privacy posture written for shared devices and family visibility.

**Sequencing.** Translate and review the 31 live articles into Arabic first, because
a published set in two languages is worth more than a large draft set in one. French
and Spanish follow the same pipeline afterwards.

**Gate.** No Arabic article publishes without a named Arabic-competent clinical
reviewer. If that person does not exist yet, that is a `BLOCKERS.md` item, not a
reason to lower the bar.

## 4. The Learn surface — OD-12

Flo's Insights tab is the structural model. Take the structure; leave the subject
matter.

```
[ search across articles, conditions, glossary, calculators ]

Topic chips — question-shaped
  [ Am I pregnant? ]  [ Why is my cycle irregular? ]  [ What is PCOS? ]

Most read this week
  [ card ] [ card ] [ card ]

For you  ← from ExperienceConfig.surfaces.learn.collections
  [ card ] [ card ] [ card ]

Browse by topic
  Cycle · Conditions · Fertility · Pregnancy · Postpartum · Menopause · Teen
```

**Question-shaped chips.** "Am I pregnant?" is an entry point; "Pregnancy" is a filing
cabinet. This is the single cheapest improvement on the surface and it costs nothing
but the tag vocabulary.

**Search is TD-14 and it is overdue.** 105 articles, a glossary and a conditions
library with no search is the most obviously missing thing in the product. Postgres
full-text per locale is sufficient — Arabic needs its own configuration, and that is
the whole reason it is not a one-line change.

**Every card carries its attribution.** Reviewer name and review date on the card,
not only inside the article. That is the differentiator made visible, and it is the
detail that makes a Femio card look different from a Flo card at a glance.

**"For you" comes from the served config**, not from client logic — `CollectionSpec`
in chapter 03 §3.

## 5. The article page

Beyond what we have:

- **Attribution block at the top**: reviewer, credentials, review date, next review
  due. Above the fold, not in a footer.
- **Numbered citation markers in the body**, resolving to a References section — the
  scholarly form Flo uses, because it is right, with DOIs where they exist.
- **A "what this does not cover" line** where a topic borders on diagnosis, carrying
  product rule 1's language at the point of risk. Flo attaches its contraception
  disclaimer to the fertility number rather than burying it in terms; that placement
  is the lesson.
- **Related tools**, chosen by tag — an article on cycle length links to the cycle
  calculator.
- **Reading time and locale availability** — "also in العربية" as a real affordance.

## 6. Weekly pregnancy content

The pregnancy tracker's model is better shaped than a single body field and we should
adopt it (chapter 03 of the teardown):

```
week, trimester,
babySize (comparison), babyLengthCm, babyWeightGrams,
developmentSummary,      -- what the baby is doing
momBodyChanges,          -- what her body is doing
nutritionNote,
fullArticle
```

Three registers per week map directly onto what a pregnancy home card needs, and we
already have 37 weeks authored (4–40). Restructuring them into these fields is
authoring work, not engineering, and it makes `pregnancy.week` a far better module.

## 7. What the free tier includes — OD-7

Flo puts its **entire content library behind the paywall**. Their four "Exclusive to
Premium" items are: insight into what you logged, 1,000+ articles, partner
connection, and the assistant.

That is the position to differ from. Under OD-7 the free tier must be genuinely
useful, and **content is the cheapest generous thing we can give**: our articles are
also our SEO surface and our acquisition channel, so putting them behind a wall costs
twice.

A defensible split, subject to the later monetisation decision:

| Free | Paid |
|---|---|
| The whole article library, all languages | Depth: patterns with confidence, the visit pack, multi-cycle analysis |
| Tracking, calendar, predictions with confidence | Partner sharing |
| Calculators | Data export in clinical formats |
| Screeners | Long-range history and comparison |

The principle: **free gives her the knowledge and her own record; paid gives her the
analysis.** That is the opposite of Flo's split, and it is more defensible for a
product whose thesis is trustworthy information.
