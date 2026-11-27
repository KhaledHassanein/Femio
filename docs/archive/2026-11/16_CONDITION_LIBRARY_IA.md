# Femio V2 — Condition Library Information Architecture (P1.8)
Prepared: 2026-07-23 · Status: living · Owners: Editorial + SEO + Product
Basis: `08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX.md` (73 personas), `femio-seo-aso`, `femio-medical-content`, `15_EDITORIAL_MEDICAL_REVIEW_POLICY.md`, and the P1.6 CMS collections (`apps/cms/`).

The library is Femio's organic-search engine and its education backbone. This document defines its taxonomy, page types, URL/i18n structure, cross-linking, and how it maps to the 73 personas and the CMS — so authoring in P1.9 slots into a fixed structure instead of improvising.

## 1. Principles
1. **Everything reachable (personalize, never restrict).** The library is fully browsable and searchable from any state; personalization changes emphasis on the home/tools, never what content exists. This is invariant #1 of the adaptation model.
2. **Pillar → cluster.** Each major condition is a **pillar** page; its facets (symptoms, diagnosis, treatment, diet, fertility impact, tracking) are **cluster** pages that link up to the pillar and across to siblings (`femio-seo-aso` keyword model).
3. **One primary intent per page**, answer-first, schema-marked.
4. **The content↔tool loop.** Every condition links to its matching tracker/calculator, and every tool links back to education — the conversion engine.
5. **Life-stage spine.** Top-level organization mirrors the persona tracks (A–F) so a woman finds content where she is in life, while conditions remain cross-linked across stages (e.g., PCOS appears in cycle, TTC, and perimenopause contexts).

## 2. Top-level taxonomy
Eight browse categories (life-stage spine + cross-cutting), each a hub page:

| # | Category | Persona track(s) | Scope |
|---|---|---|---|
| 1 | **Puberty & teens** | A | First periods, what's normal, teen cycle/pain, early PCOS signs, athlete/REDs, teen absent/late periods |
| 2 | **Cycles & periods** | B (core) | Cycle basics, tracking, PMS/PMDD, painful periods, heavy bleeding (HMB/AUB), irregular/absent cycles, migraine |
| 3 | **Gynae conditions** | B | PCOS, endometriosis, fibroids, adenomyosis, thyroid–cycle, infections, vaginal/pelvic health, HA, cancer screening/survivorship |
| 4 | **Sexual & reproductive health** | B | Sexual wellbeing, contraception (education), coming off contraception, SRH basics |
| 5 | **Trying to conceive & fertility** | C | TTC basics, fertile-window awareness, infertility (primary/secondary), recurrent loss, PCOS/endo/thyroid/male-factor TTC, fertility preservation, POI, IVF/ART |
| 6 | **Pregnancy** | D | Week-by-week, uncomplicated pregnancy, GDM, hypertension/pre-eclampsia, thyroid, prior loss (PAL), multiples, hyperemesis, cholestasis, anemia, mood, high BMI, AMA, VBAC, Rh |
| 7 | **Postpartum** | E | Recovery, breastfeeding/lactation, postpartum mood, after complicated pregnancy, contraception/return of fertility, loss & grief, postpartum thyroiditis |
| 8 | **Perimenopause & menopause** | F | Perimenopause, menopause/postmenopause, comorbidity, surgical/induced, premature/early, GSM |

Cross-cutting content that spans categories — **mental health & screeners**, **crisis resources**, **nutrition**, **sleep**, **fitness/REDs**, **thyroid**, **privacy & your data** — lives as its own hub and is linked from every relevant pillar.

## 3. The A–Z condition/topic index (derived from the 73 personas)
Each maps to a pillar page and its clusters; persona code(s) in brackets tie coverage back to `docs/personas/`.

- **Adenomyosis** [B9]
- **Anemia in pregnancy / nutrition** [D10]
- **Abnormal uterine bleeding (AUB) / heavy menstrual bleeding** [B4]
- **Breastfeeding & lactation** [E2]
- **Cancer — screening & prevention; gynae-cancer survivorship** [B18, B19]
- **Cholestasis of pregnancy** [D16]
- **Contraception (education) & coming off contraception** [B13, B14]
- **Cycle tracking — general / what's normal** [B1, A2]
- **Dysmenorrhea (painful periods)** [B3, A3]
- **Endometriosis** [B7] · **Endometriosis & TTC** [C7]
- **Fertility preservation** [C15] · **Premature ovarian insufficiency (POI)** [C16]
- **Fibroids** [B8]
- **Gestational diabetes (GDM)** [D3] · **Pre-existing diabetes in pregnancy** [D4]
- **GSM (genitourinary syndrome of menopause)** [F6]
- **Hyperemesis gravidarum** [D15]
- **Hypertension — chronic** [D5] · **Pre-eclampsia / gestational HTN** [D6]
- **Hypothalamic amenorrhea (HA)** [B16] · **Athlete / REDs** [A6]
- **Infertility — primary <35 / >35, secondary** [C2, C3, C4] · **Male-factor** [C9]
- **IVF / ART** [C10] · **TTC after contraception** [C11] · **TTC anxiety** [C12] · **LGBTQ+/donor, single mother by choice** [C13, C14]
- **Menstrual migraine** [B15]
- **Menopause & postmenopause** [F2] · **Perimenopause** [F1] · **comorbidity / surgical-induced / premature-early** [F3, F4, F5]
- **Mood — PMS/PMDD** [B2] · **antenatal mood** [D11] · **postpartum mood** [E3]
- **Multiples (twins+)** [D9] · **Advanced maternal age** [D13] · **High BMI in pregnancy** [D12] · **VBAC** [D14] · **Prior preterm** [D8] · **Rh-negative** [D17]
- **PCOS — not TTC / signs in teens / with TTC** [B6, A4, C6]
- **Pregnancy — uncomplicated / after loss (PAL)** [D1, D2]
- **Pregnancy loss & grief** [E6] · **Recurrent pregnancy loss** [C5]
- **Postpartum recovery / after complicated pregnancy / contraception & fertility / thyroiditis** [E1, E4, E5, E7]
- **Puberty & premenarche** [A1] · **Teen absent/late periods** [A5]
- **Sexual & reproductive health / sexual wellbeing** [B11, B12]
- **Thyroid & cycle** [B17] · **Thyroid & TTC** [C8] · **Thyroid in pregnancy** [D7]
- **Vaginal & pelvic health / infections** [B10]
- **Cross-cutting:** parent/guardian mode [X1], partner mode [X2].

This index is the coverage checklist: every persona's condition has a home, and Z1 (Other/Custom) users still reach all of it via search/browse.

## 4. Page types → CMS collections
| Page type | CMS collection | Purpose | Key schema |
|---|---|---|---|
| **Pillar (condition)** | `conditions` | The authoritative page for a condition; the page contract (§6 of doc 15) | `MedicalWebPage` + `BreadcrumbList` |
| **Cluster (article)** | `articles` | A facet/sub-topic (symptoms, diagnosis, diet, tracking…) linking to its pillar | `Article` + `MedicalWebPage` |
| **FAQ** | `faqs` | Standalone or embedded real Q&A | `FAQPage` |
| **Tip** | `tips` | Short actionable card, surfaced in-app + on pages | — |
| **Glossary term** | `glossary` | One term, plain-language definition; auto-linked from first use | `DefinedTerm` |
| **Calculator/tool** | (app, P1.10) | Due date, ovulation, GA, BMI, cycle-length; links to its condition | `WebApplication` |

Life-stage **category hubs** (§2) are lightweight index pages (can be `conditions` entries of a "hub" style or app routes) listing their pillars.

## 5. URL & i18n structure
- Locale-prefixed subdirectories, one domain: `/en/`, `/ar/`, `/fr/`, `/es/` (consolidated authority, `femio-seo-aso`).
- Paths:
  - Condition pillar: `/{locale}/conditions/{slug}` (e.g., `/en/conditions/pcos`)
  - Article/cluster: `/{locale}/learn/{slug}` (e.g., `/en/learn/pcos-and-insulin-resistance`)
  - Category hub: `/{locale}/learn/{category}` (e.g., `/en/learn/cycles-and-periods`)
  - Glossary: `/{locale}/glossary/{term}` · FAQ: usually embedded; standalone at `/{locale}/faq/{slug}`
  - Calculators: `/{locale}/calculators/{tool}`
- **Localized slugs** — ~~translated, never transliterated (Arabic slugs in Arabic)~~ **SUPERSEDED 2026-08-06 by ADR-045: slugs stay English in all four locales.** The rest of this bullet stands. Reopen only on Search Console evidence after translations ship. Complete `hreflang` cluster per page + `x-default` → language selector. Metadata written natively per locale, not literally translated. AR pages render RTL; AR keyword research done separately (MSA target, dialect synonyms noted in body).

## 6. Cross-linking model
- Every **condition pillar** links to: its **tracker/calculator**, **3–5 sibling conditions**, and its **cluster** articles.
- Every **cluster** links **up** to its pillar and **across** to 2–3 related clusters.
- Every **tool** links back to its condition education.
- **Glossary auto-linking**: the first use of a defined term on any page links to its glossary entry.
- **Life-stage bridges**: conditions that recur across stages cross-link (PCOS: cycles ↔ TTC ↔ perimenopause; thyroid: cycle ↔ TTC ↔ pregnancy ↔ postpartum), so a user moving between life stages keeps her context — mirroring the adaptation model's constant-core principle in the content layer.

## 7. Schema.org & E-E-A-T per page
`MedicalWebPage` on condition/article pages, `FAQPage` for real FAQs, `BreadcrumbList` for hierarchy, `DefinedTerm` for glossary, `WebApplication` for calculators, `Article` with `author` + `reviewer` (`Person` schema, credentials) on articles. Every health page shows named author, named reviewer + credentials, last-reviewed date, and sources (doc 15 §8).

## 8. Launch prioritization (feeds P1.9)
Author the **spine pillars first** (highest intent + persona-central), then fan out to clusters:
1. **Wave A (spine):** Cycle basics/tracking [B1], PCOS [B6], Endometriosis [B7], PMS/PMDD [B2], Heavy/painful periods [B4/B3], TTC basics + fertile-window [C1], Uncomplicated pregnancy [D1], Perimenopause [F1], Menopause [F2].
2. **Wave B (high-value conditions):** Fibroids [B8], Adenomyosis [B9], Irregular/absent cycles [B16/A5], GDM [D3], Pre-eclampsia [D6], Thyroid across stages [B17/C8/D7], Postpartum recovery + mood [E1/E3], GSM [F6].
3. **Wave C:** the remainder of the §3 index, plus cross-cutting hubs (mental health/screeners, nutrition, sleep, privacy).
P1.9 target: **first 60 EN articles** cover Wave A + the start of Wave B, plus the priority-30 AR translations. **Publication is gated by P0.22** (`[NEEDS SOURCE]` clearance) and the doc-15 review process — no pillar goes live un-reviewed.

## 9. Coverage governance
The §3 index is the master coverage list; a page is "covered" only when its pillar is **published** (reviewer-approved, per-locale signed off). Gaps and overdue re-reviews are tracked against this list (ties to the admin dashboard, P1.20, and continuous task C.3). New conditions discovered during authoring get a line here and in `07_MASTER_TODO.md`.

## Open items → next
- Keyword research per pillar/locale using the connected Semrush/Ahrefs tools (volume/difficulty/SERP gap vs healthline/flo/clue/verywell) — feeds titles, slugs, and cluster lists (P1.9/P1.11).
- Finalize category-hub implementation (CMS "hub" entries vs app routes) during P1.9 build.
- Confirm calculator set + routes with P1.10.
