#!/usr/bin/env node
/**
 * Onboard a throwaway anonymous user, seed her some cycles, and screenshot the
 * app at 390×844 — light, dark and Arabic.
 *
 * CLAUDE.md says a screenshot is the test, not a nice-to-have, and `docs/26`
 * happened because nobody had one. But the dashboard only shows most of itself
 * once there is data to show, so "run it and look" needs a user with a history,
 * and making one by hand through the tracker means back-dating three periods
 * through a date strip that only reaches back fourteen days.
 *
 * This does it in about twenty seconds instead. It is the difference between
 * verifying the empty state — which is all the audit's first pass could reach —
 * and verifying the product.
 *
 * ## Why the session is read out of a cookie
 *
 * `@supabase/ssr` keeps the session in a cookie, not `localStorage`, and chunks it
 * across `…auth-token.0`, `…auth-token.1` when it outgrows the 4KB cookie limit.
 * So the value is reassembled in name order and, since supabase-js v2.x, un-prefixed
 * from `base64-`. Getting this wrong fails as "no auth token", which reads like a
 * broken login rather than a wrong storage assumption — it cost a debugging pass.
 *
 * ## Why rows are inserted over the REST API rather than seeded in SQL
 *
 * Going through PostgREST with her own JWT means **RLS is exercised**, not
 * bypassed. The first attempt omitted `profile_id` and was correctly rejected with
 * 42501, which is the policy doing its job. A service-role key would have written
 * the rows and told us nothing; it is deliberately not used here and must not be.
 *
 * Usage:
 *   node scripts/dev/seed-and-shoot.mjs [--out DIR] [--stage 1] [--offsets 16,44,72]
 *                                        [--route dashboard] [--flags experience.v2.log]
 *
 * `--flags` seeds `femio.flags.v1` — the client's *cached* flag source — so a
 * screen behind a flag that is off in the database can still be rendered and
 * looked at. This is the only way to see one before it ships, and this project
 * has three times learned that a green gate is not a rendered screen.
 *
 * Requires the dev server on :3000 and apps/web/.env.local.
 */
import { chromium } from "../../apps/web/node_modules/@playwright/test/index.mjs";
import { readFileSync, mkdirSync } from "node:fs";
import { join } from "node:path";

const args = Object.fromEntries(
  process.argv.slice(2).reduce((acc, a, i, arr) => {
    if (a.startsWith("--")) acc.push([a.slice(2), arr[i + 1]]);
    return acc;
  }, []),
);

const OUT = args.out ?? "screenshots";
const STAGE = Number(args.stage ?? 1); // index into the life-stage radio group
const OFFSETS = (args.offsets ?? "16,44,72").split(",").map(Number);
const ROUTE = args.route ?? "dashboard";
const FLAGS = (args.flags ?? "").split(",").map((f) => f.trim()).filter(Boolean);
const BASE = "http://localhost:3000";

/**
 * A plausible age for each life stage, by radio index: teen, cycle, TTC,
 * pregnant, postpartum, menopause. A contradiction here does not error — it
 * quietly resolves her to a different persona than the one being measured.
 */
const AGE_BAND_FOR_STAGE = [/^13–15$/, /^25–34$/, /^25–34$/, /^25–34$/, /^25–34$/, /^45–54$/];

mkdirSync(OUT, { recursive: true });

const env = Object.fromEntries(
  readFileSync(join("apps", "web", ".env.local"), "utf8")
    .split(/\r?\n/)
    .filter((l) => l.includes("=") && !l.trim().startsWith("#"))
    .map((l) => {
      const i = l.indexOf("=");
      return [l.slice(0, i).trim(), l.slice(i + 1).trim()];
    }),
);

const SB = env.NEXT_PUBLIC_SUPABASE_URL;
const KEY = env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
if (!SB || !KEY) {
  console.error("apps/web/.env.local needs NEXT_PUBLIC_SUPABASE_URL and _PUBLISHABLE_KEY");
  process.exit(1);
}

/** The wizard's own button labels, straight from the catalog it renders from. */
function labelsFor(locale) {
  const catalog = JSON.parse(
    readFileSync(join("apps", "web", "messages", `${locale}.json`), "utf8"),
  );
  return { next: catalog.onboarding.nav.next, start: catalog.onboarding.confirm.start };
}

async function onboard(page, locale) {
  await page.goto(`${BASE}/${locale}/welcome`, { waitUntil: "networkidle", timeout: 180_000 });
  await page.getByRole("radio").nth(STAGE).click();

  // An age band **coherent with the life stage**, answered rather than skipped.
  //
  // Two things depend on this and both bite silently. `isMinor(null)` is true, so
  // a skipped age changes what the rest of the app will allow (R3.0.8). And the
  // resolver weighs stage against age: answering "I'm a teenager" and then 25–34
  // is a contradiction, and it produced a **false audit finding** — teen measured
  // at 844px and six nodes, reported as the emptiest screen in the app, when a
  // teenager with a teen age band gets 1501px and thirty-five. That is the third
  // measurement artifact in this workstream (see §5 and the checkpoint-1
  // correction), so the coherence lives in the tool rather than in whoever
  // remembers to pass `--band`.
  const band = page.getByRole("button", { name: AGE_BAND_FOR_STAGE[STAGE] ?? /^25–34$/ });
  if (await band.count()) await band.first().click();

  // Labels are read from the locale's own catalog rather than guessed. Hardcoding
  // /continue|متابعة/ meant the Arabic run failed on a regex nobody could verify in
  // a console that mangles the script, and a screenshot tool that cannot reach the
  // Arabic build is useless for the locale hardest to eyeball by hand.
  //
  // A positional selector (`.app-bottom-bar button` last) was tried instead and was
  // worse — it silently matched a disabled Continue and hung all three runs. The
  // catalog is the one source that is correct by construction: it is the same file
  // the button renders from.
  const { next, start } = labelsFor(locale);
  for (let i = 0; i < 6; i += 1) {
    const btn = page.getByRole("button", { name: next, exact: true });
    if ((await btn.count()) === 0) break;
    await btn.first().click();
    await page.waitForTimeout(900);
  }
  await page.getByRole("button", { name: start, exact: true }).click();
  await page.waitForURL(/dashboard/, { timeout: 90_000 });
  await page.waitForTimeout(1500);
}

async function sessionJwt(context) {
  const cookies = (await context.cookies())
    .filter((c) => /auth-token(\.\d+)?$/.test(c.name))
    .sort((a, b) => a.name.localeCompare(b.name));
  if (cookies.length === 0) return null;
  let raw = cookies.map((c) => c.value).join("");
  if (raw.startsWith("base64-")) raw = Buffer.from(raw.slice(7), "base64").toString("utf8");
  try {
    return JSON.parse(raw).access_token;
  } catch {
    return null;
  }
}

async function seedCycles(page, jwt) {
  const uid = JSON.parse(Buffer.from(jwt.split(".")[1], "base64").toString("utf8")).sub;
  const rows = OFFSETS.map((back) => {
    const d = new Date();
    d.setDate(d.getDate() - back);
    return { profile_id: uid, period_start: d.toISOString().slice(0, 10), flow: "medium" };
  });
  return page.evaluate(
    async ({ sb, key, jwt: token, rows: body }) => {
      const res = await fetch(`${sb}/rest/v1/cycles`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
          apikey: key,
          Prefer: "return=minimal",
        },
        body: JSON.stringify(body),
      });
      return `${res.status} ${(await res.text()).slice(0, 120)}`;
    },
    { sb: SB, key: KEY, jwt, rows },
  );
}

const browser = await chromium.launch();
const runs = [
  { name: "light", locale: "en", colorScheme: "light" },
  { name: "dark", locale: "en", colorScheme: "dark" },
  { name: "ar", locale: "ar", colorScheme: "light" },
];

for (const run of runs) {
  const context = await browser.newContext({
    viewport: { width: 390, height: 844 },
    deviceScaleFactor: 2,
    colorScheme: run.colorScheme,
  });
  const page = await context.newPage();
  const consoleErrors = [];
  page.on("console", (m) => m.type() === "error" && consoleErrors.push(m.text().slice(0, 120)));

  try {
    await onboard(page, run.locale);
    const jwt = await sessionJwt(context);
    if (!jwt) throw new Error("no session cookie — has @supabase/ssr changed its storage?");
    const seeded = await seedCycles(page, jwt);
    if (!seeded.startsWith("201")) throw new Error(`seed failed: ${seeded}`);

    if (FLAGS.length > 0) {
      await page.evaluate((keys) => {
        const flags = {};
        for (const k of keys) flags[k] = true;
        window.localStorage.setItem("femio.flags.v1", JSON.stringify(flags));
      }, FLAGS);
    }

    await page.goto(`${BASE}/${run.locale}/${ROUTE}`, { waitUntil: "networkidle" });
    await page.waitForTimeout(2500);
    const height = await page.evaluate(() => document.body.scrollHeight);
    await page.screenshot({ path: join(OUT, `${ROUTE}-${run.name}.png`), fullPage: true });
    // A second shot, viewport-sized and scrolled to the end. `fullPage` expands the
    // viewport, which moves `fixed` elements to the page origin and can leave a
    // `sticky bottom-0` bar somewhere no eye is looking — so a bottom-anchored
    // control is invisible in exactly the screenshot taken to check it. This is the
    // frame that shows the save bar, the nav and the crisis pill where a phone puts
    // them.
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
    await page.waitForTimeout(400);
    await page.screenshot({ path: join(OUT, `${ROUTE}-${run.name}-bottom.png`) });

    console.log(
      `${run.name.padEnd(6)} ${ROUTE.padEnd(9)} ${String(height).padStart(5)}px  console-errors=${consoleErrors.length}`,
    );
    consoleErrors.slice(0, 3).forEach((e) => console.log(`   ! ${e}`));
  } catch (cause) {
    console.log(`${run.name.padEnd(6)} FAILED: ${String(cause).slice(0, 160)}`);
  }
  await context.close();
}

await browser.close();
