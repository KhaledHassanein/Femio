# Femio V2 — Editorial Policy & Medical Review Process (P1.7)
Prepared: 2026-07-23 · Status: living · Owners: Khaled + Medical Reviewer(s) + Editorial lead
Basis: `femio-medical-content`, `femio-seo-aso` (E-E-A-T), `04_MEDICAL_DATA_SOURCES.md`, `13_LEGAL_COMPLIANCE.md`, and the CMS review gate built in P1.6 (`apps/cms/`).

This document is both an **internal standard** and the source for two **public trust pages** — `/editorial-policy` and `/medical-review` — which every article footer links to (an E-E-A-T requirement in a YMYL category). Prose over bullets where it matters; the rules are enforced, not aspirational.

## 1. Why this exists
Femio competes on trust in a category scarred by data scandals and thin, un-reviewed content. Our promise is simple and verifiable: **every health claim is traceable to a reputable source, every page is reviewed by a qualified clinician before it goes live, and every locale is medically correct — not merely translated.** Google holds "Your Money or Your Life" health content to the highest expertise/authority/trust bar, and so do we. Content that cannot meet this bar is not published.

## 2. Scope
Applies to all user-facing health content in every locale (EN/AR/FR/ES): condition and article pages, FAQs, tips, glossary terms, screener copy, calculator explanations, coaching/insight cards, and notification text. It does **not** govern marketing copy or legal pages (separate review), though those still must not make medical claims.

## 3. Editorial principles
1. **Wellness, education, and tracking only.** We explain, we help people track, we point to clinicians. We never diagnose, treat, prevent disease, or act as contraception (this also keeps Femio outside medical-device scope — `13_LEGAL_COMPLIANCE.md` §7). Language is "this may suggest… discuss with your clinician," never "you have."
2. **Evidence over opinion.** Every factual claim traces to a Tier-1/2 source (§4). We do not publish anecdote as fact, and we never invent statistics, dosages, or guideline positions — if a fact cannot be sourced, it is cut or flagged `[NEEDS SOURCE]` for the reviewer.
3. **Uncertainty-honest.** Predictions and insights are ranges with context ("expected around…", "based on your last N cycles"), never guaranteed dates, and never a "late" counter in irregular modes.
4. **Plain and warm.** Grade 6–8 reading level (§5), short sentences, second person, active voice, every medical term defined on first use. No fear-mongering and no toxic positivity.
5. **Culturally adapted, not just translated.** The same medical evidence holds in every locale; what changes is examples, food references, healthcare-system phrasing, and optional clearly-toggled faith-aware notes (AR). Adaptation never changes the evidence.
6. **Safety foregrounded.** A specific, always-present "When to see a doctor" section, and a visually distinct **red-flag box** ("Seek care now if…") near the top of any page touching an emergency-capable symptom (ectopic, PPH, pre-eclampsia, TSS, etc.).

## 4. Sourcing standards
- **Hierarchy.** Tier 1 — MedlinePlus/NIH, CDC, WHO, NHS. Tier 2 — ACOG, RCOG, NICE, The Menopause Society, ASRM, ESHRE. (Full catalog: `04_MEDICAL_DATA_SOURCES.md`.) Prefer Tier 1 for general facts; Tier 2 for specialty/guideline positions.
- **Minimum.** At least **two** independent sources per page, **at least one Tier 1/2**. Guideline-specific claims cite the guideline directly.
- **Integrity.** Facts are rewritten in our own words and cited — never copy licensed text; respect the WHO non-commercial clause and all source licenses. Each source is stored structurally in the CMS (title, URL, tier) so citations render consistently and are auditable.
- **Recency.** Cite the current version of a guideline; note the version/year. Superseded guidance is updated at review time (§7).

## 5. Reading level
EN content must pass a **Flesch-Kincaid grade ≤ 8** check (recorded as the CMS `readingLevelOk` flag). Other locales target the equivalent plain-language register (grade 6–8 equivalent), verified by the locale reviewer. Jargon is defined on first use; the common term leads, with the clinical term (and English in parentheses on first AR use) following.

## 6. Content structure (page contract)
Every condition/article page follows this order (snippet- and schema-optimized, `femio-medical-content` §2):
answer-first **summary box** (2–3 sentences) → **What it is** → **Symptoms** → **When to see a doctor** (always, specific) → **Diagnosis** → **Treatment options** (educational, never a dose) → **Living with / self-care** → **Track it in Femio** (links the matching tool — the content↔tool loop) → **FAQ** (real questions, schema-ready) → **Sources**. Red-flag boxes sit near the top where relevant. Screeners present as screening, end with score interpretation + "share with your clinician" + crisis resources.

## 7. The medical review process
Femio content moves through a controlled workflow that is **enforced in software** (the CMS review-gate hook, `apps/cms/src/hooks/review-gate.ts`), not left to discipline:

1. **Draft** — an editor/author writes EN master content to the page contract, adds sources, sets the disclaimer type, and runs the reading-level check. Status: *Draft*.
2. **Medical review** — the author moves it to *In medical review*. A qualified **medical reviewer** checks accuracy, source fidelity, safety framing (red-flags, when-to-see-a-doctor), and non-diagnostic language. They either request changes (*Changes requested*) or approve.
3. **Approval** — only a user with the **medical_reviewer** (or admin) role can set *Approved* and record themselves as `medicalReviewer` with a `lastReviewed` date and a `nextReviewDue` set to **+12 months**. The system blocks anyone else from approving.
4. **Publish** — only after approval can the content be published, and only a reviewer/admin can publish. **Unreviewed or unapproved content cannot go live** — the data layer refuses it regardless of which API is used.
5. **Per-locale sign-off** — a locale page (AR/FR/ES) is translated (machine draft → human translator → **per-locale medical reviewer**) and **cannot publish without that locale's reviewer sign-off**. Translation quality is never a substitute for medical review in that language.

**Reviewer qualifications.** Medical reviewers are licensed clinicians appropriate to the content (e.g., OB-GYN, family medicine, relevant specialty). Their name, credentials, and a linked **bio page** (`Person` schema, `sameAs` professional profiles) appear on every page they approve.

## 8. Authorship, bylines & E-E-A-T signals
Every published health page displays: a **named author**, a **named medical reviewer with credentials** (linked to their bio), the **last-reviewed date**, and the **sources list**. Author and reviewer bio pages carry `Person` schema. Site-wide, Femio publishes this editorial policy, the medical-review process, an about page with the real team, and a contact page — internally linked from every article footer (`femio-seo-aso` E-E-A-T foundations).

## 9. Disclaimers
Three standard disclaimer types (the CMS `disclaimerType` field), each with fixed, reviewed wording:
- **General** — "Femio provides educational and tracking information, not medical advice, diagnosis, or treatment. Talk to your clinician about your situation."
- **Screening** — for screeners: "This is a screening tool, not a diagnosis. Share your result with your clinician." + crisis resources where relevant (`docs/compliance/CRISIS_RESOURCES.md`).
- **Emergency / red-flag** — the "Seek care now if…" box: education pointing to urgent care, never triage or diagnosis.

## 10. Independence & conflicts of interest
Medical content is **editorially independent of advertising and commerce.** Advertisers and affiliates never influence medical content, review outcomes, or rankings; ad slots are visually separated and never targeted on health data. Any commercial relationship relevant to a topic is disclosed. Reviewers disclose conflicts; a conflicted reviewer does not sign off on the affected content.

## 11. Corrections, feedback & maintenance
- **Corrections.** A visible way to report an error on every page; substantiated corrections are made promptly, and material changes are dated/noted.
- **Re-review SLA.** Every page is re-reviewed at least every **12 months** (`nextReviewDue`), and sooner when guidance changes. Overdue pages are surfaced to reviewers and, if they lapse badly, deprioritized in ranking until refreshed (continuous task **C.3**).
- **Versioning.** The CMS keeps version history (drafts/versions); what changed and who approved it is auditable.

## 12. Governance & enforcement summary
This policy is not advisory — its key gates are **enforced by the CMS**: reviewer-only approval, approval-before-publish, per-locale reviewer sign-off, structured sources, reading-level and disclaimer fields, and 12-month re-review dates. The public `/editorial-policy` and `/medical-review` pages are generated from this document so what we promise externally is exactly what we enforce internally.

## Open items → next
- Recruit/appoint the medical reviewer panel (per specialty + per locale) — **Khaled**; gates P1.9 publication and ties to the P0.22 `[NEEDS SOURCE]` clearance.
- Build the public `/editorial-policy`, `/medical-review`, `/about`, `/contact`, and author/reviewer **bio pages** (with `Person` schema) as part of P1.9–P1.11.
- Corrections-reporting UI + overdue-review dashboard (admin, P1.18/P1.20).
