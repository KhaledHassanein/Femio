# Study 10: Compliance, legal and safety

Area: `docs/compliance/`, the legal foundation and RBAC and analytics docs, the owner runbooks, and the code that enforces them.
Date: 2026-10-27. Worktree: `claude/femio-repo-study-planning-88d7c9`. This study changed nothing except the two output files.

**How to read the labels.** **Checked** = I ran a command or read the file today. **From the docs** = a docs file states it and I did not verify it. **Hypothesis** = my reading. **[NEEDS SOURCE]** = a claim with no citation I could trace. Terms of art are explained once, on first use.

**What I read in full:** all 19 markdown files in `docs/compliance/`, `docs/13_LEGAL_COMPLIANCE.md`, `docs/18_RBAC_MODEL.md`, `docs/19_ANALYTICS_EVENT_SCHEMA.md`, `docs/runbooks/OWNER_ACTIONS.md`, and `docs/archive/runbooks-2026-10/OWNER_ACTIONS_2026-10-07.md`. **Listed, not read:** `docs/compliance/NEEDS_SOURCE_TRACKER.xlsx` (binary workbook). **Read for cross-checks:** `scripts/claims-lint.mjs`, `scripts/crisis-compliance.mjs`, `apps/web/src/lib/crisis/crisis.json`, the privacy and terms pages and their message keys, the Flutter store, manifest, pubspec, onboarding and string files. **Not read, only located:** `docs/11_NEEDS_SOURCE_CHECKLIST.md`, `docs/DECISIONS.md` (ADRs are cited only through the docs), the Supabase migrations and Edge Functions, `scripts/security/rls-audit.mjs`, `scripts/dev/partner-sharing-check.mjs`, `apps/web/src/lib/analytics/events.ts`.

---

## 1. Purpose in one paragraph

This area holds the rules Femio must obey before a person can safely use it: which health thresholds and wording are allowed, what the app may claim, what data it may keep and where, what Google Play and the data-protection laws ask for, and what to show when someone may be in danger. Its core job is to keep Femio in the "wellness, education and tracking" lane, outside medical-device rules, and to keep health data away from advertisers and analytics vendors. The current direction (decision D7, accepted 2026-10-07 in the owner runbook) is a **private Android app**: records stay on the phone, there are no accounts, and the website is a teaser. Most of `docs/compliance/` still describes the earlier **cloud-account design**, so it needs partial rewriting. The checklist for the private v1 is **Appendix A**. Crisis resources are in **Appendix B**.

---

## 2. Inventory table

Every file in `docs/compliance/` is listed, plus the governing docs and runbooks in scope. Status set: live, app-only (closed web tracker), dead, duplicate, unknown. "Live" here means the file governs current code or current plans.

| path | lines | one-line purpose | status |
|---|---|---|---|
| docs/compliance/PRIVATE_LAUNCH_V1.md | 139 | The D7 plan: records on the phone, no accounts, what law still applies, six questions for counsel | live (header still says "proposed") |
| docs/compliance/MENSTRUAL_SAFETY_THRESHOLDS.md | 145 | Absent-period, heavy-bleeding, adolescent and energy-shortage wording and numbers | live |
| docs/compliance/PREGNANCY_BP_SAFETY.md | 50 | Blood-pressure reference points in pregnancy, aspirin and postpartum wording | live |
| docs/compliance/CONTRACEPTION_SAFETY.md | 57 | Missed pills, return of fertility, migraine with aura, breastfeeding method, folic acid | live |
| docs/compliance/FERTILITY_AWARENESS_SAFETY.md | 49 | Trying-to-conceive wording, when to suggest evaluation, pregnancy-test timing | live |
| docs/compliance/ENDOMETRIOSIS_CONTENT_SAFETY.md | 47 | Endometriosis wording, required footer, banned words | live |
| docs/compliance/REPRODUCTIVE_TREATMENT_SAFETY.md | 61 | Miscarriage, fertility-treatment complications, early menopause, loss and milk-stopping wording | live |
| docs/compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md | 45 | Master claims rules, store-policy baseline, reproductive-data rules | live |
| docs/compliance/MENTAL_HEALTH_SCREENERS.md | 114 | Which questionnaires may be used, scoring, licence and attribution rules | live |
| docs/compliance/CRISIS_RESOURCES.md | 122 | Single source for crisis wording, directory policy, acceptance criteria | live |
| docs/compliance/DATA_MAP.md | 75 | Field-by-field record of health data and why it is held | live (describes the cloud schema, not the private build) |
| docs/compliance/PROCESSOR_REGISTER.md | 29 | Who processes data, agreement (DPA) and region status | live (statuses conflict with other docs, see section 8) |
| docs/compliance/DPIA.md | 90 | Data protection impact assessment, skeleton; partner-sharing risks added 2026-08-23 | live (skeleton; DPO not appointed) |
| docs/compliance/BREACH_RUNBOOK.md | 44 | 72-hour breach steps; roles blank | live (skeleton) |
| docs/compliance/SECURITY_REVIEW.md | 98 | Engineering security review of the website and Supabase layer | live (website scope) |
| docs/compliance/PARTNER_SHARING_DESIGN.md | 168 | Consent design for sharing one's record with a partner (built, web only) | app-only (closed web tracker) |
| docs/compliance/THROUGHLINE_LINK_CONFIRMATION.md | 87 | Draft email asking the crisis directory to confirm the link; owner's residual-risk approval | live (email not sent) |
| docs/compliance/P0_12_LEGAL_INTAKE_FORM.md | 141 | Blank questionnaire for owner and lawyer: entity, contacts, DPO, ages | live (blank) |
| docs/compliance/NEEDS_SOURCE_REVIEW_BRIEF.md | 16 | Brief for clearing the source-check flags | live |
| docs/compliance/NEEDS_SOURCE_TRACKER.xlsx | binary, 132 KB | Source-check workbook (not read) | unknown |
| docs/13_LEGAL_COMPLIANCE.md | 113 | Legal foundation of 2026-07-16; drafts for counsel; partly superseded by PRIVATE_LAUNCH_V1 | live (partly superseded) |
| docs/18_RBAC_MODEL.md | 69 | Staff roles (admin, editor, medical reviewer, translator, support) for the content and web back office | app-only (closed web tracker) |
| docs/19_ANALYTICS_EVENT_SCHEMA.md | 144 | Closed list of allowed analytics events and the rules that enforce it | live (schema; no vendor connected) |
| docs/runbooks/OWNER_ACTIONS.md | 43 | Owner's list of manual actions, rewritten 2026-10-27; drops the lawyer and DPO | live |
| docs/archive/runbooks-2026-10/OWNER_ACTIONS_2026-10-07.md | 125 | Earlier owner runbook: lawyer brief, DPO, crisis sign-off, Egypt licensing date, purge decision | dead (superseded 2026-10-27; kept for its legal questions) |

Code and config that enforce these rules are in section 3 and in section 4.

---

## 3. Key rules the product must obey

Each block lists the rule, its source, and what the code shows. Thresholds are the numbers from the docs; they are prompts to talk to a clinician, not diagnoses.

### 3.1 Menstrual and energy thresholds (MENSTRUAL_SAFETY_THRESHOLDS.md)

Reviewer named: "Mohamed K.", reviewed 2026-07-23, next review 2027-07-23 (From the docs).

- **No period.** Always consider pregnancy first. Secondary amenorrhea (no period after having had one) needing review: more than **3 months** without a period after regular cycles, or **6 months** after irregular cycles (ASRM 2024). Suspected hypothalamic amenorrhea (no period from energy strain): clinical review if cycles persistently exceed **45 days**, or no period for **3 months or more** (Endocrine Society 2017). Amenorrhea means absence of periods. FHA means functional hypothalamic amenorrhea.
- **Bone wording.** Never tell someone to get a scan. A clinician may consider a bone-density (DXA) assessment after 6 or more months without a period. Femio may say only: "a clinician may consider bone-health assessment based on duration and risk factors."
- **Energy shortage in sport (REDs).** No kcal, body-fat or "safe/unsafe" cut-offs shown to anyone, especially minors (IOC 2023).
- **Heavy bleeding.** Use the NICE definition (bleeding that affects quality of life); no numeric blood-loss estimate required. The PBAC (a pictorial bleeding score) may be recorded for a clinician, but Femio must not display the ≥100 or ≥150 cut-offs and needs the instrument's permission before reproducing any chart.
- **Routing prompts.** Bleeding longer than 7 days; needing a new product in under 2 hours; soaking one every hour for several hours; clots about **2.5 cm** or larger. These mean "discuss with a clinician," not a triage rule. Very heavy bleeding with fainting, marked weakness, chest pain or breathlessness means urgent assessment.
- **Adolescents.** Typical cycles 21–45 days, periods 7 days or fewer (ACOG). Calm check-in prompt if no period by age **15**, or no breast development by **13**, or no period within **3 years** of breast development starting. PCOS irregular-cycle rules (2023 international guideline): 1 to under 3 years after the first period, cycles under 21 or over 45 days; from 3 years on, under 21, over 35, or fewer than 8 cycles a year; any single cycle over 90 days after the first post-period year. Adolescent PCOS is not diagnosed from pelvic ultrasound or AMH (a blood test for ovarian reserve).

### 3.2 Pregnancy and postpartum blood pressure (PREGNANCY_BP_SAFETY.md)

- **Measuring.** Upper-arm validated monitor, correct cuff, rest 5 minutes, back supported, feet flat, two readings a minute apart, both recorded (AHA).
- **Reference points** (fixed educational text only; never applied to an entered reading): **140/90 mmHg** = hypertension in pregnancy (NICE NG133) and the ACOG medication-start threshold (CHAP advisory 2022, reaffirmed 2025); **160/110 mmHg** = severe (NICE; ACOG); **135/85 mmHg** = NICE treatment target.
- **Warning symptoms** that need prompt contact: severe headache, vision changes, upper-abdominal pain, swelling of face or hands, difficulty breathing (ACOG; CDC Hear Her).
- **Aspirin.** No single global dose. USPSTF 2021 specifies 81 mg daily from 12 weeks for high-risk people; NICE specifies 75–150 mg from 12 weeks for certain groups. Femio may explain that a clinician sometimes prescribes low-dose aspirin, and must not publish a dose or start or stop date.
- **Postpartum.** Blood-pressure check no later than **7–10 days** after birth for a hypertensive disorder of pregnancy; within **72 hours** if severe (ACOG Committee Opinion 736). CDC warning signs apply during pregnancy and for one year after delivery.
- **Emergency routing.** Ask for the user's maternity-unit contact; show official emergency numbers only by country selection; fallback copy: "Seek immediate medical care now. Contact your maternity unit or local emergency services. If you cannot reach them, go to the nearest emergency department."
- **Code.** Checked: no systolic, diastolic or mmHg logic found in `apps/web/src` or `apps/mobile/lib`. Blood-pressure tracking is not in the Flutter app. The rule is documentation only for now.

### 3.3 Contraception wording (CONTRACEPTION_SAFETY.md)

- **Missed or late doses.** No universal decision tree. Point to the leaflet supplied with the product, and to a pharmacist or clinician. Emergency contraception is time-sensitive; Femio does not decide eligibility or residual pregnancy risk.
- **Return of fertility.** Never promise a date for a period, ovulation or pregnancy. After pills, implant or intrauterine device: no clinically important delay (FSRH 2019). After the DMPA injection: return can take up to about **one year** (FSRH 2014, amended 2023).
- **Migraine with aura.** CDC U.S. MEC 2024 classes combined hormonal contraception as **category 4** (unacceptable risk) for migraine with aura. Femio may show that fact and advise a prompt clinician conversation. It must not call a method "safe" or "unsafe" for a person.
- **Breastfeeding method (LAM).** All three criteria are required: no period, almost-exclusive feeding with gaps of no more than 4 hours by day and 6 hours by night, under 6 months postpartum. Femio explains the criteria and never gives a verdict. Pumping has no separate rule in the cited CDC appendix.
- **Folic acid.** WHO: 400 micrograms daily from when trying to conceive through 12 weeks of pregnancy. Higher doses are clinician-directed.

### 3.4 Fertility awareness (FERTILITY_AWARENESS_SAFETY.md)

- The fertile window is the 6 days ending on ovulation day. Basal body temperature (a waking temperature) is mostly looks-back-only, not a forecast.
- Intercourse every 1–2 days in the window gives the highest pregnancy rates; 2–3 times a week is nearly as good. No pressure, no "one missed day loses the cycle."
- Lubricants: do not quote laboratory sperm-movement results as a real-world effect (prospective studies found no fertility effect). No brand endorsement.
- Caffeine: about 1–2 cups a day shows no apparent harm (ASRM). No milligram cut-off.
- **When to suggest evaluation:** after 12 months trying if the partner is under 35; after 6 months if 35 or older; sooner over 40; at once if there is a known cause (irregular or absent cycles, suspected endometriosis, a treatment that may reduce fertility).
- **Never hard-code "day 21"** for a mid-luteal progesterone test; timing is individual. No universal AMH, FSH or antral-follicle cut-offs. Clinician-provided results may be stored, never labelled.
- **Pregnancy tests.** They detect hCG. Testing after the first day of a missed period is generally more accurate. No "97–99% accurate" promise.
- **Emotional safety.** Ban "just relax," "stress is stopping you," "it will happen when you stop trying." There is no conclusive evidence that stress alone prevents conception.

### 3.5 Endometriosis (ENDOMETRIOSIS_CONTENT_SAFETY.md)

- **Required footer (exact):** "Femio helps you track symptoms and prepare for a clinician conversation. It does not diagnose, stage, treat, or manage endometriosis."
- **Required on fertility prediction surfaces (exact):** "Predictions are estimates, not guarantees, and are not a method of birth control."
- **Banned words:** cure, reverse, detox, diet-as-cure, "safe day," "infertile day," any claim that a normal scan excludes endometriosis.
- No stage-specific or Endometriosis Fertility Index probabilities, no post-surgery conception window, no labelling pain as ovulation or as a flare.
- Checked: the required footer sentence and the required prediction sentence are **absent** from `apps/web/messages/en.json` and `apps/mobile/lib/l10n/app_en.arb` (grep, no matches).

### 3.6 Reproductive treatment, loss and early menopause (REPRODUCTIVE_TREATMENT_SAFETY.md)

- **Antiphospholipid syndrome (APS).** Clinician-managed low-dose aspirin plus heparin can help. No dose offered.
- **Progesterone for miscarriage.** NICE NG126 limits it to a scan-confirmed intrauterine pregnancy with bleeding and a history of miscarriage.
- **Ovarian hyperstimulation syndrome (OHSS, an overreaction to fertility drugs).** Contact the fertility clinic promptly for new or worsening symptoms. Seek urgent local care for breathing difficulty, chest pain, a swollen or tender leg, severe or worsening abdominal pain, persistent vomiting, or markedly reduced or dark urine. Femio does not grade severity.
- **Premature ovarian insufficiency (POI).** ASRM 2024: disordered cycles for at least 4 months and FSH above **25 IU/L**, repeat after 4–6 weeks if unsure. NICE NG23 uses two samples 4–6 weeks apart. Both say AMH is not a substitute. Femio never declares POI from one result, and never tells anyone to stop hormone therapy to test. HRT is not contraception.
- **Loss terms.** CDC uses 20 weeks for stillbirth in US public guidance; WHO compares internationally at 28 weeks and uses national definitions where relevant. Neonatal death is death of a live-born baby within 28 days. Use the user's own term.
- **Milk-stopping.** Cabergoline is never recommended or dosed by Femio.

### 3.7 Mental-health screeners (MENTAL_HEALTH_SCREENERS.md)

- **Universal rules.** A score is a screen, not a diagnosis. Use only the complete, unmodified instrument in a validated language version. Show the name, source, attribution, scoring basis, date and version. Store consent separately from the result. A high score routes to follow-up; it does not by itself establish suicide risk.
- **GAD-7** (anxiety, 0–21): bands at 5, 10, 15; 10 is a reasonable point for further evaluation (Spitzer 2006). It has **no self-harm item**, so it must never be the only trigger for an emergency route.
- **EPDS** (postnatal depression, 10 items): no universal threshold. Conservative global presentation: show the score without a label and route to clinician follow-up. A health-system module may use its own reviewed threshold. NSW example (not a universal rule): 10–12 monitor, 13 or more assess further. A positive item 10 (self-harm) needs immediate assessment.
- **PHQ-9** (depression, adults): item 9 is the self-harm item. Adolescent use is blocked until a clinician-supported workflow, validated version and self-harm response are approved.
- **Excluded pending permission:** SCOFF (BMJ copyright; no shortened or "-style" copies), DRSP (no item copies), and exact DSM wording.
- **Code.** Checked: `apps/web/src/lib/screeners/epds.ts` (line 135) and `mood.ts` (line 118) return the self-harm item as a separate flag that no total can mask. Checked: `messages/en.json` and the screener components contain **no attribution or copyright text** for EPDS, PHQ-9 or GAD-7. Whether the Arabic, French and Spanish versions are validated is **not stated** in the docs.

### 3.8 Crisis routing (CRISIS_RESOURCES.md, crisis.json)

- **Global fallback text** is reproduced verbatim in Appendix B. Never add promises about cost, confidentiality, hours or language. Never present a US or UK number as global.
- **Directory.** Find A Helpline (findahelpline.com), a single plain outbound link (canonical host, no query string, `referrerPolicy` no-referrer), covering 175+ countries (From the docs). The owner accepted the residual risk on 2026-08-03; the written confirmation from the directory has **not** been sent.
- **Acceptance criteria** (From the docs): (1) "Need help now?" is always reachable, not gated by a questionnaire total; (2) a self-harm answer uses the urgent route regardless of total; (3) country and language are separate, explicit settings; (4) emergency services are visually separate from support services; (5) if the directory is down, the global fallback stays visible; (6) translations, including Arabic RTL, get human linguistic review.
- **Code.** Checked: `scripts/crisis-compliance.mjs` passes (expiry 2027-07-23 and 2027-08-11; key parity across en, ar, fr, es). The ar, fr and es copy is marked approved by the owner on 2026-08-11 (crisis.json). Checked: **no crisis or help-now route exists in `apps/mobile`** (the Flutter app).

### 3.9 Claims language (HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md, scripts/claims-lint.mjs)

- **Intended use.** Wellness, education, tracking, organising the user's own entries, and preparing for a clinician. Not: diagnose, stage, predict disease, rule out, treat, cure, prevent, act as contraception, or name a day when pregnancy cannot happen.
- **Banned by the docs** (beyond the lint list): "safe day," "infertile day," "cannot get pregnant today," efficacy of pregnancy avoidance, instructions to stop or switch contraception, "cure," "reverse," "detox," "safe for you."
- **Medication reminders** reproduce only a schedule the user or a clinician entered. No default dose, no "safe for you."
- **Lint.** `scripts/claims-lint.mjs` bans, as whole words: diagnose and its forms, cure(s/ing), treat(s/ing/ment), prevent(s/ing), contracept(ion/ive/ives), birth control. It scans **only** the English catalogue values in `apps/web/messages/en.json` (lines 14–18: `SCAN_LOCALES = ["en"]`). It does not scan ar, fr or es, the Flutter ARB files, `crisis.json`, or CMS content (its own header says that is pending, P1.6). Checked: it passes today.
- **A conflict to resolve.** `docs/13_LEGAL_COMPLIANCE.md` §4 wants the terms to say "it is **not a contraceptive**", but the lint bans the word "contraceptive" in any value. Either add a reviewed exception (the lint header allows one) or reword the sentence.

### 3.10 Consent, sharing and analytics rules (docs/13 §3, §5b, §6; DATA_MAP; DPIA; PARTNER_SHARING_DESIGN; docs/19)

- **Explicit consent before the first health field is stored**, per purpose: core, insights, research (docs/13 §3; DATA_MAP legend). Checked: the Flutter app has **no consent step** (grep for "consent" in `apps/mobile/lib` returns nothing). Whether local-only storage triggers this rule is an open question (section 10).
- **Analytics** is a separate opt-in purpose (`analytics`, migration 0005). No consent screen exists, so nothing is sent (From the docs; PostHog key is unset).
- **Analytics catalogue** (docs/19; From the docs and file list): closed enum; no article slugs, no calculator names, no life stage, age band or condition tags; autocapture and session recording off; crisis surface never tracked; EU host enforced. `apps/web/src/lib/analytics/events.ts` and `guard.ts` exist (Checked by path).
- **Partner sharing** (built on the website, ADR-068 per the docs): opt-in per category; screener results, crisis surface and appointment questions can **never** be shared; no "share everything"; grants expire after 6 months; revocation is silent; a withheld category is absent, not shown as hidden; not offered under 18; unknown age counts as under 18. Gates still open: docs/13 §5 disclosures section and DPO sign-off on the Article 9(2)(a) consent wording (PARTNER_SHARING_DESIGN §Status).
- **Data-subject rights** (docs/13 §3; From the docs): access, export, correction, deletion, withdrawal, objection; target 72 hours. In the private v1 the user saves an export file herself.
- **Breach.** Notify the supervisory authority within 72 hours where there is risk; notify individuals without undue delay where risk is high (GDPR Art. 33–34, as cited in BREACH_RUNBOOK). The runbook is still a skeleton with blank roles.

### 3.11 Modules that carry these rules (existence and behaviour)

- `apps/web/messages/en.json` (`privacy`, `terms`, `epds`, `moodScreeners`, `fertility`-related keys): English master copy. Checked: the privacy and terms keys exist in en, ar, fr and es.
- `apps/web/src/app/[locale]/(public)/privacy/page.tsx` and `terms/page.tsx`: draft pages, `robots: { index: false }` (privacy line 20, terms line 18). Checked. Both pull all text from messages; no literal copy (checked by reading).
- `apps/web/src/lib/web-app.ts` (line 13): the website's sign-in and tracker are gated by `NEXT_PUBLIC_WEB_APP_ENABLED === "1"`. Checked. Production setting is From the docs (D8).
- `apps/mobile/lib/features/onboarding/onboarding_flow.dart` (line 20): an `under18` step; `apps/mobile/lib/l10n/app_en.arb` line 24 has the under-18 body text. Checked.
- `apps/mobile/lib/data/store.dart`: `FileStore` writes `femio-record.json` in the app support directory (line 23); `clear()` exists. Checked.
- `scripts/analytics-lint.mjs`, `scripts/security/rls-audit.mjs`, `scripts/dev/partner-sharing-check.mjs`: exist (Checked by path); not run in this study.

---

## 4. Data flow

**Where data enters.**
- Flutter Android app: onboarding (birth year, language, the under-18 stop), the log screens, the calendar and fertile-window view, the contraction timer, the movement log, weight, appointments, and mood entries (Checked by file list).
- Website: calculators and articles (public); sign-in, tracker and screeners exist in code but are closed in production (From the docs, D8).

**Where it is stored.**
- **Flutter v1:** one JSON file, `femio-record.json`, in the app's private support directory (`store.dart` line 23). Android encrypts app data at rest only through device file-based encryption. App lock and Keystore encryption are deferred to **P3.8** (store.dart lines 17–19; From the code comment).
- **Website and Supabase:** the project is in the EU (**eu-west-1, Ireland**, "verified via the connector 2026-10-07", PRIVATE_LAUNCH §2; From the docs). Owner-only row-level security (a database rule that each person sees only their own rows) and consent-gated inserts (SECURITY_REVIEW §1–2; From the docs). The archive lists **443 accounts** in the production project on 2026-10-07, of which **442 anonymous**, and says 228 hold test data (archive, C6c). Current state: unknown.

**Where it leaves the device.**
- **Flutter release build:** nothing. Checked: no `http` or `https` address in `apps/mobile/lib` outside the translation files; the main `AndroidManifest.xml` declares no `INTERNET` permission; `pubspec.yaml` depends only on Flutter, `flutter_localizations`, `intl` and `path_provider`. Caveat: debug and profile manifests are not checked here, and a release-build test is missing (section 7).
- **Website and external services** (From the docs unless marked):
  - **Supabase** (EU): database, auth, storage. Processor agreement not signed (PROCESSOR_REGISTER: "☐ sign").
  - **Vercel:** hosting; region "choose EU" and status "planned" in the register, but the site is live on Vercel (the repo's CLAUDE.md, "Current status"). Register is out of date.
  - **Vercel Web Analytics** (cookieless page counts): planned in PRIVATE_LAUNCH §3; **not in the processor register**.
  - **Sentry:** error reports; EU-only DSN enforced and health-scrubbed (SECURITY_REVIEW §5 and ADR-026 per the docs). Register says "planned"; agreement not signed.
  - **PostHog (EU):** agreement signed 2026-08-16; **not connected** (no key set; PROCESSOR_REGISTER).
  - **Google sign-in:** the archive says "Google sign-in live" (2026-10-07); **not in the processor register**.
  - **Resend** (email), **DeepL** (translation drafts of UI strings, no user data): planned.
  - **Paddle, Stripe** (billing, Phase 2): the register lists "Stripe / Paddle". **Conflict:** the owner's global rule says Stripe is not available and must never be suggested.
  - **Shopify** (store, Phase 3).
  - **Find A Helpline / ThroughLine:** one outbound link; no data sent by Femio.
  - **Google Play** (distribution and Data safety form).

**Data that should leave but is not documented.** The Flutter pubspec has no crash or analytics SDK (Checked), so PRIVATE_LAUNCH §3's "Sentry with IP storage off" for the app is a plan, not code.

---

## 5. Dependencies

**Cross-references between the docs.**
- `docs/13` → DATA_MAP, PROCESSOR_REGISTER, DPIA, BREACH_RUNBOOK (From the docs).
- `PRIVATE_LAUNCH_V1` → docs/13 §3–§6, OWNER_ACTIONS (D7), P0_12 intake (From the docs).
- `CRISIS_RESOURCES` → copied verbatim into `apps/web/src/lib/crisis/crisis.json` (the JSON header says so; Checked).
- `MENTAL_HEALTH_SCREENERS` → CRISIS_RESOURCES (From the docs).
- `PARTNER_SHARING_DESIGN` → DPIA, PROCESSOR_REGISTER, docs/13 §5b (From the docs).
- `THROUGHLINE_LINK_CONFIRMATION` → CRISIS_RESOURCES directory policy (From the docs).
- `docs/runbooks/OWNER_ACTIONS.md` → PRIVATE_LAUNCH_V1, and the archive for the removed items (From the docs).

**What the code reads.**
- `scripts/claims-lint.mjs` reads `apps/web/messages/en.json` (Checked).
- `scripts/crisis-compliance.mjs` reads `apps/web/src/lib/crisis/crisis.json` (Checked).
- `package.json` gate script runs claims-lint, crisis-lint and analytics-lint in CI (Checked).
- The privacy and terms pages import `TrustPage` and `localizedAlternates` (Checked).

**What imports this area.** The crisis components and `help-now` route (From the docs; the component files exist, Checked by path); the screeners (`epds.ts`, `mood.ts`, Checked); the Flutter onboarding `under18` step (Checked).

---

## 6. Strings and i18n

- **Crisis copy.** `crisis.json` has four locales: en (reviewed by Mohamed K., 2026-07-23), and ar, fr, es (reviewed by "Dr Khaled Hassanein (owner, clinician, Arabic speaker)", 2026-08-11) (Checked). The directory policy asks for human linguistic review of Arabic and RTL layout (From the docs). Owner review is recorded; an independent linguistic check is not.
- **Privacy and terms.** Keys exist in all four locales (Checked). The text is the English-first draft that describes the cloud-account product (section 8). Translations of the draft were not reviewed here.
- **Hard-coded text.** The privacy and terms pages hold no literal copy (Checked). I did not read the crisis components or the screener components for literal strings; that is outstanding.
- **Flutter.** ARB files exist for en, ar, fr, es (Checked). Compliance-relevant English keys: `privacyLine` "Stored on this phone only." (app_en.arb line 72); `awarenessNote` "Estimates for awareness and planning, not a way to avoid pregnancy." (line 70); `under18Body` (line 24); `pregRedFlagsBody` (lines 282–283); `movementsUrgentBody` (lines 318–319); contraction copy (lines 284–290). Parity across the four ARB files was not checked.
- **Claims lint** does not scan any of these (section 3.9).

---

## 7. Tests and guards

**Run today (Checked):**
- `node scripts/claims-lint.mjs`: passes, exit 0 ("no forbidden clinical claims in UI copy", English only).
- `node scripts/crisis-compliance.mjs`: passes, exit 0 (expiry, metadata, key parity).

**Exist, not run in this study:**
- `scripts/analytics-lint.mjs` (CI; From the docs it passes).
- `scripts/security/rls-audit.mjs`: manual gate, 12 of 12 passed on 2026-07-24 (SECURITY_REVIEW §2, From the docs).
- `scripts/dev/partner-sharing-check.mjs`: 20 assertions, per PARTNER_SHARING_DESIGN (From the docs).
- Unit tests named by the code: `apps/web/src/lib/screeners/epds.test.ts`, `mood.test.ts`, `apps/web/src/lib/crisis/directory.test.ts` (existence Checked; contents not read). Flutter tests under `apps/mobile/test` (existence only).

**Not tested or guarded (no guard found):**
- The mandated prediction sentence and the endometriosis footer: no guard; both are absent today (Checked).
- Banned phrases beyond the lint list ("safe day," "infertile day," "reverse," "detox," "safe for you"): none is in `en.json` or `app_en.arb` today (Checked), but nothing stops them.
- The Flutter crisis route: absent, so nothing to test.
- "No network in the Flutter release build": no test. A test that fails if an `INTERNET` permission or an HTTP client appears would make the promise checkable.
- Privacy and terms text against the data map: no check.
- Blood-pressure reference points: no code, so nothing to test; the docs are the only control.

---

## 8. Smells, risks and contradictions

Severity: **High** = would mislead a user, break a stated promise, or miss a legal step before launch. **Medium** = needs fixing before the relevant feature ships. **Low** = tidy-up.

**High**

- **H1. The Egypt licensing deadline and the lawyer have been dropped from the live plan, while the compliance docs say the Egypt answer needs counsel.** The archived runbook says Egypt's data-protection licensing for health data is "enforced from 31 October 2026" (archive intro) and gives no source; [NEEDS SOURCE]. Today is 2026-10-27, four days before that date. The current runbook (2026-10-27) replaces the lawyer and DPO with "a short regulatory note that a session drafts from the published laws" (OWNER_ACTIONS, "Moved, not dropped"). PRIVATE_LAUNCH_V1 §2 and §6 say Egypt's answer needs an Egypt-qualified lawyer. These two positions cannot both stand; this is for the owner to decide, and it is the most time-sensitive item in this study.
- **H2. The privacy and terms drafts describe the cloud-account product, not D7.** `apps/web/messages/en.json` `privacy.points` says: accounts with email, age band, "Our database and hosting provider is the only one that holds health data", "EU database", "export and delete are buttons in the app", and "Teen accounts" with guardian consent. None of that matches the private v1. Publishing them as they stand would misdescribe the product.
- **H3. A public claim the code does not yet support.** `privacy.points` ("Security") says "Data is encrypted in transit and at rest." SECURITY_REVIEW §5 lists Supabase at-rest encryption as an open confirmation. The Flutter store relies on device encryption and defers app-level encryption to P3.8 (store.dart lines 17–19).
- **H4. Old health data is still in the production database.** The archive records 442 anonymous accounts, 228 holding test data, and an owner decision pending on purging them (C6c). The 2026-10-27 runbook is silent. A "we hold nothing" private launch needs this decided and executed.
- **H5. The Flutter v1 app has no crisis route.** CRISIS_RESOURCES criterion 1 requires "Need help now?" to be reachable. No `crisis` or `help now` text exists in `apps/mobile/lib` (Checked). The Flutter app does take free text: a text field on the log screen (`apps/mobile/lib/features/log/log_screen.dart` line 270) and appointment fields including visit questions (`appointments_screen.dart` lines 259–269; Checked). Free text can disclose risk, so this is a gap unless the owner decides otherwise (question Q5).
- **H6. Required safety sentences are absent.** The mandated prediction sentence ("Predictions are estimates, not guarantees, and are not a method of birth control.") and the endometriosis footer are not in `en.json` or `app_en.arb` (Checked). The Flutter `awarenessNote` (app_en.arb line 70) is close but is not the mandated wording.
- **H7. Unsourced prevalence-style claims in support text.** `epds.support.body` says "Thoughts of harming yourself are more common after birth than most people are told"; `moodScreeners.support.body` says "Thoughts like that are more common than most people are told." Both are shipped copy with no citation. The docs forbid unsourced prevalence language. [NEEDS SOURCE]
- **H8. Pregnancy red-flag and fetal-movement wording has no source in the docs.** `app_en.arb` lines 282–283 list bleeding, severe headache, vision changes, severe abdominal pain, reduced movements. Lines 318–319 tell her to contact the maternity team now if movements are less than usual. PREGNANCY_BP_SAFETY lists a different set (severe headache, vision changes, upper-abdominal pain, swelling of face or hands, difficulty breathing). The Flutter copy is plausible but has no citation in `docs/compliance`. [NEEDS SOURCE]
- **H9. No country crisis or emergency numbers for the launch markets.** D4 names Saudi Arabia and Egypt as launch markets. No file in the repo gives an emergency or crisis number for either country, and the policy forbids numbers without re-verification (CRISIS_RESOURCES). That is correct as a rule, but it means the local route currently rests on the generic fallback alone. A verified local source is needed. I have not supplied numbers from memory.

**Medium**

- **M1. The processor register contradicts other files.** Sentry: "planned", but SECURITY_REVIEW §5 says wired 2026-08-03 with an EU DSN. Vercel: "planned", but the site is live. Stripe appears in the Stripe/Paddle row, but the owner's rule (global CLAUDE.md) says Stripe is not available for an Egypt-based seller. Vercel Web Analytics and Google sign-in are missing. (PROCESSOR_REGISTER lines 11–16; Checked.)
- **M2. The claims lint is narrow.** English only; no ARB, `crisis.json` or CMS scan; banned list lacks the phrases in section 3.9. Checked: the lint's own header says it scans "the English UI message catalogs lexically"; CMS coverage is "P1.6."
- **M3. Terms draft omits a required sentence.** docs/13 §4 requires "it is not a contraceptive." The terms draft in `en.json` has no such sentence (Checked: no "contracept" word in its values). Adding it collides with the lint (section 3.9).
- **M4. DATA_MAP is out of date for the Flutter app.** The map's rule says every new field is added in the same change. The Flutter record holds `birthYear`, `locale`, an after-birth stage flag and contraction and movement logs (`profile.dart`, `domain/contractions.dart`; Checked). None appears in DATA_MAP.
- **M5. No wellness disclaimer in the Flutter app.** Grep for "medical device," "wellness," "not medical" returns nothing in `apps/mobile/lib` or `app_en.arb` (Checked). The footer exists only in the website drafts.
- **M6. Teen wording contradicts the 18+ launch.** PRIVATE_LAUNCH §3 says the tracker is 18+ at launch and Play audience is 18+; the privacy and terms drafts describe teen accounts with guardian consent.
- **M7. No backup or export in the Flutter app.** Grep for "backup" and "export" in `apps/mobile/lib` returns nothing (Checked). PRIVATE_LAUNCH §3 makes a user-saved file the backup. Without it, losing the phone loses the record, which PRIVATE_LAUNCH itself calls out.
- **M8. Screener attribution and licences are missing.** No attribution or copyright text for EPDS, PHQ-9 or GAD-7 (Checked). The GAD-7 licence is "to confirm" (MENTAL_HEALTH_SCREENERS). Whether the Arabic EPDS is a validated version is not stated. The website is closed in production (From the docs), so this is not live now, but it would ship with a reopening.
- **M9. Consent versus local storage.** docs/13 §3 and DATA_MAP require explicit consent before the first health field is stored. The Flutter app stores health fields with no consent step. Either the rule is applied or the docs record why local-only storage is out of its scope. [Hypothesis: the docs do not settle this.]
- **M10. The medical reviewer's identity is unclear.** Every threshold file names "Mohamed K." as reviewer, with no credentials in the repo. The 2026-10-27 runbook says Khaled is the only clinical reviewer. The archive (B1) asked for a named clinician with credentials. Two accounts of who signed off.
- **M11. No DPO, and the breach runbook is a skeleton.** DPIA §5 is unsigned; P0.12 §3 blank; BREACH_RUNBOOK roles blank. The 2026-10-27 runbook removes the DPO.
- **M12. Primary legal sources missing.** Saudi PDPL: no primary text is cited anywhere in the docs ([NEEDS SOURCE]). Egypt 151/2020 and its 2025 Executive Regulations: cited through law-firm summaries; PRIVATE_LAUNCH says "Official Arabic text not retrieved." UK: ICO guidance cited through a law-firm summary, with a counter-view from Chino.io. The conclusions drawn from these are the docs' own.
- **M13. Egypt terms are not consistent.** docs/13 says "registration with the Egyptian Data Protection Center" and mentions a DPO; PRIVATE_LAUNCH says a controller **licence** and a local representative, possibly fee-free for 1–100,000 records. Both are From the docs, neither verified.
- **M14. "Health data not collected" on the Play Data safety form.** PRIVATE_LAUNCH §4 relies on this. Play's own definition of "collected" is not quoted in the docs. [Hypothesis: it may depend on whether data leaves the device; check Play's page before submission.]
- **M15. Contraction timer has no compliance document.** `domain/contractions.dart` and the timer screen are careful ("It does not decide whether this is labour," no 5-1-1 rule), but no file in `docs/compliance` governs labour-related routing (Checked).
- **M16. Website "encrypted" and cookie claims are not in the register.** PRIVATE_LAUNCH §4 says cookies are essential only, so no banner is needed under UK PECR and EU ePrivacy. From the docs; not verified in code.

**Low**

- **L1. Source-check count mismatch.** The brief says 432 flags; the repo's CLAUDE.md says 454 in `11_NEEDS_SOURCE_CHECKLIST.md`. Not read here.
- **L2. Status drift.** PRIVATE_LAUNCH's header says "proposed as D7 ... awaiting the owner's yes"; OWNER_ACTIONS says D7 accepted 2026-10-07.
- **L3. Partner sharing exists in the back end.** The `partner-view` Edge Function and `partner_links` table are live-verified (PARTNER_SHARING_DESIGN). PRIVATE_LAUNCH says partner sharing is off in v1. The app has no partner screen (Checked), so the risk is limited to the web, which is closed in production (From the docs).
- **L4. The cycle code uses 21–35 days as a stated-baseline range** (`apps/web/src/lib/cycle/predict.ts` line 188; `phases.ts` line 62 uses 21 as the minimum). No compliance document lists that range or cites it. [Hypothesis: a source should be added; the docs give 21–45 for adolescents and 21–35 is widely quoted, but I have not checked it.]
- **L5. The ThroughLine terms analysis** (CRISIS_RESOURCES, dated 2026-08-03) is marked as an engineering analysis, "not legal advice," with the DPO to countersign. The owner accepted it. The written confirmation is drafted but not sent.
- **L6. Dead material.** The archived runbook is dead by design (superseded), but it holds the only text of the counsel brief and the Egypt date.
- **L7. The RBAC document** is for the staff roles of a back office the docs say will be retired (D3 retires Payload CMS). Its Payload parts will go stale.

---

## 9. Keep, rebuild or delete verdict

Judged against the direction: private Android app, records on the phone, no runtime Supabase, wedge = Arabic-first TTC to pregnancy, Saudi and Egypt.

- **PRIVATE_LAUNCH_V1.md:** Keep. This is the governing plan. Update its header status to "accepted D7, 2026-10-07."
- **MENSTRUAL_SAFETY_THRESHOLDS.md:** Keep. The rules apply to any app. Confirm the reviewer's identity and credentials.
- **PREGNANCY_BP_SAFETY.md:** Keep as a reference. Nothing to build until blood-pressure logging is added.
- **CONTRACEPTION_SAFETY.md:** Keep. Apply it to the Flutter calendar and fertile-window copy.
- **FERTILITY_AWARENESS_SAFETY.md:** Keep. Add the mandated prediction sentence to the Flutter fertile-window view (H6).
- **ENDOMETRIOSIS_CONTENT_SAFETY.md:** Keep. Apply the footer wherever endometriosis content appears.
- **REPRODUCTIVE_TREATMENT_SAFETY.md:** Keep for the website articles; trim for the app, which does not yet need it.
- **HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md:** Keep as the master rules. Feed its banned phrases into the lint (M2).
- **MENTAL_HEALTH_SCREENERS.md:** Keep. No screener in v1 unless the owner decides otherwise (Q6). Add attribution before any reopening.
- **CRISIS_RESOURCES.md:** Keep. This is core. Build the Flutter crisis route from the same `crisis.json` copy, or a reviewed twin (H5).
- **DATA_MAP.md:** Rebuild for the private model. The on-device record fields go in; the cloud tables are marked dormant.
- **PROCESSOR_REGISTER.md:** Rebuild. Correct the Sentry, Vercel and Stripe rows; add Vercel Web Analytics and Google sign-in; state that v1 has no processor that touches health data (M1).
- **DPIA.md:** Keep for the website and any later sync. Write a short DPIA note for the private v1, or record the DPO's decision that one is not needed (M11).
- **BREACH_RUNBOOK.md:** Keep. Scope it to the residual data (website logs, crash reports, store records). Fill the roles.
- **SECURITY_REVIEW.md:** Keep for the website. There is no review for the Flutter app; one is needed before release.
- **PARTNER_SHARING_DESIGN.md:** Keep as a parked design, labelled "not in v1." Do not delete: it records why the rules are as they are.
- **THROUGHLINE_LINK_CONFIRMATION.md:** Keep. Sending the one email costs little and closes L5.
- **P0_12_LEGAL_INTAKE_FORM.md:** Rebuild. Shrink to the entity, contacts and the four counsel questions in PRIVATE_LAUNCH §6.
- **NEEDS_SOURCE_REVIEW_BRIEF.md:** Keep as reference.
- **NEEDS_SOURCE_TRACKER.xlsx:** Keep. Not read; verdict unknown.
- **docs/13_LEGAL_COMPLIANCE.md:** Rebuild in part. §3–§4 assume cloud accounts; §5b (disclosures) still applies to partner sharing; mark the superseded parts.
- **docs/18_RBAC_MODEL.md:** Park. Relevant only if the website and the content back office return; the Payload parts go when D3 is executed.
- **docs/19_ANALYTICS_EVENT_SCHEMA.md:** Keep. Either add Vercel Web Analytics to the schema or state that it is out of scope for analytics.
- **docs/runbooks/OWNER_ACTIONS.md:** Keep. Its removal of counsel conflicts with the compliance docs; the owner must decide (Q1).
- **Archived OWNER_ACTIONS_2026-10-07.md:** Keep, archived. It holds the counsel brief and the Egypt date.
- **scripts/claims-lint.mjs:** Keep and extend: all four locales, ARB files, the banned phrases, and a reviewed exception for "not a contraceptive" (M2, M3).
- **scripts/crisis-compliance.mjs:** Keep. Add a check that the Flutter crisis route exists once it is built.
- **apps/web/src/lib/crisis/crisis.json:** Keep. This is the single source of crisis copy; the Flutter app should read the same text.
- **apps/web/src/lib/screeners/epds.ts and mood.ts:** Keep. The self-harm routing logic is correct as written; the screener UI can stay parked.
- **Privacy and terms pages (`apps/web/src/app/[locale]/(public)/privacy` and `terms`):** Keep the pages with `noindex`. Rewrite their copy in `en.json` to the private model (H2).
- **apps/web/messages/en.json `privacy` and `terms` keys:** Rebuild to the private model, 18+ only (H2, M6).
- **apps/mobile/lib/data/store.dart:** Keep. This is the right direction. Add app lock and encryption at P3.8 (H3).
- **apps/mobile AndroidManifest.xml:** Keep. Add a release-build test that no `INTERNET` permission is present (section 7).
- **Flutter contraction timer (`domain/contractions.dart`, timer screen):** Keep. Write a compliance note for it (M15).
- **apps/web/src/lib/analytics/events.ts and guard.ts:** Keep. Sound design; no vendor is connected.
- **Supabase partner-view function, partner_links, health RLS:** Park. Not used by the private v1 (From the docs). Decide with the owner what to do with the live data (H4, Q4).

---

## 10. Open questions

Each needs a yes or no, or a named answer, from the owner or a qualified lawyer.

1. **Egypt.** Is the 31 October 2026 licensing date right, and what does Egypt require of an app that holds no records off the phone? Counsel (PRIVATE_LAUNCH §6.1) or the owner's chosen route? This needs an answer before the date passes.
2. **Controller.** Which entity and country is the controller, and is it registered? (P0.12 §1 is blank.)
3. **Clinical reviewer.** Is "Mohamed K." a real named clinician with credentials? Or is Khaled the clinical reviewer for every file, as the 2026-10-27 runbook says? The threshold files need one answer.
4. **Legacy data.** Purge the 228 test-data accounts and the 214 empty ones (archive C6c)? Confirm there is no real user data, or say what happens to it.
5. **Crisis route in v1.** Will the Flutter v1 include any free-text or risk-disclosing field? If yes, a crisis route is required (H5).
6. **Screeners in v1.** In or out? If in: GAD-7 licence confirmed, EPDS validated Arabic version confirmed, attribution added.
7. **Privacy and terms rewrite.** Approve a rewrite to the on-device model, 18+ only, with the "not a contraceptive" sentence and the Egypt and Saudi wording taken from counsel's answers.
8. **Encryption claim.** Keep "encrypted at rest" in the policy until verified, or remove it?
9. **Red-flag and movement wording.** Add a source to the docs for the Flutter lines 282–283 and 318–319, or revise them to match PREGNANCY_BP_SAFETY?
10. **Support copy.** Source or remove "more common than most people are told" (H7).
11. **Consent step.** Does local-only storage need the consent step in docs/13 §3, or is it outside that rule? (M9.)
12. **Processors.** Confirm the real status of Sentry, Vercel's region, Vercel Web Analytics and Google sign-in. Remove the Stripe row per the owner's rule (Paddle or Google Play Billing).
13. **Play.** Check the Data safety definition of "collected" on Play's own page. Get the Play-prescribed non-device disclaimer text. Choose a personal or organisation account (a personal one needs 12 testers for 14 days; an organisation account needs a D-U-N-S number).
14. **DPO.** Appoint one (external is allowed), or record that none is needed for the private v1.
15. **Egypt and Saudi crisis numbers.** Name a verified local source, or accept the generic fallback alone for launch (H9).
16. **Primary sources.** Obtain the Saudi PDPL text, the Egypt 151/2020 and Executive Regulations text, and the ICO guidance, and cite them in the docs (M12).
17. **Source-check count.** 432 or 454 flags? (L1; docs/11 not read.)
18. **Adding the mandated sentences now.** Add the prediction sentence and the endometriosis footer to the copy now (H6), even before launch? This is a copy change with no legal cost.

---

## Appendix A. Compliance checklist for the private v1

Status: **done** = verified in the repo today or fixed by a signed decision; **drafted** = text or design exists but is wrong, partial or unverified; **missing** = no artifact. "Checked" means verified today.

| # | Item | Status | Where | Note |
|---|---|---|---|---|
| 1 | Private, on-device design decided (D7) | done | docs/compliance/PRIVATE_LAUNCH_V1.md; docs/runbooks/OWNER_ACTIONS.md | Accepted 2026-10-07; PRIVATE_LAUNCH header still says "proposed" (L2) |
| 2 | Health record stored only on the phone | drafted | apps/mobile/lib/data/store.dart | JSON file exists; app-level encryption deferred to P3.8 |
| 3 | No network calls in the Flutter build | done | apps/mobile/lib; apps/mobile/android/app/src/main/AndroidManifest.xml | Checked: no http(s) in code, no INTERNET permission in main manifest; release test missing |
| 4 | No analytics, crash or ad SDK in the Flutter build | done | apps/mobile/pubspec.yaml | Checked: only flutter, flutter_localizations, intl, path_provider |
| 5 | Crash-reporting decision for Android (no IP, no user content) | missing | docs/compliance/PRIVATE_LAUNCH_V1.md §3 | No SDK, no decision recorded for the app |
| 6 | User-saved backup file and import | missing | docs/compliance/PRIVATE_LAUNCH_V1.md §3 | Checked: no backup or export code in apps/mobile |
| 7 | "Save a backup" honesty copy in the app | drafted | apps/mobile/lib/l10n/app_en.arb line 72 | "Stored on this phone only." exists; backup prompt missing |
| 8 | Delete all data on the device | drafted | apps/mobile/lib/data/store.dart (clear) | Method exists; UI not checked |
| 9 | Privacy policy for the v1 model | drafted | apps/web/messages/en.json (privacy); privacy/page.tsx line 20 | Describes the cloud product; rewrite needed (H2) |
| 10 | Terms of use for the v1 model | drafted | apps/web/messages/en.json (terms); terms/page.tsx line 18 | Same problem (H2) |
| 11 | Terms state "not a contraceptive" | missing | docs/13_LEGAL_COMPLIANCE.md §4 | Absent from draft; lint conflict (3.9) |
| 12 | Teen wording removed from policies (18+ only) | missing | en.json privacy "Teens and guardians" | Contradicts 18+ launch (M6) |
| 13 | Play Data safety form answers | missing | PRIVATE_LAUNCH_V1 §4 | Only the intended answer is written down |
| 14 | Play Health apps declaration | missing | PRIVATE_LAUNCH_V1 §4 | Required by the docs |
| 15 | Play-prescribed non-device disclaimer and clinician reminder | drafted | en.json privacy/terms footnote | Generic footer exists; Play wording not verified |
| 16 | In-app wellness disclaimer on health screens | missing | apps/mobile/lib/l10n/app_en.arb | No match for "medical device," "wellness" (M5) |
| 17 | 18+ gate at onboarding | done | apps/mobile/lib/features/onboarding/onboarding_flow.dart line 20; app_en.arb line 24 | Checked: the under-18 step and its copy exist; the flow itself was not run |
| 18 | Play target audience set to 18+ | missing | Play Console (owner) | PRIVATE_LAUNCH §3 |
| 19 | Play account type chosen (personal needs 12 testers × 14 days) | missing | docs/runbooks/OWNER_ACTIONS.md item 3 | Owner action |
| 20 | Data map updated for the Flutter record | missing | docs/compliance/DATA_MAP.md | No on-device fields listed (M4) |
| 21 | Consent step before first health entry, or documented exemption | missing | docs/13 §3; apps/mobile/lib | No consent code (M9) |
| 22 | Egypt answer from counsel (licence, representative) | missing | PRIVATE_LAUNCH_V1 §6.1 | Deadline per archive: 31 Oct 2026 [NEEDS SOURCE] (H1) |
| 23 | Saudi answer from counsel | missing | PRIVATE_LAUNCH_V1 §6.2 | No primary text in docs (M12) |
| 24 | UK answer from counsel | missing | PRIVATE_LAUNCH_V1 §6.3 | ICO cited via secondary source (M12) |
| 25 | Controller entity, registration, address | missing | docs/compliance/P0_12_LEGAL_INTAKE_FORM.md §1 | Blank |
| 26 | Publishable privacy contact | missing | P0_12 §2 | Blank |
| 27 | DPO decision | missing | DPIA §5; P0_12 §3 | Not appointed (M11) |
| 28 | DPIA for the private v1 (or documented decision that it is not needed) | missing | docs/compliance/DPIA.md | DPIA covers the website and partner sharing only |
| 29 | Breach runbook for residual data | drafted | docs/compliance/BREACH_RUNBOOK.md | Skeleton; roles blank |
| 30 | Processor register correct | drafted | docs/compliance/PROCESSOR_REGISTER.md | Sentry, Vercel, Stripe and Google rows wrong or missing (M1) |
| 31 | Legacy health data in production database: purge or keep decided | missing | docs/archive/runbooks-2026-10/OWNER_ACTIONS_2026-10-07.md C6c | Not in current runbook (H4) |
| 32 | Partner sharing off in v1 | done | apps/mobile (no partner screen); web closed (From the docs, D8) | Back end still live (L3) |
| 33 | Website cookies essential only | drafted | docs/compliance/PRIVATE_LAUNCH_V1.md §4 | Not verified in code |
| 34 | Vercel Web Analytics: no health events, no identifiers | drafted | PRIVATE_LAUNCH_V1 §3 | Not in processor register (M1) |
| 35 | Claims lint passes on English UI copy | done | scripts/claims-lint.mjs | Checked, exit 0; English only |
| 36 | Claims lint covers ar, fr, es, ARB and CMS | missing | scripts/claims-lint.mjs (SCAN_LOCALES line 15) | M2 |
| 37 | Banned phrases from the docs in the lint | missing | HEALTH_APP_CLAIMS §Intended-use; ENDOMETRIOSIS §5 | None present today (Checked); nothing enforces (M2) |
| 38 | Mandated prediction sentence on every fertility surface | missing | en.json; app_en.arb | Absent (Checked); H6 |
| 39 | Endometriosis footer | missing | en.json; app_en.arb | Absent (Checked) |
| 40 | No "safe day," "infertile day" or "cure" in copy | done | en.json; app_en.arb | Checked by grep: none present |
| 41 | Blood-pressure reference points in the app | drafted | docs/compliance/PREGNANCY_BP_SAFETY.md | Doc ready; no feature in v1 (Checked) |
| 42 | Source for pregnancy red-flag and movement copy | missing | app_en.arb lines 282–283, 318–319 | H8 |
| 43 | Screener in v1 decided | missing | docs/compliance/MENTAL_HEALTH_SCREENERS.md | None in Flutter (Checked); decision needed (Q6) |
| 44 | Screener attribution and licences | missing | en.json; screener components | Checked: no attribution text (M8) |
| 45 | Unsourced prevalence wording removed from support copy | missing | en.json epds.support.body; moodScreeners.support.body | H7 |
| 46 | Verified local emergency and crisis numbers for Egypt and Saudi Arabia | missing | docs/compliance/CRISIS_RESOURCES.md | None in any file (H9) |
| 47 | Crisis route in the Flutter app, with global fallback | missing | apps/mobile/lib | Checked: no crisis route (H5) |
| 48 | Web crisis copy approved in four locales, in date | done | apps/web/src/lib/crisis/crisis.json; scripts/crisis-compliance.mjs | Checked, exit 0 |
| 49 | Findahelpline link terms confirmed in writing | drafted | docs/compliance/THROUGHLINE_LINK_CONFIRMATION.md | Email drafted, not sent; owner accepted risk 2026-08-03 |
| 50 | Contraction-timer safety note | missing | apps/mobile/lib/domain/contractions.dart | No compliance doc (M15) |
| 51 | Fetal-movement wording note | missing | docs/compliance | No doc; app copy at app_en.arb 318–319 |
| 52 | Named reviewer with credentials on each threshold file | drafted | docs/compliance/*.md (reviewer line) | Name only; identity unclear (M10) |
| 53 | At-rest encryption verified before policy says so | missing | SECURITY_REVIEW §5 | H3 |
| 54 | Privacy claim "no ad or analytics vendor sees health data" true for v1 | done | apps/mobile/pubspec.yaml | Checked for the app; policy wording still drafted (row 9) |

**Count.** Done: 9 (rows 1, 3, 4, 17, 32, 35, 40, 48, 54). Drafted: 13 (rows 2, 7, 8, 9, 10, 15, 29, 30, 33, 34, 41, 49, 52). Missing: 32 (rows 5, 6, 11, 12, 13, 14, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 31, 36, 37, 38, 39, 42, 43, 44, 45, 46, 47, 50, 51, 53). Total 54.

---

## Appendix B. Crisis resources (what the docs and code contain)

**Global fallback** (verbatim from CRISIS_RESOURCES.md; the same wording appears in `crisis.json` as `immediateLead` and `stayWithSomeone`):

> If you may act on thoughts of harming yourself or someone else, or you are in immediate danger, contact the emergency services available where you are now or go to the nearest emergency department. You can also use Find A Helpline to find a crisis service for your country. If you can, stay with someone you trust while you get help.

**If you are worried about someone else** (verbatim):

> If you think the person is in immediate danger, do not leave them alone if it is safe for you to stay. Contact the emergency services available where they are, a crisis service, a health worker, or a trusted family member.

**Directory.** Find A Helpline, https://findahelpline.com. Country-based directory; participating services verify their own information. Topic pages the docs name: eating and body image, grief and loss, abuse and domestic violence. Commercial use requires ThroughLine's prior written permission (From the docs; the link is a plain inbound link; written confirmation not sent).

**Country numbers.** None in any file. CRISIS_RESOURCES says numbers may appear only in country-specific content after re-verification, and never as a global fallback. **Egypt and Saudi Arabia, the launch markets in D4, have no entries.** This is a gap for H9, not something to fill from memory.

**Maternity and pregnancy routing.** "Contact your maternity unit or local emergency services"; if unreachable, the nearest emergency department (PREGNANCY_BP_SAFETY, From the docs; the same in `app_en.arb` line 283).

**Languages in code.** en, ar, fr, es in `crisis.json`; the ar, fr and es entries are marked approved by the owner, 2026-08-11 (Checked). Flutter: no crisis route (H5).

**Support organisations that are not crisis services** (peer, maternal-health, eating-disorder or bereavement support) must stay visually separate from the urgent route (CRISIS_RESOURCES, From the docs).

---

## Summary of this study

- The rules are thorough and mostly consistent with each other; the claims guard and crisis guard pass today.
- The **biggest risk is timing and legal cover**: the Egypt licensing date (per the archived runbook, 31 October 2026) and the removal of counsel from the current runbook need a decision now.
- The **privacy and terms drafts describe the old cloud product** and say things the code does not yet support (encryption at rest). They need rewriting before publication.
- The **private Flutter app has no crisis route, no backup, no wellness disclaimer and no consent step**, and it lacks the mandated prediction sentence and endometriosis footer.
- The **processor register and the data map are out of date** for the private model, and the register lists Stripe, which the owner's rules exclude.
- **No Egypt or Saudi crisis number** exists in the repo; a verified local source is needed.
- Legal sources for Saudi PDPL and the Egypt regulations are secondary or absent; these conclusions are the docs', not verified here.
- The **medical reviewer's identity** is unclear across the docs.
- Appendix A has 54 items: 9 done, 13 drafted, 32 missing.
