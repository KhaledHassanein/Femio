# Owner guide, A to Z: everything only you can do, click by click

Rewritten 2026-10-08. Written for someone who is not a developer. ✅ = done, ☐ = still to
do, ➖ = no longer needed (the plan changed). Do the ☐ items in any order unless a step says
otherwise. If anything looks different from what is written, paste a screenshot or the
message into the chat. Nothing here can break the app if you stop halfway.

---

## Done (nothing to do)

- ✅ **Supabase over-use stopped.** The website no longer reads the database on a page view.
  You chose to stay on the free plan; the restriction lifts by itself after the billing
  month resets.
- ✅ **SQL file run in Supabase** (security fixes and cleanup), verified in the database.
- ✅ **Pull request #22 merged** (security fix, new design).
- ✅ **Vercel connector given full access.**
- ✅ **Pull request #26 merged** by Claude (2026-10-08): the website is now the app's front
  door, with the new homepage, calculators and "Get the app" page live on femioapp.com.
- ✅ **Decisions D1–D8 made**, including D7 (records stay on the phone) and D8 (the website
  promotes the Android app; web sign-in closed).

## No longer needed (the plan changed)

- ➖ **Upgrade Supabase to Pro.** The app keeps records on the phone, so there is no reason
  to pay for the database now.
- ➖ **Leaked-password protection** and **staging Supabase project.** There are no accounts
  in the app (D7).
- ➖ **Purge test accounts.** The old web accounts will go when Supabase is retired.
- ➖ **Beta invite code.** Web sign-in is closed, so the code no longer guards anything.

---

## Step 1 · Try the app on your Android phone (5 min) ☐

1. Open this chat in the Claude app on your phone and download the newest
   `femio-…-android.apk` file Claude sent.
2. Tap the file. Android asks to allow "install unknown apps" for that app once: allow it.
3. Tap **Install**, then **Open**. If it says "App not installed", uninstall the older
   femio first (test builds are signed with a temporary key).
4. Go through the questions, then use Today, Calendar and Log for a day or two.
5. Tell Claude what feels wrong, confusing or missing. Screenshots help.

## Step 2 · Google Play developer account (20 min, $25 once) ☐

Needed before the app can be published. Do this soon: a new personal account must run a
closed test with **12 testers for 14 days** before it can go public.

1. Decide **personal** or **organisation** account. Organisation skips the 12-tester rule
   but needs a **D-U-N-S number** for your company (free from Dun & Bradstreet, takes days
   to weeks). If you have a registered company, organisation is better.
2. Go to **https://play.google.com/console** → sign in with the Google account you want to
   own the app → **Create account** → choose personal or organisation → pay $25.
3. Verify your identity when Google asks (ID photo; organisations also the D-U-N-S).
4. Tell Claude "Play account ready". Claude then prepares the listing (Arabic and English
   text, screenshots, the privacy declarations) and walks you through the upload and the
   signing key, click by click.

## Step 3 · Tell Claude where your company is registered (1 min) ☐

Type it in the chat (for example "Egypt, sole proprietor" or "UAE free-zone LLC", or "not
registered yet"). It changes what the lawyer needs to answer for Egypt.

## Step 4 · A privacy lawyer, four short questions (1 hour to brief) ☐

Start this week: Egypt's data-protection rules are enforced from **31 October 2026**. Send
the lawyer `docs/compliance/PRIVATE_LAUNCH_V1.md` §6. Because the app keeps health records
on the phone, the questions are short: does Femio need an Egypt licence or local
representative for website logs and crash reports alone, the same for Saudi Arabia and the
UK, and a review of the privacy policy Claude will draft. Ideally an Egypt-qualified
lawyer who can refer Saudi and UK questions.

## Step 5 · An Arabic-speaking medical reviewer ☐

Nothing medical is published in Arabic without a named reviewer. Either name a clinician
(ideally OB-GYN: name, credentials, one-line bio) or tell Claude you will review Arabic
yourself, and it is recorded that way.

The same reviewer is needed in English too: 25 of the 100 guides on the website name a
reviewer and 75 do not yet. The homepage now says only that a reviewed guide names its
reviewer. If you review them yourself, Claude adds your name, credentials and bio once,
and they appear on each guide you approve.

## Step 6 · Google Search Console (10 min, any time) ☐

This tells Google your site exists and shows what people search to find it.

1. Go to **https://search.google.com/search-console** → **Add property** → choose
   **Domain** → type `femioapp.com` → Continue.
2. Copy the **TXT record** Google shows (it starts `google-site-verification=`).
3. Open where you bought **femioapp.com** (GoDaddy, Namecheap, Cloudflare…) → **DNS
   settings** → **Add record** → Type **TXT**, Name/Host **@**, Value = what you copied →
   Save.
4. Back in Search Console click **Verify** (DNS can take up to an hour; retry if needed).
5. Left menu **Sitemaps** → type `sitemap.xml` → **Submit**.

## Later (Claude tells you when)

- ☐ **Pause Supabase.** After Claude retires the article editor and moves the last
  translation table into the website, Claude tells you, and you pause the project:
  Supabase → **Femio** → **Settings** → **General** → **Pause project**.
- ☐ **Play Store signing key.** Done together with the first upload (Step 2); Google keeps
  the key safe with "Play App Signing", so there is nothing to lose.
- ☐ **iPhone app.** After the Android launch: needs an Apple Developer account ($99 a year)
  and a Mac or a paid cloud build service. Not yet.

---

When you finish a step, type it in the chat (for example "Step 2 done, personal account").
Claude checks what it can from its side and carries on.
