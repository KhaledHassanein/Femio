# 04 — Growing femio after launch, A to Z: every step you do by hand

**For Khaled.** This continues `docs/33_REBUILD_V3/06_LAUNCH_GUIDE_A_TO_Z.md` (accounts, the
closed test, production). That guide gets the app into Play; this one sets up everything that
measures, earns and feeds the site afterwards. Same rules: plain words, in order, each step
says how long, what to click, what to paste and what "done" looks like. When a step says *a
session*, open Claude Code in the repo and paste the quoted line. Nothing here needs you to
write code.

**One decision first, before parts C–E and H:** ADR-075 in `docs/DECISIONS.md`. It changes
one sentence of rule 4 so the *website* may measure visits and carry ads, after consent and
without anything a woman typed. The app stays untouched. Say **"accept ADR-075"**, **"accept
without ads"**, or **"decline"** to a session. If you decline, do parts A, B, F, G only.

**The shape of it.** A → repository safety (10 min). B → Search Console (15 min, no decision
needed). C → Google Analytics 4 (20 min). D → Google Tag Manager + the consent banner
(40 min, the most careful part). E → Meta Business + Pixel (30 min). F → Canva and the social
accounts (1 hour over a few days). G → the agent routines (20 min + 45 min a week forever).
H → AdSense (20 min to apply, then waiting). I → Play payments profile and the premium
product (30 min, in February). J → ASO upkeep (monthly, 15 min). The interactive checklist
(https://claude.ai/artifact/V3exHDJpZasUkRoWuameDp, private to you) mirrors every step; tick there as
you go.

**Where things live.** Keep a single page in your password manager called "femio growth" with
every id this guide produces (Search Console property, GA4 Measurement ID `G-…`, GTM container
`GTM-…`, Meta Pixel ID, AdSense publisher id `pub-…`). Never paste an id into chat; a session
only ever needs the public ones (`G-`, `GTM-`, `pub-`), and you put those into Vercel yourself
(part D step 8 shows how).

---

## A · Repository safety (10 min, once)

Why: from now on agents open pull requests every week. `main` must accept nothing without you.

1. github.com → your femio repository → **Settings** → **Branches** → **Add branch ruleset**
   (or "Add rule" on older UI). Name: `main`. Target: `main`.
2. Tick **Require a pull request before merging**, approvals **1**. Tick **Require status
   checks to pass**: search and add the Vercel check (`Vercel`) and, if the gate runs in
   Actions, `gate`. Tick **Block force pushes**. Save.
3. Settings → **Actions** → **General** → Workflow permissions: **Read repository contents**,
   and tick **Allow GitHub Actions to create and approve pull requests** (routines open PRs).
4. Done when: a session says "push to main" and GitHub refuses with "protected branch"; the
   session then opens a PR instead and you press **Merge**.

---

## B · Google Search Console (15 min, no decision needed)

Why: it is the only place that shows which Google searches show femio, free, no cookie, no
banner. Routine R1 reads it every Monday.

1. search.google.com/search-console → **Add property** → choose **Domain** → type
   `femioapp.com` → Continue.
2. Google shows a TXT record. Open vercel.com → your team → **Domains** → `femioapp.com` →
   **DNS Records** → **Add**: Type `TXT`, Name `@` (leave blank if Vercel says so), Value =
   the string Google showed → Save. Back in Search Console press **Verify** (DNS can take up
   to an hour; press Verify again later if it fails).
3. In Search Console → **Sitemaps** → paste `https://femioapp.com/sitemap.xml` → Submit.
4. Settings (gear) → **Users and permissions** → add the Google account you use with the
   Ahrefs connector as **Full** if it is different from the one you used here (R1 reads
   through it).
5. Done when: Sitemaps shows "Success" with a page count; after 2–3 days **Performance**
   shows impressions. Tick B in the checklist and write the property name on your
   "femio growth" page.

*Alternative if DNS is awkward:* URL-prefix property `https://femioapp.com` → HTML tag method →
copy only the `content="…"` value → Vercel → Project **femio-web** → Settings → Environment
Variables → `NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION` = that value → Redeploy (Deployments →
⋯ → Redeploy). The site already prints the tag when the variable exists.

---

## C · Google Analytics 4 (20 min; after "accept ADR-075")

1. analytics.google.com → **Admin** (gear, bottom left) → **Create** → **Account**. Name
   `KM Digital Labs`. Data-sharing boxes: untick all except "Technical support". Next.
2. **Property**: name `femio website`, time zone `(GMT+02:00) Cairo`, currency `US Dollar`.
   Next. Business details: industry **Health**, size **Small**. Objectives: tick **Examine user
   behavior** only. Create. Accept the terms (Egypt as country). **Also open the "Data
   Processing Terms" and accept them** (needed for EEA visitors).
3. **Data stream**: Web → URL `https://femioapp.com`, stream name `femioapp.com` →
   **Enhanced measurement**: leave ON but open the gear and **untick "Form interactions"
   and "Site search"** (the site has neither; fewer surprises). Create stream.
4. Copy the **Measurement ID** (`G-XXXXXXXXXX`) to your "femio growth" page. Do not install
   the tag Google offers; GTM will carry it (part D).
5. Admin → **Data settings** → **Data collection**: **turn OFF "Google signals"** (no
   cross-device profiles; this is a health site). **Data retention**: 14 months. **Data
   collection → Granular location and device data**: untick EEA countries' city precision if
   offered.
6. Admin → **Data filters**: the "Internal traffic" filter → set to **Active** and in **Data
   streams → Configure tag settings → Define internal traffic** add your home IP so your own
   visits are excluded.
7. Admin → **Property access management** → add the account used by routines as **Viewer**
   (same account as B step 4).
8. Done when: Admin → Data streams shows the stream with the `G-` id; nothing else yet (no
   data until part D is live). Tick C.

---

## D · Google Tag Manager and the consent banner (40 min; the careful part)

Why: one GTM script in the site carries every tag after it, and a certified banner makes every
tag wait for consent. The site code for this is built by a session (`01_ANALYTICS_AND_PIXELS.md`
§6); your part is the container and the banner.

1. tagmanager.google.com → **Create account**: name `KM Digital Labs`, country Egypt.
   **Container**: name `femioapp.com`, platform **Web** → Create → accept terms. Copy the
   container id **`GTM-XXXXXXX`** from the top bar to your "femio growth" page. Close the
   install dialog (the session installs it).
2. Left menu **Admin** → **Container settings** → tick **Enable consent overview**. Save.
3. **Tags** → **New** → name `GA4 · configuration` → Tag type **Google Tag** → Tag ID = your
   `G-…` → **Triggering**: "Initialization – All Pages" → Save.
4. Open the tag again → **Advanced settings → Consent settings** → "Require additional consent
   for tag to fire": add **analytics_storage**. Save. (This is the line that makes GA4 wait.)
5. **Variables** → **Configure** → tick everything under **Clicks** and **Pages**. Then
   **User-defined variables → New** → **Data Layer Variable** for each: `page_type`,
   `article_slug`, `calculator_slug`, `placement`, `from_locale`, `to_locale`,
   `source_host`, `country` (the site pushes these; names must match exactly).
6. **Triggers → New → Custom Event** for each event in `01_ANALYTICS_AND_PIXELS.md` §4
   (`article_read`, `calculator_open`, `calculator_used`, `get_app_click`, `help_now_open`,
   `language_switch`, `outbound_source_click`). Then **Tags → New → Google Analytics: GA4
   Event** for each, event name = the same, parameters = only the ones listed in that table,
   consent setting = analytics_storage, trigger = its custom event. Seven tags. **Or skip the
   typing:** the file `docs/34_GROWTH_OPS/gtm/femio-container.json` holds all of it (GA4
   configuration, the seven event tags, triggers, variables, consent settings). **Admin →
   Import Container → choose the file → Existing workspace → Merge → Rename conflicting**,
   then open **Variables → `const · GA4 measurement id`** and paste your `G-…` id. The
   README beside the file has the five steps.
7. **The consent banner.** Two routes; use the first:
   - **AdSense "Privacy & messaging"** (free, Google-certified, needs the AdSense account from
     part H even before ads are approved): adsense.google.com → **Privacy & messaging** →
     **GDPR** → **Create message** → sites: `femioapp.com` → languages: English, Arabic,
     French, Spanish → **Consent options**: tick "Do not consent" (so decline is one tap) →
     Styling: match Dusk Bloom (plum `#8A3572` button, cream `#FBF7F3` background) → Publish.
     Also create the **US state regulations** message (opt-out) and publish. The message
     tag is served through the AdSense script, which the session adds to the site when
     `NEXT_PUBLIC_ADSENSE_CLIENT` is set. **Verify in step 9 that it also updates Consent
     Mode for the GA4 tag**; if it does not, use the second route.
   - **A free certified CMP** (CookieYes, Cookiebot or similar, check the free tier's page
     limit against about 160 pages): sign up → add `femioapp.com` → enable **Google Consent
     Mode v2** and **IAB TCF v2.3** → languages EN/AR/FR/ES → copy the script → give the
     session the snippet URL, never a key: *"mount this CMP snippet before GTM"*.
8. **Put the ids in Vercel yourself:** vercel.com → project **femio-web** → **Settings** →
   **Environment Variables** → Add `NEXT_PUBLIC_GTM_ID` = `GTM-…` (Production, Preview) →
   Save → **Deployments** → latest → ⋯ → **Redeploy**. Then tell a session: *"GTM id is set
   in Vercel; verify consent on the preview"*.
9. **Verify (10 min, do it yourself once so you understand it).** In GTM press **Preview**
   → enter `https://femioapp.com/ar` → Connect. A new tab opens with a "Tag Assistant
   connected" badge. In the Tag Assistant window: the **Consent** tab shows every type
   **Denied** on load; no tag listed under "Tags fired" except nothing (the GA4 tag must sit
   under "Tags not fired"). Press **Allow** on the banner → the Consent tab flips
   `analytics_storage: Granted` → the GA4 configuration tag appears under "Tags fired".
   Open a calculator and tap a day → `calculator_open` then `calculator_used` events appear
   with only `calculator_slug`. If any tag fires before Allow, stop and tell a session
   exactly which tag.
10. GTM → **Submit** → version name `v1 consent + GA4` → Publish. In GA4 → **Reports →
    Realtime**: your visit appears within a minute (unless your IP is filtered).
11. Done when: step 9 behaves as written and Realtime shows a visit from another device.
    Tick D.

---

## E · Meta Business Suite and the Pixel (30 min; after "accept ADR-075")

Why: a pixel on the site builds an audience of visitors for organic reach later and shows
which Facebook/Instagram posts bring readers. Expect Meta to restrict a health domain to
"Core Setup"; the plan already assumes it.

1. business.facebook.com → **Create a business portfolio**: name `KM Digital Labs`, your
   name, your business email. Confirm the email.
2. **Settings → Business assets → Pages**: add or create the **femio** Facebook Page (name
   `femio`, category **Health & wellness website**, bio from `04_GROWTH_PACK.md` §1, Arabic
   first). Connect the Instagram account from part F when it exists.
3. **Settings → Data sources → Datasets** (older UI: Pixels) → **Add** → name
   `femioapp.com` → **Set up manually** → copy the **Dataset/Pixel ID** (digits) to your
   "femio growth" page. Do not install the code; GTM carries it.
4. **Events Manager → the dataset → Settings**: **Automatic advanced matching: OFF**.
   **Track events automatically without code: OFF** (we fire exactly three). Under **Data
   sharing restrictions** read what Meta applied; if it says Core Setup, nothing changes.
5. **Business Settings → Brand safety and suitability → Domains** → **Add** `femioapp.com`
   → verify by **DNS TXT** (Vercel → Domains → DNS Records, like part B step 2) or by the
   meta tag (give the `content` value to a session: *"set Meta domain verification tag"*).
6. In GTM (part D): **Tags → New → Facebook Pixel** template (search the Community Template
   Gallery: "Facebook Pixel" by facebookarchive/Meta, or the official "Meta Pixel" template)
   → Pixel ID = yours → Event: PageView → trigger All Pages → **Consent settings: require
   ad_storage and ad_user_data**. Two more Pixel tags: **ViewContent** on triggers
   `article_read` and `calculator_open`; **Lead** on `get_app_click`. No parameters. Preview
   as in D9: nothing fires before **Allow**; after it, PageView appears in Events Manager →
   **Test events** within a minute. Submit and publish `v2 meta pixel`.
7. Done when: Events Manager → Overview shows PageView from femioapp.com with "Browser"
   as the source. Tick E.

---

## F · Canva and the social accounts (about 1 hour, spread over a few days)

Handles: try **femioapp** everywhere (`femio` is likely taken); keep the same handle on every
platform. Bio (Arabic first, then English), from `04_GROWTH_PACK.md` §1: *سجلاتكِ لا تغادر
هاتفكِ — تطبيق خاص لتتبع الدورة والتخطيط للحمل · Your records never leave your phone* and the
site link with `?utm_source=<platform>&utm_medium=social`.

1. **Canva** (10 min): canva.com → sign up with the business Google account → Free plan.
   Then tell a session: *"build the femio Canva templates (G3)"*; it creates the six
   templates through the Canva connector and tells you where they are. Upgrade to Pro only if
   it asks for Brand Kit or Magic Resize.
2. **Instagram** (10 min): create a **Professional → Creator/Business** account, handle,
   bio, link. Connect it to the Facebook Page (part E step 2).
3. **TikTok** (10 min): Business account, same bio. Content from R5's vertical designs.
4. **Snapchat** (10 min): **Public Profile** for `femioapp` (highest female share in both
   markets, growth pack §5.1).
5. **X** (5 min): `femioapp`, Arabic bio, used for Saudi threads only.
6. **WhatsApp Channel** (5 min, from your phone): WhatsApp → Updates → **Create channel**
   → `femio` → bio → share the invite link; R5 writes a Channel version of each post.
7. **Facebook groups** (ongoing): join the Egyptian TTC/PCOS/ICSI groups from your personal
   profile as Dr Khaled; read each group's rules (growth pack §5.1 row 3).
8. Write every handle on your "femio growth" page and in `docs/34_GROWTH_OPS/social/ACCOUNTS.md`
   (public handles only). Tick F.

---

## G · The agent routines (20 min once, then about 45 min a week)

1. In Claude Code (desktop app) say: *"create the growth routines from docs/34_GROWTH_OPS/
   routines"*. The session uses `/schedule` to create R1 (Mon 07:00 Cairo), R2 (Tue 07:00),
   R5 (Wed 07:00), R6 (first Fri 07:00), R7 (Sun 18:00), each pointing at its file. It shows
   you the list; nothing else happens until the first schedule fires.
2. Each Sunday evening you receive R7's page; each Tuesday a PR. Any evening: open Claude
   Code and say **"review this week"**. Read the paragraphs. Answer each with one word:
   **publish**, **fix** (and what), or **hold**. For posts: **post 1, 2, 3** copies the text
   for you to paste into the platform (Buffer or Meta Business Suite's planner if you prefer
   to schedule). Fifteen minutes on Tuesday, thirty on Sunday.
3. Once a week, drop the Play Console export into the repo for R7: Play Console →
   **Statistics** → **Export report** (installs, retention) → save the CSV as
   `docs/34_GROWTH_OPS/reports/play/YYYY-WW.csv` (git-ignored; only summaries are committed).
   Or tell a session *"here is this week's Play CSV"* and attach it.
4. Once a month, paste the one-question feedback answers into
   `reports/feedback/YYYY-MM.md`, removing any health detail someone typed despite the warning.
5. Done when: the first R7 page and the first content PR exist and you have answered them.
   Tick G. Routines you want to stop: say *"pause R5"*.

---

## H · Google AdSense (20 min to apply; then days to weeks of waiting; after "accept ADR-075")

Apply when the site has steady readers (the plan's threshold: about 1,000 sessions a week or
eight weeks after launch, whichever comes first).

1. adsense.google.com → **Get started** → your site `femioapp.com` → country Egypt → accept
   terms. Google shows a code snippet with your **publisher id `pub-…`**: write the id on your
   "femio growth" page; do not paste the snippet anywhere.
2. **Payments → Payments info**: name and address exactly as on your bank account and ID.
   Payment method: add it when AdSense asks (Egypt: wire transfer to your bank; the account
   name must match; AdSense also sends a PIN by post to your address before the first
   payment, so the postal address must be real).
3. The code is already built (R6.8). Put `NEXT_PUBLIC_ADSENSE_CLIENT` = `ca-pub-…` (the id as
   AdSense prints it in the ad code, with `ca-`) into Vercel yourself (same place as D8) and
   redeploy: article and hub pages then load the AdSense script, which also carries the
   Privacy & messaging banner (D7), and `femioapp.com/ads.txt` prints your line. Back in AdSense
   press **Verify**. Then wait for the review email (days to weeks).
4. When approved: **Ads → By site** → turn **Auto ads OFF** (we place units ourselves) →
   **Ads → By ad unit → Display ads** → create `article-mid`, `article-end`, `hub-top`
   (responsive) → copy only the **slot numbers** (digits) → put them into Vercel as
   `NEXT_PUBLIC_ADSENSE_SLOT_ARTICLE_MID`, `NEXT_PUBLIC_ADSENSE_SLOT_ARTICLE_END` and
   `NEXT_PUBLIC_ADSENSE_SLOT_HUB_TOP` and redeploy. The placements are already in the code
   (`02_MONETIZATION.md` §1.1); a unit fills only after a visitor allows ads in the banner, so
   the banner must show to every visitor (the free certified tool in D7), not only in Europe.
5. **Brand safety → Content → Blocking controls → Sensitive categories**: block Dating,
   Drugs & supplements, Get rich quick, Politics, Religion, Sexual & reproductive health,
   Birth control, Cosmetic procedures, Astrology & esoteric, Weight loss, Significant skin
   exposure. Also **Ad serving → "Ad load"** slider to Low.
6. Done when: an article shows two labelled ads below the fold, Lighthouse performance on it
   stays ≥ 85 (the session runs it), and AdSense → Reports shows impressions. Tick H.

---

## I · Play payments profile and the premium product (30 min; in February 2027, before app release 2)

1. Play Console → **Setup → Payments profile** → **Create payments profile** → country
   Egypt, business type as your registration (KM Digital Labs), bank account in EGP, tax
   info. Google verifies within days. (Egypt is a supported merchant country.)
2. Play Console → your app → **Monetize → Products → Subscriptions** → **Create
   subscription**: Product ID `femio_plus`, name `femio Plus` (Arabic: `femio Plus`, keep the
   Latin wordmark), description from `02_MONETIZATION.md` §2.4.
3. **Add base plan** `monthly`: auto-renewing, 1 month, **Set prices** → base price USD
   `0.99` → the table shows every country; **read the EGP and SAR rows**: if Play's minimum
   is above the converted price it will say so; round EGP and SAR to the nearest local
   convention (e.g. 49 EGP, 3.99 SAR) by editing those rows. Grace period 7 days; account
   hold on. Activate.
4. **Add base plan** `yearly`: 1 year, USD `9.99`, same rounding (499 EGP, 37.99 SAR).
   **Add offer** → free trial 7 days → eligibility: new subscribers. Activate.
5. **Setup → License testing**: add your own Gmail and two testers' Gmails so purchases are
   free during the test. Then tell a session: *"premium products exist: femio_plus with
   monthly and yearly; integrate Play Billing (M4)"*.
6. Done when: in the internal test build, Settings → femio Plus shows both prices in EGP on
   your phone and a test purchase completes and restores after reinstall. Tick I.

---

## J · ASO upkeep (15 min a month)

1. Play Console → **Store performance → Store listing acquisition** (and **Search terms** when
   it appears): note the top terms by installs. Tell a session: *"ASO monthly: here are the top
   terms"*; it proposes changes to `docs/store/play-listing.{en,ar}.md` (title and short
   description first), you say publish, and you paste the new text into Console → **Store
   presence → Main store listing** → Save → the change goes live with the next review.
2. Reply to every review in its language within 48 hours (Console → **Ratings and reviews**).
   R6 drafts replies for the common ones; medical questions always get "talk to your doctor"
   + the article link.
3. Every quarter: refresh the 8 screenshots if a screen changed (a session renders them at
   1080×1920 from the golden tests) and upload under **Main store listing → Graphics**.
4. Tick J monthly in the checklist (it resets each month).

---

## If something goes wrong

| Symptom | Do |
|---|---|
| GA4 Realtime shows nothing after D10 | GTM Preview (D9): is the GA4 tag under "Tags not fired"? Then the consent did not flip; check the banner is published for `femioapp.com` and that the tag's consent setting is `analytics_storage`. Your own IP may be filtered (C6): try your phone on mobile data |
| A tag fires before Allow | Stop; tell a session which tag; it is a missing consent setting on that tag (D4/E6) |
| Meta says "Data sharing restrictions: Core Setup" | Expected; nothing to change |
| AdSense: "Site not ready" / "Low value content" | Wait two weeks of content PRs, then re-apply; the pages are sourced and signed, which is what the review looks for |
| AdSense: "Policy violation: sensitive" on a page | Tell a session the URL; it removes units from that page and appeals with the review trail |
| Lighthouse on an article drops below 85 | Tell a session; it lazy-loads or removes the mid unit |
| Play: subscription price "below minimum" for a country | Edit that row to the minimum Play shows; keep USD base as is |
| A routine opened a PR you do not want | Say "hold" or close the PR; nothing is live until merged |
| You lost the "femio growth" page | GA4 id: analytics.google.com → Admin → Data streams; GTM id: tagmanager.google.com top bar; Pixel: Events Manager; AdSense: Account → Settings |
