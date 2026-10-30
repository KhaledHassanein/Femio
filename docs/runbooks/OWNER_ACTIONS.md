# Owner actions: only what Khaled must do by hand

**Rewritten 2026-10-28 for v3.** The 2026-10-27 version (four items) is in git history. The rule
is unchanged: Khaled is the only person in every role; sessions do everything else and proceed on
the recommended default. Do not add a line here unless only a human with Khaled's identity can do it.

## Now (before the release candidate)

| # | What | Why only you | Time |
|---|---|---|---|
| 1 | **Create the Google Play Console account** ($25, one-off) at play.google.com/console | Google verifies your identity | 20 min |
| 2 | **Create the upload keystore** and keep it outside the repo: run the command in `docs/33_REBUILD_V3/05_RELEASE_RUNBOOK.md` §2, then copy `apps/mobile/android/key.properties.example` to `key.properties` and fill it in. Back the `.jks` file up somewhere safe: losing it means a new app listing | A signing key is an identity | 10 min |
| 3 | ~~Fill the three legal placeholders~~ **Done 2026-10-29 from your dashboard notes**: `info@femioapp.com`, effective 2026-10-29, entity `KM Digital Labs`. **Still yours:** (a) the legal form and registration number of KM Digital Labs, one line in chat, and the session adds it to `apps/web/src/lib/legal/placeholders.ts`; (b) make sure the mailbox `info@femioapp.com` exists and receives mail (not verified) | Only you know the registration; only you can create the mailbox | 10 min |
| 4 | **Pause the Supabase project** (Settings → General → Pause) and **delete the `femio-cms` Vercel project**. Before pausing, if you ever edited translations in the old CMS translation portal, export them first: SQL editor → `select key, locale, value from ui_strings where status = 'human_reviewed' and locale <> 'en'` → CSV → send to a session to merge | Account owner only | 10 min |

## When a session sends a build

| # | What | Why only you | Time |
|---|---|---|---|
| 5 | **Install each test APK on your phone** and say what is wrong, in Arabic and English | Real phone, real use | 10 min each |
| 6 | **Find 12 testers who keep the app installed for 14 days** (Google requires it of a new personal developer account). The recruitment message in Arabic and English is in `docs/33_REBUILD_V3/04_GROWTH_PACK.md` §5 | Your people | messages |
| 7 | **Say "publish"** on the legal pages and the Arabic articles you are happy with. One guide waits for you specifically: `docs/content/articles/pcos-treatment-options-to-discuss.md` (the AI reviewer would not sign it without a clinician confirming letrozole availability for ovulation induction in Egypt and Saudi Arabia and whether to add an OHSS warning; the note is `docs/content/reviews/2026-10-28-pcos-set.md`). Two cited pages have moved: the ASRM 2021 page in `docs/compliance/FERTILITY_AWARENESS_SAFETY.md` now 404s (a 2026 version replaced it) and the NHS infertility-treatment page passed its review date | You are the named reviewer | when you want |
| 8 | **Listen to the calculator with NVDA once** (free screen reader, nvaccess.org, 15 min to install). Open `femioapp.com/ar/calculators/fertile-window`, press Tab until a day is read out, use the arrow keys, press Enter, and note whether NVDA reads: the full date on each day, the result sentence after Enter, and nothing twice. Write what you heard in `testing-results/2026-10-28-calendar-a11y/nvda-notes.md` (a session turns it into fixes). The keyboard part is already automated (`apps/web/e2e/calculators.spec.ts`); NVDA is not installed on this PC | A screen reader is heard, not tested in code | 20 min |
| 9 | ~~Three Arabic content decisions~~ **Done 2026-10-30 (ADR-077: keep the conservative scope, keep تكيّس المبايض, أهل العلم الشرعي)** · from the editor pass (`docs/content/reviews/2026-10-28-arabic-editor-pass.md`): (a) the Arabic guides drop the English lines on donor sperm, same-sex couples, parenting alone and home insemination; keep that for Egypt and Saudi readers (today's default) or restore them; (b) the lay term تكيّس المبايض is used in guides, app and store instead of the glossary's المبيض المتعدد الكيسات; keep the lay term (default) or switch; (c) in the Ramadan guide, "المرجع الديني" or "أهل العلم الشرعي" for the person she asks about fasting. One word each; a session records the ADR and applies it | Register and scope are yours | 5 min |
| 10 | ~~Confirm two pregnancy red-flag symptoms~~ **Done 2026-10-30: NHS pages recorded in MR-29; the card change is R4.14** · (register MR-29): the app and website list the five ACOG/CDC Hear Her signs (severe headache, vision changes, upper-abdominal pain, swelling of the face or hands, difficulty breathing). Bleeding and reduced movements are standard additions with no source in `docs/compliance/`. Name an NHS or RCOG page and a session adds them to both, or say no | A medical claim needs your source | 10 min |

## Growth (after the release candidate; the interactive checklist mirrors these)

Every step is written click by click in `docs/34_GROWTH_OPS/04_OWNER_GUIDE_GROWTH_A_TO_Z.md`
(offline copy: `04_OWNER_GUIDE_GROWTH_A_TO_Z.html`). Tick them in the interactive checklist
(https://claude.ai/artifact/V3exHDJpZasUkRoWuameDp, private to Khaled; ticks and the ADR-075 choice persist and a session reads them back).
**Since 2026-10-29 that artifact is the go-live dashboard:** 68 steps in 9 phases (accounts, website, measurement, ads,
Play Console, first upload, social, premium, upkeep), a "needs from you" queue that sessions append to, the ADR-076
card (ads inside the app: decide there), and a log. Source: `docs/34_GROWTH_OPS/dashboard/`. The table below stays
as the short list; the dashboard holds the click-by-click steps.

| # | What | Why only you | Time |
|---|---|---|---|
| 11 | ~~Decide ADR-075~~ **Done 2026-10-28: accepted.** The website may measure visits and carry ads after consent; the app is untouched | — | — |
| 12 | **Create the measurement accounts** you own: Search Console (guide part B), GA4 (C), Tag Manager + consent banner (D), Meta Business + Pixel (E). Put `NEXT_PUBLIC_GTM_ID` into Vercel yourself (D8); the site sends nothing until you do. Also create the one-question feedback form (any form tool; the form must warn "do not include health details") and give a session its URL | Google and Meta verify your identity; the ids belong to you | 2 hours over a week |
| 13 | **Create the Canva account and the social handles** `femioapp` (Instagram, TikTok, Snapchat, X, WhatsApp Channel, Facebook Page) with the bilingual bio (guide part F) | Accounts are in your name | 1 hour over a few days |
| 14 | **Start the growth routines** ("create the growth routines", part G), then each week: "review this week" and answer publish / fix / hold; drop the Play CSV weekly | Only you can say publish | 45 min a week |
| 15 | **Apply to AdSense** when the site has steady readers (part H), set the blocking list. The code is built (R6.8): put `NEXT_PUBLIC_ADSENSE_CLIENT` (`ca-pub-…`) and the three slot variables into Vercel yourself (dashboard phase 4); ads fill only after the consent tool grants `ad_storage`, so the consent tool must show to every visitor (the free certified tool in part D7, not AdSense's EEA-only message) or non-EEA readers never see one | Payments and identity | 20 min + waiting |
| 16 | **Play payments profile and the `femio_plus` subscription** with monthly and yearly plans (part I; February 2027). Read the EGP and SAR rows Play shows and round them | Merchant identity and bank | 30 min |
| 18 | ~~Decide ADR-076~~ **Done 2026-10-29: accepted** (ads on both; her health data never leaves the phone) | — | — |
| 20 | **AdMob account and ids** (dashboard phase 4, items `admob-account`, `admob-units`, `ads-env`, `app-ads-txt`): create the AdMob account on the same Google account, add the Android app (package `com.femioapp.femio`, "not yet on Play"), create two banner units (`femio-article`, `femio-learn`), copy the app id and the two unit ids into `apps/mobile/ads.env` (copy of `ads.env.example`, git-ignored, never into chat), put the `pub-` publisher id into Vercel as `NEXT_PUBLIC_ADMOB_PUBLISHER`, then in AdMob verify `app-ads.txt`. In Play: Ads = Yes, and the Data safety rows in `docs/store/data-safety-and-declarations.md` | Accounts and ids are yours | 40 min |
| 19 | **Run the Play Billing probe on your phone once** (`flutter run --profile`, Settings → About → *femio Plus · billing check*) and send a session the line it shows plus any `SecurityException` in `adb logcat`; proves the billing library lives without INTERNET on a real device | Needs a phone signed in to Play | 10 min |
| 17 | **Spend 20–60 minutes with Flo, Clue and one Arabic app** on your phone: count ad units on an article and a calculator, note where the paywall appears; write the counts into `docs/34_GROWTH_OPS/reports/2026-10-28-competitor-monetization.md` §2 | Only a phone shows the real units | 1 hour |
| 21 | **Delete two legacy Vercel variables** on project `femio-web`: `NEXT_PUBLIC_BETA_INVITE_CODE` and `NEXT_PUBLIC_ENABLE_GOOGLE_AUTH` (the v2 sign-in era; nothing in `apps/web` reads them). Keep `NEXT_PUBLIC_APP_URL` and `NEXT_PUBLIC_CRISIS_DIRECTORY_URL`, both in use | The session's Vercel connector can read and add variables but not delete them | 2 min |
| 22 | **Branch protection: DEFERRED.** GitHub's message on your dashboard note is right: rulesets and branch protection are not enforced on a private repository on the Free plan. Options: GitHub Team ($4/user/month) or leave it. Recommendation: leave it; the session protocol already never pushes `main` without your word, and you are the only committer | Your money | — |

## Decisions already made (unchanged)

D1–D8 and ADR-072 stand: the TTC → pregnancy wedge, Saudi + Egypt, Arabic first, the private
Android app, the website as its front door, Dusk Bloom, no database, calendar calculators.
Every other decision has a default in `docs/33_REBUILD_V3/01_PRODUCT_SCOPE.md` §6; a session
proceeds on it and tells you at the next checkpoint.
