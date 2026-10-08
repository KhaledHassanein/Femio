# Tester guide: what to test, and how (no account needed)

Written 2026-10-08. Forward this page to anyone helping test Femio. **Nobody needs an
account or a password**: the website is fully public, and the Android app keeps
everything on the phone, with no sign-in.

Why there is no test login: the website's sign-in and tracker were closed when the
Android app became the product (decision D8), and the app has no accounts by design
(D7: health records stay on the phone). A web login would mean testers typing health
data onto our servers, which is the exposure the private design avoids.

---

## 1 · The website (5–15 minutes, any phone or computer)

Open **https://femioapp.com**. The site chooses a language from the phone; switch with
the language menu at the top (العربية · English · Français · Español).

Please try, in **Arabic and in one other language**, on your **phone**:

1. **Homepage.** Does it say clearly what Femio is? Tap each goal card (period, trying
   to get pregnant, pregnant, menopause): does it take you somewhere useful?
2. **Calculators** (`/calculators`). Try at least three: period, ovulation (fertile
   window), due date, pregnancy test timing, pregnancy week. Enter real-looking dates.
   Is the result clear? Is anything confusing or alarming?
3. **Learn** (`/learn`). Search for something you would really ask ("late period",
   "spotting in pregnancy", "PCOS"). Open two articles. Are they readable?
   *Articles are in English for now; Arabic articles are being written and reviewed.*
4. **Dark mode.** Switch your phone to dark mode and look at two pages again.
5. **Get the app** (`/app`). Is it clear what the app does and that it is private?

## 2 · The Android app (a few days of normal use)

1. Install the newest `femio-…-android.apk` (from the owner). Android asks once to
   allow installs from that source: allow it. If it says "App not installed",
   uninstall the older femio first.
2. Answer the first questions honestly (or make up a realistic person), then use
   **Today**, **Calendar** and **Log** for a few days.
3. If you pick "I'm pregnant", open the four pregnancy tools from Today.

## 3 · How to report

For each problem, send the owner: **(1)** a screenshot, **(2)** the page or screen,
**(3)** the language and light/dark, **(4)** what you expected instead. "This felt
confusing" is as useful as "this is broken". Never send real health details about
yourself in a report; describe the screen instead.

---

## Owner notes (not for testers)

- **Play Store closed testing** (Step 2 in the owner guide) is where tester "accounts"
  do exist: testers are added by their Gmail address in Play Console → Testing →
  Closed testing → Testers (an email list or a Google Group). A personal developer
  account needs **12 testers for 14 days** before the app can go public.
- **If you still want a web login for testers**, three things are needed, in order:
  the database back (wait for the Supabase billing month to reset, or upgrade the plan),
  the tracker switched on for preview links only (production stays closed), and tester
  accounts created. Ask Claude and it will do the second and third. Not recommended,
  for the privacy reason above.
