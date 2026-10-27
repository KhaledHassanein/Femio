# Owner actions: only what Khaled must do by hand

**Rewritten 2026-10-27 on the owner's direction:** *"I will be the only one in charge of everything
… I just need the website and apps really functional and up and running."*

The previous version (lawyer, DPO, Arabic reviewer, staging project, SMTP, Search Console and the
rest) is archived at `docs/archive/runbooks-2026-10/OWNER_ACTIONS_2026-10-07.md`, together with
the A-to-Z guide. Nothing there is required now.

## The rule for sessions

- **Khaled is the only person in every role:** owner, controller, clinical reviewer (English and
  Arabic), and approver of the legal texts.
- **Sessions do everything else.** They draft the legal pages, the store listing, the content
  and the code.
- **Every decision has a default.** A session proceeds on its recommended default and tells Khaled
  at the next checkpoint. It never waits on Khaled for something it can do itself.
- **Do not add a line to this file** unless only a human with Khaled's identity can do it.

## The list

| # | What | Why only you | Time |
|---|---|---|---|
| 1 | **Install each test APK on your phone** when a session sends one, and say what's wrong | Real phone, real use | 10 min each |
| 2 | **Create the Google Play Console account** ($25, one-off) | Google verifies your identity | 20 min |
| 3 | **Find 12 testers who keep the app installed for 14 days** | Google requires it of new personal developer accounts before an app can go public | Messages to friends and family |
| 4 | **Say "publish"** on the legal pages and articles you're happy with | You are the named reviewer | When you want |

## Moved, not dropped

- **Lawyer, DPO, DPIA sign-off.** Replaced by legal pages and a short regulatory note that a session
  drafts from the published laws. You approve them as owner. They are not a lawyer's opinion. The
  private design (records never leave the phone) is what keeps the legal exposure low.
- **Arabic reviewer.** That's you. An Arabic article goes live when you say "publish".
- **Supabase Pro, custom email, web-push keys, invite code, staging project.** Not needed: there are
  no accounts in v1 (D7).
- **Search Console, illustration approval, CMS smoke test, forwarding alert emails.** Optional.
  Sessions handle them through the connectors, or they wait until after launch.

## Decisions already made (unchanged)

D1–D8 stand: the TTC → pregnancy wedge, Saudi + Egypt, Arabic first, the private Android app,
the website as its front door, Dusk Bloom. The full text is in the archived file, §0.
