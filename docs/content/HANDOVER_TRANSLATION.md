# Handover — translating the library into Arabic, French and Spanish (R3.8)

**Status: ready to hand to a separate chat/agent.** Owner directed the full library, all three
target languages, on 2026-08-30.

Plan in §1–§4; **the prompt to paste into the other chat is §5, verbatim.** Its last instruction
tells that agent to finish by writing a return handover back to this project, and §6 is the
prompt for that return.

---

## 1. What this is, and one thing said once

Every row in the CMS is `_locale = 'en'`: 100 published articles, 5 conditions, 0 glossary
terms, 0 FAQs. Payload is configured with `fallback: true`, so an Arabic reader is *already*
served the English article with no indication. Product rule 6 says Arabic is first-class; today
it is first-class in the UI and absent from the library.

**My recommendation was narrower** — Arabic only, roughly twenty articles — because the binding
constraint is not translation cost but **clinical review capacity**, and there are two reviewers
in `payload.people`. The full scope is 105 articles × 3 languages = **315 translated documents,
each of which is new medical content in a language a clinician must read before it can be
published.** The owner has decided on the full library; this handover is written for that, and
the constraint is recorded here rather than argued again.

**Nothing about the scope decision changes the safety rules in §3.** They are not preferences.

## 2. What already exists

| Thing | Where | Note |
|---|---|---|
| English source of truth | `docs/content/articles/*.md` | **105 files**, frontmatter + Markdown |
| Published in the CMS | `payload.articles` + `articles_locales` | 100, all `reviewStatus: approved` |
| Conditions | `payload.conditions` | 5 |
| Importer (English only) | `apps/cms/scripts/import-articles.mjs` | Hard-fails on `locale !== "en"` |
| Content guard | `pnpm content-lint` | Runs in the gate |
| Review gate | `apps/cms/src/hooks/review-gate.ts` | Data layer, cannot be bypassed |
| Search fallback | migration `0023` | Applied 2026-08-30 |

**The search fallback is why this can ship incrementally.** `search_content` tries her locale,
falls back to English, and returns `matched_locale` so the UI says which library answered. A
half-translated library therefore degrades honestly rather than looking broken — so translate in
whatever order makes sense and ship continuously. There is no big-bang cutover to wait for.

## 3. The four rules that are not negotiable

**3.1 — A translation is new medical content, not a formatting change.** It cannot inherit the
English article's `reviewStatus: approved`, its `medically_reviewed_by`, or its `last_reviewed`
date. Those fields assert that a named clinician read *this text* and stands behind it. Carrying
them across languages would be a false claim of clinical review, on health content, in a language
nobody reviewed. Every translated document imports as `_status: draft`, `reviewStatus: draft`,
reviewer `PENDING`, review date `null`.

The CMS enforces this at the data layer — `enforceReviewGate` rejects `approved` and `published`
from anyone without the `medical_reviewer` or `admin` role, whichever API is used. **The agent
cannot publish. Do not try, and do not attempt to work around it.** Producing good drafts is the
whole job.

**3.2 — Slugs do not change.** URLs are stable identifiers and the app routes by slug in every
locale. `endometriosis-signs` stays `endometriosis-signs` in Arabic. Translate `title`, `excerpt`
and `body`; never the slug, and never the internal-link targets.

**3.3 — Sources are identical across languages.** A Tier-1 citation does not become a different
citation because the surrounding prose is in Spanish. Keep the same sources, in the same order,
with the same URLs. Do not substitute a local-language source that says something similar — that
is a different claim with a different evidence base, and it needs its own review.

**3.4 — No new medical claims, and no dropped ones.** Especially the red-flag and
"discuss with your clinician" lines. Femio's positioning is wellness and education only; a phrase
that reads as neutral in English can land as diagnostic in another language. Where a hedge has no
natural equivalent, keep the hedge and lose the elegance.

## 4. Two things specific to Arabic

**RTL is built and verified, but bidi has bitten this project twice.** `°C` rendered as `C°` and
`±2` rendered as `2±`, both beside Arabic text. Neither Unicode isolates nor a `dir="ltr"` span
settled the second one; the fix was to remove the sign and write the words. **So: avoid leading
mathematical signs and stray Latin units inside Arabic sentences.** Write "يومين في كل اتجاه"
rather than "±2 يوم". Numerals themselves are fine.

**Terminology has to be decided once, up front.** The same condition must not be three different
words across a hundred articles. Build the term list first — and note that it doubles as the
glossary, which is currently **empty** (R3.7) and is a real gap in its own right.

---

## 5. The prompt — paste this verbatim into the other chat

> You are translating the content library for **Femio**, a women's-health platform. The English
> source is 105 Markdown files in `docs/content/articles/` in the repo you have been given, plus
> 5 condition pages in the CMS. Target languages: **Arabic (`ar`), French (`fr`), Spanish
> (`es`)**.
>
> Read `CLAUDE.md` first, then `docs/content/CODEX_AUTHORING_BRIEF.md` (the schema every file
> follows) and `docs/content/HANDOVER_TRANSLATION.md` (which produced this prompt). Use the
> `femio-medical-content` and `femio-i18n-workflow` skills.
>
> **What you are producing:** for each English article, one translated Markdown file per target
> language, in `docs/content/articles/`, named `<slug>.<locale>.md` — for example
> `endometriosis-signs.ar.md`. Same frontmatter schema as the English file, with `locale` set to
> the target.
>
> **Five rules that are not stylistic:**
>
> 1. **Never mark a translation as reviewed.** `status: draft`, `review_status: draft`,
>    `medically_reviewed_by: PENDING`, `last_reviewed: null`. A translation is new medical
>    content in a language no clinician has read. Carrying the English article's approval across
>    would be a false claim of clinical review. The CMS enforces this at the data layer and will
>    reject you; do not attempt to work around it.
> 2. **Never change a slug**, and never change an internal link target. URLs are stable in every
>    locale and the app routes by slug.
> 3. **Keep the sources identical** — same citations, same order, same URLs. Do not substitute a
>    local-language source that says something similar.
> 4. **Do not add or drop a medical claim**, especially red-flag lines and "discuss with your
>    clinician" hedges. Where a hedge has no natural equivalent, keep the hedge and lose the
>    elegance. Femio is wellness and education only and never diagnoses.
> 5. **Arabic: avoid leading mathematical signs and stray Latin units inside sentences.** Write
>    "يومين في كل اتجاه", not "±2 يوم" — bidi reorders those and it has cost this project two
>    debugging passes. Numerals are fine.
>
> **Do this first, before translating any article:** produce a terminology list — every medical
> term that recurs across the library, with the single agreed rendering in each target language.
> The same condition must not appear under three different words across a hundred articles. Put
> it in `docs/content/GLOSSARY_TERMS.md`. It is also the source for Femio's glossary section,
> which is currently empty, so make the definitions publishable rather than translator's notes.
>
> **Then translate in this order**, because a partially translated library degrades honestly (the
> app falls back to English and says so), so the most-read pages should land first:
>
> 1. The 5 condition pages.
> 2. Anything a new user meets in her first session — cycle basics, "is this normal", the
>    onboarding-adjacent set.
> 3. Every article containing a red flag or urgent-care guidance.
> 4. The rest, in whatever order is efficient.
>
> **Check your work as you go:** `pnpm content-lint` runs over the drafts. Be aware its reading-
> level rule is English-specific — if it reports grade-level findings on a non-English file, say
> so in your return handover rather than distorting the translation to satisfy it.
>
> **You cannot publish and should not try.** Producing accurate drafts, with the terminology list,
> is the whole job. A human clinician reviews and publishes.
>
> **When you finish — or when you stop for any reason — write a return handover** to
> `docs/content/HANDOVER_TRANSLATION_RETURN.md`, following the prompt in §6 of
> `docs/content/HANDOVER_TRANSLATION.md`. Do this even if you completed only part of the work;
> a partial return that says exactly where you stopped is far more useful than nothing.

---

## 6. The return prompt — give this to that agent for its final step

> Write `docs/content/HANDOVER_TRANSLATION_RETURN.md`. Prose over bullets. Cover:
>
> **What you produced.** How many files, in which languages, which slugs. Where they are. If you
> did not finish, say exactly where you stopped and what remains — by slug, not by estimate.
>
> **The terminology list.** Where it is, how many terms, and any term you had to make a judgement
> call on. Name the calls: a reviewer needs to check those first.
>
> **Every place you were unsure.** Specifically: any sentence where the English hedge had no
> natural equivalent and you kept the hedge at the cost of fluency; any medical term with more
> than one defensible rendering; anything you suspect reads as diagnostic in the target language
> even though the English does not. This section is the most valuable thing you will write —
> it is the reviewer's worklist.
>
> **What you did not do, and why.** Including anything you judged unsafe to translate without a
> clinician, and any article you think should be rewritten for the target audience rather than
> translated.
>
> **The state of the checks.** Whether `pnpm content-lint` passes, and any finding you decided
> not to act on with the reason — particularly reading-level findings, whose rule is
> English-specific.
>
> **What the receiving project must do next**, in order, concretely enough to act on without
> re-reading your whole output.
>
> Do not mark anything as reviewed, approved, or ready to publish. That is a clinician's call and
> your handover feeds it.
