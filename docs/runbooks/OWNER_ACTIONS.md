# Owner actions: only what Khaled must do by hand

**Rewritten 2026-10-28 for v3.** The 2026-10-27 version (four items) is in git history. The rule
is unchanged: Khaled is the only person in every role; sessions do everything else and proceed on
the recommended default. Do not add a line here unless only a human with Khaled's identity can do it.

## Hackathon: #BuildHybridAI (deadline Monday 30 November 2026, 2 pm Pacific = 00:00 Cairo on Tuesday 1 December)

Step-by-step guide with screenshots of what you should see: `docs/hackathon/OWNER_GUIDE.html` (open it in a browser).

Added 2026-11-24 (ADR-078). Steps 23 to 25 unlock the AI; without them the app still works on rules.

| # | What | Why only you | Time |
|---|---|---|---|
| 23 | **Firebase project on the paid plan.** console.firebase.google.com → Add project `femio` (no Google Analytics) → Build → AI Logic → Get started → **Gemini Developer API** → upgrade to **Blaze** and set a **$10 budget alert** (Google Cloud → Billing → Budgets & alerts). The paid tier keeps her questions out of Google's training | A billing account is yours | 15 min |
| 24 | **Register the Android app** in that project: package `com.femioapp.femio`. Copy the three ids (App ID, API key, project ID) from Project settings → Your apps into `apps/mobile/assistant.env` inside the branch folder `E:\Femio\.claude\worktrees\firebase-hackathon-eligibility-833c52` until it is merged (copy of `assistant.env.example`, git-ignored; never into chat). Skip google-services.json | Console access | 5 min |
| 25 | **App Check.** Install the debug build (a session builds it), open Ask femio once, then in `adb logcat` find the line with the debug token, and add it at App Check → Apps → Manage debug tokens. Then turn **enforcement on** for AI Logic and leave it on through judging (owner 2026-11-24: judges who sideload the APK may not reach Cloud boost; the rest works) | Console access | 10 min |
| 26 | **Name the demo phone.** It must be on Google's AICore supported-device list (Gemini Nano); Settings → Assistant in femio says "Ready" when it is. Without Nano the demo still works: turn on Cloud boost there | Your phone | 2 min |
| 27 | **Say "make it public"** and a session creates the public GitHub repository `femio-app` (Apache-2.0, app only, made by `scripts/hackathon/export-public-app.mjs`; the monorepo stays private) | Publishing is yours to approve | 1 min |
| 28 | **Record the video** (script on the hackathon pack page), upload it to YouTube (public or unlisted), then **submit on Devpost** with the texts in `docs/hackathon/DEVPOST_SUBMISSION.md`, the repo link and the video link | Your account and voice | 1 hour |
| 29 | **Gemini logging off.** In Google AI Studio for the femio project, open Logs (or Settings → Logging) and switch request logging **off**; never join the "Contributor" data-sharing tier. In Firebase console → AI Logic → Monitoring, leave it off, or turn off "include prompts and responses". The privacy notice promises this (ADR-080) | Your console | 5 min |
| 30 | **Firebase data sharing off.** Firebase console → gear icon → Project settings → **Data privacy** (on some layouts: Integrations or "Data sharing settings") → untick every box that lets Google use your Firebase data for other Google services, then Save. Google Analytics is already unlinked (you did it 2026-11-24) | Your console | 3 min |
| 31 | **Website measurement switch.** Vercel → project `femio-web` → Analytics → **Enable Web Analytics**. Then delete the `NEXT_PUBLIC_GTM_ID` variable in Vercel, delete the GTM container, and delete the Meta pixel (Events Manager → the dataset → Settings → remove) so nothing old can load | Your accounts | 10 min |
| 32 | **AdMob app.** In AdMob, archive or remove the femio Android app and its ad units (the app no longer contains ads); keep AdSense for the website | Your account | 3 min |
| 33 | **Traffic check on a real phone** (before the Play release): install the release build, use Cloud boost once, and capture traffic with HTTP Toolkit or PCAPdroid; a session reads the capture to confirm the notice lists everything Google receives (ML Kit telemetry is still unverified) | Your phone | 30 min |
| 34 | **EU and UK representative** (GDPR Art. 27): decide with the lawyer whether to appoint one (services cost roughly a few hundred euros a year) or to switch Cloud boost off for EEA/UK phones | Your decision | — |
| 35 | **Egypt PDPC licence** (Law 151 Art. 12): ask the lawyer whether Cloud boost needs the sensitive-data licence and a transfer permit; the grace period ended about 1 Nov 2026 | Your decision | — |
| 36 | **One privacy-lawyer review before the Play release**, with `docs/compliance/PRIVACY_REVIEW_2026-11-24.md`, the privacy policy and the consumer health data policy pages | Paid, yours | 1–2 h |

## Judge audit (2026-11-26): decisions and the real-phone run

Plan: `docs/33_REBUILD_V3/audit-2026-11-26/00-FINISHING-PLAN.md` (PROGRESS R14). Rows 40-42 are one-word answers; a session builds the rest.

| # | What | Why only you | Time |
|---|---|---|---|
| 40 | **Calendar rule: keep her stated cycle length until three periods are logged?** Today, logging her second period removes two of the three ranges and the fertile window, because femio switches to "learning from your log" and ignores the length she gave (reproduced; PROGRESS R14.8). Recommended: yes, keep the stated length (low confidence, dashed) until three starts, then use her own cycles. **Decided 2026-11-26 (owner, verbatim): "Yes, keep it."** Built by the hackathon session (R14.7, R14.8) | A medical-rules decision | Done |
| 41 | **Fertile window in "Track my period" mode: show it (with the sentence that it is not a way to avoid pregnancy, MR-15) or show it only in "Trying to conceive"?** Today it is drawn in both modes without that sentence on the calendar (R14.9). Recommended: show it in both, always with the MR-15 sentence | Product and safety call | 2 min |
| 42 | **App Check while judges test.** A sideloaded APK cannot pass Play Integrity, so with enforcement on, Cloud boost is refused for judges (on-device and rules still work). Recommended: keep enforcement on, say so in the testing steps, and show a real cloud run in the video. The alternative (enforcement off until judging ends) weakens the security story | Your console and your risk | 2 min |
| 43 | **Real-phone proof run** (this is rows 25 and 26 in practice). Install the build a session sends, register its App Check debug token, then: Settings → Assistant (status), "+" → Tell femio anything (Say it), Ask femio one question, switch Cloud boost on and ask one general question, then Settings → Assistant → What the AI did. Send the screenshots and say whether the phone shows "Ready". Nothing has run against real Gemini Nano or Firebase yet, and the submission's main claim depends on it | Your phone and console | 30 min |
| 44 | **Pregnancy warning-sign list (MR-29).** The card lists 7 signs and cites CDC Hear Her, which lists more (fever, fainting, thoughts of harming yourself or the baby, chest pain, severe vomiting, fluid leaking, leg swelling, overwhelming tiredness). Approve adding them, or name the ones to leave out (R14.11) | Clinical sign-off | 10 min |
| 45 | **Website deploy for the truth fixes.** When R14.2 and R14.4 are built, say "deploy" so the live privacy pages stop promising that names are removed and the site links the test build | Production deploy | 1 min |
| 46 | **Movement log, clinician check (CLIN-20, MR-30).** The log counts movements and times each session; the 1.5x flag is a design heuristic, and some UK guidance prefers "know your baby's usual pattern" to counting [NEEDS SOURCE: RCOG / NHS reduced fetal movements]. The urgent line ("contact your maternity team now, do not wait") is correct. Recommended: you read MR-30 against the NHS page and say "keep" or "switch to pattern wording"; until then it ships as is | Clinical review | 10 min |

## Calculators (R13, 2026-11-25)

| # | What | Why only you | Time |
|---|---|---|---|
| 37 | **PCOS visit checklist: yes or no?** A page or app tool that lists PCOS symptoms and questions to bring to a clinician, with no score and no "you may have PCOS" (D-04 bars a screener in v1). Say yes and a session builds it from the cited PCOS guide (PROGRESS R13.6) | A product and regulatory call | 2 min |
| 38 | **Read the new Arabic calculator wording** on `/ar/calculators/due-date`, `/pregnancy-calendar`, `/pregnancy-weight-gain`, `/contraction-timer` (screenshots in `testing-results/2026-11-25-r11-calculators/`); note any line to change (PROGRESS R13.7) | Clinical Arabic register | 15 min |

## Now (before the release candidate)

| # | What | Why only you | Time |
|---|---|---|---|
| 1 | **Create the Google Play Console account** ($25, one-off) at play.google.com/console | Google verifies your identity | 20 min |
| 2 | **Probably done; please confirm (audit 2026-11-26, REL-6):** `E:\_Private\femio-upload-keystore.jks` (29 Oct) and a git-ignored `key.properties` exist in the main checkout. Confirm that the keystore has a backup copy. Original step: **Create the upload keystore** and keep it outside the repo: run the command in `docs/33_REBUILD_V3/05_RELEASE_RUNBOOK.md` §2, then copy `apps/mobile/android/key.properties.example` to `key.properties` and fill it in. Back the `.jks` file up somewhere safe: losing it means a new app listing | A signing key is an identity | 10 min |
| 3 | ~~Fill the three legal placeholders~~ **Done 2026-10-30**: `info@femioapp.com` (receives mail, you tested it), KM Digital Labs, sole proprietorship, commercial register no. 682-374-954 | | |
| 4 | **Pause the Supabase project** (Settings → General → Pause) and **delete the `femio-cms` Vercel project**. Before pausing, if you ever edited translations in the old CMS translation portal, export them first: SQL editor → `select key, locale, value from ui_strings where status = 'human_reviewed' and locale <> 'en'` → CSV → send to a session to merge | Account owner only | 10 min |
| 39 | **Clinical read of the content revision (R3.10)**: the medical changes are listed in the commit messages `d83c7c1` (guides) and `114b2a2` (app and website strings), and the items left for you in `docs/33_REBUILD_V3/research/CONTENT_REVISION_2026-11.md`. Approve, or name the lines to revert | Medical sign-off is yours | 30–45 min |

## When a session sends a build

| # | What | Why only you | Time |
|---|---|---|---|
| 5 | **Install each test APK on your phone** and say what is wrong, in Arabic and English. Current candidate (2026-11-01, built from main `6fe965b`): `apps/mobile/build/app/outputs/flutter-apk/app-release.apk` (Google test ads show because `ads.env` is absent). While you are there, hold two of the store screenshots (`docs/store/screenshots/ar/`) next to the same screens | Real phone, real use | 10 min each |
| 6 | **Find 12 testers who keep the app installed for 14 days** (Google requires it of a new personal developer account). The recruitment message in Arabic and English is in `docs/33_REBUILD_V3/04_GROWTH_PACK.md` §5 | Your people | messages |
| 7 | ~~Say "publish"~~ **Done 2026-10-30 (ADR-077)**: legal pages, all 11 Arabic guides, every English guide and the PCOS treatment guide are signed off and published | | |
| 8 | **Listen to the calculator with NVDA once** (ticked on the dashboard on 2026-10-28, but `nvda-notes.md` does not exist: write the three things you heard, or say "skip NVDA") (free screen reader, nvaccess.org, 15 min to install). Open `femioapp.com/ar/calculators/fertile-window`, press Tab until a day is read out, use the arrow keys, press Enter, and note whether NVDA reads: the full date on each day, the result sentence after Enter, and nothing twice. Write what you heard in `testing-results/2026-10-28-calendar-a11y/nvda-notes.md` (a session turns it into fixes). The keyboard part is already automated (`apps/web/e2e/calculators.spec.ts`); NVDA is not installed on this PC | A screen reader is heard, not tested in code | 20 min |
| 9 | ~~Three Arabic content decisions~~ **Done 2026-10-30 (ADR-077 and its addendum 2: conservative scope kept, تكيّس المبايض kept, أهل العلم الشرعي in the Ramadan guide per your dashboard answer to question 9c)** | | |
| 10 | ~~Confirm two pregnancy red-flag symptoms~~ **Done 2026-10-30: NHS pages recorded in MR-29; the card shows both signs (R4.14)** · (register MR-29): the app and website list the five ACOG/CDC Hear Her signs (severe headache, vision changes, upper-abdominal pain, swelling of the face or hands, difficulty breathing). Bleeding and reduced movements are standard additions with no source in `docs/compliance/`. Name an NHS or RCOG page and a session adds them to both, or say no | A medical claim needs your source | 10 min |

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
| 12 | **Superseded by ADR-080 (2026-11-24): only Search Console is still wanted; GA4, Tag Manager and Meta Pixel are removed, see row 31.** ~~Create the measurement accounts~~ you own: Search Console (guide part B), GA4 (C), Tag Manager + consent banner (D), Meta Business + Pixel (E). Put `NEXT_PUBLIC_GTM_ID` into Vercel yourself (D8); the site sends nothing until you do. Also create the one-question feedback form (any form tool; the form must warn "do not include health details") and give a session its URL | Google and Meta verify your identity; the ids belong to you | 2 hours over a week |
| 13 | **Create the Canva account and the social handles** `femioapp` (Instagram, TikTok, Snapchat, X, WhatsApp Channel, Facebook Page) with the bilingual bio (guide part F) | Accounts are in your name | 1 hour over a few days |
| 14 | **Start the growth routines** ("create the growth routines", part G), then each week: "review this week" and answer publish / fix / hold; drop the Play CSV weekly | Only you can say publish | 45 min a week |
| 15 | **Apply to AdSense** when the site has steady readers (part H), set the blocking list. The code is built (R6.8): put `NEXT_PUBLIC_ADSENSE_CLIENT` (`ca-pub-…`) and the three slot variables into Vercel yourself (dashboard phase 4); ads fill only after the consent tool grants `ad_storage`, so the consent tool must show to every visitor (the free certified tool in part D7, not AdSense's EEA-only message) or non-EEA readers never see one | Payments and identity | 20 min + waiting |
| 16 | **Play payments profile and the `femio_plus` subscription** with monthly and yearly plans (part I; February 2027). Read the EGP and SAR rows Play shows and round them | Merchant identity and bank | 30 min |
| 18 | ~~Decide ADR-076~~ **Done 2026-10-29: accepted** (ads on both; her health data never leaves the phone). **Reversed 2026-11-24 by ADR-080: no ads in the app** | — | — |
| 20 | **Superseded by ADR-080 (2026-11-24): the app has no ads; see row 32.** ~~AdMob account and ids~~ (dashboard phase 4, items `admob-account`, `admob-units`, `ads-env`, `app-ads-txt`): create the AdMob account on the same Google account, add the Android app (package `com.femioapp.femio`, "not yet on Play"), create two banner units (`femio-article`, `femio-learn`), copy the app id and the two unit ids into `apps/mobile/ads.env` (copy of `ads.env.example`, git-ignored, never into chat), put the `pub-` publisher id into Vercel as `NEXT_PUBLIC_ADMOB_PUBLISHER`, then in AdMob verify `app-ads.txt`. In Play: Ads = Yes, and the Data safety rows in `docs/store/data-safety-and-declarations.md` | Accounts and ids are yours | 40 min |
| 19 | **Run the Play Billing probe on your phone once** (`flutter run --profile`, Settings → About → *femio Plus · billing check*) and send a session the line it shows plus any `SecurityException` in `adb logcat`; proves the billing library lives without INTERNET on a real device | Needs a phone signed in to Play | 10 min |
| 17 | **Spend 20–60 minutes with Flo, Clue and one Arabic app** on your phone: count ad units on an article and a calculator, note where the paywall appears; write the counts into `docs/34_GROWTH_OPS/reports/2026-10-28-competitor-monetization.md` §2 | Only a phone shows the real units | 1 hour |
| 21 | **Delete two legacy Vercel variables** on project `femio-web`: `NEXT_PUBLIC_BETA_INVITE_CODE` and `NEXT_PUBLIC_ENABLE_GOOGLE_AUTH` (the v2 sign-in era; nothing in `apps/web` reads them). Keep `NEXT_PUBLIC_APP_URL` and `NEXT_PUBLIC_CRISIS_DIRECTORY_URL`, both in use | The session's Vercel connector can read and add variables but not delete them | 2 min |
| 22 | **Branch protection: DEFERRED.** GitHub's message on your dashboard note is right: rulesets and branch protection are not enforced on a private repository on the Free plan. Options: GitHub Team ($4/user/month) or leave it. Recommendation: leave it; the session protocol already never pushes `main` without your word, and you are the only committer | Your money | — |

## Decisions already made (unchanged)

D1–D8 and ADR-072 stand: the TTC → pregnancy wedge, Saudi + Egypt, Arabic first, the private
Android app, the website as its front door, Dusk Bloom, no database, calendar calculators.
Every other decision has a default in `docs/33_REBUILD_V3/01_PRODUCT_SCOPE.md` §6; a session
proceeds on it and tells you at the next checkpoint.
