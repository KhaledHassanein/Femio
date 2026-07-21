# Femio App – Roadmap & Milestones

This document is the **single source of truth** for current milestone status and what we’re building next.

## Current status (Feb 10, 2026)

### Completed ✅
- **M1 Research & Strategy** – competitive research, pain points, positioning
- **M2 PRD + UX** – requirements + UX/specs
- **M3 Architecture** – Clean Architecture + feature-first structure
- **M4.1 Core Setup** – theme, localization, DI, database
- **M4.2 MVP Features** – onboarding → monetization (core tracking features)
- **M4.3 Testing & Profiling** – unit tests, performance notes

### Shipped iterations after M4.3 ✅
- **Education content system** (JSON-driven) + authoring guide
- **Pregnancy case tips** (icon-based section)
- **Postpartum guide to 12 months (V1)** + postpartum case tips
- **Postpartum timeline browse UX** (weeks/months grouping + auto-scroll to current entry)

---

## Next milestone: M5 – “Premium Education” (content quality + trust)

Goal: make the app feel like a short, practical GP visit — **informative but not overwhelming**.

### Deliverables
- **Content QA pass**
  - Normalize tone (non-judgmental, culturally sensitive)
  - Remove repetition across weeks/months; keep sections tight
  - Ensure every entry has: baby development, baby care tips, mom recovery, when to get help
- **Red flag consistency**
  - Make sure postpartum “When to get help” is consistent across months 1–12
  - Ensure baby case tips don’t contradict timeline guidance
- **Localization readiness**
  - Confirm new headings/labels are localized (EN/AR) where applicable

### Definition of done
- A clinician (or qualified reviewer) can skim any week/month and find the essentials in <2 minutes.

---

## M6 – Personalization 2.0 (rules + content)

Goal: personalize guidance using the onboarding profile without hardcoding logic everywhere.

### Options (pick one, then implement)
- **A. Content-driven personalization (recommended)**
  - Store condition-specific notes in JSON (simple rules)
  - App shows only relevant notes based on saved profile
- **B. Code-driven personalization (current direction, expand carefully)**
  - Keep rules in Dart, but consolidate and test them

### Deliverables
- Expand profile inputs only if they directly improve guidance clarity (avoid long forms).
- Add tests for personalization rules.

---

## M7 – Privacy & Trust polish (launch readiness)

Goal: strengthen trust posture (especially for MENA privacy concerns).

### Deliverables
- Clear in-app “Privacy promise” page (what is stored locally, what is not)
- Data export/delete UX validation (works end-to-end)
- Review analytics events for PII risk

---

## Work queue (small, high-value)

- Add a short “How to use this guide” blurb at the top of pregnancy/postpartum pages (1–2 lines).
- Ensure the postpartum timeline list scrolls to the calculated current entry even when opened from other entry points (if we add more entry points later).
- Add a lightweight content lint/check script later (optional): validates JSON schema, duplicate IDs, missing weeks/months.
