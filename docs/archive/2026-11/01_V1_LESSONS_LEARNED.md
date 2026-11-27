# Femio V1 (Flutter) — Achievements & Lessons Learned
**Status: ARCHIVED — learning reference only. Do not build on this codebase.**
Archive location: `references/femio_v1_archive/`

## What V1 achieved
- Flutter app (Android/iOS/desktop targets), Clean Architecture + BLoC + Isar (local DB) + GetIt DI, ~15,000 LOC, 367 Dart files.
- 10 core features: onboarding (4 life-stage modes: Period / Pregnancy / TTC / Menopause), period tracking + calendar, cycle analysis & predictions, symptom/mood logging (17 categories), fertility/TTC (cervical mucus, fertile window), vitals (BP per AHA, weight/BMI, temperature), 40-week pregnancy guide + 12-month postpartum guide, dashboard, settings (export/import, discreet mode), freemium monetization (IAP + AdMob).
- 4 languages (EN/AR/FR/ES) via ARB files; RTL support; light/dark/OLED themes.
- 61 unit tests (100% pass), performance profiling docs, 25k-word PRD, 15k-word architecture doc, competitive analysis of 15+ apps, feature gap analysis.
- Engagement layer (M8/revamp): daily tips, achievements/streaks, kick counter, hospital bag checklist, doctor report PDF, symptom pattern engine, cycle-phase coaching, condition profiles (PCOS, endo, PMDD, thyroid, anemia), Health Connect foundation.

## Why it isn't good enough (root causes)
1. **No backend.** Everything is on-device (Isar). No accounts, no sync, no web presence, no CMS, no analytics, no admin control. Content updates require app releases.
2. **Content baked into code.** Articles/tips/guides are JSON/Dart assets — impossible to manage, translate, or grow without a developer. The opposite of "content-rich and manageable from admin."
3. **No SEO surface.** A Flutter mobile app earns zero organic search traffic; competitors (Flo, Healthline) win on web content.
4. **Firebase never configured**, DI registrations incomplete, dead buttons — signs of scope outrunning finishing discipline.
5. **Predictions are naive** (weighted average, 14-day luteal constant) — the exact thing users complain about in competitor reviews for PCOS/irregular cycles.
6. **No multilingual pipeline** — 4 ARB files edited by hand; no translation portal, no workflow.

## What to carry forward into V2
- The 4 life-stage onboarding model (Period / TTC / Pregnancy / Menopause) — validated and correct.
- Condition-profile concept (PCOS, endo, PMDD, thyroid, anemia) + doctor-visit prep + doctor PDF report — strong differentiators; keep and expand.
- The discipline rules from CLAUDE.md (no hardcoded strings/colors, no magic numbers, every feature tested, no skipping phases) — adopt as V2 engineering standards.
- The Free/Pro gating map and pricing research as a starting point.
- Medical-disclaimer policy: never present predictions as diagnosis.

## What to do differently
- **Web-first PWA + shared API backend**; mobile apps later reuse the same backend (and most of the frontend via Capacitor).
- **Headless CMS with translation workflow** — all content, strings, and articles managed from the admin portal, not code.
- **Server-side content = SEO engine** from day one.
- **Smarter predictions**: model uncertainty honestly, adapt to irregular cycles, show confidence ranges — the #1 functional complaint in the market.
- **Privacy as a headline feature**, not an afterthought (the #1 trust complaint in the market).
