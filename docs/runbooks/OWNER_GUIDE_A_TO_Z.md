# Owner guide, A to Z: the steps only you can do, click by click

Written 2026-10-07 for someone who is not a developer. Do the steps **in order**: each
one says how long it takes, exactly where to click, and what you should see when it
worked. If anything looks different from what is written here, stop and paste a
screenshot or the message into the chat. Nothing here can break the app if you stop
halfway.

Already done for you this session (nothing to do): the security upgrade, the fix for
the database overuse, the new design, the Learn hub, **the beta invite code**
(`BLOOM-2026`, active from the next deploy), and **the pull request** (#22) with
everything in it.

---

## Step 1 · Get the app working again: upgrade Supabase to Pro (5 min, $25/month) 🔴 URGENT

**What is wrong.** Since **6 October, 19:45 UTC**, Supabase has answered every request
from the live app with "402 Payment Required". The free plan includes 5 GB of data
transfer a month, and a bug in the CMS (now fixed in #22) burned through it by
downloading the whole article library on every page view. So right now **nobody can
sign up, sign in or log anything** on femioapp.com. The articles still show, because
the CMS talks to the database another way. These are the usage-alert emails you were
getting.

**The fix is a plan upgrade.** The free plan only lifts the block when the next billing
month starts, which could be weeks away. Pro was already planned for launch (backups,
no pausing), so this only brings it forward.

1. Go to **https://supabase.com/dashboard** and sign in.
2. Top-left, click your **organization name** (the one that contains the "Femio" project).
3. In the left menu click **Billing** (in some layouts it sits under **Organization settings**).
4. Click **Change subscription plan**, then choose **Pro**, then confirm with your card.
5. On the same page, make sure **Spend cap** is **ON**. That is the default. It means you can
   never be charged more than the $25 plan price by surprise.
6. Wait about 5 minutes, then open **https://femioapp.com/en/welcome**, choose any option
   and press Continue through to the end. **It worked if you land in the app.** If you are
   still sent back to the welcome screen after 15 minutes, tell Claude: it can read the logs.

> Prefer not to pay yet? The block lifts on its own when your next Supabase billing month
> starts (the date is on the **Usage** page). Until then the app cannot sign anyone in.

---

## Step 2 · Run one SQL file in Supabase (3 min)

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

## Step 3 · Merge the pull request so the new version goes live (3 min)

Do this **after Step 2**. The upgraded CMS needs the column Step 2 adds.

1. Open **https://github.com/KhaledHassanein/Femio/pull/22**.
2. Scroll to the bottom. You will see the checks. **If "CI" shows a red ✗**: that was caused
   by the Supabase block from Step 1. After Step 1, click **Details** next to the red CI
   check → **Re-run all jobs** (top-right), and wait about 12 minutes for it to turn green ✓.
3. Click **Merge pull request** → **Confirm merge**.
4. Vercel publishes automatically in about 3–5 minutes. **It worked if**
   **https://femioapp.com/en** shows the new deep-plum design, and
   **https://femioapp.com/en/learn** shows rows with illustrated cards.
5. Then open **https://femio-cms.vercel.app/admin** and log in as usual. **It worked if** you
   can open any article. If login fails, tell Claude straight away. In Vercel you can also
   undo a deploy with one click: Vercel → **femio-cms** → **Deployments** → the previous one →
   **⋯** → **Instant Rollback**.

---

## Step 4 · Turn on leaked-password protection (1 min)

Supabase checks new passwords against known breached passwords. It is a Pro feature, so
do it after Step 1.

1. Supabase → **Femio** project → left sidebar **Authentication**.
2. Open **Attack Protection**. In some layouts it is under **Sign In / Providers → Email**,
   in the "Password security" section.
3. Turn on **"Prevent use of leaked passwords"** → **Save**.

---

## Step 5 · Give Claude full read access to Vercel (2 min)

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

- **A privacy lawyer** (MENA + EU) with three questions: does Egypt's data-protection
  licence apply to Femio, does Saudi law allow EU hosting, and finalise the privacy policy
  and terms. Egypt's rules are enforced from **31 October 2026**.
- **An Arabic-speaking medical reviewer**, or confirm you will review Arabic yourself.
  Nothing in Arabic is published without a named reviewer.
- **Google Play developer account** ($25, one-off) at play.google.com/console. A personal
  account must run a 14-day test with 12 testers before going public; an organisation
  account (needs a D-U-N-S number) skips that.

---

## When you are done

Type in the chat which steps you finished (for example *"1, 2, 3 done"*). Claude checks
each one from its side (logs, the live site, the database) and carries on.
