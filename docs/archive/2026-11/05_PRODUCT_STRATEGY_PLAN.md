# Femio V2 — Product Strategy & Plan ("the #1 all-inclusive female health app")

## Positioning
**One account for a woman's whole health life** — puberty → cycles → conditions → TTC/IVF → pregnancy → postpartum → perimenopause → menopause — with referenced medical content, honest predictions, and verifiable privacy. Web-first (SEO-powered), 4 languages (EN/AR/FR/ES, RTL-native), later wrapped to Android/iOS on the same backend.

## Differentiators (each maps to a market pain point)
1. Lifecycle continuity (vs. fragmentation into 3–5 apps).
2. Uncertainty-honest predictions + irregular-cycle/PCOS mode (vs. accuracy complaints).
3. Condition-grade depth: PCOS, endometriosis, PMDD, fibroids, thyroid, anemia, AUB, infections, menopause, **IVF module** (vs. surface content).
4. Referenced, medically-reviewed, multilingual library (vs. clickbait content).
5. Privacy-by-design: anonymous mode, local-first option, encrypted sync, no health-data ad targeting, plain-language policy (vs. category-wide trust collapse).
6. Generous permanent free tier (vs. paywall creep).
7. Arabic/RTL + cultural options (discreet mode, faith-aware cycle guidance toggle) — MENA wedge.
8. Doctor-bridge: visit-prep summaries, exportable PDF reports, validated screeners (vs. "my doctor won't take app data seriously").

## Product surface map
**Public web (SEO engine, no login):** condition library (A–Z), symptom guides, calculators (due date, ovulation, BMI, gestational age, HRT education, contraception comparison), blog, quizzes/screeners (teasers), community previews.
**Web app (login, PWA):** dashboard per life-stage mode; trackers (cycle, symptoms 100+, mood, vitals, sleep, meds, pain map); TTC toolkit (BBT, OPK log, CM); IVF module (protocol calendar, injection reminders, appointments, results log); pregnancy mode (week-by-week, kick counter, contraction timer, checklists, weight-gain chart); postpartum (recovery, EPDS, feeding/sleep); menopause mode (34-symptom tracker, MRS score, HRT log, CBT-based program); insights & pattern engine; doctor report export; community/forum; e-commerce store.
**Admin portal:** CMS (articles, blog, guides, tips — draft→medical review→publish workflow), translation management (all UI strings + content, per-locale status, machine-translate + human review), comments/forum moderation, customer service inbox, member analytics (anonymized: age bands, conditions, retention, funnels), store management, roles & permissions (admin/editor/reviewer/translator/support), feature flags, notification campaigns.

## Monetization (as agreed)
- **Free:** trackers, basic predictions, full library, calculators, community, 1 tip/day — with tasteful contextual ads (never health-data-targeted) + affiliate (books, devices like BBT thermometers, store products).
- **Pro (~$4.99/mo, $34.99/yr):** ad-free, advanced insights & pattern engine, confidence predictions, doctor reports, condition programs (CBT menopause, PCOS program), IVF module premium tools, wearable sync, partner mode.
- **AI tier (later, ~$9.99/mo):** AI health companion chat (guardrailed, cited answers only), AI cycle insights, AI report summaries. Separate tier because of inference cost + regulatory care.
- **Store:** curated products (supplements, menstrual care, fertility, menopause) — see e-commerce advice in doc 06.
- Later: B2B2C (employers/insurers, Ovia's model), clinic partnerships (MENA telehealth referral).

## Regulatory guardrails (must-follow)
- Keep **intended purpose = wellness/education/tracking**, NOT contraception, diagnosis, or treatment → stays outside FDA SaMD / EU MDR scope. Never market fertile-window as birth control (that's Natural Cycles' regulated territory).
- GDPR: cycle data = special-category health data → explicit consent, DPIA, EU hosting option, right-to-erasure, no processor access without DPA. Also: Saudi PDPL, UAE PDPL, Egypt Law 151/2020.
- Screeners presented as "screening tools, not diagnosis; discuss with your clinician."
- Minors: teen mode with stricter privacy (no ads, no community DMs).
- App stores later: Apple 5.1.3 health rules, Google Play health apps declaration.

## Phased roadmap
**Phase 0 — Foundation (this phase):** strategy sign-off, brand & design system, architecture, repos, environments, master TODO governance.
**Phase 1 — Public site + core cycle web app (MVP launch):** condition library (first 60 articles EN + priority AR), calculators, cycle/symptom tracker PWA, accounts, i18n framework live in 4 locales, admin CMS + translation portal v1, analytics, SEO foundation.
**Phase 2 — Life-stage expansion:** TTC toolkit, pregnancy + postpartum modes, menopause mode, pattern engine, doctor reports, notifications/email, community v1, Pro subscription + payments.
**Phase 3 — Depth & revenue:** IVF module, condition programs, wearables (Health Connect/HealthKit via apps or API integrations), store (Shopify integration), affiliates, AI tier pilot.
**Phase 4 — Mobile apps:** Capacitor wrap (or Flutter shell reusing API) → Play Store + App Store, ASO, push notifications, offline sync hardening.
**Phase 5 — Scale:** B2B2C, more locales, clinic partnerships, native optimizations.

## Success metrics
North star: weekly active tracked users. Guardrails: D30 retention >25%, organic search sessions, free→Pro conversion 2–5%, content pages indexed, prediction MAE vs. actual, NPS, medical-review coverage 100%.
