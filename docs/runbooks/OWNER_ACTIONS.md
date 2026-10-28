# Owner actions: only what Khaled must do by hand

**Rewritten 2026-10-28 for v3.** The 2026-10-27 version (four items) is in git history. The rule
is unchanged: Khaled is the only person in every role; sessions do everything else and proceed on
the recommended default. Do not add a line here unless only a human with Khaled's identity can do it.

## Now (before the release candidate)

| # | What | Why only you | Time |
|---|---|---|---|
| 1 | **Create the Google Play Console account** ($25, one-off) at play.google.com/console | Google verifies your identity | 20 min |
| 2 | **Create the upload keystore** and keep it outside the repo: run the command in `docs/33_REBUILD_V3/05_RELEASE_RUNBOOK.md` §2, then copy `apps/mobile/android/key.properties.example` to `key.properties` and fill it in. Back the `.jks` file up somewhere safe: losing it means a new app listing | A signing key is an identity | 10 min |
| 3 | **Fill the three legal placeholders** in `apps/web/src/lib/legal/placeholders.ts`: the legal entity (KM Digital Labs, with its registration), the privacy contact email, and the effective date | They are your name and address | 5 min |
| 4 | **Pause the Supabase project** (Settings → General → Pause) and **delete the `femio-cms` Vercel project**. Before pausing, if you ever edited translations in the old CMS translation portal, export them first: SQL editor → `select key, locale, value from ui_strings where status = 'human_reviewed' and locale <> 'en'` → CSV → send to a session to merge | Account owner only | 10 min |

## When a session sends a build

| # | What | Why only you | Time |
|---|---|---|---|
| 5 | **Install each test APK on your phone** and say what is wrong, in Arabic and English | Real phone, real use | 10 min each |
| 6 | **Find 12 testers who keep the app installed for 14 days** (Google requires it of a new personal developer account). The recruitment message in Arabic and English is in `docs/33_REBUILD_V3/04_GROWTH_PACK.md` §5 | Your people | messages |
| 7 | **Say "publish"** on the legal pages and the Arabic articles you are happy with. One guide waits for you specifically: `docs/content/articles/pcos-treatment-options-to-discuss.md` (the AI reviewer would not sign it without a clinician confirming letrozole availability for ovulation induction in Egypt and Saudi Arabia and whether to add an OHSS warning; the note is `docs/content/reviews/2026-10-28-pcos-set.md`). Two cited pages have moved: the ASRM 2021 page in `docs/compliance/FERTILITY_AWARENESS_SAFETY.md` now 404s (a 2026 version replaced it) and the NHS infertility-treatment page passed its review date | You are the named reviewer | when you want |
| 8 | **Listen to the calculator with NVDA once** (free screen reader, nvaccess.org, 15 min to install). Open `femioapp.com/ar/calculators/fertile-window`, press Tab until a day is read out, use the arrow keys, press Enter, and note whether NVDA reads: the full date on each day, the result sentence after Enter, and nothing twice. Write what you heard in `testing-results/2026-10-28-calendar-a11y/nvda-notes.md` (a session turns it into fixes). The keyboard part is already automated (`apps/web/e2e/calculators.spec.ts`); NVDA is not installed on this PC | A screen reader is heard, not tested in code | 20 min |
| 9 | **Three Arabic content decisions** from the editor pass (`docs/content/reviews/2026-10-28-arabic-editor-pass.md`): (a) the Arabic guides drop the English lines on donor sperm, same-sex couples, parenting alone and home insemination; keep that for Egypt and Saudi readers (today's default) or restore them; (b) the lay term تكيّس المبايض is used in guides, app and store instead of the glossary's المبيض المتعدد الكيسات; keep the lay term (default) or switch; (c) in the Ramadan guide, "المرجع الديني" or "أهل العلم الشرعي" for the person she asks about fasting. One word each; a session records the ADR and applies it | Register and scope are yours | 5 min |
| 10 | **Confirm two pregnancy red-flag symptoms** (register MR-29): the app and website list the five ACOG/CDC Hear Her signs (severe headache, vision changes, upper-abdominal pain, swelling of the face or hands, difficulty breathing). Bleeding and reduced movements are standard additions with no source in `docs/compliance/`. Name an NHS or RCOG page and a session adds them to both, or say no | A medical claim needs your source | 10 min |

## Growth (after the release candidate; the interactive checklist mirrors these)

Every step is written click by click in `docs/34_GROWTH_OPS/04_OWNER_GUIDE_GROWTH_A_TO_Z.md`
(offline copy: `04_OWNER_GUIDE_GROWTH_A_TO_Z.html`). Tick them in the interactive checklist
(https://claude.ai/artifact/V3exHDJpZasUkRoWuameDp, private to Khaled; ticks and the ADR-075 choice persist and a session reads them back).

| # | What | Why only you | Time |
|---|---|---|---|
| 11 | **Decide ADR-075** (`docs/DECISIONS.md`): accept, accept without ads, or decline. It lets the *website* measure visits and carry ads after consent; the app is untouched | Changes a product rule | 15 min to read |
| 12 | **Create the measurement accounts** you own: Search Console (guide part B, no decision needed), then after 11: GA4 (C), Tag Manager + consent banner (D), Meta Business + Pixel (E). Put the public ids (`G-`, `GTM-`) into Vercel yourself | Google and Meta verify your identity; the ids belong to you | 2 hours over a week |
| 13 | **Create the Canva account and the social handles** `femioapp` (Instagram, TikTok, Snapchat, X, WhatsApp Channel, Facebook Page) with the bilingual bio (guide part F) | Accounts are in your name | 1 hour over a few days |
| 14 | **Start the growth routines** ("create the growth routines", part G), then each week: "review this week" and answer publish / fix / hold; drop the Play CSV weekly | Only you can say publish | 45 min a week |
| 15 | **Apply to AdSense** when the site has steady readers (part H), set the blocking list, give a session only the `pub-` id and slot numbers | Payments and identity | 20 min + waiting |
| 16 | **Play payments profile and the `femio_plus` subscription** with monthly and yearly plans (part I; February 2027). Read the EGP and SAR rows Play shows and round them | Merchant identity and bank | 30 min |
| 17 | **Spend 20–60 minutes with Flo, Clue and one Arabic app** on your phone: count ad units on an article and a calculator, note where the paywall appears; write the counts into `docs/34_GROWTH_OPS/reports/2026-10-28-competitor-monetization.md` §2 | Only a phone shows the real units | 1 hour |

## Decisions already made (unchanged)

D1–D8 and ADR-072 stand: the TTC → pregnancy wedge, Saudi + Egypt, Arabic first, the private
Android app, the website as its front door, Dusk Bloom, no database, calendar calculators.
Every other decision has a default in `docs/33_REBUILD_V3/01_PRODUCT_SCOPE.md` §6; a session
proceeds on it and tells you at the next checkpoint.
