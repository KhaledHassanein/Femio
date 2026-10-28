# Femio — current state (living document)

**Last updated: 2026-10-28.** Rewrite in place; never add a dated copy. Older versions are in git
history and `docs/archive/`.

## ▶ Resume prompt

> Read `CLAUDE.md`, then this file, then `docs/33_REBUILD_V3/PROGRESS.md`. The first open item
> there is the work. The plan is `docs/33_REBUILD_V3/00_PLAN.md`; the study it rests on is
> `docs/32_STUDY/00_SYNTHESIS.md` (do not re-study). Owner items go in
> `docs/runbooks/OWNER_ACTIONS.md`, never in chat. Build one item, gate it, photograph every UI
> change (390×844, light, dark, Arabic), commit with the reasoning in the message, and update
> `PROGRESS.md` in the same commit. Khaled is the only human in every role; proceed on the default.
>
> First, run `git branch --list "wip/*"`. A branch there means the last session stopped mid-item.

## Where things stand (2026-10-28)

- **Direction (ADR-072, 2026-10-27).** The private Android app (`apps/mobile`) is the product; the
  website (`apps/web`) is a static front door with calendar calculators and the guides. The web
  tracker, Supabase, Payload, Sentry, PostHog and the service worker are **deleted from the tree**;
  the website needs three public env vars and makes no network call of its own.
- **Merged to `main` and deployed 2026-10-28** (owner's go-ahead): `femioapp.com` serves the v3
  site (deployment `dpl_DXjSKZgmrjRp7wP4nNwpF2xJfqND`, commit `0965a65`). The `femio-cms` Vercel
  project now fails every build because `apps/cms` is gone; deleting it is owner action #4.
- **The main checkout at `E:\Femio` holds uncommitted edits** to the Android build script,
  manifest and `MainActivity.kt` that are not from this work. Look before touching them.
- **Done in v3 so far:** study + knowledge graph; constitution refresh; tracker removal; privacy
  tripwire; calendar calculators (R2.1); article template + legal pages + help-now numbers
  (R2.3, R2.4); Dusk icon set, OG images, Android adaptive icon and splash (R1.1–R1.3); Flutter
  refactor (R4.10); sealed record, backup, PIN lock, Settings, no-backup rules, release signing
  from a key outside git (R4.1–R4.3, R4.11 partly). Ledger: `docs/33_REBUILD_V3/PROGRESS.md`.
- **Health:** `pnpm gate` green (528 web tests), 70 e2e against the built site; `flutter analyze`
  clean, 75 Dart tests. Flutter 3.47.8 on this PC (upgraded 2026-10-27).
- **Supabase project** is still restricted (402) and still exists; the repo no longer references
  it. Pausing it and deleting the CMS Vercel project are owner actions.
- **Content:** 100 EN articles in `apps/web/src/content/snapshot` (derived from the CMS before
  retirement); 0 Arabic. The repo-native content pipeline (R3) is the next large piece.

## The working loop

1. **Take** the first open item in `docs/33_REBUILD_V3/PROGRESS.md`. Mark it `[~]`.
2. **Build** the whole item, including all four UI locales and its tests.
3. **Gate:** `pnpm gate` for the web; `cd apps/mobile && flutter analyze && flutter test` for the
   app. When a guard fails, fix the code, never the rule.
4. **Verify** the way the change can actually fail: a rendered page at 390×844 (the shoot scripts
   under `apps/web/scripts/`), `flutter test --update-goldens test/screens_test.dart` for app
   screens, the deployed site for anything that only breaks in production.
5. **Record** the line in `PROGRESS.md` and this file in place. An ADR only when the decision
   cost something or could be reversed by accident.
6. **Commit** with explicit paths (never `git add -A`).
7. **Next item.**

**Stopped mid-item?** Commit the dirty tree to `wip/<item-id>` with a `wip:` message saying what
is built, what is not, and the next action. Never commit ungated work to `main`.

## Environment traps that have each cost real time

- **Line endings are LF everywhere** (`.gitattributes`). If a generator guard fails with no
  visible diff, that is the first thing to check.
- **`pnpm install` can hang silently on this PC** (two instances were found stuck for an hour).
  Kill `pnpm.mjs` node processes and re-run with `--reporter=append-only`.
- **Never run `pnpm build` while a server is on :3000**; they share `apps/web/.next`. Check the
  port first (`netstat -ano | grep :3000`). Playwright under `CI=1` starts its own `next start`
  and fails if the port is taken; without `CI` it reuses what is there.
- **A full-page screenshot places `position: fixed` elements at the initial viewport origin**, so
  the crisis lifebuoy appears to overlap mid-page content. Artifact, not defect.
- **Arabic number ranges reverse under bidi** ("20 – 15"): wrap the dash in left-to-right marks
  (`use-calculator-format.ts`). Any new "a – b" string with digits needs the same.
- **next-intl serves Arabic as `ar-u-nu-latn`** (Western digits). Compare the language part, never
  the whole locale string, when branching on Arabic.
- **A Tailwind utility with no theme entry emits nothing**, silently (`border-divider` did). Check
  the preset map before anything else.
- **The i18n catalogs are JSON parsed by every guard**; re-serialising with 2-space indent is
  safe, but `apps/mobile/lib/l10n/*.arb` must keep `@key` metadata beside placeholder strings.
- **Bash heredocs with nested quotes fail on this machine.** Write a script file and run it.
- **flutter_secure_storage 11 and file_picker 13 changed their APIs** (no
  `encryptedSharedPreferences`; static `FilePicker.pickFiles`/`saveFile`; `readAsBytes()`). Read
  the pub cache at `E:\pub_cache\hosted\pub.dev\<pkg>` rather than memory.
- **A medical constant in a client component fails `native-readiness-lint`**, even a trimester
  boundary. Constants live in `lib/calculators` and are imported.
- **The screens golden test is slow** (fonts, 50+ captures): run it in the background with a
  long timeout; it writes `apps/mobile/test/screenshots/` (ignored).

## Verification honesty

Guards have caught real errors in this project's own work, repeatedly, including in this rebuild
(the native-readiness guard on the term bar; the vocabulary guard on a catalog edit). **Watch a new
guard fail before trusting it.** When a guard fails, fix the code; do not narrow the rule. Say
whether a number comes from a synthetic fixture or from real use.
