---
name: femio-seo-aso
description: Femio SEO and ASO playbook - YMYL health SEO, E-E-A-T, multilingual hreflang, schema.org, keyword strategy, and app store optimization. Use when writing Femio content for search, building public pages, doing keyword research, metadata, sitemaps, or preparing Play Store / App Store listings.
---

# Femio SEO & ASO Playbook

Femio's growth engine is organic search in a YMYL (Your Money Your Life) category — Google holds health content to the highest E-E-A-T bar. Everything below assumes that.

## E-E-A-T foundations (site-wide, non-negotiable)
- Every health page shows: named author, named medical reviewer (credentials linked to bio page), last-reviewed date, sources list.
- Site publishes: editorial policy, medical review process, about page with real team, contact page, privacy policy. These pages are internal-linked from every article footer.
- Author/reviewer bio pages with `Person` schema + credentials (sameAs → professional profiles).

## On-page standards
- One primary intent per page. Title ≤60 chars, benefit-led; meta description ≤155 with CTA.
- Answer-first summary (40–60 words) targeting featured snippet, then depth.
- Schema.org: `MedicalWebPage` + `FAQPage` (real FAQs only) + `BreadcrumbList`; calculators get `WebApplication`; articles `Article` with author/reviewer.
- Internal linking: every condition page links to its tracker/calculator tool and 3–5 sibling conditions; tools link back to education (the content↔tool loop is our conversion engine).
- Core Web Vitals budget: LCP <2.0s, CLS <0.05, INP <200ms. Images: next/image, AVIF/WebP, dimensioned.

## Multilingual SEO
- Path strategy: `/en/`, `/ar/`, `/fr/`, `/es/` subdirectories (one domain, consolidated authority).
- `hreflang` cluster complete + `x-default` → language selector; localized slugs (translated, not transliterated); localized metadata written natively, not translated literally.
- AR pages: RTL-rendered, Arabic keyword research separately (search behavior differs — dialect vs MSA; target MSA, note dialect synonyms in content).

## Keyword strategy
- Pillar-cluster model: pillar = condition (e.g., PCOS) → clusters = symptoms, diagnosis, treatment, diet, fertility-impact, tracking.
- Priority: high-intent underserved terms (menopause symptoms, PCOS irregular period tracking, IVF injection calendar, ovulation calculator variants) before head terms.
- Use connected SEO tools (Semrush/Ahrefs MCPs) for volume/difficulty/SERP gap vs healthline.com, flo.health, helloclue.com, verywellhealth.com per locale.
- Calculators/tools = link magnets: build them shareable, embeddable.

## ASO (Phase 4)
- Title (30 chars) = brand + top keyword: "Femio: Period & Cycle Tracker" localized per store language.
- iOS subtitle (30) + keyword field (100, no duplicates of title, comma-separated no spaces); Android long description keyword-natural (Google indexes it; Apple doesn't index description).
- Screenshots: first 3 carry the message (privacy, honest predictions, lifecycle); localized text overlays per market; A/B via store experiments.
- Ratings strategy: in-app prompt after positive moments (streak, accurate prediction confirmed) only; respond to all reviews in-language.
- Store privacy labels must exactly match actual data practice (Apple nutrition label, Play Data safety) — mismatch is a rejection + trust risk.

## Reporting cadence
Weekly: GSC queries/CTR anomalies, new content indexed, tool-page conversions. Monthly: cluster coverage vs competitors, hreflang errors, CWV. Log actions in docs and add follow-ups to 07_MASTER_TODO.md.
