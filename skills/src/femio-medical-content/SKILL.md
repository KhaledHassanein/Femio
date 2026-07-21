---
name: femio-medical-content
description: Femio medical content authoring - referenced, medically-reviewed, grade 6-8 reading level patient education for gynecology and women's health. Use when writing or editing ANY Femio health content - articles, condition pages, tips, coaching cards, screener copy, notifications, in all 4 languages.
---

# Femio Medical Content Standards

Femio content must be more trustworthy than Flo's and clearer than Healthline's. Every claim traceable, every page reviewed, every locale medically correct — not just translated.

## Article template (mandatory frontmatter)
```yaml
title / locale / slug
medically_reviewed_by: <name, credentials>   # never publish without
written_by:
last_reviewed: YYYY-MM-DD
next_review_due: +12 months
sources: [≥2, at least one Tier 1/2 per 04_MEDICAL_DATA_SOURCES.md]
disclaimer: standard | screener | emergency
reading_level_check: passed   # Flesch-Kincaid grade ≤8 (EN)
```

## Writing rules
1. **Source hierarchy:** MedlinePlus/NIH/CDC/WHO/NHS (Tier 1) > ACOG/RCOG/NICE/Menopause Society/ASRM/ESHRE (Tier 2). Facts rewritten in our words + cited; never copy licensed text; respect WHO NC clause.
2. **Structure:** answer-first summary box (2–3 sentences, snippet-optimized) → "What it is" → "Symptoms" → "When to see a doctor" (always present, always specific) → "Diagnosis" → "Treatment options" → "Living with / self-care" → "Track it in Femio" (tool link) → FAQ (schema-ready) → Sources.
3. **Tone:** warm, plain, direct. Define every medical term on first use. Short sentences. "You", active voice. No fear-mongering, no toxic positivity, no diagnosis language ("this may suggest — discuss with your clinician", never "you have").
4. **Red-flag boxes:** any symptom that can indicate emergency (ectopic, PPH, pre-eclampsia, TSS…) gets a visually distinct "Seek care now if…" box near the top.
5. **Predictions/insights copy:** always uncertainty-honest ("expected around", "based on your last N cycles"), never guaranteed dates.
6. **Screeners (EPDS, PHQ-9, DRSP, MRS…):** present as screening not diagnosis; end with score interpretation + "share with your clinician" + crisis resources where relevant.
7. **Cultural adaptation (not just translation):** AR content may add optional faith-aware notes (clearly toggled), local food examples in nutrition tips, local healthcare-system phrasing per locale. Same medical facts in all locales — adaptation changes examples, never evidence.
8. **Minors/teen content:** age-appropriate, extra privacy-respecting, encourage trusted-adult involvement.

## Localization workflow
EN master → medical reviewer sign-off → translation portal (machine draft → human translator → per-locale medical reviewer) → publish. A locale page missing reviewer sign-off cannot go live.

## Never
Never invent statistics, dosages, or guideline positions. If a fact can't be sourced, cut it or flag `[NEEDS SOURCE]` for the reviewer.
