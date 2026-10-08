# Owner guide, A to Z: the steps only you can do, click by click

Written 2026-10-07 for someone who is not a developer. Do the steps **in order**: each
one says how long it takes, exactly where to click, and what you should see when it
worked. If anything looks different from what is written here, stop and paste a
screenshot or the message into the chat. Nothing here can break the app if you stop
halfway.

Already done for you this session (nothing to do): the security upgrade, the fix for
the database overuse (articles now ship inside the website build, so they never touch the database), the new design, the Learn hub, **the beta invite code**
(`BLOOM-2026`, active from the next deploy), and **the pull request** (#22) with
everything in it.

---

## Step 1 · Choose: stay free (recommended for now) or upgrade to Pro

**What happened.** The free plan includes 5 GB of data transfer ("egress") a month. Your
dashboard shows **8.96 GB used with 0 monthly active users**: no people caused it. A bug
made the website download the whole article library from the database on every page view,
and search-engine bots view a lot of pages. On **6 October, 19:45 UTC** Supabase
restricted the project, and it now answers the app with "402". Articles still show, but
**nobody can sign up or sign in until the restriction lifts**.

**Used egress cannot be "freed" or refunded.** Supabase counts it until the billing month
ends. Pausing or deleting things does not undo it (Supabase's own billing FAQ says so).
There are two ways out:

| | Stay free (recommended now) | Upgrade to Pro |
|---|---|---|
| Cost | $0 | $25/month |
| When sign-in works again | Automatically, shortly after your billing month resets | About 5 minutes after upgrading |
| Fits you if | No real users yet, which is true today (0 MAU) | You want testers in this week |

**To stay free:** do nothing in Supabase. To see the reset date, go to
**https://supabase.com/dashboard** → click **"KM Org"** (top-left) → **Billing** →
**"Upcoming invoice"**. The restriction lifts shortly after that date.

**Why it will not happen again: this is fixed in #22.** The website now carries its
articles inside its own build, so a page view, a bot crawl or a sitemap read **touches the
database not at all**. After the merge the only Supabase traffic left is people's own
logins and logs: a few MB a month at this stage, far under 5 GB.

> ⚠️ Supabase gives **no second grace period**. If the quota is exceeded again, the project is
> restricted at once. That is why Step 3 (the merge) matters even if you stay free: it is
> what stops the leak.

**To upgrade instead:** Billing → **Change subscription plan** → **Pro** → confirm. Keep
**Spend cap ON** (the default) so you can never be charged above $25 by surprise.

---

## Step 2 · Run one SQL file in Supabase: ✅ done 2026-10-07 (verified)

This applies three database changes: it removes three empty, unused tables, applies the
security fixes Supabase's own checker asked for, and adds one column the upgraded CMS
needs. It is a single, all-or-nothing transaction and safe to run twice. It was tested on
a copy of your database's structure before being given to you.

1. Open the file on GitHub:
   **https://github.com/KhaledHassanein/Femio/blob/claude/epic-planck-5y8geb/docs/runbooks/sql/2026-10-07_apply_all.sql**
2. Click the **Raw** button (top-right of the file). Press **Ctrl+A** then **Ctrl+C** to copy it all.
3. Go to **https://supabase.com/dashboard** → open the **Femio** project.
4. In the left sidebar click **SQL Editor** (the icon looks like a terminal window `>_`).
5. Click **+ New query**. Click into the empty editor and press **Ctrl+V** to paste.
6. Click **Run** (bottom-right), or press **Ctrl+Enter**.
7. **It worked if** you see **"Success. No rows returned"**. Lines starting with "NOTICE" are
   fine. If Supabase asks *"This query contains destructive operations, run anyway?"*,
   choose **Run**. The destructive part is only the three empty tables, and the file
   checks they are empty first.
8. **If you see "0024 refused"**, nothing was changed. Copy the message to Claude.

---

## Step 3 · Merge the pull request: ✅ done 2026-10-07

Do this **after Step 2**. The upgraded CMS needs the column Step 2 adds. **Do it even if you stay on the free plan: this merge is what stops the leak.**

1. Open **https://github.com/KhaledHassanein/Femio/pull/22**.
2. Scroll to the bottom to see the checks. **"CI" will show a red ✗ while Supabase is
   restricted.** The tests that sign in to the real database cannot pass during the
   restriction. Every other test passes: the code was checked separately. **Merge anyway**:
   the merge is the fix. Once the restriction lifts, CI goes green on its own next run.
3. Click **Merge pull request** → **Confirm merge**.
4. Vercel publishes automatically in about 3–5 minutes. **It worked if**
   **https://femioapp.com/en** shows the new deep-plum design, and
   **https://femioapp.com/en/learn** shows rows with illustrated cards.
5. Then open **https://femio-cms.vercel.app/admin** and log in as usual. **It worked if** you
   can open any article. If login fails, tell Claude straight away. In Vercel you can also
   undo a deploy with one click: Vercel → **femio-cms** → **Deployments** → the previous one →
   **⋯** → **Instant Rollback**.

---

## Step 4 · Turn on leaked-password protection (1 min, only on Pro)

Supabase checks new passwords against known breached passwords. It is a Pro-plan
feature, so skip this step while you stay free and do it when you upgrade at launch.

1. Supabase → **Femio** project → left sidebar **Authentication**.
2. Open **Attack Protection**. In some layouts it is under **Sign In / Providers → Email**,
   in the "Password security" section.
3. Turn on **"Prevent use of leaked passwords"** → **Save**.

---

## Step 5 · Give Claude full read access to Vercel: ✅ done 2026-10-07

The Vercel connector works but cannot see logs, usage or settings for your team
("403 forbidden").

1. Go to **claude.ai** → your avatar (bottom-left) → **Settings** → **Connectors**.
2. Find **Vercel** → **Disconnect**, then **Connect** again.
3. On the Vercel authorisation page, **select the team "khaledhassaneins-projects"**. It may
   be a dropdown or a list of checkboxes. Choose **All projects** if asked → **Authorize**.

---

## Step 6 · The beta invite code: already done ✅

Claude set **`BLOOM-2026`** as the invite code on the live site. From the next deploy
(Step 3), anyone who signs up must enter it. Share it only with testers you choose. It is
not a password and not a security control; it only keeps "we are testing" true until the
legal work is done.

*To change it:* Vercel → **femio-web** → **Settings** → **Environment Variables** →
`NEXT_PUBLIC_BETA_INVITE_CODE` → **Edit** → save, then **Deployments** → latest →
**⋯** → **Redeploy**. *To open signup on launch day:* delete the variable and redeploy.

---

## Step 7 · Clean out old test accounts (optional, 10 seconds)

Your database holds **443 accounts, and 442 of them are anonymous test accounts** created
by automated tests and trial runs, all idle for over 30 days. 214 hold no data at all.
Type in the chat **"purge test accounts"** to delete the 214 empty ones, or **"purge all
test accounts"** for all 442. Nothing is deleted until you say so.

---

## Step 8 · Google Search Console (10 min, any time)

This tells Google your site exists and shows you what people search to find it.

1. Go to **https://search.google.com/search-console** → **Add property** → choose
   **Domain** → type `femioapp.com` → Continue.
2. Google shows a **TXT record** (a line starting `google-site-verification=`). Copy it.
3. Open the website where you bought **femioapp.com** (GoDaddy, Namecheap, Cloudflare, …) →
   **DNS settings** → **Add record** → Type **TXT**, Name/Host **@**, Value = the line you
   copied → Save.
4. Back in Search Console click **Verify**. DNS can take up to an hour; retry if needed.
5. Left menu **Sitemaps** → enter `sitemap.xml` → **Submit**.

---

## Step 9 · People and paperwork (start this week, runs in the background)

These are not clicks but they set the launch date:

- **First, decide D7** (`OWNER_ACTIONS.md` §0): keep health records on the phone for v1.
  If yes, the lawyer's job shrinks to four short questions
  (`docs/compliance/PRIVATE_LAUNCH_V1.md` §6). Egypt's rules are enforced from
  **31 October 2026**.
- **An Arabic-speaking medical reviewer**, or confirm you will review Arabic yourself.
  Nothing in Arabic is published without a named reviewer.
- **Google Play developer account** ($25, one-off) at play.google.com/console. A personal
  account must run a 14-day test with 12 testers before going public; an organisation
  account (needs a D-U-N-S number) skips that.

---

## When you are done

Type in the chat which steps you finished (for example *"1, 2, 3 done"*). Claude checks
each one from its side (logs, the live site, the database) and carries on.
