# 06 — Launching femio, A to Z

**For Khaled.** Plain words, in order, with what to paste. Nothing here needs a developer: when a
step says "a session", open Claude Code in the repo and paste the line in quotes. Every step says
how long it takes and what "done" looks like. The texts you paste into Google Play are in
`04_GROWTH_PACK.md` §4 (ASO pack) and `03_LEGAL_PACK.md` §4 (Play answers); this guide points
at them rather than repeating them.

**The shape of it.** A → get the accounts and keys (one evening). B → the website goes live
(one session). C → the app reaches your phone (one session, then you). D → the closed test with
12 testers (14 days, mostly waiting). E → production access and the soft launch. F → the first
100 women. Dates: release candidate 9 Nov, closed test 11–25 Nov, soft launch the week of 30 Nov
2026 (D5). Everything slips day for day with the release candidate.

---

## A · Accounts and keys (one evening, about 1 hour)

### A1 · Google Play Console account (20 min, $25 once)
1. Go to **play.google.com/console** and sign in with the Google account that will own femio
   for good (not a work account you might lose).
2. Choose **"Yourself"** (personal developer account). Pay the one-time **$25**.
3. Identity verification: Google asks for a government ID and may send a letter or a code. Use
   your legal name and your Cairo address. This can take a few days; start it now.
4. Done when: the Console shows "Verified" on the account.

*Why personal and not an organisation account:* you are the only person in every role; an
organisation account needs a D-U-N-S number and company documents. The cost of a personal
account is the closed-test rule in step D.

### A2 · The signing key (10 min, once, keep it forever)
The key proves every future update comes from you. Lose it and femio has to start as a new app.
1. Open PowerShell on your PC and run the `keytool` command in `05_RELEASE_RUNBOOK.md` §2. It
   asks for a password and your name. Choose a long passphrase and save it in your password
   manager under "femio upload key".
2. Copy the `.jks` file to a second place (an offline drive or the password manager's attachments).
3. Copy `apps/mobile/android/key.properties.example` to `apps/mobile/android/key.properties`
   and type the path and passwords in. This file is ignored by git; never commit it.
4. Done when: `flutter build appbundle --release` in `apps/mobile` finishes without "debug".

### A3 · The three legal placeholders (5 min)
Open `apps/web/src/lib/legal/placeholders.ts` and fill in: the legal entity (KM Digital Labs
and its registration number or your name as a sole trader), the privacy contact email (one you
read), and the effective date (the launch week). A session can do this if you tell it the values.

### A4 · Close the old cloud (10 min)
1. **Supabase**: supabase.com → project → Settings → General → **Pause project**. If you ever
   edited translations in the old CMS portal, run the export line in
   `docs/runbooks/OWNER_ACTIONS.md` #4 first.
2. **Vercel**: delete the `femio-cms` project. Keep `femio` (the website).
3. In the `femio` Vercel project → Settings → Environment Variables: delete everything except
   `NEXT_PUBLIC_APP_URL`. (A session can list what is there if you paste a screenshot.)
Done when: the Supabase dashboard says Paused and Vercel shows one project.

---

## B · The website goes live (one session, 1 hour)

1. Tell a session: **"Merge the v3 branch into main and deploy"**. It runs the gate, merges,
   pushes; Vercel builds `main`. (The branch today: `claude/femio-repo-study-planning-88d7c9`.)
2. On your phone, open **femioapp.com/ar/calculators/fertile-window**: tap a day; the window
   draws on the calendar; the Hijri date shows under each day.
3. Open **femioapp.com/ar/privacy**: your entity, email and date appear where the highlighted
   placeholders were.
4. Open **femioapp.com/en/help-now**: choose Egypt; the numbers appear with their sources.
5. Share any article link in WhatsApp: the preview card shows the plum "femio" image.
6. Google Search Console (optional, 10 min): search.google.com/search-console → add property
   `femioapp.com` → verify with the HTML tag → paste the token into Vercel as
   `NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION` → submit `https://femioapp.com/sitemap.xml`.
Done when: steps 2–5 look right on your phone.

---

## C · The app reaches your phone (one session + 30 min of you)

1. Tell a session: **"Build the release candidate APK and bundle for R4.12"**. It bumps the
   version, builds both files, and tells you where the APK is
   (`apps/mobile/build/app/outputs/flutter-apk/app-release.apk`).
2. Copy the APK to your phone (USB, or send it to yourself) and install it. Android will warn
   about an unknown source; allow it once.
3. Run the six checks in `05_RELEASE_RUNBOOK.md` §4 (onboarding in Arabic, PIN, backup, delete
   and restore, airplane mode, both themes). Write what is wrong in one message to a session:
   "On the Today screen in Arabic, …". Each round is one session.
4. Done when: you would hand this phone to your wife or sister without explaining anything.

---

## D · Play Console: listing, forms, closed test (2 hours of you, then 14 days)

### D1 · Create the app (10 min)
Console → **Create app** → name **femio** → default language **Arabic (Saudi Arabia)**, then
add English, French and Spanish listings → app (not game) → free → accept the declarations.

### D2 · Store listing (30 min)
Open `docs/store/play-listing.ar.md` and `docs/store/play-listing.en.md` beside the Console and paste:
- **Title** (29 chars AR / 28 EN) and **short description** from the top of each file.
- **Full description** AR and EN. The ship-gated lines are already resolved against the
  build (`docs/store/README.md` says which); fill the support email first. Keep the "not a
  medical device" paragraph; Google requires it. `pnpm store-lint` checks the limits.
- **Screenshots**: 8 per language, from the real app (a session makes them with
  `flutter test --update-goldens`; captions in §4.4). The Arabic set first.
- **Feature graphic** 1024×500 (§4.5) and the icon (`apps/web/public/icons/icon-512.png`).
- **Category** Health & Fitness; **contact email** the one from A3; **privacy policy URL**
  `https://femioapp.com/ar/privacy`.

### D3 · The forms (30 min, answer exactly as written)
Console → Policy → App content:
- **Privacy policy**: the URL above.
- **Ads**: **Yes, my app contains ads** (Google AdMob banners on the guide screens only, ADR-076).
- **App access**: all features available without special access.
- **Content rating**: the IARC questionnaire; answer literally (`03_LEGAL_PACK.md` §4.4).
- **Target audience**: 18 and over; tick "restrict minor access"; no, it does not appeal to
  children.
- **Data safety**: paste the answers in `docs/store/data-safety-and-declarations.md` line by line
  (checked against Google's ads SDK page on 2026-11-01; full table in
  `docs/store/PLAY_POLICY_CHECK_2026-11.md`). Collects: **Yes**, and only through Google's ads SDK:
  device or other IDs, approximate location, app interactions, diagnostics. **Nothing from her
  record.** Deletion: **Yes, in Settings** (her record); the advertising ID is reset in Android
  settings. (Corrected 2026-11-01: this step said "No" from before ads were added.)
- **Health apps declaration**: Period tracking; Reproductive and sexual health; Medical
  reference and education; Emergency and first aid (the Help now screen lists emergency numbers). Nothing under medical device or clinical decision support
  (`03_LEGAL_PACK.md` §4.2).
- **Government apps / Financial features / News**: No.

### D4 · Find the 12 testers (your messages, 2 days)
Google requires **12 people who keep the app installed for 14 consecutive days** before a
personal account may publish. Aim for **16**, because one who uninstalls on day 10 restarts the
clock. Send the message in `04_GROWTH_PACK.md` §5.5 (Egyptian Arabic, Gulf Arabic, English
versions) to friends, family, colleagues and your clinic's staff. Ask each for the Gmail address
they use on their phone.

### D5 · Start the closed test (20 min)
Console → Testing → **Closed testing** → create track → upload the `.aab` a session built →
release notes (two lines, AR and EN) → add the testers' emails (or a Google Group) → **Start
rollout**. Send every tester the opt-in link the Console shows. Write the start date in
`docs/33_REBUILD_V3/PROGRESS.md` R5.4.

### D6 · During the 14 days
- Every message from a tester goes to a session as it is ("Mona says the Hijri date is one day
  off"). The session fixes, gates, and tells you when a new bundle is ready; upload it to the
  same track. Updates do not restart the 14 days; uninstalls do.
- Check the Console weekly: Testing → Closed testing → the tester count must stay ≥ 12.

---

## E · Production access and the soft launch (about a week of waiting)

1. On day 15, Console → **Apply for production access**. Describe the test honestly: who the
   testers were, what you fixed, what the app does. Google usually answers in about seven days.
2. When approved: Production → **Create release** → upload the latest `.aab` → **Countries**:
   Egypt and Saudi Arabia first (add the rest later) → roll out.
3. Tell a session: **"The app is live at <Play URL>; wire the store link"**. It sets
   `PLAY_STORE_URL` in `apps/web/src/lib/site.ts`, redeploys, and every "Get the app" button on
   the site goes to Play.
4. Done when: a stranger in Riyadh can search "femio" on Play and install it.

---

## F · The first 100 women (6 weeks)

The plan, channels, calendar and the one-question feedback link are in `04_GROWTH_PACK.md` §5.
In short: QR cards in the clinic, a WhatsApp Channel, Egyptian Facebook groups, three posts a
week each tied to one article or calculator, and the Ramadan set live by 11 January 2027. You
measure with Play Console installs and the feedback link, not with analytics in the app.

---

## If something goes wrong

| Symptom | Do |
|---|---|
| Play rejects the bundle: "Health apps declaration" | Reopen D3 and tick the three features; re-submit |
| Play rejects: "Data safety does not match" | Tell a session: "Play says Data safety mismatch"; it re-runs the privacy tripwire and tells you what changed |
| A tester cannot install: "not available in your country" | Add the country under Testing → Countries |
| You lost the keystore | Stop. Tell a session; the app must be re-created under a new package name |
| A tester's records vanished | They uninstalled; records live only on the phone. Restore from their backup file if they saved one |
| The website shows the old design | Vercel built an older commit; tell a session "redeploy main" |
